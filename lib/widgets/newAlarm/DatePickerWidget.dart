import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final ValueChanged<DateTime> onDateSelected;

  const DatePickerWidget({super.key, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.calendar_today),
      title: const Text('날짜 선택'),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
    );
  }
}