import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/infraestructure/ap_sensor_measure_widget.dart';
import 'package:mobile/presentation/core/size_config.dart';

class HomeDashBoard extends StatelessWidget {
  const HomeDashBoard({super.key});

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
                APSensorMeasureWidget(
                  meassureName: "Batería",
                ),
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
                    width: SizeConfig.blockSizeHorizontal * 18,
                    height: SizeConfig.blockSizeHorizontal * 18,
                    child: FloatingActionButton(
                      onPressed: (() => {}),
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
