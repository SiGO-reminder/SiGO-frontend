import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
// pubspec.yaml에 flutter_slidable 추가 후 사용
import 'package:flutter_slidable/flutter_slidable.dart';

class AlarmBox extends StatefulWidget {
  const AlarmBox({super.key});

  @override
  State<AlarmBox> createState() => _AlarmBoxState();
}

class _AlarmBoxState extends State<AlarmBox> {
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0), // 위로 16px 마진
      child: Slidable(
        // 슬라이드 구분 키
        key: const ValueKey('AlarmBox'),
        // 가로 방향 슬라이드
        direction: Axis.horizontal,
        // 오른쪽(END)에 액션 패널을 배치해서 '왼쪽으로' 스와이프
        endActionPane: ActionPane(
          // 슬라이드 폭을 전체의 (50/343)만큼만 보여주도록 설정
          extentRatio: 75 / 343,
          motion: const DrawerMotion(),
          children: [
            // 삭제 액션
            CustomSlidableAction(
              onPressed: (context) {
                debugPrint('삭제 버튼 클릭');
              },
              backgroundColor: (isChecked == true)
                  ? const Color(0xFF5EB6FF)
                  : const Color(0xffA9A9A9),
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: SvgPicture.asset(
                // Icons.abc_outlined,
                'assets/images/bxs_trash.svg',
                // 아이콘 크기 설정
                color: Colors.white,
              ),
            )
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            debugPrint('알림 박스 클릭');
          },
          child: SizedBox(
            width: double.infinity,
            height: 83,
            child: Stack(
              children: [
                // 알림 상자 배경
                Container(
                  width: double.infinity,
                  height: 83,
                  decoration: ShapeDecoration(
                    color: (isChecked == true)
                        ? Colors.white
                        : const Color(0xffEBEBEB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                // 시각 (08:00 / PM)
                Positioned(
                  left: 14,
                  top: 9,
                  child: Text(
                    '08:00',
                    style: TextStyle(
                      color: (isChecked == true)
                          ? const Color(0xFF5EB6FF)
                          : const Color(0xffA9A9A9),
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  left: 105,
                  top: 24,
                  child: Text(
                    'PM',
                    style: TextStyle(
                      color: (isChecked == true)
                          ? const Color(0xFF5EB6FF)
                          : const Color(0xffA9A9A9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // 텍스트: 반지하 돈부리 · 저녁 약속
                Positioned(
                  left: 13.5,
                  top: 47,
                  child: Row(
                    children: [
                      const Text(
                        '반지하 돈부리',
                        style: TextStyle(
                          color: Color(0xFFC2C2C2),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.80,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const ShapeDecoration(
                          color: Colors.black26,
                          shape: OvalBorder(),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '저녁 약속',
                        style: TextStyle(
                          color: Color(0xFFC2C2C2),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.80,
                        ),
                      ),
                    ],
                  ),
                ),
                // 스위치
                Positioned(
                  right: 16,
                  top: 25,
                  child: CupertinoSwitch(
                    value: isChecked,
                    activeColor: const Color(0xFF5FB7FF),
                    trackColor: const Color(0xFF757575),
                    onChanged: (bool value) {
                      setState(() => isChecked = value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
