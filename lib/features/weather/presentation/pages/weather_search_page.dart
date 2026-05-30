import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/constants/taiwan_locations.dart';
import '../providers/weather_search_notifier.dart';
import '../states/weather_view_state.dart';
import '../widgets/weather_content_view.dart';
import '../widgets/weather_error_view.dart';
import '../widgets/weather_initial_view.dart';
import '../widgets/weather_loading_view.dart';

class WeatherSearchPage extends ConsumerStatefulWidget {
  const WeatherSearchPage({super.key});

  @override
  ConsumerState<WeatherSearchPage> createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends ConsumerState<WeatherSearchPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(weatherSearchProvider);
    final notifier = ref.read(weatherSearchProvider.notifier);
    final isLoading = state is WeatherLoading;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('36 小時天氣預報')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _controller,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    hintText: '例如：臺北市',
                    helperText: '請輸入台灣 22 縣市名稱',
                    prefixIcon: const Icon(Icons.location_city_outlined),
                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _controller.clear();
                              notifier.updateQuery('');
                              notifier.reset();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close),
                          ),
                  ),
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    notifier.updateQuery(value);
                    setState(() {});
                  },
                  onSubmitted: (_) => notifier.search(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: isLoading ? null : notifier.search,
                    icon: const Icon(Icons.search),
                    label: Text(isLoading ? '查詢中...' : '查詢'),
                  ),
                ),
                const SizedBox(height: 16),
                Text('快速帶入', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: TaiwanLocations.values.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final location = TaiwanLocations.values[index];
                      return ActionChip(
                        label: Text(location),
                        onPressed: isLoading
                            ? null
                            : () {
                                _controller.text = location;
                                notifier.applyLocation(location);
                                FocusScope.of(context).unfocus();
                                setState(() {});
                              },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: switch (state) {
                      WeatherInitial() => const WeatherInitialView(),
                      WeatherLoading() => const WeatherLoadingView(),
                      WeatherSuccess(:final forecast) => WeatherContentView(
                        forecast: forecast,
                      ),
                      WeatherError(:final message) => WeatherErrorView(
                        message: message,
                        onRetry: notifier.search,
                      ),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
