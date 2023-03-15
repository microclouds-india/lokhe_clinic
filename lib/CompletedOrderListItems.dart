import 'dart:io';
import 'package:clinic_app/baseURL.dart';
import 'package:clinic_app/progressbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'AcceptedBookingsResponseModel.dart';
import 'BookingHistory.dart';
import 'CompletedBookingsResponseModel.dart';
import 'RejectedBookingsResponseModel.dart';

class CompletedOrderListItems extends StatefulWidget {
  const CompletedOrderListItems({Key? key}) : super(key: key);

  @override
  _CompletedOrderListItemsState createState() => _CompletedOrderListItemsState();
}

TextEditingController _textFieldController = TextEditingController();

class _CompletedOrderListItemsState extends State<CompletedOrderListItems> {

  var token = "";
  List? data;
  CompletedBookingsRequestModel completedBookingsRequestModel = new CompletedBookingsRequestModel(token: '');

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
      getAllBookings(completedBookingsRequestModel);
    });
  }

  getAllBookings(CompletedBookingsRequestModel completedBookingsRequestModel2) async {

    completedBookingsRequestModel.token = token;
    showAlertDialog(context);
    // var currentBookingsResponseModel2 = null;

    var url =Uri.parse(baseURL.base_url+'doctors_api/clinic_bookings_completed');
    final response = await http.post(url, body:completedBookingsRequestModel2.toJson());
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 10, top: 10),
            primary: true,
            shrinkWrap: false,
            itemCount: data == null ? 0 : data!.length,
            itemBuilder: ((_, index) {
              return Container(
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
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ElevatedButton.icon(
                          icon: Text('History',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),),
                          label: Icon(Icons.history, size: 20),
                          onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingHistory(id: data![index]["id"].toString(),),
                                )),
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue[800],
                            elevation: 5,
                            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
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
