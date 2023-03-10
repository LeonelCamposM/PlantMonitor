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
  Measure sensorMeasure = Measure(0, 0);
  Timer? timer;
  bool conected = false;
  int counter = 0;

  void getUpdatedValue() async {
    try {
      final response = await http
          .get(
        Uri.parse('http://192.168.1.22:80/getLimits'),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return http.Response('Error', 408);
        },
      );
      if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        setState(() {
          counter = 0;
          conected = true;
          sensorMeasure = Measure.fromJson(map);
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        conected == true
            ? ConectedDashboard(
                currentMeassure: sensorMeasure,
                measureLimits: widget.measureLimits)
            : const DisconectedDashboard(),
      ],
    );
  }
}
