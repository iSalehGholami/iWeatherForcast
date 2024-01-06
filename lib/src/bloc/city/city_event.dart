import 'package:weather_forecast_app_zarinpal/src/data/models/city_model.dart';

abstract class CityEvent {}

class FetchMatchedCitiesEvent extends CityEvent {
  final String keyword;

  FetchMatchedCitiesEvent(this.keyword);
}

class FetchSelectedCitiesEvent extends CityEvent {}

class ClearCurrentEvent extends CityEvent {}

class AddCityEvent extends CityEvent {
  final City city;

  AddCityEvent(this.city);
}

class RemoveCityEvent extends CityEvent {
  final City city;

  RemoveCityEvent(this.city);
}
