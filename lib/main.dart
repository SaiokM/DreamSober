// ignore_for_file: prefer_const_constructors, unused_import, body_might_complete_normally_nullable

import 'package:dreamsober/pages/authorization/login_or_register.dart';
import 'package:dreamsober/pages/home_page.dart';
import 'package:dreamsober/pages/impact_on.dart';
import 'package:dreamsober/pages/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:dreamsober/pages/authorization/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dreamsober/models/drinkDB.dart';
import 'package:dreamsober/models/userprefs.dart';
import 'package:dreamsober/screens/drinkpage.dart';
import 'package:dreamsober/screens/placeholder.dart';
import 'package:dreamsober/screens/managedrink.dart';
import 'package:dreamsober/screens/databasepage.dart';
import 'package:dreamsober/screens/graph.dart';
import 'package:dreamsober/screens/impacttest.dart';
import 'package:provider/provider.dart';
import 'package:dreamsober/pages/authorization/login_page.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await UserPrefs.init();
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
      initialRoute: AuthPage.route,
      theme: ThemeData(primarySwatch: Colors.brown), // Theme color<
      routes: {
        ManageDrinkPage.route: (context) => ManageDrinkPage(),
        //ImpactTest.route: (context) => ImpactTest(),
        ProfilePage.route: (context) => ProfilePage(),
        DatabasePage.route: (context) => DatabasePage(),
        //DrinkPage.route: (context) => DrinkPage(userUID: userUID)
        //DatabasePage.route: (context) => DatabasePage(),
        AuthPage.route: (context) => AuthPage(),
        ImpactOnboarding.route: (context) => ImpactOnboarding(),
        HomePage.route: (context) => HomePage(),
      },
    );
  }
}
