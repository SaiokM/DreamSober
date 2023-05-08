// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final userUID = FirebaseAuth.instance.currentUser!.uid;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                "Name",
                style: optionStyle,
              ),
              SizedBox(height: 40),
              Text(userUID),
              SizedBox(height: 40),
              ElevatedButton(
                  onPressed: () => signUserOut(), child: Text("Sign Out"))
            ],
          ),
        ),
      ),
    );
  }
}
