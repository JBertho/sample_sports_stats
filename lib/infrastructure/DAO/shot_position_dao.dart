import 'package:sample_sport_stats/infrastructure/Entities/shot_position_entity.dart';
import 'package:sample_sport_stats/infrastructure/SqliteHelper.dart';

class ShotPositionDAO {
  final dbHelper = SqliteHelper.instance;

  Future<int> insertShotPosition(ShotPositionEntity entity) async {
    final db = await dbHelper.database;
    return await db.insert('shot_positions', entity.toMap());
  }

  Future<List<ShotPositionEntity>> getShotPositionsByGameId(int gameId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'shot_positions',
      where: 'game_id = ?',
      whereArgs: [gameId],
    );
    return maps.map(ShotPositionEntity.fromMap).toList();
  }

  Future<void> deleteShotPositionsByGameId(int gameId) async {
    final db = await dbHelper.database;
    await db.delete('shot_positions', where: 'game_id = ?', whereArgs: [gameId]);
  }
}
