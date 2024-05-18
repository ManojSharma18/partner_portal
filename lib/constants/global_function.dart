import 'package:flutter/material.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_event.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import 'package:partner_admin_portal/constants/utils.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/orders/manage/manage_orderes.dart';
import 'global_variables.dart';

enum MealSession {
  All,Session1,Session2,Session3,Session4
}

enum InProgress {
  All,YetToStart,Preparing,Ready,DeliveyOut,Delayed,PickedUp
}

enum Closed {
  All,Cancelled,Completed,inCompleted,Rejected
}

enum Amount {
  All,Pocket,Premium,Budget,Luxury
}

enum Subsciption{
  All,ForOrders,Sub
}

class GlobalFunction {

  static MealTime selectedMealTime = MealTime.All;

  static MealSession selectedSession = MealSession.All;

  static InProgress selectedInProgress = InProgress.All;

  static Closed selectedClosed = Closed.All;

  static Orders selectedOrders = Orders.All;

  static Amount selectedAmount = Amount.All;

  static Subsciption selectedSubs = Subsciption.All;

  static Widget buildMealButton(BuildContext context,MealTime mealTime, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedMealTime == mealTime ? GlobalVariables.textColor : selectedMealTime == MealTime.All ? GlobalVariables.textColor : Colors.white;
    return BlocBuilder<OrderBloc,OrderState>(
        builder: (BuildContext context, state) {
          return GestureDetector(
            onTap: () {
              context.read<OrderBloc>().add(BreakfastEvent(mealTime));
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
        },
    );
  }

  static Widget buildSessionButton(BuildContext context,MealSession mealSession, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedSession == mealSession ? GlobalVariables.textColor : selectedSession == MealSession.All ? GlobalVariables.textColor : Colors.white;
    return BlocBuilder<OrderBloc,OrderState>(
      builder: (BuildContext context, state) {
        return GestureDetector(
          onTap: () {
             context.read<OrderBloc>().add(SessionEvent(mealSession));
          },
          child: Container(
            width: 60,
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
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1.3102272749 * ffem / fem,
                  color: GlobalVariables.primaryColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget buildInProgressButton(BuildContext context,InProgress inProgress, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedInProgress == inProgress ? GlobalVariables.textColor : selectedInProgress == InProgress.All ? GlobalVariables.textColor : Colors.white;
    return BlocBuilder<OrderBloc,OrderState>(
      builder: (BuildContext context, state) {
        return GestureDetector(
          onTap: () {
            context.read<OrderBloc>().add(InProgressEvent(inProgress));
          },
          child: Container(
            height: 30,
            width: 90,
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
      },
    );
  }

  static Widget buildClosedButton(BuildContext context,Closed closed, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedClosed == closed ? GlobalVariables.textColor : selectedClosed == Closed.All ? GlobalVariables.textColor : Colors.white;
    return BlocBuilder<OrderBloc,OrderState>(
      builder: (BuildContext context, state) {
        return GestureDetector(
          onTap: () {
            context.read<OrderBloc>().add(ClosedEvent(closed));
          },
          child: Container(
            width: 90,
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
      },
    );
  }

  static Widget buildOrderButton(BuildContext context,Orders orders, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedOrders == orders ? GlobalVariables.textColor : selectedOrders == Orders.All ? GlobalVariables.textColor : Colors.white;
    return GestureDetector(
      onTap: () {
        context.read<OrderBloc>().add(OrderTypeEvent(orders));
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

  static Widget buildAmountButton(BuildContext context,Amount amount, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedAmount == amount ? GlobalVariables.textColor : selectedAmount == Amount.All ? GlobalVariables.textColor : Colors.white;
    return GestureDetector(
      onTap: () {
        context.read<OrderBloc>().add(AmountEvent(amount));
      },
      child: Container(
        width: 100,
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

  static Widget buildSubscriptionForOrders(BuildContext context,Subsciption subs, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedSubs == subs ? GlobalVariables.textColor : selectedSubs == Subsciption.All ? GlobalVariables.textColor : Colors.white;
    return GestureDetector(
      onTap: () {
        context.read<OrderBloc>().add(SubscriptionEvent(subs));
      },
      child: Container(
        width: 110,
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

  static showOrderItems(int index,final Map<String,dynamic> currentOrder,double width,BuildContext context,double sum) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    showDialog(context: context, builder: (BuildContext context) {
      return  BlocBuilder<OrderBloc,OrderState>(
        builder: (BuildContext context, state) {
          print(currentOrder);
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Items | ${currentOrder['Items'].length}", style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF363563),
                ),),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                    child: Icon(Icons.cancel,color: GlobalVariables.textColor,))
              ],
            ),
            content:  Column(
              children: [
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
                  height: 490,
                  width: 400,
                  child: ListView.builder(
                    itemCount: currentOrder['Items'].length,
                    itemBuilder: (_, itemIndex) {
                      double itemPrice = currentOrder['Items'][itemIndex]['price'];
                      sum += itemPrice;
                      print(sum);
                      return Container(
                        padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width:width,
                              child: Text(
                                '${itemIndex+1}. ${currentOrder['Items'][itemIndex]['itemName']} ',
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
                                    "${currentOrder['Items'][itemIndex]['count']} ",
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
                                    '\u20B9 ${currentOrder['Items'][itemIndex]['price']}',
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

              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Total:  \u20B9 ${sum.toStringAsFixed(2)}',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF363563),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Tooltip(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Open Sans',
                          fontSize: 10,
                          color: Colors.white,
                          wordSpacing: 0.23,
                          letterSpacing: 0.23,
                        ),
                        message:  'Including CGST, SGST and delivery charges', // Provide a default value if widget.suffixTooltip is null
                        child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                      ),
                    ],
                  ),
                   Row(
                     children: [
                       InkWell(
                         onTap:(){
                           context.read<OrderBloc>().add(OrderRejectEvent(state.orderList, index,state.closedList,currentOrder['Id']));
                           Navigator.pop(context);
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
                           Navigator.pop(context);
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
                   )
                ],
              ),
            ],
          );
        },
      );
    });

  }

  static showOrderItemsSubscription(int index,final Map<String,dynamic> currentOrder,double width,BuildContext context,double sum) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    showDialog(context: context, builder: (BuildContext context) {
      return  BlocBuilder<OrderBloc,OrderState>(
        builder: (BuildContext context, state) {
          print(currentOrder);
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Items | ${currentOrder['Items'].length}", style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF363563),
                ),),
                InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.cancel,color: GlobalVariables.textColor,))
              ],
            ),
            content:  Column(
              children: [
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
                  height: 470,
                  width: 400,
                  child: ListView.builder(
                    itemCount: currentOrder['Items'].length,
                    itemBuilder: (_, itemIndex) {
                      double itemPrice = currentOrder['Items'][itemIndex]['price'];
                      sum += itemPrice;
                      print(sum);
                      return Container(
                        padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width:width,
                              child: Text(
                                '${itemIndex+1}. ${currentOrder['Items'][itemIndex]['itemName']} ',
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
                                    "${currentOrder['Items'][itemIndex]['count']} ",
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
                                    '\u20B9 ${currentOrder['Items'][itemIndex]['price']}',
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

              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Total:  \u20B9 ${currentOrder['Amount']}',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF363563),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Tooltip(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Open Sans',
                          fontSize: 10,
                          color: Colors.white,
                          wordSpacing: 0.23,
                          letterSpacing: 0.23,
                        ),
                        message:  'Including CGST, SGST and delivery charges', // Provide a default value if widget.suffixTooltip is null
                        child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap:(){
                          // context.read<OrderBloc>().add(OrderRejectEvent(state.orderList, index,state.closedList));
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 100,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: GlobalVariables.primaryColor
                          ),
                          child: Center(
                            child: Text(
                              "Ok",
                              style:SafeGoogleFont(
                                'Poppins',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: GlobalVariables.textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          );
        },
      );
    });

  }

  static showItemsInprogressAndClosed(int index,double width,BuildContext context,List<Map<String,dynamic>> list,double sum) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    showDialog(context: context, builder: (BuildContext context) {
      return  BlocBuilder<OrderBloc,OrderState>(
        builder: (BuildContext context, state) {
          return AlertDialog(
            title: Text("Items | ${list[index]['Items'].length}", style: SafeGoogleFont(
              'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xFF363563),
            ),),
            content:  Column(
              children: [
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
                  height: 480,
                  width: 400,
                  child: ListView.builder(
                    itemCount: list[index]['Items'].length,
                    itemBuilder: (_, itemIndex) {
                      double itemPrice = list[index]['Items'][itemIndex]['price'];
                      sum += itemPrice;
                      return Container(
                        padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width:width,
                              child: Text(
                                '${itemIndex+1}. ${list[index]['Items'][itemIndex]['itemName']} ',
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
                                    "${list[index]['Items'][itemIndex]['count']} ",
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
                                    '\u20B9 ${list[index]['Items'][itemIndex]['price']}',
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
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Total:  \u20B9 ${sum.toStringAsFixed(2)}',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF363563),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Tooltip(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Open Sans',
                          fontSize: 10,
                          color: Colors.white,
                          wordSpacing: 0.23,
                          letterSpacing: 0.23,
                        ),
                        message:  'Including CGST, SGST and delivery charges', // Provide a default value if widget.suffixTooltip is null
                        child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap:(){
                      // context.read<OrderBloc>().add(OrderRejectEvent(state.orderList, index,state.closedList));
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: GlobalVariables.primaryColor
                      ),
                      child: Center(
                        child: Text(
                          "Ok",
                          style:SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: GlobalVariables.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          );
        },
      );
    });

  }
}