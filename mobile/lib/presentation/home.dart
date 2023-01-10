import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobile/presentation/sensor_configuration.dart/configurationForm.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
  // Future<void> fetchAlbum() async {
  //   final response = await http.get(Uri.parse('http://192.168.1.22:80/'));
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     print("done");
  //   } else {
  //     print("error");
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [ConfigurationForm()],
        ),
      ),
    );
  }
}
