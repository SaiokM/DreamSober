import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const routename = 'ProfilePage';

  @override
  Widget build(BuildContext context) {
    print('${ProfilePage.routename} built');
    return Scaffold(
      body: _buildForm(context),
    );
  } //build


  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(

    );
  }
}//ProfilePage

