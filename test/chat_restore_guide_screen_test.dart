import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';

void main() {
  testWidgets('ChatRestoreGuideScreen renders titles and sections correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChatRestoreGuideScreen(),
      ),
    );

    // Verify AppBar title
    expect(find.text('دليل استعادة المحادثات'), findsOneWidget);

    // Verify app section headers
    expect(find.text('1. واتساب (WhatsApp)'), findsOneWidget);
    expect(find.text('2. تليجرام (Telegram)'), findsOneWidget);
    expect(find.text('3. فيسبوك ماسنجر (Facebook Messenger)'), findsOneWidget);
    expect(find.text('4. إنستجرام (Instagram)'), findsOneWidget);

    // Verify note header
    expect(find.text('ملاحظة هامة:'), findsOneWidget);
  });
}
