class SoilMeasure {
  int humidity;
  String date;
  int battery;

  SoilMeasure(this.humidity, this.date, this.battery);

  factory SoilMeasure.fromJson(Map<dynamic, dynamic> json) => SoilMeasure(
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
