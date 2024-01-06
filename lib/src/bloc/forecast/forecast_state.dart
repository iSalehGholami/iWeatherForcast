import 'package:dartz/dartz.dart';
import 'package:weather_forecast_app_zarinpal/src/data/models/forecast_model.dart';

abstract class ForecastState {}

class ForecastInitState extends ForecastState {}

class ForecastLoadingState extends ForecastState {}

class ForecastLoadedState extends ForecastState {
  final Either<String, List<Forecast>> forecastDataList;

  ForecastLoadedState(this.forecastDataList);
}

class ForecastErrorState extends ForecastState {
  final String error;

  ForecastErrorState(this.error);
}
