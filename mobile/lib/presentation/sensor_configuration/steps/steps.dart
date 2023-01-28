import 'package:flutter/material.dart';

Widget communicationStep(Function onCommunicationChange) {
  return Column(children: [
    const SizedBox(height: 10),
    CommunicationRadioSelect(
      onCommunicationChange: onCommunicationChange,
    )
  ]);
}

// ignore: must_be_immutable
class CommunicationRadioSelect extends StatefulWidget {
  const CommunicationRadioSelect(
      {super.key, required this.onCommunicationChange});
  final Function onCommunicationChange; // wifi

  @override
  State<CommunicationRadioSelect> createState() =>
      // ignore: no_logic_in_create_state
      _CommunicationRadioSelectState();
}

class _CommunicationRadioSelectState extends State<CommunicationRadioSelect> {
  bool state = true;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Radio<bool>(
            value: state,
            groupValue: true,
            onChanged: (bool? campoVisible) {
              setState(() {
                state = true;
              });
              widget.onCommunicationChange("wifi");
            },
          ),
          const Text("Wifi"),
        ],
      ),
      Row(
        children: [
          Radio<bool>(
            value: !state,
            groupValue: true,
            onChanged: ((bool? campoVisible) {
              setState(() {
                state = false;
              });
              widget.onCommunicationChange("ap");
            }),
          ),
          const Text("Punto de acceso"),
        ],
      ),
      const SizedBox(height: 30),
    ]);
  }
}

Widget networkSettingsStep(bool stepVisible) {
  return Column(
    children: [
      const SizedBox(height: 10),
      Visibility(
        visible: stepVisible,
        child: Column(
          children: [
            TextFormField(
              initialValue: "",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Nombre de red',
                border: OutlineInputBorder(),
              ),
              onChanged: (alergias) {},
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: "",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Contraseña de red',
                border: OutlineInputBorder(),
              ),
              onChanged: (alergias) {},
            ),
          ],
        ),
      ),
    ],
  );
}
