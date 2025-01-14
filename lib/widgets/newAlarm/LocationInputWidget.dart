import 'package:flutter/material.dart';
import 'package:projects/screen/LocationSearchScreen.dart';

class LocationInputWidget extends StatefulWidget {
  final ValueChanged<Map<String, String>> onLocationSelected;

  const LocationInputWidget({super.key, required this.onLocationSelected});

  @override
  State<LocationInputWidget> createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  String? selectedLocation; // 선택된 장소 이름
  String? selectedX; // 선택된 경도
  String? selectedY; // 선택된 위도

  @override
  Widget build(BuildContext context) {
    return Material(
      // Material 위젯 추가
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LocationSearchScreen()),
          );
          if (result != null) {
            setState(() {
              selectedLocation = result['location']; // 건물명
              selectedX = result['x'].toString(); // 경도를 문자열로 변환
              selectedY = result['y'].toString(); // 위도를 문자열로 변환
            });

            // 상위 위젯으로 데이터 전달
            widget.onLocationSelected({
              'location': selectedLocation!,
              'x': selectedX!,
              'y': selectedY!,
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedLocation ?? '장소를 선택하세요',
                style: TextStyle(
                  fontSize: 16,
                  color: selectedLocation == null ? Colors.grey : Colors.black,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
