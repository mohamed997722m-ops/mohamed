import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:ui' as ui;
import '../services/database_service.dart';

class BookmarksScreen extends StatefulWidget {
  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<Map<String, dynamic>> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    _refreshBookmarks();
  }

  Future<void> _refreshBookmarks() async {
    final db = await DatabaseService().database;
    final data = await db.query('bookmarks');
    setState(() {
      _bookmarks = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('المحفوظات')),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: _bookmarks.isEmpty
            ? Center(child: Text('لا يوجد روابط محفوظة'))
            : ListView.builder(
                itemCount: _bookmarks.length,
                itemBuilder: (ctx, i) => ListTile(
                  leading: Icon(Icons.link, color: Colors.green),
                  title: Text(_bookmarks[i]['title'] ?? 'رابط'),
                  subtitle: Text(_bookmarks[i]['url'] ?? ''),
                  onLongPress: () async {
                    final db = await DatabaseService().database;
                    await db.delete('bookmarks', where: 'id = ?', whereArgs: [_bookmarks[i]['id']]);
                    _refreshBookmarks();
                  },
                ),
              ),
      ),
    );
  }
}
