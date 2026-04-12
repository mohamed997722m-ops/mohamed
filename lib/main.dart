import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'providers/profile_provider.dart';
import 'providers/settings_provider.dart';
import 'services/notification_service.dart';
import 'services/database_service.dart';
import 'utils/app_theme.dart';
import 'utils/morning_messages.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final profileProvider = ProfileProvider();
  await profileProvider.loadProfile();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  await NotificationService().init();
  _scheduleMorningMessage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: profileProvider),
        ChangeNotifierProvider.value(value: settingsProvider),
      ],
      child: MasarApp(),
    ),
  );
}

void _scheduleMorningMessage() {
  final random = Random();
  final message = MorningMessages.messages[random.nextInt(MorningMessages.messages.length)];

  // Schedule for 8:15 AM
  final now = DateTime.now();
  final scheduledTime = DateTime(now.year, now.month, now.day, 8, 15);

  NotificationService().scheduleNotification(
    999,
    "رسالة الصباح",
    message,
    scheduledTime.isBefore(now) ? scheduledTime.add(Duration(days: 1)) : scheduledTime,
  );
}

class MasarApp extends StatefulWidget {
  @override
  _MasarAppState createState() => _MasarAppState();
}

class _MasarAppState extends State<MasarApp> {
  StreamSubscription? _intentDataStreamSubscription;

  bool get _shouldBypass => kIsWeb || Platform.environment.containsKey('FLUTTER_TEST');

  @override
  void initState() {
    super.initState();
    if (_shouldBypass) return;

    final dynamic plugin = ReceiveSharingIntent.instance;

    _intentDataStreamSubscription = plugin.getMediaStream().listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty && value.first.path.isNotEmpty) {
        _saveSharedLink(value.first.path);
      }
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    plugin.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty && value.first.path.isNotEmpty) {
        _saveSharedLink(value.first.path);
      }
    });
  }

  void _saveSharedLink(String link) async {
    final db = await DatabaseService().database;
    await db.insert('bookmarks', {
      'url': link,
      'title': 'رابط مشترك',
      'type': 'link',
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مسار',
      theme: AppTheme.lightTheme,
      home: Consumer<ProfileProvider>(
        builder: (ctx, profileProv, _) =>
          profileProv.profile == null ? OnboardingScreen() : HomeScreen(),
      ),
    );
  }
}
