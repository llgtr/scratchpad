import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/workout.dart';
import '../models/exercise.dart';
import '../models/exercise_set.dart';

class Workouts with ChangeNotifier {
  final Database _database;
  List<Workout> _workouts = [];
  List<Exercise> _exercises = [];
  List<ExerciseSet> _sets = [];

  Workouts(this._database) {
    fetchAndSetWorkouts();
  }

  // Workouts

  List<Workout> getWorkouts() {
    return _workouts;
  }

  Future<void> fetchAndSetWorkouts() async {
    try {
      final workoutResults = await _database.query('workouts');
      final exerciseResults = await _database.query('exercises');
      final setResults = await _database.query('sets');
      _workouts = workoutResults.map((w) => Workout.fromMap(w)).toList();
      _exercises = exerciseResults.map((e) => Exercise.fromMap(e)).toList();
      _sets = setResults.map((s) => ExerciseSet.fromMap(s)).toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> createWorkout(Workout workout) async {
    try {
      await _database.transaction((tx) async {
        var newWorkoutId = 1;
        final latestWorkout = await tx.query('workouts', orderBy: 'id DESC', limit: 1);

        if (latestWorkout.length > 0) {
          newWorkoutId = (latestWorkout[0]['id'] as int) + 1;
        }

        final batch = tx.batch();

        final workoutToInsert = workout.toMap();
        workoutToInsert['id'] = newWorkoutId;
        batch.insert('workouts', workoutToInsert);

        await batch.commit();
      });
      await fetchAndSetWorkouts();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateWorkout(Workout workout) async {
    try {
      await _database.transaction((tx) async {
        final batch = tx.batch();

        batch.update('workouts', workout.toMap(), where: 'id = ?', whereArgs: [workout.id]);

        await batch.commit();
      });
      await fetchAndSetWorkouts();
    } catch (error) {
      throw error;
    }
  }


  Future<void> removeWorkout(int id) async {
    try {
      await _database.transaction((tx) async {
        final batch = tx.batch();

        batch.delete('workouts', where: 'id = ?', whereArgs: [id]);

        await batch.commit();
      });
      await fetchAndSetWorkouts();
    } catch (error) {
      throw error;
    }
  }

  // Exercises

  List<Exercise> getExercisesById(int id) {
    return _exercises.where((e) => e.workoutId == id).toList();
  }

  Future<void> createExercise(Exercise exercise) async {
    try {
      await _database.transaction((tx) async {
        var newExerciseId = 1;
        final latestExercise = await tx.query('exercises', orderBy: 'id DESC', limit: 1);

        if (latestExercise.length > 0) {
          newExerciseId = (latestExercise[0]['id'] as int) + 1;
        }

        final batch = tx.batch();

        final exerciseToInsert = exercise.toMap();
        exerciseToInsert['id'] = newExerciseId;
        batch.insert('exercises', exerciseToInsert);

        await batch.commit();
      });
      await fetchAndSetWorkouts();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateExercise(Exercise exercise) async {
    try {
      await _database.transaction((tx) async {
        final batch = tx.batch();

        batch.update('exercises', exercise.toMap(), where: 'id = ?', whereArgs: [exercise.id]);

        await batch.commit();
      });
      await fetchAndSetWorkouts();
    } catch (error) {
      throw error;
    }
  }


  Future<void> removeExercise(int id) async {
    try {
      await _database.transaction((tx) async {
        final batch = tx.batch();

        batch.delete('exercises', where: 'id = ?', whereArgs: [id]);

        await batch.commit();
      });
      await fetchAndSetWorkouts();
    } catch (error) {
      throw error;
    }
  }

  // ExerciseSets

  List<ExerciseSet> getExerciseSetsByExerciseId(int id) {
    return _sets.where((s) => s.exerciseId == id).toList();
  }

  List<ExerciseSet> getExerciseSetsByWorkoutId(int id) {
    return _sets.where((s) => s.workoutId == id).toList();
  }

  Future<void> createExerciseSet(ExerciseSet exerciseSet) async {
    try {
      await _database.transaction((tx) async {
        var newExerciseSetId = 1;
        final latestExerciseSet = await tx.query('sets', orderBy: 'id DESC', limit: 1);

        if (latestExerciseSet.length > 0) {
          newExerciseSetId = (latestExerciseSet[0]['id'] as int) + 1;
        }

        final batch = tx.batch();

        final exerciseSetToInsert = exerciseSet.toMap();
        exerciseSetToInsert['id'] = newExerciseSetId;
        batch.insert('sets', exerciseSetToInsert);

        await batch.commit();
      });
      await fetchAndSetWorkouts();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateExerciseSet(ExerciseSet exerciseSet) async {
    try {
      await _database.transaction((tx) async {
        final batch = tx.batch();

        batch.update('sets', exerciseSet.toMap(), where: 'id = ?', whereArgs: [exerciseSet.id]);

        await batch.commit();
      });
      await fetchAndSetWorkouts();
    } catch (error) {
      throw error;
    }
  }


  Future<void> removeExerciseSet(int id) async {
    try {
      await _database.transaction((tx) async {
        final batch = tx.batch();

        batch.delete('sets', where: 'id = ?', whereArgs: [id]);

        await batch.commit();
      });
      await fetchAndSetWorkouts();
    } catch (error) {
      throw error;
    }
  }
}
