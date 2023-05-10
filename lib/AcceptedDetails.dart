import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:clinic_app/UploadImageModel.dart';
import 'package:clinic_app/baseURL.dart';
import 'package:clinic_app/progressbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'AcceptedBookingsResponseModel.dart';
import 'ChatScreen.dart';
import 'CompletedBookingModel.dart';
import 'RoomEnterModel.dart';
import 'dart:math' as math;
import 'package:path/path.dart' as Path;
import 'dart:convert';
import 'package:async/async.dart';

class AcceptedDetail extends StatefulWidget {
  final int index;
  List data;
  List diseasesdata;

  AcceptedDetail(
      {required this.index, required this.data, required this.diseasesdata});

  @override
  State<AcceptedDetail> createState() => _AcceptedDetailState();
}

class _AcceptedDetailState extends State<AcceptedDetail> {
  var token = "";

  final ImagePicker imagePicker = ImagePicker();
  List imageFileList = [];
  String? valueChoose;
  final descriptionText = TextEditingController();

  AcceptedBookingsRequestModel acceptedBookingsRequestModel =
  new AcceptedBookingsRequestModel(token: '');
  RoomEnterRequestModel requestModelRoomEnter =
  new RoomEnterRequestModel(token: '', booking_id: '');
  CompletedBookingRequestModel completedBookingRequestModel =
  new CompletedBookingRequestModel(booking_id: '');
  UploadImageRequestModel uploadImageRequestModel =
  new UploadImageRequestModel(token: '', booking_id: '', image: '');

  final serverText = TextEditingController(text: "https://meeting.lokhes.in");
  // final serverText = TextEditingController(text: "https://meet.jit.si/");

  // final serverText = TextEditingController(text: "https://jitsi.tatoobooks.com/");
  final roomText = TextEditingController(text: "plugintestroom");
  final subjectText = TextEditingController(text: "My Plugin Test Meeting");
  final nameText = TextEditingController(text: "Plugin Test User");
  final emailText = TextEditingController(text: "fake@email.com");
  final iosAppBarRGBAColor =
  TextEditingController(text: "#0080FF80"); //transparent blue
  bool isAudioOnly = true;
  bool isAudioMuted = true;
  bool isVideoMuted = true;
  var video_url = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Accepted Order".tr, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[800],
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.lightBlue[800]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_outlined,color: Colors.lightBlue[800]!),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      width: 1,
                      height: 24,
                      color: Colors.lightBlue[800]!,
                    ),
                    Expanded(
                      child: Text(
                          "Name ".tr,
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                    Flexible(
                      child: Text(widget.data[widget.index]["name"]==null ? "" : ": "+widget.data[widget.index]["name"],
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.place_outlined,color: Colors.lightBlue[800]!),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      width: 1,
                      height: 24,
                      color: Colors.lightBlue[800]!,
                    ),
                    Expanded(
                      child: Text(
                          "Address ".tr,
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                    Flexible(
                      child: Text(widget.data[widget.index]["address"]==null ? "" : ": "+widget.data[widget.index]["address"],
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month_outlined,color: Colors.lightBlue[800]!),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      width: 1,
                      height: 24,
                      color: Colors.lightBlue[800]!,
                    ),
                    Expanded(
                      child: Text(
                          "Date of Birth ".tr,
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                    Flexible(
                      child: Text(widget.data[widget.index]["dob"]==null ? "" : ": "+widget.data[widget.index]["dob"],
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.data[widget.index]["gender"] == "Male" ? Icons.male : Icons.female,color: Colors.lightBlue[800]!),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      width: 1,
                      height: 24,
                      color: Colors.lightBlue[800]!,
                    ),
                    Expanded(
                      child: Text(
                          "Gender ".tr,
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                    Flexible(
                      child: Text(widget.data[widget.index]["gender"]==null ? "" : ": "+widget.data[widget.index]["gender"],
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_outline,color: Colors.lightBlue[800]!),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      width: 1,
                      height: 24,
                      color: Colors.lightBlue[800]!,
                    ),
                    Expanded(
                      child: Text(
                          "Mode of consultation ".tr,
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                    Flexible(
                      child: Text(widget.data[widget.index]["mode_of_consultation"]==null ? "" : ": "+widget.data[widget.index]["mode_of_consultation"],
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.date_range_outlined,color: Colors.lightBlue[800]!),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      width: 1,
                      height: 24,
                      color: Colors.lightBlue[800]!,
                    ),
                    Expanded(
                      child: Text(
                          "Date ".tr,
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                    Flexible(
                      child: Text(widget.data[widget.index]["date_time"]==null ? "" : ": "+widget.data[widget.index]["date_time"],
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timelapse_outlined,color: Colors.lightBlue[800]!),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      width: 1,
                      height: 24,
                      color: Colors.lightBlue[800]!,
                    ),
                    Expanded(
                      child: Text(
                          "Time ".tr,
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                    Flexible(
                      child: Text(widget.data[widget.index]["Timeslot"]==null ? "" : ": "+widget.data[widget.index]["Timeslot"],
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.payment_outlined,color: Colors.lightBlue[800]!),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      width: 1,
                      height: 24,
                      color: Colors.lightBlue[800]!,
                    ),
                    Expanded(
                      child: Text(
                          "Payment status ".tr,
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                    Flexible(
                      child: Text(widget.data[widget.index]["payment_status"]==null ? "" : ": "+widget.data[widget.index]["payment_status"],
                          style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    showAlertDialog(context);
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    var token = prefs.getString('token');

                    requestModelRoomEnter.token = token!;
                    requestModelRoomEnter.booking_id =
                    widget.data[widget.index]["id"];

                    var RoomEnterResponseModel = null;

                    var url = Uri.parse(
                        baseURL.base_url + 'doctors_api/generate_roomcode');
                    final response = await http.post(url,
                        body: requestModelRoomEnter.toJson());
                    print("response timezone: " + response.body);
                    // Fluttertoast.showToast(msg: "response: " + response.body, toastLength: Toast.LENGTH_SHORT);
                    try {
                      if (response.statusCode == 200) {
                        var jsonResponse = convert.jsonDecode(response.body)
                        as Map<String, dynamic>;
                        if (jsonResponse['status'] == "200") {
                          Navigator.of(context, rootNavigator: true).pop();
                          // RoomEnterResponseModel = RoomEnterModel.fromJson(jsonResponse);
                          if (jsonResponse['room_code'] == "No Roomcode") {
                            Fluttertoast.showToast(
                                msg: "You can enter the room only in " +
                                    jsonResponse['booking_date'] +
                                    " at " +
                                    jsonResponse['avail_time'] +
                                    "",
                                toastLength: Toast.LENGTH_SHORT);
                            // Get.showSnackbar(Ui.RoomCodeSnackBar(message: "You can enter the room only in "+jsonResponse['booking_date']+" at "+jsonResponse['avail_time']+""));
                          } else {
                            // JitsiMeet.addListener(JitsiMeetingListener(
                            //     onConferenceWillJoin: _onConferenceWillJoin,
                            //     onConferenceJoined: _onConferenceJoined,
                            //     onConferenceTerminated:
                            //     _onConferenceTerminated,
                            //     onError: _onError));
                            video_url = jsonResponse['video_url'];
                            _joinMeeting(jsonResponse['room_code'], jsonResponse['video_url']);
                          }
                        } else if (jsonResponse['status'] == "400") {
                          Navigator.of(context, rootNavigator: true).pop();
                          // Fluttertoast.showToast( msg: "There is no timeslot in "+formattedDate.toString(), toastLength: Toast.LENGTH_SHORT);
                        } else if (jsonResponse['status'] == "404") {
                          Navigator.of(context, rootNavigator: true).pop();
                          // Fluttertoast.showToast( msg: "Empty fields", toastLength: Toast.LENGTH_SHORT);
                        } else {
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                      }
                    } on SocketException {
                      print('No Internet connection');
                      print(SocketException);
                    } on HttpException {
                      print("Couldn't find the post");
                      print(HttpException);
                    } on FormatException {
                      print("Bad response format");
                      print(FormatException);
                    } catch (Exception) {
                      return RoomEnterResponseModel;
                    }
                    return RoomEnterResponseModel;
                    // {
                    //   throw Exception(
                    //       Get.showSnackbar(Ui.ErrorSnackBar(message: 'API Failed'.tr)),
                    //   );
                    // }
                  },
                  child: Text('     Join Meeting     '),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue[800],
                    elevation: 5,
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (widget.diseasesdata != null)
                Center(
                  child: ElevatedButton.icon(
                    icon: Text(
                      'Upload Prescription',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white),
                    ),
                    label: Icon(Icons.drive_folder_upload, size: 20),
                    onPressed: () =>
                    {
                      selectImages(widget.index, context),
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue[800],
                      elevation: 5,
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  margin:
                  EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.lightBlue[800]!, // set border color
                        width: 1.5), // set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(20.0)), // set rounded corner radius
                  ),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.top,
                    // onChanged: (input) => requestModelRateDoctor.comments = input,
                    controller: descriptionText,
                    maxLines: null,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(
                      // Icons.phone_android,
                      // ),
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      hintText: 'Please add description...',
                      counterText: '',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.lightBlue[800]!, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton(
                      hint: Text("Select disease"),
                      // dropdownColor: Colors.lightBlue[800]!,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: (TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      )),
                      value: valueChoose,
                      onChanged: (newValue) {
                        setState(() {
                          valueChoose = newValue as String;
                        });
                      },
                      items: widget.diseasesdata.map((valueItem) {
                        print("widget.index: " + widget.index.toString());
                        for (int i = 0;
                        i <= widget.diseasesdata.length;
                        i++) {}
                        return DropdownMenuItem(
                            value: valueItem["id"],
                            child: Text(valueItem["title"]));
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              print("valueChoose: " +
                                  imageFileList!.length.toString());

                              if (imageFileList!.length == 0) {
                                Fluttertoast.showToast(
                                    msg: "Please select prescription",
                                    toastLength: Toast.LENGTH_SHORT);
                              } else if (descriptionText.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please enter description",
                                    toastLength: Toast.LENGTH_SHORT);
                              } else if (valueChoose == null) {
                                Fluttertoast.showToast(
                                    msg: "Please select disease",
                                    toastLength: Toast.LENGTH_SHORT);
                              } else {
                                showAlertDialog(context);

                                var uri = Uri.parse(baseURL.base_url +
                                    'doctors_api/clinicbooking_upload_prescription');
                                var request =
                                http.MultipartRequest('POST', uri);
                                for (int i = 0; i < imageFileList!.length; i++) {
                                  request.files.add(
                                    http.MultipartFile(
                                      'image[$i]',
                                      http.ByteStream(DelegatingStream.typed(
                                          imageFileList![i].openRead())),
                                      await imageFileList![i].length(),
                                      filename: Path.basename(
                                          imageFileList![i].path),
                                    ),
                                  );
                                }

                                request.fields['booking_id'] =
                                widget.data[widget.index]["id"];
                                request.fields['disease_id'] =
                                    valueChoose.toString();
                                request.fields['description'] =
                                    descriptionText.text;

                                var response = await request.send();
                                response.stream
                                    .transform(utf8.decoder)
                                    .listen((value) {
                                  var jsonResponse = convert.jsonDecode(value)
                                  as Map<String, dynamic>;
                                  if (jsonResponse['status'] == "200") {
                                    setState(() {
                                      Navigator.of(context,
                                          rootNavigator: true)
                                          .pop();
                                      Fluttertoast.showToast(
                                          msg: "${jsonResponse['message']}",
                                          toastLength: Toast.LENGTH_SHORT);
                                      descriptionText.clear();
                                      imageFileList.clear();
                                    });
                                  } else {
                                    setState(() {
                                      Navigator.of(context,
                                          rootNavigator: true)
                                          .pop();
                                      Fluttertoast.showToast(
                                          msg: "${jsonResponse['message']}",
                                          toastLength: Toast.LENGTH_SHORT);
                                    });
                                  }
                                });
                              }
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.lightBlue[800],
                              onPrimary: Colors.white,
                              elevation: 5,
                              padding: EdgeInsets.only(left: 40, right: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(20), // <-- Radius
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              print("booking_id: " +
                                  widget.data![widget.index]["id"]);
                              Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatScreen(
                                              widget.data![widget
                                                  .index]["id"],
                                              widget.data![widget.index]
                                              ["userid"])));
                            },
                            child: Text(
                              'Chat',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.lightBlue[800],
                              onPrimary: Colors.white,
                              elevation: 5,
                              padding: EdgeInsets.only(left: 40, right: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(20), // <-- Radius
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => HomePage()),
                    // );

                    showAlertDialog(context);
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    var token = prefs.getString('token');

                    // completedBookingRequestModel.token = token!;
                    completedBookingRequestModel.booking_id =
                    widget.data[widget.index]["id"];

                    var RoomEnterResponseModel = null;

                    var url = Uri.parse(baseURL.base_url +
                        'doctors_api/clinicbooking_complete_button');
                    final response = await http.post(url,
                        body: completedBookingRequestModel.toJson());
                    print("response timezone: " + response.body);
                    // Fluttertoast.showToast(msg: "response: " + response.body, toastLength: Toast.LENGTH_SHORT);
                    try {
                      if (response.statusCode == 200) {
                        var jsonResponse = convert.jsonDecode(response.body)
                        as Map<String, dynamic>;
                        if (jsonResponse['status'] == "200") {
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.of(context, rootNavigator: true).pop();
                          // getAllBookings(acceptedBookingsRequestModel);
                        } else if (jsonResponse['status'] == "400") {
                          Navigator.of(context, rootNavigator: true).pop();
                          // Fluttertoast.showToast( msg: "There is no timeslot in "+formattedDate.toString(), toastLength: Toast.LENGTH_SHORT);
                        } else if (jsonResponse['status'] == "404") {
                          Navigator.of(context, rootNavigator: true).pop();
                          // Fluttertoast.showToast( msg: "Empty fields", toastLength: Toast.LENGTH_SHORT);
                        } else {
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                      }
                    } on SocketException {
                      print('No Internet connection');
                      print(SocketException);
                    } on HttpException {
                      print("Couldn't find the post");
                      print(HttpException);
                    } on FormatException {
                      print("Bad response format");
                      print(FormatException);
                    } catch (Exception) {
                      return RoomEnterResponseModel;
                    }
                    return RoomEnterResponseModel;
                    // {
                    //   throw Exception(
                    //       Get.showSnackbar(Ui.ErrorSnackBar(message: 'API Failed'.tr)),
                    //   );
                    // }
                  },
                  child: Text('Complete meeting'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue[800],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _joinMeeting(String room_code, String video_url) async {
  //   // String serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;
  //
  //   // Enable or disable any feature flag here
  //   // If feature flag are not provided, default values will be used
  //   // Full list of feature flags (and defaults) available in the README
  //   Map<FeatureFlagEnum, bool> featureFlags = {
  //     FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
  //   };
  //   if (!kIsWeb) {
  //     // Here is an example, disabling features for each platform
  //     if (Platform.isAndroid) {
  //       // Disable ConnectionService usage on Android to avoid issues (see README)
  //       featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
  //     } else if (Platform.isIOS) {
  //       // Disable PIP on iOS as it looks weird
  //       featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
  //     }
  //   }
  //   // Define meetings options here
  //   // var options = JitsiMeetingOptions(room: roomText.text)
  //   var options = JitsiMeetingOptions(room: room_code)
  //     // ..serverURL = serverText.text
  //     ..serverURL = video_url
  //     ..subject = subjectText.text
  //     ..userDisplayName = nameText.text
  //     ..userEmail = emailText.text
  //     ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
  //     ..audioOnly = isAudioOnly
  //     ..audioMuted = isAudioMuted
  //     ..videoMuted = isVideoMuted
  //     ..featureFlags.addAll(featureFlags)
  //     ..webOptions = {
  //       // "roomName": roomText.text,
  //       "roomName": room_code,
  //       "width": "100%",
  //       "height": "100%",
  //       "enableWelcomePage": false,
  //       "chromeExtensionBanner": null,
  //       "userInfo": {"displayName": nameText.text}
  //     };
  //
  //   debugPrint("JitsiMeetingOptions: $options");
  //   await JitsiMeet.joinMeeting(
  //     options,
  //     listener: JitsiMeetingListener(
  //         onConferenceWillJoin: (message) {
  //           debugPrint("${options.room} will join with message: $message");
  //         },
  //         onConferenceJoined: (message) {
  //           debugPrint("${options.room} joined with message: $message");
  //         },
  //         onConferenceTerminated: (message) {
  //           debugPrint("${options.room} terminated with message: $message");
  //         },
  //         genericListeners: [
  //           JitsiGenericListener(
  //               eventName: 'readyToClose',
  //               callback: (dynamic message) {
  //                 debugPrint("readyToClose callback");
  //               }),
  //         ]),
  //   );
  // }

  _joinMeeting(String room_code, String video_url) async {
    String? serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;

    Map<FeatureFlag, Object> featureFlags = {};

    // Define meetings options here
    var options = JitsiMeetingOptions(
      roomNameOrUrl: room_code,
      serverUrl: video_url,
      subject: subjectText.text,
      // token: tokenText.text,
      isAudioMuted: isAudioMuted,
      isAudioOnly: isAudioOnly,
      isVideoMuted: isVideoMuted,
      userDisplayName: nameText.text,
      userEmail: emailText.text,
      featureFlags: featureFlags,
    );

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeetWrapper.joinMeeting(
      options: options,
      listener: JitsiMeetingListener(
        onOpened: () => debugPrint("onOpened"),
        onConferenceWillJoin: (url) {
          debugPrint("onConferenceWillJoin: url: $url");
        },
        onConferenceJoined: (url) {
          debugPrint("onConferenceJoined: url: $url");
        },
        onConferenceTerminated: (url, error) {
          debugPrint("onConferenceTerminated: url: $url, error: $error");
        },
        onAudioMutedChanged: (isMuted) {
          debugPrint("onAudioMutedChanged: isMuted: $isMuted");
        },
        onVideoMutedChanged: (isMuted) {
          debugPrint("onVideoMutedChanged: isMuted: $isMuted");
        },
        onScreenShareToggled: (participantId, isSharing) {
          debugPrint(
            "onScreenShareToggled: participantId: $participantId, "
                "isSharing: $isSharing",
          );
        },
        onParticipantJoined: (email, name, role, participantId) {
          debugPrint(
            "onParticipantJoined: email: $email, name: $name, role: $role, "
                "participantId: $participantId",
          );
        },
        onParticipantLeft: (participantId) {
          debugPrint("onParticipantLeft: participantId: $participantId");
        },
        onParticipantsInfoRetrieved: (participantsInfo, requestId) {
          debugPrint(
            "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
                "requestId: $requestId",
          );
        },
        onChatMessageReceived: (senderId, message, isPrivate) {
          debugPrint(
            "onChatMessageReceived: senderId: $senderId, message: $message, "
                "isPrivate: $isPrivate",
          );
        },
        onChatToggled: (isOpen) => debugPrint("onChatToggled: isOpen: $isOpen"),
        onClosed: () => debugPrint("onClosed"),
      ),
    );
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

  void selectImages(int index, BuildContext context) async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);

      print("Image List:" + imageFileList![0].path.toString());
    }
    print("Image List Length:" + imageFileList!.length.toString());
    // setState(() {});
  }
}

class ExpandableUpload extends StatefulWidget {
  final int index;
  final List data;
  final List diseasesdata;

  ExpandableUpload(this.index, this.data, this.diseasesdata);

  @override
  State<ExpandableUpload> createState() => _ExpandableUploadState();
}

class _ExpandableUploadState extends State<ExpandableUpload> {
  final ImagePicker imagePicker = ImagePicker();

  // List<XFile>? imageFileList = [];
  List imageFileList = [];
  String? valueChoose;
  final descriptionText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    buildItem(String label) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(label),
      );
    }

    buildList() {
      return Column(
        children: [
          ListTile(
            title: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Text(
                      'Upload Prescription',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white),
                    ),
                    label: Icon(Icons.drive_folder_upload, size: 20),
                    onPressed: () =>
                    {
                      selectImages(widget.index, context),
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue[800],
                      elevation: 5,
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                // SizedBox(
                //   width: 10,
                // ),
                // Expanded(
                //   child: ElevatedButton.icon(
                //     icon: Text('Upload file',
                //       style: Theme
                //           .of(context)
                //           .textTheme
                //           .bodyText1!
                //           .copyWith(color: Colors.white),),
                //     label: Icon(Icons.upload_file, size: 20),
                //     onPressed: () =>
                //     {
                //       getPdfAndUpload(),
                //     },
                //     style: ElevatedButton.styleFrom(
                //       primary: Colors.lightBlue[800],
                //       elevation: 5,
                //       // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.lightBlue[800]!, // set border color
                    width: 1.5), // set border width
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)), // set rounded corner radius
              ),
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                // onChanged: (input) => requestModelRateDoctor.comments = input,
                controller: descriptionText,
                maxLines: null,
                decoration: InputDecoration(
                  // prefixIcon: Icon(
                  // Icons.phone_android,
                  // ),
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  hintText: 'Please add description...',
                  counterText: '',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue[800]!, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton(
                  hint: Text("Select disease"),
                  // dropdownColor: Colors.lightBlue[800]!,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 25,
                  isExpanded: true,
                  underline: SizedBox(),
                  style: (TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  )),
                  value: valueChoose,
                  onChanged: (newValue) {
                    setState(() {
                      valueChoose = newValue as String;
                    });
                  },
                  items: widget.diseasesdata.map((valueItem) {
                    print("widget.index: " + widget.index.toString());
                    for (int i = 0; i <= widget.diseasesdata.length; i++) {}
                    return DropdownMenuItem(
                        value: valueItem["id"],
                        child: Text(valueItem["title"]));
                  }).toList(),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          print("valueChoose: " +
                              imageFileList!.length.toString());

                          if (imageFileList!.length == 0) {
                            Fluttertoast.showToast(
                                msg: "Please select prescription",
                                toastLength: Toast.LENGTH_SHORT);
                          } else if (descriptionText.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please enter description",
                                toastLength: Toast.LENGTH_SHORT);
                          } else if (valueChoose == null) {
                            Fluttertoast.showToast(
                                msg: "Please select disease",
                                toastLength: Toast.LENGTH_SHORT);
                          } else {
                            showAlertDialog(context);

                            var uri = Uri.parse(baseURL.base_url +
                                'doctors_api/clinicbooking_upload_prescription');
                            var request = http.MultipartRequest('POST', uri);
                            for (int i = 0; i < imageFileList!.length; i++) {
                              request.files.add(
                                http.MultipartFile(
                                  'image[$i]',
                                  http.ByteStream(DelegatingStream.typed(
                                      imageFileList![i].openRead())),
                                  await imageFileList![i].length(),
                                  filename:
                                  Path.basename(imageFileList![i].path),
                                ),
                              );
                            }

                            request.fields['booking_id'] =
                            widget.data[widget.index]["id"];
                            request.fields['disease_id'] =
                                valueChoose.toString();
                            request.fields['description'] =
                                descriptionText.text;

                            var response = await request.send();
                            response.stream
                                .transform(utf8.decoder)
                                .listen((value) {
                              var jsonResponse = convert.jsonDecode(value)
                              as Map<String, dynamic>;
                              if (jsonResponse['status'] == "200") {
                                setState(() {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Fluttertoast.showToast(
                                      msg: "${jsonResponse['message']}",
                                      toastLength: Toast.LENGTH_SHORT);
                                  descriptionText.clear();
                                  imageFileList.clear();
                                });
                              } else {
                                setState(() {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Fluttertoast.showToast(
                                      msg: "${jsonResponse['message']}",
                                      toastLength: Toast.LENGTH_SHORT);
                                });
                              }
                            });
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue[800],
                          onPrimary: Colors.white,
                          elevation: 5,
                          padding: EdgeInsets.only(left: 40, right: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20), // <-- Radius
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          print("booking_id: " +
                              widget.data![widget.index]["id"]);
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(
                                          widget.data![widget.index]["id"],
                                          widget.data![widget
                                              .index]["userid"])));
                        },
                        child: Text(
                          'Chat',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue[800],
                          onPrimary: Colors.white,
                          elevation: 5,
                          padding: EdgeInsets.only(left: 40, right: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20), // <-- Radius
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ScrollOnExpand(
            child: Card(
              elevation: 5,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToExpand: true,
                      tapBodyToCollapse: true,
                      hasIcon: false,
                    ),
                    header: Center(
                      child: Container(
                        color: Colors.lightBlue[800],
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              ExpandableIcon(
                                theme: const ExpandableThemeData(
                                  expandIcon: Icons.arrow_right,
                                  collapseIcon: Icons.arrow_drop_down,
                                  iconColor: Colors.white,
                                  iconSize: 28.0,
                                  iconRotationAngle: math.pi / 2,
                                  iconPadding: EdgeInsets.only(right: 5),
                                  hasIcon: false,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Upload",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    collapsed: Container(),
                    expanded: buildList(),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void selectImages(int index, BuildContext context) async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);

      print("Image List:" + imageFileList![0].path.toString());
    }
    print("Image List Length:" + imageFileList!.length.toString());
    // setState(() {});
  }

  Future getPdfAndUpload() async {
    final pdfImageresult =
    await FilePicker.platform.pickFiles(allowMultiple: true);
    if (pdfImageresult == null) return;
    List<File> files = pdfImageresult.paths.map((path) => File(path!)).toList();
    imageFileList.addAll(files);
    print("imageFileList: " + imageFileList.toString());
  }
}
