class Measure {
  String name;
  dynamic value;

  Measure(this.name, this.value);

  factory Measure.fromJson(Map<dynamic, dynamic> json) => Measure(
        json['value'] as dynamic,
        json['name'] as String,
      );

  Map<dynamic, dynamic> toJson() => {
        'value': value,
        'name': name,
      };
}
