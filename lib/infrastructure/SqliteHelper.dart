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
      version: 1,
      onCreate: (db, version) async {
        // Create tables and define schema
        await db.execute('''
          CREATE TABLE team (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
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
      },
    );
  }

}