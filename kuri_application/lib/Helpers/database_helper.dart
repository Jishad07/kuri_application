import 'dart:async';
import 'package:kuri_application/Models/Contributor.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';  // Import Contributor model

class DatabaseHelper {
  static final _databaseName = "contributors.db";
  static final _databaseVersion = 1;
  static final table = 'contributors';

  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto incrementing ID
        name TEXT,
        phone_number TEXT,
        email TEXT,
        image TEXT
      )
    ''');
  }

  // Insert a new contributor
  Future<int> insertContributor(Contributor contributor) async {
    Database db = await database;
    return await db.insert(table, contributor.toMap());
  }

  // Fetch all contributors
  Future<List<Contributor>> getContributors() async {
    Database db = await database;
    var result = await db.query(table);
    List<Contributor> contributors = result.isNotEmpty
        ? result.map((c) => Contributor.fromMap(c)).toList()
        : [];
    return contributors;
  }

  // Update a contributor
  Future<int> updateContributor(Contributor contributor) async {
    Database db = await database;
    return await db.update(
      table,
      contributor.toMap(),
      where: 'id = ?',
      whereArgs: [contributor.id],
    );
  }

  // Delete a contributor
  Future<int> deleteContributor(int id) async {
    Database db = await database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
