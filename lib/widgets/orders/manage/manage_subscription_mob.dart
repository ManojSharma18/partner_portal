import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/manage_orders/order_bloc.dart';
import '../../../bloc/manage_orders/order_state.dart';
import '../../../constants/global_function.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/order_constants/subscription_variables.dart';
import '../../../constants/utils.dart';
import '../../../provider/day_provider.dart';
import '../../menu/live_menu/live_menu.dart';
import 'manage_orderes.dart';

class ManageSubscriptionMobile extends StatelessWidget {
  const ManageSubscriptionMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    DayProvider dayProvider = context.watch<DayProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
        title: Row(
          children: [
            Text( dayProvider.selectedDay,style:SafeGoogleFont(
              'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF363563),
            ),),
            SizedBox(width: 10,),
            InkWell(
              onTap: () {
                showDropdownMenu(context);
              },
              child: Icon(Icons.arrow_drop_down_circle_outlined, color: GlobalVariables.textColor),
            )

          ],
        ),
        actions: [
          Switch(
              activeThumbImage: NetworkImage(
                'https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
              inactiveTrackColor: Colors.grey,
              inactiveThumbImage: NetworkImage(
                'https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
              inactiveThumbColor: GlobalVariables.whiteColor,
              value: GlobalVariables.isOpend,
              onChanged: (val) {
                GlobalVariables.isOpend = val;
              }),
          SizedBox(width: 10,),
          InkWell(
            onTap: (){
              // _showHolidayPopupMenu(context);
              GlobalFunction.showHolidayMessage(context);
            },
            child: Image.asset(
              'assets/images/holidaynew.png',
              width: 25,
              height: 25,color: GlobalVariables.textColor,
            ),
          ),
          SizedBox(width: 10,),
        ],
      ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 350,
                  margin: EdgeInsets.only(left: 0),
                  color: GlobalVariables.primaryColor.withOpacity(0.2),
                  child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar:AppBar(
                        toolbarHeight: 0,
                        backgroundColor:GlobalVariables.primaryColor.withOpacity(0.2),
                        bottom: TabBar(
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
                          tabs: [
                            Tab(text: 'New'),
                            Tab(text: 'In progress'),
                          ],
                        ),
                      ),
                      body: TabBarView(
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
                Expanded(
                  flex: 10,
                  child:  Container(
                    color: GlobalVariables.whiteColor,
                    child: GridView.builder(
                        itemCount: SubscriptionVariables.orders.length,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 20,
                            mainAxisExtent: 400,
                            childAspectRatio: 5,
                            mainAxisSpacing: 30
                        ),
                        itemBuilder: (context,index) {
                          final currentOrder =  SubscriptionVariables.orders[index];
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
                                      Tooltip(
                                          message: "${currentOrder['number']}",
                                          child: Icon(Icons.call,color: Colors.green,size: 20,)
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.person,color: Colors.blue,size: 18,),
                                              SizedBox(width: 5,),
                                              Text("Customer",
                                                style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,

                                                  color: Color(0xFF363563),
                                                ),),
                                            ],
                                          ),
                                          SizedBox(width: 15,),
                                          Row(
                                            children: [
                                              Icon(Icons.delivery_dining,color: Colors.red,size: 18,),
                                              SizedBox(width: 5,),
                                              Text("Driver",
                                                style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,

                                                  color: Color(0xFF363563),
                                                ),),
                                            ],
                                          ),
                                        ],
                                      ),

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
                                    itemCount: SubscriptionVariables.orders[index]['Items'].length,
                                    itemBuilder: (_, itemIndex) {
                                      return Container(
                                        padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width:270*fem,
                                              child: Text(
                                                '${SubscriptionVariables.orders[index]['Items'][itemIndex]['itemName']} ',
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
                                                "${SubscriptionVariables.orders[index]['Items'][itemIndex]['count']}",
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
                                  margin:EdgeInsets.only(left:2*fem,right: 2*fem,bottom: 10,top: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("${SubscriptionVariables.orders.elementAt(index)['Type']} ",style:SafeGoogleFont(
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

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void showDropdownMenu(BuildContext context) async {
    DateTime today = DateTime.now();
    String? newValue = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(450, 50, 600, 0),
      items: <PopupMenuItem<String>>[
        for (String value in ['Today : ${DateFormat('dd MMM').format(today)}',
          '${DateFormat('EEE').format(today.add(Duration(days: 1)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 1)))}',
          '${DateFormat('EEE').format(today.add(Duration(days: 2)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 2)))}',
          '${DateFormat('EEE').format(today.add(Duration(days: 3)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 3)))}',
          '${DateFormat('EEE').format(today.add(Duration(days: 4)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 4)))}',
          '${DateFormat('EEE').format(today.add(Duration(days: 5)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 5)))}',
          '${DateFormat('EEE').format(today.add(Duration(days: 6)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 6)))}'])
          PopupMenuItem<String>(
            value: value,
            child: Text(value,style: SafeGoogleFont(
              'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF363563),
            ),),
          ),
      ],
    );

    if (newValue != null) {

    }
  }
}
