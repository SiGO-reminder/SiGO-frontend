import 'package:flutter/material.dart';
import 'package:projects/screen/NewAlarmScreen.dart';
import 'package:projects/widgets/homeScreen/PlusbuttonWidget.dart';
import 'package:projects/widgets/homeScreen/PopupMenuButtonWidget.dart';
import 'package:projects/widgets/homeScreen/DraggableScrollableSheetWidget.dart';
import 'package:projects/widgets/homeScreen/AlarmBoxWidget.dart';
import 'package:projects/widgets/homeScreen/DateCircleWidget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart'; // 날짜 형식화를 위해 추가

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedbottomNavigationIcon = 1;
  int sorting_criteria = 1; // 사용자별 정렬 기준
  late String currentDate; // 오늘 날짜를 저장할 변수

  @override
  void initState() {
    super.initState();
    // 오늘 날짜 가져오기
    currentDate = DateFormat('yyyy/MM/dd').format(DateTime.now());
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
                      sorting_criteria = criteria;
                    });
                    print("Selected sorting criteria: $sorting_criteria");
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (sorting_criteria == 2) const DateCircle(),
                  const AlarmBox(),
                  const AlarmBox(),
                  const AlarmBox(),
                ],
              ),
            ),
          ),
          if (sorting_criteria == 1) const ScrollableSheet(),
        ],
      ),
      floatingActionButton: plus_Button(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewAlarmScreen()),
          );
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 69,
        child: BottomNavigationBar(
          currentIndex: _selectedbottomNavigationIcon,
          onTap: (index) {
            setState(() {
              _selectedbottomNavigationIcon = index;
              print(index);
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
