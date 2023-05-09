import 'dart:ffi';
import 'package:flutter/material.dart';


class ProfilePage extends  StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const routename = 'ProfilePage';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? gender;

  @override
  Widget build(BuildContext context) {
    print('${ProfilePage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: const Text(ProfilePage.routename),
      ),
      body: _buildForm(context),
    );
  } //build


  Widget _buildForm(BuildContext context){
    return Form(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            TextFormField(
              //initialValue: "VALORE",
              decoration: const InputDecoration(
              labelText: 'Name',
              ),
            ),
            TextFormField(
              initialValue: "VALORE",   
              decoration: const InputDecoration(
              labelText: 'Surname',
              ),
            ),
        
            TextFormField(
              initialValue: "VALORE",   
              decoration: const InputDecoration(
              labelText: 'Age',
              ),
            ),
            Text('Gender'),
            Column(children: [
              RadioListTile(
                    title: const Text("Male"),
                    value: "Male", 
                    groupValue: gender, 
                    onChanged: (value){
                      setState(() {
                          gender = value.toString();
                      });
                    },
                ),
                RadioListTile(
                    title: const Text("Female"),
                    value: "Female", 
                    groupValue: gender, 
                    onChanged: (value){
                      setState(() {
                          gender = value.toString();
                      });
                    },
                ),
              ],
            ),
            TextFormField(
              initialValue: "VALORE",   
              decoration: const InputDecoration(
              labelText: 'Weight',
              ),
            ),
            TextFormField(
              initialValue: "VALORE",   
              decoration: const InputDecoration(
              labelText: 'E-Mail',
              ),
            ),
            TextFormField(
              initialValue: "VALORE",   
              decoration: const InputDecoration(
              labelText: 'Password',
              ),
            ),

          ],
        ),);
  }

} //ProfilePage

