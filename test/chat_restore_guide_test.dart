import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';
import 'package:masar/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:masar/providers/profile_provider.dart';
import 'package:masar/providers/settings_provider.dart';

void main() {
  testWidgets('ChatRestoreGuideScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChatRestoreGuideScreen(),
      ),
    );

    expect(find.text('دليل استعادة المحادثات'), findsOneWidget);
    expect(find.textContaining('واتساب'), findsAtLeastNWidgets(1));
    expect(find.textContaining('تليجرام'), findsAtLeastNWidgets(1));
    expect(find.textContaining('فيسبوك'), findsAtLeastNWidgets(1));
    expect(find.textContaining('إنستجرام'), findsAtLeastNWidgets(1));
  });

  testWidgets('MainDrawer contains Chat Restore Guide link', (WidgetTester tester) async {
    // Set a large surface size to avoid overflow in tests
    tester.view.physicalSize = Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
        child: MaterialApp(
          home: Scaffold(
            drawer: MainDrawer(),
          ),
        ),
      ),
    );

    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('استعادة المحادثات'), findsOneWidget);
    expect(find.byIcon(Icons.restore), findsOneWidget);

    // Reset surface size
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
