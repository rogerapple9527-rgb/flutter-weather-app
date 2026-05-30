class WeatherResponseModel {
  const WeatherResponseModel({required this.success, required this.records});

  final String success;
  final WeatherRecordsModel records;

  factory WeatherResponseModel.fromJson(Map<String, dynamic> json) {
    return WeatherResponseModel(
      success: json['success'] as String? ?? '',
      records: WeatherRecordsModel.fromJson(
        json['records'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }
}

class WeatherRecordsModel {
  const WeatherRecordsModel({
    required this.datasetDescription,
    required this.locations,
  });

  final String datasetDescription;
  final List<WeatherLocationModel> locations;

  factory WeatherRecordsModel.fromJson(Map<String, dynamic> json) {
    final locationList = json['location'] as List<dynamic>? ?? const [];

    return WeatherRecordsModel(
      datasetDescription: json['datasetDescription'] as String? ?? '',
      locations: locationList
          .map(
            (item) => WeatherLocationModel.fromJson(
              item as Map<String, dynamic>? ?? <String, dynamic>{},
            ),
          )
          .toList(),
    );
  }
}

class WeatherLocationModel {
  const WeatherLocationModel({
    required this.locationName,
    required this.weatherElements,
  });

  final String locationName;
  final List<WeatherElementModel> weatherElements;

  factory WeatherLocationModel.fromJson(Map<String, dynamic> json) {
    final elementList = json['weatherElement'] as List<dynamic>? ?? const [];

    return WeatherLocationModel(
      locationName: json['locationName'] as String? ?? '',
      weatherElements: elementList
          .map(
            (item) => WeatherElementModel.fromJson(
              item as Map<String, dynamic>? ?? <String, dynamic>{},
            ),
          )
          .toList(),
    );
  }
}

class WeatherElementModel {
  const WeatherElementModel({required this.elementName, required this.times});

  final String elementName;
  final List<WeatherTimeModel> times;

  factory WeatherElementModel.fromJson(Map<String, dynamic> json) {
    final timeList = json['time'] as List<dynamic>? ?? const [];

    return WeatherElementModel(
      elementName: json['elementName'] as String? ?? '',
      times: timeList
          .map(
            (item) => WeatherTimeModel.fromJson(
              item as Map<String, dynamic>? ?? <String, dynamic>{},
            ),
          )
          .toList(),
    );
  }
}

class WeatherTimeModel {
  const WeatherTimeModel({
    required this.startTime,
    required this.endTime,
    required this.parameter,
  });

  final String startTime;
  final String endTime;
  final WeatherParameterModel parameter;

  factory WeatherTimeModel.fromJson(Map<String, dynamic> json) {
    return WeatherTimeModel(
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      parameter: WeatherParameterModel.fromJson(
        json['parameter'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }
}

class WeatherParameterModel {
  const WeatherParameterModel({required this.name, this.value, this.unit});

  final String name;
  final String? value;
  final String? unit;

  factory WeatherParameterModel.fromJson(Map<String, dynamic> json) {
    return WeatherParameterModel(
      name: json['parameterName'] as String? ?? '',
      value: json['parameterValue'] as String?,
      unit: json['parameterUnit'] as String?,
    );
  }
}
