import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobile/domain/soil_meassure.dart';
import 'package:mobile/presentation/dashboard/dashboard.dart';

class APSoilMoistureWidget extends StatefulWidget {
  const APSoilMoistureWidget({Key? key}) : super(key: key);

  @override
  State<APSoilMoistureWidget> createState() => _APSoilMoistureWidgetState();
}

class _APSoilMoistureWidgetState extends State<APSoilMoistureWidget> {
  SoilMeasure soilMeasure = SoilMeasure(0, "", 0);
  Timer? timer;

  void getUpdatedValue() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.22:80/getSensorData'),
    );
    if (response.statusCode == 200) {
      Map map = json.decode(response.body);
      setState(() {
        soilMeasure = SoilMeasure.fromJson(map);
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
    return Dashboard(
      soilMeasure: soilMeasure,
    );
  }
}
