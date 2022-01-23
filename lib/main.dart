import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'locator.dart';
import 'view_model/view_model.dart';
import 'views/game_card.dart';
import 'views/game_table.dart';
import 'views/home.dart';

import 'views/waiting.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

   SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  Future<void> initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {}

    if (!_initialized) {}

    if (_initialized) {
      return MaterialApp(
        theme: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.green[900],
          ),
          appBarTheme: AppBarTheme(
            color: Colors.green[900],
          ),
          scaffoldBackgroundColor: Colors.green[900],
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Colors.redAccent,
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Tombala',
        initialRoute: '/home',
        routes: {
          '/home': (context) => HomeScreen(),
          "/home/waiting_room": (context) => const WaitingScreen(),
          "/home/game_card": (context) => const GameCardScreen(),
          "/home/game_table": (context) => const GameTableScreen(),
        },
      );
    }
    return const CircularProgressIndicator();
  }
}
