import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BMIDatabase {
  static final BMIDatabase instance = BMIDatabase._init();

  static Database? _database;

  BMIDatabase._init();

  // Define your column names
  static const String _dbName = 'bitp3453_bmi';
  static const String _tblName = 'bmi';
  static const String _colUsername = 'username';
  static const String _colWeight = 'weight';
  static const String _colHeight = 'height';
  static const String _colGender = 'gender';
  static const String _colStatus = 'bmi_status';

  // Getters for your column names
  String get dbName => _dbName;
  String get tblName => _tblName;
  String get colUsername => _colUsername;
  String get colWeight => _colWeight;
  String get colHeight => _colHeight;
  String get colGender => _colGender;
  String get colStatus => _colStatus;

  Future<void> init() async {
    if (_database != null) return;

    _database = await openDatabase(
      join(await getDatabasesPath(), _dbName),
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblName (
        $_colUsername TEXT PRIMARY KEY,
        $_colWeight REAL,
        $_colHeight REAL,
        $_colGender TEXT,
        $_colStatus TEXT
      )
    ''');
  }

  Future<void> insertData(Map<String, dynamic> data) async {
    await _database!.insert(_tblName, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    return await _database!.query(_tblName);
  }
}