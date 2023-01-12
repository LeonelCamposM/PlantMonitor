class SoilMeasure {
  int humidity;
  String date;

  SoilMeasure(
    this.humidity,
    this.date,
  );

  factory SoilMeasure.fromJson(Map<dynamic, dynamic> json) => SoilMeasure(
        json['humidity'] as int,
        json['date'] as String,
      );

  Map<dynamic, dynamic> toJson() => {
        'humidity': humidity,
        'date': date,
      };
}
