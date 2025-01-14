import 'package:flutter/material.dart';
import 'package:projects/screen/NewAlarmScreen.dart';
import 'package:projects/widgets/homeScreen/PlusbuttonWidget.dart';
import 'package:projects/widgets/homeScreen/PopupMenuButtonWidget.dart';
import 'package:projects/widgets/homeScreen/DraggableScrollableSheetWidget.dart';
import 'package:projects/widgets/homeScreen/AlarmBoxWidget.dart';
import 'package:projects/widgets/homeScreen/DateCircleWidget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart'; //로컬타임임

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedbottomNavigationIcon = 1;
  int sorting_criteria = 1; //이건 사용자에 따라 별도 설정
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
                  DateFormat('yyyy/MM/dd').format(DateTime.now()),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.32,
                  ),
                ),
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
          // print('new_alarm으로 이동');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewAlarmScreen()),
          );
        },
      ),
      bottomNavigationBar: SizedBox(
        // margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 69,
        child: BottomNavigationBar(
          currentIndex: _selectedbottomNavigationIcon,
          onTap: (index) {
            setState(
              () {
                _selectedbottomNavigationIcon = index;
                print(index);
              },
            );
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
                    ? const Color(0xff5FB7FF) // 선택된 상태
                    : const Color(0xffB3B3B3), // 선택되지 않은 상태
              ),
              label: 'Personal',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/material-symbols_home-rounded.svg',
                color: _selectedbottomNavigationIcon == 1
                    ? const Color(0xff5FB7FF) // 선택된 상태
                    : const Color(0xffB3B3B3), // 선택되지 않은 상태
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/charm_menu-meatball.svg',
                color: _selectedbottomNavigationIcon == 2
                    ? const Color(0xff5FB7FF) // 선택된 상태
                    : const Color(0xffB3B3B3), // 선택되지 않은 상태
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
