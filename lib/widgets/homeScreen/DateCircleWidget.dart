import 'package:flutter/material.dart';

class DateCircle extends StatefulWidget {
  const DateCircle({super.key});

  @override
  State<DateCircle> createState() => _DateCircleState();
}

class _DateCircleState extends State<DateCircle> {
  int _selectedIndex = 0;

  final List<int> _days = List.generate(
    5,
    (index) => DateTime.now().add(Duration(days: index)).day,
  );
  //list 생성 = [오늘날짜, ()+1, ()+2, ()+3, ()+4]

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_days.length, (index) {
          final day = _days[index];
          final isSelected = (index == _selectedIndex);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                color: isSelected ? const Color(0xFF5EB6FF) : Colors.white,
                shape: const OvalBorder(),
              ),
              child: Center(
                child: Text(
                  day.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
