import 'package:flutter/foundation.dart';

// import 'exercise.dart';

class Workout {
  final int id;
  DateTime date;
  String description;
  // List<Exercise> exercises;

  Workout({
    @required this.id,
    @required this.date,
    @required this.description,
    // @required this.exercises,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'description': description,
  };

  factory Workout.fromMap(Map<String, dynamic> map) => Workout(
    id: map['id'] as int,
    date: DateTime.parse(map['date'] as String),
    description: map['description'] as String,
    // exercises: map['exercises'] as List<Exercise>,
  );
}
