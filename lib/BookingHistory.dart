import 'package:clinic_app/FilesTabbar.dart';
import 'package:clinic_app/MediaTabbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BookingHistory extends StatelessWidget {

  String id;
  BookingHistory({required this.id});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 1,
        child: WillPopScope(
          onWillPop: () async {
          print('Backbutton pressed (device or appbar button), do whatever you want.');

          return true;
        },
          child: Scaffold(
            appBar: AppBar(
              title: Text("History", style: TextStyle(color: Colors.white)),
              centerTitle: true,
              backgroundColor: Colors.lightBlue[800],
              elevation: 0,
              automaticallyImplyLeading: false,
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: "Prescription",
                    icon: Icon(Icons.perm_media_outlined),
                  ),
                  // Tab(
                  //   text: "Files",
                  //   icon: Icon(Icons.file_copy_outlined),
                  // ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                MediaTabbar(id: id.toString(),),
                // FilesTabbar(id: id.toString(),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
