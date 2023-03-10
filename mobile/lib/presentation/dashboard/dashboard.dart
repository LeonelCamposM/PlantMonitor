import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/sensor_measure.dart';
import 'package:plant_monitor/infraestructure/users_measures_repo.dart';
import 'package:plant_monitor/presentation/core/size_config.dart';
import 'package:plant_monitor/presentation/core/text.dart';
import 'package:plant_monitor/presentation/dashboard/circular_chart.dart';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
            SizeConfig.blockSizeVertical <= 8.1
                ? SizedBox(
                    height: SizeConfig.blockSizeVertical * 65,
                  )
                : SizedBox(
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
  List<Measure> measures = [];

  Future<List<Measure>> getNewMeasures() async {
    print("new");
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.22:80/getAllData'),
      );
      if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        print(map);
      }
    } catch (e) {
      print("catch");
      print(e);
    }
    return [];
  }

  void onPressed(context) async {
    measures = await getNewMeasures();
    for (var element in measures) {
      addMeasure(element);
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Mediciónes recolectadas'),
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircularChartCard(
              sensorMeasure: widget.currentMeassure,
              limit: widget.measureLimits,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 14,
                      height: SizeConfig.blockSizeHorizontal * 14,
                      child: FloatingActionButton(
                        onPressed: (() => {onPressed(context)}),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
