import 'package:flutter/cupertino.dart';

import '../constants.dart';

class SetInput extends StatelessWidget {
  const SetInput({
    this.title,
    this.textController,
    this.onChanged,
  });

  final String title;
  final TextEditingController textController;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(title, style: Styles.smallText),
          CupertinoTextField(
            keyboardType: TextInputType.number,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: CupertinoColors.systemGrey5))),
            controller: textController,
            onChanged: (s) {
              onChanged(s);
            },
          ),
        ]
      )
    );
  }
}
