import 'dart:async';
import 'package:clinic_app/HomePage.dart';
import 'package:clinic_app/LoginCred.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash extends StatefulWidget {
  @override
  Splashscreen createState() => Splashscreen();
}

class Splashscreen extends State<splash> {

  var token = "";

  @override
  void initState() {
    super.initState();
    getValidationData().whenComplete(() async {});
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
    print("token: "+token);
    Timer(
        Duration(seconds: 3),
        () => token == "" ? Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => LoginCred())) : Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => HomePage())));

    var assetsImage = new AssetImage(
        'assets/icon.jpg'); //<- Creates an object that fetches an image.
    var image = new Image(
        image: assetsImage,
        height: 300); //<- Creates a widget that displays an image.

    return MaterialApp(
      home: Scaffold(
        /* appBar: AppBar(
          title: Text("MyApp"),
          backgroundColor:
              Colors.blue, //<- background color to combine with the picture :-)
        ),*/
        body: Container(
          decoration: new BoxDecoration(color: Colors.white),
          child: new Center(
            child: image,
          ),
        ), //<- place where the image appears
      ),
    );
  }
}
