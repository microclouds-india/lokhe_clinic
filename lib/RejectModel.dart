// To parse this JSON data, do
//
//     final rejectButtonResponseModel = rejectButtonResponseModelFromJson(jsonString);

import 'dart:convert';

RejectButtonResponseModel rejectButtonResponseModelFromJson(String str) => RejectButtonResponseModel.fromJson(json.decode(str));

String rejectButtonResponseModelToJson(RejectButtonResponseModel data) => json.encode(data.toJson());

class RejectButtonResponseModel {
  RejectButtonResponseModel({
    required this.message,
    required this.status,
  });

  String message;
  String status;

  factory RejectButtonResponseModel.fromJson(Map<String, dynamic> json) => RejectButtonResponseModel(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}




class RejectRequestModel {
  String token;
  String booking_id;

  RejectRequestModel({
    required this.token,
    required this.booking_id,
  });



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'token': token,
      'booking_id': booking_id,
    };
    return map;
  }
}