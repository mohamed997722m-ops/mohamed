import 'package:flutter/material.dart';
import '../services/database_service.dart';

class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<Map<String, dynamic>> _friends = [];

  @override
  void initState() {
    super.initState();
    _refreshFriends();
  }

  Future<void> _refreshFriends() async {
    final db = await DatabaseService().database;
    final data = await db.query('friends');
    setState(() {
      _friends = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أصدقائي في مسار'),
        backgroundColor: Colors.green,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _friends.isEmpty
            ? Center(child: Text('لا يوجد أصدقاء مضافين'))
            : ListView.builder(
                itemCount: _friends.length,
                itemBuilder: (ctx, i) => ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text(_friends[i]['name']),
                  subtitle: Text(_friends[i]['profileLink']),
                  trailing: Icon(Icons.chat, color: Colors.green),
                  onTap: () => _openChat(_friends[i]),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFriendDialog(context),
        child: Icon(Icons.person_add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _linkController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('إضافة صديق جديد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameController, decoration: InputDecoration(labelText: 'اسم الصديق')),
              TextField(controller: _linkController, decoration: InputDecoration(labelText: 'رابط الملف الشخصي (مسار)')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
            TextButton(
              onPressed: () async {
                final db = await DatabaseService().database;
                await db.insert('friends', {
                  'name': _nameController.text,
                  'profileLink': _linkController.text,
                });
                Navigator.pop(ctx);
                _refreshFriends();
              },
              child: Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  void _openChat(Map<String, dynamic> friend) {
    // Navigate to a chat mockup
  }
}
