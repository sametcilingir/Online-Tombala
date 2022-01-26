import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/views/game_card/game_card.dart';
import 'components/views/game_table/game_table.dart';
import 'components/views/home/home.dart';
import 'components/views/waiting/waiting.dart';
import 'utils/locator/locator.dart';
import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {});
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
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
        '/home': (context) => const HomeScreen(),
        "/home/waiting_room": (context) => const WaitingScreen(),
        "/home/game_card": (context) => const GameCardScreen(),
        "/home/game_table": (context) => const GameTableScreen(),
      },
    );
  }
}
