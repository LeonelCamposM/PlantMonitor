import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/sensor_measure.dart';
import 'package:plant_monitor/presentation/core/size_config.dart';
import 'package:plant_monitor/presentation/core/text.dart';
import 'package:plant_monitor/presentation/measures/date_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/date_symbol_data_local.dart';

// ignore: must_be_immutable
class MeasuresChart extends StatelessWidget {
  final List<ChartData> chartData = [];
  bool oneDay = false;
  bool oneMonth = false;

  MeasuresChart({super.key, required this.measures}) {
    initializeDateFormatting();
    List<DateTime> days = [];
    for (var element in measures) {
      DateTime date = DateTime.parse(element.date);
      chartData.add(ChartData(date, element.humidity.toDouble()));
      days.add(date);
    }
    chartData.sort((a, b) {
      return a.x.compareTo(b.x);
    });
    oneDay = sameDay(days);
    oneMonth = isSameMonth(days);
  }

  bool sameDay(List<DateTime> fechas) {
    DateTime primerDia = fechas[0].toLocal();
    int dia = primerDia.day;

    for (int i = 1; i < fechas.length; i++) {
      DateTime fecha = fechas[i].toLocal();
      if (fecha.day != dia) {
        return false;
      }
    }

    return true;
  }

  bool isSameMonth(List<DateTime> dates) {
    if (dates.isEmpty) {
      return false;
    }

    final firstDate = dates.first;

    for (final date in dates) {
      if (date.month != firstDate.month || date.year != firstDate.year) {
        return false;
      }
    }

    return true;
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
            child: oneDay == true
                ? SfCartesianChart(
                    tooltipBehavior: tooltipBehavior,
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
                  )
                : oneMonth == false
                    ? SfCartesianChart(
                        legend: Legend(
                          isVisible: true,
                        ),
                        tooltipBehavior: tooltipBehavior,
                        primaryXAxis: DateTimeAxis(
                            rangePadding: ChartRangePadding.additional,
                            dateFormat: DateFormat('dd MMMM', 'es')),
                        primaryYAxis: NumericAxis(
                            labelFormat: '{value}%', borderColor: Colors.blue),
                        series: <ChartSeries<ChartData, DateTime>>[
                          LineSeries<ChartData, DateTime>(
                              name: "Humedad del suelo ",
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y),
                        ],
                      )
                    : SfCartesianChart(
                        tooltipBehavior: tooltipBehavior,
                        primaryXAxis: DateTimeAxis(
                            rangePadding: ChartRangePadding.additional,
                            dateFormat: DateFormat('dd/MM/yyyy')),
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
                  getBodyText("27/2/2023", false),
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
                  getBodyText("27/2/2023", false),
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
                  padding: const EdgeInsets.only(bottom: 10, right: 10),
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
