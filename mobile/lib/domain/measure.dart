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
