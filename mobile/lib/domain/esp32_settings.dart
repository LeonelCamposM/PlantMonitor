class ESP32Settings {
  String communicationType = "wifi";
  String wifiName = "";
  String wifiPass = "";

  ESP32Settings(this.communicationType, this.wifiName, this.wifiPass);

  factory ESP32Settings.fromJson(Map<dynamic, dynamic> json) => ESP32Settings(
        json['communicationType'] as String,
        json['wifiName'] as String,
        json['wifiPass'] as String,
      );

  Map<dynamic, dynamic> toJson() => {
        'communicationType': communicationType,
        'wifiName': wifiName,
        'wifiPass': wifiPass,
      };
}
