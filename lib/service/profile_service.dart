import 'dart:convert';
import 'dart:developer';

import 'package:VetScholar/service/fault_navigator.dart';
import 'package:VetScholar/ui/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import '../models/Questions/QuestionResponse.dart';
import '../models/Questions/TestResult.dart';
import 'auth_service.dart';
import 'authorized_client.dart';

class ProfileService {
  final HttpService _httpService = HttpService();
  String? baseUrl = dotenv.env['BASE_URL'];
  String? subjectRoute = dotenv.env['ROUTE_SUBJECTS'];
  String? whoamiPath = dotenv.env['WHO_AM_I_PATH'];
  Future<bool> whoami() async {

    final response = await _httpService.authorizedGet(Uri.parse('$baseUrl$whoamiPath'));
    if (response.statusCode != 200 ){
      log("user have invalid session_id");
      return false;
    }
    log("user have valid session_id");
    return true;
  }
  void logout(BuildContext context) async {
    String? logoutSession = dotenv.env['LOGOUT_SESSION'];
    Response response = await _httpService.authorizedDelete(Uri.parse('$baseUrl$logoutSession'), json.encode({
      'session_token': await AuthService.getAccessToken(),
    }));
    log(response.body);
    if (response.statusCode!= 200 && response.statusCode != 500 ){
      CustomSnackBar().showCustomToastWithCloseButton(context, Colors.red, Icons.close, "Logout Failed!");

    }
    AuthService().deleteAccessToken();
    CustomSnackBar().showCustomToast(context, Colors.green, Icons.check, "Logged Out Successfully!");
    FaultNavigator(context).navigateToLoginScreen();
  }


    Future<Response> fetchProfileData() async {
     return await _httpService.authorizedGet(Uri.parse('$baseUrl$whoamiPath'));
    }

}