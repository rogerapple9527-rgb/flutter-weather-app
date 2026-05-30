import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_app/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('renders weather search skeleton', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: WeatherApp()));

    expect(find.text('36 小時天氣預報'), findsOneWidget);
    expect(find.text('查詢'), findsOneWidget);
    expect(find.text('請輸入縣市名稱並點擊查詢，例如：臺北市、台中市、高雄市。'), findsOneWidget);
  });
}
