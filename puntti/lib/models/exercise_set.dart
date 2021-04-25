import 'package:flutter/foundation.dart';

class ExerciseSet {
  final int id;
  final int exerciseId;
  final int workoutId;
  int weight;
  int repCount;
  String notes;

  ExerciseSet({
    @required this.id,
    @required this.exerciseId,
    @required this.workoutId,
    @required this.weight,
    @required this.repCount,
    @required this.notes,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'exerciseId': exerciseId,
    'workoutId': workoutId,
    'weight': weight,
    'repCount': repCount,
    'notes': notes,
  };

  factory ExerciseSet.fromMap(Map<String, dynamic> map) => ExerciseSet(
    id: map['id'] as int,
    exerciseId: map['exerciseId'] as int,
    workoutId: map['workoutId'] as int,
    weight: map['weight'] as int,
    repCount: map['repCount'] as int,
    notes: map['notes'] as String,
  );
}
