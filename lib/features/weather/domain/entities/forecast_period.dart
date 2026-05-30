class ForecastPeriod {
  const ForecastPeriod({
    required this.startTime,
    required this.endTime,
    required this.weatherDescription,
    required this.rainProbability,
    required this.minTemperature,
    required this.maxTemperature,
    required this.comfortDescription,
  });

  final DateTime startTime;
  final DateTime endTime;
  final String weatherDescription;
  final int rainProbability;
  final int minTemperature;
  final int maxTemperature;
  final String comfortDescription;
}
