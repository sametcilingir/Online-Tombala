import 'package:get_it/get_it.dart';
import 'services/firebase_database_service.dart';
import 'view_model/view_model.dart';
import 'views/game_card.dart';
import 'views/game_table.dart';
import 'views/home.dart';
import 'views/waiting.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ViewModel());
  locator.registerLazySingleton(() => FirebaseDatabaseService());
  
  locator.registerLazySingleton(() => WaitingScreen());
  locator.registerLazySingleton(() => HomeScreen());
  locator.registerLazySingleton(() => GameCardScreen());
  locator.registerLazySingleton(() => GameTableScreen());

}