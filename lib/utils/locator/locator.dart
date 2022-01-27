import 'package:get_it/get_it.dart';
import '../routes/routes.dart';

import '../../components/view_models/view_model.dart';
import '../../components/views/game_card/game_card.dart';
import '../../components/views/home/home.dart';
import '../../components/views/waiting/waiting.dart';
import '../services/firebase_database_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ViewModel());

  locator.registerLazySingleton(() => FirebaseDatabaseService());

  locator.registerLazySingleton(() => Routes());

  locator.registerLazySingleton(() => const HomeScreen());
  locator.registerLazySingleton(() => const WaitingScreen());
  locator.registerLazySingleton(() => const GameCardScreen());
}
