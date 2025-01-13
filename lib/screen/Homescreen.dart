import 'package:flutter/material.dart';
import 'package:projects/screen/NewAlarmScreen.dart';
import 'package:projects/widgets/plus_button.dart';
import 'package:projects/widgets/draggableScrollableSheet.dart';
import 'package:projects/widgets/alarmBox.dart';
import 'package:projects/widgets/dateCircle.dart';

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
    var AlarmStack = SafeArea(
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
    );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(91),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 43, left: 22, right: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '2024/11/30',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.32,
                  ),
                ),
                PopupMenuButton(
                  color: const Color(0xffF4F5F7),
                  popUpAnimationStyle: AnimationStyle(
                    curve: Easing.emphasizedDecelerate,
                    duration: const Duration(seconds: 1),
                  ),
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    color: Color(0xffB3B3B3),
                    size: 32,
                  ),
                  itemBuilder: (context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(
                          Icons.data_array_rounded,
                          size: 20,
                        ),
                        title: Text(
                          "Style",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        setState(() {
                          sorting_criteria = 1;
                        });
                        print(sorting_criteria);
                      },
                      child: const ListTile(
                        title: Text(
                          "일정 기준",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      onTap: () {
                        setState(() {
                          sorting_criteria = 2;
                        });
                        print(sorting_criteria);
                      },
                      child: const ListTile(
                        title: Text(
                          "날짜 기준",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          AlarmStack,
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 45),
              label: 'Personal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 45),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_rounded, size: 45),
              label: 'SeeMore',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
