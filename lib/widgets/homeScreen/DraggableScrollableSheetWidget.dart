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
    final screenHeight = MediaQuery.of(context).size.height;
    final double stop40px = 40.0 / screenHeight;
    final Map<String, List<Map<String, dynamic>>> groupedAlarms = {};
    for (var alarm in futureAlarms) {
      final date = alarm['date'] ?? 'Unknown Date';
      if (!groupedAlarms.containsKey(date)) {
        groupedAlarms[date] = [];
      }
      groupedAlarms[date]!.add(alarm);
    }
    final sortedDates = groupedAlarms.keys.toList()..sort();

    return DraggableScrollableSheet(
      initialChildSize: 0.05,
      minChildSize: 0.05,
      maxChildSize: 1.0,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            height: 1500,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, stop40px, stop40px, 1.0],
                colors: const [
                  Colors.transparent,
                  Colors.transparent,
                  Color(0xffF4F5F7),
                  Color(0xffF4F5F7),
                ],
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(height: 30, color: Colors.transparent),
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
                      child: Container(height: 30, color: Colors.transparent),
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
                          color: Colors.white),
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
                Container(
                  color: const Color(0xffF4F5F7),
                  child: Column(
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                      ...sortedDates.map(
                        (date) {
                          final alarms = groupedAlarms[date]!;
                          return NextCalender(
                            date: date,
                            alarms: alarms,
                            onToggle: onToggle,
                            onDelete: onDelete,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
    return ExpansionTile(
      title: Text(date),
      children: alarms.map((alarm) {
        return AlarmBoxWidget(
          rawTime: alarm['time'] ?? "00:00",
          location: alarm['location'] ?? "Unknown Location",
          title: alarm['title'] ?? "No Title",
          isOn: alarm['isOn'] ?? true,
          onDelete: () => onDelete(alarm['id']?.toString() ?? ''),
          onToggle: (val) => onToggle(alarm['id']?.toString() ?? '', val),
        );
      }).toList(),
    );
  }
}
