 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Ui{

   static BoxDecoration getBoxDecoration() {
     return BoxDecoration(color: Colors.white,
       borderRadius: BorderRadius.all(Radius.circular(10)),
       boxShadow: [
         BoxShadow(color: Colors.grey.withOpacity(0.1),
           blurRadius: 10,
           spreadRadius: 10,
           offset: Offset(0, 5),
         ),
       ],
       border: Border.all(color: Colors.white),
       // gradient: 10,
     );
   }

   static GetBar ErrorSnackBar({String title = 'Error', String? message}) {
     Get.log("[$title] $message", isError: true);
     return GetBar(
       titleText: Text(title.tr, style: Get.textTheme!.headline6!.merge(TextStyle(color: Get.theme!.primaryColor))),
       messageText: Text(message!, style: Get.textTheme!.caption!.merge(TextStyle(color: Get.theme!.primaryColor))),
       snackPosition: SnackPosition.BOTTOM,
       margin: EdgeInsets.all(20),
       backgroundColor: Colors.redAccent,
       icon: Icon(Icons.remove_circle_outline, size: 32, color: Get.theme!.primaryColor),
       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
       borderRadius: 8,
       duration: Duration(seconds: 5),
     );
   }

 }