import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar/main.dart';
import 'package:provider/provider.dart';
import 'package:masar/providers/profile_provider.dart';
import 'package:masar/providers/settings_provider.dart';
import 'package:masar/screens/chat_restore_guide_screen.dart';
import 'package:masar/widgets/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final profileProvider = ProfileProvider();
    final settingsProvider = SettingsProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: profileProvider),
          ChangeNotifierProvider.value(value: settingsProvider),
        ],
        child: MasarApp(),
      ),
    );

    expect(find.text('أهلاً بك في مسار'), findsOneWidget);
  });

  testWidgets('ChatRestoreGuideScreen displays guides and is in Drawer', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // 1. Test ChatRestoreGuideScreen directly
    await tester.pumpWidget(
      MaterialApp(
        home: ChatRestoreGuideScreen(),
      ),
    );

    expect(find.text('دليل استعادة المحادثات'), findsOneWidget);
    expect(find.text('1. واتساب (WhatsApp)'), findsOneWidget);
    expect(find.text('2. تليجرام (Telegram)'), findsOneWidget);
    expect(find.text('3. فيسبوك ماسنجر (Facebook Messenger)'), findsOneWidget);
    expect(find.text('4. إنستجرام (Instagram)'), findsOneWidget);

    // 2. Test Drawer items presence
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

    expect(find.text('استعادة المحادثات'), findsOneWidget);
    expect(find.text('المحفوظات'), findsOneWidget);
  });
}
