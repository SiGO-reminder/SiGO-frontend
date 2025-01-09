import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PopupMenuWidget extends StatelessWidget {
  final Function(int)? onCriteriaSelected;

  const PopupMenuWidget({super.key, this.onCriteriaSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // color: const Color(0xffF4F5F7),
      color: const Color(0xffFfffff),
      icon: SvgPicture.asset(
        'assets/images/charm_menu-mini.svg',
      ),
      iconSize: 32,
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
          onTap: () {
            if (onCriteriaSelected != null) {
              onCriteriaSelected!(1);
            }
          },
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "일정 기준",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 1,
                  width: 30,
                ),
                SvgPicture.asset(
                  'assets/images/basil_stack-solid.svg',
                ),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(
          height: 0,
        ),
        PopupMenuItem(
          padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
          onTap: () {
            if (onCriteriaSelected != null) {
              onCriteriaSelected!(2);
            }
          },
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "날짜 기준",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 1,
                  width: 30,
                ),
                SvgPicture.asset(
                  'assets/images/uil_calender.svg',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
