import 'package:flutter/material.dart';
import 'package:plant_monitor/presentation/core/size_config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MeasuresChart extends StatelessWidget {
  MeasuresChart({super.key});
  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);

  final List<ChartData> chartData = <ChartData>[
    ChartData(1, 24),
    ChartData(2, 20),
    ChartData(3, 35),
    ChartData(4, 27),
    ChartData(5, 30),
    ChartData(6, 41),
    ChartData(7, 26)
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: SizeConfig.blockSizeHorizontal * 100,
            height: SizeConfig.blockSizeVertical * 80,
            child: SfCartesianChart(
                tooltipBehavior: tooltipBehavior,
                legend: Legend(isVisible: true),
                title: ChartTitle(text: "Humedad de suelo el Lunes"),
                primaryXAxis: NumericAxis(
                    labelFormat: '{value} p.m',
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
                ]))
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final int y;
}
