import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projects/widgets/newAlarm/LocationItemWidget.dart';

class LocationSearchScreen extends StatefulWidget {
  final ValueChanged<Map<String, String>> onLocationSelected; // x, y 값 포함

  const LocationSearchScreen({super.key, required this.onLocationSelected});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = []; // 검색 결과 저장
  bool isLoading = false;

  // API 호출
  Future<void> performSearch(String query) async {
    if (query.isEmpty) return;
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/naver-map/search'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'address': query}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          searchResults = List<Map<String, dynamic>>.from(data['data']);
        });
      } else {
        showErrorSnackBar('검색 실패. 다시 시도하세요.');
      }
    } catch (e) {
      showErrorSnackBar('네트워크 오류가 발생했습니다.');
    }

    setState(() {
      isLoading = false;
    });
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도착지 입력'),
        backgroundColor: const Color(0xff5FB7FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 검색 입력 필드
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: '장소를 입력하세요.',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      searchResults.clear();
                    });
                  },
                ),
              ),
              onChanged: (value) {
                if (value.length > 1) {
                  performSearch(value);
                }
              },
            ),
          ),
          // 검색 결과 리스트
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchResults.isEmpty
                ? const Center(child: Text('검색 결과가 없습니다.'))
                : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return LocationItemWidget(
                  name: result['name'],
                  address: result['address'],
                  category: result['category'],
                  onTap: () {
                    // x, y, address 전달
                    widget.onLocationSelected({
                      'location': result['name'],
                      'x': result['x'],
                      'y': result['y'],
                    });
                    Navigator.pop(context); // 이전 화면으로 이동
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
