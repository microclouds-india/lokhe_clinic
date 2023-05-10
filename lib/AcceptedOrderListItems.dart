import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:clinic_app/BookingHistory.dart';
import 'package:clinic_app/UploadImageModel.dart';
import 'package:clinic_app/baseURL.dart';
import 'package:clinic_app/progressbar.dart';
import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'AcceptedBookingsResponseModel.dart';
import 'AcceptedDetails.dart';
import 'ChatScreen.dart';
import 'CompletedBookingModel.dart';
import 'RoomEnterModel.dart';
import 'dart:math' as math;
import 'package:path/path.dart' as Path;


class AcceptedOrderListItems extends StatefulWidget {
  const AcceptedOrderListItems({Key? key}) : super(key: key);

  @override
  _AcceptedOrderListItemsState createState() => _AcceptedOrderListItemsState();
}

TextEditingController _textFieldController = TextEditingController();

class _AcceptedOrderListItemsState extends State<AcceptedOrderListItems> {
  var token = "";
  List? data;
  List? diseasesdata;

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  AcceptedBookingsRequestModel acceptedBookingsRequestModel = new AcceptedBookingsRequestModel(
      token: '');
  RoomEnterRequestModel requestModelRoomEnter = new RoomEnterRequestModel(
      token: '', booking_id: '');
  CompletedBookingRequestModel completedBookingRequestModel = new CompletedBookingRequestModel(
      booking_id: '');
  UploadImageRequestModel uploadImageRequestModel = new UploadImageRequestModel(
      token: '', booking_id: '', image: '');

  final serverText = TextEditingController(text: "https://meet.jit.si/");

  // final serverText = TextEditingController(text: "https://jitsi.tatoobooks.com/");
  final roomText = TextEditingController(text: "plugintestroom");
  final subjectText = TextEditingController(text: "My Plugin Test Meeting");
  final nameText = TextEditingController(text: "Plugin Test User");
  final emailText = TextEditingController(text: "fake@email.com");
  final iosAppBarRGBAColor = TextEditingController(
      text: "#0080FF80"); //transparent blue
  bool isAudioOnly = true;
  bool isAudioMuted = true;
  bool isVideoMuted = true;

  @override
  void initState() {
    getValidationData().whenComplete(() async {});
    super.initState();
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    var token2 = sharedPreferences.getString('token');
    setState(() {
      token = token2!;
      getAllBookings(acceptedBookingsRequestModel);
      getDiseases();
    });
  }

  getAllBookings(
      AcceptedBookingsRequestModel acceptedBookingsRequestModel2) async {
    acceptedBookingsRequestModel.token = token;
    showAlertDialog(context);
    // var currentBookingsResponseModel2 = null;

    var url =
    Uri.parse(baseURL.base_url + 'doctors_api/clinic_bookings_accepted');
    final response =
    await http.post(url, body: acceptedBookingsRequestModel2.toJson());
    print("response timezone: " + response.body);
    // Fluttertoast.showToast(msg: "response: " + response.body, toastLength: Toast.LENGTH_SHORT);
    try {
      if (response.statusCode == 200) {
        var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['status'] == "200") {
          Navigator.of(context, rootNavigator: true).pop();
          // currentBookingsResponseModel2 = CurrentBookingsResponseModel.fromJson(jsonResponse);
          setState(() {
            data = jsonResponse!['data'];
            print("dataItemmmmmmmmmmmmmm" + data.toString());
            // for (int i = 0; i < listResponse!.length; i++) {
            //   speciality = listResponse![i]['speciality'];
            // }
          });
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
    }
    // return currentBookingsResponseModel2;
  }

  getDiseases() async {
    showAlertDialog(context);

    var url = Uri.parse(baseURL.base_url + 'doctors_api/diseases');
    final response = await http.get(url);
    print("responsessssssssss: " + response.body);
    try {
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body) as Map<
            String,
            dynamic>;
        if (jsonResponse['status'] == "200") {
          Navigator.of(context, rootNavigator: true).pop();
          setState(() {
            diseasesdata = jsonResponse!['data'];
            // for(int i=0; i <= jsonResponse['data'].toString().length; i++){
            //   diseasesdata![i].title = jsonResponse['data'][i]['title'];
            print("listItemmmmmmmmmmmmmm" + diseasesdata.toString());
            // }
          });
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 10, top: 10),
            primary: true,
            shrinkWrap: false,
            itemCount: data == null ? 0 : data!.length,
            itemBuilder: ((_, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AcceptedDetail(index: index,data: data!, diseasesdata: diseasesdata!)),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
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
                              child: Text(data![index]["name"]==null ? "" : ": "+data![index]["name"],
                                  style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Icon(Icons.place_outlined,color: Colors.lightBlue[800]!),
                      //       Container(
                      //         margin: EdgeInsets.symmetric(horizontal: 12),
                      //         width: 1,
                      //         height: 24,
                      //         color: Colors.lightBlue[800]!,
                      //       ),
                      //       Expanded(
                      //         child: Text(
                      //             "Address ".tr,
                      //             style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      //         ),
                      //       ),
                      //       Flexible(
                      //         child: Text(data![index]["address"]==null ? "" : ": "+data![index]["address"],
                      //             style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Icon(Icons.calendar_month_outlined,color: Colors.lightBlue[800]!),
                      //       Container(
                      //         margin: EdgeInsets.symmetric(horizontal: 12),
                      //         width: 1,
                      //         height: 24,
                      //         color: Colors.lightBlue[800]!,
                      //       ),
                      //       Expanded(
                      //         child: Text(
                      //             "Date of Birth ".tr,
                      //             style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      //         ),
                      //       ),
                      //       Flexible(
                      //         child: Text(data![index]["dob"]==null ? "" : ": "+data![index]["dob"],
                      //             style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Icon(data![index]["gender"] == "Male" ? Icons.male : Icons.female,color: Colors.lightBlue[800]!),
                      //       Container(
                      //         margin: EdgeInsets.symmetric(horizontal: 12),
                      //         width: 1,
                      //         height: 24,
                      //         color: Colors.lightBlue[800]!,
                      //       ),
                      //       Expanded(
                      //         child: Text(
                      //             "Gender ".tr,
                      //             style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      //         ),
                      //       ),
                      //       Flexible(
                      //         child: Text(data![index]["gender"]==null ? "" : ": "+data![index]["gender"],
                      //             style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
                              child: Text(data![index]["mode_of_consultation"]==null ? "" : ": "+data![index]["mode_of_consultation"],
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
                              child: Text(data![index]["date_time"]==null ? "" : ": "+data![index]["date_time"],
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
                              child: Text(data![index]["Timeslot"]==null ? "" : ": "+data![index]["Timeslot"],
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
                              child: Text(data![index]["payment_status"]==null ? "" : ": "+data![index]["payment_status"],
                                  style: TextStyle(color: Colors.lightBlue[800], fontSize: 13)
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ListTile(
                      //   title: Row(
                      //     children: <Widget>[
                      //       Expanded(
                      //         child: ElevatedButton(
                      //           onPressed: () async {
                      //             // Navigator.push(
                      //             //   context,
                      //             //   MaterialPageRoute(
                      //             //       builder: (context) => HomePage()),
                      //             // );
                      //
                      //             showAlertDialog(context);
                      //             SharedPreferences prefs =
                      //             await SharedPreferences.getInstance();
                      //             var token = prefs.getString('token');
                      //
                      //             requestModelRoomEnter.token = token!;
                      //             requestModelRoomEnter.booking_id =
                      //             data![index]["id"];
                      //
                      //             var RoomEnterResponseModel = null;
                      //
                      //             var url = Uri.parse(baseURL.base_url +
                      //                 'doctors_api/generate_roomcode');
                      //             final response = await http.post(
                      //                 url, body: requestModelRoomEnter.toJson());
                      //             print("response timezone: " + response.body);
                      //             // Fluttertoast.showToast(msg: "response: " + response.body, toastLength: Toast.LENGTH_SHORT);
                      //             try {
                      //               if (response.statusCode == 200) {
                      //                 var jsonResponse = convert.jsonDecode(
                      //                     response.body) as Map<String, dynamic>;
                      //                 if (jsonResponse['status'] == "200") {
                      //                   Navigator.of(context, rootNavigator: true)
                      //                       .pop();
                      //                   // RoomEnterResponseModel = RoomEnterModel.fromJson(jsonResponse);
                      //                   if (jsonResponse['room_code'] ==
                      //                       "No Roomcode") {
                      //                     Fluttertoast.showToast(
                      //                         msg:
                      //                         "You can enter the room only in " +
                      //                             jsonResponse[
                      //                             'booking_date'] +
                      //                             " at " +
                      //                             jsonResponse['avail_time'] +
                      //                             "",
                      //                         toastLength: Toast.LENGTH_SHORT);
                      //                     // Get.showSnackbar(Ui.RoomCodeSnackBar(message: "You can enter the room only in "+jsonResponse['booking_date']+" at "+jsonResponse['avail_time']+""));
                      //                   } else {
                      //                     JitsiMeet.addListener(
                      //                         JitsiMeetingListener(
                      //                             onConferenceWillJoin:
                      //                             _onConferenceWillJoin,
                      //                             onConferenceJoined:
                      //                             _onConferenceJoined,
                      //                             onConferenceTerminated:
                      //                             _onConferenceTerminated,
                      //                             onError: _onError));
                      //                     _joinMeeting(jsonResponse['room_code']);
                      //                   }
                      //                 } else if (jsonResponse['status'] ==
                      //                     "400") {
                      //                   Navigator.of(context, rootNavigator: true)
                      //                       .pop();
                      //                   // Fluttertoast.showToast( msg: "There is no timeslot in "+formattedDate.toString(), toastLength: Toast.LENGTH_SHORT);
                      //                 } else if (jsonResponse['status'] ==
                      //                     "404") {
                      //                   Navigator.of(context, rootNavigator: true)
                      //                       .pop();
                      //                   // Fluttertoast.showToast( msg: "Empty fields", toastLength: Toast.LENGTH_SHORT);
                      //                 } else {
                      //                   Navigator.of(context, rootNavigator: true)
                      //                       .pop();
                      //                 }
                      //               }
                      //             } on SocketException {
                      //               print('No Internet connection');
                      //               print(SocketException);
                      //             } on HttpException {
                      //               print("Couldn't find the post");
                      //               print(HttpException);
                      //             } on FormatException {
                      //               print("Bad response format");
                      //               print(FormatException);
                      //             } catch (Exception) {
                      //               return RoomEnterResponseModel;
                      //             }
                      //             return RoomEnterResponseModel;
                      //             // {
                      //             //   throw Exception(
                      //             //       Get.showSnackbar(Ui.ErrorSnackBar(message: 'API Failed'.tr)),
                      //             //   );
                      //             // }
                      //           },
                      //           child: Text('Join Meeting'),
                      //           style: ElevatedButton.styleFrom(
                      //             primary: Colors.lightBlue[800],
                      //             elevation: 5,
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(20)),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: 10,
                      //       ),
                      //       Expanded(
                      //         child: ElevatedButton(
                      //           onPressed: () async {
                      //             // Navigator.push(
                      //             //   context,
                      //             //   MaterialPageRoute(
                      //             //       builder: (context) => HomePage()),
                      //             // );
                      //
                      //             showAlertDialog(context);
                      //             SharedPreferences prefs =
                      //             await SharedPreferences.getInstance();
                      //             var token = prefs.getString('token');
                      //
                      //             // completedBookingRequestModel.token = token!;
                      //             completedBookingRequestModel.booking_id =
                      //             data![index]["id"];
                      //
                      //             var RoomEnterResponseModel = null;
                      //
                      //             var url = Uri.parse(baseURL.base_url +
                      //                 'doctors_api/clinicbooking_complete_button');
                      //             final response = await http.post(url,
                      //                 body: completedBookingRequestModel
                      //                     .toJson());
                      //             print("response timezone: " + response.body);
                      //             // Fluttertoast.showToast(msg: "response: " + response.body, toastLength: Toast.LENGTH_SHORT);
                      //             try {
                      //               if (response.statusCode == 200) {
                      //                 var jsonResponse = convert.jsonDecode(
                      //                     response.body) as Map<String, dynamic>;
                      //                 if (jsonResponse['status'] == "200") {
                      //                   Navigator.of(context, rootNavigator: true).pop();
                      //                   getAllBookings(acceptedBookingsRequestModel);
                      //                 } else
                      //                 if (jsonResponse['status'] == "400") {
                      //                   Navigator.of(context, rootNavigator: true)
                      //                       .pop();
                      //                   // Fluttertoast.showToast( msg: "There is no timeslot in "+formattedDate.toString(), toastLength: Toast.LENGTH_SHORT);
                      //                 } else if (jsonResponse['status'] ==
                      //                     "404") {
                      //                   Navigator.of(context, rootNavigator: true)
                      //                       .pop();
                      //                   // Fluttertoast.showToast( msg: "Empty fields", toastLength: Toast.LENGTH_SHORT);
                      //                 } else {
                      //                   Navigator.of(context, rootNavigator: true)
                      //                       .pop();
                      //                 }
                      //               }
                      //             } on SocketException {
                      //               print('No Internet connection');
                      //               print(SocketException);
                      //             } on HttpException {
                      //               print("Couldn't find the post");
                      //               print(HttpException);
                      //             } on FormatException {
                      //               print("Bad response format");
                      //               print(FormatException);
                      //             } catch (Exception) {
                      //               return RoomEnterResponseModel;
                      //             }
                      //             return RoomEnterResponseModel;
                      //             // {
                      //             //   throw Exception(
                      //             //       Get.showSnackbar(Ui.ErrorSnackBar(message: 'API Failed'.tr)),
                      //             //   );
                      //             // }
                      //           },
                      //           child: Text('Complete meeting'),
                      //           style: ElevatedButton.styleFrom(
                      //             primary: Colors.lightBlue[800],
                      //             elevation: 5,
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(20)),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // if(diseasesdata != null)
                        // ExpandableUpload(index, data!, diseasesdata!),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // _joinMeeting(String room_code) async {
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
  //     ..serverURL = serverText.text
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

  // void _onConferenceWillJoin(message) {
  //   debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  // }
  //
  // void _onConferenceJoined(message) {
  //   debugPrint("_onConferenceJoined broadcasted with message: $message");
  // }
  //
  // void _onConferenceTerminated(message) {
  //   debugPrint("_onConferenceTerminated broadcasted with message: $message");
  // }
  //
  // _onError(error) {
  //   debugPrint("_onError broadcasted: $error");
  // }

  void selectImages(int index) async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);

      print("Image List:" + imageFileList![0].path.toString());
    }
    print("Image List Length:" + imageFileList!.length.toString());
    setState(() {});
  }


  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('Do you want to exit?',
          style: TextStyle(
            color: Colors.lightBlue[800],
            fontSize: 15,
          ),),
        // content: new Text('Do you want to exit?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }
}

