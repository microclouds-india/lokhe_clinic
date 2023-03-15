// To parse this JSON data, do
//
//     final completedResponseModel = completedResponseModelFromJson(jsonString);

import 'dart:convert';

CompletedResponseModel completedResponseModelFromJson(String str) => CompletedResponseModel.fromJson(json.decode(str));

String completedResponseModelToJson(CompletedResponseModel data) => json.encode(data.toJson());

class CompletedResponseModel {
  CompletedResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  String message;
  List<Datum> data;
  String status;

  factory CompletedResponseModel.fromJson(Map<String, dynamic> json) => CompletedResponseModel(
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
    required this.gender,
    required this.dob,
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
  String gender;
  String dob;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    modeOfConsultation: json["mode_of_consultation"],
    roomCode: json["room_code"] == null ? "" : json["room_code"],
    consultTime: json["consult_time"],
    dateTime: json["date_time"],
    timeslot: json["Timeslot"],
    address: json["address"],
    decription: json["decription"],
    total: json["total"],
    paymentStatus: json["payment_status"],
    gender: json["gender"],
    dob: json["dob"] == null ? "" : json["dob"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mode_of_consultation": modeOfConsultation,
    "room_code": roomCode,
    "consult_time": consultTime,
    "date_time": dateTime,
    "Timeslot": timeslot,
    "address": address,
    "decription": decription,
    "total": total,
    "payment_status": paymentStatus,
    "gender": gender,
    "dob": dob,
  };
}


class CompletedBookingsRequestModel {
  String token;

  CompletedBookingsRequestModel({
    required this.token,
  });



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'token': token,
    };
    return map;
  }
}


