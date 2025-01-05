import 'package:flutter/material.dart';
import 'package:projects/widgets/alarmBox.dart';

class ScrollableSheet extends StatelessWidget {
  const ScrollableSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.05,
      minChildSize: 0.05,
      maxChildSize: 1.0,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start, // 상단 정렬
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 30,
                      color: Colors.transparent,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                            10,
                          ),
                          topLeft: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0,
                            blurRadius: 5.0,
                            offset:
                                Offset(0, -0.01), // changes position of shadow
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.keyboard_double_arrow_up_rounded,
                        color: Color(0xff757575),
                        size: 30,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 30,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 10,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0,
                            blurRadius: 5.0,
                            offset:
                                Offset(0, -0.01), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 10,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0,
                            blurRadius: 5.0,
                            offset:
                                Offset(5, -0.01), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 1500,
                decoration: const BoxDecoration(
                  color: Color(0xffF4F5F7),
                ),
                child: const Column(
                  children: [
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Row 내에서 Text를 상단에 정렬
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(23, 13, 0, 1),
                          child: Text(
                            "향후 일정 보기",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff757575),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(4, 18.5, 0, 1),
                          child: Icon(
                            Icons.calendar_today_outlined,
                            color: Color(0xff757575),
                            size: 19,
                          ),
                        )
                      ],
                    ),
                    nextCalender(),
                    nextCalender(),
                    nextCalender(),
                    nextCalender(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class nextCalender extends StatelessWidget {
  const nextCalender({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 6),
      child: ExpansionTile(
        minTileHeight: 36,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          "2077/01/01",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        initiallyExpanded: false,
        backgroundColor: Color(0xffF4F5F7),
        iconColor: Colors.blue,
        collapsedBackgroundColor: Colors.white,
        children: [
          AlarmBox(),
          AlarmBox(),
          AlarmBox(),
        ],
      ),
    );
  }
}
