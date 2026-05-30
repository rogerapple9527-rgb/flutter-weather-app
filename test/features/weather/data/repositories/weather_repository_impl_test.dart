import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_app/core/error/app_failure.dart';
import 'package:flutter_weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:flutter_weather_app/features/weather/data/mappers/weather_forecast_mapper.dart';
import 'package:flutter_weather_app/features/weather/data/models/weather_response_model.dart';
import 'package:flutter_weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:flutter_weather_app/features/weather/domain/entities/weather_forecast.dart';

void main() {
  group('WeatherRepositoryImpl', () {
    test('throws invalid input when query is empty', () async {
      final repository = WeatherRepositoryImpl(
        remoteDataSource: FakeWeatherRemoteDataSource(),
        mapper: const WeatherForecastMapper(),
      );

      expect(
        () => repository.getForecast('  '),
        throwsA(isA<InvalidInputFailure>()),
      );
    });

    test('throws invalid input when location is not in Taiwan list', () async {
      final repository = WeatherRepositoryImpl(
        remoteDataSource: FakeWeatherRemoteDataSource(),
        mapper: const WeatherForecastMapper(),
      );

      expect(
        () => repository.getForecast('Tokyo'),
        throwsA(
          isA<InvalidInputFailure>().having(
            (failure) => failure.message,
            'message',
            contains('台灣 22 縣市名稱'),
          ),
        ),
      );
    });

    test('normalizes 台 into 臺 before calling data source', () async {
      String? capturedLocationName;

      final repository = WeatherRepositoryImpl(
        remoteDataSource: FakeWeatherRemoteDataSource(
          onFetch: (locationName) async {
            capturedLocationName = locationName;
            return buildResponse();
          },
        ),
        mapper: const WeatherForecastMapper(),
      );

      final forecast = await repository.getForecast('台北市');

      expect(capturedLocationName, '臺北市');
      expect(forecast.locationName, '臺北市');
    });

    test('rethrows app failures from remote data source', () async {
      final repository = WeatherRepositoryImpl(
        remoteDataSource: FakeWeatherRemoteDataSource(
          onFetch: (_) async => throw const NetworkFailure(),
        ),
        mapper: const WeatherForecastMapper(),
      );

      expect(
        () => repository.getForecast('臺北市'),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('converts unknown exceptions into unknown failure', () async {
      final repository = WeatherRepositoryImpl(
        remoteDataSource: FakeWeatherRemoteDataSource(
          onFetch: (_) async => throw Exception('boom'),
        ),
        mapper: const WeatherForecastMapper(),
      );

      expect(
        () => repository.getForecast('臺北市'),
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('rethrows app failures from mapper', () async {
      final repository = WeatherRepositoryImpl(
        remoteDataSource: FakeWeatherRemoteDataSource(
          onFetch: (_) async => buildResponse(),
        ),
        mapper: ThrowingWeatherForecastMapper(const ParsingFailure()),
      );

      expect(
        () => repository.getForecast('臺北市'),
        throwsA(isA<ParsingFailure>()),
      );
    });
  });
}

class FakeWeatherRemoteDataSource extends WeatherRemoteDataSource {
  FakeWeatherRemoteDataSource({this.onFetch})
    : super(dio: Dio(), authorization: 'token');

  final Future<WeatherResponseModel> Function(String locationName)? onFetch;

  @override
  Future<WeatherResponseModel> fetchForecast(String locationName) async {
    final handler = onFetch;
    if (handler == null) {
      throw UnimplementedError();
    }
    return handler(locationName);
  }
}

class ThrowingWeatherForecastMapper extends WeatherForecastMapper {
  const ThrowingWeatherForecastMapper(this.error);

  final AppFailure error;

  @override
  WeatherForecast toEntity(WeatherResponseModel responseModel) {
    throw error;
  }
}

WeatherResponseModel buildResponse() {
  return WeatherResponseModel.fromJson({
    'success': 'true',
    'records': {
      'datasetDescription': '三十六小時天氣預報',
      'location': [
        {
          'locationName': '臺北市',
          'weatherElement': [
            {
              'elementName': 'Wx',
              'time': [
                {
                  'startTime': '2026-05-31 06:00:00',
                  'endTime': '2026-05-31 18:00:00',
                  'parameter': {'parameterName': '多雲時晴'},
                },
              ],
            },
            {
              'elementName': 'PoP',
              'time': [
                {
                  'startTime': '2026-05-31 06:00:00',
                  'endTime': '2026-05-31 18:00:00',
                  'parameter': {'parameterName': '20'},
                },
              ],
            },
            {
              'elementName': 'MinT',
              'time': [
                {
                  'startTime': '2026-05-31 06:00:00',
                  'endTime': '2026-05-31 18:00:00',
                  'parameter': {'parameterName': '25'},
                },
              ],
            },
            {
              'elementName': 'CI',
              'time': [
                {
                  'startTime': '2026-05-31 06:00:00',
                  'endTime': '2026-05-31 18:00:00',
                  'parameter': {'parameterName': '舒適'},
                },
              ],
            },
            {
              'elementName': 'MaxT',
              'time': [
                {
                  'startTime': '2026-05-31 06:00:00',
                  'endTime': '2026-05-31 18:00:00',
                  'parameter': {'parameterName': '31'},
                },
              ],
            },
          ],
        },
      ],
    },
  });
}
