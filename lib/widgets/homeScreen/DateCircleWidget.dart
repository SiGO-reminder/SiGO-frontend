import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateCircle extends StatelessWidget {
  final String selectedDate;
  final void Function(DateTime) onDateSelected;

  const DateCircle({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = List.generate(5, (index) => today.add(Duration(days: index)));

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((date) {
          final isSelected = DateFormat('yyyy-MM-dd').format(date) == selectedDate;

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF5EB6FF) : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  DateFormat('d').format(date),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
