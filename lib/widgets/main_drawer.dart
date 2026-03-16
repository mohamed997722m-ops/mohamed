import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/lectures_screen.dart';
import '../screens/tasks_screen.dart';
import '../screens/sections_screen.dart';
import '../screens/quran_screen.dart';
import '../screens/bookmarks_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/friends_screen.dart';
import '../screens/attendance_calendar_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              accountName: Text("مسار"),
              accountEmail: Text("مساعدك الدراسي الذكي"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.school, color: Colors.green, size: 40),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerItem(Icons.home, "الرئيسية", () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
                  }),
                  _drawerItem(Icons.book, "المحاضرات", () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => LecturesScreen()));
                  }),
                  _drawerItem(Icons.group, "السكاشن", () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SectionsScreen()));
                  }),
                  _drawerItem(Icons.task, "التاسكات", () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => TasksScreen()));
                  }),
                  _drawerItem(Icons.calendar_month, "سجل الحضور", () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AttendanceCalendarScreen()));
                  }),
                  _drawerItem(Icons.people, "أصدقائي", () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => FriendsScreen()));
                  }),
                  _drawerItem(Icons.menu_book, "ورد القرآن", () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => QuranScreen()));
                  }),
                  _drawerItem(Icons.bookmark, "المحفوظات", () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookmarksScreen()));
                  }),
                  Divider(),
                  _drawerItem(Icons.settings, "الإعدادات", () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsScreen()));
                  }),
                  Divider(),
                  _buildDeveloperInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildDeveloperInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("صانع البرنامج:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
          SizedBox(height: 5),
          Text("محمد سعيد", style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold)),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.purple),
                onPressed: () => _launchURL("https://www.instagram.com/mohamed_s_60?igsh=MWg3ZmxqeGE4ZGxwaA=="),
              ),
              IconButton(
                icon: Icon(Icons.video_library, color: Colors.black),
                onPressed: () => _launchURL("https://www.tiktok.com/@mo.saied_?_r=1&_t=ZS-94gyukQjAgy"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
