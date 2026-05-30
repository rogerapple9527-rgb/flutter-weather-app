import '../../../../core/error/app_failure.dart';
import '../../domain/entities/forecast_period.dart';
import '../../domain/entities/weather_forecast.dart';
import '../models/weather_response_model.dart';

class WeatherForecastMapper {
  const WeatherForecastMapper();

  WeatherForecast toEntity(WeatherResponseModel responseModel) {
    if (responseModel.success.toLowerCase() != 'true') {
      throw const ParsingFailure();
    }

    if (responseModel.records.locations.isEmpty) {
      throw const NotFoundFailure();
    }

    final location = responseModel.records.locations.first;
    final weatherElementMap = {
      for (final element in location.weatherElements)
        element.elementName: element,
    };

    final weatherTimes = weatherElementMap['Wx']?.times;
    final rainTimes = weatherElementMap['PoP']?.times;
    final minTemperatureTimes = weatherElementMap['MinT']?.times;
    final maxTemperatureTimes = weatherElementMap['MaxT']?.times;
    final comfortTimes = weatherElementMap['CI']?.times;

    if (weatherTimes == null ||
        rainTimes == null ||
        minTemperatureTimes == null ||
        maxTemperatureTimes == null ||
        comfortTimes == null) {
      throw const ParsingFailure();
    }

    final totalPeriods = [
      weatherTimes.length,
      rainTimes.length,
      minTemperatureTimes.length,
      maxTemperatureTimes.length,
      comfortTimes.length,
    ].reduce((value, element) => value < element ? value : element);

    if (totalPeriods == 0) {
      throw const NotFoundFailure();
    }

    final periods = List.generate(totalPeriods, (index) {
      final weather = weatherTimes[index];
      final rain = rainTimes[index];
      final minTemperature = minTemperatureTimes[index];
      final maxTemperature = maxTemperatureTimes[index];
      final comfort = comfortTimes[index];

      final startTime = DateTime.tryParse(weather.startTime);
      final endTime = DateTime.tryParse(weather.endTime);
      if (startTime == null || endTime == null) {
        throw const ParsingFailure();
      }

      return ForecastPeriod(
        startTime: startTime,
        endTime: endTime,
        weatherDescription: weather.parameter.name,
        rainProbability: _parseInt(rain.parameter.name),
        minTemperature: _parseInt(minTemperature.parameter.name),
        maxTemperature: _parseInt(maxTemperature.parameter.name),
        comfortDescription: comfort.parameter.name,
      );
    });

    return WeatherForecast(
      locationName: location.locationName,
      periods: periods,
    );
  }

  int _parseInt(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null) {
      throw const ParsingFailure();
    }
    return parsed;
  }
}
