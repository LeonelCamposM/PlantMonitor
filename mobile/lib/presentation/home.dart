import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile/infraestructure/ap_sensor_measure_widget.dart';
import 'package:mobile/infraestructure/fcm_repo.dart';
import 'package:mobile/infraestructure/wifi_sensor_measure_widget.dart';
import 'package:mobile/presentation/sensor_configuration/configuration_form.dart';

enum NavigationState { home, wifiDashboard, configurationForm, apDashboard }

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
    AndroidNotification? android = message.notification?.android;
    showModalBottomSheet(
        context: context,
        builder: ((context) {
          return Text(notification!.title.toString());
        }));
  }

  void sendMessage(FirebaseMessagingRepo fcm) async {
    String? token = await fcm.getToken();
    print(token);
    fcm.sendPushMessage(token!, "notificacion post", "nueva");
    print("done");
    print("done");
    print("done");
    print("done");
    print("done");
  }

  void changeTitle(String title) {
    setState(() {
      widget.title = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (navState) {
      case NavigationState.home:
        changeTitle("Resumen de mediciones");
        page = Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Column(
            children: [
              Card(
                elevation: 10,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Sensor de chayotes",
                          style: TextStyle(fontSize: 25)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.battery_2_bar),
                            SizedBox(
                              width: 10,
                            ),
                            Text("La batería está por acabarse"),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          )),
        );
        break;
      case NavigationState.configurationForm:
        changeTitle("Configuraciones del sensor");
        page = const ConfigurationForm();
        break;
      case NavigationState.wifiDashboard:
        changeTitle("Mediciones del sensor");
        page = Center(child: WifiSensorMeasureWidget());
        break;
      case NavigationState.apDashboard:
        page = Column(
          children: const [
            APSensorMeasureWidget(),
          ],
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          page,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navState.index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.sensors), label: "Sensores"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Configuración"),
          // BottomNavigationBarItem(icon: Icon(Icons.wifi_off), label: "AP"),
        ],
        onTap: (pagina) {
          setState(() {
            navState = NavigationState.values[pagina];
          });
        },
      ),
    );
  }
}
