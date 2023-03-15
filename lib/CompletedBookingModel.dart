// To parse this JSON data, do
//
//     final completedBookingResponseModel = completedBookingResponseModelFromJson(jsonString);

import 'dart:convert';

CompletedBookingResponseModel completedBookingResponseModelFromJson(String str) => CompletedBookingResponseModel.fromJson(json.decode(str));

String completedBookingResponseModelToJson(CompletedBookingResponseModel data) => json.encode(data.toJson());

class CompletedBookingResponseModel {
  CompletedBookingResponseModel({
    required this.message,
    required this.status,
  });

  String message;
  String status;

  factory CompletedBookingResponseModel.fromJson(Map<String, dynamic> json) => CompletedBookingResponseModel(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}




class CompletedBookingRequestModel {
  // String token;
  String booking_id;

  CompletedBookingRequestModel({
    // required this.token,
    required this.booking_id,
  });



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      // 'token': token,
      'booking_id': booking_id,
    };
    return map;
  }
}