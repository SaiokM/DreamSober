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
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      UserPrefs.setImpactAccess(decodedResponse['access']);
      UserPrefs.setImpactRefresh(decodedResponse['refresh']);
      return response.statusCode;
    }
    log(response.statusCode.toString());
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

  static Future<Map<String, SleepDay>> getSleepRangeData(
      String startDate, String endDate) async {
    var access = UserPrefs.getImpactAccess();
    if (JwtDecoder.isExpired(access!)) {
      await refreshTokens();
      access = UserPrefs.getImpactAccess();
    }

    Map<String, SleepDay> sleepRange = {};
    final url =
        "$baseUrl$sleepEndpoint$patientUsername/daterange/start_date/$startDate/end_date/$endDate/";
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    final response = await http.get(Uri.parse(url), headers: headers);

    //log("----Impact-----${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      for (int i = 0; i < decodedResponse['data'].length; i++) {
        SleepDay day = SleepDay.fromJson(decodedResponse['data'][i]);
        sleepRange[day.date] = day;
        //print(day.duration);
      }
    }
    //log("${sleepRange.toString()}\n----Impact-----");
    return sleepRange;
  }
}
