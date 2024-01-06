import "package:hive_flutter/hive_flutter.dart";

part "city_model.g.dart";

@HiveType(typeId: 0)
class City extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String country;

  @HiveField(2)
  String state;

  @HiveField(3)
  double lat;

  @HiveField(4)
  double lon;

  City(this.name, this.country, this.state, this.lat, this.lon);

  factory City.fromJSON(Map<String, dynamic> jsonObject) {
    return City(
      jsonObject['name'],
      jsonObject['country'],
      jsonObject['state'] ?? "",
      jsonObject['lat'],
      jsonObject['lon'],
    );
  }
}
