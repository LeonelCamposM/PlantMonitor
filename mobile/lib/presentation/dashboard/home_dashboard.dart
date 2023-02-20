import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/measure.dart';
import 'package:plant_monitor/infraestructure/users_limit_repo.dart';
import 'package:plant_monitor/infraestructure/users_measures_repo.dart';
import 'package:plant_monitor/presentation/core/size_config.dart';

class HomeDashBoard extends StatelessWidget {
  const HomeDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: SizeConfig.blockSizeVertical * 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [SensorMeasureWidget()],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 10,
            ),
          ],
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
                      onPressed: (() => {addMeasure(Measure(23, 67))}),
                      child: Icon(
                        size: SizeConfig.blockSizeHorizontal * 6,
                        Icons.save,
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
