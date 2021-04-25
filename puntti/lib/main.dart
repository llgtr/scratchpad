import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart';

import 'db/db.dart';
import 'providers/workouts.dart';

import 'screens/log_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  try {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
    );
    return runApp(App());
  } catch (error) {
    throw error;
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var _isInit = true;
  Database _database;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      connectToDB(Constants.DATABASE_NAME).then((database) {
        _database = database;
      }).catchError((err) {
        print(err);
      }).whenComplete(() {
        setState(() {
          _isInit = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !_isInit
        ? MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => Workouts(_database),
              ),
            ],
            child: CupertinoApp(home: MyHomePage()),
          )
        : CupertinoApp(
            debugShowCheckedModeBanner: false,
            home: Container(
              child: LoadingScreen(),
            ),
          );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.folder),
            title: Text('Log'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.news),
            title: Text('Statistics'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return WorkoutListScreen();
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return StatisticsScreen();
            });
          case 2:
            return CupertinoTabView(builder: (context) {
              return SettingsScreen();
            });
          default:
            // TODO: Extract this view (?)
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Center(
                  child: Text("Error")
                )
              );
            });
        }
      },
    );
  }
}
