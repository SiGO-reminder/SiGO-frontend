import 'package:flutter/material.dart';
import 'package:projects/widgets/newAlarm/InputTitleWidget.dart';
import 'package:projects/widgets/newAlarm/DatePickerWidget.dart';
import 'package:projects/widgets/newAlarm/TimePickerWidget.dart';
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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(91),
        child: Container(
          color: const Color(0xff5FB7FF),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 53,
              bottom: 9,
            ),
            child: Stack(
              alignment: Alignment.center, // 중앙 정렬
              children: [
                // 아이콘: 왼쪽에 고정
                Positioned(
                  left: 10,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 34,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                // 텍스트: 정가운데 배치
                const Text(
                  '새 일정 추가',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.32,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 15,
          top: 5,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 일정 입력
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: InputTitleWidget(
                        controller: titleController,
                        label: '일정을 입력하세요.',
                      ),
                    ),

                    const Divider(
                      thickness: 2,
                      color: Color(0xffE9E9E9),
                      endIndent: 0,
                    ),

                    // 날짜 선택
                    DatePickerWidget(
                      onDateSelected: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),

                    const Divider(
                      thickness: 2,
                      color: Color(0xffE9E9E9),
                      endIndent: 0,
                    ),

                    // 시간 선택
                    TimePickerWidget(
                      onTimeSelected: (time) {
                        setState(() {
                          selectedTime = time;
                        });
                      },
                    ),

                    const Divider(
                      thickness: 2,
                      color: Color(0xffE9E9E9),
                      endIndent: 0,
                    ),

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
                                  location =
                                      selectedLocation['location']; // 건물명
                                  x = selectedLocation['x']; // 경도
                                  y = selectedLocation['y']; // 위도
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.search,
                              color: Color(0xff757575),
                              size: 24,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              location ?? '장소',
                              style: TextStyle(
                                color: location == null
                                    ? const Color(0xffD9D9D9)
                                    : Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: const Color(0xffD9D9D9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Divider(
                      thickness: 2,
                      color: Color(0xffE9E9E9),
                      endIndent: 0,
                    ),

                    // 교통수단 선택
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TransportSelectorWidget(
                        onTransportSelected: (trans) {
                          setState(() {
                            transport = trans;
                          });
                        },
                      ),
                    ),

                    const Divider(
                      thickness: 2,
                      color: Color(0xffE9E9E9),
                      endIndent: 0,
                    ),

                    // 확인 버튼
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: ConfirmButtonWidget(
                onPressed: onConfirm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
