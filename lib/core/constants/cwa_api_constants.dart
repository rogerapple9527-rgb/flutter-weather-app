class CwaApiConstants {
  const CwaApiConstants._();

  static const authorization = String.fromEnvironment(
    'CWA_AUTHORIZATION',
    defaultValue: '',
  );

  static const forecastPath = '/v1/rest/datastore/F-C0032-001';
  static const jsonFormat = 'JSON';
}
