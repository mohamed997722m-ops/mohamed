import 'dart:ui' as ui;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    String path = join(await getDatabasesPath(), 'masar_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
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
        relatedSubject TEXT
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
        createdAt TEXT
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
  }
}
