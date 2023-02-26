import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/measure.dart';
import 'package:plant_monitor/infraestructure/ap_sensor_repo.dart';
import 'package:plant_monitor/infraestructure/users_limit_repo.dart';
import 'package:plant_monitor/presentation/core/size_config.dart';
import 'package:app_settings/app_settings.dart';

class HomeDashBoard extends StatefulWidget {
  const HomeDashBoard({super.key});

  @override
  State<HomeDashBoard> createState() => _HomeDashBoardState();
}

class _HomeDashBoardState extends State<HomeDashBoard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return APSensorRepo(
      measureLimits: MeasureLimit(99, 10),
    );
  }
}

// ignore: must_be_immutable
class ConectedDashboard extends StatelessWidget {
  Measure currentMeassure = Measure(0, 0);

  ConectedDashboard({super.key});

  void updateMeassure(Measure newMeassure) {
    currentMeassure = newMeassure;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SensorMeasureWidget(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 14,
                    height: SizeConfig.blockSizeHorizontal * 14,
                    child: FloatingActionButton(
                      onPressed: (() => {}),
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
                            AppSettings.openWIFISettings(callback: () {
                              print("sample callback function called");
                            }),
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
