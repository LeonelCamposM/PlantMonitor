import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile/domain/measure.dart';
import 'package:mobile/domain/sensor.dart';
import 'package:mobile/presentation/dashboard/verticalList.dart';
import 'package:mobile/presentation/home.dart';

// ignore: must_be_immutable
class WifiSensorMeasureWidget extends StatelessWidget {
  WifiSensorMeasureWidget({Key? key, required this.callback}) : super(key: key);
  Sensor sensor = Sensor(<Measure>[], "", "", "");
  DatabaseReference starCountRef =
      FirebaseDatabase.instance.ref("users/leonel");
  final Function callback;

  List<Sensor> getUpdatedValue(AsyncSnapshot<DatabaseEvent> snapshot) {
    List<Sensor> userSensors = [];
    String date = "";
    String time = "";
    if (snapshot.hasData) {
      Map<dynamic, dynamic> map =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
      for (dynamic key in map.keys) {
        List<Measure> measures = [];
        Map<dynamic, dynamic> mapMeasures = map[key] as Map<dynamic, dynamic>;
        for (dynamic measureKey in mapMeasures.keys) {
          if (measureKey == "Fecha") {
            date = mapMeasures[measureKey];
          }
          switch (measureKey) {
            case "Fecha":
              date = mapMeasures[measureKey];
              break;
            case "Hora":
              time = mapMeasures[measureKey];
              break;
            default:
              measures.add(Measure(measureKey, mapMeasures[measureKey]));
              break;
          }
        }

        userSensors.add(Sensor(measures, key, date, time));
      }
    }
    return userSensors;
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

        List<Sensor> newValue = getUpdatedValue(snapshot);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: getSensorVerticalList(newValue, context, callback),
        );
      },
    );
  }
}
