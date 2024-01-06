import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_forecast_app_zarinpal/src/constants/const.dart';
import 'package:weather_forecast_app_zarinpal/src/data/local/city_local_data_source.dart';
import 'package:weather_forecast_app_zarinpal/src/data/models/city_model.dart';
import 'package:weather_forecast_app_zarinpal/src/data/remote/city_remote_data_source.dart';
import 'package:weather_forecast_app_zarinpal/src/data/remote/forecast_remote_data_source.dart';
import 'package:weather_forecast_app_zarinpal/src/data/repository/city_repository.dart';
import 'package:weather_forecast_app_zarinpal/src/data/repository/forecast_repository.dart';

var locator = GetIt.instance;

Future<void> getItInit() async {
  // << Initialize Hive >>
  await Hive.initFlutter();

  // << Hive Adapters >>
  Hive.registerAdapter(CityAdapter());

  // << Hive Boxes >>
  final citiesBox = await Hive.openBox<City>("citiesBox");
  // << Default Hive Cities :) >>
  if (citiesBox.isEmpty) {
    citiesBox.addAll([
      City(
        'Tehran',
        'IR',
        "",
        35.6892523,
        51.3896004,
      ),
      City(
        'New York County',
        'US',
        "New York",
        40.7127281,
        -74.0060152,
      ),
      City(
        'London',
        'GB',
        "England",
        51.4875167,
        -0.1687007,
      ),
      City(
        'Dubai',
        'AE',
        "Dubai",
        25.2653471,
        55.2924914,
      ),
    ]);
  }

  // << Dio >>
  locator.registerSingleton<Dio>(
    Dio(
      BaseOptions(baseUrl: APIConfig.BaseAPIUrl),
    ),
  );

  // <<Hive>
  locator.registerLazySingleton<Box<City>>(() => Hive.box<City>('citiesBox'));

  // << Data sources >>

  locator.registerFactory<ICityRemoteDataSource>(() => CityRemoteDataSource());
  locator.registerFactory<ICityLocalDataSource>(() => CityLocalDataSource());

  locator.registerFactory<IForecastRemoteDataSource>(() => ForecastRemoteDataSource());

  // << Repositories >>

  locator.registerFactory<ICityRepository>(() => CityRepository());
  locator.registerFactory<IForecastRepository>(() => ForecastRepository());
}
