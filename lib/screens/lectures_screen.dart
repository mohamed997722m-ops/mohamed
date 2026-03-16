import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class LecturesScreen extends StatefulWidget {
  @override
  _LecturesScreenState createState() => _LecturesScreenState();
}

class _LecturesScreenState extends State<LecturesScreen> {
  List<Map<String, dynamic>> _lectures = [];

  @override
  void initState() {
    super.initState();
    _refreshLectures();
  }

  Future<void> _refreshLectures() async {
    final db = await DatabaseService().database;
    final data = await db.query('lectures');
    setState(() {
      _lectures = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المحاضرات'),
        backgroundColor: Colors.green,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _lectures.isEmpty
            ? Center(child: Text('لا يوجد محاضرات مضافة'))
            : ListView.builder(
                itemCount: _lectures.length,
                itemBuilder: (ctx, i) => Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(_lectures[i]['subject'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("الدكتور: ${_lectures[i]['doctor']}"),
                        Text("المكان: ${_lectures[i]['building']} - ${_lectures[i]['room']}"),
                        Text("اليوم: ${_getDayArabic(_lectures[i]['day'])}"),
                      ],
                    ),
                    trailing: Text(_lectures[i]['startTime'], style: TextStyle(fontWeight: FontWeight.bold)),
                    onLongPress: () => _deleteLecture(_lectures[i]['id']),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLectureDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _getDayArabic(String day) {
    switch (day) {
      case 'Saturday': return 'السبت';
      case 'Sunday': return 'الأحد';
      case 'Monday': return 'الاثنين';
      case 'Tuesday': return 'الثلاثاء';
      case 'Wednesday': return 'الأربعاء';
      case 'Thursday': return 'الخميس';
      case 'Friday': return 'الجمعة';
      default: return day;
    }
  }

  void _showAddLectureDialog(BuildContext context) {
    final _subjectController = TextEditingController();
    final _doctorController = TextEditingController();
    final _buildingController = TextEditingController();
    final _roomController = TextEditingController();
    String _selectedDay = 'Saturday';
    TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0);
    TimeOfDay _endTime = TimeOfDay(hour: 11, minute: 0);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('إضافة محاضرة جديدة'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: _subjectController, decoration: InputDecoration(labelText: 'اسم المادة')),
                  TextField(controller: _doctorController, decoration: InputDecoration(labelText: 'اسم الدكتور')),
                  TextField(controller: _buildingController, decoration: InputDecoration(labelText: 'المبنى')),
                  TextField(controller: _roomController, decoration: InputDecoration(labelText: 'القاعة/المدرج')),
                  DropdownButtonFormField<String>(
                    value: _selectedDay,
                    items: ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
                        .map((d) => DropdownMenuItem(value: d, child: Text(_getDayArabic(d)))).toList(),
                    onChanged: (val) => _selectedDay = val!,
                    decoration: InputDecoration(labelText: 'اليوم'),
                  ),
                  ListTile(
                    title: Text("وقت البدء: ${_startTime.format(context)}"),
                    trailing: Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(context: context, initialTime: _startTime);
                      if (picked != null) setState(() => _startTime = picked);
                    },
                  ),
                  ListTile(
                    title: Text("وقت الانتهاء: ${_endTime.format(context)}"),
                    trailing: Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(context: context, initialTime: _endTime);
                      if (picked != null) setState(() => _endTime = picked);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('إلغاء')),
              TextButton(
                onPressed: () async {
                  final db = await DatabaseService().database;
                  await db.insert('lectures', {
                    'subject': _subjectController.text,
                    'doctor': _doctorController.text,
                    'building': _buildingController.text,
                    'room': _roomController.text,
                    'day': _selectedDay,
                    'startTime': '${_startTime.hour}:${_startTime.minute}',
                    'endTime': '${_endTime.hour}:${_endTime.minute}',
                    'hasQuiz': 0,
                  });
                  Navigator.of(ctx).pop();
                  _refreshLectures();
                  // Notification logic will be handled centrally
                },
                child: Text('حفظ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteLecture(int id) async {
    final db = await DatabaseService().database;
    await db.delete('lectures', where: 'id = ?', whereArgs: [id]);
    _refreshLectures();
  }
}
