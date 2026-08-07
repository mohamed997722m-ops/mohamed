import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar/widgets/main_drawer.dart';

void main() {
  testWidgets('MainDrawer has Chat Restore and Bookmarks items in order', (WidgetTester tester) async {
    // Increase viewport size to prevent ListView lazy-loading truncation
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          drawer: MainDrawer(),
          body: Container(),
        ),
      ),
    );

    // Open drawer
    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    // Verify both items are in the drawer
    expect(find.text('استعادة المحادثات'), findsOneWidget);
    expect(find.text('المحفوظات'), findsOneWidget);

    // Verify ordering
    final chatRestoreFinder = find.text('استعادة المحادثات');
    final bookmarksFinder = find.text('المحفوظات');

    final chatRestoreY = tester.getCenter(chatRestoreFinder).dy;
    final bookmarksY = tester.getCenter(bookmarksFinder).dy;

    // In a vertical list, item preceding another should have a smaller Y coordinate
    expect(chatRestoreY, lessThan(bookmarksY));
  });
}
