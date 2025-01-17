import 'package:flutter/material.dart';
import 'package:projects/screen/NewAlarmScreen.dart';
import 'package:projects/widgets/homeScreen/DateCircleWidget.dart';
import 'package:projects/widgets/homeScreen/PlusbuttonWidget.dart';
import 'package:projects/widgets/homeScreen/PopupMenuButtonWidget.dart';
import 'package:projects/widgets/homeScreen/DraggableScrollableSheetWidget.dart';
import 'package:projects/widgets/homeScreen/AlarmBoxWidget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:projects/utils/DataStorage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedbottomNavigationIcon = 1;
  int sortingCriteria = 1; // 사용자별 정렬 기준
  late String currentDate; // 오늘 날짜를 저장할 변수
  List<Map<String, dynamic>> alarms = []; // 알람 데이터 리스트

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('yyyy/MM/dd').format(DateTime.now());
    loadAlarms(); // 저장된 알람 데이터 로드
  }

  Future<void> loadAlarms() async {
    List<Map<String, dynamic>> loadedAlarms = await DataStorage.loadAlarms();
    setState(() {
      alarms = loadedAlarms;
    });
  }

  Future<void> toggleAlarmStatus(int index, bool isOn) async {
    await DataStorage.updateAlarmStatus(index, isOn); // 상태 저장
    setState(() {
      alarms[index]['isOn'] = isOn; // UI 업데이트
    });
  }

  Future<void> deleteAlarm(int index) async {
    await DataStorage.deleteAlarm(index); // 데이터베이스에서 알람 삭제
    loadAlarms(); // 삭제 후 데이터 새로고침
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5F7),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(91),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 43, left: 22, right: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 오늘 날짜 표시
                Text(
                  currentDate,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.32,
                  ),
                ),
                // 팝업 메뉴
                PopupMenuWidget(
                  onCriteriaSelected: (criteria) {
                    setState(() {
                      sortingCriteria = criteria;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: alarms.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset('assets/images/page.png'),
                      ),
                      const Text(
                        "오늘의 일정이 없어요!",
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xffB3B3B3),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        "+ 버튼을 눌러 새 일정을 추가해보세요.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffB3B3B3),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: sortingCriteria == 2
                        ? const EdgeInsets.only(top: 50)
                        : EdgeInsets.zero,
                    itemCount: alarms.length,
                    itemBuilder: (context, index) {
                      final alarm = alarms[index];
                      return AlarmBoxWidget(
                        key: ValueKey(alarm['time'] + alarm['title']), // 고유 키
                        rawTime: alarm['time'] ?? "00:00",
                        location: alarm['location'] ?? "Unknown Location",
                        title: alarm['title'] ?? "No Title",
                        isOn: alarm['isOn'] ?? true,
                        onDelete: () => deleteAlarm(index),
                        onToggle: (isOn) => toggleAlarmStatus(index, isOn),
                      );
                    },
                  ),
          ),
          if (sortingCriteria == 1) const ScrollableSheet(),
          if (sortingCriteria == 2)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: DateCircle(),
            ),
        ],
      ),
      floatingActionButton: plus_Button(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewAlarmScreen()),
          ).then((_) => loadAlarms());
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 69,
        child: BottomNavigationBar(
          currentIndex: _selectedbottomNavigationIcon,
          onTap: (index) {
            setState(() {
              _selectedbottomNavigationIcon = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          selectedItemColor: const Color(0xff5FB7FF),
          unselectedItemColor: const Color(0xffB3B3B3),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/iconamoon_profile-fill.svg',
                color: _selectedbottomNavigationIcon == 0
                    ? const Color(0xff5FB7FF)
                    : const Color(0xffB3B3B3),
              ),
              label: 'Personal',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/material-symbols_home-rounded.svg',
                color: _selectedbottomNavigationIcon == 1
                    ? const Color(0xff5FB7FF)
                    : const Color(0xffB3B3B3),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/charm_menu-meatball.svg',
                color: _selectedbottomNavigationIcon == 2
                    ? const Color(0xff5FB7FF)
                    : const Color(0xffB3B3B3),
              ),
              label: 'SeeMore',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
