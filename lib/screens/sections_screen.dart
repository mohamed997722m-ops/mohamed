import "dart:ui" as ui;
import 'package:flutter/material.dart';
import '../services/database_service.dart';

class SectionsScreen extends StatefulWidget {
  @override
  _SectionsScreenState createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  List<Map<String, dynamic>> _sections = [];

  @override
  void initState() {
    super.initState();
    _refreshSections();
  }

  Future<void> _refreshSections() async {
    final db = await DatabaseService().database;
    final data = await db.query('sections');
    setState(() {
      _sections = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('السكاشن'),
        backgroundColor: Colors.green,
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: _sections.isEmpty
            ? Center(child: Text('لا يوجد سكاشن مضافة'))
            : ListView.builder(
                itemCount: _sections.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(_sections[i]['subject']),
                  subtitle: Text("${_sections[i]['ta']} - ${_sections[i]['day']}"),
                  trailing: Text(_sections[i]['startTime']),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSectionDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAddSectionDialog(BuildContext context) {
    final _subjectController = TextEditingController();
    final _taController = TextEditingController();
    final _buildingController = TextEditingController();
    final _roomController = TextEditingController();
    String _selectedDay = 'Saturday';
    TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0);
    TimeOfDay _endTime = TimeOfDay(hour: 11, minute: 0);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            title: Text('إضافة سكشن جديد'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: _subjectController, decoration: InputDecoration(labelText: 'اسم المادة')),
                  TextField(controller: _taController, decoration: InputDecoration(labelText: 'اسم المعيد')),
                  TextField(controller: _buildingController, decoration: InputDecoration(labelText: 'المبنى')),
                  TextField(controller: _roomController, decoration: InputDecoration(labelText: 'القاعة/المعمل')),
                  DropdownButtonFormField<String>(
                    value: _selectedDay,
                    items: ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
                        .map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
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
                  await db.insert('sections', {
                    'subject': _subjectController.text,
                    'ta': _taController.text,
                    'building': _buildingController.text,
                    'room': _roomController.text,
                    'day': _selectedDay,
                    'startTime': '${_startTime.hour}:${_startTime.minute}',
                    'endTime': '${_endTime.hour}:${_endTime.minute}',
                    'hasQuiz': 0,
                  });
                  Navigator.of(ctx).pop();
                  _refreshSections();
                },
                child: Text('حفظ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
