import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_event.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import 'package:partner_admin_portal/constants/global_function.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu.dart';
import 'package:partner_admin_portal/widgets/orders/manage/manage_orders_mob.dart';
import 'package:partner_admin_portal/widgets/orders/manage/manage_orders_tab.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/constants/search_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';

enum Orders { All,Pickup,Dinein,Deliver}

enum Inprogress {All,Preparing,ReadyToDeliver,OutforDeliver}

class ManageOrders extends StatefulWidget {
  final String query;
  const ManageOrders({Key? key, required this.query}) : super(key: key);

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> with SingleTickerProviderStateMixin {

  Orders selectedOrders = Orders.All;
  Inprogress prepare = Inprogress.All;

  late TabController _tabController;

  List<Map<String, dynamic>> filteredOrders = [];

  String searchedQuery = "";

  final List<Map<String,dynamic>> orders = [
    {
      "Id" : "KAA104122300001",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:57 PM",
      "CustomerName" : "Manoj",
      "number" : "8431944706",
      "Amount" : 353.00,
      "Status" : "Delivered",
      "dname" : "Prajwal",
      "Items": [
        {"itemName": "Decadent Chocolate Fudge Brownie Sundae", "count": 3, "price": 150},
        {"itemName": "Crispy Honey Glazed Salmon Fillet", "count": 2, "price": 110},
        {"itemName": "Delectable Southern Style Buttermilk Fried Chicken", "count": 2, "price": 100},
        {"itemName": "Vada", "count": 5, "price":200},
        {"itemName": "Palav", "count": 2, "price": 100},
        {"itemName": "Mosaranna", "count": 1, "price": 50},
        {"itemName": "Puliyogare", "count": 2, "price": 100},
        {"itemName": "kali dosa", "count": 3, "price": 100},
      ],
      "Expand" : false,
      "Type" : "Deliver",
      "Address" : "Home",
      "rating" :  0,
      "order" : "PreOrder",
    },
    {
      "Id" : "KAA104122300002",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:57 PM",
      "CustomerName" : "Anusha",
      "number" : "9353425719",
      "Amount" : 353.00,
      "Status" : "Delivered",
      "dname" : "Shashank",
      "Items": [
        {"itemName": "Masala Dosa", "count": 3, "price": 150},
        {"itemName": "Rava Idli", "count": 2, "price": 110},
        {"itemName": "Set Dosa", "count": 2, "price": 100},
        {"itemName": "Vada", "count": 5, "price":200},
        {"itemName": "Palav", "count": 2, "price": 100},
        {"itemName": "Mosaranna", "count": 1, "price": 50},

      ],
      "Expand" : false,
      "Type" : "Pick up",
      "Address" : "Work",
      "rating" :  0,
      "order" : "Subcription",
    },
    {
      "Id" : "KAA104122300003",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:57 PM",
      "number" : "8105445911",
      "Amount" : 353.00,
      "CustomerName" : "krishna",
      "Status" : "Cancelled",
      "Items": [
        {"itemName": "Vada", "count": 5, "price":200},
        {"itemName": "Palav", "count": 2, "price": 100},
        {"itemName": "Mosaranna", "count": 1, "price": 50},
        {"itemName": "Puliyogare", "count": 2, "price": 100},
        {"itemName": "kali dosa", "count": 3, "price": 100},
      ],
      "Expand" : false,
      "dname" : "Shamanth",
      "Type" : "Dine in",
      "Address" : "Home",
      "rating" :  0,
      "order" : "Subscription",
    },
    {
      "Id" : "KAA104122300004",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:57 PM",
      "Amount" : 353.00,
      "number" : "944292368",
      "CustomerName" : "Kumari",
      "Status" : "Delivered",
      "Items": [
        {"itemName": "Rava Idli", "count": 2, "price": 110},
        {"itemName": "Set Dosa", "count": 2, "price": 100},
        {"itemName": "Vada", "count": 5, "price":200},
        {"itemName": "Palav", "count": 2, "price": 100},
        {"itemName": "Mosaranna", "count": 1, "price": 50},
        {"itemName": "Puliyogare", "count": 2, "price": 100},
        {"itemName": "kali dosa", "count": 3, "price": 100},
      ],
      "Expand" : false,
      "dname" : "Usman",
      "Type" : "Deliver",
      "Address" : "Work",
      "rating" :  0,
      "order" : "PreOrder",
    },
    {
      "Id" : "KAA104122300005",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:57 PM",
      "number" : "9980859042",
      "CustomerName" : "Deepak",
      "Amount" : 353.00,
      "Status" : "Cancelled",
      "Items": [
        {"itemName": "Palav", "count": 2, "price": 100},
        {"itemName": "Mosaranna", "count": 1, "price": 50},
        {"itemName": "Puliyogare", "count": 2, "price": 100},
        {"itemName": "kali dosa", "count": 3, "price": 100},
      ],
      "Expand" : false,
      "dname" : "Sachin",
      "Type" : "Pick up",
      "Address" : "Home",
      "rating" :  0,
      "order" : "Subscription",
    },
    {
      "Id" : "KAA104122300006",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:57 PM",
      "number" : "7204339914",
      "Amount" : 353.00,
      "Status" : "Delivered",
      "dname" : "Prajwal",
      "CustomerName" : "Divya",
      "Items": [
        {"itemName": "Mosaranna", "count": 1, "price": 50},
        {"itemName": "Puliyogare", "count": 2, "price": 100},
        {"itemName": "kali dosa", "count": 3, "price": 100},
      ],
      "Expand" : false,
      "Type" : "Dine in",
      "Address" : "Home",
      "rating" :  0,
      "order" : "PreOrder",
    },
    {
      "Id" : "KAA104122300007",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:57 PM",
      "Amount" : 353.00,
      "number" : "95293580982",
      "Status" : "Delivered",
      "CustomerName" : "Shilpa",
      "dname" : "Shashank",
      "Items": [

        {"itemName": "Mosaranna", "count": 1, "price": 50},
      ],
      "Expand" : false,
      "Type" : "Pick up",
      "Address" : "Work",
      "rating" :  0,
      "order" : "Subcription",
    },
    {
      "Id" : "KAA104122300008",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "number" : "9392038940",
      "Time" : "8:57 PM",
      "Amount" : 353.00,
      "Status" : "Cancelled",
      "CustomerName" : "Bharath",
      "Items": [
        {"itemName": "Masala Dosa", "count": 3, "price": 150},
        {"itemName": "Rava Idli", "count": 2, "price": 110}
      ],
      "Expand" : false,
      "dname" : "Shamanth",
      "Type" : "Dine in",
      "Address" : "Home",
      "rating" :  0,
      "order" : "Subscription",
    },
    {
      "Id" : "KAA104122300009",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:57 PM",
      "number" : "8927239028",
      "Amount" : 353.00,
      "Status" : "Delivered",
      "CustomerName" : "Gowtham",
      "Items": [
        {"itemName": "Masala Dosa", "count": 3, "price": 150},
        {"itemName": "Rava Idli", "count": 2, "price": 110},
        {"itemName": "Set Dosa", "count": 2, "price": 100},
        {"itemName": "Vada", "count": 5, "price":200},
        {"itemName": "Palav", "count": 2, "price": 100},
        {"itemName": "Mosaranna", "count": 1, "price": 50},
        {"itemName": "Puliyogare", "count": 2, "price": 100},
        {"itemName": "kali dosa", "count": 3, "price": 100},
      ],
      "Expand" : false,
      "dname" : "Usman",
      "Type" : "Deliver",
      "Address" : "Work",
      "rating" :  0,
      "order" : "PreOrder",
    },
  ];



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return ResponsiveBuilder(
        mobileBuilder: (BuildContext context,BoxConstraints constraint){
          return ManageOrdersMob(tabController: _tabController,  filteredOrders: filteredOrders, inprogress: GlobalVariables.inprogress);
        }, tabletBuilder:  (BuildContext context,BoxConstraints constraint){
      filteredOrders = orders.where((order) {
        return order['number'].contains(widget.query) || order['Id'].toString().toLowerCase().contains(widget.query) || order['CustomerName'].toString().toLowerCase().contains(widget.query) || order['CustomerName'].toString().contains(widget.query)  ;
      }).toList();
      return ManageOrdersTab(tabController: _tabController, searchedQuery: widget.query, filteredOrders: filteredOrders);
    }, desktopBuilder: (BuildContext context,BoxConstraints constraint){
      filteredOrders = orders.where((order) {
        return order['number'].contains(widget.query) || order['Id'].toString().toLowerCase().contains(widget.query) || order['CustomerName'].toString().toLowerCase().contains(widget.query) || order['CustomerName'].toString().contains(widget.query)  ;
      }).toList();
      return BlocBuilder<OrderBloc,OrderState>(
        builder: (BuildContext context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5,),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.only(left: 5),
                        color: GlobalVariables.whiteColor,
                        child: DefaultTabController(
                          length: 3,
                          child: Scaffold(
                            appBar:AppBar(
                              toolbarHeight: 0,backgroundColor:Colors.grey.shade50,
                              bottom: TabBar(
                                controller: _tabController,
                                isScrollable: false,
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelPadding: EdgeInsets.symmetric(horizontal: 5),
                                indicatorColor: Color(0xfffbb830),
                                unselectedLabelColor: Colors.black54,
                                labelColor: Color(0xFF363563),
                                labelStyle: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF363563),
                                ),
                                physics: NeverScrollableScrollPhysics(),
                                tabs: [
                                  Tab(text: 'New'),
                                  Tab(text: 'In progress'),
                                  Tab(text: 'Closed',)
                                ],
                              ),
                            ),
                            body: TabBarView(
                              controller: _tabController,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Container(
                                  color: GlobalVariables.whiteColor,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GlobalFunction.buildMealButton(context,MealTime.All,'All'),
                                            GlobalFunction.buildMealButton(context,MealTime.Breakfast,'Breakfast'),
                                            GlobalFunction.buildMealButton(context,MealTime.Lunch,'Lunch'),
                                            GlobalFunction.buildMealButton(context,MealTime.Dinner,'Dinner'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GlobalFunction.buildSessionButton(context,MealSession.All,'All'),
                                            GlobalFunction.buildSessionButton(context,MealSession.Session1,'S1'),
                                            GlobalFunction.buildSessionButton(context,MealSession.Session2,'S2'),
                                            GlobalFunction.buildSessionButton(context,MealSession.Session3,'S3'),
                                            GlobalFunction.buildSessionButton(context,MealSession.Session4,'S4'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GlobalFunction.buildInProgressButton(context, InProgress.All, 'All'),
                                              GlobalFunction.buildInProgressButton(context, InProgress.YetToStart, 'Yet to start'),
                                              GlobalFunction.buildInProgressButton(context, InProgress.Preparing, 'Preparing'),

                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            child:  Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                GlobalFunction.buildInProgressButton(context, InProgress.Ready, 'Ready'),
                                                GlobalFunction.buildInProgressButton(context, InProgress.DeliveyOut, 'Delivery Out'),
                                                GlobalFunction.buildInProgressButton(context, InProgress.PickedUp, 'Picked up'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                Container(
                                  color: GlobalVariables.whiteColor,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GlobalFunction.buildClosedButton(context, Closed.All, "All"),
                                            GlobalFunction.buildClosedButton(context, Closed.Cancelled, "Cancelled"),
                                            GlobalFunction.buildClosedButton(context, Closed.Completed, "Completed"),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            GlobalFunction.buildClosedButton(context, Closed.inCompleted, "In completed"),
                                            GlobalFunction.buildClosedButton(context, Closed.Rejected, "Rejected"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      width: 1,
                    ),
                    Expanded(
                      flex: 5,
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          Container(
                            color: GlobalVariables.whiteColor,
                            child: GridView.builder(
                                itemCount: widget.query == "" ? state.orderList.length : filteredOrders.length,
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.all(20),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 20,
                                    mainAxisExtent: 440,
                                    childAspectRatio: 5,
                                    mainAxisSpacing: 30
                                ),
                                itemBuilder: (context,index) {
                                  state.orderList.sort(compareTime);
                                  final currentOrder = widget.query == "" ? state.orderList[index] : filteredOrders[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: GlobalVariables.whiteColor,
                                        border: Border.all(color: GlobalVariables.primaryColor.withOpacity(0.5))
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin:EdgeInsets.only(left: 4*fem,right: 5*fem,top: 15,bottom: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${currentOrder['Id']}",style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color:GlobalVariables.textColor,
                                              ),),
                                              Row(
                                                children: [
                                                  Icon(Icons.paypal_rounded,color: Colors.blue,size: 20,),
                                                  SizedBox(width: 10,),
                                                  Text("\u20B9 ${currentOrder['Amount']}",style: TextStyle(
                                                      color: GlobalVariables.textColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15
                                                  ),),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),
                                        Container(
                                          margin:EdgeInsets.only(left: 5*fem,right: 5*fem,top: 10,bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("${currentOrder['CustomerName'] }",
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,

                                                      color: Color(0xFF363563),
                                                    ),),
                                                  SizedBox(width: 10,),

                                                ],
                                              ),
                                              Tooltip(
                                                  message: "${currentOrder['number']}",
                                                  child: Icon(Icons.call,color: Colors.green,size: 20,)
                                              )

                                            ],
                                          ),
                                        ),

                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),

                                        Container(
                                            padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width:45*fem,
                                                child: Text(
                                                  'Item names',
                                                  style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF363563),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    child: Text(
                                                      "QTY",
                                                      style: SafeGoogleFont(
                                                        'Poppins',
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        height: 1.5,
                                                        color: Color(0xFF363563),
                                                      ),
                                                    ),
                                                  ),

                                                  Container(
                                                    width: 40,
                                                    child: Text(
                                                      'Total',
                                                      style: SafeGoogleFont(
                                                        'Poppins',
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        height: 1.5,
                                                        color: Color(0xFF363563),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ),

                                        Container(
                                          height: 200,
                                          child: ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: GlobalVariables.orders[index]['Items'].length,
                                            itemBuilder: (_, itemIndex) {
                                              int serialNumber = itemIndex + 1;
                                              return Container(
                                                padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width:45*fem,
                                                      child: Text(
                                                        '${serialNumber}. ${GlobalVariables.orders[index]['Items'][itemIndex]['itemName']} ',
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w400,
                                                          color: Color(0xFF363563),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width: 30,
                                                          child: Text(
                                                            // "${GlobalVariables.orders[index]['Items'][itemIndex]['count']} x ${GlobalVariables.orders[index]['Items'][itemIndex]['price'] ~/ GlobalVariables.orders[index]['Items'][itemIndex]['count']}",
                                                            "${GlobalVariables.orders[index]['Items'][itemIndex]['count']}",
                                                            style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.5,
                                                              color: Color(0xFF363563),
                                                            ),
                                                          ),
                                                        ),

                                                        Container(
                                                          width: 40,
                                                          child: Text(
                                                            '\u20B9 ${GlobalVariables.orders[index]['Items'][itemIndex]['price']}',
                                                            style: TextStyle(
                                                                fontSize: 13
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),

                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              "Deliver",
                                              style:  SafeGoogleFont (
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5*ffem/fem,
                                                color: Color(0xFF363563),
                                              ),
                                            ),
                                            Text(
                                              "Home",
                                              style:  SafeGoogleFont (
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5*ffem/fem,
                                                color: Color(0xFF363563),
                                              ),
                                            ),
                                            Text(
                                              "${currentOrder['Time']} ",
                                              style:  SafeGoogleFont (
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5*ffem/fem,
                                                color: Color(0xFF363563),
                                              ),
                                            ),
                                            InkWell(
                                                onTap: (){

                                                },
                                                child: Icon(Icons.timelapse_outlined,color: Colors.blueGrey,size: 20,)
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),


                                        Container(
                                          margin:EdgeInsets.only(left:2*fem,right: 2*fem,bottom: 15,top: 15),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap:(){
                                                      GlobalFunction.showOrderItems(index, 200, context);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text("Items | ${GlobalVariables.orders[index]['Items'].length} ",
                                                          style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,

                                                            color: Color(0xFF363563),
                                                          ),),
                                                        SizedBox(width: 0,),
                                                        Icon(Icons.double_arrow_outlined,size: 20,color: GlobalVariables.primaryColor,)
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      InkWell(
                                                        onTap:(){
                                                          context.read<OrderBloc>().add(OrderRejectEvent(state.orderList, index,state.closedList));
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: Colors.red
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                                                            child: Center(
                                                              child: Text(
                                                                "Reject",
                                                                style:SafeGoogleFont(
                                                                  'Poppins',
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: GlobalVariables.whiteColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 2*fem,),
                                                      InkWell(
                                                        onTap:(){
                                                          context.read<OrderBloc>().add(OrderAcceptEvent(state.orderList, state.inProgressList, index,state.orderList[index]['Id']));
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: Colors.green
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                                                            child: Center(
                                                              child: Text(
                                                                "Accept",
                                                                style:SafeGoogleFont(
                                                                  'Poppins',
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: GlobalVariables.whiteColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                          Container(
                            color: GlobalVariables.whiteColor,
                            child: GridView.builder(
                                itemCount: state.inProgressList.length,
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.all(20),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 20,
                                    mainAxisExtent: 470,
                                    childAspectRatio: 5,
                                    mainAxisSpacing: 30
                                ),
                                itemBuilder: (context,index) {
                                  final status = state.inProgressList[index]['Status'];
                                  final currentOrder = state.inProgressList[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: GlobalVariables.whiteColor,
                                        border: Border.all(color: GlobalVariables.primaryColor.withOpacity(0.5))
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin:EdgeInsets.only(left: 5*fem,right: 5*fem,top: 15,bottom: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${currentOrder['Id']}",style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color:GlobalVariables.textColor,
                                              ),),
                                              Row(
                                                children: [
                                                  Icon(Icons.paypal_rounded,color: Colors.blue,size: 20,),
                                                  SizedBox(width: 10,),
                                                  Text("\u20B9 ${currentOrder['Amount']}",style: TextStyle(
                                                      color: GlobalVariables.textColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15
                                                  ),),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),
                                        Container(
                                          margin:EdgeInsets.only(left: 5*fem,right: 5*fem,top: 10,bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("${state.inProgressList.elementAt(index)['CustomerName'] } ",
                                                style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,

                                                  color: Color(0xFF363563),
                                                ),),
                                              Tooltip(
                                                  message: "${currentOrder['number']}",
                                                  child: Icon(Icons.call,color: Colors.green,size: 20,)
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width:45*fem,
                                                  child: Text(
                                                    'Item names',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      child: Text(
                                                        "QTY",
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          height: 1.5,
                                                          color: Color(0xFF363563),
                                                        ),
                                                      ),
                                                    ),

                                                    Container(
                                                      width: 40,
                                                      child: Text(
                                                        'Total',
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          height: 1.5,
                                                          color: Color(0xFF363563),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                        ),
                                        Container(
                                          height:200,
                                          child: ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: state.inProgressList[index]['Items'].length,
                                            itemBuilder: (_, itemIndex) {
                                              return Container(
                                                padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width:45*fem,
                                                      child: Text(
                                                        '${itemIndex+1}. ${state.inProgressList[index]['Items'][itemIndex]['itemName']} ',
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w400,
                                                          color: Color(0xFF363563),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width: 30,
                                                          child: Text(
                                                            "${state.inProgressList[index]['Items'][itemIndex]['count']}",
                                                            style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.5,
                                                              color: Color(0xFF363563),
                                                            ),
                                                          ),
                                                        ),

                                                        Container(
                                                          width: 40,
                                                          child: Text(
                                                            '\u20B9 ${state.inProgressList[index]['Items'][itemIndex]['price']}',
                                                            style: TextStyle(
                                                                fontSize: 13
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              "Deliver",
                                              style:  SafeGoogleFont (
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5*ffem/fem,
                                                color: Color(0xFF363563),
                                              ),
                                            ),
                                            Text(
                                              "Home",
                                              style:  SafeGoogleFont (
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5*ffem/fem,
                                                color: Color(0xFF363563),
                                              ),
                                            ),
                                            Text(
                                              "${GlobalVariables.orders.elementAt(index)['Time']} ",
                                              style:  SafeGoogleFont (
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5*ffem/fem,
                                                color: Color(0xFF363563),
                                              ),
                                            ),
                                            InkWell(
                                                onTap: (){

                                                },
                                                child: Icon(
                                                  state.inProgressList[index]['Status'] == "Start"
                                                      ? Icons.start_rounded
                                                      : state.inProgressList[index]['Status'] == "Ready"
                                                      ? Icons.done_rounded
                                                      : state.inProgressList[index]['Status'] == "Delivery out"
                                                      ? Icons.delivery_dining
                                                      : state.inProgressList[index]['Status'] == "Complete"
                                                      ? Icons.done_all_outlined
                                                      : Icons.delivery_dining
                                                  ,
                                                  color: state.inProgressList[index]['Status'] == "Start"
                                                      ? Colors.blueGrey
                                                      : state.inProgressList[index]['Status'] == "Ready"
                                                      ? Colors.grey
                                                      : state.inProgressList[index]['Status'] == "Delivery out"
                                                      ? Colors.blueGrey
                                                      : state.inProgressList[index]['Status'] == "Complete"
                                                      ? Colors.blue
                                                      : Colors.blueGrey,size: 20,)
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),
                                        Container(
                                          margin:EdgeInsets.only(left: 5*fem,right: 5*fem,top: 8,bottom: 8),
                                          child: Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.delivery_dining,color: Colors.red,size: 22,),
                                                  SizedBox(width: 10,),
                                                  Text("${currentOrder['dname'] } ",
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xFF363563),
                                                    ),),
                                                  SizedBox(width: 10,),

                                                ],
                                              ),
                                              Tooltip(
                                                  message: "${currentOrder['number']}",
                                                  child: Icon(Icons.call,color: Colors.green,size: 20,)
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),


                                        Container(
                                          margin:EdgeInsets.only(left:2*fem,right: 2*fem,bottom: 10,top: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap:(){
                                                      GlobalFunction.showItemsInprogressAndClosed(index, 200, context, state.inProgressList);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text("Items | ${state.inProgressList[index]['Items'].length} ",
                                                          style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,

                                                            color: Color(0xFF363563),
                                                          ),),
                                                        SizedBox(width: 0,),
                                                        Icon(Icons.double_arrow_outlined,size: 20,color: GlobalVariables.primaryColor,)
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      InkWell(
                                                        onTap:() {
                                                          if(state.inProgressList[index]['Status'] == "Complete") {
                                                            context.read<OrderBloc>().add(OrderCompleteEvent(index));

                                                          }else {
                                                            context.read<OrderBloc>().add(OrderStatusEvent(state.inProgressList, index,"Ready"));
                                                          }
                                                         
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: Colors.green
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                                                            child: Center(
                                                              child: Text(
                                                                "${state.inProgressList[index]['Status']}",
                                                                style:SafeGoogleFont(
                                                                  'Poppins',
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: GlobalVariables.whiteColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                          Container(
                            color: GlobalVariables.whiteColor,
                            child: BlocBuilder<OrderBloc,OrderState>(
                              builder: (BuildContext context, OrderState state) {
                                if(state is OrderState) {
                                  state.closedList.sort(compareTime);
                                  return GridView.builder(
                                      itemCount: widget.query == "" ? state.closedList.length : filteredOrders.length,
                                      scrollDirection: Axis.vertical,
                                      padding: EdgeInsets.all(20),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 20,
                                          mainAxisExtent: 430,
                                          childAspectRatio: 5,
                                          mainAxisSpacing: 30
                                      ),
                                      itemBuilder: (context,index) {
                                        final currentOrder = widget.query == "" ? state.closedList[index] : filteredOrders[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: GlobalVariables.whiteColor,
                                              border: Border.all(color: GlobalVariables.primaryColor.withOpacity(0.5))
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                margin:EdgeInsets.only(left: 4*fem,right: 5*fem,top: 15,bottom: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${currentOrder['Id']}",style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                      color:GlobalVariables.textColor,
                                                    ),),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.paypal_rounded,color: Colors.blue,size: 20,),
                                                        SizedBox(width: 10,),
                                                        Text("\u20B9 ${currentOrder['Amount']}",style: TextStyle(
                                                            color: GlobalVariables.textColor,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 15
                                                        ),),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 0.5,
                                                color: GlobalVariables.primaryColor,
                                              ),
                                              Container(
                                                margin:EdgeInsets.only(left: 5*fem,right: 5*fem,top: 10,bottom: 10),
                                                child: Row(
                                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("${currentOrder['CustomerName'] }",
                                                          style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,

                                                            color: Color(0xFF363563),
                                                          ),),
                                                        SizedBox(width: 10,),

                                                      ],
                                                    ),
                                                    Tooltip(
                                                        message: "${currentOrder['number']}",
                                                        child: Icon(Icons.call,color: Colors.green,size: 20,)
                                                    )

                                                  ],
                                                ),
                                              ),

                                              Container(
                                                height: 0.5,
                                                color: GlobalVariables.primaryColor,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width:45*fem,
                                                        child: Text(
                                                          'Item names',
                                                          style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xFF363563),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width: 40,
                                                            child: Text(
                                                              "QTY",
                                                              style: SafeGoogleFont(
                                                                'Poppins',
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.5,
                                                                color: Color(0xFF363563),
                                                              ),
                                                            ),
                                                          ),

                                                          Container(
                                                            width: 40,
                                                            child: Text(
                                                              'Total',
                                                              style: SafeGoogleFont(
                                                                'Poppins',
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.5,
                                                                color: Color(0xFF363563),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              ),
                                              Container(
                                                height: 200,
                                                child: ListView.builder(
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: GlobalVariables.orders[index]['Items'].length,
                                                  itemBuilder: (_, itemIndex) {
                                                    int serialNumber = itemIndex + 1;
                                                    return Container(
                                                      padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            width:45*fem,
                                                            child: Text(
                                                              '${serialNumber}. ${state.closedList[index]['Items'][itemIndex]['itemName']} ',
                                                              style: SafeGoogleFont(
                                                                'Poppins',
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400,
                                                                color: Color(0xFF363563),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                width: 30,
                                                                child: Text(
                                                                  // "${GlobalVariables.orders[index]['Items'][itemIndex]['count']} x ${GlobalVariables.orders[index]['Items'][itemIndex]['price'] ~/ GlobalVariables.orders[index]['Items'][itemIndex]['count']}",
                                                                  "${state.closedList[index]['Items'][itemIndex]['count']}",
                                                                  style: SafeGoogleFont(
                                                                    'Poppins',
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w500,
                                                                    height: 1.5,
                                                                    color: Color(0xFF363563),
                                                                  ),
                                                                ),
                                                              ),

                                                              Container(
                                                                width: 40,
                                                                child: Text(
                                                                  '\u20B9 ${state.closedList[index]['Items'][itemIndex]['price']}',
                                                                  style: TextStyle(
                                                                      fontSize: 13
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Container(
                                                height: 0.5,
                                                color: GlobalVariables.primaryColor,
                                              ),

                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(
                                                    "Deliver",
                                                    style:  SafeGoogleFont (
                                                      'Poppins',
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      height: 1.5*ffem/fem,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Home",
                                                    style:  SafeGoogleFont (
                                                      'Poppins',
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      height: 1.5*ffem/fem,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${GlobalVariables.orders.elementAt(index)['Time']} ",
                                                    style:  SafeGoogleFont (
                                                      'Poppins',
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      height: 1.5*ffem/fem,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  InkWell(
                                                      onTap: (){

                                                      },
                                                      child: Icon( state.closedList[index]['Status'] == "Completed" ? Icons.done_all_outlined : Icons.cancel,color: state.closedList[index]['Status'] == "Completed" ? Colors.green : Colors.red,size: 20,)
                                                  ),

                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Container(
                                                height: 0.5,
                                                color: GlobalVariables.primaryColor,
                                              ),

                                              Container(
                                                height: 0.5,
                                                color: GlobalVariables.primaryColor,
                                              ),
                                              Container(
                                                margin:EdgeInsets.only(left:2*fem,right: 2*fem,bottom: 10,top: 10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                          onTap:(){
                                                           GlobalFunction.showItemsInprogressAndClosed(index, 200, context, state.closedList);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text("Items | ${state.closedList[index]['Items'].length} ",
                                                                style: SafeGoogleFont(
                                                                  'Poppins',
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,

                                                                  color: Color(0xFF363563),
                                                                ),),
                                                              SizedBox(width: 0,),
                                                              Icon(Icons.double_arrow_outlined,size: 20,color: GlobalVariables.primaryColor,)
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            InkWell(
                                                              onTap:(){
                                                               // context.read<OrderBloc>().add(OrderRejectEvent(state.orderList, index,state.closedList));
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    color: state.closedList[index]['Status'] == "Completed" ? Colors.green : Colors.red,

                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "${state.closedList[index]['Status']}",
                                                                      style:SafeGoogleFont(
                                                                        'Poppins',
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: GlobalVariables.whiteColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  );
                                } else{
                                  return CircularProgressIndicator();
                                }
                              },

                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },

      );
    });
  }



  Widget buildOrderButton(Orders orders, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedOrders == orders ? GlobalVariables.textColor : selectedOrders == Orders.All ? GlobalVariables.textColor : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOrders = orders;
        });
      },
      child: Container(
        width: 70,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color:GlobalVariables.textColor),
          color: backgroundColor,
        ),
        child: Center(
          child: Text(
            label,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              height: 1.3102272749 * ffem / fem,
              color: GlobalVariables.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInprogressButton(Inprogress prepares, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = prepare == prepares ? GlobalVariables.textColor : prepare == Inprogress.All ? GlobalVariables.textColor : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          prepare = prepares;
        });
      },
      child: Container(
        width: 75,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color:GlobalVariables.textColor),
          color: backgroundColor,
        ),
        child: Center(
          child: Text(
            label,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 9,
              fontWeight: FontWeight.bold,
              height: 1.3102272749 * ffem / fem,
              color: GlobalVariables.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

int compareTime(Map<String, dynamic> a, Map<String, dynamic> b) {
  DateTime timeA = DateFormat('hh:mm a').parse(a['Time']);
  DateTime timeB = DateFormat('hh:mm a').parse(b['Time']);
  return timeB.compareTo(timeA);
}
}
