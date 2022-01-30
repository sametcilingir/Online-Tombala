import 'package:get_it/get_it.dart';

import '../../components/view_models/view_model.dart';
import '../services/firebase_database_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ViewModel());
  locator.registerLazySingleton(() => FirebaseDatabaseService());
}
