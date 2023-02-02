// @param messages: Player messages in order
// @param icons: Player images in order
// @return Container with vertical list chat view
import 'package:flutter/material.dart';
import 'package:mobile/domain/measure.dart';
import 'package:mobile/domain/sensor.dart';
import 'package:mobile/presentation/core/size_config.dart';
import 'package:mobile/presentation/dashboard/dashboard.dart';

Widget getSensorVerticalList(List<Sensor> userSensors, context, callback) {
  return SizedBox(
    height: SizeConfig.blockSizeVertical * 90,
    width: SizeConfig.blockSizeHorizontal * 50,
    child: ListView(
        reverse: false,
        scrollDirection: Axis.vertical,
        children: List.generate(
          userSensors.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Row(
                children: [
                  Card(
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
                                const Text("Sensor: ",
                                    style: TextStyle(fontSize: 25)),
                                Text(userSensors[index].name,
                                    style: TextStyle(fontSize: 25)),
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
                                    const Text(
                                      "Detalles de último reporte: ",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.blockSizeVertical * 3,
                                      width: SizeConfig.blockSizeVertical * 40,
                                    ),
                                    Text(
                                      "Fecha : ${userSensors[index].date}",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "Hora : ${userSensors[index].time}",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 3,
                              width: SizeConfig.blockSizeVertical * 40,
                            ),
                            ElevatedButton(
                                onPressed: (() => {
                                      callback("measures",
                                          userSensors[index].measures)
                                    }),
                                child: const Text("Mediciones"))
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        )),
  );
}

Widget getSensorHorizontalList(List<Measure> sensorsMeassures) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: SizeConfig.blockSizeVertical * 85,
      width: SizeConfig.blockSizeHorizontal * 60,
      child: ListView(
          scrollDirection: Axis.vertical,
          children: List.generate(
            sensorsMeassures.length,
            (index) => Row(
              children: [
                sensorsMeassures[index].value is double
                    ? CircularChartCard(
                        sensorMeasure: sensorsMeassures[index],
                      )
                    : const Text("")
              ],
            ),
          )),
    ),
  );
}
