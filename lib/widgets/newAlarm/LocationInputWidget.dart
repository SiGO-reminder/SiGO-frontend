import 'package:flutter/material.dart';
import 'package:projects/screen/LocationSearchScreen.dart';

class LocationInputWidget extends StatefulWidget {
  final ValueChanged<Map<String, String>> onLocationSelected; // x, y 포함 콜백

  const LocationInputWidget({super.key, required this.onLocationSelected});

  @override
  State<LocationInputWidget> createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  String? selectedLocation; // 사용자에게 보여줄 건물명
  String? selectedX; // 경도
  String? selectedY; // 위도

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // 위치 검색 화면으로 이동
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocationSearchScreen(
              onLocationSelected: (location) {
                setState(() {
                  // 선택한 위치 정보 저장
                  selectedLocation = location['location']; // 건물명
                  selectedX = location['x']; // 경도
                  selectedY = location['y']; // 위도
                });

                // 콜백 호출하여 부모 위젯에 전달
                widget.onLocationSelected({
                  'location': location['location']!,
                  'x': location['x']!,
                  'y': location['y']!,
                });
              },
            ),
          ),
        );
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
            // 선택한 위치 표시 (없을 시 기본 문구)
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
    );
  }
}
