import 'package:flutter/material.dart';
import 'package:mobile/presentation/core/size_config.dart';
import 'package:mobile/presentation/dashboard/home_dashboard.dart';
import 'package:mobile/presentation/settings/settings.dart';

enum NavigationState { home, configurationForm }

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
    super.initState();
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
        changeTitle("Mediciones");
        page = const HomeDashBoard();
        break;
      case NavigationState.configurationForm:
        changeTitle("Configuración de alertas");
        page = Column(
          children: const [
            AlertSettings(),
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
