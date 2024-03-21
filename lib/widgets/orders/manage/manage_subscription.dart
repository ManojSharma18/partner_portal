import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/global_function.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../menu/live_menu/live_menu.dart';
import 'manage_orderes.dart';
import '../../responsive_builder.dart';

class ManageSubscription extends StatelessWidget {
  const ManageSubscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return  ResponsiveBuilder(
        mobileBuilder: (BuildContext context,BoxConstraints constraint){
          return Column();
        }, tabletBuilder:  (BuildContext context,BoxConstraints constraint){

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
                      length: 2,
                      child: Scaffold(
                        appBar:AppBar(
                          toolbarHeight: 0,backgroundColor:Colors.grey.shade50,
                          bottom: TabBar(
                            //controller: GlobalVariables.getSubscriptionTabController(),
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
                              Tab(text: 'TAb 1'),
                              Tab(text: 'Tab 2'),

                            ],
                          ),
                        ),
                        body: TabBarView(
                          // controller: GlobalVariables.getSubscriptionTabController(),
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
                                  SizedBox(height: 10,),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        GlobalFunction.buildOrderButton(context,Orders.All, 'All'),
                                        GlobalFunction.buildOrderButton(context,Orders.Pickup, 'Pick up'),
                                        GlobalFunction.buildOrderButton(context,Orders.All, 'Dine'),
                                        GlobalFunction.buildOrderButton(context,Orders.All, 'Deliver'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GlobalFunction.buildInProgressButton(context, InProgress.All, 'All'),
                                        GlobalFunction.buildInProgressButton(context, InProgress.DeliveyOut, 'Delivery Out'),
                                        GlobalFunction.buildInProgressButton(context, InProgress.Delayed, 'Delayed'),
                                      ],
                                    ),
                                  ),



                                ],
                              ),
                            ),
                            Column()
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
                    controller: GlobalVariables.getSubscriptionTabController(),
                    children: [
                      Container(
                        color: GlobalVariables.whiteColor,
                        child: GridView.builder(
                            itemCount: GlobalVariables.orders.length,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.all(20),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisExtent: 270,
                                childAspectRatio: 5,
                                mainAxisSpacing: 30
                            ),
                            itemBuilder: (context,index) {
                              final currentOrder =  GlobalVariables.orders[index];
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
                                          Text("OID : ${currentOrder['Id']}",style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color:GlobalVariables.textColor,
                                          ),),
                                          Row(
                                            children: [

                                              Text("${currentOrder['type']}",style: TextStyle(
                                                  color: GlobalVariables.textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14
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
                                          Text("${currentOrder['CustomerName'] } ",
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
                                      height:80,
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: GlobalVariables.orders[index]['Items'].length,
                                        itemBuilder: (_, itemIndex) {
                                          return Container(
                                            padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width:32*fem,
                                                  child: Text(
                                                    '${GlobalVariables.orders[index]['Items'][itemIndex]['itemName']} ',
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
                                                      width: 60,
                                                      child: Text(
                                                        "${GlobalVariables.orders[index]['Items'][itemIndex]['count']} x ${GlobalVariables.orders[index]['Items'][itemIndex]['price'] ~/ GlobalVariables.orders[index]['Items'][itemIndex]['count']}",
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
                                              Text("${GlobalVariables.orders.elementAt(index)['Type']} ",style:SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,

                                                color: Color(0xFF363563),
                                              ) ,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap:(){
                                                      // setState(() {
                                                      //   orders.removeAt(index);
                                                      // });
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
                                                            "Canceled",
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
                        ),
                      ),

                      Column()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }, desktopBuilder: (BuildContext context,BoxConstraints constraint){

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
                      length: 2,
                      child: Scaffold(
                        appBar:AppBar(
                          toolbarHeight: 0,backgroundColor:Colors.grey.shade50,
                          bottom: TabBar(
                            //controller: GlobalVariables.getSubscriptionTabController(),
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
                              Tab(text: 'In progress'), 
                              Tab(text: 'Closed'),

                            ],
                          ),
                        ),
                        body: TabBarView(
                          // controller: GlobalVariables.getSubscriptionTabController(),
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
                                  SizedBox(height: 10,),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        GlobalFunction.buildOrderButton(context,Orders.All, 'All'),
                                        GlobalFunction.buildOrderButton(context,Orders.Pickup, 'Pick up'),
                                        GlobalFunction.buildOrderButton(context,Orders.All, 'Dine'),
                                        GlobalFunction.buildOrderButton(context,Orders.All, 'Deliver'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GlobalFunction.buildInProgressButton(context, InProgress.All, 'All'),
                                        GlobalFunction.buildInProgressButton(context, InProgress.DeliveyOut, 'Delivery Out'),
                                        GlobalFunction.buildInProgressButton(context, InProgress.Delayed, 'Delayed'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GlobalFunction.buildAmountButton(context, Amount.All, 'All'),
                                        GlobalFunction.buildAmountButton(context, Amount.Pocket, 'Pocket friendly'),
                                        GlobalFunction.buildAmountButton(context, Amount.Premium, 'Premium'),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Column()
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
                    controller: GlobalVariables.getSubscriptionTabController(),
                    children: [
                      Container(
                        color: GlobalVariables.whiteColor,
                        child: GridView.builder(
                            itemCount: GlobalVariables.orders.length,
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
                              final currentOrder =  GlobalVariables.orders[index];
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
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("${currentOrder['Id']}",style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color:GlobalVariables.textColor,
                                          ),),
                                          Row(
                                            children: [
                                              Container(
                                                height:30,
                                                width: 30,
                                                decoration:BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  color: GlobalVariables.primaryColor
                                                ),
                                                child: Center(
                                                  child: Text("${currentOrder['budgetType'] == "Pocket friendly" ? "PF" : currentOrder['budgetType'].toString().substring(0,1)}",style: TextStyle(
                                                      color: GlobalVariables.textColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14
                                                  ),),
                                                ),
                                              ),
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
                                          Text("${currentOrder['CustomerName'] } ",
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


                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                    Container(
                                      height:190,
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: GlobalVariables.orders[index]['Items'].length,
                                        itemBuilder: (_, itemIndex) {
                                          return Container(
                                            padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    '${GlobalVariables.orders[index]['Items'][itemIndex]['itemName']} ',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                ),
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
                                              Text("${GlobalVariables.orders.elementAt(index)['Type']} ",style:SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,

                                                color: Color(0xFF363563),
                                              ) ,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap:(){
                                                      // setState(() {
                                                      //   orders.removeAt(index);
                                                      // });
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
                                                            "Cancel",
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
                        ),
                      ),

                      Column()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
