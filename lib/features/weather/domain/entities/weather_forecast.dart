import 'forecast_period.dart';

class WeatherForecast {
  const WeatherForecast({required this.locationName, required this.periods});

  final String locationName;
  final List<ForecastPeriod> periods;
}
