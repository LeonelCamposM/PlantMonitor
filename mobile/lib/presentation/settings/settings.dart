import 'package:flutter/material.dart';
import 'package:mobile/presentation/core/size_config.dart';
import 'package:mobile/presentation/core/text.dart';

// ignore: must_be_immutable
class AlertSettings extends StatefulWidget {
  const AlertSettings({super.key});

  @override
  State<AlertSettings> createState() => _AlertSettingsState();
}

class _AlertSettingsState extends State<AlertSettings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: SizeConfig.blockSizeVertical * 3,
        ),
        TitledSlider(
          title: "Húmedad minima",
          max: 100,
        ),
        TitledSlider(
          title: "Batería minima",
          max: 100,
        ),
        TitledSlider(
          title: "Frecuencia de reporte",
          max: 24,
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class TitledSlider extends StatefulWidget {
  String title = "";
  double max = 0;
  TitledSlider({super.key, required this.title, required this.max});

  @override
  State<TitledSlider> createState() => _TitledSliderState();
}

class _TitledSliderState extends State<TitledSlider> {
  double _currentValue = 0;

  String getValueTag(int value, String title) {
    String tag = "";
    switch (title) {
      case "Húmedad minima":
        tag = "$value%";
        break;
      case "Batería minima":
        tag = "$value%";
        break;
      case "Frecuencia de reporte":
        tag = "$value horas";
        break;
      default:
    }
    return tag;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 90,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                getTitleText(widget.title, false),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 3,
                ),
                Slider(
                  value: _currentValue,
                  max: widget.max,
                  divisions: 10,
                  label: getValueTag(_currentValue.round(), widget.title),
                  onChanged: (double value) {
                    setState(() {
                      _currentValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
