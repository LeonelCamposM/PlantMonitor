import 'package:d_chart/d_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_monitor/presentation/core/size_config.dart';

class measuresChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: SizeConfig.blockSizeHorizontal * 100,
            height: SizeConfig.blockSizeVertical * 50,
            child: DChartLine(
              includePoints: true,
              includeArea: true,
              data: const [
                {
                  'id': 'Line',
                  'data': [
                    {'domain': 0, 'measure': 4.1},
                    {'domain': 2, 'measure': 4},
                    {'domain': 3, 'measure': 6},
                    {'domain': 4, 'measure': 1},
                  ],
                },
              ],
              lineColor: (lineData, index, id) => Colors.green,
            )),
      ],
    );
  }
}
