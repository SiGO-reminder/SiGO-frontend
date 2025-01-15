import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
    bool isOn = true,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> alarmData = {
      "title": title,
      "date": date,
      "time": time,
      "location": location,
      "transport": transport,
      "x": x,
      "y": y,
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
      Map<String, dynamic> decodedAlarm = jsonDecode(alarm);
      return {
        "time": decodedAlarm["time"] ?? "00:00",
        "location": decodedAlarm["location"] ?? "Unknown Location",
        "title": decodedAlarm["title"] ?? "No Title",
        "isOn": decodedAlarm["isOn"] ?? true,
      };
    }).toList();
  }

  // **3. 알람 상태 업데이트**
  static Future<void> updateAlarmStatus(int index, bool isOn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList(alarmKey) ?? [];
    if (index < alarms.length) {
      Map<String, dynamic> alarm = jsonDecode(alarms[index]);
      alarm['isOn'] = isOn;
      alarms[index] = jsonEncode(alarm);
      await prefs.setStringList(alarmKey, alarms);
    }
  }

  // **4. 알람 삭제**
  static Future<void> deleteAlarm(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList(alarmKey) ?? [];
    if (index < alarms.length) {
      alarms.removeAt(index);
      await prefs.setStringList(alarmKey, alarms);
    }
  }

  // **5. 모든 알람 삭제**
  static Future<void> clearAlarms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(alarmKey);
  }
}
