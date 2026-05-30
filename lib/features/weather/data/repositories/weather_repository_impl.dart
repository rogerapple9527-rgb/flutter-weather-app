import '../../../../core/error/app_failure.dart';
import '../../domain/constants/taiwan_locations.dart';
import '../../domain/entities/weather_forecast.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';
import '../mappers/weather_forecast_mapper.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  const WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.mapper,
  });

  final WeatherRemoteDataSource remoteDataSource;
  final WeatherForecastMapper mapper;

  @override
  Future<WeatherForecast> getForecast(String locationName) async {
    final normalizedLocationName = _normalizeLocationName(locationName);

    if (normalizedLocationName.isEmpty) {
      throw const InvalidInputFailure();
    }

    if (!TaiwanLocations.contains(normalizedLocationName)) {
      throw const InvalidInputFailure('請輸入台灣 22 縣市名稱，例如：臺北市、高雄市。');
    }

    try {
      final response = await remoteDataSource.fetchForecast(
        normalizedLocationName,
      );
      return mapper.toEntity(response);
    } on AppFailure {
      rethrow;
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  String _normalizeLocationName(String locationName) {
    return locationName.trim().replaceAll('台', '臺');
  }
}
