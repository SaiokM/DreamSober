// ignore_for_file: prefer_const_constructors, unused_import, body_might_complete_normally_nullable

import 'package:dreamsober/pages/authorization/forgot_pw_page.dart';
import 'package:dreamsober/pages/authorization/login_or_register.dart';
import 'package:dreamsober/pages/home_page.dart';
import 'package:dreamsober/pages/authorization/impact_on.dart';
import 'package:dreamsober/pages/profilePage.dart';
import 'package:dreamsober/pages/teamPage.dart';
import 'package:flutter/material.dart';
import 'package:dreamsober/pages/authorization/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dreamsober/models/drinkDB.dart';
import 'package:dreamsober/models/userprefs.dart';
import 'package:dreamsober/pages/drinkpage.dart';
import 'package:dreamsober/pages/managedrink.dart';
import 'package:dreamsober/pages/databasepage.dart';
import 'package:dreamsober/pages/graph.dart';
import 'package:provider/provider.dart';
import 'package:dreamsober/pages/authorization/login_page.dart';
import 'firebase/firebase_options.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize user preferences
  await UserPrefs.init();

  runApp(
    ChangeNotifierProvider(
      // Provide the DailyDrinkdDB instance to the app
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
      // Disable the debug banner
      debugShowCheckedModeBanner: false,

      //  Set the initial route
      initialRoute: AuthPage.route,

      // Define the app theme
      theme: ThemeData(primarySwatch: Colors.brown),

      // Define the app routes
      routes: {
        ManageDrinkPage.route: (context) => ManageDrinkPage(),
        ProfilePage.route: (context) => ProfilePage(),
        DatabasePage.route: (context) => DatabasePage(),
        AuthPage.route: (context) => AuthPage(),
        ImpactOnboarding.route: (context) => ImpactOnboarding(),
        HomePage.route: (context) => HomePage(),
        TeamPage.route: (context) => TeamPage(),
        ForgotPasswordPage.route: (context) => ForgotPasswordPage(),
      },
    );
  }
}
