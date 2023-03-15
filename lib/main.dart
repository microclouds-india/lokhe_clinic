import 'dart:async';
import 'package:clinic_app/LoginCred.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';

void main() {
  runApp( MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var token = "";

  @override
  void initState() {
    super.initState();
    getValidationData().whenComplete(() async {});
    Future.delayed( const Duration(seconds: 3), () => token == "" ? Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) => LoginCred())) : Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) => HomePage())));
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token2 = sharedPreferences.getString('token');
    setState(() {
      token = token2!;
      print("token2: "+token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(
            child: Image.asset(
              'assets/icon/icon.jpg',
              // fit: BoxFit.cover,
              // repeat: ImageRepeat.noRepeat,
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );
  }
}