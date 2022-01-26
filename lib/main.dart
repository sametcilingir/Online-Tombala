import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:tombala/utils/routes/routes.dart';

import 'firebase_options.dart';
import 'utils/locator/locator.dart';

main() async {
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: FlexThemeData.dark(scheme: FlexScheme.blueWhale),
        debugShowCheckedModeBanner: false,
        title: 'Online Tombala',
        initialRoute: Routes.home,
        routes: Routes.routes);
  }
}
