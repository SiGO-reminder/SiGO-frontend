import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final ValueChanged<DateTime> onDateSelected;

  const DatePickerWidget({super.key, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.calendar_month_rounded,
        color: Color(0xff757575),
        size: 24,
      ),
      title: const Text(
        '날짜 선택',
        style: TextStyle(
          color: Color(0xffD9D9D9),
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: ThemeData(
                useMaterial3: true,
                datePickerTheme: const DatePickerThemeData(
                  backgroundColor: Colors.white, // 배경색
                  headerBackgroundColor: Color(0xff5EB6FF), // 헤더 배경색
                  headerForegroundColor: Colors.white, // 헤더 텍스트 색상
                  surfaceTintColor: Colors.transparent, // 색상 전환 비활성화
                  yearStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  dayStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              child: child ?? const SizedBox(),
            );
          },
        );

        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
    );
  }
}
