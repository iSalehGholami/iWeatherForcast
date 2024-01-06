import 'package:weather_forecast_app_zarinpal/src/data/models/city_model.dart';
import 'package:weather_forecast_app_zarinpal/src/data/models/weather_model.dart';

class Forecast {
  double temperature;
  double windSpeed;
  int humidity;
  int datetime;
  Weather weatherCondition;
  City city;

  Forecast(
    this.temperature,
    this.windSpeed,
    this.humidity,
    this.datetime,
    this.weatherCondition,
    this.city,
  );

  factory Forecast.fromJSON(Map<String, dynamic> jsonObject, City city) {
    return Forecast(
      jsonObject["main"]["temp"].toDouble() ?? 0.0,
      jsonObject["wind"]["speed"].toDouble() ?? 0.0,
      jsonObject["main"]["humidity"],
      jsonObject["timezone"],
      Weather.fromJSON(jsonObject["weather"][0]),
      city,
    );
  }
}
