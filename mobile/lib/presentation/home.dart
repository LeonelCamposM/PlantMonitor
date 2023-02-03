import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile/infraestructure/fcm_repo.dart';
import 'package:mobile/infraestructure/wifi_sensor_measure_widget.dart';
import 'package:mobile/presentation/core/size_config.dart';
import 'package:mobile/presentation/sensors/measures_list.dart';
import 'package:mobile/presentation/settings/configuration_form.dart';

enum NavigationState { home, wifiDashboard, configurationForm }

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantMonitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({
    super.key,
  });
  String title = "";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NavigationState navState = NavigationState.home;
  String route = "sensors";
  dynamic args;

  callback(String route, dynamic args) {
    setState(() {
      this.route = route;
      this.args = args;
    });
  }

  @override
  void initState() {
    // FirebaseMessagingRepo fcm =
    //     FirebaseMessagingRepo(showFlutterNotification: showFlutterNotification);
    // fcm.requestPermission();
    // fcm.startFCM();
    // sendMessage(fcm);
    super.initState();
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    showModalBottomSheet(
        context: context,
        builder: ((context) {
          return Text(notification!.title.toString());
        }));
  }

  void sendMessage(FirebaseMessagingRepo fcm) async {
    String? token = await fcm.getToken();
    fcm.sendPushMessage(token!, "notificacion post", "nueva");
  }

  void changeTitle(String title) {
    setState(() {
      widget.title = title;
    });
  }

  void enableBack() {}

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Widget page;

    switch (navState) {
      case NavigationState.home:
        changeTitle("Resumen de mediciones");
        page = const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text("home")),
        );
        break;
      case NavigationState.configurationForm:
        changeTitle("Configuración de alertas");
        page = Column(
          children: const [
            ConfigurationForm(),
          ],
        );
        break;
      case NavigationState.wifiDashboard:
        if (route == "sensors") {
          changeTitle("Sensores activos");
        } else {
          changeTitle("Mediciones del sensor");
        }

        page = route == "sensors"
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: WifiSensorMeasureWidget(callback: callback)),
                ],
              )
            : page = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: MeasuresList(
                    sensorMeasures: args,
                  )),
                ],
              );
        break;
    }

    return Scaffold(
      appBar: route == "measures"
          ? AppBar(
              title: Text(widget.title),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => {callback("sensors", null)},
              ),
            )
          : AppBar(
              title: Text(widget.title),
            ),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navState.index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.sensors), label: "Sensores"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Configuración"),
        ],
        onTap: (pagina) {
          if (NavigationState.values[pagina] == NavigationState.home) {
            route = "sensors";
          }
          setState(() {
            navState = NavigationState.values[pagina];
          });
        },
      ),
    );
  }
}
