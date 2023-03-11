import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/sensor_measure.dart';
import 'package:plant_monitor/presentation/core/text.dart';
import 'package:plant_monitor/presentation/measures/measures_chart.dart';

void addMeasure(Measure measure) async {
  DatabaseReference measuresRef =
      FirebaseDatabase.instance.ref("users/leonel/measures/");
  await measuresRef.push().set(measure.toJson());
}

void addLastMeasure(Measure measure) async {
  DatabaseReference measuresRef =
      FirebaseDatabase.instance.ref("users/leonel/lastMeasure/");
  await measuresRef.set(measure.toJson());
}

Future<Measure?> getLastMeasure() async {
  Measure? lastMeasure = Measure(0, 0, 0, 0, 0, DateTime.now());
  final measuresRef = FirebaseDatabase.instance.ref();
  final snapshot = await measuresRef.child('users/leonel/lastMeasure/').get();
  if (snapshot.exists) {
    print(snapshot.value);
    lastMeasure = snapshot.value as Measure?;
  }
  return lastMeasure;
}

// ignore: must_be_immutable
class UserMeasuresChart extends StatelessWidget {
  UserMeasuresChart({
    Key? key,
  }) : super(key: key);
  DatabaseReference humididtyLimitRef =
      FirebaseDatabase.instance.ref("users/leonel/measures");

  List<UserMeasure> getMeasures(AsyncSnapshot<DatabaseEvent> snapshot) {
    List<UserMeasure> measures = [];
    if (snapshot.hasData) {
      if (snapshot.data!.snapshot.value != null) {
        Map<dynamic, dynamic> map =
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        for (var element in map.keys) {
          measures.add(UserMeasure.fromJson(map[element]));
        }
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
        return measures.isNotEmpty
            ? MeasuresChart(
                measures: measures,
              )
            : Center(child: getTitleText("No tiene mediciones", false));
      },
    );
  }
}
