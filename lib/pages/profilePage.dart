import 'package:flutter/material.dart';
import 'package:dreamsober/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class ProfilePage extends StatefulWidget {
  final String userUID;
  ProfilePage({Key? key, required this.userUID}) : super(key: key);
  static const routename = 'ProfilePage';
  //final user = FirebaseAuth.instance.currentUser!;
  //static String userUID = FirebaseAuth.instance.currentUser!.uid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //Text controller
  late String sex;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool enable = false;
  @override /*
  void initState() {
    super.initState();
    nameController = new TextEditingController(text: 'Initial value');
    ageController = new TextEditingController(text: 'Initial value');
    weightController = new TextEditingController(text: 'Initial value');
    heightController = new TextEditingController(text: 'Initial value');
  }*/

  @override
  Widget build(BuildContext context) {
    print('${ProfilePage.routename} built');
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: _buildForm(context),
    );
  } //build

  Widget _buildForm(BuildContext context) {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child(widget.userUID);

    return SingleChildScrollView(
      child: StreamBuilder(
          stream: dbRef.child("User").onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CurrentUser _currentUser;
              if (!enable) {
                Map<dynamic, dynamic> map =
                    snapshot.data!.snapshot.value as dynamic;
                //log(map.toString());
                _currentUser = CurrentUser.fromJson(map);
                nameController.text = _currentUser.name;
                ageController.text = _currentUser.age.toString();
                weightController.text = _currentUser.weight.toString();
                heightController.text = _currentUser.height.toString();
                sex = _currentUser.sex;
              }
              log(enable.toString());
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const Image(
                                    image:
                                        AssetImage('assets/profileimg.png'))),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            //enabled: enable,
                            readOnly: !enable,
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == "") {
                                return 'Can\'t be empty';
                              }
                              if (value.contains(RegExp(r'[^a-zA-Z]'))) {
                                return 'Can\'t contain numbers or special characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            //enabled: enable,
                            readOnly: !enable,
                            controller: ageController,
                            decoration: InputDecoration(
                              labelText: 'Age',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == "") {
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
                            keyboardType: TextInputType.number,
                            //enabled: enable,
                            readOnly: !enable,
                            controller: weightController,
                            decoration: InputDecoration(
                              labelText: 'Weight [kg]',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == "") {
                                return 'Can\'t be empty';
                              }
                              if (value.length > 5) {
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
                            keyboardType: TextInputType.number,
                            //enabled: enable,
                            readOnly: !enable,
                            controller: heightController,
                            decoration: InputDecoration(
                              labelText: 'Heigth [cm]',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == "") {
                                return 'Can\'t be empty';
                              }
                              if (value.length > 5) {
                                return 'Too long';
                              }
                              if (!value.contains(RegExp(r'^[0-9]'))) {
                                return 'Can\'t contain letters or special characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(117, 117, 117, 1),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column( 
                              children: [
                                const Text('Sex'),
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
                        ],),
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown[300],
                              minimumSize: Size(200, 50),
                            ),
                            onPressed: () {
                              setState(() {
                                if (enable) {
                                  if (formKey.currentState!.validate()) {
                                    final name = nameController.text;
                                    final age = int.parse(ageController.text);
                                    final height =
                                        double.parse(heightController.text);
                                    final weight =
                                        double.parse(weightController.text);
                                    _currentUser = CurrentUser(
                                        name, age, height, weight, sex);
                                    _currentUser.saveToDB(dbRef.child("User"));
                                    enable = false;
                                  }
                                } else {
                                  enable = true;
                                }
                              });
                            },
                            child: enable
                                ? const Text(
                                    "Submit",
                                    style: TextStyle(fontSize: 20),
                                  )
                                : const Text(
                                    "Modify profile",
                                    style: TextStyle(fontSize: 20),
                                  ),
                          ),
                        ],
                      )),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
} //ProfilePage

