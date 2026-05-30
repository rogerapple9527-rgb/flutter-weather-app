import '../../domain/entities/weather_forecast.dart';

sealed class WeatherViewState {
  const WeatherViewState();
}

final class WeatherInitial extends WeatherViewState {
  const WeatherInitial();
}

final class WeatherLoading extends WeatherViewState {
  const WeatherLoading();
}

final class WeatherSuccess extends WeatherViewState {
  const WeatherSuccess(this.forecast);

  final WeatherForecast forecast;
}

final class WeatherError extends WeatherViewState {
  const WeatherError(this.message);

  final String message;
}
