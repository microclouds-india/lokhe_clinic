import 'dart:convert';

TimeslotResponseModel timeslotResponseModelFromJson(String str) => TimeslotResponseModel.fromJson(json.decode(str));

String timeslotResponseModelToJson(TimeslotResponseModel data) => json.encode(data.toJson());

class TimeslotResponseModel {
  TimeslotResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory TimeslotResponseModel.fromJson(Map<String, dynamic> json) => TimeslotResponseModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.timeslotName,
    required this.startTime,
    required this.eTime,
    required this.status,
  });

  String id;
  String timeslotName;
  String startTime;
  String eTime;
  String status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    timeslotName: json["timeslot_name"],
    startTime: json["start_time"],
    eTime: json["e_time"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "timeslot_name": timeslotName,
    "start_time": startTime,
    "e_time": eTime,
    "status": status,
  };
}

class TimeslotRequestModel {
  String token;
  String date;

  TimeslotRequestModel({
    required this.token,
    required this.date,
  });



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'token': token,
      'date': date,
    };
    return map;
  }
}