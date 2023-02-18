class Measure {
  int humidity;
  int battery;

  Measure(this.humidity, this.battery);

  factory Measure.fromJson(Map<dynamic, dynamic> json) => Measure(
        json['humidity'] as int,
        json['battery'] as int,
      );

  Map<dynamic, dynamic> toJson() => {
        'humidity': humidity,
        'battery': battery,
      };
}
