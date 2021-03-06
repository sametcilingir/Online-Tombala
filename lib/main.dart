import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'components/view_models/view_model.dart';
import 'core/locator/locator.dart';
import 'core/routes/routes.dart';
import 'firebase_options.dart';

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ViewModel _viewModel = locator<ViewModel>();


  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _viewModel.locale,
        theme: _viewModel.appTheme,
        debugShowCheckedModeBanner: false,
        title: "Online Tombala",
        initialRoute: Routes.home,
        routes: Routes.routes,
      );
    },);
  }
}
