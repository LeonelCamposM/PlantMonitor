// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:mobile/domain/esp32_settings.dart';
import 'package:mobile/presentation/settings/steps/steps.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ButtonBar extends StatelessWidget {
  ButtonBar(
      {Key? key,
      required this.actualStep,
      required this.controlDetails,
      required this.send})
      : super(key: key);
  int actualStep;
  dynamic controlDetails;
  dynamic send;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (actualStep > 0)
          TextButton(
            onPressed: controlDetails.onStepCancel,
            child: const Text('Anterior'),
          ),
        if (actualStep == 1)
          TextButton(
            onPressed: send,
            child: const Text('Enviar'),
          ),
        if (actualStep < 1)
          TextButton(
            onPressed: controlDetails.onStepContinue,
            child: const Text('Siguiente'),
          ),
      ],
    );
  }
}

class ConfigurationForm extends StatefulWidget {
  const ConfigurationForm({super.key});

  @override
  State<ConfigurationForm> createState() => _ConfigurationFormState();
}

class _ConfigurationFormState extends State<ConfigurationForm> {
  int actualStep = 0;
  ESP32Settings formResponse = ESP32Settings("wifi", "", "");

  void onStepTapped(step) {
    setState(() {
      actualStep = step;
    });
  }

  void onStepContinue() {
    setState(() {
      actualStep = actualStep + 1;
    });
  }

  void onStepCancel() {
    if (actualStep > 0) {
      setState(() {
        actualStep = actualStep - 1;
      });
    }
  }

  int onCommunicationChange(String communication) {
    setState(() {
      formResponse.communicationType = communication;
    });
    return 0;
  }

  void sendConfigData(ESP32Settings formResponse) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.22:80/config'),
      body: formResponse.toJson(),
    );
    if (response.statusCode == 200) {
      if (response.body.contains("ap")) {}
      switch (response.body) {
        case "ok ap":
          break;
        case "ok wifi":
          break;
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.key,
      child: Expanded(
        child: Stepper(
          physics: const ClampingScrollPhysics(),
          controlsBuilder: (context, controlDetails) {
            return ButtonBar(
              actualStep: actualStep,
              controlDetails: controlDetails,
              send: () => {sendConfigData(formResponse)},
            );
          },
          currentStep: actualStep,
          onStepTapped: onStepTapped,
          onStepContinue: onStepContinue,
          onStepCancel: onStepCancel,
          steps: [
            Step(
              title: const Text('Medio de comunicación'),
              content: communicationStep(onCommunicationChange),
              isActive: actualStep == 0,
            ),
            Step(
              title: const Text('Configuración de la conexión'),
              content:
                  networkSettingsStep(formResponse.communicationType == "wifi"),
              isActive: actualStep == 1,
            )
          ],
        ),
      ),
    );
  }
}
