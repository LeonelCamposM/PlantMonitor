class SensorMeasure {
  int humidity;
  String date;
  int battery;

  SensorMeasure(this.humidity, this.date, this.battery);

  factory SensorMeasure.fromJson(Map<dynamic, dynamic> json) => SensorMeasure(
        json['humidity'] as int,
        json['date'] as String,
        json['battery'] as int,
      );

  Map<dynamic, dynamic> toJson() => {
        'humidity': humidity,
        'date': date,
        'battery': battery,
      };
}
