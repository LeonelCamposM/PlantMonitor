import 'package:flutter/material.dart';
import 'package:mobile/domain/measure.dart';
import 'package:mobile/presentation/core/size_config.dart';
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

// ignore: must_be_immutable
class TextCard extends StatelessWidget {
  TextCard({super.key, required this.sensorMeasure});
  Measure sensorMeasure;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text(sensorMeasure.name, style: const TextStyle(fontSize: 25)),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
