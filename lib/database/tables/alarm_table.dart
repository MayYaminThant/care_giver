// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';

import '../../models/alarms.dart';
import '../database_helper.dart';

const AL_TABLE_NAME = 'tbl_alarm';
const AL_ID = 'alid';
const AL_TIME = 'alarm_time';
const AL_FLAG = 'flag';

class AlarmTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $AL_TABLE_NAME('
      '$AL_ID INTEGER PRIMARY KEY AUTOINCREMENT,'
      '$AL_TIME INTEGER NOT NULL,'
      '$AL_FLAG INTEGER NOT NULL)',
    );
  }

  static Future<int> insert(MyAlarm alarm) async {
    final Database db = await DatabaseHelper().db;

    return db.insert(
      AL_TABLE_NAME,
      alarm.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> update(MyAlarm alarm) async {
    final Database db = await DatabaseHelper().db;

    return db.update(
      AL_TABLE_NAME,
      alarm.toJson(),
      where: "$AL_ID=?",
      whereArgs: [alarm.id],
    );
  }

  static Future<List<MyAlarm>> getAll() async {
    final Database db = await DatabaseHelper().db;

    final List<Map<String, dynamic>> maps = await db.query(AL_TABLE_NAME);

    return List.generate(maps.length, (index) => MyAlarm.fromJson(maps[index]));
  }

  static Future<int> delete(int id) async {
    final Database db = await DatabaseHelper().db;

    return db.delete(AL_TABLE_NAME, where: '$AL_ID=?', whereArgs: [id]);
  }
}
