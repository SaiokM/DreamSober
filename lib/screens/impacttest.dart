import 'dart:convert';

import 'package:dreamsober/models/userprefs.dart';
import 'package:dreamsober/pages/home_page.dart';
import 'package:flutter/material.dart';
import "package:dreamsober/models/impact.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class ImpactTest extends StatelessWidget {
  ImpactTest({Key? key}) : super(key: key);

  static String route = '/impact/';

  static const routename = 'Impact';
  TextEditingController userController = TextEditingController();
  TextEditingController pswController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('${ImpactTest.routename} built');
    userController.text = UserPrefs.getImpactUser();
    pswController.text = UserPrefs.getImpactPsw();

    return Scaffold(
      //appBar: AppBar(        title: Text(ImpactTest.routename),      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async {
                    final result = await _isImpactUp();
                    final message = result
                        ? 'IMPACT backend is up!'
                        : 'IMPACT backend is down!';
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(message)));
                  },
                  child: Text('Ping IMPACT')),
              SizedBox(height: 10),
              TextFormField(
                controller: userController,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: pswController,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async {
                    final result = await _getAndStoreTokens();
                    final message =
                        result == 200 ? 'Request successful' : 'Request failed';
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(message)));
                  },
                  child: const Text('Get tokens')),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final access = UserPrefs.getImpactAccess();
                    final refresh = UserPrefs.getImpactRefresh();
                    final message = access == null
                        ? 'No stored tokens'
                        : 'access: $access;\nrefresh: $refresh';
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(message)));
                  },
                  child: const Text('Print tokens')),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final refresh = UserPrefs.getImpactRefresh();
                    final message;
                    if (refresh == null) {
                      message = 'No stored tokens';
                    } else {
                      final result = await _refreshTokens();
                      message = result == 200
                          ? 'Request successful'
                          : 'Request failed';
                    } //if-else
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(message)));
                  },
                  child: const Text('Refresh tokens')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    UserPrefs.clearTokens();
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text('Tokens have been deleted')));
                  },
                  child: const Text('Delete tokens')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, HomePage.route);
                  },
                  child: const Text('HOME PAGE')),
            ],
          ),
        ),
      ),
    );
  } //build

  //This method allows to check if the IMPACT backend is up
  Future<bool> _isImpactUp() async {
    //Create the request
    final url = Impact.baseUrl + Impact.pingEndpoint;

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url));

    //Just return if the status code is OK
    return response.statusCode == 200;
  } //_isImpactUp

  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  Future<int> _getAndStoreTokens() async {
    //Create the request
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    log(userController.text);
    log(pswController.text);
    UserPrefs.setImpactUsername(userController.text);
    UserPrefs.setImpactPsw(pswController.text);
    Impact.username = userController.text;
    Impact.password = pswController.text;
    final body = {
      'username': userController.text,
      'password': pswController.text
    };

    //Get the response
    log('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If response is OK, decode it and store the tokens. Otherwise do nothing.
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      UserPrefs.setImpactAccess(decodedResponse['access']);
      UserPrefs.setImpactRefresh(decodedResponse['refresh']);
    } //if

    //Just return the status code
    return response.statusCode;
  } //_getAndStoreTokens

  //This method allows to refrsh the stored JWT in SharedPreferences
  Future<int> _refreshTokens() async {
    //Create the request
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final refresh = UserPrefs.getImpactRefresh();
    final body = {'refresh': refresh};

    //Get the response
    log('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If the response is OK, set the tokens in SharedPreferences to the new values
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      UserPrefs.setImpactAccess(decodedResponse['access']);
      UserPrefs.setImpactRefresh(decodedResponse['refresh']);
    } //if

    //Just return the status code
    return response.statusCode;
  } //_refreshTokens
} //HomePage
