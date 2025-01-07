import 'package:shared_preferences/shared_preferences.dart';

class DataStorage {
  // 데이터 저장
  static Future<void> saveAlarm({
    required String title,
    required String date,
    required String time,
    required String location,
    required String transport,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 저장할 데이터 객체
    Map<String, dynamic> alarmData = {
      "title": title,
      "date": date,
      "time": time,
      "location": location,
      "transport": transport,
    };

    // JSON 형식으로 변환 후 저장
    List<String> alarms = prefs.getStringList('alarms') ?? [];
    alarms.add(alarmData.toString()); // JSON을 문자열로 저장
    await prefs.setStringList('alarms', alarms);
  }

  // 저장된 데이터 불러오기
  static Future<List<Map<String, dynamic>>> loadAlarms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarms = prefs.getStringList('alarms') ?? [];
    return alarms.map((e) {
      final Map<String, dynamic> alarm = {};
      List<String> fields = e.replaceAll(RegExp(r'[{}]'), '').split(', ');
      for (var field in fields) {
        List<String> keyValue = field.split(': ');
        alarm[keyValue[0]] = keyValue[1];
      }
      return alarm;
    }).toList();
  }

  // 데이터 삭제
  static Future<void> clearAlarms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('alarms');
  }
}