import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:projects/widgets/newAlarm/LocationItemWidget.dart';

class LocationSearchScreen extends StatefulWidget {
  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  Timer? _debounce;

  // API 호출
  Future<void> performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/v0/naver-map/search'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'address': query}),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['data'] is List) {
          setState(() {
            searchResults = List<Map<String, dynamic>>.from(data['data']);
          });
        } else {
          showErrorSnackBar('응답 데이터가 올바르지 않습니다.');
        }
      } else {
        showErrorSnackBar('검색 실패: ${response.statusCode}');
      }
    } catch (e) {
      showErrorSnackBar('네트워크 오류: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
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
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  if (value.trim().length > 1) {
                    performSearch(value);
                  } else {
                    setState(() {
                      searchResults.clear();
                    });
                  }
                });
              },
            ),
          ),
          // 검색 결과 리스트
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchResults.isEmpty
                ? const Center(
              child: Text(
                '검색 결과가 없습니다.',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return LocationItemWidget(
                  name: result['name'],
                  address: result['address'],
                  onTap: () {
                    Navigator.pop(context, {
                      'location': result['name'],
                      'x': result['x'],
                      'y': result['y'],
                    });
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
