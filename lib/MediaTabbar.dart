import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic_app/PrescriptionAllModel.dart';
import 'package:clinic_app/ShowHistoryPrescriptions.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'APIMedia.dart';

class MediaTabbar extends StatefulWidget  {

  String id;
  MediaTabbar({required this.id});

  @override
  State<MediaTabbar> createState() => _MediaTabbarState();
}

class _MediaTabbarState extends State<MediaTabbar> {

  List<Datum> ?dataItem;
  var token;
  late int dataCount = -1;
  String hasData = "";
  PrescriptionAllRequestModel prescriptionAllRequestModel = new PrescriptionAllRequestModel(token: '', booking_id: '');

  @override
  void initState() {
    // TODO: implement initState
    getMedia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print("dataItem111: "+dataItem.toString());

    if(dataCount == -1 && hasData == ""){
        return WillPopScope(
          onWillPop: ()async {
            print('Backbutton pressed (device or appbar button), do whatever you want.');

            return true;
          },
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        );
    }else if(hasData == "no data"){
      return WillPopScope(
        onWillPop: () async {
          print('Backbutton pressed (device or appbar button), do whatever you want.');

          return true;
        },
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: ClipRRect(
            child: Center(child: Text(
              "Media is empty",
              // style: context.textTheme.headline6,
              style: TextStyle(
                color: Colors.lightBlue[800],
              ),
            ),),
          ),
        ),
      );
    }else{
      return WillPopScope(
        onWillPop: () async{
          print('Backbutton pressed (device or appbar button), do whatever you want.');

          return true;
        },
        child: Scaffold(
          body: Column(
            children: [
              // Container(
              //   height: 30,
              //   child: Center(
              //     child: Row(
              //       children: [
              //         Container(
              //           margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              //           child: Text('Date: 23-03-2022', style: TextStyle(
              //               color: Colors.lightBlue[800],
              //               fontSize: 15,
              //               fontWeight: FontWeight.bold
              //           ),),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Container(
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.builder(
                      itemCount: dataItem!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5),
                      itemBuilder: (BuildContext context, int index) {
                        // return Image.file(
                        //   File(dataItem![index].prescription),
                        //   fit: BoxFit.cover,
                        // );
                        return GestureDetector(
                          onTap: () async {
                            print("Container clicked 1");
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ShowHistoryPrescription(imageurl: dataItem![index].prescription)));
                          },
                          child: CachedNetworkImage(
                            // height: 300,
                            // width: 300,
                            fit: BoxFit.cover,
                            imageUrl: dataItem![index].prescription,
                            placeholder: (context, url) =>
                                // Image.asset(
                                //   'assets/img/loading.gif',
                                //   fit: BoxFit.cover,
                                //   width: double.infinity,
                                //   height: 80,
                                // ),
                            Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  getMedia() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    prescriptionAllRequestModel.token = token!;
    prescriptionAllRequestModel.booking_id = widget.id.toString();

    print("booking_id: "+widget.id);

    APIMedia apiMedia = new APIMedia();
    apiMedia.getMedia(prescriptionAllRequestModel).then((value) async {
      print("value: "+value.toString());
      setState(() {
        hasData = "no data";
      });
      if (value.status == "200") {
        setState(() {
          dataItem = value.data;
          dataCount = 1;
          hasData = "data";
        });
        print("dataItem222: "+value.data.length.toString());
        // Fluttertoast.showToast(msg: "dataItem222: "+dataItem.length.toString(), toastLength: Toast.LENGTH_SHORT);
      }else if(value.status == "400") {
        // Get.showSnackbar(Ui.ErrorSnackBarInvalid(message: 'Invalid fields'.tr));
        return Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: ClipRRect(
            // borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Image.asset(
              'assets/img/on_boarding.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 80,
            ),
          ),
        );
      }else if(value.status == "404") {
        // Get.showSnackbar(Ui.ErrorSnackBarEmpty(message: 'Empty fields'.tr));
      }else if(value.status == "403") {
        // Get.showSnackbar(Ui.ErrorSnackBarOTP(message: 'Invalid OTP'.tr));
      }else {
      }
    });
  }
}
