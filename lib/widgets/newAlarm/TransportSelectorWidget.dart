import 'package:flutter/material.dart';

class TransportSelectorWidget extends StatelessWidget {
  final ValueChanged<String> onTransportSelected;

  const TransportSelectorWidget({super.key, required this.onTransportSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['버스', '택시', '자전거', '도보'].map((transport) {
        return ElevatedButton(
          onPressed: () => onTransportSelected(transport),
          child: Text(transport),
        );
      }).toList(),
    );
  }
}