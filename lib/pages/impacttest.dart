import 'package:dreamsober/models/sleepday.dart';
import 'package:dreamsober/pages/authorization/auth_page.dart';
import 'package:dreamsober/models/userprefs.dart';
import 'package:flutter/material.dart';
import "package:dreamsober/models/impact.dart";
import 'package:http/http.dart' as http;
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
      //appBar: AppBar(title: Text(ImpactTest.routename),),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              TextFormField(
                controller: userController,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: pswController,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async {
                    final result = await getandsaveTokens();
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
                      final result = await Impact.refreshTokens();
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
                      ..showSnackBar(SnackBar(
                          content: const Text('Tokens have been deleted')));
                  },
                  child: const Text('Delete tokens')),
              ElevatedButton(
                  onPressed: () async {
                    Map<String, SleepDay>? results =
                        await Impact.getSleepRangeData(
                            '2023-05-04', '2023-05-10');
                    String message =
                        results != null ? "Data retrived!" : "Error!";
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(message)));
                    log(results.toString());
                  },
                  child: Text("Get Data")),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async {
                    await getandsaveTokens();
                    Navigator.pushReplacementNamed(context, AuthPage.route);
                  },
                  child: const Text('HOME PAGE')),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _isImpactUp() async {
    //Create the request
    final url = Impact.baseUrl + Impact.pingEndpoint;

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url));

    //Just return if the status code is OK
    return response.statusCode == 200;
  } //_isImpactUp

  Future<int> getandsaveTokens() async {
    UserPrefs.setImpactUsername(userController.text.trim());
    UserPrefs.setImpactPsw(pswController.text.trim());
    return await Impact.getTokens();
  }
}