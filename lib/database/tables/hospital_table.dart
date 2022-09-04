import 'package:care_giver/database/database_helper.dart';
import 'package:care_giver/models/hospital.dart';
import 'package:sqflite/sqflite.dart';

const HS_TABLE_NAME = 'tbl_hospital';
const HS_ID = 'hid';
const HS_NAME = 'hospital_name';
const HS_PHONE = 'phone';
const HS_ADDRESS = 'address';
const HS_LATITUDE = 'latitude';
const HS_LONGITUDE = 'longitude';

class HospitalTable {
  static Future<void> onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $HS_TABLE_NAME('
      '$HS_ID INTEGER PRIMARY KEY AUTOINCREMENT,'
      '$HS_NAME TEXT NOT NULL,'
      '$HS_PHONE TEXT NOT NULL,'
      '$HS_ADDRESS TEXT NOT NULL,'
      '$HS_LATITUDE INTEGER NOT NULL,'
      '$HS_LONGITUDE INTEGER NOT NULL)',
    );
  }

  static Future<int> insert(Hospital hospital) async {
    final Database db = await DatabaseHelper().db;

    return db.insert(
      HS_TABLE_NAME,
      hospital.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> update(Hospital hospital) async {
    final Database db = await DatabaseHelper().db;

    return db.update(
      HS_TABLE_NAME,
      hospital.toJson(),
      where: "$HS_ID=?",
      whereArgs: [hospital.id],
    );
  }

  static Future<List<Hospital>> getAll() async {
    final Database db = await DatabaseHelper().db;

    final List<Map<String, dynamic>> maps = await db.query(HS_TABLE_NAME);

    return List.generate(
        maps.length, (index) => Hospital.fromJson(maps[index]));
  }

  static Future<int> delete(int id) async {
    final Database db = await DatabaseHelper().db;

    return db.delete(HS_TABLE_NAME, where: '$HS_ID=?', whereArgs: [id]);
  }

  static Future<bool> checkHospitalIsExist(
      String val1, String val2, String val3) async {
    final Database db = await DatabaseHelper().db;
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        'Select count(*) from $HS_TABLE_NAME where $HS_NAME=\'$val1\' and $HS_LATITUDE=$val2 and $HS_LONGITUDE=$val3'));
    return (count ?? 0) > 0;
  }
}
