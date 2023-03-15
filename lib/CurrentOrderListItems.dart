import 'dart:io';
import 'package:clinic_app/ChatScreen.dart';
import 'package:clinic_app/RescheduleWidget.dart';
import 'package:clinic_app/baseURL.dart';
import 'package:clinic_app/progressbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'AcceptModel.dart';
import 'CurrentBookingsResponseModel.dart';
import 'RejectModel.dart';

class CurrentOrderListItems extends StatefulWidget {
  const CurrentOrderListItems({Key? key}) : super(key: key);

  @override
  _CurrentOrderListItemsState createState() => _CurrentOrderListItemsState();
}

TextEditingController _textFieldController = TextEditingController();

class _CurrentOrderListItemsState extends State<CurrentOrderListItems> {
  var token = "";
  List? data;
  CurrentBookingsRequestModel currentBookingsRequestModel = new CurrentBookingsRequestModel(token: '');
  AcceptRequestModel acceptRequestModel = new AcceptRequestModel(token: '', booking_id: '', mode_of_consultation: '', consult_time: '');
  RejectRequestModel rejectRequestModel = new RejectRequestModel(token: '', booking_id: '');
  TimeOfDay selectedTime = TimeOfDay.now();

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
      print("token2: " + token);
      print("data: " + data.toString());
      getAllBookings(currentBookingsRequestModel);
    });
  }

  getAllBookings(CurrentBookingsRequestModel currentBookingsRequestModel) async {
    print("token1: " + token);
    currentBookingsRequestModel.token = token;
    showAlertDialog(context);
    // var currentBookingsResponseModel2 = null;

    var url = Uri.parse(baseURL.base_url + 'doctors_api/clinic_bookings');
    final response = await http.post(url, body: currentBookingsRequestModel.toJson());
    print("response current: " + response.body);
    // Fluttertoast.showToast(msg: "response: " + response.body, toastLength: Toast.LENGTH_SHORT);
    try {
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['status'] == "200") {
          Navigator.of(context, rootNavigator: true).pop();
          // currentBookingsResponseModel2 = CurrentBookingsResponseModel.fromJson(jsonResponse);
          setState(() {
            data = jsonResponse!['data'];
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 10, top: 10),
            primary: true,
            shrinkWrap: false,
            itemCount: data == null ? 0 : data!.length,
            itemBuilder: ((_, index) {
              return Container(
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
                            child: Text(data![index]["name"]==null ? "" : ": "+data![index]["name"],
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
                            child: Text(data![index]["address"]==null ? "" : ": "+data![index]["address"],
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
                            child: Text(data![index]["dob"]==null ? "" : ": "+data![index]["dob"],
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
                          Icon(data![index]["gender"] == "Male" ? Icons.male : Icons.female,color: Colors.lightBlue[800]!),
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
                            child: Text(data![index]["gender"]==null ? "" : ": "+data![index]["gender"],
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
                    ListTile(
                      title: Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (data![index]["mode_of_consultation"] ==
                                    "offline") {
                                  showAlertDialog(context);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  var token = prefs.getString('token');

                                  print("id: " + data![index]['id']);

                                  acceptRequestModel.token = token!;
                                  acceptRequestModel.booking_id = data![index]['id'];
                                  acceptRequestModel.mode_of_consultation = data![index]['mode_of_consultation'];
                                  // acceptRequestModel.consult_time = _textFieldController.text;

                                  var RoomEnterResponseModel = null;

                                  var url = Uri.parse(baseURL.base_url +
                                      'doctors_api/clinicbooking_accept_button');
                                  final response = await http.post(url,
                                      body: acceptRequestModel.toJson());
                                  print(
                                      "response timezone: " + response.body);
                                  try {
                                    if (response.statusCode == 200) {
                                      var jsonResponse =
                                          convert.jsonDecode(response.body)
                                              as Map<String, dynamic>;
                                      print("jsonResponse: " +
                                          jsonResponse['status']);
                                      if (jsonResponse['status'] == "200") {
                                        Fluttertoast.showToast(msg: "Accepted", toastLength: Toast.LENGTH_SHORT);
                                        Navigator.of(context, rootNavigator: true).pop();
                                        getAllBookings(currentBookingsRequestModel);
                                      } else if (jsonResponse['status'] ==
                                          "400") {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        // Fluttertoast.showToast( msg: "There is no timeslot in "+formattedDate.toString(), toastLength: Toast.LENGTH_SHORT);
                                      } else if (jsonResponse['status'] ==
                                          "404") {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        // Fluttertoast.showToast( msg: "Empty fields", toastLength: Toast.LENGTH_SHORT);
                                      } else {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
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
                                } else {
                                  // _displayDialog(context, index);
                                  _selectTime(context, index);
                                }
                              },
                              child: Text('Accept'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue[800],
                                elevation: 5,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RescheduleWidget(data![index]['id']),
                                  ),
                                );

                              },
                              child: Text('Reschedule'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue[800],
                                elevation: 5,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  _selectTime(BuildContext context, int index) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() async {
        String selTime = timeOfDay.hour.toString() + ':' + timeOfDay.minute.toString() + ':00';
        selTime = DateFormat.jm().format(DateFormat("hh:mm:ss").parse(selTime));
        print("timeeeeeeeeeeeeeeeeeeeeeeeeee: "+selTime.toString());

        showAlertDialog(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var token = prefs.getString('token');

        print("id: " + data![index]['id']);

        acceptRequestModel.token = token!;
        acceptRequestModel.booking_id = data![index]['id'];
        acceptRequestModel.mode_of_consultation = data![index]['mode_of_consultation'];
        // acceptRequestModel.consult_time = _textFieldController.text;
        acceptRequestModel.consult_time = selTime;

        var RoomEnterResponseModel = null;

        var url = Uri.parse(baseURL.base_url + 'doctors_api/clinicbooking_accept_button');
        final response = await http.post(url, body: acceptRequestModel.toJson());
        print("response timezone: " + response.body);
        try {
          if (response.statusCode == 200) {
            var jsonResponse = convert.jsonDecode(response.body)
            as Map<String, dynamic>;
            print("jsonResponse: " + jsonResponse['status']);
            if (jsonResponse['status'] == "200") {
              Fluttertoast.showToast(msg: "Accepted", toastLength: Toast.LENGTH_SHORT);
              Navigator.of(context, rootNavigator: true).pop();
              getAllBookings(currentBookingsRequestModel);
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
      });
    }
  }

  // _displayDialog(BuildContext context, int index) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(
  //             'Consultation Time',
  //             style: TextStyle(
  //               color: Colors.lightBlue[800],
  //               fontSize: 17,
  //             ),
  //           ),
  //           content: TextField(
  //             style: TextStyle(
  //               color: Colors.lightBlue[800],
  //             ),
  //             controller: _textFieldController,
  //             decoration: InputDecoration(
  //               hintText: "eg: 10:00am - 11:00am",
  //               hintStyle: TextStyle(
  //                 fontSize: 12,
  //                 color: Colors.lightBlue[800],
  //               ),
  //               enabledBorder: UnderlineInputBorder(
  //                 borderSide: BorderSide(color: Colors.lightBlue[800]!),
  //               ),
  //               focusedBorder: UnderlineInputBorder(
  //                 borderSide: BorderSide(color: Colors.lightBlue[800]!),
  //               ),
  //             ),
  //           ),
  //           actions: <Widget>[
  //             new FlatButton(
  //               child: new Text(
  //                 'SUBMIT',
  //                 style: TextStyle(
  //                   color: Colors.lightBlue[800],
  //                 ),
  //               ),
  //               onPressed: () async {
  //                 showAlertDialog(context);
  //                 SharedPreferences prefs =
  //                     await SharedPreferences.getInstance();
  //                 var token = prefs.getString('token');
  //
  //                 print("id: " + data![index]['id']);
  //
  //                 acceptRequestModel.token = token!;
  //                 acceptRequestModel.booking_id = data![index]['id'];
  //                 acceptRequestModel.mode_of_consultation =
  //                     data![index]['mode_of_consultation'];
  //                 acceptRequestModel.consult_time = _textFieldController.text;
  //
  //                 var RoomEnterResponseModel = null;
  //
  //                 var url = Uri.parse(baseURL.base_url +
  //                     'doctors_api/clinicbooking_accept_button');
  //                 final response =
  //                     await http.post(url, body: acceptRequestModel.toJson());
  //                 print("response timezone: " + response.body);
  //                 try {
  //                   if (response.statusCode == 200) {
  //                     var jsonResponse = convert.jsonDecode(response.body)
  //                         as Map<String, dynamic>;
  //                     print("jsonResponse: " + jsonResponse['status']);
  //                     if (jsonResponse['status'] == "200") {
  //                       Fluttertoast.showToast(
  //                           msg: "Accepted", toastLength: Toast.LENGTH_SHORT);
  //                       Navigator.of(context, rootNavigator: true).pop();
  //                       Navigator.of(context, rootNavigator: true).pop();
  //                       getAllBookings(currentBookingsRequestModel);
  //                     } else if (jsonResponse['status'] == "400") {
  //                       Navigator.of(context, rootNavigator: true).pop();
  //                       // Fluttertoast.showToast( msg: "There is no timeslot in "+formattedDate.toString(), toastLength: Toast.LENGTH_SHORT);
  //                     } else if (jsonResponse['status'] == "404") {
  //                       Navigator.of(context, rootNavigator: true).pop();
  //                       // Fluttertoast.showToast( msg: "Empty fields", toastLength: Toast.LENGTH_SHORT);
  //                     } else {
  //                       Navigator.of(context, rootNavigator: true).pop();
  //                     }
  //                   }
  //                 } on SocketException {
  //                   print('No Internet connection');
  //                   print(SocketException);
  //                 } on HttpException {
  //                   print("Couldn't find the post");
  //                   print(HttpException);
  //                 } on FormatException {
  //                   print("Bad response format");
  //                   print(FormatException);
  //                 } catch (Exception) {
  //                   return RoomEnterResponseModel;
  //                 }
  //                 return RoomEnterResponseModel;
  //                 // {
  //                 //   throw Exception(
  //                 //       Get.showSnackbar(Ui.ErrorSnackBar(message: 'API Failed'.tr)),
  //                 //   );
  //                 // }
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
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
