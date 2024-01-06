import 'package:dartz/dartz.dart';
import 'package:weather_forecast_app_zarinpal/src/data/models/city_model.dart';

abstract class CityState {}

class CityInitState extends CityState {}

class CityLoadingState extends CityState {}

class CityLoadedState extends CityState {
  final Either<String, List<City>> cities;

  CityLoadedState(this.cities);
}

class CityClearSearchState extends CityState {}

class CityDoneState extends CityState {
  final String message;

  CityDoneState(this.message);
}

class CityErrorState extends CityState {
  final String error;

  CityErrorState(this.error);
}
