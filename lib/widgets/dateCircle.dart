import 'package:flutter/material.dart';

class DateCircle extends StatefulWidget {
  const DateCircle({super.key});

  @override
  State<DateCircle> createState() => _DateCircleState();
}

class _DateCircleState extends State<DateCircle> {
  // 현재 선택된 인덱스를 저장 (기본 0이라 가정)
  int _selectedIndex = 0;

  // 예시로 보여줄 5개 날짜
  final List<int> _days = [30, 1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    return Container(
      // 좌우 마진 20
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      // 화면 너비에 맞춰 최대 확장
      width: MediaQuery.of(context).size.width,
      // 5개의 Circle을 균등 간격으로 정렬
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_days.length, (index) {
          final day = _days[index];
          final isSelected = (index == _selectedIndex);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index; // 선택된 인덱스 갱신
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                // 선택 여부에 따라 색상 변경
                color: isSelected ? const Color(0xFF5EB6FF) : Colors.white,
                shape: const OvalBorder(),
              ),
              // 텍스트를 가운데 정렬하기 위해 Center 사용
              child: Center(
                child: Text(
                  day.toString(),
                  style: TextStyle(
                    // 선택 여부에 따라 글자색 변경
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontFamily: 'Pretendard',
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
