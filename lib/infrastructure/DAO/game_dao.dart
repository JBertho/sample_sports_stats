import 'package:sample_sport_stats/infrastructure/Entities/game_entity.dart';
import 'package:sample_sport_stats/infrastructure/SqliteHelper.dart';

class GameDAO {
  final dbHelper = SqliteHelper.instance;

  Future<void> insertGame(GameEntity game) async {
    final db = await dbHelper.database;
    await db.insert('game', game.toMap());
  }

  Future<List<GameEntity>> getGames() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('game');
    return List.generate(maps.length, (i) {
      return GameEntity.fromMap(maps[i]);
    });
  }

  Future<void> updateGame(GameEntity game) async {
    final db = await dbHelper.database;
    await db.update('game', game.toMap(), where: 'id = ?', whereArgs: [game.id]);
  }

  Future<void> deleteGame(int id) async {
    final db = await dbHelper.database;
    await db.delete('game', where: 'id = ?', whereArgs: [id]);
  }
}