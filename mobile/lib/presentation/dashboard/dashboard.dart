import 'package:flutter/material.dart';
import 'package:mobile/domain/soil_meassure.dart';
import 'package:mobile/presentation/dashboard/percentage_widget.dart';

// ignore: must_be_immutable
class Dashboard extends StatelessWidget {
  Dashboard({super.key, required this.soilMeasure});
  SoilMeasure soilMeasure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PercentageWidget(
            percentaje: soilMeasure.humidity.toDouble(),
            title: 'Humedad',
            barColor: Colors.lightBlue,
          ),
          PercentageWidget(
            percentaje: soilMeasure.battery.toDouble(),
            title: 'Batería',
            barColor: Colors.yellow,
          ),
        ],
      ),
    );
  }
}
