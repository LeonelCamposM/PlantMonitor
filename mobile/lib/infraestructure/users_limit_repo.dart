import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/sensor_measure.dart';
import 'package:plant_monitor/infraestructure/ap_sensor_repo.dart';
import 'package:plant_monitor/presentation/settings/settings.dart';

Map<dynamic, dynamic> getUpdatedValues(AsyncSnapshot<DatabaseEvent> snapshot) {
  // check null todo
  Map<dynamic, dynamic> map = <dynamic, dynamic>{};
  if (snapshot.hasData) {
    map = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
    map["error"] = false;
  } else {
    map["error"] = true;
  }
  return map;
}

Measure getUpdatedMeasure(AsyncSnapshot<DatabaseEvent> snapshot) {
  Measure measure = Measure(0, 0, 0, 0, 0, DateTime.now());
  if (snapshot.hasData) {
    Map<dynamic, dynamic> map =
        snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
    measure = Measure.fromJson(map);
  }
  return measure;
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
  SensorMeasureWidget({
    Key? key,
  }) : super(key: key);
  DatabaseReference humididtyLimitRef =
      FirebaseDatabase.instance.ref("users/leonel");

  @override
  Widget build(BuildContext context) {
    humididtyLimitRef.keepSynced(true);
    return StreamBuilder(
      stream: humididtyLimitRef.onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) {
          return const Text('');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        }
        Measure measure = Measure(0, 0, 0, 0, 0, DateTime.now());
        MeasureLimit limit = MeasureLimit(0, 0);
        Map<dynamic, dynamic> map = getUpdatedValues(snapshot);
        if (map["error"] == true) {
        } else {
          measure = Measure.fromJson(map["lastMeasure"]);
          print("aaa" + measure.humidity.toString());
          limit = MeasureLimit.fromJson(map["humidityLimit"]);
        }

        return APSensorRepo(
          lastMeasure: measure,
          measureLimits: limit,
        );
      },
    );
  }
}

// ignore: must_be_immutable
class FirebaseAlertsWidget extends StatelessWidget {
  FirebaseAlertsWidget({
    Key? key,
  }) : super(key: key);
  DatabaseReference humididtyLimitRef =
      FirebaseDatabase.instance.ref("users/leonel");

  @override
  Widget build(BuildContext context) {
    humididtyLimitRef.keepSynced(true);
    return StreamBuilder(
      stream: humididtyLimitRef.onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) {
          return const Text('');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        }
        MeasureLimit limit = MeasureLimit(0, 0);
        Map<dynamic, dynamic> map = getUpdatedValues(snapshot);
        if (map["error"] == true) {
        } else {
          limit = MeasureLimit.fromJson(map["humidityLimit"]);
        }

        return AlertSettings(
          limit: limit,
        );
      },
    );
  }
}
