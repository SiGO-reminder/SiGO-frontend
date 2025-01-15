import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatelessWidget {
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? selectedDate;

  const DatePickerWidget({
    super.key,
    required this.onDateSelected,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.calendar_month_rounded,
        color: Color(0xff757575),
        size: 24,
      ),
      title: Text(
        selectedDate == null
            ? '날짜 선택'
            : DateFormat('yyyy/MM/dd').format(selectedDate!),
        style: TextStyle(
          color: selectedDate == null ? const Color(0xffD9D9D9) : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 10),
          builder: (context, child) {
            return Theme(
              data: ThemeData(
                useMaterial3: true,
                datePickerTheme: const DatePickerThemeData(
                  backgroundColor: Colors.white,
                  headerBackgroundColor: Color(0xff5EB6FF),
                  headerForegroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
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
