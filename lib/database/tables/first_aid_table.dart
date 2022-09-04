import 'package:care_giver/models/first_aid.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

const F_TABLE_NAME = 'tbl_first_aid';
const F_AID = 'faid';
const F_NAME = 'name';
const F_INSTRUCTION = 'instruction';
const F_CAUTION = 'caution';
const F_PHOTO = 'photo';

class FirstAidTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $F_TABLE_NAME('
      '$F_AID INTEGER PRIMARY KEY AUTOINCREMENT,'
      '$F_NAME TEXT NOT NULL,'
      '$F_INSTRUCTION TEXT NOT NULL,'
      '$F_CAUTION TEXT NOT NULL,'
      '$F_PHOTO TEXT)',
    );
  }

  static Future<int> insert(FirstAid aid) async {
    final Database db = await DatabaseHelper().db;

    return db.insert(
      F_TABLE_NAME,
      aid.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> update(FirstAid firstAid) async {
    final Database db = await DatabaseHelper().db;

    return db.update(
      F_TABLE_NAME,
      firstAid.toJson(),
      where: "$F_AID=?",
      whereArgs: [firstAid.id],
    );
  }

  static Future<List<FirstAid>> getAll() async {
    final Database db = await DatabaseHelper().db;

    final List<Map<String, dynamic>> maps = await db.query(F_TABLE_NAME);

    return List.generate(
        maps.length, (index) => FirstAid.fromJson(maps[index]));
  }

  static Future<int> delete(int id) async {
    final Database db = await DatabaseHelper().db;

    return db.delete(F_TABLE_NAME, where: '$F_AID=?', whereArgs: [id]);
  }
}
