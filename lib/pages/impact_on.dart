import 'dart:convert';
import 'dart:io';
import 'package:dreamsober/components/my_button.dart';
import 'package:dreamsober/components/rectangle_tile.dart';
import 'package:dreamsober/components/textfield_psw.dart';
import 'package:dreamsober/components/textfield_user.dart';
import 'package:dreamsober/models/sleepday.dart';
import 'package:dreamsober/pages/authorization/auth_page.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dreamsober/models/userprefs.dart';
import 'package:dreamsober/pages/home_page.dart';
import 'package:flutter/material.dart';
import "package:dreamsober/models/impact.dart";
import 'package:http/http.dart' as http;
import 'dart:developer';

class ImpactOnboarding extends StatefulWidget {
  const ImpactOnboarding({Key? key}) : super(key: key);

  static const route = '/impact/';
  static const routeDisplayName = 'ImpactOnboardingPage';

  @override
  State<ImpactOnboarding> createState() => _ImpactOnboardingState();
}

class _ImpactOnboardingState extends State<ImpactOnboarding> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController pswController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    log(UserPrefs.getImpactLogin().toString());
    if (UserPrefs.getImpactLogin()) {
      userController.text = UserPrefs.getImpactUser();
      pswController.text = UserPrefs.getImpactPsw();
    }
    super.initState();
  }

  Future<int> getandsaveTokens() async {
    UserPrefs.setImpactUsername(userController.text.trim());
    UserPrefs.setImpactPsw(pswController.text.trim());
    return await Impact.getTokens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.brown[100],
      appBar: UserPrefs.getImpactLogin() ? AppBar() : null,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Image.asset(
                      'assets/impact_logo.png',
                      fit: BoxFit.fitWidth,
                    ),
                    const Text('Please authorize to use our app',
                        style: TextStyle(
                          fontSize: 16,
                        )),

                    const SizedBox(height: 20),

                    //User textfield
                    UserTextField(
                      controller: userController,
                      hintText: 'Username',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    //password textfield
                    PswTextField(
                      controller: pswController,
                      hintText: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 20),

                    // SIgn in button
                    MyButton(
                        text: 'Authorize',
                        onTap: () async {
                          final result = await getandsaveTokens();
                          final message = result == 200
                              ? 'Login successful'
                              : 'Login failed';
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(message)));
                          log('Response: $message');
                          result == 200
                              ? Navigator.pushReplacementNamed(
                                  context, AuthPage.route)
                              : null;
                        }),

                    const SizedBox(height: 20),

                    // or continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // fitbit button
                    RectangleTile(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Avaible from the next update"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        imagePath: 'assets/fitbit_logo.png'),

                    const SizedBox(width: 35),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
