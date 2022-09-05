import '../../database/tables/alarm_table.dart';
import '../../database/tables/first_aid_table.dart';
import '../../database/tables/hospital_table.dart';
import '../../database/tables/user_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final String _databaseName = 'db_caregiver.db';
  final int _databaseVersion = 1;

  static Database? _db;

  Future<Database> get db async {
    // Get a singleton database
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);

// open the database
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await AlarmTable.onCreate(db, version);
    await FirstAidTable.onCreate(db, version);
    await HospitalTable.onCreate(db, version);
    await UserTable.onCreate(db, version);
  }

  static Future<void> clear() async {
    final Database db = await DatabaseHelper().db;

    await db.delete(AL_TABLE_NAME);
    await db.delete(F_TABLE_NAME);
    await db.delete(HS_TABLE_NAME);
    await db.delete(U_TABLE_NAME);
  }
}
