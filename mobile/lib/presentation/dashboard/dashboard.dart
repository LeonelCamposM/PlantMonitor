import 'package:flutter/material.dart';
import 'package:mobile/domain/sensor_measure.dart';
import 'package:mobile/presentation/dashboard/percentage_widget.dart';

// ignore: must_be_immutable
class Dashboard extends StatelessWidget {
  Dashboard({super.key, required this.sensorMeasure});
  SensorMeasure sensorMeasure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PercentageWidget(
            percentaje: sensorMeasure.humidity.toDouble(),
            title: 'Humedad',
            barColor: Colors.lightBlue,
          ),
          PercentageWidget(
            percentaje: sensorMeasure.battery.toDouble(),
            title: 'Batería',
            barColor: Colors.yellow,
          ),
        ],
      ),
    );
  }
}
