import 'dart:async';
import 'package:clinic_app/PDFScreen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic_app/PrescriptionAllModel.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'APIMedia.dart';

class FilesTabbar extends StatefulWidget  {

  String id;
  FilesTabbar({required this.id});

  @override
  State<FilesTabbar> createState() => _FilesTabbarState();
}

class _FilesTabbarState extends State<FilesTabbar> with WidgetsBindingObserver {


  // final Completer<PDFViewController> _controller =
  // Completer<PDFViewController>();
  // int? pages = 0;
  // int? currentPage = 0;
  // bool isReady = false;
  // String errorMessage = '';

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
        onWillPop: () {
          print('Backbutton pressed (device or appbar button), do whatever you want.');

          //trigger leaving and use own data
          Navigator.pop(context);

          //we need to return a future
          return Future.value(true);
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
        onWillPop: () {
          print('Backbutton pressed (device or appbar button), do whatever you want.');

          //trigger leaving and use own data
          Navigator.pop(context);

          //we need to return a future
          return Future.value(true);
        },
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: ClipRRect(
            child: Center(child: Text(
              "File is empty",
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
        onWillPop: () {
          print('Backbutton pressed (device or appbar button), do whatever you want.');

          //trigger leaving and use own data
          Navigator.pop(context);

          //we need to return a future
          return Future.value(true);
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
                        return GestureDetector(
                          onTap: () async {
                            print("Container clicked 1");
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PDFScreen(pathPDF: dataItem![index].prescription,)));
                          },
                          child: Container(
                            height: 200,
                            width: 200,
                            color: Colors.black,
                          ),
                          // PDFView(
                          //   filePath: dataItem![0].prescription,
                          //   enableSwipe: true,
                          //   swipeHorizontal: true,
                          //   autoSpacing: true,
                          //   pageFling: true,
                          //   pageSnap: true,
                          //   nightMode: false,
                          //   // defaultPage: currentPage!,
                          //   fitPolicy: FitPolicy.BOTH,
                          //   preventLinkNavigation: false, // if set to true the link is handled in flutter
                          //   onRender: (_pages) {
                          //     setState(() {
                          //       pages = _pages;
                          //       isReady = true;
                          //     });
                          //   },
                          //   onError: (error) {
                          //     setState(() {
                          //       errorMessage = error.toString();
                          //     });
                          //     print("aaaaaaaaaaaaaaa"+error.toString());
                          //   },
                          //   onPageError: (page, error) {
                          //     setState(() {
                          //       errorMessage = '$page: ${error.toString()}';
                          //     });
                          //     print("bbbbbbbbbbbbbbb"+'$page: ${error.toString()}');
                          //   },
                          //   onViewCreated: (PDFViewController pdfViewController) {
                          //     _controller.complete(pdfViewController);
                          //   },
                          //   onLinkHandler: (String? uri) {
                          //     print('goto uri: $uri');
                          //   },
                          //   onPageChanged: (int? page, int? total) {
                          //     print('page change: $page/$total');
                          //     setState(() {
                          //       currentPage = page;
                          //     });
                          //   },
                          // ),
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
