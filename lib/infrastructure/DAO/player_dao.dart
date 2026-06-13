import 'package:sample_sport_stats/infrastructure/Entities/player_entity.dart';
import 'package:sample_sport_stats/infrastructure/SqliteHelper.dart';

class PlayerDAO {
  final dbHelper = SqliteHelper.instance;

  Future<int> insertPlayer(PlayerEntity entity) async {
    final db = await dbHelper.database;
    return await db.insert('player', entity.toMap());
  }

  Future<List<PlayerEntity>> getPlayersByTeamId(int teamId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'player',
      where: 'team_id = ?',
      whereArgs: [teamId],
      orderBy: 'number ASC',
    );
    return maps.map(PlayerEntity.fromMap).toList();
  }

  Future<void> deletePlayer(int id) async {
    final db = await dbHelper.database;
    await db.delete('player', where: 'id = ?', whereArgs: [id]);
  }
}
