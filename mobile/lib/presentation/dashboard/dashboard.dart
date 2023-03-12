import 'dart:io';

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
  MeasureLimit measureLimits;
  Measure lastMeasure;
  ConectedDashboard(
      {super.key, required this.measureLimits, required this.lastMeasure});

  @override
  State<ConectedDashboard> createState() => _ConectedDashboardState();
}

class _ConectedDashboardState extends State<ConectedDashboard> {
  final environmentSensors = EnvironmentSensors();
  List<Measure> measures = [];
  Measure currentMeasure = Measure(0, 0, 0, 0, 0, DateTime.now());

  // Revisar si no hay mediciones nuevas y hay que buscar la ultima medicion de ese dia
  Future<List<Measure>> getNewMeasures() async {
    List<String> messages = [];
    // var httpClient = HttpClient();
    // print("cosnul");
    // var request =
    //     await httpClient.getUrl(Uri.parse('http://192.168.1.22:80/getAllData'));
    // var response = await request.close();
    // await for (var line
    //     in response.transform(utf8.decoder).transform(const LineSplitter())) {
    //   messages.add(line);
    // }
    // httpClient.close();

    List<Measure> measures = [];
    for (var message in messages) {
      message = message.replaceAll(";", "");
      Map map = jsonDecode(message);
      Measure measure = Measure.fromJson(map);
      measures.add(measure);
    }
    if (measures.isEmpty) {
      print(widget.lastMeasure.humidity);
      setState(() {
        currentMeasure = widget.lastMeasure;
      });
    } else {
      currentMeasure = measures.last;
      addLastMeasure(currentMeasure);
      setState(() {
        currentMeasure = currentMeasure;
      });
    }
    return measures;
  }

  void sendDeleteData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.22:80/deleteAllData'),
      );
      if (response.statusCode == 200) {
        print("data deleted");
      }
    } catch (e) {
      print("catch");
      print(e);
    }
  }

  void uploadNewMeasures(context) async {
    measures = await getNewMeasures();
    for (var element in measures) {
      addMeasure(element);
    }
    sendDeleteData();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Mediciones recolectadas'),
    ));
  }

  @override
  void initState() {
    super.initState();
    uploadNewMeasures(context);
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
              sensorMeasure: currentMeasure,
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
