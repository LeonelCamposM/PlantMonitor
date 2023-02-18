import 'package:flutter/cupertino.dart';
import 'package:mobile/infraestructure/ap_sensor_measure_widget.dart';
import 'package:mobile/presentation/core/size_config.dart';

class HomeDashBoard extends StatelessWidget {
  const HomeDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
            APSensorMeasureWidget(
              meassureName: "Humedad",
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 10,
        ),
      ],
    );
  }
}
