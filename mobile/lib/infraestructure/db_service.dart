import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile/domain/soil_meassure.dart';

// ignore: must_be_immutable
class Meassure extends StatelessWidget {
  Meassure({Key? key}) : super(key: key);
  SoilMeassure soilMeassure = SoilMeassure(0, "");
  DatabaseReference starCountRef =
      FirebaseDatabase.instance.ref("users/208210896");

  SoilMeassure getUpdatedValue(AsyncSnapshot<DatabaseEvent> snapshot) {
    SoilMeassure soilMeassure = SoilMeassure(0, "");
    if (snapshot.hasData) {
      Map<dynamic, dynamic> map =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
      soilMeassure = SoilMeassure.fromJson(map);
    }
    return soilMeassure;
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
        SoilMeassure newValue = getUpdatedValue(snapshot);
        return Text("${newValue.date} ${newValue.humidity}");
      },
    );
  }
}
