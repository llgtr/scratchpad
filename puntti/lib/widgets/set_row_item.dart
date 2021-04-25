import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/exercise_set.dart';
import '../providers/workouts.dart';

import 'set_input.dart';

class SetRowItem extends StatefulWidget {
  final ExerciseSet exerciseSet;
  const SetRowItem({Key key, @required this.exerciseSet})
      : super(key: key);

  @override
  _SetRowItemState createState() => _SetRowItemState();
}
class _SetRowItemState extends State<SetRowItem> {
  ExerciseSet _exerciseSet;
  TextEditingController _weightController;
  TextEditingController _repCountController;
  TextEditingController _notesController;

  String parseIntToString(int n) { return (n == null) ? '' : n.toString(); }
  int parseStringToInt(String s) { return (s.isEmpty) ? null : int.parse(s); }

  @override
  void initState() {
    super.initState();
    _exerciseSet = widget.exerciseSet;
    _weightController = new TextEditingController(text: parseIntToString(_exerciseSet.weight));
    _repCountController = new TextEditingController(text: parseIntToString(_exerciseSet.repCount));
    _notesController = new TextEditingController(text: _exerciseSet.notes);
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repCountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Workouts>(builder: (ctx, provider, _) {
      return Container(
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: CupertinoColors.systemGrey5))
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: SetInput(
                title: 'Weight',
                textController: _weightController,
                onChanged: (s) {
                  setState(() {
                    _exerciseSet.weight = parseStringToInt(s);
                    provider.updateExerciseSet(_exerciseSet);
                  });
                }
              )
            ),
            Expanded(
              child: SetInput(
                title: 'Reps',
                textController: _repCountController,
                onChanged: (s) {
                  setState(() {
                    _exerciseSet.repCount = parseStringToInt(s);
                    provider.updateExerciseSet(_exerciseSet);
                  });
                }
              )
            ),
            Expanded(
              child: SetInput(
                title: 'Notes',
                textController: _notesController,
                onChanged: (s) {
                  setState(() {
                    _exerciseSet.notes = s;
                    provider.updateExerciseSet(_exerciseSet);
                  });
                }
              )
            ),
            CupertinoButton(
              child: Icon(
                CupertinoIcons.delete,
              ),
              onPressed: () {
                provider.removeExerciseSet(_exerciseSet.id);
              },
            )
          ],
      ));
    }
    );
  }
}
