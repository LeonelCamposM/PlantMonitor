import 'package:mobile/domain/measure.dart';

class Sensor {
  List<Measure> measures;
  String name;
  String date;
  String time;

  Sensor(
    this.measures,
    this.name,
    this.date,
    this.time,
  );

  factory Sensor.fromJson(Map<dynamic, dynamic> json) => Sensor(
        json['measures'] as List<Measure>,
        json['name'] as String,
        json['date'] as String,
        json['time'] as String,
      );

  Map<dynamic, dynamic> toJson() => {
        'measures': measures,
        'name': name,
        'date': date,
        'time': time,
      };
}
