// ignore_for_file: prefer_const_constructors

import 'package:dreamsober/pages/authorization/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:dreamsober/pages/authorization/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dreamsober/models/drinkDB.dart';
import 'package:dreamsober/screens/drinkpage.dart';
import 'package:dreamsober/screens/placeholder.dart';
import 'package:dreamsober/screens/managedrink.dart';
import 'package:dreamsober/screens/databasepage.dart';
import 'package:dreamsober/screens/graph.dart';
import 'package:provider/provider.dart';
import 'package:dreamsober/pages/authorization/login_page.dart';
import 'package:dreamsober/pages/authorization/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => DailyDrinkDB(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      //initialRoute: LoginOrRegisterPage.route,
      onGenerateRoute: (settings) {
        if (settings.name == DatabasePage.route) {
          final args = settings.arguments;
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  DatabasePage(userUID: args.toString()));
        }
      },
      routes: {
        ManageDrinkPage.route: (context) => ManageDrinkPage(),
        //DrinkPage.route: (context) => DrinkPage(userUID: userUID)
        //DatabasePage.route: (context) => DatabasePage(),
      },
    );
  }
}
