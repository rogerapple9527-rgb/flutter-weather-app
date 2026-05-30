import 'package:dio/dio.dart';

import '../../../../core/constants/cwa_api_constants.dart';
import '../../../../core/error/app_failure.dart';
import '../models/weather_response_model.dart';

class WeatherRemoteDataSource {
  const WeatherRemoteDataSource({required this.dio});

  final Dio dio;

  Future<WeatherResponseModel> fetchForecast(String locationName) async {
    if (CwaApiConstants.authorization.isEmpty) {
      throw const UnknownFailure(
        '缺少中央氣象署授權碼，請用 --dart-define=CWA_AUTHORIZATION=your_api_key 啟動 App。',
      );
    }

    try {
      final response = await dio.get<Map<String, dynamic>>(
        CwaApiConstants.forecastPath,
        queryParameters: {
          'Authorization': CwaApiConstants.authorization,
          'format': CwaApiConstants.jsonFormat,
          'locationName': locationName,
        },
      );

      final data = response.data;
      if (data == null) {
        throw const ParsingFailure();
      }

      return WeatherResponseModel.fromJson(data);
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        throw const NetworkFailure();
      }

      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        return WeatherResponseModel.fromJson(responseData);
      }

      throw const NetworkFailure();
    } on AppFailure {
      rethrow;
    } catch (_) {
      throw const ParsingFailure();
    }
  }
}
