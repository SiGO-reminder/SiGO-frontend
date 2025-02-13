import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:projects/widgets/newAlarm/LocationItemWidget.dart';
import 'package:flutter_svg/svg.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

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
        Uri.parse('http://10.0.2.2:3002/api/v0/naver-map/search'),
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(91),
        child: Container(
          color: const Color(0xff5FB7FF),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 53,
              bottom: 9,
            ),
            child: Stack(
              alignment: Alignment.center, // 중앙 정렬
              children: [
                // 아이콘: 왼쪽에 고정
                Positioned(
                  left: 10,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                // 텍스트: 정가운데 배치
                const Text(
                  '도착지 입력',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.32,
                  ),
                ),
              ],
            ),
          ),
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
                hintStyle: const TextStyle(
                  color: Color(0xffB3B3B3),
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.32,
                ),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xff757575),
                  size: 30,
                ),
                suffixIcon: searchController.text.isNotEmpty // 조건부 렌더링
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Color(0xff757575),
                          size: 30,
                        ),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchResults.clear();
                          });
                        },
                      )
                    : null,
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
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 150),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'assets/images/hugeicons_border-none-02.svg',
                                width: 72,
                              ),
                            ),
                            const Text(
                              '일치하는 장소 정보가 없어요',
                              style: TextStyle(
                                color: Color(0xffD2D2D2),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.32,
                              ),
                            ),
                          ],
                        ))
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
