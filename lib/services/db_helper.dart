import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'favorite_location.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_location(id TEXT PRIMARY KEY, name TEXT, loc_lat REAL, loc_lng REAL, temp REAL, description TEXT, icon TEXT, timezone INTEGER)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();

    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> delete(String table, String id) async {
    // print('delete func: received id: $id');
    final db = await DBHelper.database();

    db.delete(table, where: "id = ?", whereArgs: [id]);
  }
}
