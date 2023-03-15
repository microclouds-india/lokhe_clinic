import 'dart:io';
import 'package:clinic_app/baseURL.dart';
import 'package:clinic_app/progressbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

import 'RejectedBookingsResponseModel.dart';

class RejectedOrderListItems extends StatefulWidget {
  const RejectedOrderListItems({Key? key}) : super(key: key);

  @override
  _RejectedOrderListItemsState createState() => _RejectedOrderListItemsState();
}

TextEditingController _textFieldController = TextEditingController();

class _RejectedOrderListItemsState extends State<RejectedOrderListItems> {

  var token = "";
  List? data;
  RejectedBookingsRequestModel rejectedBookingsRequestModel = new RejectedBookingsRequestModel(token: '');

  @override
  void initState()  {
    getValidationData().whenComplete(() async {});
    super.initState();
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token2 = sharedPreferences.getString('token');
    setState(() {
      token = token2!;
      getAllBookings(rejectedBookingsRequestModel);
    });
  }

  getAllBookings(RejectedBookingsRequestModel rejectedBookingsRequestModel2) async {

    rejectedBookingsRequestModel.token = token;
    showAlertDialog(context);
    // var currentBookingsResponseModel2 = null;

    var url =Uri.parse(baseURL.base_url+'doctors_api/clinic_bookings_rejected');
    final response = await http.post(url, body:rejectedBookingsRequestModel2.toJson());
    print("response timezone: " + response.body);
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

    }on SocketException {
      print('No Internet connection');
      print(SocketException);
    }
    // return currentBookingsResponseModel2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Booked doctors history",
      //     style: TextStyle(color: Colors.white),
      //     // style: Get.textTheme.headline6,
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.lightBlue[800],
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      // ),
      body: Container(
        color: Colors.grey[100],
        // color: Colors.white,
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: true,
          shrinkWrap: false,
          itemCount: data == null ? 0 : data!.length,
          itemBuilder: ((_, index) {
            return GestureDetector(
              onTap: () {
                print("Container clicked 1");
              },
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => HomePage()),
                  // );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
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
                        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                        child: Text("Name: " + data![index]["name"]),
                      ),
                      // Container(
                      //   margin:
                      //   EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      //   child: Text(
                      //     "Gender: " + data![index]["date_time"],
                      //     style: TextStyle(color: Colors.grey, fontSize: 13),
                      //   ),
                      // ),
                      Container(
                        margin:
                        EdgeInsets.only(bottom: 10, left: 10, right: 10),
                        child: Text(
                          "Address: " + data![index]["address"],
                          textAlign: TextAlign.justify,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                      Container(
                        margin:
                        EdgeInsets.only(bottom: 10, left: 10, right: 10),
                        child: Text(
                          "Mode of consultation: " + data![index]["mode_of_consultation"],
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                      Container(
                        margin:
                        EdgeInsets.only(bottom: 10, left: 10, right: 10),
                        child: Text(
                          "Date: " + data![index]["date_time"],
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                      Container(
                        margin:
                        EdgeInsets.only(bottom: 10, left: 10, right: 10),
                        child: Text(
                          "Time: " + data![index]["Timeslot"],
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                      Container(
                        margin:
                        EdgeInsets.only(bottom: 10, left: 10, right: 10),
                        child: Text(
                          "Payment status: " + data![index]["payment_status"],
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),

                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                onPressed: () async {

                                  _displayDialog(context, index);

                                },
                                elevation: 5,
                                child: Text("Reschedule"),
                                color: Colors.lightBlue[800],
                                textColor: Colors.white,
                                padding: EdgeInsets.only(left: 20, right: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }


  _displayDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Rescheduling Time',
              style: TextStyle(
                color: Colors.lightBlue[800],
                fontSize: 17,
              ),
            ),
            content: TextField(
              style: TextStyle(
                color: Colors.lightBlue[800],
              ),
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: "eg: 10:00am - 11:00am",
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.lightBlue[800],
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue[800]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue[800]!),
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  'SUBMIT',
                  style: TextStyle(
                    color: Colors.lightBlue[800],
                  ),
                ),
                onPressed: () async {

                  // showAlertDialog(context);
                  // SharedPreferences prefs = await SharedPreferences.getInstance();
                  // var token = prefs.getString('token');
                  //
                  // acceptRequestModel.token = token!;
                  // acceptRequestModel.booking_id = data![index]['id'];
                  //
                  // var url =Uri.parse(baseURL.base_url+'doctors_api/clinicbooking_accept_button');
                  // final response = await http.post(url, body:acceptRequestModel.toJson());
                  // print("response timezone: " + response.body);
                  // try {
                  //   if (response.statusCode == 200) {
                  //     var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
                  //     print("jsonResponse: " + jsonResponse['status']);
                  //     if (jsonResponse['status'] == "200") {
                  //       Fluttertoast.showToast( msg: "Accepted", toastLength: Toast.LENGTH_SHORT);
                  //       Navigator.of(context, rootNavigator: true).pop();
                  //       Navigator.of(context, rootNavigator: true).pop();
                  //       getAllBookings(currentBookingsRequestModel);
                  //     } else if (jsonResponse['status'] == "400") {
                  //       Navigator.of(context, rootNavigator: true).pop();
                  //       // Fluttertoast.showToast( msg: "There is no timeslot in "+formattedDate.toString(), toastLength: Toast.LENGTH_SHORT);
                  //     } else if (jsonResponse['status'] == "404") {
                  //       Navigator.of(context, rootNavigator: true).pop();
                  //       // Fluttertoast.showToast( msg: "Empty fields", toastLength: Toast.LENGTH_SHORT);
                  //     } else {
                  //       Navigator.of(context, rootNavigator: true).pop();
                  //     }
                  //   }
                  //
                  // }on SocketException {
                  //   print('No Internet connection');
                  //   print(SocketException);
                  // } on HttpException {
                  //   print("Couldn't find the post");
                  //   print(HttpException);
                  // } on FormatException {
                  //   print("Bad response format");
                  //   print(FormatException);
                  // } catch(Exception){
                  //   return RoomEnterResponseModel;
                  // }
                  // return RoomEnterResponseModel;

                },
              )
            ],
          );
        });
  }
}
