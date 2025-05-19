import 'dart:developer';

import 'package:sample_sport_stats/infrastructure/Entities/quarter_entity.dart';
import 'package:sample_sport_stats/infrastructure/SqliteHelper.dart';

class QuarterDao {
  final dbHelper = SqliteHelper.instance;

  Future<int> insertQuarter(QuarterEntity quarter) async {
    final db = await dbHelper.database;
    var id = await db.insert('quarter', quarter.toMap());

    return id;
  }

  Future<List<QuarterEntity>> getQuarters() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('quarter');
    return List.generate(maps.length, (i) {
      return QuarterEntity.fromMap(maps[i]);
    });
  }

  Future<List<QuarterEntity>> getQuartersByGame(int id) async {
    var quarters = await getQuarters();
    log("GAME_ID : " + id.toString());
    log("ALL : " + quarters.toString());
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('quarter', where: 'game_id = ?', whereArgs: [id]);
    return List.generate(maps.length, (i) {
      return QuarterEntity.fromMap(maps[i]);
    });
  }
}
