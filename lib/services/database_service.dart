import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }
    String path = join(await getDatabasesPath(), 'masar_database.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE lectures (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject TEXT,
        doctor TEXT,
        building TEXT,
        room TEXT,
        day TEXT,
        startTime TEXT,
        endTime TEXT,
        hasQuiz INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE sections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject TEXT,
        ta TEXT,
        building TEXT,
        room TEXT,
        day TEXT,
        startTime TEXT,
        endTime TEXT,
        hasQuiz INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        dueDate TEXT,
        isDone INTEGER,
        relatedSubject TEXT,
        color INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        dateTime TEXT,
        type TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT,
        imagePath TEXT,
        createdAt TEXT,
        color INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT,
        title TEXT,
        type TEXT,
        localPath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE quran_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        surah TEXT,
        verse INTEGER,
        updatedAt TEXT
      )
    ''');

    await _createV2Tables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE tasks ADD COLUMN color INTEGER');
      await db.execute('ALTER TABLE notes ADD COLUMN color INTEGER');
      await _createV2Tables(db);
    }
  }

  Future<void> _createV2Tables(Database db) async {
    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        subjectId INTEGER,
        type TEXT,
        status INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE friends (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        profileLink TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        friendId INTEGER,
        content TEXT,
        timestamp TEXT,
        isMe INTEGER
      )
    ''');
  }
}
