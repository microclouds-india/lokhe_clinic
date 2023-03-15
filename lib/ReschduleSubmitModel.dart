



class RescheduleSubmitRequestModel {
  String token;
  String consult_time;
  String date;
  String timeslot_id;
  String booking_id;

  RescheduleSubmitRequestModel({
    required this.token,
    required this.consult_time,
    required this.date,
    required this.timeslot_id,
    required this.booking_id,
  });



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'token': token,
      'consult_time': consult_time,
      'date': date,
      'timeslot_id': timeslot_id,
      'booking_id': booking_id,
    };
    return map;
  }
}