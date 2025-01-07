import 'package:flutter/material.dart';

class InputTitleWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const InputTitleWidget({super.key, required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}