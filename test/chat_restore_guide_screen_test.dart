import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';

void main() {
  testWidgets('ChatRestoreGuideScreen displays correct app title and sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChatRestoreGuideScreen(),
      ),
    );

    // Verify AppBar title
    expect(find.text('دليل استعادة المحادثات'), findsOneWidget);

    // Verify sections text presence
    expect(find.textContaining('واتساب'), findsWidgets);
    expect(find.textContaining('تليجرام'), findsWidgets);
    expect(find.textContaining('فيسبوك ماسنجر'), findsWidgets);
    expect(find.textContaining('إنستجرام'), findsWidgets);
  });
}
