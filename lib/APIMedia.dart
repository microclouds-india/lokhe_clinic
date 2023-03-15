import 'dart:async';
import 'dart:io';
import 'package:clinic_app/PrescriptionAllModel.dart';
import 'package:clinic_app/baseURL.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIMedia{

  Future<PrescriptionAllResponseModel> getMedia(PrescriptionAllRequestModel prescriptionAllRequestModel) async {

    var prescriptionAllModel = null;

    var url =Uri.parse(baseURL.base_url+'doctors_api/clinicbooking_download_prescription');
    final response = await http.post(url, body:prescriptionAllRequestModel.toJson());
    print("response timezone: " + response.body);
    // Fluttertoast.showToast(msg: "response: " + response.body, toastLength: Toast.LENGTH_SHORT);
    try {
      // if (response.statusCode == 200) {
        // if (response.body.status == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        prescriptionAllModel = PrescriptionAllResponseModel.fromJson(jsonMap);
        // }
      // }
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
    } catch(Exception){
      return prescriptionAllModel;
    }
    return prescriptionAllModel;
    // {
    //   throw Exception(
    //       Get.showSnackbar(Ui.ErrorSnackBar(message: 'API Failed'.tr)),
    //   );
    // }
  }
}