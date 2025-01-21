import 'package:flutter/material.dart';
import 'AlarmBoxWidget.dart';

class DraggableScrollableSheetWidget extends StatelessWidget {
  final List<Map<String, dynamic>> futureAlarms;
  final Future<void> Function(String, bool) onToggle;
  final Future<void> Function(String) onDelete;

  const DraggableScrollableSheetWidget({
    super.key,
    required this.futureAlarms,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // 알람 데이터를 날짜별로 그룹화
    final Map<String, List<Map<String, dynamic>>> groupedAlarms = {};
    for (var alarm in futureAlarms) {
      final date = alarm['date'] ?? 'Unknown Date';
      if (!groupedAlarms.containsKey(date)) {
        groupedAlarms[date] = [];
      }
      groupedAlarms[date]?.add(alarm);
    }

    final sortedDates = groupedAlarms.keys.toList()..sort();

    return DraggableScrollableSheet(
      initialChildSize: 0.05,
      minChildSize: 0.05,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              // 상단 핸들바
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x19000000),
                            spreadRadius: 0,
                            blurRadius: 30,
                            offset: Offset(0, 3),
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
              // 섹션 구분 디자인
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
                            color: Color(0x19000000),
                            spreadRadius: 0,
                            blurRadius: 5.0,
                            offset: Offset(0, -0.01),
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
                            color: Color(0x19000000),
                            spreadRadius: 0,
                            blurRadius: 5.0,
                            offset: Offset(5, -0.01),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // 알람 데이터 섹션
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xffF4F5F7),
                ),
                child: Column(
                  children: [
                    const Row(
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
                              letterSpacing: -0.80,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(4, 18.5, 0, 1),
                          child: Icon(
                            Icons.calendar_today_outlined,
                            color: Color(0xff757575),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    ...sortedDates.map((date) {
                      final alarms = groupedAlarms[date]!;
                      return NextCalender(
                        date: date,
                        alarms: alarms,
                        onToggle: onToggle,
                        onDelete: onDelete,
                      );
                    }),
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

class NextCalender extends StatelessWidget {
  final String date;
  final List<Map<String, dynamic>> alarms;
  final Future<void> Function(String, bool) onToggle;
  final Future<void> Function(String) onDelete;

  const NextCalender({
    super.key,
    required this.date,
    required this.alarms,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
      child: ExpansionTile(
        minTileHeight: 36,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          date,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: Color(0xFF757575),
          ),
        ),
        iconColor: Colors.blue,
        collapsedBackgroundColor: Colors.white,
        backgroundColor: const Color(0xffF4F5F7),
        children: alarms.map((alarm) {
          return AlarmBoxWidget(
            rawTime: alarm['time'] ?? "00:00",
            location: alarm['location'] ?? "Unknown Location",
            title: alarm['title'] ?? "No Title",
            isOn: alarm['isOn'] ?? true,
            onDelete: () => onDelete(alarm['id']),
            onToggle: (value) => onToggle(alarm['id'], value),
          );
        }).toList(),
      ),
    );
  }
}
