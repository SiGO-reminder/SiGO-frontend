import 'package:flutter/material.dart';
import 'package:projects/widgets/button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void addSomething() {
    print('Adding!!!');
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffeeeeee),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('2024/12/05'),
        ),
        body: const Center(
          child: Text('Body'),
        ),
        floatingActionButton: const Button(
          addPressed: MyApp.addSomething,
        ), // 버튼을 오른쪽 하단에 배치
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endFloat, // 위치 지정
      ),
    );
  }
}
