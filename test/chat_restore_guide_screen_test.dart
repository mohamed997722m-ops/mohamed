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

    // Verify Title
    expect(find.text('دليل استعادة المحادثات'), findsOneWidget);

    // Verify Sections
    expect(find.textContaining('واتساب (WhatsApp)'), findsOneWidget);
    expect(find.textContaining('تليجرام (Telegram)'), findsOneWidget);
    expect(find.textContaining('فيسبوك ماسنجر (Facebook Messenger)'), findsOneWidget);
    expect(find.textContaining('إنستجرام (Instagram)'), findsOneWidget);

    // Verify Note
    expect(find.textContaining('ملاحظة هامة:'), findsOneWidget);
  });
}
