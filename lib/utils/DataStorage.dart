import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class DataStorage {
  static const String alarmKey = 'alarms';

  // **1. 알람 저장**
  static Future<void> saveAlarm({
    required String title,
    required String date,
    required String time,
    required String location,
    required String transport,
    required String x,
    required String y,
    int preparationTime = 0,
    bool isOn = true,

  }) async {
    print('Saved Alarm Data:');
    print('Title: $title');
    print('Date: $date');
    print('Time: $time');
    print('Location: $location');
    print('Transport: $transport');
    print('Longitude: $x');
    print('Latitude: $y');
    print('Preparation Time: $preparationTime');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String id = DateTime.now().millisecondsSinceEpoch.toString(); // 고유 ID 생성

    Map<String, dynamic> alarmData = {
      "id": id, // 고유 ID 추가
      "title": title,
      "date": DateFormat('yyyy-MM-dd').format(DateTime.parse(date)), // 날짜 형식 통일
      "time": time,
      "location": location,
      "transport": transport,
      "x": x,
      "y": y,
      'preparationTime': preparationTime, // 준비시간 저장
      "isOn": isOn,
    };

    List<String> alarms = prefs.getStringList(alarmKey) ?? [];
    alarms.add(jsonEncode(alarmData));
    await prefs.setStringList(alarmKey, alarms);
  }

  // **2. 알람 데이터 불러오기**
  static Future<List<Map<String, dynamic>>> loadAlarms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList(alarmKey) ?? [];
    return alarms.map((alarm) {
      return jsonDecode(alarm) as Map<String, dynamic>;
    }).toList();
  }

  // **3. 알람 상태 업데이트 (ID 기반)**
  static Future<void> updateAlarmStatus(String id, bool isOn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList(alarmKey) ?? [];
    for (int i = 0; i < alarms.length; i++) {
      Map<String, dynamic> alarm = jsonDecode(alarms[i]);
      if (alarm['id'] == id) {
        alarm['isOn'] = isOn; // 상태 업데이트
        alarms[i] = jsonEncode(alarm);
        break;
      }
    }
    await prefs.setStringList(alarmKey, alarms);
  }

  // **4. 알람 업데이트 (ID 기반)**
  static Future<void> updateAlarm(String id, Map<String, dynamic> updatedData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList(alarmKey) ?? [];
    for (int i = 0; i < alarms.length; i++) {
      Map<String, dynamic> alarm = jsonDecode(alarms[i]);
      if (alarm['id'] == id) {
        alarms[i] = jsonEncode({...alarm, ...updatedData}); // 데이터 병합 후 업데이트
        break;
      }
    }
    await prefs.setStringList(alarmKey, alarms);
  }

  // **5. 알람 삭제 (ID 기반)**
  static Future<void> deleteAlarm(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList(alarmKey) ?? [];
    alarms.removeWhere((alarm) {
      Map<String, dynamic> decodedAlarm = jsonDecode(alarm);
      return decodedAlarm['id'] == id;
    });
    await prefs.setStringList(alarmKey, alarms);
  }

  // **6. 모든 알람 삭제**
  static Future<void> clearAlarms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(alarmKey);
  }

  // **7. 기존 알람 데이터에 ID 추가 (초기화)**
  static Future<void> initializeAlarms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList(alarmKey) ?? [];
    bool needsUpdate = false;

    for (int i = 0; i < alarms.length; i++) {
      Map<String, dynamic> alarm = jsonDecode(alarms[i]);
      if (!alarm.containsKey('id')) {
        alarm['id'] = DateTime.now().millisecondsSinceEpoch.toString(); // ID 추가
        alarms[i] = jsonEncode(alarm);
        needsUpdate = true;
      }
    }

    if (needsUpdate) {
      await prefs.setStringList(alarmKey, alarms);
    }
  }
}
