import 'package:flutter/material.dart';
import 'package:dreamsober/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);
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
  final formKey = GlobalKey<FormState>();

  bool enable = true;

  @override
  Widget build(BuildContext context) {
    print('${ProfilePage.routename} built');
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: _buildForm(context),
    );
  } //build

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  enabled: enable,
                  initialValue: enable?"Insert your Name":"",
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
                  enabled: enable,
                  initialValue: enable?"Insert your Age":"",
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
                  enabled: enable,
                  initialValue: enable?"Insert your Weight":"",
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
                  enabled: enable,
                  initialValue: enable?"Insert your Height":"",
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
                            if (enable) {
                              setState(() {
                              sex = value.toString();
                            });
                            }
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
                            if (enable) {
                              setState(() {
                              sex = value.toString();
                            });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[300],
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if(enable){
                        final name = nameController.text;
                        final age = int.parse(ageController.text);
                        final height = double.parse(heightController.text);
                        final weight = double.parse(weightController.text);
                        CurrentUser currentUser =
                          CurrentUser(name, age, height, weight, sex);
                        currentUser.saveToDB(dbRef.child("User"));
                        enable = false;
                        }
                      else{
                        setState(() {
                          enable = true;
                        });
                      }
                    }
                  },
                  child: enable? const Text("Submit") : const Text("Modify"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[300],
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Text("Logout"),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
} //ProfilePage

