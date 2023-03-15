import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:clinic_app/baseURL.dart';
import 'package:clinic_app/progressbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AllChats.dart';
import 'AllChatsSend.dart';

class ChatScreen extends StatefulWidget {
  final String id;
  final String user_id;

  const ChatScreen(this.id, this.user_id);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

String text1 = "";
String text2 = "";
String text3 = "";
String text4 = "";
String text5 = "";

class _ChatScreenState extends State<ChatScreen> {
  var token;
  List? data;
  var _controller = TextEditingController();
  bool sendIcon = false;
  bool isLoading = false;
  AllChatsRequestModel allChatsRequestModel =
      new AllChatsRequestModel(token: '', user_id: '', booking_id: '');
  AllChatsSendRequestModel allChatsSendRequestModel =
      new AllChatsSendRequestModel(
          token: '', user_id: '', booking_id: '', message: '');

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
      getAllChats(allChatsRequestModel);
    });
  }

  getAllChats(AllChatsRequestModel acceptedBookingsRequestModel2) async {
    allChatsRequestModel.token = token;
    allChatsRequestModel.user_id = widget.user_id;
    allChatsRequestModel.booking_id = widget.id;
    // showAlertDialog(context);
    // var currentBookingsResponseModel2 = null;
    isLoading = true;
    print("allchat token: " + token.toString());
    print("allchat id: " + widget.user_id.toString());

    var url = Uri.parse(baseURL.base_url + 'doctors_api/doctor_chats_all');
    final response =
        await http.post(url, body: acceptedBookingsRequestModel2.toJson());
    print("response timezone: " + response.body);
    try {
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['status'] == "200") {
          setState(() {
            isLoading = false;
            data = jsonResponse!['data'];
          });
        } else if (jsonResponse['status'] == "400") {
          setState(() {
            isLoading = false;
          });
          // Navigator.of(context, rootNavigator: true).pop();
        } else if (jsonResponse['status'] == "404") {
          setState(() {
            isLoading = false;
          });
          // Navigator.of(context, rootNavigator: true).pop();
          // Fluttertoast.showToast( msg: "Empty fields", toastLength: Toast.LENGTH_SHORT);
        } else {
          setState(() {
            isLoading = false;
          });
          // Navigator.of(context, rootNavigator: true).pop();
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
    print("id: " + widget.user_id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Chat Page",
          // style: context.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[800],
        automaticallyImplyLeading: false,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          Container(
            width: 15,
            margin: EdgeInsets.only(right: 20),
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  getAllChats(allChatsRequestModel);
                });
              },
              child: isLoading == false
                  ? Center(child: Icon(Icons.refresh))
                  : CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.0),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data == null ? 0 : data!.length,
              itemBuilder: (context, index) => Row(
                mainAxisAlignment: data![index]["sender"] == "doctor"
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[800]?.withOpacity(
                            data![index]["sender"] == "doctor" ? 0.90 : 0.20),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        data![index]["message"],
                        style: TextStyle(
                          color: data![index]["sender"] == "doctor"
                              ? Colors.white
                              : Colors.black,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 32,
                color: Colors.lightBlue[800]!.withOpacity(0.08),
              ),
            ]),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10 * 0.75, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[800]!.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(40)),
                      child: Row(
                        children: [
                          // SizedBox(width: 5),
                          // Icon(
                          //   Icons.sentiment_satisfied_alt_outlined,
                          //   color: Theme.of(context)
                          //       .textTheme
                          //       .bodyText1
                          //       ?.color
                          //       ?.withOpacity(0.64),
                          // ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              onChanged: (input) =>
                                  allChatsSendRequestModel.message = input,
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: "Type message",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 60,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.lightBlue[800]!.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(40)),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        GestureDetector(
                          child: sendIcon == false
                              ? Icon(
                                  Icons.send,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.color
                                      ?.withOpacity(0.64),
                                )
                              : Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.lightBlue[800],
                                  ),
                                ),
                          onTap: () async {

                            allChatsSendRequestModel.token = token;
                            allChatsSendRequestModel.user_id = widget.user_id;
                            allChatsSendRequestModel.booking_id = widget.id;
                            // showAlertDialog(context);
                            if (allChatsSendRequestModel.message == "") {
                              setState(() {
                                sendIcon = false;
                              });
                            } else {

                              setState(() {
                                sendIcon = true;
                              });

                              var url = Uri.parse(baseURL.base_url +
                                  'doctors_api/sentmessage_to_user');
                              final response = await http.post(url,
                                  body: allChatsSendRequestModel.toJson());
                              print("response timezone controllerrrrrrr: " + _controller.text.toString());
                              try {
                                if (response.statusCode == 200) {
                                  var jsonResponse =
                                      convert.jsonDecode(response.body)
                                          as Map<String, dynamic>;
                                  if (jsonResponse['status'] == "200") {
                                    setState(() {
                                      sendIcon = false;
                                      getAllChats(allChatsRequestModel);
                                      _controller.clear();
                                      allChatsSendRequestModel.message="";
                                    });
                                  } else if (jsonResponse['status'] == "400") {
                                    setState(() {
                                      sendIcon = false;
                                    });
                                  } else if (jsonResponse['status'] == "404") {
                                    setState(() {
                                      sendIcon = false;
                                    });
                                  } else {
                                    setState(() {
                                      sendIcon = false;
                                    });
                                  }
                                }
                              } on SocketException {
                                print('No Internet connection');
                                print(SocketException);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
