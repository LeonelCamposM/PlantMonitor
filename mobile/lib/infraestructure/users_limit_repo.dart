import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/measure.dart';
import 'package:plant_monitor/infraestructure/ap_sensor_repo.dart';
import 'package:plant_monitor/presentation/settings/settings.dart';

MeasureLimit getUpdatedLimit(AsyncSnapshot<DatabaseEvent> snapshot) {
  MeasureLimit limit = MeasureLimit(0, 0);
  if (snapshot.hasData) {
    Map<dynamic, dynamic> map =
        snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
    limit = MeasureLimit.fromJson(map);
  }
  return limit;
}

void updateUserLimits(double min, double max) async {
  DatabaseReference minRef =
      FirebaseDatabase.instance.ref("users/leonel/humidityLimit/min");
  DatabaseReference maxRef =
      FirebaseDatabase.instance.ref("users/leonel/humidityLimit/max");
  minRef.set(min);
  maxRef.set(max);
}

// ignore: must_be_immutable
class SensorMeasureWidget extends StatelessWidget {
  SensorMeasureWidget({Key? key}) : super(key: key);
  DatabaseReference starCountRef =
      FirebaseDatabase.instance.ref("users/leonel/humidityLimit");

  @override
  Widget build(BuildContext context) {
    starCountRef.keepSynced(true);
    return StreamBuilder(
      stream: starCountRef.onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) {
          return const Text('');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        }

        MeasureLimit limit = getUpdatedLimit(snapshot);
        return APSensorRepo(
          measureLimits: limit,
        );
      },
    );
  }
}

// ignore: must_be_immutable
class FirebaseAlertsWidget extends StatelessWidget {
  FirebaseAlertsWidget({Key? key}) : super(key: key);
  DatabaseReference starCountRef =
      FirebaseDatabase.instance.ref("users/leonel/humidityLimit");

  @override
  Widget build(BuildContext context) {
    starCountRef.keepSynced(true);
    return StreamBuilder(
      stream: starCountRef.onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) {
          return const Text('');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        }

        MeasureLimit limit = getUpdatedLimit(snapshot);
        return AlertSettings(
          limit: limit,
        );
      },
    );
  }
}
