import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/utils.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    Color baseColor = Color(0xFF363563);
    Color lighterColor = baseColor.withOpacity(0.1);
    return Scaffold(
      appBar: AppBar(
        title: Text("MANAGE ORDERS",style: SafeGoogleFont(
          'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF363563),
        ),),
        elevation: 5,
        backgroundColor: Color(0xfffbb830),
        bottom:  PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(

            child: TabBar(
              indicatorColor: Color(0xfffbb830),
              dividerColor: Colors.white,
              labelColor: Color(0xFF363563),
              unselectedLabelColor: Colors.black54,
              controller: _tabController,
              indicatorWeight: 5,
              labelStyle: SafeGoogleFont(
                'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF363563),
              ),
              tabs: [
                Tab(text: 'New'),
                Tab(text: 'Preparing'),
                Tab(text: 'Ready'),
                Tab(text: 'Pick up'),
                Tab(text: 'Past Orders',)
              ],
            ),
          ),
        ),
        actions: [
          Icon(Icons.settings,color: Color(0xFF363563),size: 25,),
          SizedBox(width: 40,),
          Icon(Icons.notifications_active_outlined,color: Color(0xFF363563),size: 25,),
          SizedBox(width: 40,),
          CircleAvatar(
            backgroundImage: NetworkImage("https://www.pngitem.com/pimgs/m/78-786293_1240-x-1240-0-avatar-profile-icon-png.png"),
          ),
          SizedBox(width: 20,)
        ],
      ),

    );
  }
}
