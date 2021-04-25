import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/workouts.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import '../widgets/exercise_row_item.dart';

var navBarFormatter = new DateFormat('dd MMMM yyyy');
var dateFormatter = new DateFormat('EEEE, dd MMMM yyyy');

class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;
  const WorkoutDetailScreen({Key key, @required this.workout})
      : super(key: key);

  @override
  _WorkoutDetailState createState() => _WorkoutDetailState();
}

class _WorkoutDetailState extends State<WorkoutDetailScreen> {
  Workout _workout;
  TextEditingController _controller;
  List<Exercise> _exercises;

  @override
  void initState() {
    super.initState();
    _workout = widget.workout;
    _controller = new TextEditingController(text: _workout.description);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        navigationBar: CupertinoNavigationBar(),
      child: SafeArea(
        child: Consumer<Workouts>(builder: (ctx, builder, _) {
            _exercises = builder.getExercisesById(_workout.id);
            return ListView(children: <Widget>[
                Container(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    border: Border.symmetric(
                      vertical: BorderSide(
                        color: CupertinoColors.systemGrey5, width: 1
                      )
                    )
                  ),
                  padding: EdgeInsets.zero,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text('${dateFormatter.format(_workout.date)}'),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: ctx,
                        builder: (modalContext) => Container(
                          color: CupertinoColors.white,
                          height: MediaQuery.of(context).copyWith().size.height / 3,
                          child: CupertinoDatePicker(
                            initialDateTime: _workout.date,
                            onDateTimeChanged: (newDate) {
                              _workout.date = newDate;
                              builder.updateWorkout(_workout);
                            },
                            mode: CupertinoDatePickerMode.date
                          )
                        )
                      );
                    }
                  )
                ),
                CupertinoTextField(
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: CupertinoColors.systemGrey5, width: 1)
                    )
                  ),
                  placeholder: 'Description',
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  controller: _controller,
                  onChanged: (s) {
                    setState(() {
                        _workout.description = s;
                    });
                  },
                ),
                Column(
                  children: _exercises
                  .map((_exercise) => ExerciseRowItem(
                      key: ValueKey(_exercise.id), exercise: _exercise)
                  )
                  .toList()
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    border: Border.symmetric(
                      vertical: BorderSide(
                        width: 1, color: CupertinoColors.systemGrey5)
                    )
                  ),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text('Add exercise'),
                    onPressed: () {
                      builder.createExercise(Exercise(
                          id: 0,
                          workoutId: _workout.id,
                          name: '',
                      ));
                    },
                  )
                )
              ]
            );
        }),
      )
    );
  }
}
