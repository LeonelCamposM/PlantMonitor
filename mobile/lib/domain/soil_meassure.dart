class SoilMeasure {
  int humidity;
  String date;
  int batery;

  SoilMeasure(this.humidity, this.date, this.batery);

  factory SoilMeasure.fromJson(Map<dynamic, dynamic> json) => SoilMeasure(
        json['humidity'] as int,
        json['date'] as String,
        json['batery'] as int,
      );

  Map<dynamic, dynamic> toJson() => {
        'humidity': humidity,
        'date': date,
        'batery': batery,
      };
}
