import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:projects/utils/DataStorage.dart';

class AlarmBox extends StatefulWidget {
  final String title;
  final String time;
  final String location;
  final bool isOn;
  final int index;

  const AlarmBox({
    Key? key,
    required this.title,
    required this.time,
    required this.location,
    required this.isOn,
    required this.index,
  }) : super(key: key);

  @override
  State<AlarmBox> createState() => _AlarmBoxState();
}

class _AlarmBoxState extends State<AlarmBox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Slidable(
        key: ValueKey(widget.index),
        endActionPane: ActionPane(
          extentRatio: 78 / 343,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                DataStorage.deleteAlarm(widget.index);
              },
              backgroundColor: const Color(0xFF5EB6FF),
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              icon: Icons.delete_rounded,
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 343,
            height: 83,
            child: Stack(
              children: [
                Container(
                  width: 343,
                  height: 83,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  top: 9,
                  child: Text(
                    widget.time,
                    style: const TextStyle(
                      color: Color(0xFF5EB6FF),
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  left: 13.5,
                  top: 47,
                  child: Text(
                    '${widget.location} · ${widget.title}',
                    style: const TextStyle(
                      color: Color(0xFFC2C2C2),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.80,
                    ),
                  ),
                ),
                Positioned(
                  left: 283,
                  top: 25,
                  child: CupertinoSwitch(
                    value: isChecked,
                    activeColor: const Color(0xFF5FB7FF),
                    trackColor: const Color(0xFF757575),
                    onChanged: (bool value) {
                      setState(() {
                        isChecked = value;
                      });
                      DataStorage.updateAlarmStatus(widget.index, value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> alarms = [];

  @override
  void initState() {
    super.initState();
    loadAlarms();
  }

  void loadAlarms() async {
    final loadedAlarms = await DataStorage.loadAlarms();
    setState(() {
      alarms = loadedAlarms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알람 목록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => loadAlarms(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          final alarm = alarms[index];
          return AlarmBox(
            index: index,
            title: alarm['title'],
            time: alarm['time'],
            location: alarm['location'],
            isOn: alarm['isOn'],
          );
        },
      ),
    );
  }
}
