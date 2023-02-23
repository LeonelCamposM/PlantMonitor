import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/measure.dart';
import 'package:plant_monitor/infraestructure/users_limit_repo.dart';
import 'package:plant_monitor/infraestructure/users_measures_repo.dart';
import 'package:plant_monitor/presentation/core/size_config.dart';

class HomeDashBoard extends StatefulWidget {
  const HomeDashBoard({super.key});

  @override
  State<HomeDashBoard> createState() => _HomeDashBoardState();
}

class _HomeDashBoardState extends State<HomeDashBoard> {
  Measure currentMeassure = Measure(0, 0);

  void updateMeassure(Measure newMeassure) {
    currentMeassure = newMeassure;
  }

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
              children: [
                SensorMeasureWidget(
                  updateMeassure: updateMeassure,
                )
              ],
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
                      onPressed: (() => {addMeasure(currentMeassure)}),
                      child: Icon(
                        size: SizeConfig.blockSizeHorizontal * 8,
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
