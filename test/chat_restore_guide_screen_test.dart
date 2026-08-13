import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';

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

    // Verify app bar title
    expect(find.text('دليل استعادة المحادثات'), findsOneWidget);

    // Verify intro text
    expect(
      find.textContaining('هذا الدليل يشرح كيفية استعادة المحادثات والرسائل'),
      findsOneWidget,
    );

    // Verify WhatsApp section title
    expect(find.text('1. واتساب (WhatsApp)'), findsOneWidget);

    // Verify Telegram section title
    expect(find.text('2. تليجرام (Telegram)'), findsOneWidget);

    // Verify Facebook Messenger section title
    expect(find.text('3. فيسبوك ماسنجر (Facebook Messenger)'), findsOneWidget);

    // Verify Instagram section title
    expect(find.text('4. إنستجرام (Instagram)'), findsOneWidget);
  });
}
