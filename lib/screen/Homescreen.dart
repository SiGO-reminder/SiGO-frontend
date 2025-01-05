import 'package:flutter/material.dart';
import 'package:projects/widgets/plus_button.dart';
import 'package:projects/widgets/draggableScrollableSheet.dart';
import 'package:projects/widgets/alarmBox.dart';
import 'package:projects/main.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    const AlarmStack = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AlarmBox(),
            AlarmBox(),
            AlarmBox(),
            AlarmBox(),
            AlarmBox(),
            AlarmBox(),
            AlarmBox(),
            AlarmBox(),
            AlarmBox(),
            AlarmBox(),
            AlarmBox(),
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
                  '2024/12/25',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
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
                          "정렬",
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
                        print("#1");
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
                        print("#2");
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
      body: const Stack(
        children: [
          AlarmStack,
          ScrollableSheet(),
        ],
      ),
      floatingActionButton: const Button(
        addPressed: MyApp.addSomething,
      ),
      bottomNavigationBar: SizedBox(
        height: 69,
        child: BottomNavigationBar(
          elevation: 4,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                size: 35,
                color: Color(0xffB3B3B3),
              ),
              label: 'Personal',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 35,
                color: Color(0xff5FB7FF),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.more_horiz_rounded,
                size: 35,
                color: Color(0xffB3B3B3),
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
