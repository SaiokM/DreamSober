// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dreamsober/pages/home_page.dart';
import 'package:dreamsober/pages/authorization/login_page.dart';

import 'login_or_register.dart';

class AuthPage extends StatelessWidget {
  static String route = "/";
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // contiene i pixel
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            final String userUID = FirebaseAuth.instance.currentUser!.uid;
            return HomePage(userUID: userUID);
          }
          // user is NOT logged in
          else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
