import 'package:get_it/get_it.dart';

import '../../components/view_models/view_model.dart';
import '../../components/views/game_card_screen/game_card_screen.dart';
import '../../components/views/home_screen/home_screen.dart';
import '../../components/views/home_screen/page_view/join_form_screen.dart';
import '../../components/views/home_screen/page_view/login_form_screen.dart';
import '../../components/views/waiting_screen/waiting_screen.dart';
import '../../main.dart';
import '../routes/routes.dart';
import '../services/firebase_database_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ViewModel());
  locator.registerLazySingleton(() => FirebaseDatabaseService());

  locator.registerLazySingleton(() => Routes());


  locator.registerLazySingleton(() => const MyApp());

  locator.registerLazySingleton(() => const HomeScreen());
  locator.registerLazySingleton(() => const JoinFormScreen());
  locator.registerLazySingleton(() => const LoginFormScreen());

  locator.registerLazySingleton(() => const WaitingScreen());
  locator.registerLazySingleton(() => const GameCardScreen());
}
