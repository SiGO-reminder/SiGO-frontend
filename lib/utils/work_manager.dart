import 'dart:convert';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:projects/screen/AlarmSoundScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projects/utils/DataStorage.dart';
import 'dart:convert';

Future<void> clearExistingWorkManagerTasks() async {
  print("🛑 기존 WorkManager 작업 삭제 중...");
  await Workmanager().cancelAll();
  print("✅ 모든 WorkManager 작업 삭제 완료.");
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final response = await DataStorage.sendApiRequest(
        startX: inputData?['start_x'],
        startY: inputData?['start_y'],
        endX: inputData?['end_x'],
        endY: inputData?['end_y'],
        alarmTime: inputData?['alarm_time'],
        preparationTime: inputData?['preparation_time'],
        transport: inputData?['transport'],
      );

      if (response.statusCode == 200) {
        print("✅ OK 신호 받음, WorkManager 중지 및 알람 실행");
        Workmanager().cancelByUniqueName(task);
        triggerAlarm();
      } else if (response.statusCode == 202) {
        print("⚠️ 5분 후 다시 실행");

        Workmanager().cancelByUniqueName(task);

        await Future.delayed(const Duration(seconds: 2));

        Workmanager().registerOneOffTask(
          task,
          "check_alarm",
          initialDelay: const Duration(minutes: 5),
          inputData: inputData!,
          existingWorkPolicy: ExistingWorkPolicy.replace,
        );
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
    }
    return Future.value(true);
  });
}

void startForegroundService() {
  FlutterForegroundTask.startService(
    notificationTitle: '알람 대기 중',
    notificationText: '알람이 2시간 30분 후에 울릴 예정입니다.',
    callback: () async {
      print("🔔 Foreground Service 실행 중");
    },
  );
}

void stopForegroundService() {
  FlutterForegroundTask.stopService();
}

void triggerAlarm() {
  print("🔔 알람이 울리고 있습니다!");
  runApp(MaterialApp(
    home: AlarmsoundScreen(),
  ));
}
