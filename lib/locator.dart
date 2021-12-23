import 'package:get_it/get_it.dart';
import 'package:tombala/services/firebase_database.dart';
import 'package:tombala/view_model/view_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ViewModel());
  locator.registerLazySingleton(() => FirebaseDatabaseService());
}