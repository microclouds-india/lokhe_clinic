// To parse this JSON data, do
//
//     final allChatsResponseModel = allChatsResponseModelFromJson(jsonString);

import 'dart:convert';

AllChatsResponseModel allChatsResponseModelFromJson(String str) => AllChatsResponseModel.fromJson(json.decode(str));

String allChatsResponseModelToJson(AllChatsResponseModel data) => json.encode(data.toJson());

class AllChatsResponseModel {
  AllChatsResponseModel({
    required this.status,
    required this.data,
  });

  String status;
  List<Datum> data;

  factory AllChatsResponseModel.fromJson(Map<String, dynamic> json) => AllChatsResponseModel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.message,
    required this.sender,
    required this.date,
    required this.time,
  });

  String id;
  String name;
  String message;
  String sender;
  DateTime date;
  String time;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    message: json["message"],
    sender: json["sender"],
    date: DateTime.parse(json["date"]),
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "message": message,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "time": time,
  };
}





class AllChatsRequestModel {
  String token;
  String user_id;
  String booking_id;

  AllChatsRequestModel({
    required this.token,
    required this.user_id,
    required this.booking_id,
  });



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'token': token,
      'user_id': user_id,
      'booking_id': booking_id,
    };
    return map;
  }
}