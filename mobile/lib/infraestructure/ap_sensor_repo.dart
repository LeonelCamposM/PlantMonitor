import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:plant_monitor/domain/sensor_measure.dart';
import 'package:plant_monitor/presentation/core/size_config.dart';
import 'package:plant_monitor/presentation/dashboard/dashboard.dart';

// ignore: must_be_immutable
class APSensorRepo extends StatefulWidget {
  APSensorRepo(
      {Key? key, required this.measureLimits, required this.lastMeasure})
      : super(key: key);
  MeasureLimit measureLimits;
  Measure lastMeasure;

  @override
  State<APSensorRepo> createState() => APSensorMeasureRepoState();
}

class APSensorMeasureRepoState extends State<APSensorRepo> {
  Timer? timer;
  bool conected = true;
  int counter = 0;

  void getUpdatedValue() async {
    try {
      final response = await http
          .get(
        Uri.parse('http://192.168.1.22:80/getName'),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          counter = 0;
          conected = true;
        });
      } else {
        counter += 1;
        if (counter > 5) {
          setState(() {
            conected = false;
          });
        }
      }
    } catch (e) {
      counter += 1;
      if (counter > 5) {
        setState(() {
          conected = false;
        });
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        conected == false
            ? ConectedDashboard(
                measureLimits: widget.measureLimits,
                lastMeasure: widget.lastMeasure,
              )
            : const DisconectedDashboard(),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
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
                        conected == false ? Icons.power_off : Icons.power,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
