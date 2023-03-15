// To parse this JSON data, do
//
//     final prescriptionAllResponseModel = prescriptionAllResponseModelFromJson(jsonString);

import 'dart:convert';

PrescriptionAllResponseModel prescriptionAllResponseModelFromJson(String str) => PrescriptionAllResponseModel.fromJson(json.decode(str));

String prescriptionAllResponseModelToJson(PrescriptionAllResponseModel data) => json.encode(data.toJson());

class PrescriptionAllResponseModel {
  PrescriptionAllResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  String message;
  List<Datum> data;
  String status;

  factory PrescriptionAllResponseModel.fromJson(Map<String, dynamic> json) => PrescriptionAllResponseModel(
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
    required this.prescription,
  });

  String id;
  String prescription;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    prescription: json["prescription"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "prescription": prescription,
  };
}




class PrescriptionAllRequestModel {
  String token;
  String booking_id;

  PrescriptionAllRequestModel({
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