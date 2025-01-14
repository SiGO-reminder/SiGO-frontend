import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePickerWidget extends StatelessWidget {
  final ValueChanged<TimeOfDay> onTimeSelected;
  final TimeOfDay? selectedTime;

  const TimePickerWidget({
    super.key,
    required this.onTimeSelected,
    this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    String timeString() {
      if (selectedTime == null) {
        return '시간 선택1';
      } else {
        final now = DateTime.now();
        final dt = DateTime(
          now.year,
          now.month,
          now.day,
          selectedTime!.hour,
          selectedTime!.minute,
        );
        // "hh:mm a" → 예: 07:05 PM
        return DateFormat('hh:mm a').format(dt);
      }
    }

    return ListTile(
      leading: const Icon(
        Icons.access_time,
        color: Color(0xff757575),
        size: 24,
      ),
      title: Text(
        timeString(),
        style: TextStyle(
          color: selectedTime == null ? const Color(0xffD9D9D9) : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xffD9D9D9),
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
