import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile/domain/soil_meassure.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;

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

class APSoilMeassureWidget extends StatefulWidget {
  const APSoilMeassureWidget({Key? key}) : super(key: key);

  @override
  State<APSoilMeassureWidget> createState() => _APSoilMeassureWidgetState();
}

class _APSoilMeassureWidgetState extends State<APSoilMeassureWidget> {
  SoilMeassure soilMeassure = SoilMeassure(0, "");
  Timer? timer;

  void getUpdatedValue() async {
    print("data");
    final response = await http.get(
      Uri.parse('http://192.168.1.22:80/getSensorData'),
    );
    if (response.statusCode == 200) {
      Map map = json.decode(response.body);
      setState(() {
        soilMeassure = SoilMeassure.fromJson(map);
      });
    } else {}
  }

  @override
  void initState() {
    getUpdatedValue();
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => getUpdatedValue());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PercentageWidget(
            percentaje: soilMeassure.humidity.toDouble(),
            title: 'Humedad',
            barColor: Colors.lightBlue,
          ),
          PercentageWidget(
            percentaje: (soilMeassure.humidity.toDouble() + 30) % 100,
            title: 'Batería',
            barColor: Colors.yellow,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
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
