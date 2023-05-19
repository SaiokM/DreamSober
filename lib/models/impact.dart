import 'package:dreamsober/models/userprefs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:dreamsober/models/sleepday.dart';
import 'package:dreamsober/models/sleepphase.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Impact with ChangeNotifier {
  static String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';
  static String sleepEndpoint = 'data/v1/sleep/patients/';
  static String patientUsername = 'Jpefaq6m58';

  static Future<int> getTokens() async {
    //Create the request
    final url = baseUrl + tokenEndpoint;
    final body = {
      'username': UserPrefs.getImpactUser(),
      'password': UserPrefs.getImpactPsw(),
    };

    log('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If response is OK, decode it and store the tokens. Otherwise do nothing.
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      UserPrefs.setImpactAccess(decodedResponse['access']);
      UserPrefs.setImpactRefresh(decodedResponse['refresh']);
      return response.statusCode;
    } //if

    //Just return the status code
    return response.statusCode;
  }

  static Future<int> refreshTokens() async {
    final url = baseUrl + refreshEndpoint;
    final refresh = UserPrefs.getImpactRefresh();
    final body = {'refresh': refresh};
    log('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      UserPrefs.setImpactAccess(decodedResponse['access']);
      UserPrefs.setImpactRefresh(decodedResponse['refresh']);
      return response.statusCode;
    }
    return response.statusCode;
  }

  static Future<List<SleepDay>?> getSleepRangeData(
      String startDate, String endDate) async {
    var access = UserPrefs.getImpactAccess();
    if (JwtDecoder.isExpired(access!)) {
      await refreshTokens();
      access = UserPrefs.getImpactAccess();
    }

    List<SleepDay> sleepWeek = [];
    final url =
        "$baseUrl$sleepEndpoint$patientUsername/daterange/start_date/$startDate/end_date/$endDate/";
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      for (int i = 0; i < decodedResponse['data'].length; i++) {
        sleepWeek.add(SleepDay.fromJson(decodedResponse['data'][i]));
      }
      log(sleepWeek.length.toString());
    } else {
      return null;
    }
    return sleepWeek;
  }
}
