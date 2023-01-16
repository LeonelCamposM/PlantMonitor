import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile/domain/soil_meassure.dart';
import 'package:mobile/presentation/dashboard/dashboard.dart';

// ignore: must_be_immutable
class WifiSoilMoistureWidget extends StatelessWidget {
  WifiSoilMoistureWidget({Key? key}) : super(key: key);
  SoilMeasure soilMeasure = SoilMeasure(0, "", 0);
  DatabaseReference starCountRef =
      FirebaseDatabase.instance.ref("users/208210896");

  SoilMeasure getUpdatedValue(AsyncSnapshot<DatabaseEvent> snapshot) {
    SoilMeasure soilMeasure = SoilMeasure(0, "", 0);
    if (snapshot.hasData) {
      Map<dynamic, dynamic> map =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
      soilMeasure = SoilMeasure.fromJson(map);
    }
    return soilMeasure;
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
        SoilMeasure newValue = getUpdatedValue(snapshot);
        soilMeasure = newValue;

        return Dashboard(soilMeasure: soilMeasure);
      },
    );
  }
}
