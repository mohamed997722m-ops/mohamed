import 'package:flutter_test/flutter_test.dart';
import 'package:masar/main.dart';
import 'package:provider/provider.dart';
import 'package:masar/providers/profile_provider.dart';
import 'package:masar/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final profileProvider = ProfileProvider();
    final settingsProvider = SettingsProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: profileProvider),
          ChangeNotifierProvider.value(value: settingsProvider),
        ],
        child: MasarApp(),
      ),
    );

    expect(find.text('أهلاً بك في مسار'), findsOneWidget);
  });
}
