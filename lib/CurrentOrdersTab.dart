import 'package:clinic_app/CurrentOrderListItems.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AcceptedOrderListItems.dart';
import 'CompletedOrderListItems.dart';
import 'RejectedOrderListItems.dart';

class CurrentOrdersTab extends StatefulWidget {
  @override
  State<CurrentOrdersTab> createState() => _CurrentOrdersTabState();
}

class _CurrentOrdersTabState extends State<CurrentOrdersTab> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Bookings".tr,
              style: TextStyle(color: Colors.white)),
            centerTitle: true,
            // backgroundColor: Colors.lightBlue[800],
            backgroundColor: Colors.lightBlue[800],
            elevation: 0,
            automaticallyImplyLeading: false,
            bottom: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  0.0,
                ),
                color: Colors.white,
              ),
              labelColor: Colors.lightBlue[800],
              unselectedLabelColor: Colors.grey[100],
              tabs: [
                Tab(
                  text: "Current",
                  // icon: Icon(Icons.reorder),
                ),
                Tab(
                  text: "Accepted",
                  // icon: Icon(Icons.assignment),
                ),
                // Tab(
                //   text: "Rejected",
                //   icon: Icon(Icons.account_balance_wallet),
                // ),
                Tab(
                  text: "Completed",
                  // icon: Icon(Icons.settings),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CurrentOrderListItems(),
              AcceptedOrderListItems(),
              // RejectedOrderListItems(),
              CompletedOrderListItems(),
            ],
          ),
        ),
      ),
    );
  }

}