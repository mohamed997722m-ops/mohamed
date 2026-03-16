import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/profile_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/main_drawer.dart';
import '../services/database_service.dart';
import '../services/prayer_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _gregorianDate = "";
  String _hijriDate = "";
  List<Map<String, dynamic>> _todayPeriods = [];
  Map<String, dynamic>? _prayerTimes;

  @override
  void initState() {
    super.initState();
    _updateDates();
    _fetchTodayPeriods();
    _fetchPrayerTimes();
  }

  Future<void> _fetchPrayerTimes() async {
    final times = await PrayerService().getPrayerTimes();
    if (times != null) {
      setState(() {
        _prayerTimes = times;
      });
    }
  }

  void _updateDates() {
    final now = DateTime.now();
    _gregorianDate = DateFormat('yyyy/MM/dd').format(now);

    final hijri = HijriCalendar.now();
    _hijriDate = "${hijri.hYear}/${hijri.hMonth}/${hijri.hDay}";
  }

  Future<void> _fetchTodayPeriods() async {
    final db = await DatabaseService().database;
    String dayName = DateFormat('EEEE').format(DateTime.now());

    final lectures = await db.query('lectures', where: 'day = ?', whereArgs: [dayName]);
    final sections = await db.query('sections', where: 'day = ?', whereArgs: [dayName]);

    setState(() {
      _todayPeriods = [...lectures, ...sections];
    });

    _checkAttendancePrompts();
  }

  void _checkAttendancePrompts() {
    // Logic for daily attendance prompt is handled in a separate service or here
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProv = Provider.of<ProfileProvider>(context);
    final profile = profileProv.profile;
    final settingsProv = Provider.of<SettingsProvider>(context);

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('مسار', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(settingsProv.isSilentMode ? Icons.notifications_off : Icons.notifications_active),
            color: settingsProv.isSilentMode ? Colors.red : Colors.white,
            onPressed: () {
              settingsProv.toggleSilentMode();
              if (settingsProv.isSilentMode) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('يا جدع عيب 😠', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to profile edit
            },
          )
        ],
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(profile, profileProv.rank),
                SizedBox(height: 20),
                _buildDateSection(),
                SizedBox(height: 20),
                if (_prayerTimes != null) _buildPrayerSection(),
                if (_prayerTimes != null) SizedBox(height: 20),
                _buildQuickActions(),
                SizedBox(height: 20),
                Text('فترات اليوم:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                SizedBox(height: 10),
                _todayPeriods.isEmpty
                  ? Center(child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('لا يوجد محاضرات أو سكاشن اليوم'),
                  ))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _todayPeriods.length,
                      itemBuilder: (ctx, i) => _buildPeriodCard(_todayPeriods[i]),
                    ),
                SizedBox(height: 20),
                _buildDeveloperFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(profile, String rank) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green,
            child: Icon(Icons.person, color: Colors.white, size: 35),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مرحباً، ${profile?.name ?? "يا بطل"}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(rank, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                if (profile != null) Text('${profile.college} - ${profile.department}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
            child: Text('${profile?.score ?? 0} نقطة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage("https://www.transparenttextures.com/patterns/islamic-art.png"),
          repeat: ImageRepeat.repeat,
          opacity: 0.05,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _dateItem('الميلادي', _gregorianDate, Icons.calendar_month),
          Container(width: 1, height: 40, color: Colors.green.withOpacity(0.3)),
          _dateItem('الهجري', _hijriDate, Icons.event_note),
        ],
      ),
    );
  }

  Widget _dateItem(String title, String date, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.green, size: 16),
            SizedBox(width: 5),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        Text(date, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        _quickActionBtn(Icons.account_balance, "جامعتي", Colors.blue, () => _launchURL("https://mohe.gov.eg/")),
        SizedBox(width: 10),
        _quickActionBtn(Icons.link, "روابطي", Colors.orange, () {}),
        SizedBox(width: 10),
        _quickActionBtn(Icons.people, "أصحابي", Colors.purple, () {}),
      ],
    );
  }

  Widget _quickActionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color),
              SizedBox(height: 5),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.mosque, color: Colors.green),
                SizedBox(width: 10),
                Text('مواقيت الصلاة', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _prayerTime('الفجر', _prayerTimes!['Fajr']),
                  _prayerTime('الظهر', _prayerTimes!['Dhuhr']),
                  _prayerTime('العصر', _prayerTimes!['Asr']),
                  _prayerTime('المغرب', _prayerTimes!['Maghrib']),
                  _prayerTime('العشاء', _prayerTimes!['Isha']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _prayerTime(String name, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Text(name, style: TextStyle(fontSize: 10, color: Colors.grey)),
          Text(time, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPeriodCard(Map<String, dynamic> period) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          width: 5,
          color: period.containsKey('doctor') ? Colors.blue : Colors.orange,
        ),
        title: Text(period['subject'] ?? ""),
        subtitle: Text("${period['startTime']} - ${period['endTime']} | ${period['building']} - ${period['room']}"),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Widget _buildDeveloperFooter() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text("صنع بواسطة محمد سعيد", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: Icon(Icons.camera_alt), onPressed: () => _launchURL("https://www.instagram.com/mohamed_s_60")),
              IconButton(icon: Icon(Icons.video_library), onPressed: () => _launchURL("https://www.tiktok.com/@mo.saied_")),
            ],
          )
        ],
      ),
    );
  }
}
