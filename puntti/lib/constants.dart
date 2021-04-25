import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

abstract class Styles {
  static const TextStyle smallTextLight = TextStyle(
    color: CupertinoColors.systemGrey,
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );
  static const TextStyle smallText = TextStyle(
    color: CupertinoColors.black,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
}

abstract class Constants {
  static const DATABASE_NAME = 'puntti';
}
