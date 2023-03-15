// To parse this JSON data, do
//
//     final roomEnterModel = roomEnterModelFromJson(jsonString);

import 'dart:convert';

RoomEnterModel roomEnterModelFromJson(String str) => RoomEnterModel.fromJson(json.decode(str));

String roomEnterModelToJson(RoomEnterModel data) => json.encode(data.toJson());

class RoomEnterModel {
  RoomEnterModel({
    required this.status,
    required this.message,
    required this.roomCode,
    required this.currentTime,
    required this.currentDate,
    required this.bookingDate,
    required this.availTime,
  });

  String status;
  String message;
  String roomCode;
  String currentTime;
  String currentDate;
  String bookingDate;
  String availTime;

  factory RoomEnterModel.fromJson(Map<String, dynamic> json) => RoomEnterModel(
    status: json["status"],
    message: json["message"],
    roomCode: json["room_code"],
    currentTime: json["current_time"],
    currentDate: json["current_date"],
    bookingDate: json["booking_date"],
    availTime: json["avail_time"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "room_code": roomCode,
    "current_time": currentTime,
    "current_date": currentDate,
    "booking_date": bookingDate,
    "avail_time": availTime,
  };
}


class RoomEnterRequestModel {
  String token;
  String booking_id;

  RoomEnterRequestModel({
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