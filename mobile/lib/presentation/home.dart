import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile/infraestructure/ap_sensor_measure_widget.dart';
import 'package:mobile/infraestructure/fcm_repo.dart';
import 'package:mobile/infraestructure/wifi_sensor_measure_widget.dart';
import 'package:mobile/presentation/sensor_configuration.dart/configuration_form.dart';

enum NavigationState { home, configurationForm, wifiDashboard, apDashboard }

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
      home: const MyHomePage(title: 'Configuración de sensor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NavigationState navState = NavigationState.home;

  @override
  void initState() {
    FirebaseMessagingRepo fcm =
        FirebaseMessagingRepo(showFlutterNotification: showFlutterNotification);
    fcm.requestPermission();
    fcm.startFCM();
    sendMessage(fcm);
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

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (navState) {
      case NavigationState.home:
        page = Center(
            child: Column(
          children: const [
            Text("Inicio"),
          ],
        ));
        break;
      case NavigationState.configurationForm:
        page = const ConfigurationForm();
        break;
      case NavigationState.wifiDashboard:
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
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Configuración"),
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: "Wifi"),
          BottomNavigationBarItem(icon: Icon(Icons.wifi_off), label: "AP"),
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
