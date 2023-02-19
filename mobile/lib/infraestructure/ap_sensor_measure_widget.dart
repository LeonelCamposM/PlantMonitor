import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobile/domain/measure.dart';
import 'package:mobile/presentation/sensors/circular_chart.dart';

// ignore: must_be_immutable
class APSensorMeasureWidget extends StatefulWidget {
  APSensorMeasureWidget({Key? key, required this.measureLimits})
      : super(key: key);
  MeasureLimit measureLimits;

  @override
  State<APSensorMeasureWidget> createState() => _APSensorMeasureWidgetState();
}

class _APSensorMeasureWidgetState extends State<APSensorMeasureWidget> {
  Measure sensorMeasure = Measure(0, 0);
  Timer? timer;

  void getUpdatedValue() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.22:80/getSensorData'),
    );
    if (response.statusCode == 200) {
      Map map = json.decode(response.body);
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
