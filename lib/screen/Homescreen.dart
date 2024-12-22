import 'package:flutter/material.dart';
import 'package:projects/widgets/button.dart';
import 'package:projects/main.dart'; // addSomething() 호출용

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    color: Color(0xffB3B3B3),
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text('Body4'),
      ),
      floatingActionButton: const Button(
        addPressed: MyApp.addSomething,
      ),
      bottomNavigationBar: SizedBox(
        height: 69,
        child: BottomNavigationBar(
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
