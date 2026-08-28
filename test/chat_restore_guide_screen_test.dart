import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';

void main() {
  testWidgets('ChatRestoreGuideScreen renders correctly and displays sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChatRestoreGuideScreen(),
      ),
    );

    expect(find.text('دليل استعادة المحادثات'), findsOneWidget);
    expect(find.textContaining('1. واتساب (WhatsApp)'), findsOneWidget);
    expect(find.textContaining('2. تليجرام (Telegram)'), findsOneWidget);
    expect(find.textContaining('3. فيسبوك ماسنجر (Facebook Messenger)'), findsOneWidget);
    expect(find.textContaining('4. إنستجرام (Instagram)'), findsOneWidget);
  });
}
