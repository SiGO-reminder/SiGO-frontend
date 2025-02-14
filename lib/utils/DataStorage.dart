import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/material.dart';
import 'package:projects/screen/AlarmSoundScreen.dart';
import 'package:permission_handler/permission_handler.dart';



class DataStorage {
  static const String alarmKey = 'alarms';

  static String convertTransport(String transport) {
    switch (transport.trim()) {
      case '택시':
        return 'driving';
      case '버스':
        return 'transit';
      case '도보':
        return 'walking';
      default:
        return 'transit'; // 기본값 설정
    }
  }

  static Future<bool> saveAlarm({
    required BuildContext context,
    required String title,
    required String date,
    required String time,
    required String location,
    required String transport,
    required String x,
    required String y,
    required int preparationTime,
    bool isOn = true,
  }) async {
    try {
      final now = DateTime.now();
      final DateTime parsedDate = DateFormat('yyyy-MM-dd').parseStrict(date.split('T')[0]);

      DateTime parsedTime;
      if (RegExp(r'^[0-9]{1,2}:[0-9]{2} [APap][Mm]$').hasMatch(time)) {
        parsedTime = DateFormat('hh:mm a').parseStrict(time);
      } else if (RegExp(r'^[0-9]{1,2}:[0-9]{2}$').hasMatch(time)) {
        parsedTime = DateFormat('HH:mm').parseStrict(time);
      } else {
        throw FormatException("잘못된 시간 형식: $time");
      }

      final DateTime alarmDateTime = DateTime(parsedDate.year, parsedDate.month, parsedDate.day, parsedTime.hour, parsedTime.minute);
      final Duration difference = alarmDateTime.difference(now);

      String convertedTransport = convertTransport(transport);
      print("🚀 변환된 Transport: $convertedTransport");

      if (difference <= const Duration(hours: 2, minutes: 30)) {
        final Position position = await Geolocator.getCurrentPosition();

        final response = await sendApiRequest(
          startX: position.longitude.toString(),
          startY: position.latitude.toString(),
          endX: x,
          endY: y,
          alarmTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(alarmDateTime),
          preparationTime: preparationTime,
          transport: convertedTransport,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("지금 바로 출발하셔야 합니다!")),
          );
          return false;
        }

        if (response.statusCode == 202) {
          print("🔄 WorkManager OneOff 실행 (5분 간격)");

          // 기존 작업을 삭제 후 다시 등록 (중복 방지)
          Workmanager().cancelByUniqueName("check_alarm_${alarmDateTime.millisecondsSinceEpoch}");

          Workmanager().registerOneOffTask(
            "check_alarm_${alarmDateTime.millisecondsSinceEpoch}",
            "check_alarm",
            initialDelay: const Duration(minutes: 5),
            inputData: {
              "start_x": x,
              "start_y": y,
              "end_x": x,
              "end_y": y,
              "alarm_time": DateFormat('yyyy-MM-dd HH:mm:ss').format(alarmDateTime),
              "preparation_time": preparationTime,
              "transport": convertedTransport
            },
            existingWorkPolicy: ExistingWorkPolicy.replace,
          );
        }
      } else {
        final DateTime workManagerStartTime = alarmDateTime.subtract(const Duration(hours: 2, minutes: 30));
        print("⏳ WorkManager 예약됨: ${workManagerStartTime.toString()}");

        Workmanager().registerOneOffTask(
          "start_foreground_service_${alarmDateTime.millisecondsSinceEpoch}",
          "start_foreground_service",
          initialDelay: workManagerStartTime.difference(now),
          inputData: {
            "start_x": x,
            "start_y": y,
            "end_x": x,
            "end_y": y,
            "alarm_time": DateFormat('yyyy-MM-dd HH:mm:ss').format(alarmDateTime),
            "preparation_time": preparationTime,
            "transport": convertedTransport
          },
          existingWorkPolicy: ExistingWorkPolicy.replace,
        );
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String id = DateTime.now().millisecondsSinceEpoch.toString();

      Map<String, dynamic> alarmData = {
        "id": id,
        "title": title,
        "date": DateFormat('yyyy-MM-dd').format(parsedDate),
        "time": DateFormat('HH:mm').format(parsedTime),
        "location": location,
        "transport": convertedTransport,
        "x": x,
        "y": y,
        "preparationTime": preparationTime,
        "isOn": isOn,
      };

      List<String> alarms = prefs.getStringList(alarmKey) ?? [];
      alarms.add(jsonEncode(alarmData));
      await prefs.setStringList(alarmKey, alarms);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('알람이 저장되었습니다!')),
      );
      return true;
    } catch (e) {
      print("❌ 날짜 변환 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("알람 저장 중 오류 발생. 날짜 형식을 확인하세요. 에러: $e")),
      );
      return false;
    }
  }

  static void triggerAlarmScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AlarmsoundScreen()),
    );
  }

  static Future<http.Response> sendApiRequest({
    required String startX,
    required String startY,
    required String endX,
    required String endY,
    required String alarmTime,
    required int preparationTime,
    required String transport,
  }) async {
    final String convertedTransport = transport.trim();
    final url = Uri.parse("http://10.0.2.2:8080/api/v0/travel-time?transport=$convertedTransport");
    final body = jsonEncode({
      "start_x": startX,
      "start_y": startY,
      "end_x": endX,
      "end_y": endY,
      "alarm_time": alarmTime,
      "preparation_time": preparationTime,
    });

    print("📡 API 요청 URL: $url");
    print("📡 요청 본문: $body");

    try {
      final response = await http.post(
        url,
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      print("📡 응답 코드: ${response.statusCode}");
      print("📡 응답 본문: ${response.body}");

      if (response.statusCode != 200) {
        print("❌ API 요청 실패: ${response.statusCode} ${response.body}");
      }

      return response;
    } catch (e) {
      print("❌ API 요청 중 오류 발생: $e");
      return http.Response("API 요청 실패", 500);
    }
  }



  static Future<List<Map<String, dynamic>>> loadAlarms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList(alarmKey) ?? [];
    return alarms.map((alarm) => jsonDecode(alarm) as Map<String, dynamic>).toList();
  }

  static Future<void> updateAlarmStatus(String id, bool isOn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList(alarmKey) ?? [];
    for (int i = 0; i < alarms.length; i++) {
      Map<String, dynamic> alarm = jsonDecode(alarms[i]);
      if (alarm['id'] == id) {
        alarm['isOn'] = isOn;
        alarms[i] = jsonEncode(alarm);
        break;
      }
    }
    await prefs.setStringList(alarmKey, alarms);
  }

  static Future<void> deleteAlarm(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList(alarmKey) ?? [];
    alarms.removeWhere((alarm) => jsonDecode(alarm)['id'] == id);
    await prefs.setStringList(alarmKey, alarms);
  }

  static Future<void> clearAlarms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(alarmKey);
  }
}

Future<bool> requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      print("❌ 위치 권한이 거부되었습니다.");
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print("❌ 위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해주세요.");
    return false;
  }

  return true;
}




