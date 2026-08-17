import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';

void main() {
  testWidgets('ChatRestoreGuideScreen renders correctly with guide sections',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChatRestoreGuideScreen(),
      ),
    );

    // Verify Title
    expect(find.text('دليل استعادة المحادثات'), findsOneWidget);

    // Verify Main Intro
    expect(
      find.textContaining('هذا الدليل يشرح كيفية استعادة المحادثات والرسائل'),
      findsOneWidget,
    );

    // Verify messaging platform section titles
    expect(find.text('1. واتساب (WhatsApp)'), findsOneWidget);
    expect(find.text('2. تليجرام (Telegram)'), findsOneWidget);
    expect(find.text('3. فيسبوك ماسنجر (Facebook Messenger)'), findsOneWidget);
    expect(find.text('4. إنستجرام (Instagram)'), findsOneWidget);

    // Verify Important Note section
    expect(find.text('ملاحظة هامة:'), findsOneWidget);
    expect(
      find.textContaining('يفضل دائماً تفعيل "النسخ الاحتياطي التلقائي"'),
      findsOneWidget,
    );
  });
}
