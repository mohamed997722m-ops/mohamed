import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProv = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('الإعدادات'),
        backgroundColor: Colors.green,
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: ListView(
          children: [
            SwitchListTile(
              title: Text('الوضع الصامت (تجاهل التنبيهات)'),
              value: settingsProv.isSilentMode,
              activeColor: Colors.red,
              onChanged: (val) => settingsProv.toggleSilentMode(),
            ),
            ListTile(
              title: Text('وقت التذكير بالمحاضرات'),
              subtitle: Text(_translateOffset(settingsProv.reminderOffset)),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showOffsetDialog(context, settingsProv),
            ),
            Divider(),
            ListTile(
              title: Text('حول التطبيق'),
              subtitle: Text('مسار v1.0.0'),
            ),
          ],
        ),
      ),
    );
  }

  String _translateOffset(String offset) {
    switch (offset) {
      case "night_before": return "قبلها بليلة";
      case "1_hour": return "قبلها بساعة";
      case "30_min": return "قبلها بـ 30 دقيقة";
      default: return offset;
    }
  }

  void _showOffsetDialog(BuildContext context, SettingsProvider prov) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: ui.TextDirection.rtl,
        child: SimpleDialog(
          title: Text('اختر وقت التذكير'),
          children: [
            _option(ctx, prov, "night_before", "قبلها بليلة"),
            _option(ctx, prov, "1_hour", "قبلها بساعة"),
            _option(ctx, prov, "30_min", "قبلها بـ 30 دقيقة"),
          ],
        ),
      ),
    );
  }

  Widget _option(BuildContext ctx, SettingsProvider prov, String value, String text) {
    return SimpleDialogOption(
      onPressed: () {
        prov.setReminderOffset(value);
        Navigator.pop(ctx);
      },
      child: Text(text),
    );
  }
}
