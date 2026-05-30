import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/weather_remote_data_source.dart';
import '../../data/mappers/weather_forecast_mapper.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/usecases/get_weather_forecast_use_case.dart';
import '../states/weather_view_state.dart';

final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>((
  ref,
) {
  return WeatherRemoteDataSource(dio: ref.watch(dioProvider));
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(
    remoteDataSource: ref.watch(weatherRemoteDataSourceProvider),
    mapper: const WeatherForecastMapper(),
  );
});

final getWeatherForecastUseCaseProvider = Provider<GetWeatherForecastUseCase>((
  ref,
) {
  return GetWeatherForecastUseCase(ref.watch(weatherRepositoryProvider));
});

final weatherSearchProvider =
    NotifierProvider<WeatherSearchNotifier, WeatherViewState>(
      WeatherSearchNotifier.new,
    );

class WeatherSearchNotifier extends Notifier<WeatherViewState> {
  late final GetWeatherForecastUseCase _getWeatherForecastUseCase;

  String _query = '';

  @override
  WeatherViewState build() {
    _getWeatherForecastUseCase = ref.watch(getWeatherForecastUseCaseProvider);
    return const WeatherInitial();
  }

  String get query => _query;

  void updateQuery(String value) {
    _query = value;
  }

  void applyLocation(String value) {
    _query = value;
  }

  Future<void> search() async {
    final trimmedQuery = _query.trim();
    if (trimmedQuery.isEmpty) {
      state = WeatherError(InvalidInputFailure().message);
      return;
    }

    state = const WeatherLoading();

    try {
      final forecast = await _getWeatherForecastUseCase(
        GetWeatherForecastParams(trimmedQuery),
      );
      state = WeatherSuccess(forecast);
    } on AppFailure catch (failure) {
      state = WeatherError(failure.message);
    } catch (_) {
      state = WeatherError(UnknownFailure().message);
    }
  }

  void reset() {
    state = const WeatherInitial();
  }
}
