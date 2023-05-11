import 'package:flutter/material.dart';
import 'package:dreamsober/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileInit extends StatefulWidget {
  ProfileInit({Key? key}) : super(key: key);
  static const routename = 'ProfileInit';
  final user = FirebaseAuth.instance.currentUser!;
  static String userUID = FirebaseAuth.instance.currentUser!.uid;

  @override
  State<ProfileInit> createState() => _ProfileInitState();
}

class _ProfileInitState extends State<ProfileInit> {
  DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child(ProfileInit.userUID);

  //Text controller
  String? sex;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('${ProfileInit.routename} built');
    return Scaffold(
      body: _buildForm(context),
    );
  } //build

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                  labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Can\'t be empty';
                    }
                    if (value.length < 2) {
                      return 'Too short';
                    }
                    if (!value.contains(RegExp(r'[^a-zA-Z]'))) {
                      return 'Can\'t contain numbers or special characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Can\'t be empty';
                    }
                    if (value.length > 2) {
                      return 'Too long';
                    }
                    if (!value.contains(RegExp(r'^[0-9]'))) {
                      return 'Can\'t contain letters or special characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Can\'t be empty';
                    }
                    if (value.length > 3) {
                      return 'Too long';
                    }
                    if (!value.contains(RegExp(r'^[0-9]'))) {
                      return 'Can\'t contain letters or special characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: heightController,
                  decoration: const InputDecoration(
                    labelText: 'Heigth [cm]',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Can\'t be empty';
                    }
                    if (value.length > 3) {
                      return 'Too long';
                    }
                    if (!value.contains(RegExp(r'^[0-9]'))) {
                      return 'Can\'t contain letters or special characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text('Sex'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text("Male"),
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
                        const Text("Female"),
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
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () {
                    final name = nameController.text;
                    final age = int.parse(ageController.text);
                    final height = double.parse(heightController.text);
                    final weight = double.parse(weightController.text);
                    CurrentUser currentUser =
                        CurrentUser(name, age, height, weight, sex);
                    currentUser.saveToDB(dbRef.child("User"));
                  },
                  child: const Text("Submit"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Text("Logout"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} //ProfileInit

