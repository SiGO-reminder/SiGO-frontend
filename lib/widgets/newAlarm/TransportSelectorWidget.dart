import 'package:flutter/material.dart';

class TransportSelectorWidget extends StatefulWidget {
  final ValueChanged<String> onTransportSelected;

  const TransportSelectorWidget({super.key, required this.onTransportSelected});

  @override
  _TransportSelectorWidgetState createState() =>
      _TransportSelectorWidgetState();
}

class _TransportSelectorWidgetState extends State<TransportSelectorWidget> {
  String selectedTransport = '';

  @override
  Widget build(BuildContext context) {
    final transportOptions = [
      {'name': '버스', 'icon': Icons.directions_bus},
      {'name': '택시', 'icon': Icons.local_taxi},
      {'name': '도보', 'icon': Icons.directions_walk},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: transportOptions.map((option) {
        final isSelected = selectedTransport == option['name'];

        return ElevatedButton.icon(
          onPressed: () {
            setState(() {
              selectedTransport = option['name'] as String;
            });
            widget.onTransportSelected(option['name'] as String);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected
                ? const Color(0xFF5EB6FF) // 선택된 버튼 배경색
                : const Color(0xFFF6F6F6), // 기본 배경색
            foregroundColor: isSelected
                ? Colors.white // 선택된 버튼 텍스트 색상
                : const Color(0xffA7A7A7), // 기본 텍스트 색상
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ), // 버튼 내부 패딩
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(right: 4), // 아이콘과 텍스트 간격 최소화
            child: Icon(
              option['icon'] as IconData,
              size: 25, // 아이콘 크기 축소
              color: isSelected ? Colors.white : const Color(0xffA7A7A7),
            ),
          ),
          label: Text(
            option['name'] as String,
            style: const TextStyle(
              fontSize: 16, // 텍스트 크기 축소
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
