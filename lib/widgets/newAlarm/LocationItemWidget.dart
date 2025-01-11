import 'package:flutter/material.dart';

class LocationItemWidget extends StatelessWidget {
  final String name; // 장소 이름
  final String address; // 주소
  final VoidCallback onTap; // 클릭 이벤트

  const LocationItemWidget({
    super.key,
    required this.name,
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // 클릭 시 이벤트 처리
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE9E9E9))), // 구분선
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name, // 장소 이름
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              address, // 주소
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
