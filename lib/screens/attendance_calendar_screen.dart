import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import '../services/database_service.dart';

class AttendanceCalendarScreen extends StatefulWidget {
  @override
  _AttendanceCalendarScreenState createState() => _AttendanceCalendarScreenState();
}

class _AttendanceCalendarScreenState extends State<AttendanceCalendarScreen> {
  Map<String, int> _attendanceData = {}; // 'yyyy-MM-dd' -> status (1=present, 0=absent)

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query('attendance');

    setState(() {
      _attendanceData = {
        for (var m in maps) m['date'] as String: m['status'] as int
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سجل الحضور والغياب'),
        backgroundColor: Colors.green,
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildLegend(),
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: 31, // Simple 31-day view for demo
                  itemBuilder: (ctx, i) {
                    final day = i + 1;
                    final dateStr = DateFormat('yyyy-MM-').format(DateTime.now()) + (day < 10 ? '0$day' : '$day');
                    final status = _attendanceData[dateStr];

                    return Container(
                      decoration: BoxDecoration(
                        color: status == 1 ? Colors.green : (status == 0 ? Colors.red : Colors.grey[200]),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Center(child: Text('$day', style: TextStyle(color: status != null ? Colors.white : Colors.black))),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _legendItem(Colors.green, "حاضر"),
        _legendItem(Colors.red, "غائب"),
        _legendItem(Colors.grey[200]!, "لا يوجد محاضرات"),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 15, height: 15, color: color),
        SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
