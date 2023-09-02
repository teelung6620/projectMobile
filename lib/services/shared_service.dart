import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/model/login_response_model.dart';

class SharedService {
  static Future<bool> isLoggedIn() async {
    var isKeyExist =
        await APICacheManager().isAPICacheKeyExist("login-details");
    return isKeyExist;
  }

  static Future<LoginResponseModel?> loginDetails() async {
    var isKeyExist =
        await APICacheManager().isAPICacheKeyExist("login-details");

    if (isKeyExist) {
      var cacheData = await APICacheManager().getCacheData("login-deatils");

      return loginResponseModelFromJson(cacheData.syncData);
    }
  }

  static Future<void> setLoginDeatails(
    LoginResponseModel model,
  ) async {
    APICacheDBModel cacheDBModel = APICacheDBModel(
        key: "login-details", syncData: jsonEncode(model.toJson()));

    await APICacheManager().addCacheData(cacheDBModel);
  }

  static Future<void> logout(BuildContext context) async {
    await APICacheManager().deleteCache("login-details");
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
