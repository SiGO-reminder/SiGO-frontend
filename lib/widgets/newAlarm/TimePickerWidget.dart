import 'package:flutter/material.dart';

class TimePickerWidget extends StatelessWidget {
  final ValueChanged<TimeOfDay> onTimeSelected;

  const TimePickerWidget({super.key, required this.onTimeSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.access_time,
        color: Color(0xff757575),
        size: 24,
      ),
      title: const Text(
        '시간',
        style: TextStyle(
          color: Color(0xffD9D9D9),
          fontSize: 20,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline,
          decorationColor: Color(0xffD9D9D9),
        ),
      ),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData(
                timePickerTheme: TimePickerThemeData(
                  backgroundColor: Colors.white, // 배경색
                  hourMinuteTextColor: Colors.black, // 시간/분 텍스트 색상
                  hourMinuteColor: const Color(0xffE8F4FF), // 시간/분 배경색
                  hourMinuteTextStyle: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  dialBackgroundColor: const Color(0xffE8F4FF), // 다이얼 배경색
                  dialTextColor: Colors.black, // 다이얼 텍스트 색상
                  entryModeIconColor: const Color(0xff5EB6FF), // 입력 모드 아이콘 색상
                  helpTextStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff5EB6FF),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // 전체 모서리 둥글게
                  ),
                ),
              ),
              child: child ?? const SizedBox(),
            );
          },
        );
        if (pickedTime != null) {
          onTimeSelected(pickedTime);
        }
      },
    );
  }
}
