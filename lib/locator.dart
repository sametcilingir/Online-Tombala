import 'package:get_it/get_it.dart';
import 'package:tombala/services/firebase_database_service.dart';
import 'package:tombala/view_model/view_model.dart';
import 'package:tombala/views/game_card.dart';
import 'package:tombala/views/game_table.dart';
import 'package:tombala/views/home.dart';
import 'package:tombala/views/waiting.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ViewModel());
  locator.registerLazySingleton(() => FirebaseDatabaseService());
  
  locator.registerLazySingleton(() => WaitingScreen());
  locator.registerLazySingleton(() => HomeScreen());
  locator.registerLazySingleton(() => GameCardScreen());
  locator.registerLazySingleton(() => GameTableScreen());

}