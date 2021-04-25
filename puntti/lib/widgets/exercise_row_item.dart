import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/exercise.dart';
import '../models/exercise_set.dart';
import '../providers/workouts.dart';
import '../widgets/set_row_item.dart';

class ExerciseRowItem extends StatefulWidget {
  final Exercise exercise;
  const ExerciseRowItem({Key key, @required this.exercise}) : super(key: key);

  @override
  _ExerciseRowItemState createState() => _ExerciseRowItemState();
}

class _ExerciseRowItemState extends State<ExerciseRowItem> {
  Exercise _exercise;
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _exercise = widget.exercise;
    _nameController = new TextEditingController(text: _exercise.name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: CupertinoColors.white, border: Border.symmetric(vertical: BorderSide(color: CupertinoColors.systemGrey5, width: 1))),
      margin: EdgeInsets.only(top: 8),
      child: Consumer<Workouts>(builder: (ctx, provider, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CupertinoTextField(
                decoration: BoxDecoration(color: CupertinoColors.white),
                placeholder: 'Name',
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                controller: _nameController,
                onChanged: (s) {
                  setState(() {
                    _exercise.name = s;
                    provider.updateExercise(_exercise);
                  });
                },
                suffix: CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  child: Icon(
                    CupertinoIcons.clear,
                  ),
                  onPressed: () {
                    provider.removeExercise(_exercise.id);
                  }
                )
              ),
              Column(
                children: provider
                  .getExerciseSetsByExerciseId(_exercise.id)
                  .map((_set) =>
                    SetRowItem(key: ValueKey(_set.id), exerciseSet: _set))
                  .toList()
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(width: 1, color: CupertinoColors.systemGrey5))
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text('Add set'),
                  onPressed: () {
                    provider.createExerciseSet(
                      ExerciseSet(
                        id: 0,
                        workoutId: _exercise.workoutId,
                        exerciseId: _exercise.id,
                        weight: null,
                        repCount: null,
                        notes: '',
                      )
                    );
                  }
                )
              )
            ],
          );
        }));
  }
}
