import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:wombocombo/models/boxing_attack.dart';

class CustomComboDBhelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();

    return await sql.openDatabase(path.join(dbPath, 'customCombos.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE custom_combos(comboName TEXT PRIMARY KEY, attacks TEXT)');
    }, version: 1);
  }

  static Future<void> drop() async {
    final db = await CustomComboDBhelper.database();
    db.delete('custom_combos');
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await CustomComboDBhelper.database();

    db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await CustomComboDBhelper.database();
    return db.query(table);
  }
}
