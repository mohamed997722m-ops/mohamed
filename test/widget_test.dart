import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar/main.dart';
import 'package:provider/provider.dart';
import 'package:masar/providers/profile_provider.dart';
import 'package:masar/providers/settings_provider.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('ChatRestoreGuideScreen test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChatRestoreGuideScreen(),
      ),
    );

    expect(find.text('دليل استعادة المحادثات'), findsWidgets);
    expect(find.text('1. واتساب (WhatsApp)'), findsOneWidget);
    expect(find.text('2. تليجرام (Telegram)'), findsOneWidget);
    expect(find.text('3. فيسبوك ماسنجر (Facebook Messenger)'), findsOneWidget);
    expect(find.text('4. إنستجرام (Instagram)'), findsOneWidget);
  });

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
