import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlarmsoundScreen extends StatelessWidget {
  const AlarmsoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double topPadding = size.height * 0.12;
    final double leftRightPadding = size.width * 0.27;
    final double bottomPadding = size.height * 0.10;
    final int currentHour = DateTime.now().hour;
    final String timeType = currentHour < 12 ? 'am' : 'pm';
    // String timeType = 'pm';

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: timeType == 'pm'
                ? [const Color(0xFF3899E8), const Color(0xFF135286)]
                : [const Color(0xFFA8D8FF), const Color(0xFF43AAFF)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: topPadding,
            left: leftRightPadding,
            right: leftRightPadding,
            bottom: bottomPadding,
          ),
          child: Column(
            children: [
              // 상단 텍스트 영역
              SizedBox(
                width: double.infinity,
                height: size.height * 0.22,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '08:00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 9),
                    Text(
                      '저녁 약속',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.64,
                      ),
                    ),
                    SizedBox(height: 9),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 24,
                        ),
                        Text(
                          '반지하 돈부리',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.64,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: size.width * 0.18,
                height: size.width * 0.25,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: timeType == 'pm'
                        ? const Color(0xffD4E4F0)
                        : Colors.white,
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    shadowColor: const Color(0x3F000000),
                    elevation: 10,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SvgPicture.asset(
                      'assets/images/fluent-mdl2_cancel.svg',
                      color: const Color(0xff757575),
                      width: size.width * 0.4, // 버튼 지름보다 약간 작게
                      height: size.width * 0.4, // 버튼 지름보다 약간 작게
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
