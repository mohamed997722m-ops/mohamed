import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
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

    expect(find.text('دليل استعادة المحادثات'), findsOneWidget);
    expect(find.text('1. واتساب (WhatsApp)'), findsOneWidget);
    expect(find.text('2. تليجرام (Telegram)'), findsOneWidget);
    expect(find.text('3. فيسبوك ماسنجر (Facebook Messenger)'), findsOneWidget);
    expect(find.text('4. إنستجرام (Instagram)'), findsOneWidget);
  });
}
