import 'dart:async';
import 'dart:io';
import 'package:clinic_app/baseURL.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Ui.dart';
import 'loginmodel.dart';
import 'logoutmodel.dart';

class Logout{

  Future<LogoutResponseModel> logout(LogoutRequestModel logoutRequestModel) async {

    var url =Uri.parse(baseURL.base_url+'doctors_api/clinic_logout');
    final response = await http.post(url, body:logoutRequestModel.toJson());
    try {
      if (response.statusCode == 200) {
        return LogoutResponseModel.fromJson(json.decode(response.body));
      }
    }on SocketException {
      print('No Internet connection');
      print(SocketException);
    } on HttpException {
      print("Couldn't find the post");
      print(HttpException);
    } on FormatException {
      print("Bad response format");
      print(FormatException);
    } on TimeoutException {
      print("Timeout");
      print(TimeoutException);
    }
    {
      throw Exception(
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'API Failed'.tr)),
      );
    }
  }
}

