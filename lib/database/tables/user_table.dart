// ignore_for_file: constant_identifier_names

import '../../database/database_helper.dart';
import '../../models/users.dart';
import 'package:sqflite/sqflite.dart';

const U_TABLE_NAME = 'tbl_user';
const U_ID = 'userid';
const U_NAME = 'username';
const U_CONTACT = 'contact';
const U_PASSWORD = 'password';

class UserTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $U_TABLE_NAME('
      '$U_ID INTEGER PRIMARY KEY AUTOINCREMENT,'
      '$U_NAME TEXT NOT NULL,'
      '$U_CONTACT TEXT NOT NULL,'
      '$U_PASSWORD TEXT NOT NULL)',
    );
  }

  static Future<int> insert(MyUser user) async {
    final Database db = await DatabaseHelper().db;

    return db.insert(
      U_TABLE_NAME,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> update(MyUser user) async {
    final Database db = await DatabaseHelper().db;

    return db.update(
      U_TABLE_NAME,
      user.toJson(),
      where: "$U_ID=?",
      whereArgs: [user.id],
    );
  }

  static Future<List<MyUser>> getAll() async {
    final Database db = await DatabaseHelper().db;

    final List<Map<String, dynamic>> maps = await db.query(U_TABLE_NAME);

    return List.generate(maps.length, (index) => MyUser.fromJson(maps[index]));
  }

  static Future<int> delete(int id) async {
    final Database db = await DatabaseHelper().db;

    return db.delete(U_TABLE_NAME, where: '$U_ID=?', whereArgs: [id]);
  }

  static Future<bool> checkUserIsExist(String val1, String val2,
      {String column1 = U_NAME, String column2 = U_PASSWORD}) async {
    final Database db = await DatabaseHelper().db;
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        'Select count(*) from $U_TABLE_NAME where $column1=\'$val1\' and $column2=\'$val2\''));
    return (count ?? 0) > 0;
  }

  static Future<MyUser?> getAUser(String username, String password) async {
    final Database db = await DatabaseHelper().db;

    final List<Map<String, dynamic>> maps = await db.query(U_TABLE_NAME,
        where: '$U_NAME=? and $U_PASSWORD=?', whereArgs: [username, password]);

    return maps.isNotEmpty ? MyUser.fromJson(maps[0]) : null;
  }
}
