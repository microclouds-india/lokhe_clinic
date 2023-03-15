// To parse this JSON data, do
//
//     final profileResponseModel = profileResponseModelFromJson(jsonString);

import 'dart:convert';

ProfileResponseModel profileResponseModelFromJson(String str) => ProfileResponseModel.fromJson(json.decode(str));

String profileResponseModelToJson(ProfileResponseModel data) => json.encode(data.toJson());

class ProfileResponseModel {
  ProfileResponseModel({
    required this.message,
    required this.id,
    required this.name,
    required this.topdoctor,
    required this.clinicId,
    required this.specalitiesId,
    required this.username,
    required this.email,
    required this.password,
    required this.phone,
    required this.decription,
    required this.status,
    required this.logged,
  });

  String message;
  String id;
  String name;
  String topdoctor;
  String clinicId;
  String specalitiesId;
  String username;
  String email;
  String password;
  String phone;
  String decription;
  String status;
  String logged;

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) => ProfileResponseModel(
    message: json["message"],
    id: json["id"],
    name: json["name"],
    topdoctor: json["topdoctor"],
    clinicId: json["clinic_id"],
    specalitiesId: json["specalities_id"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    phone: json["phone"],
    decription: json["decription"],
    status: json["status"],
    logged: json["logged"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "id": id,
    "name": name,
    "topdoctor": topdoctor,
    "clinic_id": clinicId,
    "specalities_id": specalitiesId,
    "username": username,
    "email": email,
    "password": password,
    "phone": phone,
    "decription": decription,
    "status": status,
    "logged": logged,
  };
}






class ProfileRequestModel {
  String token;

  ProfileRequestModel({
    required this.token,
  });



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'token': token,
    };
    return map;
  }
}