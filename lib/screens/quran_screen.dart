import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import '../services/database_service.dart';

class QuranScreen extends StatefulWidget {
  @override
  _QuranScreenState createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final _surahController = TextEditingController();
  final _verseController = TextEditingController();
  Map<String, dynamic>? _lastProgress;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final db = await DatabaseService().database;
    final data = await db.query('quran_progress', orderBy: 'id DESC', limit: 1);
    if (data.isNotEmpty) {
      setState(() {
        _lastProgress = data.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ورد القرآن')),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_lastProgress != null)
                Card(
                  color: Colors.green.withOpacity(0.1),
                  child: ListTile(
                    title: Text('آخر ما وصلت إليه:'),
                    subtitle: Text('سورة ${_lastProgress!['surah']} - آية ${_lastProgress!['verse']}'),
                    trailing: Text(_lastProgress!['updatedAt']),
                  ),
                ),
              SizedBox(height: 20),
              TextField(controller: _surahController, decoration: InputDecoration(labelText: 'اسم السورة')),
              TextField(controller: _verseController, decoration: InputDecoration(labelText: 'رقم الآية'), keyboardType: TextInputType.number),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProgress,
                child: Text('حفظ التقدم'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProgress() async {
    if (_surahController.text.isNotEmpty && _verseController.text.isNotEmpty) {
      final db = await DatabaseService().database;
      await db.insert('quran_progress', {
        'surah': _surahController.text,
        'verse': int.parse(_verseController.text),
        'updatedAt': DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()),
      });
      _surahController.clear();
      _verseController.clear();
      _loadProgress();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم حفظ الورد بنجاح')));
    }
  }
}
