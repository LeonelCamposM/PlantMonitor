// ignore: must_be_immutable
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/domain/measure.dart';
import 'package:mobile/presentation/core/size_config.dart';
import 'package:mobile/presentation/sensors/circular_chart.dart';

// ignore: must_be_immutable
class MeasuresList extends StatelessWidget {
  List<Measure> sensorMeasures;
  MeasuresList({super.key, required this.sensorMeasures});

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.blockSizeVertical * 100;
    double width = SizeConfig.blockSizeHorizontal * 60;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: height,
        width: width,
        child: ListView(
            scrollDirection: Axis.vertical,
            children: List.generate(
              sensorMeasures.length,
              (index) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  kIsWeb == true
                      ? sensorMeasures[index].value is double
                          ? CircularChartCard(
                              sensorMeasure: sensorMeasures[index],
                            )
                          : const Text("")
                      : sensorMeasures[index].value is double
                          ? const Text("")
                          : CircularChartCard(
                              sensorMeasure: sensorMeasures[index],
                            )
                ],
              ),
            )),
      ),
    );
  }
}
