class Measure {
  double temperature;
  double pressure;
  double altitude;
  int battery;
  int humidity;
  DateTime date;

  Measure(this.temperature, this.pressure, this.altitude, this.battery,
      this.humidity, this.date);

  factory Measure.fromJson(Map<dynamic, dynamic> json) => Measure(
      json['temperature'] as double,
      json['pressure'] as double,
      json['altitude'] as double,
      json['battery'] as int,
      json['humidity'] as int,
      DateTime.parse(json['date'] as String));

  Map<dynamic, dynamic> toJson() => {
        'temperature': temperature,
        'pressure': pressure,
        'altitude': altitude,
        'battery': battery,
        'humidity': humidity,
        'date': date.toString()
      };
}

class MeasureLimit {
  int max;
  int min;

  MeasureLimit(this.max, this.min);

  factory MeasureLimit.fromJson(Map<dynamic, dynamic> json) => MeasureLimit(
        json['max'] as int,
        json['min'] as int,
      );

  Map<dynamic, dynamic> toJson() => {
        'max': max,
        'min': min,
      };
}

class UserMeasure {
  int battery;
  String date;
  int humidity;

  UserMeasure(this.battery, this.date, this.humidity);

  factory UserMeasure.fromJson(Map<dynamic, dynamic> json) => UserMeasure(
        json['battery'] as int,
        json['date'] as String,
        json['humidity'] as int,
      );

  Map<dynamic, dynamic> toJson() => {
        'battery': battery,
        'date': date,
        'humidity': humidity,
      };
}
