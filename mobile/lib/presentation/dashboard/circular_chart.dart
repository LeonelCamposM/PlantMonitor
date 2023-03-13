import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/sensor_measure.dart';
import 'package:plant_monitor/presentation/core/text.dart';

// ignore: must_be_immutable
class CircularChartCard extends StatelessWidget {
  CircularChartCard(
      {super.key, required this.sensorMeasure, required this.limit});
  Measure sensorMeasure;
  MeasureLimit limit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          limit.max > sensorMeasure.humidity &&
                  limit.min < sensorMeasure.humidity
              ? PercentageWidget(
                  percentaje: sensorMeasure.humidity.toDouble(),
                  title: "Humedad",
                  barColor: Colors.lightBlue,
                )
              : PercentageWidget(
                  percentaje: sensorMeasure.humidity.toDouble(),
                  title: "Humedad",
                  barColor: Colors.red,
                ),
          10 < sensorMeasure.battery
              ? PercentageWidget(
                  percentaje: sensorMeasure.battery.toDouble(),
                  title: "Batería",
                  barColor: const Color.fromARGB(255, 236, 213, 3),
                )
              : PercentageWidget(
                  percentaje: sensorMeasure.battery.toDouble(),
                  title: "Batería",
                  barColor: Colors.red,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: barColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: title == "Humedad"
                ? const Icon(color: Colors.white, Icons.water_drop)
                : title == "Temperatura"
                    ? const Icon(color: Colors.white, Icons.device_thermostat)
                    : const Icon(color: Colors.white, Icons.battery_5_bar),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getBodyText(title, false),
              Row(
                children: [getBodyText("${percentaje.ceil()} %", false)],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
