import 'package:sample_sport_stats/infrastructure/Entities/game_entity.dart';
import 'package:sample_sport_stats/infrastructure/SqliteHelper.dart';

class GameDAO {
  final dbHelper = SqliteHelper.instance;

  Future<int> insertGame(GameEntity game) async {
    final db = await dbHelper.database;
    var id = await db.insert('game', game.toMap());

    return id;
  }

  Future<List<GameEntity>> getGames() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('game');
    return List.generate(maps.length, (i) {
      return GameEntity.fromMap(maps[i]);
    });
  }

  Future<List<GameEntity>> getGamesByTeamId(int id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> gamesMap =
        await db.query('game', where: 'team_id = ?', whereArgs: [id]);
    final List<GameEntity> games = [];
    for (Map<String, dynamic> game in gamesMap) {
      games.add(GameEntity.fromMap(game));
    }
    return games;
  }

  Future<void> updateGame(GameEntity game) async {
    final db = await dbHelper.database;
    await db
        .update('game', game.toMap(), where: 'id = ?', whereArgs: [game.id]);
  }

  Future<void> deleteGame(int id) async {
    final db = await dbHelper.database;
    await db.delete('game', where: 'id = ?', whereArgs: [id]);
  }
}
