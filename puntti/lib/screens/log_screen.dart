import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workouts.dart';
import '../models/workout.dart';

import 'workout_screen.dart';
import '../widgets/workout_row_item.dart';

class WorkoutListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Consumer<Workouts>(
        builder: (context, builder, _) {
          final List<Workout> _workouts = builder.getWorkouts()..sort((a, b) => - a.date.compareTo(b.date));
          return CustomScrollView(
            semanticChildCount: _workouts.length,
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text('Log'),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(
                    CupertinoIcons.plus_circled,
                    semanticLabel: 'Add',
                  ),
                  onPressed: () {
                    builder.createWorkout(Workout(
                      id: 0,
                      date: new DateTime.now(),
                      description: '',
                    ));
                  },
                ),
              ),
              SliverSafeArea(
                top: false,
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < _workouts.length) {
                        final _workout = _workouts[index];
                        final _exercises = builder.getExercisesById(_workout.id);
                        return Dismissible(
                          child: WorkoutRowItem(
                            index: index,
                            workout: _workout,
                            exercises: _exercises,
                            lastItem: index == _workouts.length - 1,
                            onPressed: () {
                              Navigator.push(context,
                                CupertinoPageRoute(
                                  builder: (routeCtx) => WorkoutDetailScreen(workout: _workout)
                                )
                              );
                            }
                          ),
                          key: ValueKey(_workout.id),
                          background: Container(
                            color: CupertinoColors.destructiveRed,
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            builder.removeWorkout(_workout.id);
                          },
                          confirmDismiss: (_) {
                            return showCupertinoDialog(
                              context: context,
                              builder: (ctx) {
                                return CupertinoAlertDialog(
                                  title: Text('Confirm'),
                                  content: Text(
                                    'Are you sure you wish to delete this workout?'
                                  ),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text('Yes'),
                                      onPressed: () => Navigator.of(ctx).pop(true)
                                    ),
                                    CupertinoDialogAction(
                                      child: Text('No'),
                                      onPressed: () => Navigator.of(ctx).pop(false)
                                    )
                                  ],
                                );
                              }
                            );
                          },
                        );
                      }
                      return null;
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
