import 'package:flutter/material.dart';
import 'package:projects/widgets/newAlarm/InputTitleWidget.dart';
import 'package:projects/widgets/newAlarm/DatePickerWidget.dart';
import 'package:projects/widgets/newAlarm/TimePickerWidget.dart';
import 'package:projects/widgets/newAlarm/TransportSelectorWidget.dart';
import 'package:projects/widgets/newAlarm/ConfirmButtonWidget.dart';
import 'package:projects/widgets/newAlarm/PrepareTime.dart';
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
  int preparationTime = 0; // 준비 시간 기본값

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
    bool isSaved = await DataStorage.saveAlarm(
      context: context, // 여기에 context 추가
      title: titleController.text,
      date: selectedDate!.toIso8601String(),
      time: selectedTime!.format(context),
      location: location!,
      transport: transport!,
      x: x!,
      y: y!,
      preparationTime: preparationTime,
    );

    if(isSaved){
      Navigator.pop(context);
    }// 화면 종료
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
                      selectedDate: selectedDate,
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
                      selectedTime: selectedTime,
                      onTimeSelected: (time) {
                        setState(
                              () {
                            selectedTime = time;
                          },
                        );
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
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const LocationSearchScreen()),
                        );
                        if (result != null) {
                          setState(() {
                            location = result['location'];
                            x = result['x'].toString(); // 경도를 문자열로 변환
                            y = result['y'].toString(); // 위도를 문자열로 변환
                          });
                        }
                      },
                      child: Material(
                        // Material로 감싸기
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 17, vertical: 16),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.place_outlined,
                                color: Color(0xff757575),
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                location ?? '장소',
                                style: TextStyle(
                                  color: location == null
                                      ? const Color(0xffD9D9D9)
                                      : Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  decorationColor: location == null
                                      ? const Color(0xffD9D9D9)
                                      : Colors.black,
                                  letterSpacing: -0.64,
                                ),
                              ),
                            ],
                          ),
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

                    // 준비 시간 선택
                    Padding(
                      padding: const EdgeInsets.fromLTRB(17, 2, 0, 0),
                      child: PreparationTime(
                        onPreparationTimeSelected: (int time) {
                          setState(() {
                            preparationTime = time; // 선택된 준비 시간 설정
                          });
                        },
                      ),
                    ),

                    // 확인 버튼
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: ConfirmButtonWidget(
                //확인차 날짜 조건만 넣음
                onPressed: (selectedDate != null) &&
                    (selectedTime != null) &&
                    (location != null) &&
                    (transport != null)
                    ? onConfirm
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
