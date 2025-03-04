import 'package:sample_sport_stats/infrastructure/Entities/team_entity.dart';
import 'package:sample_sport_stats/infrastructure/SqliteHelper.dart';

class TeamDao {
  final dbHelper = SqliteHelper.instance;

  Future<int> insertTeam(TeamEntity team) async {
    final db = await dbHelper.database;
    return await db.insert('team', team.toMap());

  }

  Future<List<TeamEntity>> getTeams() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('team');
    return List.generate(maps.length, (i) {
      return TeamEntity.fromMap(maps[i]);
    });
  }

  Future<void> updateTeam(TeamEntity team) async {
    final db = await dbHelper.database;
    await db.update('team', team.toMap(), where: 'id = ?', whereArgs: [team.id]);
  }

  Future<void> deleteTeam(int id) async {
    final db = await dbHelper.database;
    await db.delete('team', where: 'id = ?', whereArgs: [id]);
  }
}