import 'package:hive/hive.dart';
import 'package:weather_forecast_app_zarinpal/src/data/models/city_model.dart';
import 'package:weather_forecast_app_zarinpal/src/utils/di.dart';

abstract class ICityLocalDataSource {
  Future<List<City>> getSelectedCities();
  Future<void> saveSelectedCity(City city);
  Future<void> removeSelectedCity(City city);
}

class CityLocalDataSource implements ICityLocalDataSource {
  final Box<City> _citiesBox = locator<Box<City>>();

  @override
  Future<List<City>> getSelectedCities() async {
    try {
      return _citiesBox.values.toList();
    } on Exception catch (ex) {
      print(ex);
      rethrow;
    }
  }

  @override
  Future<void> saveSelectedCity(City city) async {
    try {
      await _citiesBox.add(city);
    } on Exception catch (ex) {
      print(ex);
      rethrow;
    }
  }

  @override
  Future<void> removeSelectedCity(City city) async {
    try {
      await _citiesBox.delete(city.key);
    } on Exception catch (ex) {
      print(ex);
      rethrow;
    }
  }
}
