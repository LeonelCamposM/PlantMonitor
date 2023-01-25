import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile/infraestructure/ap_soil_moisture_widget.dart';
import 'package:mobile/infraestructure/wifi_soil_moisture_widget.dart';
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
  String? token;

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    // AndroidNotification? android = message.notification?.android;
    showModalBottomSheet(
        context: context,
        builder: ((context) {
          return Text(notification!.title.toString());
        }));
  }

  void getToken() async {
    String? newToken = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = newToken;
    });
  }

  @override
  void initState() {
    getToken();
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (navState) {
      case NavigationState.home:
        page = Center(child: Text(token.toString()));
        break;
      case NavigationState.configurationForm:
        page = const ConfigurationForm();
        break;
      case NavigationState.wifiDashboard:
        page = Center(child: WifiSoilMoistureWidget());
        break;
      case NavigationState.apDashboard:
        page = Column(
          children: const [
            APSoilMoistureWidget(),
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
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: "wifi"),
          BottomNavigationBarItem(icon: Icon(Icons.wifi_off), label: "ap"),
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
