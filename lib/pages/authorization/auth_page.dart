import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dreamsober/pages/home_page.dart';
import 'package:dreamsober/models/userprefs.dart';
import 'login_or_register.dart';

class AuthPage extends StatelessWidget {
  static String route = "/";
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevents the page from resizing when the keyboard is shown
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData && UserPrefs.getImpactLogin()) {
            final String userUID = FirebaseAuth.instance.currentUser!.uid;
            UserPrefs.setUID(userUID);
            return HomePage();
          }
          // user is NOT logged in
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
