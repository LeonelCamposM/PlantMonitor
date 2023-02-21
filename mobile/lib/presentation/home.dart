import 'package:flutter/material.dart';
import 'package:plant_monitor/infraestructure/users_limit_repo.dart';
import 'package:plant_monitor/presentation/core/size_config.dart';
import 'package:plant_monitor/presentation/dashboard/home_dashboard.dart';
import 'package:plant_monitor/presentation/measures/measures_chart.dart';

enum NavigationState { home, measures, settings }

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

  @override
  void initState() {
    super.initState();
  }

  void changeTitle(String title) {
    setState(() {
      widget.title = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Widget page;

    switch (navState) {
      case NavigationState.home:
        changeTitle("Medir");
        page = const HomeDashBoard();
        break;
      case NavigationState.settings:
        changeTitle("Configuración de alertas");
        page = FirebaseAlertsWidget();
        break;
      case NavigationState.measures:
        changeTitle("Mediciones");
        page = MeasuresChart();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navState.index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: "Mediciones"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active), label: "Alertas"),
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
