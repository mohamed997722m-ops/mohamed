import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
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
    final now = DateTime.now();
    for (var period in _todayPeriods) {
      final endTimeParts = (period['endTime'] as String).split(':');
      final endHour = int.parse(endTimeParts[0]);
      final endMin = int.parse(endTimeParts[1]);

      final endDateTime = DateTime(now.year, now.month, now.day, endHour, endMin);

      if (now.isAfter(endDateTime) && now.isBefore(endDateTime.add(Duration(hours: 2)))) {
        // Show attendance dialog if not already answered
        _showAttendanceDialog(period);
      }
    }
  }

  void _showAttendanceDialog(Map<String, dynamic> period) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: ui.TextDirection.rtl,
        child: AlertDialog(
          title: Text('سؤال الحضور'),
          content: Text('هل حضرت محاضرة ${period['subject']}؟'),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<ProfileProvider>(context, listen: false).updateScore(10);
                Navigator.pop(ctx);
              },
              child: Text('نعم (جدع)', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ProfileProvider>(context, listen: false).updateScore(-5);
                Navigator.pop(ctx);
              },
              child: Text('لا (للأسف)', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProv = Provider.of<ProfileProvider>(context);
    final profile = profileProv.profile;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('مسار', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_active, color: Colors.white),
            onPressed: () {},
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
                _buildHeader(profile),
                SizedBox(height: 20),
                _buildDateSection(),
                SizedBox(height: 20),
                if (_prayerTimes != null) _buildPrayerSection(),
                if (_prayerTimes != null) SizedBox(height: 20),
                _buildScoreSection(profile?.score ?? 0),
                SizedBox(height: 20),
                Text('فترات اليوم:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                SizedBox(height: 10),
                _todayPeriods.isEmpty
                  ? Center(child: Text('لا يوجد محاضرات أو سكاشن اليوم'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _todayPeriods.length,
                      itemBuilder: (ctx, i) => _buildPeriodCard(_todayPeriods[i]),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(profile) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('مرحباً، ${profile?.name ?? ""}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${profile?.college ?? ""} - ${profile?.department ?? ""}', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _dateCard('التاريخ الميلادي', _gregorianDate, Icons.calendar_month),
        _dateCard('التاريخ الهجري', _hijriDate, Icons.event_note),
      ],
    );
  }

  Widget _dateCard(String title, String date, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon, color: Colors.green),
              SizedBox(height: 5),
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(date, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
                Text('مواقيت الصلاة اليوم', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _prayerTime('الفجر', _prayerTimes!['Fajr']),
                _prayerTime('الظهر', _prayerTimes!['Dhuhr']),
                _prayerTime('العصر', _prayerTimes!['Asr']),
                _prayerTime('المغرب', _prayerTimes!['Maghrib']),
                _prayerTime('العشاء', _prayerTimes!['Isha']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _prayerTime(String name, String time) {
    return Column(
      children: [
        Text(name, style: TextStyle(fontSize: 10, color: Colors.grey)),
        Text(time, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildScoreSection(int score) {
    return Card(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مستواك الحالي', style: TextStyle(color: Colors.white, fontSize: 16)),
                Text('النقاط: $score', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            Icon(
              score >= 50 ? Icons.sentiment_very_satisfied : Icons.sentiment_neutral,
              color: Colors.white,
              size: 50,
            ),
          ],
        ),
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
}
