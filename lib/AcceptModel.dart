// To parse this JSON data, do
//
//     final acceptButtonResponseModel = acceptButtonResponseModelFromJson(jsonString);

import 'dart:convert';

AcceptButtonResponseModel acceptButtonResponseModelFromJson(String str) => AcceptButtonResponseModel.fromJson(json.decode(str));

String acceptButtonResponseModelToJson(AcceptButtonResponseModel data) => json.encode(data.toJson());

class AcceptButtonResponseModel {
  AcceptButtonResponseModel({
    required this.message,
    required this.status,
  });

  String message;
  String status;

  factory AcceptButtonResponseModel.fromJson(Map<String, dynamic> json) => AcceptButtonResponseModel(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}



class AcceptRequestModel {
  String token;
  String booking_id;
  String mode_of_consultation;
  String consult_time;

  AcceptRequestModel({
    required this.token,
    required this.booking_id,
    required this.mode_of_consultation,
    required this.consult_time,
  });



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'token': token,
      'booking_id': booking_id,
      'mode_of_consultation': mode_of_consultation,
      'consult_time': consult_time,
    };
    return map;
  }
}