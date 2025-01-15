import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AlarmBoxWidget extends StatefulWidget {
  final String rawTime; // 예: '15:15' 형식의 원본 시간
  final String location; // 예: '반지하 돈부리'
  final String title; // 예: '저녁 약속'
  final VoidCallback onDelete; // 삭제 콜백

  const AlarmBoxWidget({
    super.key,
    required this.rawTime,
    required this.location,
    required this.title,
    required this.onDelete,
  });

  @override
  State<AlarmBoxWidget> createState() => _AlarmBoxWidgetState();
}

class _AlarmBoxWidgetState extends State<AlarmBoxWidget> {
  bool isChecked = true;

  String getFormattedTime(String rawTime) {
    // "오전 3:15" 또는 "오후 6:00"을 24시간 형식으로 변환
    final isAfternoon = rawTime.contains('오후');
    final timeParts = rawTime.replaceAll(RegExp(r'[^\d:]'), '').split(':');
    int hour = int.parse(timeParts[0]);
    String minute = timeParts[1];

    if (isAfternoon && hour != 12) {
      hour += 12; // 오후일 경우 12시간 추가
    } else if (!isAfternoon && hour == 12) {
      hour = 0; // 오전 12시는 0시로 변경
    }

    // 24시간 형식을 12시간 형식으로 변환
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12 == 0 ? 12 : hour % 12; // 0은 12로 변환
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = getFormattedTime(widget.rawTime);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Slidable(
        key: const ValueKey('AlarmBox'),
        direction: Axis.horizontal,
        endActionPane: ActionPane(
          extentRatio: 75 / 343,
          motion: const DrawerMotion(),
          children: [
            CustomSlidableAction(
              onPressed: (context) {
                widget.onDelete();
              },
              backgroundColor: isChecked ? const Color(0xFF5EB6FF) : const Color(0xffA9A9A9),
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/images/bxs_trash.svg',
                color: Colors.white,
              ),
            ),
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
                    color: isChecked ? Colors.white : const Color(0xffEBEBEB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                // 시각
                // 시각 (시간 / AM, PM)
                Positioned(
                  left: 14,
                  top: 9,
                  child: Text(
                    formattedTime.split(' ')[0], // 시간 부분 (예: "08:00")
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
                  left: 105, // 위치 조정
                  top: 24, // 기존 디자인에 맞춘 위치
                  child: Text(
                    formattedTime.split(' ')[1], // AM/PM 부분 (예: "PM")
                    style: TextStyle(
                      color: (isChecked == true)
                          ? const Color(0xFF5EB6FF)
                          : const Color(0xffA9A9A9),
                      fontSize: 16, // 작은 폰트 크기
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // 장소 및 제목
                Positioned(
                  left: 13.5,
                  top: 47,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFC2C2C2),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.location,
                        style: const TextStyle(
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
                      Text(
                        widget.title,
                        style: const TextStyle(
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
