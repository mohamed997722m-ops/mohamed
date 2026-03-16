import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'dart:math';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> _tasks = [];
  final List<Color> _vividColors = [
    Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.pink, Colors.teal, Colors.indigo
  ];

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  Future<void> _refreshTasks() async {
    final db = await DatabaseService().database;
    final data = await db.query('tasks');
    setState(() {
      _tasks = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التاسكات (المهمات)'),
        backgroundColor: Colors.green,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _tasks.isEmpty
            ? Center(child: Text('لا يوجد تاسكات مضافة'))
            : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (ctx, i) {
                  final task = _tasks[i];
                  final color = task['color'] != null ? Color(task['color']) : _vividColors[i % _vividColors.length];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: color, width: 2),
                    ),
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(
                          task['isDone'] == 1 ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: color,
                        ),
                        onPressed: () => _toggleDone(task),
                      ),
                      title: Text(task['title'], style: TextStyle(fontWeight: FontWeight.bold, decoration: task['isDone'] == 1 ? TextDecoration.lineThrough : null)),
                      subtitle: Text("موعد التسليم: ${task['dueDate']}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.grey),
                        onPressed: () => _deleteTask(task['id']),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('إضافة تاسك جديد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _titleController, decoration: InputDecoration(labelText: 'اسم التاسك')),
              TextField(controller: _dateController, decoration: InputDecoration(labelText: 'تاريخ التسليم')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('إلغاء')),
            TextButton(
              onPressed: () async {
                final db = await DatabaseService().database;
                final randomColor = _vividColors[Random().nextInt(_vividColors.length)].value;
                await db.insert('tasks', {
                  'title': _titleController.text,
                  'dueDate': _dateController.text,
                  'isDone': 0,
                  'description': '',
                  'relatedSubject': '',
                  'color': randomColor,
                });
                Navigator.of(ctx).pop();
                _refreshTasks();
              },
              child: Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleDone(Map<String, dynamic> task) async {
    final db = await DatabaseService().database;
    await db.update('tasks', {'isDone': task['isDone'] == 1 ? 0 : 1}, where: 'id = ?', whereArgs: [task['id']]);
    _refreshTasks();
  }

  void _deleteTask(int id) async {
    final db = await DatabaseService().database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
    _refreshTasks();
  }
}
