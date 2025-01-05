import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AlarmBox extends StatefulWidget {
  const AlarmBox({super.key});

  @override
  State<AlarmBox> createState() => _AlarmBoxState();
}

class _AlarmBoxState extends State<AlarmBox> {
  bool isChecked = true; // 알람이 켜져있는지 꺼져있는지 확인

  void _handleTap() {
    // 버튼이 눌렸을 때의 동작
    print('AlarmBox tapped!');
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
            16, 16, 16, 0), // 스택으로 쌓았을때를 생각해서 bottom 마진 0
        width: double.infinity,
        height: 89,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: (isChecked)
              ? const Color(0x00ffffff)
              : const Color(0xffDEDEDE), // 배경색을 투명하게 설정
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: _handleTap, // 터치 이벤트 처리
            borderRadius: BorderRadius.circular(10), // InkWell의 모서리를 둥글게
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 7, 9, 8), // 피그마 기준 패딩
              child: Column(
                children: [
                  // 한 알림 상자에 container가 5개(왼3개, 우 2개) 색상변경으로 영역 확인 가능
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
                        children: [
                          const SizedBox(
                            // color: Colors.white,
                            width: 143,
                            height: 15,
                            child: Text(
                              " 2024/12/4",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff757575),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                // color: Colors.white,
                                width: 93,
                                height: 37,
                                child: Text(
                                  "08:00",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    color: (isChecked)
                                        ? const Color(0xff5FB7FF)
                                        : const Color(0xff000000),
                                  ),
                                ),
                              ),
                              SizedBox(
                                // color: Colors.white,
                                width: 50,
                                height: 37,
                                child: Text(
                                  "PM",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w400,
                                    color: (isChecked)
                                        ? const Color(0xff5FB7FF)
                                        : const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: SizedBox(
                          // color: Colors.white,
                          height: 52,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CupertinoSwitch(
                                  value: isChecked,
                                  activeColor: const Color(0xff5FB7FF),
                                  trackColor: const Color(0xff757575),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value ?? false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        // color: Colors.white,
                        width: 143,
                        height: 17,
                        child: Text(
                          " 저녁약속",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: (isChecked)
                                ? const Color(0xff9A9A9A)
                                : const Color(0xff757575),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          // color: Colors.white,
                          height: 17,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: Transform.translate(
                                  offset: const Offset(1, 2),
                                  child: const Icon(
                                    Icons.place,
                                    color: Color(0xff757575),
                                    size: 16,
                                  ),
                                ),
                              ),
                              Container(
                                child: const Text(
                                  "반지하 돈부리",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff757575),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
