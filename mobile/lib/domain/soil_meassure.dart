class SoilMeassure {
  int humidity;
  String date;

  SoilMeassure(
    this.humidity,
    this.date,
  );

  factory SoilMeassure.fromJson(Map<dynamic, dynamic> json) => SoilMeassure(
        json['humidity'] as int,
        json['date'] as String,
      );

  Map<dynamic, dynamic> toJson() => {
        'humidity': humidity,
        'date': date,
      };
}
