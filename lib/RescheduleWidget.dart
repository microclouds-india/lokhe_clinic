import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:clinic_app/ReschduleSubmitModel.dart';
import 'package:clinic_app/baseURL.dart';
import 'package:clinic_app/progressbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BlockButtonWidget.dart';
import 'TimeslotModel.dart';
import 'Ui.dart';

class RescheduleWidget extends StatefulWidget {
  final String id;

  const RescheduleWidget(this.id);

  @override
  _RescheduleWidgetState createState() => _RescheduleWidgetState();
}

class _RescheduleWidgetState extends State<RescheduleWidget> {
  int _groupValue = -1;
  DateTime selectedDate = DateTime.now();
  String pressedValue = "-1";
  String pressedValue2 = "-1";
  String pressedValue2_id = "-1";
  String timeSlotClicked = "-1";
  var token;
  final double horizontalPadding = 0.0;

  DateTime selectedDateDatepicker = DateTime.now();
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void onInit() {
    // super.onInit();
  }

  @override
  void initState() {
    // TODO: implement initState
    getValidationData().whenComplete(() async {});
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var token2 = sharedPreferences.getString('token');
    setState(() {
      token = token2;
    });
  }

  TimeslotRequestModel requestModeltimeslot =
      new TimeslotRequestModel(token: '', date: '');
  RescheduleSubmitRequestModel rescheduleSubmitRequestModel =
      new RescheduleSubmitRequestModel(
          token: '',
          consult_time: '',
          date: '',
          timeslot_id: '',
          booking_id: '');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Reschedule".tr,
            // style: context.textTheme.headline6,
            style: TextStyle(
              color: Colors.lightBlue[800],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Colors.lightBlue[800]),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          elevation: 0,
        ),
        // bottomNavigationBar: buildBlockButtonWidget(controller.booking.value),
        bottomNavigationBar: buildBlockButtonWidget(),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding ?? 20, vertical: 10),
                  decoration: Ui.getBoxDecoration(),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Center(
                          child: Text(
                            "Select day".tr,
                            // style: Get.textTheme?.headline6,
                            style: TextStyle(
                              color: Colors.lightBlue[800],
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDateDatePicker(context),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue[800],
                        ),
                        child: Text(
                          "   Set Date   ".tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme?.headline1?.merge(
                            TextStyle(
                                color: Get.theme?.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "${formattedDate}".split(' ')[0],
                        // style: Get.textTheme?.subtitle2,
                        style: TextStyle(
                          color: Colors.lightBlue[800],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding ?? 20, vertical: 10),
                  decoration: Ui.getBoxDecoration(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Select timeslot',
                        // style: Get.textTheme?.headline6,
                        style: TextStyle(
                          color: Colors.lightBlue[800],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      timeSlotClicked != "-1"
                          ? Container(
                              child: Center(
                                child: FutureBuilder<TimeslotResponseModel>(
                                    future: getTimeslot(requestModeltimeslot),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        print(snapshot.data!.data);
                                        // Fluttertoast.showToast(msg: "data: " + snapshot.data.data.toString(), toastLength: Toast.LENGTH_SHORT);
                                        // return ListView.builder(itemBuilder: (context, index){
                                        return GridView.count(
                                          shrinkWrap: true,
                                          crossAxisCount: 2,
                                          childAspectRatio: 2.5,
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: 0,
                                          physics: ScrollPhysics(),
                                          children: List.generate(
                                              snapshot.data!.data.length,
                                              (index) {
                                            // children: List.generate(30, (index) {
                                            return Center(
                                              child: OutlinedButton(
                                                child: Text(
                                                  // '$index am to $index am',
                                                  snapshot.data!.data[index]
                                                              .timeslotName !=
                                                          null
                                                      ? snapshot
                                                          .data!
                                                          .data[index]
                                                          .timeslotName
                                                          .tr
                                                      : '9 am to 10 am',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: pressedValue2 ==
                                                            snapshot
                                                                .data!
                                                                .data[index]
                                                                .timeslotName
                                                                .toString()
                                                        ? Colors.white
                                                        : snapshot
                                                                    .data!
                                                                    .data[index]
                                                                    .status ==
                                                                "0"
                                                            ? Colors.grey[400]
                                                            : Colors
                                                                .lightBlue[800],
                                                  ),
                                                  // ),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  shape: StadiumBorder(),
                                                  // backgroundColor: pressedValue2 == snapshot.data.data[index].timeslotName.toString() ? Get.theme.accentColor.withOpacity(0.3) : Colors.grey[200],
                                                  backgroundColor: pressedValue2 ==
                                                              snapshot
                                                                  .data!
                                                                  .data[index]
                                                                  .timeslotName
                                                                  .toString() &&
                                                          snapshot
                                                                  .data!
                                                                  .data[index]
                                                                  .status !=
                                                              "0"
                                                      ? Colors.lightBlue[800]
                                                      : snapshot
                                                                  .data!
                                                                  .data[index]
                                                                  .status ==
                                                              "0"
                                                          ? Colors.grey[100]
                                                          : Get.theme
                                                              ?.accentColor
                                                              .withOpacity(0.1),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (pressedValue2 ==
                                                        snapshot
                                                            .data!
                                                            .data[index]
                                                            .timeslotName
                                                            .toString()) {
                                                      pressedValue2 = "-1";
                                                    } else if (pressedValue2 !=
                                                            snapshot
                                                                .data!
                                                                .data[index]
                                                                .timeslotName
                                                                .toString() &&
                                                        snapshot
                                                                .data!
                                                                .data[index]
                                                                .status !=
                                                            "0") {
                                                      pressedValue2 = snapshot
                                                          .data!
                                                          .data[index]
                                                          .timeslotName
                                                          .toString();
                                                      pressedValue2_id =
                                                          snapshot.data!
                                                              .data[index].id
                                                              .toString();
                                                      // Fluttertoast.showToast(msg: "data: " + pressedValue2.toString(), toastLength: Toast.LENGTH_SHORT);
                                                    }
                                                  });
                                                },
                                              ),
                                            );
                                          }),
                                        );
                                        // });
                                      } else {
                                        return Center(
                                            // child: CircularProgressIndicator()
                                            );
                                      }
                                    }),
                              ),
                            )
                          : Center(child: Container()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBlockButtonWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Get.theme?.primaryColor,
        // color: Colors.lightBlue[800],
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.lightBlue[800]!.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5)),
        ],
      ),
      child: BlockButtonWidget(
        text: Text(
          "Submit".tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
          // style: Get.textTheme?.headline6?.merge(
          //   TextStyle(color: Colors.lightBlue[800],),
          // ),
        ),
        // color: Get.theme!.accentColor,
        color: Colors.lightBlue[800]!,
        onPressed: () async {
          if (pressedValue2 == "-1") {
            Fluttertoast.showToast(
                msg: "Please select time", toastLength: Toast.LENGTH_SHORT);
          } else {
            showAlertDialog(context);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var token = prefs.getString('token');

            rescheduleSubmitRequestModel.token = token!;
            rescheduleSubmitRequestModel.date = formattedDate;
            rescheduleSubmitRequestModel.consult_time = pressedValue2;
            rescheduleSubmitRequestModel.timeslot_id = pressedValue2_id;
            rescheduleSubmitRequestModel.booking_id = widget.id;

            print("formattedDate: " + formattedDate.toString());
            print("pressedValue2: " + pressedValue2.toString());
            print("pressedValue2_id: " + pressedValue2_id.toString());
            print("widget.id: " + widget.id.toString());

            var url =
                Uri.parse(baseURL.base_url + 'doctors_api/reschedule_button');
            final response = await http.post(url,
                body: rescheduleSubmitRequestModel.toJson());
            try {
              if (response.statusCode == 200) {
                var jsonResponse =
                    convert.jsonDecode(response.body) as Map<String, dynamic>;
                print("jsonResponse: " + jsonResponse['status']);
                if (jsonResponse['status'] == "200") {
                  Navigator.of(context, rootNavigator: true).pop();
                  Fluttertoast.showToast(msg: "Success", toastLength: Toast.LENGTH_SHORT);
                  Navigator.pop(context);
                } else if (jsonResponse['status'] == "400") {
                  Navigator.of(context, rootNavigator: true).pop();
                  // Fluttertoast.showToast( msg: "There is no timeslot in "+formattedDate.toString(), toastLength: Toast.LENGTH_SHORT);
                } else if (jsonResponse['status'] == "404") {
                  Navigator.of(context, rootNavigator: true).pop();
                  Fluttertoast.showToast(
                      msg: "Empty fields", toastLength: Toast.LENGTH_SHORT);
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
              // return RoomEnterResponseModel;
            }
            // return RoomEnterResponseModel;
          }
        },
      ).paddingOnly(right: 20, left: 20),
    );
  }

  Future<void> _selectDateDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateDatepicker,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 7)));
    if (picked != null && picked != selectedDateDatepicker)
      setState(() {
        selectedDateDatepicker = picked;
        String Onlydate =
            new DateFormat("dd-MM-yyyy").format(selectedDateDatepicker);
        formattedDate = Onlydate;

        print("Reschedule date: " + formattedDate.toString());

        if (timeSlotClicked != formattedDate.toString()) {
          timeSlotClicked = formattedDate.toString();
          requestModeltimeslot.token = token;
          requestModeltimeslot.date = formattedDate;
          pressedValue2 = "-1";
        } else {
          timeSlotClicked = "-1";
        }
      });
  }

  Future<TimeslotResponseModel> getTimeslot(
      TimeslotRequestModel requestModeltimeslot) async {
    var timeslotResponseModel = null;

    var url = Uri.parse(baseURL.base_url + 'doctors_api/reschedule_timeslots');
    final response = await http.post(url, body: requestModeltimeslot.toJson());
    print("response timezone: " + response.body);
    // Fluttertoast.showToast(msg: "response: " + response.body, toastLength: Toast.LENGTH_SHORT);
    try {
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['status'] == "200") {
          // Navigator.of(context).pop();
          timeslotResponseModel = TimeslotResponseModel.fromJson(jsonResponse);
        } else if (jsonResponse['status'] == "400") {
          // Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "There is no timeslot in " + formattedDate.toString(),
              toastLength: Toast.LENGTH_SHORT);
        } else if (jsonResponse['status'] == "404") {
          // Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Empty fields", toastLength: Toast.LENGTH_SHORT);
        } else {
          // Navigator.of(context).pop();
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
    } on TimeoutException {
      print("Timeout");
      print(TimeoutException);
    } catch (Exception) {
      return timeslotResponseModel;
    }
    return timeslotResponseModel;
  }
}
