import 'package:flutter/material.dart';

class ConfirmButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const ConfirmButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5EB6FF),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: onPressed,
      child: const Text(
        '확인',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}