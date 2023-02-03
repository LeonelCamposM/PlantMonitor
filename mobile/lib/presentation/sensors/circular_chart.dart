import 'package:flutter/material.dart';
import 'package:mobile/domain/measure.dart';
import 'package:mobile/presentation/core/text.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// ignore: must_be_immutable
class CircularChartCard extends StatelessWidget {
  CircularChartCard({super.key, required this.sensorMeasure});
  Measure sensorMeasure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          sensorMeasure.name == "Batería"
              ? PercentageWidget(
                  percentaje: sensorMeasure.value.toDouble(),
                  title: sensorMeasure.name,
                  barColor: Colors.yellow,
                )
              : sensorMeasure.name == "Humedad"
                  ? PercentageWidget(
                      percentaje: sensorMeasure.value.toDouble(),
                      title: sensorMeasure.name,
                      barColor: Colors.lightBlue,
                    )
                  : sensorMeasure.name == "Presión"
                      ? PercentageWidget(
                          percentaje: sensorMeasure.value.toDouble(),
                          title: sensorMeasure.name,
                          barColor: Colors.orangeAccent,
                        )
                      : PercentageWidget(
                          percentaje: sensorMeasure.value.toDouble(),
                          title: sensorMeasure.name,
                          barColor: Colors.purple,
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
            child: getTitleText(title, false),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularPercentIndicator(
              animation: true,
              animationDuration: 1000,
              radius: 90.0,
              lineWidth: 25,
              percent: percentaje / 100,
              progressColor: barColor,
              circularStrokeCap: CircularStrokeCap.round,
              center: getTitleText("$text%", false),
            ),
          ),
        ],
      ),
    );
  }
}
