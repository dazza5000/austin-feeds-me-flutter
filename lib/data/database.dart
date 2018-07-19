import 'dart:async';

import 'package:sqflite/sqflite.dart';

class Database {
  static final Database _instance = Database._internal();

  factory Database() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Database._internal();
}