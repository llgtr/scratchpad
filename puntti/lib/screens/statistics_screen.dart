import 'package:flutter/cupertino.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsTabState createState() {
    return _StatisticsTabState();
  }
}

class _StatisticsTabState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Text('Nothing here yet...')
      )
    );
  }
}
