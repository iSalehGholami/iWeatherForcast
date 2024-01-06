import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/forecast/forecast_event.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/forecast/forecast_state.dart';
import 'package:weather_forecast_app_zarinpal/src/data/repository/forecast_repository.dart';
import 'package:weather_forecast_app_zarinpal/src/utils/di.dart';

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  final IForecastRepository _forecastRepository = locator.get();
  ForecastBloc() : super(ForecastInitState()) {
    on<ForecastCheckAllCitiesRequest>(
      (event, emit) async {
        try {
          emit(ForecastLoadingState());
          final allCitiesForecastData = await _forecastRepository.fetchCitiesWeathers();
          emit(
            ForecastLoadedState(allCitiesForecastData),
          );
        } catch (e) {
          emit(ForecastErrorState('Failed to fetch cities: $e'));
        }
      },
    );
  }
}
