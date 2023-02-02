import 'package:flutter/material.dart';
import 'package:mobile/domain/measure.dart';
import 'package:mobile/presentation/dashboard/percentage_widget.dart';

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
