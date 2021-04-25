// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// 
// import '../providers/workouts.dart';
// import '../models/exercise.dart';
// import '../models/exercise_set.dart';
// 
// class ExerciseDetailModal extends StatefulWidget {
//   final Exercise exercise;
//   final List<ExerciseSet> sets;
//   const ExerciseDetailModal({Key key, @required this.exercise, @required this.sets})
//       : super(key: key);
// 
//   @override
//   _ExerciseDetailState createState() => _ExerciseDetailState();
// }
// 
// class _ExerciseDetailState extends State<ExerciseDetailModal> {
//   Exercise _exercise;
//   List<ExerciseSet> _sets;
//   TextEditingController _controller;
// 
//   @override
//   void initState() {
//     super.initState();
//     _exercise = widget.exercise;
//     _sets = widget.sets;
//     _controller = new TextEditingController(text: _exercise.name);
//   }
// 
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// 
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: CupertinoColors.white,
//         borderRadius: BorderRadius.all(
//           Radius.circular(10)
//         )
//       ),
//       child: Column(
//         children: <Widget>[
//           // Consumer<Workouts>(
//           //   builder: (ctx, builder, _) {
//           //     return CupertinoButton(
//           //       padding: EdgeInsets.all(0),
//           //       child: Text('Save'),
//           //       onPressed: () {
//           //         // builder.updateExercise(_exercise);
//           //         // Navigator.pop(context);
//           //       },
//           //     );
//           //   },
//           // ),
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text('id: ${_exercise.id}'),
//                 CupertinoTextField(
//                   controller: _controller,
//                   prefix: Text('Name: '),
//                   decoration: null,
//                   onChanged: (s) {
//                     setState(() {
//                       _exercise.name = s;
//                     });
//                   }
//                 ),
//                 Consumer<Workouts>(
//                   builder: (ctx, builder, _) {
//                     return CupertinoButton.filled(
//                       child: Text('Add set'),
//                       onPressed: () {
//                         builder.createExerciseSet(
//                           ExerciseSet(
//                             id: 0,
//                             exerciseId: _exercise.id,
//                             workoutId: _exercise.workoutId,
//                             repCount: 0,
//                           )
//                         );
//                       }
//                     );
//                   }
//                 ),
//                 Container(
//                   height: 300,
//                   child: ListView.builder(
//                     padding: EdgeInsets.symmetric(vertical: 8),
//                     itemCount: _sets.length,
//                     itemBuilder: (ctx, index) {
//                       final _set = _sets[index];
//                       return Dismissible(
//                         // child: ExerciseRowItem(
//                         //   index: index,
//                         //   exercise: _exercise,
//                         // ),
//                         // key: ValueKey(_exercise.id),
//                         // direction: DismissDirection.endToStart,
//                         // onDismissed: (_) {
//                         //   builder.removeExercise(_exercise.id);
//                         // },
//                         child: Text('${_set.repCount}'),
//                         key: ValueKey(_set.id),
//                         direction: DismissDirection.endToStart,
//                         onDismissed: (_) {},
//                       );
//                     },
//                   )
//                 ),
//                 // Row(
//                 //   children: <Widget>[
//                 //     CupertinoButton.filled(
//                 //       child: Text('-'),
//                 //       onPressed: () {
//                 //         if (_exercise.setCount > 0) {
//                 //           setState(() {
//                 //             _exercise.setCount -= 1;
//                 //           });
//                 //         }
//                 //       }
//                 //     ),
//                 //     Text('setCount: ${_exercise.setCount}'),
//                 //     CupertinoButton.filled(
//                 //       child: Text('+'),
//                 //       onPressed: () {
//                 //         setState(() {
//                 //           _exercise.setCount += 1;
//                 //         });
//                 //       }
// 
//                 //     ),
//                 //   ]
//                 // ),
//                 // Row(
//                 //   children: <Widget>[
//                 //     CupertinoButton.filled(
//                 //       child: Text('-'),
//                 //       onPressed: () {
//                 //         if (_exercise.repCount > 0) {
//                 //           setState(() {
//                 //             _exercise.repCount -= 1;
//                 //           });
//                 //         }
//                 //       }
//                 //     ),
//                 //     Text('repCount: ${_exercise.repCount}'),
//                 //     CupertinoButton.filled(
//                 //       child: Text('+'),
//                 //       onPressed: () {
//                 //         setState(() {
//                 //           _exercise.repCount += 1;
//                 //         });
//                 //       }
// 
//                 //     ),
//                 //   ]
//                 // ),
//               ]
//             )
//           )
//         ]
//       )
//     );
//   }
// }
