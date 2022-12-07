import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:wombocombo/models/boxing_attack.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();

    return await sql.openDatabase(path.join(dbPath, 'boxingattacks.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE boxing_attacks(attackName TEXT, attackImage TEXT, correspondingNumber TEXT PRIMARY KEY)');
    }, version: 1);
  }

  static Future<void> initialInsert() async {
    final db = await DBHelper.database();
    db.transaction(
      (txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO boxing_attacks(attackName, attackImage, correspondingNumber) VALUES("test", "test", "test1")');
        print('insert1 $id1');
      },
    );
  }

  static Future<void> drop() async {
    final db = await DBHelper.database();
    db.delete('boxing_attacks');
  }
  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();

    db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
