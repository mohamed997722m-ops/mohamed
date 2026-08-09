import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';

void main() {
  testWidgets('ChatRestoreGuideScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChatRestoreGuideScreen(),
      ),
    );

    // Verify AppBar title
    expect(find.text('دليل استعادة المحادثات'), findsOneWidget);

    // Verify section titles are present
    expect(find.text('1. واتساب (WhatsApp)'), findsOneWidget);
    expect(find.text('2. تليجرام (Telegram)'), findsOneWidget);
    expect(find.text('3. فيسبوك ماسنجر (Facebook Messenger)'), findsOneWidget);
    expect(find.text('4. إنستجرام (Instagram)'), findsOneWidget);

    // Verify there are some list items / explanation texts
    expect(find.textContaining('واتساب بشكل أساسي'), findsOneWidget);
  });
}
