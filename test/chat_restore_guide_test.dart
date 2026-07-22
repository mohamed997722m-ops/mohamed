import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';

void main() {
  testWidgets('ChatRestoreGuideScreen displays correctly with localization', (WidgetTester tester) async {
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

    await tester.pumpAndSettle();

    // Check title in AppBar
    expect(find.text('دليل استعادة المحادثات'), findsOneWidget);

    // Check presence of WhatsApp section
    expect(find.textContaining('واتساب'), findsAtLeastNWidgets(1));

    // Check presence of Telegram section
    expect(find.textContaining('تليجرام'), findsAtLeastNWidgets(1));

    // Check presence of Messenger section
    expect(find.textContaining('فيسبوك ماسنجر'), findsAtLeastNWidgets(1));

    // Check presence of Instagram section
    expect(find.textContaining('إنستجرام'), findsAtLeastNWidgets(1));
  });
}
