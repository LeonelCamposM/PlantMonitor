import 'package:flutter/material.dart';
import 'package:mobile/infraestructure/ap_soil_moisture_widget.dart';
import 'package:mobile/infraestructure/wifi_soil_moisture_widget.dart';
import 'package:mobile/presentation/sensor_configuration.dart/configurationForm.dart';

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
  NavigationState navState = NavigationState.configurationForm;
  var args;

  @override
  void initState() {
    super.initState();
  }

  callback(NavigationState state, dynamic args) {
    setState(() {
      navState = state;
      this.args = args;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page = const ConfigurationForm();

    switch (navState) {
      case NavigationState.home:
        page = const Center(child: Text("home"));
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
