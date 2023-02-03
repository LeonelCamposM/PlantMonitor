import 'package:flutter/material.dart';
import 'package:mobile/domain/sensor.dart';
import 'package:mobile/presentation/core/size_config.dart';
import 'package:mobile/presentation/core/text.dart';

// ignore: must_be_immutable
class SensorList extends StatelessWidget {
  final Function callback;
  List<Sensor> userSensors;
  SensorList({super.key, required this.callback, required this.userSensors});

  Widget getSensorCard(int index, List<Sensor> userSensors) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  getTitleText("Sensor: ", true),
                  getTitleText(userSensors[index].name, true)
                ],
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 3,
                width: SizeConfig.blockSizeVertical * 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getBodyText("Último reporte: ", true),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 1,
                        width: SizeConfig.blockSizeVertical * 40,
                      ),
                      getBodyText("Fecha: ${userSensors[index].date}", false),
                      getBodyText("Hora: ${userSensors[index].time}", false),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 3,
              ),
              ElevatedButton(
                  onPressed: (() =>
                      {callback("measures", userSensors[index].measures)}),
                  child: const Text("Mediciones"))
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    double height = 0;
    double width = 0;

    if (SizeConfig.blockSizeHorizontal > 9.15) {
      height = SizeConfig.blockSizeVertical * 90;
      width = SizeConfig.blockSizeHorizontal * 30;
    } else {
      height = SizeConfig.blockSizeVertical * 90;
      width = SizeConfig.blockSizeHorizontal * 80;
    }

    return SizedBox(
      height: height,
      width: width,
      child: ListView(
          reverse: false,
          scrollDirection: Axis.vertical,
          children: List.generate(
            userSensors.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: getSensorCard(index, userSensors),
              ),
            ),
          )),
    );
  }
}
