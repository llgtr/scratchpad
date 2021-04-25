import 'package:flutter/foundation.dart';

class Exercise {
  final int id;
  final int workoutId;
  String name;

  Exercise({
    @required this.id,
    @required this.workoutId,
    @required this.name,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'workoutId': workoutId,
    'name': name,
  };

  factory Exercise.fromMap(Map<String, dynamic> map) => Exercise(
    id: map['id'] as int,
    workoutId: map['workoutId'] as int,
    name: map['name'] as String,
  );
}
