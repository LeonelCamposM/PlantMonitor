import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/sensor_measure.dart';
import 'package:plant_monitor/presentation/measures/measures_chart.dart';

void addMeasure(Measure measure) async {
  DatabaseReference measuresRef =
      FirebaseDatabase.instance.ref("users/leonel/measures/");

  UserMeasure userMeasure =
      UserMeasure(measure.battery, DateTime.now().toString(), measure.humidity);
  await measuresRef.push().set(userMeasure.toJson());
}

class UserMeasuresChart extends StatelessWidget {
  UserMeasuresChart({
    Key? key,
  }) : super(key: key);
  DatabaseReference humididtyLimitRef =
      FirebaseDatabase.instance.ref("users/leonel/measures");

  List<UserMeasure> getMeasures(AsyncSnapshot<DatabaseEvent> snapshot) {
    List<UserMeasure> measures = [];
    if (snapshot.hasData) {
      Map<dynamic, dynamic> map =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
      for (var element in map.keys) {
        measures.add(UserMeasure.fromJson(map[element]));
      }
    }
    return measures;
  }

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

        List<UserMeasure> measures = getMeasures(snapshot);
        return MeasuresChart(
          measures: measures,
        );
      },
    );
  }
}
