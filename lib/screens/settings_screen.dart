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
        textDirection: TextDirection.rtl,
        child: ListView(
          children: [
            SwitchListTile(
              title: Text('الوضع الصامت (تجاهل التنبيهات)'),
              value: settingsProv.isSilentMode,
              activeColor: Colors.red,
              onChanged: (val) {
                settingsProv.toggleSilentMode();
                if (val) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('يا جدع عيب 😠', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
                  );
                }
              },
            ),
            SwitchListTile(
              title: Text('الوضع الليلي'),
              value: settingsProv.isDarkMode,
              onChanged: (val) => settingsProv.toggleDarkMode(),
            ),
            ListTile(
              title: Text('وقت التذكير المسائي'),
              subtitle: Text(settingsProv.reminderTime),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: int.parse(settingsProv.reminderTime.split(':')[0]),
                    minute: int.parse(settingsProv.reminderTime.split(':')[1]),
                  ),
                );
                if (picked != null) {
                  settingsProv.setReminderTime("${picked.hour}:${picked.minute}");
                }
              },
            ),
            Divider(),
            ListTile(
              title: Text('حول التطبيق'),
              subtitle: Text('مسار v1.0.0 - صنع بواسطة محمد سعيد'),
            ),
          ],
        ),
      ),
    );
  }
}
