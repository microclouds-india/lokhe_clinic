import 'dart:io';
import 'dart:convert' as convert;
import 'package:clinic_app/LoginCred.dart';
import 'package:clinic_app/baseURL.dart';
import 'package:clinic_app/progressbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AccountLinkedWidget.dart';
import 'Logout.dart';
import 'ProfileModel.dart';
import 'Ui.dart';
import 'logoutmodel.dart';

class ProfileTab extends StatefulWidget {
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  var token;
  var profileDetails;

  ProfileRequestModel profileRequestModel = new ProfileRequestModel(token: '');
  LogoutRequestModel logoutRequestModel = new LogoutRequestModel(token: '');

  @override
  void initState() {
    // TODO: implement initState
    getValidationData().whenComplete(() async {});
    super.initState();
    setState(() {});
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var token2 = sharedPreferences.getString('token');
    setState(() {
      token = token2!;
      print("token2: " + token);
      getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Profile", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.lightBlue[800],
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: Ui.getBoxDecoration(),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                              child: Image.asset('assets/img/on_boarding.png')),
                        ),
                        AccountLinkWidget(
                          icon: Icon(Icons.person_outline,
                              color: Colors.lightBlue[800]),
                          text: Text(profileDetails['name']! == null ? "" :
                            "Name: " + profileDetails['name'] + ''.tr,
                            style: TextStyle(
                              color: Colors.lightBlue[800],
                            ),
                          ),
                          onTap: (e) {
                            // Get.toNamed(Routes.PROFILE);
                          },
                        ),
                        AccountLinkWidget(
                          icon: Icon(Icons.assignment_outlined,
                              color: Colors.lightBlue[800]),
                          text: Text(
                            "Description: " +
                                profileDetails['decription'] +
                                ''.tr,
                            style: TextStyle(
                              color: Colors.lightBlue[800],
                            ),
                          ),
                          onTap: (e) {
                            // Get.find<TabsController>().changePageInRoot(1);
                          },
                        ),
                        AccountLinkWidget(
                          icon: Icon(Icons.email_outlined,
                              color: Colors.lightBlue[800]),
                          text: Text(
                            "Email: " + profileDetails['email'] + ''.tr,
                            style: TextStyle(
                              color: Colors.lightBlue[800],
                            ),
                          ),
                          onTap: (e) {
                            // Get.toNamed(Routes.NOTIFICATIONS);
                          },
                        ),
                        AccountLinkWidget(
                          icon: Icon(Icons.phone_android_outlined,
                              color: Colors.lightBlue[800]),
                          text: Text(
                            "Phone: " + profileDetails['phone'] + ''.tr,
                            style: TextStyle(
                              color: Colors.lightBlue[800],
                            ),
                          ),
                          onTap: (e) {
                            // Get.find<TabsController>().changePageInRoot(2);
                          },
                        ),
                        Container(
                          width: 150,
                          height: 40,
                          margin: EdgeInsets.only(left: 60, right: 60, top: 30),
                          child: ElevatedButton(
                            onPressed: () async {
                              SharedPreferences sharespreferences =
                                  await SharedPreferences.getInstance();
                              var token = sharespreferences.getString("token");

                              logoutRequestModel.token = token!;

                              Logout logout = new Logout();
                              showAlertDialog(context);
                              logout.logout(logoutRequestModel).then((value) async {

                                Navigator.of(context, rootNavigator: true).pop();

                                if (value.status == "200") {
                                  SharedPreferences sharespreferences = await SharedPreferences.getInstance();
                                  sharespreferences.remove("token");
                                  print("logout: " + token);

                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginCred(),));

                                } else if (value.status == "400") {
                                  Fluttertoast.showToast(msg: "Invalid fields", toastLength: Toast.LENGTH_SHORT);
                                } else if (value.status == "404") {
                                  Fluttertoast.showToast(msg: "Empty fields", toastLength: Toast.LENGTH_SHORT);
                                } else {}
                              });
                            },
                            child: Text(
                              'Logout',
                              style: Get.textTheme?.caption?.merge(TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              )),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.lightBlue[800],
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20), // <-- Radius
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getProfile() async {
    print("token1: " + token);
    profileRequestModel.token = token;
    // showAlertDialog(context);

    var url = Uri.parse(baseURL.base_url + 'doctors_api/clinic_profile');
    final response = await http.post(url, body: profileRequestModel.toJson());
    print("response current: " + response.body);
    // Fluttertoast.showToast(msg: "response: " + response.body, toastLength: Toast.LENGTH_SHORT);
    try {
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['status'] == "200") {
          // Navigator.of(context, rootNavigator: true).pop();
          // currentBookingsResponseModel2 = CurrentBookingsResponseModel.fromJson(jsonResponse);
          setState(() {
            profileDetails = jsonResponse;
            print("name: " + profileDetails['name']);
          });
        } else if (jsonResponse['status'] == "400") {
          // Navigator.of(context, rootNavigator: true).pop();
          // Fluttertoast.showToast( msg: "There is no timeslot in "+formattedDate.toString(), toastLength: Toast.LENGTH_SHORT);
        } else if (jsonResponse['status'] == "404") {
          // Navigator.of(context, rootNavigator: true).pop();
          // Fluttertoast.showToast( msg: "Empty fields", toastLength: Toast.LENGTH_SHORT);
        } else {
          // Navigator.of(context, rootNavigator: true).pop();
        }
      }
    } on SocketException {
      print('No Internet connection');
      print(SocketException);
    }
    // return currentBookingsResponseModel2;
  }
}
