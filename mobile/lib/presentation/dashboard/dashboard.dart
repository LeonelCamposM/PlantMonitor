import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/measure.dart';
import 'package:plant_monitor/infraestructure/users_measures_repo.dart';
import 'package:plant_monitor/presentation/core/size_config.dart';
import 'package:plant_monitor/presentation/core/text.dart';
import 'package:plant_monitor/presentation/dashboard/circular_chart.dart';
import 'package:environment_sensors/environment_sensors.dart';

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
class ConectedDashboard extends StatefulWidget {
  Measure currentMeassure;
  MeasureLimit measureLimits;

  ConectedDashboard(
      {super.key, required this.currentMeassure, required this.measureLimits});

  @override
  State<ConectedDashboard> createState() => _ConectedDashboardState();
}

class _ConectedDashboardState extends State<ConectedDashboard> {
  bool lightAvailable = true;

  final environmentSensors = EnvironmentSensors();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool lightAvailable;

    lightAvailable =
        await environmentSensors.getSensorAvailable(SensorType.Light);

    setState(() {
      lightAvailable = lightAvailable;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // (lightAvailable)
        //     ? StreamBuilder<double>(
        //         stream: environmentSensors.light,
        //         builder: (context, snapshot) {
        //           if (!snapshot.hasData) {
        //             return const CircularProgressIndicator();
        //           }
        //           return Text(
        //               'Luz detectada: ${snapshot.data?.toStringAsFixed(2)} lx');
        //         })
        //     : const Text('No light sensor found'),
        CircularChartCard(
          sensorMeasure: widget.currentMeassure,
          limit: widget.measureLimits,
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
                            addMeasure(widget.currentMeassure),
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
