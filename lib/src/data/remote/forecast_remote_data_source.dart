import 'package:dio/dio.dart';
import 'package:weather_forecast_app_zarinpal/src/constants/const.dart';
import 'package:weather_forecast_app_zarinpal/src/data/models/city_model.dart';
import 'package:weather_forecast_app_zarinpal/src/data/models/forecast_model.dart';
import 'package:weather_forecast_app_zarinpal/src/utils/api_exception.dart';
import 'package:weather_forecast_app_zarinpal/src/utils/di.dart';

abstract class IForecastRemoteDataSource {
  Future<List<Forecast>> fetchCitiesWeathers(List<City> cities);
  Future<Forecast> fetchCityWeathers(City city);
}

class ForecastRemoteDataSource extends IForecastRemoteDataSource {
  final Dio _dio = locator.get();
  @override
  Future<List<Forecast>> fetchCitiesWeathers(List<City> cities) async {
    try {
      List<Forecast> forecasts = [];
      for (var city in cities) {
        var response = await _dio.get(
          APIConfig.WeatherForecastAPISuffix,
          queryParameters: {
            "lat": city.lat,
            "lon": city.lon,
            "units": "metric",
            "appid": APIConfig.APIKey,
          },
        );
        forecasts.add(
          Forecast.fromJSON(response.data, city),
        );
      }

      return forecasts;
    } on DioException catch (ex) {
      throw DioException(requestOptions: ex.requestOptions);
    } on Exception catch (ex) {
      throw Exception(ex);
    }
  }

  @override
  Future<Forecast> fetchCityWeathers(City city) async {
    try {
      var response = await _dio.get(
        APIConfig.WeatherForecastAPISuffix,
        queryParameters: {
          "lat": city.lat,
          "lon": city.lon,
          "units": "metric",
          "appid": APIConfig.APIKey,
        },
      );
      return Forecast.fromJSON(response.data, city);
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode ?? 0, ex.message);
    } on Exception catch (ex) {
      throw Exception(ex);
    }
  }
}
