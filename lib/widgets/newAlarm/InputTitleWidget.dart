import 'package:flutter/material.dart';

class InputTitleWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const InputTitleWidget({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xffD9D9D9),
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        border: InputBorder.none, // 기본 테두리 제거
      ),
    );
  }
}
