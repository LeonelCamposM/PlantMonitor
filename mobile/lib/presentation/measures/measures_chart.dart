import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/sensor_measure.dart';
import 'package:plant_monitor/presentation/core/size_config.dart';
import 'package:plant_monitor/presentation/core/text.dart';
import 'package:plant_monitor/presentation/measures/date_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class MeasuresChart extends StatelessWidget {
  final List<ChartData> chartData = [];

  MeasuresChart({super.key, required this.measures}) {
    for (var element in measures) {
      DateTime date = DateTime.parse(element.date);
      chartData.add(ChartData(date, element.humidity.toDouble()));
    }
    chartData.sort((a, b) {
      return a.x.compareTo(b.x);
    });
  }

  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
  List<UserMeasure> measures;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            width: SizeConfig.blockSizeHorizontal * 90,
            height: SizeConfig.blockSizeVertical * 50,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                  rangePadding: ChartRangePadding.additional,
                  dateFormat: DateFormat.jm()),
              primaryYAxis: NumericAxis(
                  labelFormat: '{value}%', borderColor: Colors.blue),
              series: <ChartSeries<ChartData, DateTime>>[
                LineSeries<ChartData, DateTime>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y),
              ],
            )),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 5,
              ),
              Column(
                children: [
                  getBodyText("20/2/2023", false),
                  SizedBox(
                      height: SizeConfig.blockSizeVertical * 10,
                      width: SizeConfig.blockSizeHorizontal * 20,
                      child: const DatePicker(
                        restorationId: 'main',
                        text: 'Desde',
                      )),
                ],
              ),
              Column(
                children: [
                  getBodyText("20/2/2023", false),
                  SizedBox(
                      height: SizeConfig.blockSizeVertical * 10,
                      width: SizeConfig.blockSizeHorizontal * 20,
                      child: const DatePicker(
                        restorationId: 'main',
                        text: 'Hasta',
                      )),
                ],
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 5,
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 14,
                    height: SizeConfig.blockSizeHorizontal * 14,
                    child: FloatingActionButton(
                      onPressed: (() => {}),
                      child: Icon(
                        size: SizeConfig.blockSizeHorizontal * 8,
                        Icons.update,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
