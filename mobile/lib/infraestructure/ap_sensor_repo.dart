import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/sensor_measure.dart';
import 'package:plant_monitor/presentation/dashboard/dashboard.dart';

// ignore: must_be_immutable
class APSensorRepo extends StatefulWidget {
  APSensorRepo({
    Key? key,
    required this.measureLimits,
  }) : super(key: key);
  MeasureLimit measureLimits;

  @override
  State<APSensorRepo> createState() => APSensorMeasureRepoState();
}

class APSensorMeasureRepoState extends State<APSensorRepo> {
  Measure sensorMeasure = Measure(0, 0, 0, 0, 0, DateTime.now());
  Timer? timer;
  bool conected = false;
  int counter = 0;

  void getUpdatedValue() async {
    try {
      final response = await http
          .get(
        Uri.parse('http://192.168.1.22:80/getName'),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          counter = 0;
          conected = true;
        });
      } else {
        counter += 1;
        if (counter > 5) {
          setState(() {
            conected = false;
          });
        }
      }
    } catch (e) {
      counter += 1;
      if (counter > 5) {
        setState(() {
          conected = false;
        });
      }
    }
  }

  @override
  void initState() {
    getUpdatedValue();
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => getUpdatedValue());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        conected == false
            ? ConectedDashboard(
                currentMeassure: sensorMeasure,
                measureLimits: widget.measureLimits)
            : const DisconectedDashboard(),
      ],
    );
  }
}
