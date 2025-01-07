import 'package:flutter/material.dart';
import 'package:projects/widgets/newAlarm/InputTitleWidget.dart';
import 'package:projects/widgets/newAlarm/DatePickerWidget.dart';
import 'package:projects/widgets/newAlarm/TimePickerWidget.dart';
import 'package:projects/widgets/newAlarm/LocationInputWidget.dart';
import 'package:projects/widgets/newAlarm/TransportSelectorWidget.dart';
import 'package:projects/widgets/newAlarm/ConfirmButtonWidget.dart';
import 'package:projects/utils/DataStorage.dart'; // 데이터 저장 추가

class NewAlarmScreen extends StatefulWidget {
  const NewAlarmScreen({super.key});

  @override
  State<NewAlarmScreen> createState() => _NewAlarmScreenState();
}

class _NewAlarmScreenState extends State<NewAlarmScreen> {
  final TextEditingController titleController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? location;
  String? transport;

  // 저장 기능
  void onConfirm() async {
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

    // 데이터 저장
    await DataStorage.saveAlarm(
      title: titleController.text,
      date: selectedDate.toString(),
      time: selectedTime!.format(context),
      location: location!,
      transport: transport!,
    );

    // 저장 완료 메시지
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('알람이 저장되었습니다!')),
    );

    Navigator.pop(context); // 화면 종료
  }

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
            InputTitleWidget(
              controller: titleController,
              label: '일정을 입력하세요.',
            ),
            const SizedBox(height: 16),
            DatePickerWidget(
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 16),
            TimePickerWidget(
              onTimeSelected: (time) {
                setState(() {
                  selectedTime = time;
                });
              },
            ),
            const SizedBox(height: 16),
            LocationInputWidget(
              onLocationSelected: (loc) {
                setState(() {
                  location = loc;
                });
              },
            ),
            const SizedBox(height: 16),
            TransportSelectorWidget(
              onTransportSelected: (trans) {
                setState(() {
                  transport = trans;
                });
              },
            ),
            const SizedBox(height: 32),
            ConfirmButtonWidget(
              onPressed: onConfirm,
            ),
          ],
        ),
      ),
    );
  }
}