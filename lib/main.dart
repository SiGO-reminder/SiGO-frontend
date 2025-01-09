import 'package:flutter/material.dart';
import 'package:projects/screen/Homescreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 분리한 홈 화면 import

void main() {
  //시작화면 구현하기 위해 추가
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  // 다른 화면에서도 호출할 수 있도록
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffF4F5F7),
        fontFamily: 'Pretendard',
      ),
      home: const HomeScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ], //홈화면 //홈화면
    );
  }
}
