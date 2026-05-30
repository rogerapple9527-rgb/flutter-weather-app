import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/weather_forecast.dart';

class WeatherContentView extends StatelessWidget {
  const WeatherContentView({super.key, required this.forecast});

  final WeatherForecast forecast;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('M/d HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                forecast.locationName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '以下為今明 36 小時預報時段。',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: forecast.periods.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final period = forecast.periods[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${dateFormat.format(period.startTime)} - '
                        '${dateFormat.format(period.endTime)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InfoChip(
                            icon: Icons.wb_cloudy_outlined,
                            label: '天氣現象',
                            value: period.weatherDescription,
                          ),
                          _InfoChip(
                            icon: Icons.umbrella_outlined,
                            label: '降雨機率',
                            value: '${period.rainProbability}%',
                          ),
                          _InfoChip(
                            icon: Icons.thermostat_outlined,
                            label: '溫度',
                            value:
                                '${period.minTemperature}°C - ${period.maxTemperature}°C',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('舒適度：${period.comfortDescription}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text('$label：$value'),
        ],
      ),
    );
  }
}
