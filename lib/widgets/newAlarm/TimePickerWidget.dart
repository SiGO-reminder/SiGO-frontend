import 'package:flutter/material.dart';

class TimePickerWidget extends StatelessWidget {
  final ValueChanged<TimeOfDay> onTimeSelected;

  const TimePickerWidget({super.key, required this.onTimeSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.access_time),
      title: const Text('시간 선택'),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          onTimeSelected(pickedTime);
        }
      },
    );
  }
}