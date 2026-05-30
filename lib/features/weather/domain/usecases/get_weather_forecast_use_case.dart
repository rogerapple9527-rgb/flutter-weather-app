import '../../../../core/usecase/use_case.dart';
import '../entities/weather_forecast.dart';
import '../repositories/weather_repository.dart';

class GetWeatherForecastParams {
  const GetWeatherForecastParams(this.locationName);

  final String locationName;
}

class GetWeatherForecastUseCase
    implements UseCase<WeatherForecast, GetWeatherForecastParams> {
  const GetWeatherForecastUseCase(this._repository);

  final WeatherRepository _repository;

  @override
  Future<WeatherForecast> call(GetWeatherForecastParams params) {
    return _repository.getForecast(params.locationName);
  }
}
