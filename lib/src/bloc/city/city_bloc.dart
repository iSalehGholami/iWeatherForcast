import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/city/city_event.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/city/city_state.dart';
import 'package:weather_forecast_app_zarinpal/src/data/repository/city_repository.dart';
import 'package:weather_forecast_app_zarinpal/src/utils/di.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final ICityRepository _cityRepository = locator.get();

  CityBloc() : super(CityInitState()) {
    on<FetchSelectedCitiesEvent>(
      (event, emit) async {
        try {
          emit(CityLoadingState());
          final selectedCities = await _cityRepository.getSelectedCities();
          emit(CityLoadedState(selectedCities));
        } catch (e) {
          emit(CityErrorState('Failed to fetch cities: $e'));
        }
      },
    );

    on<AddCityEvent>(
      (event, emit) async {
        try {
          await _cityRepository.saveSelectedCity(event.city);

          emit(
            CityDoneState("${event.city.name} was added to the chain ✅"),
          );
        } catch (e) {
          emit(CityErrorState('Failed to add city: $e'));
        }
      },
    );

    on<RemoveCityEvent>(
      (event, emit) async {
        try {
          await _cityRepository.removeSelectedCity(event.city);
        } catch (e) {
          emit(CityErrorState('Failed to remove city: $e'));
        }
      },
    );

    on<FetchMatchedCitiesEvent>(
      (event, emit) async {
        try {
          emit(CityLoadingState());
          var result = await _cityRepository.findMatchedCities(event.keyword);

          emit(
            CityLoadedState(result),
          );
        } catch (e) {
          emit(
            CityErrorState('Failed to fetch matched city: $e'),
          );
        }
      },
    );

    on<ClearCurrentEvent>(
      (event, emit) {
        emit(CityInitState());
        emit(CityClearSearchState());
      },
    );
  }
}
