import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile/domain/measure.dart';
import 'package:mobile/infraestructure/ap_sensor_measure_widget.dart';

// ignore: must_be_immutable
class WifiSensorMeasureWidget extends StatelessWidget {
  WifiSensorMeasureWidget({Key? key}) : super(key: key);
  DatabaseReference starCountRef =
      FirebaseDatabase.instance.ref("users/leonel/humidityLimit");

  MeasureLimit getUpdatedValue(AsyncSnapshot<DatabaseEvent> snapshot) {
    MeasureLimit limit = MeasureLimit(0, 0);
    if (snapshot.hasData) {
      Map<dynamic, dynamic> map =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
      limit = MeasureLimit.fromJson(map);
    }
    return limit;
  }

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

        MeasureLimit limit = getUpdatedValue(snapshot);
        return APSensorMeasureWidget(
          measureLimits: limit,
        );
      },
    );
  }
}

void updateUserLimits(double min, double max) async {
  DatabaseReference minRef =
      FirebaseDatabase.instance.ref("users/leonel/humidityLimit/min");
  DatabaseReference maxRef =
      FirebaseDatabase.instance.ref("users/leonel/humidityLimit/max");
  minRef.set(min);
  maxRef.set(max);
}
