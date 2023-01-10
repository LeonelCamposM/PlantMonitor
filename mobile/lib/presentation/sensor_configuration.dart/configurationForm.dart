// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:mobile/presentation/sensor_configuration.dart/steps/steps.dart';

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
  ConfigData formResponse = ConfigData();

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
              send: () => {print("enviado")},
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
              content: pasoInformacionMedica(
                  formResponse.communicationType == "wifi"),
              isActive: actualStep == 1,
            )
          ],
        ),
      ),
    );
  }
}

class ConfigData {
  String communicationType = "wifi";
  String wifiName = "";
  String wifiPass = "";
}
