import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_app/core/error/app_failure.dart';
import 'package:flutter_weather_app/features/weather/data/mappers/weather_forecast_mapper.dart';
import 'package:flutter_weather_app/features/weather/data/models/weather_response_model.dart';

void main() {
  const mapper = WeatherForecastMapper();

  group('WeatherForecastMapper', () {
    test('maps API response into weather forecast entity', () {
      final response = WeatherResponseModel.fromJson({
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
                      'parameter': {
                        'parameterName': '多雲時晴',
                        'parameterValue': '3',
                      },
                    },
                  ],
                },
                {
                  'elementName': 'PoP',
                  'time': [
                    {
                      'startTime': '2026-05-31 06:00:00',
                      'endTime': '2026-05-31 18:00:00',
                      'parameter': {
                        'parameterName': '20',
                        'parameterUnit': '百分比',
                      },
                    },
                  ],
                },
                {
                  'elementName': 'MinT',
                  'time': [
                    {
                      'startTime': '2026-05-31 06:00:00',
                      'endTime': '2026-05-31 18:00:00',
                      'parameter': {
                        'parameterName': '25',
                        'parameterUnit': 'C',
                      },
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
                      'parameter': {
                        'parameterName': '31',
                        'parameterUnit': 'C',
                      },
                    },
                  ],
                },
              ],
            },
          ],
        },
      });

      final forecast = mapper.toEntity(response);

      expect(forecast.locationName, '臺北市');
      expect(forecast.periods, hasLength(1));
      expect(forecast.periods.first.weatherDescription, '多雲時晴');
      expect(forecast.periods.first.rainProbability, 20);
      expect(forecast.periods.first.minTemperature, 25);
      expect(forecast.periods.first.maxTemperature, 31);
      expect(forecast.periods.first.comfortDescription, '舒適');
    });

    test('throws not found when API returns empty locations', () {
      final response = WeatherResponseModel.fromJson({
        'success': 'true',
        'records': {'datasetDescription': '三十六小時天氣預報', 'location': []},
      });

      expect(() => mapper.toEntity(response), throwsA(isA<NotFoundFailure>()));
    });

    test('throws parsing failure when success flag is false', () {
      final response = WeatherResponseModel.fromJson({
        'success': 'false',
        'records': {'datasetDescription': '三十六小時天氣預報', 'location': []},
      });

      expect(() => mapper.toEntity(response), throwsA(isA<ParsingFailure>()));
    });

    test('throws parsing failure when weather elements are missing', () {
      final response = WeatherResponseModel.fromJson({
        'success': 'true',
        'records': {
          'datasetDescription': '三十六小時天氣預報',
          'location': [
            {'locationName': '臺北市', 'weatherElement': []},
          ],
        },
      });

      expect(() => mapper.toEntity(response), throwsA(isA<ParsingFailure>()));
    });
  });
}
