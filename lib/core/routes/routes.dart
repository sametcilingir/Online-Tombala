import 'package:flutter/material.dart';

import '../../components/views/game_card_screen/game_card_screen.dart';
import '../../components/views/home_screen/home_screen.dart';
import '../../components/views/waiting_screen/waiting_screen.dart';

class Routes {
  Routes._();
  static const String home = '/home';
  static const String waitingRoom = '/home/waiting_room';
  static const String gameCard = '/home/waiting_room/game_card';

  static final routes = <String, WidgetBuilder>{
    home: (BuildContext context) => const HomeScreen(),
    waitingRoom: (BuildContext context) => const WaitingScreen(),
    gameCard: (BuildContext context) => const GameCardScreen()
  };

}
