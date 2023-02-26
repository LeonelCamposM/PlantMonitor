import 'dart:async';
import 'dart:convert';
import 'package:app_settings/app_settings.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/measure.dart';
import 'package:plant_monitor/infraestructure/users_measures_repo.dart';
import 'package:plant_monitor/presentation/core/size_config.dart';
import 'package:plant_monitor/presentation/core/text.dart';
import 'package:plant_monitor/presentation/dashboard/circular_chart.dart';

// ignore: must_be_immutable
class APSensorRepo extends StatefulWidget {
  APSensorRepo({
    Key? key,
    required this.measureLimits,
  }) : super(key: key);
  MeasureLimit measureLimits;

  @override
  State<APSensorRepo> createState() => _APSensorMeasureRepoState();
}

class _APSensorMeasureRepoState extends State<APSensorRepo> {
  Measure sensorMeasure = Measure(0, 0);
  Timer? timer;
  bool conected = false;
  int counter = 0;

  void getUpdatedValue() async {
    try {
      final response = await http
          .get(
        Uri.parse('http://192.168.1.22:80/getSensorData'),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      print(response);
      if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        setState(() {
          print(counter);
          counter = 0;
          conected = true;
          sensorMeasure = Measure.fromJson(map);
        });
      } else {
        counter += 1;
        if (counter > 5) {
          print(counter);
          setState(() {
            conected = false;
          });
        }
      }
    } catch (e) {
      counter += 1;
      if (counter > 5) {
        print(counter);
        setState(() {
          conected = false;
        });
      }
    }
  }

  @override
  void initState() {
    getUpdatedValue();
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => getUpdatedValue());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        conected == true
            ? ConectedDashboard(
                currentMeassure: sensorMeasure,
              )
            : const DisconectedDashboard(),
      ],
    );
  }
}

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
        SizedBox(
          height: SizeConfig.blockSizeHorizontal * 4,
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
                                  AppSettings.openWIFISettings(callback: () {
                                    print("sample callback function called");
                                  })
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

  ConectedDashboard({super.key, required this.currentMeassure});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircularChartCard(
          sensorMeasure: currentMeassure,
          limit: MeasureLimit(99, 10),
        ),
        SizedBox(
          height: SizeConfig.blockSizeHorizontal * 12,
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
                      onPressed: (() => {addMeasure(currentMeassure)}),
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
