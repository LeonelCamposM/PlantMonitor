import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/measure.dart';
import 'package:plant_monitor/infraestructure/users_measures_repo.dart';
import 'package:plant_monitor/presentation/core/size_config.dart';
import 'package:plant_monitor/presentation/core/text.dart';
import 'package:plant_monitor/presentation/dashboard/circular_chart.dart';

class DisconectedDashboard extends StatelessWidget {
  const DisconectedDashboard({super.key});

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
                Column(
                  children: [
                    getTitleText("Sensor desconectado", false),
                  ],
                )
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 70,
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
                    child: Column(
                      children: [
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 14,
                          height: SizeConfig.blockSizeHorizontal * 14,
                          child: FloatingActionButton(
                            onPressed: (() => {
                                  AppSettings.openWIFISettings(callback: () {})
                                }),
                            child: Icon(
                              size: SizeConfig.blockSizeHorizontal * 8,
                              Icons.power,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ConectedDashboard extends StatelessWidget {
  Measure currentMeassure;
  MeasureLimit measureLimits;

  ConectedDashboard(
      {super.key, required this.currentMeassure, required this.measureLimits});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircularChartCard(
          sensorMeasure: currentMeassure,
          limit: measureLimits,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 20,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 14,
                    height: SizeConfig.blockSizeHorizontal * 14,
                    child: FloatingActionButton(
                      onPressed: (() => {
                            addMeasure(currentMeassure),
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Medición guardada'),
                            ))
                          }),
                      child: Icon(
                        size: SizeConfig.blockSizeHorizontal * 8,
                        Icons.save,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeHorizontal * 3,
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 14,
                    height: SizeConfig.blockSizeHorizontal * 14,
                    child: FloatingActionButton(
                      onPressed: (() => {
                            AppSettings.openWIFISettings(callback: () {}),
                          }),
                      child: Icon(
                        size: SizeConfig.blockSizeHorizontal * 8,
                        Icons.power_off,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
