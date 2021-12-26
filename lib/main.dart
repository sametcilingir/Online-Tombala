import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/views/game_card.dart';
import 'package:tombala/views/game_table.dart';
import 'package:tombala/views/home.dart';
import 'package:tombala/views/room_choose.dart';
import 'package:tombala/views/room_join.dart';
import 'package:tombala/views/waiting.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  Future<void> initializeFlutterFire() async {
    /*final NotesViewModel _notesViewModel = locator<NotesViewModel>();
    try {
      //flutter downloader burda
      await FlutterDownloader.initialize(debug: _notesViewModel.debugs);
    } catch (e) {
      print("flutter downloader hata   " + e.toString());
    }*/

    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
        //print("firebase onaylandı");
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
        print("firebase onaylanmadı   " + e.toString());
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
    if (_error) {
      print("firebase hata");

      //return Center(child: Text('Something Went Wrong'));
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      //print("firebase yükleniyor");

      //return Center(child: Text('Loading'));
    }

    if (_initialized) {
      //print("firebase onaylandı");
// Assign listener after the SDK is initialized successfully
      /*FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          setState(() {
          initialRoute ="/auth";
            
          });
        } else {
          setState(() {
          initialRoute ="/home";
            
          });
        }
      });*/

      return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        darkTheme: ThemeData(
          
          appBarTheme: AppBarTheme(
            color: Color(0xff344d2f),
          ),
          scaffoldBackgroundColor: Color(0xff344d2f),
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            secondary: Color(0xfffac57d),
            primary: Color(0xffa81817),
          ),
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        title: 'Tombala',
        routes: {
          '/': (context) => HomeScreen(),
          "/room_choose": (context) => RoomChooseScreen(),
          "/waiting_room": (context) => WaitingScreen(),
          "/room_join": (context) => RoomJoinScreen(),
          "/game_card": (context) => GameCardScreen(),
          "/game_table": (context) => GameTableScreen(),
        },
      );
    }
    return const CircularProgressIndicator();
  }
}
