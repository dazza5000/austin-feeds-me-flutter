import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class EventsDatabase {
  static const EVENT_TABLE_NAME = "event";
  static final EventsDatabase _instance = EventsDatabase._internal();

  factory EventsDatabase() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  EventsDatabase._internal();

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "event.db");
    var theDatabase = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDatabase;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE " + EVENT_TABLE_NAME + " ("
        "id STRING PRIMARY KEY, "
        "name TEXT, "
        "time INTEGER, "
        "description TEXT, "
        "url TEXT, "
        "photo TEXT, "
        "lat DOUBLE, "
        "lng DOUBLE)");
  }

  Future closeDb() async {
    var dbClient = await db;
    return dbClient.close();
  }
}