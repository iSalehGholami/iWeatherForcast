class Weather {
  int id;
  String name;
  String description;
  String iconName;

  Weather(this.id, this.name, this.description, this.iconName);

  factory Weather.fromJSON(Map<String, dynamic> jsonObject) {
    return Weather(
      jsonObject["id"],
      jsonObject["main"],
      jsonObject["description"],
      jsonObject["icon"],
    );
  }
}
