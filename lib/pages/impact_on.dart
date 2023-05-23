import 'dart:convert';
import 'dart:io';
import 'package:dreamsober/models/sleepday.dart';
import 'package:dreamsober/pages/authorization/auth_page.dart';
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
  static bool _passwordVisible = false;
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

  void _showPassword() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
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
                    Image.asset(
                      'assets/impact_logo.png',
                      fit: BoxFit.fitWidth,
                    ),
                    const Text('Please authorize to use our app',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Username',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                      controller: userController,
                      cursorColor: const Color(0xFF83AA99),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF89453C),
                          ),
                        ),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFF89453C),
                        ),
                        hintText: 'Username',
                        hintStyle: const TextStyle(color: Color(0xFF89453C)),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Password',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      controller: pswController,
                      cursorColor: const Color(0xFF83AA99),
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF89453C),
                          ),
                        ),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF89453C),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _showPassword();
                          },
                        ),
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Color(0xFF89453C)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              final result = await getandsaveTokens();
                              final message = result == 200
                                  ? 'Login successful'
                                  : 'Login failed';
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(
                                    SnackBar(content: Text(message)));
                              Navigator.pushReplacementNamed(
                                  context, AuthPage.route);
                              message == 200
                                  ? Navigator.pushReplacementNamed(
                                      context, AuthPage.route)
                                  : null;
                            },
                            child: const Text('Login')),
                        /*child: ElevatedButton(
                          onPressed: () async {
                            bool? validation = true;
                            if (!validation) {
                              // if not correct show message
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(8),
                                content: Text('Wrong Credentials'),
                                duration: Duration(seconds: 2),
                              ));
                            } else {
                              // else move to Purpleair Onboarding if we have not saved a api key yet
                              UserPrefs.setImpactUsername(userController.text);
                              UserPrefs.setImpactPsw(pswController.text);
                            }
                          },
                          style: ButtonStyle(
                              //maximumSize: const MaterialStatePropertyAll(Size(50, 20)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                              elevation: MaterialStateProperty.all(0),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  const EdgeInsets.symmetric(
                                      horizontal: 80, vertical: 12)),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF89453C))),
                          child: const Text('Authorize'),
                        ),*/
                      ),
                    ),
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
