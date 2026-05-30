import 'package:flutter/material.dart';

class WeatherLoadingView extends StatelessWidget {
  const WeatherLoadingView({super.key});

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
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('讀取天氣資料中...'),
            ],
          ),
        ),
      ),
    );
  }
}
