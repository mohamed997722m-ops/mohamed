import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';

void main() {
  testWidgets('ChatRestoreGuideScreen renders correctly with titles and content', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', 'AE'),
        ],
        home: ChatRestoreGuideScreen(),
      ),
    );

    // Verify AppBar title
    expect(find.text('دليل استعادة المحادثات'), findsOneWidget);

    // Verify introduction text
    expect(find.textContaining('هذا الدليل يشرح كيفية استعادة المحادثات'), findsOneWidget);

    // Verify sections title presence
    expect(find.text('1. واتساب (WhatsApp)'), findsOneWidget);
    expect(find.text('2. تليجرام (Telegram)'), findsOneWidget);

    // Scroll down to view lower sections
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
    await tester.pump();

    expect(find.text('3. فيسبوك ماسنجر (Facebook Messenger)'), findsOneWidget);
    expect(find.text('4. إنستجرام (Instagram)'), findsOneWidget);

    // Verify note box
    expect(find.text('ملاحظة هامة:'), findsOneWidget);
  });
}
