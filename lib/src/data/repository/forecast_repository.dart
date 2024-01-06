import 'package:dartz/dartz.dart';
import 'package:weather_forecast_app_zarinpal/src/data/models/city_model.dart';
import 'package:weather_forecast_app_zarinpal/src/data/models/forecast_model.dart';
import 'package:weather_forecast_app_zarinpal/src/data/remote/forecast_remote_data_source.dart';
import 'package:weather_forecast_app_zarinpal/src/data/repository/city_repository.dart';
import 'package:weather_forecast_app_zarinpal/src/utils/api_exception.dart';
import 'package:weather_forecast_app_zarinpal/src/utils/di.dart';

abstract class IForecastRepository {
  Future<Either<String, List<Forecast>>> fetchCitiesWeathers();
  Future<Either<String, Forecast>> fetchCityWeather(City city);
}

class ForecastRepository extends IForecastRepository {
  final IForecastRemoteDataSource _dataSource = locator.get();
  final ICityRepository _cityRepository = locator.get();

  // @override
  // Future<Either<String, List<Forecast>>> fetchCitiesWeathers(List<City> cities) async {
  //   try {
  //     var result = await _dataSource.fetchCitiesWeathers(cities);
  //     return right(result);
  //   } on ApiException catch (ex) {
  //     return left(
  //       ex.message ?? 'Error while fetching cities\' weathers : No error message',
  //     );
  //   }
  // }

  @override
  Future<Either<String, List<Forecast>>> fetchCitiesWeathers() async {
    try {
      var eitherCities = await _cityRepository.getSelectedCities();

      return eitherCities.fold(
        (left) {

          throw Exception(left);
        },
        (right) async {
          var result = await _dataSource.fetchCitiesWeathers(right);
          return Right(result);
        },
      );
    } catch (e) {
      return left(
        'Error while fetching cities\' weathers: $e',
      );
    }
  }

  @override
  Future<Either<String, Forecast>> fetchCityWeather(City city) async {
    try {
      var result = await _dataSource.fetchCityWeathers(city);
      return right(result);
    } on ApiException catch (ex) {
      return left(
        ex.message ?? 'Error while fetching ${city.name}\'s weathers : No error message',
      );
    }
  }
}
