import 'package:flutter/material.dart';

class WeatherInitialView extends StatelessWidget {
  const WeatherInitialView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_outlined,
                size: 54,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text('開始查詢天氣預報', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                '請輸入縣市名稱並點擊查詢，例如：臺北市、台中市、高雄市。',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
