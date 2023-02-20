import 'package:firebase_database/firebase_database.dart';
import 'package:plant_monitor/domain/measure.dart';

void addMeasure(Measure measure) async {
  DatabaseReference measuresRef =
      FirebaseDatabase.instance.ref("users/leonel/measures/");

  await measuresRef.push().set({
    'battery': measure.battery,
    'humidity': measure.humidity,
    'date': DateTime.now().toString()
  });
}
