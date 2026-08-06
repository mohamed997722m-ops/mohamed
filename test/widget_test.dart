import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masar/main.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';
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

  testWidgets('ChatRestoreGuideScreen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ar', 'AE'),
        ],
        locale: Locale('ar', 'AE'),
        home: ChatRestoreGuideScreen(),
      ),
    );

    expect(find.text('دليل استعادة المحادثات'), findsWidgets);
    expect(find.textContaining('واتساب'), findsWidgets);
    expect(find.textContaining('تليجرام'), findsWidgets);
  });
}
