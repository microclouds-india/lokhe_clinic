import 'dart:async';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:clinic_app/baseURL.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:clinic_app/CurrentOrderListItems.dart';
import 'package:clinic_app/HomePage.dart';
import 'package:clinic_app/progressbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginmodel.dart';

class LoginCred extends StatefulWidget {
  late LoginRequestModel requestModel;

  @override
  _LoginCredState createState() => _LoginCredState();
}

class _LoginCredState extends State<LoginCred> {

  LoginRequestModel loginRequestModel = LoginRequestModel(email: '', password: '');

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: MaterialApp(
        home: Scaffold(
          // backgroundColor: Colors.white,
          backgroundColor: Colors.grey[100],
          body: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 110, right: 110, bottom: 100),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child: Image.asset('assets/icon/icon.jpg')),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.only(top: 0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // color: Colors.lightBlue[800],
                              image: DecorationImage(
                                  image: AssetImage("assets/icon/icon.jpg"),
                                  scale: 3.8),
                            ),
                          ),
                        ),
                        title: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.lightBlue[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          "It's nice to see you again",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50, right: 50, top: 10),
                      child: Text(
                        "Username",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 40, right: 40, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.lightBlue, // set border color
                            width: 1.5), // set border width
                        borderRadius: BorderRadius.all(
                            Radius.circular(20.0)), // set rounded corner radius
                      ),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (input) => loginRequestModel.email = input,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          hintText: 'Please enter your email...',
                          border: InputBorder.none,
                        ),
                        // keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50, right: 50, top: 10),
                      child: Text(
                        "Password",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 40, right: 40, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.lightBlue, // set border color
                            width: 1.5), // set border width
                        borderRadius: BorderRadius.all(
                            Radius.circular(20.0)), // set rounded corner radius
                      ),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        obscureText: true,
                        onChanged: (input) => loginRequestModel.password = input,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone_android,
                          ),
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          hintText: 'Please enter your password...',
                          border: InputBorder.none,
                        ),
                        // keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 60, right: 60, top: 30),
                      child: ElevatedButton(
                        onPressed: () async {

                          print(loginRequestModel.toJson());
                          showAlertDialog(context);
                          var url =Uri.parse(baseURL.base_url+'doctors_api/clinic_login');
                          final response = await http.post(url, body:loginRequestModel.toJson());
                          print("response timezone: " + response.body);
                          try {
                            if (response.statusCode == 200) {
                              var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
                              if (jsonResponse['status'] == "200") {

                                Navigator.of(context, rootNavigator: true).pop();

                                SharedPreferences sharespreferences = await SharedPreferences.getInstance();
                                sharespreferences.setString('token', jsonResponse['token']);

                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

                              } else if (jsonResponse['status'] == "400") {
                                Navigator.of(context, rootNavigator: true).pop();
                                Fluttertoast.showToast( msg: "Invalid fields", toastLength: Toast.LENGTH_SHORT);
                              } else if (jsonResponse['status'] == "404") {
                                Navigator.of(context, rootNavigator: true).pop();
                                Fluttertoast.showToast( msg: "Empty fields", toastLength: Toast.LENGTH_SHORT);
                              } else {
                                Navigator.of(context, rootNavigator: true).pop();
                                Fluttertoast.showToast( msg: ""+jsonResponse['response'], toastLength: Toast.LENGTH_SHORT);
                              }
                            }

                          }on SocketException {
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
                          } catch(Exception){
                            // return RoomEnterResponseModel;
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue[800],
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // <-- Radius
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
