import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_app/core/error/app_failure.dart';
import 'package:flutter_weather_app/features/weather/domain/entities/forecast_period.dart';
import 'package:flutter_weather_app/features/weather/domain/entities/weather_forecast.dart';
import 'package:flutter_weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:flutter_weather_app/features/weather/domain/usecases/get_weather_forecast_use_case.dart';
import 'package:flutter_weather_app/features/weather/presentation/providers/weather_search_notifier.dart';
import 'package:flutter_weather_app/features/weather/presentation/states/weather_view_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('WeatherSearchNotifier', () {
    test('starts with initial state', () {
      final provider =
          NotifierProvider<WeatherSearchNotifier, WeatherViewState>(
            () => WeatherSearchNotifier(
              GetWeatherForecastUseCase(FakeWeatherRepository()),
            ),
          );
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(provider);

      expect(state, isA<WeatherInitial>());
    });

    test('sets error state when query is empty', () async {
      final provider =
          NotifierProvider<WeatherSearchNotifier, WeatherViewState>(
            () => WeatherSearchNotifier(
              GetWeatherForecastUseCase(FakeWeatherRepository()),
            ),
          );
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(provider.notifier);
      await notifier.search();

      final state = container.read(provider);
      expect(state, isA<WeatherError>());
      expect((state as WeatherError).message, '請輸入有效的縣市名稱。');
    });

    test(
      'updates query and returns success state when use case succeeds',
      () async {
        String? capturedLocationName;
        final provider =
            NotifierProvider<WeatherSearchNotifier, WeatherViewState>(
              () => WeatherSearchNotifier(
                GetWeatherForecastUseCase(
                  FakeWeatherRepository(
                    onGetForecast: (locationName) async {
                      capturedLocationName = locationName;
                      return fakeForecast;
                    },
                  ),
                ),
              ),
            );
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(provider.notifier);
        notifier.updateQuery(' 臺北市 ');
        await notifier.search();

        final state = container.read(provider);
        expect(capturedLocationName, '臺北市');
        expect(state, isA<WeatherSuccess>());
        expect((state as WeatherSuccess).forecast.locationName, '臺北市');
      },
    );

    test('returns error state when use case throws app failure', () async {
      final provider =
          NotifierProvider<WeatherSearchNotifier, WeatherViewState>(
            () => WeatherSearchNotifier(
              GetWeatherForecastUseCase(
                FakeWeatherRepository(
                  onGetForecast: (_) async => throw const NotFoundFailure(),
                ),
              ),
            ),
          );
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(provider.notifier);
      notifier.applyLocation('臺北市');
      await notifier.search();

      final state = container.read(provider);
      expect(state, isA<WeatherError>());
      expect((state as WeatherError).message, '找不到該地區的天氣資料。');
    });

    test('reset returns state to initial', () {
      final provider =
          NotifierProvider<WeatherSearchNotifier, WeatherViewState>(
            () => WeatherSearchNotifier(
              GetWeatherForecastUseCase(FakeWeatherRepository()),
            ),
          );
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(provider.notifier);
      notifier.reset();

      expect(container.read(provider), isA<WeatherInitial>());
    });
  });
}

class FakeWeatherRepository implements WeatherRepository {
  FakeWeatherRepository({this.onGetForecast});

  final Future<WeatherForecast> Function(String locationName)? onGetForecast;

  @override
  Future<WeatherForecast> getForecast(String locationName) async {
    final handler = onGetForecast;
    if (handler != null) {
      return handler(locationName);
    }
    return fakeForecast;
  }
}

final fakeForecast = WeatherForecast(
  locationName: '臺北市',
  periods: [
    ForecastPeriod(
      startTime: DateTime(2026, 5, 31, 6),
      endTime: DateTime(2026, 5, 31, 18),
      weatherDescription: '多雲時晴',
      rainProbability: 20,
      minTemperature: 25,
      maxTemperature: 31,
      comfortDescription: '舒適',
    ),
  ],
);
