import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';

void main() {
  testWidgets('ChatRestoreGuideScreen displays title', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChatRestoreGuideScreen()));
    expect(find.text('دليل استعادة المحادثات'), findsOneWidget);
    expect(find.text('1. واتساب (WhatsApp)'), findsOneWidget);
  });
}
