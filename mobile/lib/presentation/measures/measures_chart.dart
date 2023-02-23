import 'package:flutter/material.dart';
import 'package:plant_monitor/presentation/core/size_config.dart';
import 'package:plant_monitor/presentation/core/text.dart';
import 'package:plant_monitor/presentation/measures/date_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MeasuresChart extends StatelessWidget {
  MeasuresChart({super.key});
  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);

  final List<ChartData> chartData = <ChartData>[
    ChartData(1, 24),
    ChartData(2, 23),
    ChartData(3, 22),
    ChartData(4, 21),
    ChartData(5, 80),
    ChartData(6, 79),
    ChartData(7, 77),
    ChartData(8, 75),
    ChartData(9, 73),
    ChartData(10, 68),
    ChartData(11, 65),
    ChartData(12, 63),
  ];

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
                tooltipBehavior: tooltipBehavior,
                legend: Legend(isVisible: true),
                title: ChartTitle(text: "Humedad de suelo el Lunes"),
                primaryXAxis: NumericAxis(
                    labelFormat: '{value} a.m',
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    borderColor: Colors.blue),
                primaryYAxis: NumericAxis(
                    labelFormat: '{value}%',
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    borderColor: Colors.blue),
                series: <ChartSeries<ChartData, int>>[
                  LineSeries<ChartData, int>(
                    name: "Humedad del suelo",
                    dataSource: chartData,
                    enableTooltip: true,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                  )
                ])),
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
  final int x;
  final int y;
}
