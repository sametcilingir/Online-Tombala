import 'package:flutter/material.dart';
import '../../components/views/game_card/game_card.dart';
import '../../components/views/home/home.dart';
import '../../components/views/waiting/waiting.dart';

class Routes {
  static const String home = '/home';
  static const String waitingRoom = '/home/waiting_room';
  static const String gameCard = '/home/waiting_room/game_card';

  static final routes = <String, WidgetBuilder>{
    home: (BuildContext context) => const HomeScreen(),
    waitingRoom: (BuildContext context) => const WaitingScreen(),
    gameCard: (BuildContext context) => const GameCardScreen()
  };
}
