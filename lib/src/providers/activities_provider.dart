import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prueba_gbp/src/models/activity_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class ActivitiesProvider with ChangeNotifier {
  static Database _database;
  List<ActivityModel> pendientes = [];

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ActivitiesDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Activities ('
          'id TEXT PRIMARY KEY,'
          'user TEXT,'
          'text TEXT,'
          'date TEXT,'
          'state TEXT'
          ')');
    });
  }

  insertActivity(
    String user,
    String text,
  ) async {
    final db = await database;
    final res = await db.rawInsert(
        "INSERT INTO Activities (id, user, text, date, state) "
        "VALUES ('${DateTime.now().toString()}', '$user', '$text','${DateTime.now().toString()}', 'pendiente')");
    return res;
  }

  getActivities(String user, String state) async {
    final db = await database;
    final res = await db.query('Activities',
        where: 'user = ? and state = ?', whereArgs: [user, state]);
    List<ActivityModel> list = res.isNotEmpty
        ? res.map((c) => ActivityModel.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<int> updateState(ActivityModel activity) async {
    final db = await database;
    final res = await db.update('Activities', activity.toJson(),
        where: 'id = ?', whereArgs: [activity.id]);
    return res;
  }
}
