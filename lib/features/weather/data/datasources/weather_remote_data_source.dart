import 'package:dio/dio.dart';

import '../../../../core/constants/cwa_api_constants.dart';
import '../../../../core/error/app_failure.dart';
import '../models/weather_response_model.dart';

typedef WeatherGetRequest =
    Future<Response<Map<String, dynamic>>> Function(
      String path, {
      Map<String, dynamic>? queryParameters,
    });

class WeatherRemoteDataSource {
  const WeatherRemoteDataSource({
    required this.dio,
    this.authorization = CwaApiConstants.authorization,
    WeatherGetRequest? getRequest,
  }) : _getRequest = getRequest;

  final Dio dio;
  final String authorization;
  final WeatherGetRequest? _getRequest;

  Future<WeatherResponseModel> fetchForecast(String locationName) async {
    if (authorization.isEmpty) {
      throw const UnknownFailure(
        '缺少中央氣象署授權碼，請用 --dart-define=CWA_AUTHORIZATION=your_api_key 啟動 App。',
      );
    }

    try {
      final response = await (_getRequest ?? dio.get<Map<String, dynamic>>)(
        CwaApiConstants.forecastPath,
        queryParameters: {
          'Authorization': authorization,
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
