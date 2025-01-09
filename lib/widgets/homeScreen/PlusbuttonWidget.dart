import 'package:flutter/material.dart';

class plus_Button extends StatelessWidget {
  final VoidCallback onPressed;
  const plus_Button({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,

      // Group60처럼 테두리를 넣고 싶다면 이렇게 지정
      backgroundColor: Colors.white,
      shape: const CircleBorder(
        side: BorderSide(width: 1, color: Color(0xFF5EB6FF)),
      ),
      elevation: 4, // 그림자 강도
      // child 부분에 Group60의 '+' 모양을 그대로 삽입
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 가로 막대
          Container(
            width: 24,
            height: 4,
            decoration: ShapeDecoration(
              color: const Color(0xFF5EB6FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // 세로 막대 (회전으로 교차)
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateZ(1.57),
            child: Container(
              width: 24,
              height: 4,
              decoration: ShapeDecoration(
                color: const Color(0xFF5EB6FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
