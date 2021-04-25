import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';

import '../models/workout.dart';
import '../models/exercise.dart';
import '../constants.dart';

var firstDateRowFormatter = new DateFormat('dd MMM');
var secondDateRowFormatter = new DateFormat('yyyy');
var weekdayFormatter = new DateFormat('E');

class WorkoutRowItem extends StatelessWidget {
  const WorkoutRowItem({
    this.index,
    this.workout,
    this.exercises,
    this.lastItem,
    this.onPressed,
  });

  final int index;
  final Workout workout;
  final List<Exercise> exercises;
  final bool lastItem;
  final Function onPressed;

  String formatExercisesList(List<Exercise> exerciseList) {
    // TODO: Handle empty strings sensibly
    return exerciseList.map((e) => e.name).fold(
      '', (previousValue, element) => (previousValue.isEmpty) ? element : previousValue + ', ' + element
    );
  }

  @override
  Widget build(BuildContext context) {
    final row = SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(
        left: 16,
        top: 8,
        bottom: 8,
        right: 8,
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: this.onPressed,
        child: Row(
          children: <Widget>[
            Container(
              child: Row(children: <Widget>[
                  Container(
                    width: 50,
                    child: Column(
                      children: <Widget>[
                        Text(
                          firstDateRowFormatter.format(workout.date),
                          style: Styles.smallText,
                        ),
                        Text(
                          secondDateRowFormatter.format(workout.date),
                          style: Styles.smallText,
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    margin: EdgeInsets.only(right: 10),
                    child: Center(
                      child: Text(
                        weekdayFormatter.format(workout.date),
                        style: TextStyle(
                          color: CupertinoColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        )
                      ),
                    )
                  ),
              ]),
            ),
            Expanded(
              child: Text(
                formatExercisesList(exercises),
                style: Styles.smallTextLight,
                overflow: TextOverflow.ellipsis
              )
            ),
          ],
        ),
      ),
    );

    if (lastItem) {
      return row;
    }

    return Column(
      children: <Widget>[
        row,
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Container(
            height: 1,
            color: CupertinoColors.systemGrey3,
          ),
        ),
      ],
    );
  }
}
