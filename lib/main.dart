import 'package:flutter/material.dart';
import 'package:projects/screen/Homescreen.dart'; // 분리한 홈 화면 import
import 'package:workmanager/workmanager.dart';
import 'package:projects/utils/work_manager.dart';
import 'package:projects/utils/DataStorage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 기존 WorkManager 작업 삭제 (앱 재시작 시 중복 실행 방지)
  await clearExistingWorkManagerTasks();

  // ✅ WorkManager 초기화 (한 번만 실행)
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  // 다른 화면에서도 호출할 수 있도록
  static void addSomething() {
    print('Adding!!!'); // HomeScreen '+'버튼 함수
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      requestLocationPermission(); // 🔄 앱 실행 시 위치 권한 요청
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffF4F5F7),
        fontFamily: 'Inter',
      ),
      home: const HomeScreen(),
    );
  }
}
