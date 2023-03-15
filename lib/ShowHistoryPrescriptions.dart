import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic_app/BlockButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ShowHistoryPrescription extends StatefulWidget {
  final String imageurl;

  const ShowHistoryPrescription({Key? key, required this.imageurl}) : super(key: key);

  @override
  _ShowHistoryPrescriptionState createState() =>
      _ShowHistoryPrescriptionState();
}

class _ShowHistoryPrescriptionState extends State<ShowHistoryPrescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Prescription".tr,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                height: 500,
                color: Colors.white,
                margin: EdgeInsets.only(left: 10, right: 10),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.imageurl,
                  imageBuilder: (context, imageProvider) => PhotoView(
                    imageProvider: imageProvider,
                  ),
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 80,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 50, right: 50, top: 10),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: BlockButtonWidget(
                text: Text(
                  "Download".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,),
                ),
                color: Colors.lightBlue[800]!,
                onPressed: () async {
                  await GallerySaver.saveImage(widget.imageurl, albumName: "DoctorsApp");
                  Fluttertoast.showToast( msg: "Image saved to gallery", toastLength: Toast.LENGTH_SHORT);
                },
                // icon: null,
              ).paddingOnly(right: 20, left: 20),
            ),
          ],
        ),
      ),
    );
  }
}
