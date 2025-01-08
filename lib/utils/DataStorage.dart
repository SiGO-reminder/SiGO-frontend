import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DataStorage {
  // **1. 데이터 저장**
  static Future<void> saveAlarm({
    required String title,
    required String date,
    required String time,
    required String location,
    required String transport,
    required String x,
    required String y,
    bool isOn = true, // 기본값 true
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 저장할 데이터 객체
    Map<String, dynamic> alarmData = {
      "title": title,
      "date": date,
      "time": time,
      "location": location,
      "transport": transport,
      "x": x,
      "y": y,
      "isOn": isOn, // on/off 상태 추가
    };

    // 기존 저장된 데이터 불러오기
    List<String> alarms = prefs.getStringList('alarms') ?? [];
    alarms.add(jsonEncode(alarmData)); // JSON 문자열로 저장
    await prefs.setStringList('alarms', alarms);
  }

  // **2. 저장된 데이터 불러오기**
  static Future<List<Map<String, dynamic>>> loadAlarms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList('alarms') ?? [];

    return alarms.map((alarm) => jsonDecode(alarm) as Map<String, dynamic>).toList();
  }

  // **3. 알람 상태 업데이트 (ON/OFF)**
  static Future<void> updateAlarmStatus(int index, bool isOn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList('alarms') ?? [];

    if (index < alarms.length) {
      Map<String, dynamic> alarm = jsonDecode(alarms[index]);
      alarm['isOn'] = isOn; // 상태 업데이트
      alarms[index] = jsonEncode(alarm); // 수정된 데이터 저장
      await prefs.setStringList('alarms', alarms);
    }
  }

  // **4. 알람 수정 기능** (새로운 기능 추가)
  static Future<void> updateAlarm(int index, Map<String, dynamic> updatedData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList('alarms') ?? [];

    if (index < alarms.length) {
      alarms[index] = jsonEncode(updatedData); // 새로운 데이터로 업데이트
      await prefs.setStringList('alarms', alarms);
    }
  }

  // **5. 알람 삭제 기능** (새로운 기능 추가)
  static Future<void> deleteAlarm(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList('alarms') ?? [];

    if (index < alarms.length) {
      alarms.removeAt(index); // 해당 인덱스 삭제
      await prefs.setStringList('alarms', alarms);
    }
  }

  // **6. 모든 데이터 삭제**
  static Future<void> clearAlarms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('alarms');
  }
}
