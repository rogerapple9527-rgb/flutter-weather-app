import '../entities/weather_forecast.dart';

abstract interface class WeatherRepository {
  Future<WeatherForecast> getForecast(String locationName);
}
