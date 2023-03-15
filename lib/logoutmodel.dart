class LogoutResponseModel {
  final String status;
  final String token;
  final String response;

  const LogoutResponseModel({
    required this.status,
    required this.token,
    required this.response,
  });

  factory LogoutResponseModel.fromJson (Map<String, dynamic> json){
    return LogoutResponseModel(
      status: json["status"] != null ? json["status"] : '',
      token: json["token"] != null ? json["token"] : '',
      response: json["response"] != null ? json["response"] : '',);
  }
}

class LogoutRequestModel {
  String token;

  LogoutRequestModel({
    required this.token,
  });



  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'token': token,
    };
    return map;
  }
}
