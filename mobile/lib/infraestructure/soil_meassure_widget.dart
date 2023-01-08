import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile/domain/soil_meassure.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:percent_indicator/circular_percent_indicator.dart';

// ignore: must_be_immutable
class SoilMeassureWidget extends StatelessWidget {
  SoilMeassureWidget({Key? key}) : super(key: key);
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
        soilMeassure = newValue;

        return Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              PercentageWidget(
                percentaje: newValue.humidity.toDouble(),
                title: 'Humedad',
                barColor: Colors.lightBlue,
              ),
              PercentageWidget(
                percentaje: (newValue.humidity.toDouble() + 30) % 100,
                title: 'Batería',
                barColor: Colors.yellow,
              ),
            ],
          ),
        );
      },
    );
  }
}

class PercentageWidget extends StatelessWidget {
  double percentaje;
  String text = "";
  String title = "";
  Color barColor;

  PercentageWidget(
      {super.key,
      required this.percentaje,
      required this.title,
      required this.barColor}) {
    text = percentaje.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // ignore: prefer_const_constructors
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: const TextStyle(fontSize: 25)),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularPercentIndicator(
              animation: true,
              animationDuration: 1000,
              radius: 80.0,
              lineWidth: 25,
              percent: percentaje / 100,
              progressColor: barColor,
              circularStrokeCap: CircularStrokeCap.round,
              center: Text("$text%", style: const TextStyle(fontSize: 30)),
            ),
          ),
        ],
      ),
    );
  }
}
