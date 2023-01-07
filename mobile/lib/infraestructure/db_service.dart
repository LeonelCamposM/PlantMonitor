import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Meassure extends StatelessWidget {
  Meassure({Key? key}) : super(key: key);
  String value = "";
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: starCountRef.onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) {
          return const Text('');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        }
        String newValue = getUpdateValue(snapshot);
        return Text(newValue);
      },
    );
  }
}

String getUpdateValue(AsyncSnapshot<DatabaseEvent> snapshot) {
  String val = "";
  if (!snapshot.hasData) {
    val = "empty";
  } else {
    Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
    List<dynamic> list = [];
    list = map.values.toList();
    for (var element in list) {
      val += element.toString();
      print(element);
    }
  }
  return val;
}
