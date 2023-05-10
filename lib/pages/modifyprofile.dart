// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:dreamsober/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  final Function()? signOut;
  ProfilePage({super.key, required this.signOut});
  static const routename = 'ProfilePage';
  final user = FirebaseAuth.instance.currentUser!;
  static String userUID = FirebaseAuth.instance.currentUser!.uid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child(ProfilePage.userUID);

  //Text controller
  String? sex;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //print('${ProfilePage.routename} built');
    return Scaffold(
      body: _buildForm(context),
    );
  } //build

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 10),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: heightController,
                  decoration: const InputDecoration(
                    labelText: 'Heigth',
                  ),
                ),
                SizedBox(height: 10),
                Text('Sex'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("Male"),
                        Radio(
                          value: "Male",
                          groupValue: sex,
                          onChanged: (value) {
                            setState(() {
                              sex = value.toString();
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Female"),
                        Radio(
                          value: "Female",
                          groupValue: sex,
                          onChanged: (value) {
                            setState(() {
                              sex = value.toString();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () {
                    final name = nameController.text;
                    final age = int.parse(ageController.text);
                    final height = double.parse(heightController.text);
                    final weight = double.parse(weightController.text);
                    CurrentUser _currentUser =
                        CurrentUser(name, age, height, weight, sex);
                    _currentUser.saveToDB(dbRef.child("User"));
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} //ProfilePage

