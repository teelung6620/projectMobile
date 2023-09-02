import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_mobile/config.dart';
import 'package:project_mobile/model/login_request_model.dart';
import 'package:project_mobile/model/login_response_model.dart';
import 'package:project_mobile/model/register_request_model.dart';
import 'package:project_mobile/model/register_response_model.dart';
import 'package:project_mobile/services/shared_service.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, Config.loginAPI);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    if (response.statusCode == 200) {
      await SharedService.setLoginDeatails(
          loginResponseModelFromJson(response.body));
      return true;
    } else {
      return false;
    }
  }

  static Future<RegisterResponseModel> register(
      RegisterRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, Config.registerAPI);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    return registerResponseModelFromJson(response.body);
  }
}
