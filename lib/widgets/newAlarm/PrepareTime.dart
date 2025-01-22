import 'package:flutter/material.dart';

class PreparationTime extends StatefulWidget {
  final Function(int) onPreparationTimeSelected; // 선택된 시간 전달 콜백

  const PreparationTime({
    Key? key,
    required this.onPreparationTimeSelected,
  }) : super(key: key);

  @override
  State<PreparationTime> createState() => _PreparationTimeState();
}

class _PreparationTimeState extends State<PreparationTime> {
  bool mainPressed = false;
  int selectedIndex = -1;
  final List<int> times = [5, 10, 20, 30];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                mainPressed = !mainPressed;
                if (!mainPressed) {
                  // 준비 시간 선택 해제 시 0 전달
                  widget.onPreparationTimeSelected(0);
                  selectedIndex = -1;
                }
              });
            },
            child: Container(
              width: 124,
              height: 32,
              decoration: BoxDecoration(
                color: mainPressed
                    ? const Color(0xFF5EB6FF)
                    : const Color(0xfff6f6f6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Row(
                  children: [
                    const Text("  "),
                    Icon(
                      Icons.add,
                      color:
                      mainPressed ? Colors.white : const Color(0xFFA6A6A6),
                    ),
                    Text(
                      '준비시간 추가',
                      style: TextStyle(
                        color: mainPressed
                            ? Colors.white
                            : const Color(0xFFA6A6A6),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.64,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (mainPressed)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(times.length, (index) {
                  bool isSelected = (index == selectedIndex);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        widget.onPreparationTimeSelected(times[index]); // 선택 시간 전달
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      width: 50,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF5EB6FF)
                            : const Color(0xfff6f6f6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${times[index]}분',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFFA6A6A6),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.32,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
