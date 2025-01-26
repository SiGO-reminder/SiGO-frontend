import 'package:flutter/material.dart';
import 'package:projects/screen/NewAlarmScreen.dart';
import 'package:projects/screen/AlarmSoundScreen.dart';
import 'package:projects/widgets/homeScreen/DateCircleWidget.dart';
import 'package:projects/widgets/homeScreen/PlusbuttonWidget.dart';
import 'package:projects/widgets/homeScreen/PopupMenuButtonWidget.dart';
import 'package:projects/widgets/homeScreen/DraggableScrollableSheetWidget.dart';
import 'package:projects/widgets/homeScreen/AlarmBoxWidget.dart' as AlarmBox;
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
  late String currentDate; // 오늘 날짜 저장
  List<Map<String, dynamic>> alarms = []; // 오늘의 알람
  List<Map<String, dynamic>> futureAlarms = []; // 미래의 알람
  String selectedDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now()); // 선택된 날짜

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('yyyy/MM/dd').format(DateTime.now());
    loadAlarms();
  }

  Future<void> loadAlarms() async {
    final loadedAlarms = await DataStorage.loadAlarms();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setState(() {
      alarms = loadedAlarms.where((alarm) => alarm['date'] == today).toList();
      futureAlarms = loadedAlarms.where((alarm) {
        final alarmDate = DateTime.parse(alarm['date']);
        return alarmDate.isAfter(DateTime.now());
      }).toList();
    });
  }

  Future<void> loadSelectedDateAlarms() async {
    final loadedAlarms = await DataStorage.loadAlarms();
    setState(() {
      alarms =
          loadedAlarms.where((alarm) => alarm['date'] == selectedDate).toList();
    });
  }

  Future<void> toggleAlarmStatus(String id, bool isOn) async {
    await DataStorage.updateAlarmStatus(id, isOn);
    if (sortingCriteria == 1) {
      loadAlarms();
    } else {
      loadSelectedDateAlarms();
    }
  }

  Future<void> deleteAlarm(String id) async {
    await DataStorage.deleteAlarm(id);
    if (sortingCriteria == 1) {
      loadAlarms();
    } else {
      loadSelectedDateAlarms();
    }
  }

  void handleCriteriaChange(int criteria) {
    setState(() {
      sortingCriteria = criteria;
      if (sortingCriteria == 1) {
        // sortingCriteria=1로 돌아올 때 오늘 날짜로 초기화
        selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        loadAlarms();
      }
    });
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
                Text(
                  currentDate,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.32,
                  ),
                ),
                PopupMenuWidget(
                  onCriteriaSelected: handleCriteriaChange,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: sortingCriteria == 2
                ? Column(
                    children: [
                      DateCircle(
                        selectedDate: selectedDate,
                        onDateSelected: (date) {
                          setState(() {
                            selectedDate =
                                DateFormat('yyyy-MM-dd').format(date);
                          });
                          loadSelectedDateAlarms();
                        },
                      ),
                      Expanded(
                        child: alarms.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/page.png'),
                                    const Text(
                                      "선택된 날짜의 일정이 없습니다!",
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
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: alarms.length,
                                itemBuilder: (context, index) {
                                  final alarm = alarms[index];
                                  return AlarmBox.AlarmBoxWidget(
                                    key: ValueKey(alarm['id']),
                                    rawTime: alarm['time'] ?? "00:00",
                                    location:
                                        alarm['location'] ?? "Unknown Location",
                                    title: alarm['title'] ?? "No Title",
                                    isOn: alarm['isOn'] ?? true,
                                    onDelete: () => deleteAlarm(alarm['id']),
                                    onToggle: (isOn) =>
                                        toggleAlarmStatus(alarm['id'], isOn),
                                  );
                                },
                              ),
                      ),
                    ],
                  )
                : alarms.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset('assets/images/page.png'),
                          ),
                          const Text(
                            "오늘의 일정이 없습니다!",
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
                        padding: const EdgeInsets.only(top: 11),
                        itemCount: alarms.length,
                        itemBuilder: (context, index) {
                          final alarm = alarms[index];
                          return AlarmBox.AlarmBoxWidget(
                            key: ValueKey(alarm['id']),
                            rawTime: alarm['time'] ?? "00:00",
                            location: alarm['location'] ?? "Unknown Location",
                            title: alarm['title'] ?? "No Title",
                            isOn: alarm['isOn'] ?? true,
                            onDelete: () => deleteAlarm(alarm['id']),
                            onToggle: (isOn) =>
                                toggleAlarmStatus(alarm['id'], isOn),
                          );
                        },
                      ),
          ),
          if (sortingCriteria == 1)
            DraggableScrollableSheetWidget(
              futureAlarms: futureAlarms,
              onToggle: toggleAlarmStatus,
              onDelete: deleteAlarm,
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
        height: 79,
        child: BottomNavigationBar(
          currentIndex: _selectedbottomNavigationIcon,
          onTap: (index) {
            setState(() {
              _selectedbottomNavigationIcon = index;
            });

            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AlarmsoundScreen()),
              );
            }
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
