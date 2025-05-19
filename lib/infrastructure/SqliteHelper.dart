import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteHelper {
  SqliteHelper._();

  static final SqliteHelper instance = SqliteHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final String path = join(await getDatabasesPath(), 'basket_app.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        // Create tables and define schema
        await db.execute('''
          CREATE TABLE team (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            division TEXT,
            season TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE game (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            opponent_name TEXT,
            team_score INTEGER,
            opponent_score INTEGER,
            At_home INTEGER,
            team_id INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE quarter (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            game_id INTEGER,
            team_score INTEGER,
            opponent_score INTEGER,
            quarter_number INTEGER,
            duration INTEGER
          )
        ''');
      },
      onUpgrade: (db, previous, after) async {
        await db.execute('''
          CREATE TABLE quarter (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            game_id INTEGER,
            team_score INTEGER,
            opponent_score INTEGER,
            quarter_number INTEGER,
            duration INTEGER
          )
        ''');
      }
    );
  }

}