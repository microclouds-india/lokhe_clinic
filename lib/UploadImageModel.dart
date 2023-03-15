// To parse this JSON data, do
//
//     final uploadImageResponseModel = uploadImageResponseModelFromJson(jsonString);

import 'dart:convert';

UploadImageResponseModel uploadImageResponseModelFromJson(String str) => UploadImageResponseModel.fromJson(json.decode(str));

String uploadImageResponseModelToJson(UploadImageResponseModel data) => json.encode(data.toJson());

class UploadImageResponseModel {
  UploadImageResponseModel({
    required this.uploadData,
    required this.message,
    required this.filesCount,
    required this.status,
  });

  UploadData uploadData;
  String message;
  int filesCount;
  String status;

  factory UploadImageResponseModel.fromJson(Map<String, dynamic> json) => UploadImageResponseModel(
    uploadData: UploadData.fromJson(json["upload_data"]),
    message: json["message"],
    filesCount: json["files_count"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "upload_data": uploadData.toJson(),
    "message": message,
    "files_count": filesCount,
    "status": status,
  };
}

class UploadData {
  UploadData({
    required this.error,
  });

  String error;

  factory UploadData.fromJson(Map<String, dynamic> json) => UploadData(
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
  };
}



class UploadImageRequestModel {
  String token;
  String booking_id;
  String image;

  UploadImageRequestModel({
    required this.token,
    required this.booking_id,
    required this.image,
  });



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'token': token,
      'booking_id': booking_id,
      'image': image,
    };
    return map;
  }
}