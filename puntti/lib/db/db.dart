import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> connectToDB(String dbName) async {
  try {
    return await openDatabase(
      join(await getDatabasesPath(), '$dbName.db'),
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        try {
          final batch = db.batch();

          batch.execute(
            'CREATE TABLE IF NOT EXISTS workouts(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT NOT NULL, description TEXT NOT NULL);'
          );

          batch.execute(
            'CREATE TABLE IF NOT EXISTS exercises(id INTEGER PRIMARY KEY AUTOINCREMENT, workoutId INTEGER NOT NULL, name TEXT NOT NULL, FOREIGN KEY(workoutId) REFERENCES workouts(id) ON DELETE CASCADE);'
          );

          batch.execute(
            'CREATE TABLE IF NOT EXISTS sets(id INTEGER PRIMARY KEY AUTOINCREMENT, exerciseId INTEGER NOT NULL, workoutId INTEGER NOT NULL, weight INTEGER, repCount INTEGER, notes TEXT, FOREIGN KEY(exerciseId) REFERENCES exercises(id) ON DELETE CASCADE);'
          );

          await batch.commit();
        } catch (err) {
          throw err;
        }
      },
      version: 1,
    );
  } catch (err) {
    throw err;
  }
}
