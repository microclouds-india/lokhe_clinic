// To parse this JSON data, do
//
//     final currentBookingsResponseModel = currentBookingsResponseModelFromJson(jsonString);

import 'dart:convert';

CurrentBookingsResponseModel currentBookingsResponseModelFromJson(String str) => CurrentBookingsResponseModel.fromJson(json.decode(str));

String currentBookingsResponseModelToJson(CurrentBookingsResponseModel data) => json.encode(data.toJson());

class CurrentBookingsResponseModel {
  CurrentBookingsResponseModel({
    required this.message,
    required this.data,
    required this.status,
    required this.logged,
  });

  String message;
  List<Datum> data;
  String status;
  String logged;

  factory CurrentBookingsResponseModel.fromJson(Map<String, dynamic> json) => CurrentBookingsResponseModel(
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    status: json["status"],
    logged: json["logged"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
    "logged": logged,
  };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.dob,
    required this.gender,
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
  String dob;
  String gender;
  String modeOfConsultation;
  dynamic roomCode;
  dynamic consultTime;
  String dateTime;
  String timeslot;
  String address;
  String decription;
  String total;
  String paymentStatus;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    dob: json["dob"],
    gender: json["gender"],
    modeOfConsultation: json["mode_of_consultation"],
    roomCode: json["room_code"],
    consultTime: json["consult_time"],
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
    "dob": dob,
    "gender": gender,
    "mode_of_consultation": modeOfConsultation,
    "room_code": roomCode,
    "consult_time": consultTime,
    "date_time": dateTime,
    "Timeslot": timeslot,
    "address": address,
    "decription": decription,
    "total": total,
    "payment_status": paymentStatus,
  };
}





class CurrentBookingsRequestModel {
  String token;

  CurrentBookingsRequestModel({
    required this.token,
  });



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'token': token,
    };
    return map;
  }
}