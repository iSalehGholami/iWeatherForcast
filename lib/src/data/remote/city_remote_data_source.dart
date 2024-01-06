import 'package:dio/dio.dart';
import 'package:weather_forecast_app_zarinpal/src/constants/const.dart';
import 'package:weather_forecast_app_zarinpal/src/data/models/city_model.dart';
import 'package:weather_forecast_app_zarinpal/src/utils/api_exception.dart';
import 'package:weather_forecast_app_zarinpal/src/utils/di.dart';

abstract class ICityRemoteDataSource {
  Future<List<City>> findMatchedCities(String keyword);
}

class CityRemoteDataSource implements ICityRemoteDataSource {
  @override
  Future<List<City>> findMatchedCities(String keyword) async {
   
    final Dio _dio = locator.get();
    try {
      var response = await _dio.get(
        APIConfig.GeocodingAPISuffix,
        queryParameters: {
          "q": keyword.toLowerCase(),
          "appid": APIConfig.APIKey,
          "limit": 5,
        },
      );
      return response.data.length > 0
          ? response.data
              .map<City>(
                (jsonObject) => City.fromJSON(jsonObject),
              )
              .toList()
          : throw ApiException(404, "City not found");
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode ?? 0, ex.message);
    } catch (ex) {
      throw Exception(ex);
    }
  }
}
