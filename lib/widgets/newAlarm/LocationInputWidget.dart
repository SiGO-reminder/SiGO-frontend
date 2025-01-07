import 'package:flutter/material.dart';

class LocationInputWidget extends StatefulWidget {
  final ValueChanged<String> onLocationSelected;

  const LocationInputWidget({super.key, required this.onLocationSelected});

  @override
  State<LocationInputWidget> createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  final TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 컨트롤러 리스너 추가 (입력값을 실시간으로 감지)
    locationController.addListener(() {
      widget.onLocationSelected(locationController.text);
    });
  }

  @override
  void dispose() {
    // 메모리 누수 방지를 위해 컨트롤러 해제
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: locationController,
      decoration: const InputDecoration(
        labelText: '장소 입력',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.location_on),
      ),
      // 키보드 입력 설정
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text, // 키보드 타입 설정
      onSubmitted: (value) {
        widget.onLocationSelected(value); // 완료 버튼 클릭 시 저장
      },
    );
  }
}