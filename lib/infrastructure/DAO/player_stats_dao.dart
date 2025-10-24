import 'package:sample_sport_stats/infrastructure/Entities/player_stats_entity.dart';
import 'package:sample_sport_stats/infrastructure/SqliteHelper.dart';

class PlayerStatsDAO {
  final dbHelper = SqliteHelper.instance;

  Future<int> insertPlayerStats(PlayerStatsEntity playerStats) async {
    final db = await dbHelper.database;
    var id = await db.insert('player_stats', playerStats.toMap());

    return id;
  }

  Future<List<PlayerStatsEntity>> getPlayerStats() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('player_stats');
    return List.generate(maps.length, (i) {
      return PlayerStatsEntity.fromMap(maps[i]);
    });
  }

  Future<List<PlayerStatsEntity>> getPlayerStatsByGameId(int id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> playersStats =
        await db.query('player_stats', where: 'game_id = ?', whereArgs: [id]);
    final List<PlayerStatsEntity> playerStatsEntities = [];
    for (Map<String, dynamic> playerStats in playersStats) {
      playerStatsEntities.add(PlayerStatsEntity.fromMap(playerStats));
    }
    return playerStatsEntities;
  }

  Future<void> updatePlayerStats(PlayerStatsEntity playerStatEntity) async {
    final db = await dbHelper.database;
    await db
        .update('player_stats', playerStatEntity.toMap(), where: 'id = ?', whereArgs: [playerStatEntity.id]);
  }

  Future<void> deletePlayerStats(int id) async {
    final db = await dbHelper.database;
    await db.delete('player_stats', where: 'id = ?', whereArgs: [id]);
  }
}
