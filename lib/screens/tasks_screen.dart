import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../services/database_service.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> _tasks = [];

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
        title: Text('التاسكات'),
        backgroundColor: Colors.green,
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: _tasks.isEmpty
            ? Center(child: Text('لا يوجد تاسكات مضافة'))
            : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (ctx, i) {
                  final task = _tasks[i];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Icon(
                        task['isDone'] == 1 ? Icons.check_circle : Icons.error,
                        color: task['isDone'] == 1 ? Colors.green : Colors.red,
                      ),
                      title: Text(task['title']),
                      subtitle: Text("الموعد: ${task['dueDate']}"),
                      onLongPress: () async {
                         final db = await DatabaseService().database;
                         await db.delete('tasks', where: 'id = ?', whereArgs: [task['id']]);
                         _refreshTasks();
                      },
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
        textDirection: ui.TextDirection.rtl,
        child: AlertDialog(
          title: Text('إضافة تاسك جديد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _titleController, decoration: InputDecoration(labelText: 'العنوان')),
              TextField(controller: _dateController, decoration: InputDecoration(labelText: 'تاريخ التسليم')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('إلغاء')),
            TextButton(
              onPressed: () async {
                final db = await DatabaseService().database;
                await db.insert('tasks', {
                  'title': _titleController.text,
                  'dueDate': _dateController.text,
                  'isDone': 0,
                  'description': '',
                  'relatedSubject': '',
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
}
