import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpStreamBuilder extends StatefulWidget {
  final String url;
  const HttpStreamBuilder({super.key, required this.url});

  @override
  HttpStreamBuilderState createState() => HttpStreamBuilderState();
}

class HttpStreamBuilderState extends State<HttpStreamBuilder> {
  late StreamController<List<dynamic>> _streamController;
  late Stream<List<dynamic>> _stream;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<List<dynamic>>();
    _stream = _streamController.stream;
    _getData();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _getData();
    });
  }

  @override
  void dispose() {
    _streamController.close();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getData() async {
    try {
      var response = await http.get(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        print("response.body");
        _streamController.sink.add(json.decode(response.body));
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      throw Exception('Error al cargar los datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: _stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(snapshot.data[index]['title']),
                subtitle: Text(snapshot.data[index]['subtitle']),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error al cargar los datos'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
