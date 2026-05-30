import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_app/core/error/app_failure.dart';
import 'package:flutter_weather_app/features/weather/data/datasources/weather_remote_data_source.dart';

void main() {
  group('WeatherRemoteDataSource', () {
    test('throws when authorization is missing', () async {
      final dataSource = WeatherRemoteDataSource(dio: Dio(), authorization: '');

      expect(
        () => dataSource.fetchForecast('臺北市'),
        throwsA(
          isA<UnknownFailure>().having(
            (failure) => failure.message,
            'message',
            contains('缺少中央氣象署授權碼'),
          ),
        ),
      );
    });

    test('returns parsed response when API succeeds', () async {
      final dataSource = WeatherRemoteDataSource(
        dio: Dio(),
        authorization: 'token',
        getRequest: (path, {queryParameters}) async {
          expect(path, '/v1/rest/datastore/F-C0032-001');
          expect(queryParameters?['Authorization'], 'token');
          expect(queryParameters?['locationName'], '臺北市');

          return Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: path),
            data: {
              'success': 'true',
              'records': {'datasetDescription': '三十六小時天氣預報', 'location': []},
            },
          );
        },
      );

      final response = await dataSource.fetchForecast('臺北市');

      expect(response.success, 'true');
      expect(response.records.datasetDescription, '三十六小時天氣預報');
    });

    test('throws parsing failure when response data is null', () async {
      final dataSource = WeatherRemoteDataSource(
        dio: Dio(),
        authorization: 'token',
        getRequest: (path, {queryParameters}) async {
          return Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: path),
            data: null,
          );
        },
      );

      expect(
        () => dataSource.fetchForecast('臺北市'),
        throwsA(isA<ParsingFailure>()),
      );
    });

    test('converts connection timeout into network failure', () async {
      final dataSource = WeatherRemoteDataSource(
        dio: Dio(),
        authorization: 'token',
        getRequest: (path, {queryParameters}) async {
          throw DioException(
            requestOptions: RequestOptions(path: path),
            type: DioExceptionType.connectionTimeout,
          );
        },
      );

      expect(
        () => dataSource.fetchForecast('臺北市'),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('parses response data from dio exception when available', () async {
      final dataSource = WeatherRemoteDataSource(
        dio: Dio(),
        authorization: 'token',
        getRequest: (path, {queryParameters}) async {
          throw DioException(
            requestOptions: RequestOptions(path: path),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: path),
              data: {
                'success': 'true',
                'records': {'datasetDescription': '三十六小時天氣預報', 'location': []},
              },
            ),
            type: DioExceptionType.badResponse,
          );
        },
      );

      final response = await dataSource.fetchForecast('臺北市');

      expect(response.success, 'true');
    });
  });
}
