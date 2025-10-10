import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/cores/math_utils.dart';

class TimerScreen extends StatefulWidget {
  final DateTime initialDuration;

  TimerScreen({required this.initialDuration});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Duration timeLeft = Duration();
  late Timer timer;

  @override
  void initState() {
    super.initState();

    updateTimeLeft();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateTimeLeft());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void updateTimeLeft() {
    setState(() {
      timeLeft = widget.initialDuration.difference(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildTime();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  Widget buildTime() {
    final days = twoDigits(timeLeft.inDays);
    final hours = twoDigits(timeLeft.inHours.remainder(24));
    final minutes = twoDigits(timeLeft.inMinutes.remainder(60));
    final seconds = twoDigits(timeLeft.inSeconds.remainder(60));

    return Row(

      children: [
        buildTimeCard(time: days, header: 'DAYS'.tr),
        buildTimeCard(time: hours, header: 'HOURS'.tr),
        buildTimeCard(time: minutes, header: 'MIN'.tr),
        // const SizedBox(width: 12),
        // buildTimeCard(time: seconds, header: 'SEC'),
      ],
    );
  }

  Widget buildTimeCard({required String time, required String header}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8,right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              time,
              style:  TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: getFontSize(11),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(header, style:  TextStyle(color: Colors.white,fontSize: getFontSize(10))),
        ],
      ),
    );
  }
}
