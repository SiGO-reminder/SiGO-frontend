import 'dart:convert';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // 현재 위치 가져오기
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // ✅ API 요청 보내기 (교통수단 반영)
      final response = await sendApiRequest(
        startX: position.longitude,
        startY: position.latitude,
        endX: inputData?['end_x'],
        endY: inputData?['end_y'],
        time: inputData?['time'],
        transport: inputData?['transport'], // 🛠 교통수단 추가
      );

      if (response == "OK") {
        print("✅ OK 신호 받음, WorkManager 중지");
        Workmanager().cancelByUniqueName("backgroundApiCheck");
      } else {
        print("⚠️ 5분 후 재시도");
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
    }
    return Future.value(true);
  });
}

Future<String> sendApiRequest({
  required double startX,
  required double startY,
  required String? endX,
  required String? endY,
  required String? time,
  required String? transport, // 🛠 추가
}) async {
  // ✅ 교통수단 URL 매핑
  String transportType = "driving"; // 기본값
  if (transport == "버스") {
    transportType = "transit";
  } else if (transport == "도보") {
    transportType = "walking";
  }

  final url = Uri.parse("http://10.0.2.2:8080/api/v0/travel-time?transport=$transportType");

  final body = jsonEncode({
    "start_x": startX.toString(),
    "start_y": startY.toString(),
    "end_x": endX,
    "end_y": endY,
    "time": time,
  });

  try {
    final response = await http.post(
      url,
      body: body,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print("API 요청 실패: ${response.statusCode}");
      return "ERROR";
    }
  } catch (e) {
    print("API 요청 오류: $e");
    return "ERROR";
  }
}
