import 'package:dartz/dartz.dart';
import 'package:weather_forecast_app_zarinpal/src/data/local/city_local_data_source.dart';
import 'package:weather_forecast_app_zarinpal/src/data/models/city_model.dart';
import 'package:weather_forecast_app_zarinpal/src/data/remote/city_remote_data_source.dart';
import 'package:weather_forecast_app_zarinpal/src/utils/api_exception.dart';
import 'package:weather_forecast_app_zarinpal/src/utils/di.dart';

abstract class ICityRepository {
  // Local data
  Future<Either<String, List<City>>> getSelectedCities();
  Future<Either<String, void>> saveSelectedCity(City city);
  Future<Either<String, void>> removeSelectedCity(City city);

  //Remote data

  Future<Either<String, List<City>>> findMatchedCities(String keyword);
}

class CityRepository implements ICityRepository {
  final ICityLocalDataSource _localDataSource = locator.get();
  final ICityRemoteDataSource _remoteDataSource = locator.get();

  @override
  Future<Either<String, List<City>>> getSelectedCities() async {
    try {
      var response = await _localDataSource.getSelectedCities();

      return right(response);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'Error on local city fetch : No error message');
    }
  }

  @override
  Future<Either<String, void>> removeSelectedCity(City city) async {
    try {
      await _localDataSource.removeSelectedCity(city);
      return right(());
    } on ApiException catch (ex) {
      return left(ex.message ?? 'Error on city removing : No error message');
    }
  }

  @override
  Future<Either<String, void>> saveSelectedCity(City city) async {
    try {
      await _localDataSource.saveSelectedCity(city);
      return right(());
    } on ApiException catch (ex) {
      return left(ex.message ?? 'Error on city saving : No error message');
    }
  }

  @override
  Future<Either<String, List<City>>> findMatchedCities(String keyword) async {
    try {
      var result = await _remoteDataSource.findMatchedCities(keyword);
      return right(result);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'Error on finding matched cities : No error message');
    }
  }
}
