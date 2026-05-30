import 'package:flutter/material.dart';

import '../features/weather/presentation/pages/weather_search_page.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F6AA5),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F7FB),
        useMaterial3: true,
      ),
      home: const WeatherSearchPage(),
    );
  }
}
