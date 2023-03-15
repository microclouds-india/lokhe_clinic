// To parse this JSON data, do
//
//     final RejectedBookingsResponseModel = RejectedBookingsResponseModelFromJson(jsonString);

import 'dart:convert';

RejectedBookingsResponseModel RejectedBookingsResponseModelFromJson(String str) => RejectedBookingsResponseModel.fromJson(json.decode(str));

String RejectedBookingsResponseModelToJson(RejectedBookingsResponseModel data) => json.encode(data.toJson());

class RejectedBookingsResponseModel {
  RejectedBookingsResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  String message;
  List<Datum> data;
  String status;

  factory RejectedBookingsResponseModel.fromJson(Map<String, dynamic> json) => RejectedBookingsResponseModel(
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
  };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.modeOfConsultation,
    required this.roomCode,
    required this.consultTime,
    required this.dateTime,
    required this.timeslot,
    required this.address,
    required this.decription,
    required this.total,
    required this.paymentStatus,
  });

  String id;
  String name;
  String modeOfConsultation;
  String roomCode;
  String consultTime;
  String dateTime;
  String timeslot;
  String address;
  String decription;
  String total;
  String paymentStatus;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    modeOfConsultation: json["mode_of_consultation"],
    roomCode: json["room_code"] == null ? null : json["room_code"],
    consultTime: json["consult_time"] == null ? null : json["consult_time"],
    dateTime: json["date_time"],
    timeslot: json["Timeslot"],
    address: json["address"],
    decription: json["decription"],
    total: json["total"],
    paymentStatus: json["payment_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mode_of_consultation": modeOfConsultation,
    "room_code": roomCode == null ? null : roomCode,
    "consult_time": consultTime == null ? null : consultTime,
    "date_time": dateTime,
    "Timeslot": timeslot,
    "address": address,
    "decription": decription,
    "total": total,
    "payment_status": paymentStatus,
  };
}




class RejectedBookingsRequestModel {
  String token;

  RejectedBookingsRequestModel({
    required this.token,
  });



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'token': token,
    };
    return map;
  }
}