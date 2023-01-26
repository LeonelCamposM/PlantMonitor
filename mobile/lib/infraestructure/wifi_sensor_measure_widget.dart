import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile/domain/sensor_measure.dart';
import 'package:mobile/presentation/dashboard/dashboard.dart';

// ignore: must_be_immutable
class WifiSensorMeasureWidget extends StatelessWidget {
  WifiSensorMeasureWidget({Key? key}) : super(key: key);
  SensorMeasure sensorMeasure = SensorMeasure(0, "", 0);
  DatabaseReference starCountRef =
      FirebaseDatabase.instance.ref("users/208210896");

  SensorMeasure getUpdatedValue(AsyncSnapshot<DatabaseEvent> snapshot) {
    SensorMeasure sensorMeasure = SensorMeasure(0, "", 0);
    if (snapshot.hasData) {
      Map<dynamic, dynamic> map =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
      sensorMeasure = SensorMeasure.fromJson(map);
    }
    return sensorMeasure;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: starCountRef.onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) {
          return const Text('');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        }
        SensorMeasure newValue = getUpdatedValue(snapshot);
        sensorMeasure = newValue;

        return Dashboard(sensorMeasure: sensorMeasure);
      },
    );
  }
}
