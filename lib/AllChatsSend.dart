// To parse this JSON data, do
//
//     final allChatsSendResponseModel = allChatsSendResponseModelFromJson(jsonString);

import 'dart:convert';

AllChatsSendResponseModel allChatsSendResponseModelFromJson(String str) => AllChatsSendResponseModel.fromJson(json.decode(str));

String allChatsSendResponseModelToJson(AllChatsSendResponseModel data) => json.encode(data.toJson());

class AllChatsSendResponseModel {
  AllChatsSendResponseModel({
    required this.message,
    required this.status,
  });

  String message;
  String status;

  factory AllChatsSendResponseModel.fromJson(Map<String, dynamic> json) => AllChatsSendResponseModel(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}




class AllChatsSendRequestModel {
  String token;
  String user_id;
  String booking_id;
  String message;

  AllChatsSendRequestModel({
    required this.token,
    required this.user_id,
    required this.booking_id,
    required this.message,
  });



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'token': token,
      'user_id': user_id,
      'booking_id': booking_id,
      'message': message,
    };
    return map;
  }
}