import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback addPressed;

  const Button({
    super.key,
    required this.addPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: addPressed,
      backgroundColor: const Color(0xff5FB7FF),
      shape: const CircleBorder(),
      elevation: 4,
      child: const Icon(
        Icons.add_rounded,
        size: 56,
        weight: 100,
        color: Colors.white,
      ),
    );
  }
}
