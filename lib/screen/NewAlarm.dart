import 'package:flutter/material.dart';
import 'package:projects/widgets/newAlarm/InputTitleWidget.dart';
import 'package:projects/widgets/newAlarm/DatePickerWidget.dart';
import 'package:projects/widgets/newAlarm/TimePickerWidget.dart';
import 'package:projects/widgets/newAlarm/LocationInputWidget.dart';
import 'package:projects/widgets/newAlarm/TransportSelectorWidget.dart';
import 'package:projects/widgets/newAlarm/ConfirmButtonWidget.dart';
import 'package:projects/utils/DataStorage.dart';
import 'package:projects/screen/LocationSearchScreen.dart'; // 장소 검색 추가

class NewAlarmScreen extends StatefulWidget {
  const NewAlarmScreen({super.key});

  @override
  State<NewAlarmScreen> createState() => _NewAlarmScreenState();
}

class _NewAlarmScreenState extends State<NewAlarmScreen> {
  // 입력값 상태 관리
  final TextEditingController titleController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? location;
  String? transport;
  String? x; // 경도
  String? y; // 위도

  // 알람 저장 기능
  void onConfirm() async {
    // 입력값 검증
    if (titleController.text.isEmpty) {
      showErrorDialog('일정을 입력하세요.');
      return;
    }
    if (selectedDate == null) {
      showErrorDialog('날짜를 선택하세요.');
      return;
    }
    if (selectedTime == null) {
      showErrorDialog('시간을 선택하세요.');
      return;
    }
    if (location == null || location!.isEmpty) {
      showErrorDialog('장소를 입력하세요.');
      return;
    }
    if (transport == null) {
      showErrorDialog('교통수단을 선택하세요.');
      return;
    }
    if (x == null || y == null) {
      showErrorDialog('위치 정보를 확인하세요.');
      return;
    }

    // 데이터 저장
    await DataStorage.saveAlarm(
      title: titleController.text,
      date: selectedDate.toString(),
      time: selectedTime!.format(context),
      location: location!,
      transport: transport!,
      x: x!, // 경도 저장
      y: y!, // 위도 저장
    );

    // 저장 완료 메시지
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('알람이 저장되었습니다!')),
    );

    Navigator.pop(context); // 화면 종료
  }

  // 오류 메시지
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('입력 오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 일정 추가'),
        backgroundColor: const Color(0xff5FB7FF),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 일정 입력
            InputTitleWidget(
              controller: titleController,
              label: '일정을 입력하세요.',
            ),
            const SizedBox(height: 16),

            // 날짜 선택
            DatePickerWidget(
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 16),

            // 시간 선택
            TimePickerWidget(
              onTimeSelected: (time) {
                setState(() {
                  selectedTime = time;
                });
              },
            ),
            const SizedBox(height: 16),

            // 위치 입력 및 검색
            GestureDetector(
              onTap: () async {
                // 장소 검색 화면으로 이동
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationSearchScreen(
                      onLocationSelected: (selectedLocation) {
                        setState(() {
                          location = selectedLocation['location']; // 건물명
                          x = selectedLocation['x']; // 경도
                          y = selectedLocation['y']; // 위도
                        });
                      },
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      location ?? '장소를 입력하세요.',
                      style: TextStyle(
                        color: location == null ? Colors.grey : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(Icons.search, color: Colors.blue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 교통수단 선택
            TransportSelectorWidget(
              onTransportSelected: (trans) {
                setState(() {
                  transport = trans;
                });
              },
            ),
            const SizedBox(height: 32),

            // 확인 버튼
            ConfirmButtonWidget(
              onPressed: onConfirm,
            ),
          ],
        ),
      ),
    );
  }
}
