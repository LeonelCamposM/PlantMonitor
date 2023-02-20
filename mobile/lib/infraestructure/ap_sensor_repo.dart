import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/measure.dart';
import 'package:plant_monitor/presentation/dashboard/circular_chart.dart';

// ignore: must_be_immutable
class APSensorRepo extends StatefulWidget {
  APSensorRepo(
      {Key? key, required this.measureLimits, required this.updateMeassure})
      : super(key: key);
  MeasureLimit measureLimits;
  Function updateMeassure;

  @override
  State<APSensorRepo> createState() => _APSensorMeasureRepoState();
}

class _APSensorMeasureRepoState extends State<APSensorRepo> {
  Measure sensorMeasure = Measure(0, 0);
  Timer? timer;

  void getUpdatedValue() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.22:80/getSensorData'),
    );
    if (response.statusCode == 200) {
      Map map = json.decode(response.body);
      widget.updateMeassure(Measure.fromJson(map));
      setState(() {
        sensorMeasure = Measure.fromJson(map);
      });
    }
  }

  @override
  void initState() {
    getUpdatedValue();
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => getUpdatedValue());
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
        CircularChartCard(
          sensorMeasure: sensorMeasure,
          limit: widget.measureLimits,
        ),
      ],
    );
  }
}
