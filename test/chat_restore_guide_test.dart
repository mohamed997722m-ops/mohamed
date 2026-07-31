import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';
import 'package:masar/widgets/main_drawer.dart';

void main() {
  testWidgets('ChatRestoreGuideScreen displays guides in Arabic', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar', 'AE'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: ChatRestoreGuideScreen(),
      ),
    );

    expect(find.text('دليل استعادة المحادثات'), findsOneWidget);
    expect(find.text('1. واتساب (WhatsApp)'), findsOneWidget);
    expect(find.text('2. تليجرام (Telegram)'), findsOneWidget);
    expect(find.text('3. فيسبوك ماسنجر (Facebook Messenger)'), findsOneWidget);
    expect(find.text('4. إنستجرام (Instagram)'), findsOneWidget);
  });

  testWidgets('MainDrawer has Chat Restore option before Bookmarks', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar', 'AE'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Material(
          child: MainDrawer(),
        ),
      ),
    );

    expect(find.text('استعادة المحادثات'), findsOneWidget);
    expect(find.text('المحفوظات'), findsOneWidget);

    // Verify ordering
    final chatRestoreFinder = find.text('استعادة المحادثات');
    final bookmarksFinder = find.text('المحفوظات');

    final chatRestoreY = tester.getCenter(chatRestoreFinder).dy;
    final bookmarksY = tester.getCenter(bookmarksFinder).dy;

    // In a vertical list, Chat Restore is before Bookmarks, so its Y coordinate should be less than Bookmarks Y coordinate.
    expect(chatRestoreY < bookmarksY, isTrue);
  });
}
