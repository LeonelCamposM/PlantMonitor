// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:mobile/domain/measure.dart';
// import 'package:mobile/presentation/dashboard/dashboard.dart';

// class APSensorMeasureWidget extends StatefulWidget {
//   const APSensorMeasureWidget({Key? key}) : super(key: key);

//   @override
//   State<APSensorMeasureWidget> createState() => _APSensorMeasureWidgetState();
// }

// class _APSensorMeasureWidgetState extends State<APSensorMeasureWidget> {
//   SensorMeasure sensorMeasure = SensorMeasure(0, "", 0);
//   Timer? timer;

//   void getUpdatedValue() async {
//     final response = await http.get(
//       Uri.parse('http://192.168.1.22:80/getSensorData'),
//     );
//     if (response.statusCode == 200) {
//       Map map = json.decode(response.body);
//       setState(() {
//         sensorMeasure = SensorMeasure.fromJson(map);
//       });
//     }
//   }

//   @override
//   void initState() {
//     getUpdatedValue();
//     super.initState();
//     timer = Timer.periodic(
//         const Duration(seconds: 5), (Timer t) => getUpdatedValue());
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dashboard(
//       sensorMeasure: sensorMeasure,
//     );
//   }
// }
