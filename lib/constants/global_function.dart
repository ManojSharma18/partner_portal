import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_event.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import 'package:partner_admin_portal/constants/utils.dart';
import 'package:partner_admin_portal/widgets/custom_textfield.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/custom_button.dart';
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

  static void showSnackBar(BuildContext context,String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 1800),
        content: Text(
          content,
          style: GlobalVariables.dataItemStyle,
        ),
        backgroundColor: GlobalVariables.primaryColor, // Set your custom background color
        behavior: SnackBarBehavior.floating, // Make the Snackbar floating
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),

      ),
    );
  }

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
            backgroundColor: GlobalVariables.whiteColor,
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
            backgroundColor: GlobalVariables.whiteColor,
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

  static showHolidayMessage(BuildContext context) {
    DateTime today = DateTime.now();
    showDialog(
        context: context,
        builder: (contexts) {
          return AlertDialog(
            backgroundColor: GlobalVariables.whiteColor,
            title: Text("Set vecation",style: SafeGoogleFont(
              'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: GlobalVariables.primaryColor,
            ),),
            content: Container(
              width: 450,
              height: 600,
              child: DefaultTabController(
                length: 2, // Number of tabs
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: GlobalVariables.primaryColor.withOpacity(0.3),
                    toolbarHeight: 1,
                    bottom: TabBar(
                      labelPadding: EdgeInsets.symmetric(horizontal: 5),

                      // Adjust the indicator weight
                      indicatorColor: Color(0xfffbb830),
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: Colors.black54,
                      labelColor: Color(0xFF363563),
                      labelStyle: SafeGoogleFont(
                        'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF363563),
                      ),
                      tabs: [
                        Tab(text: 'Week'),
                        Tab(text: 'Range',)
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Container(
                                      width: 150,
                                      child: Text('${DateFormat('EEE').format(today.add(Duration(days: 0)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 0)))}',style: GlobalVariables.dataItemStyle,)),

                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(value: true, onChanged: (val){

                                    }),
                                  ),
                                  SizedBox(width: 130),
                                  Checkbox(value: false, onChanged: (val) {

                                  })
                                ],
                              ),
                              SizedBox(height: 10,),

                              DataTable(
                                dataRowHeight: 80,
                                columnSpacing: 10,

                                border: TableBorder.all(
                                    color: Colors.black12,
                                    width: 1,
                                    style: BorderStyle.solid,
                                    borderRadius: BorderRadius.circular(10)),
                                columns: [
                                  DataColumn(label: Container(width: 60,child: Text(''))),
                                  DataColumn(label: Container(width: 65,child: Text(''))),
                                  DataColumn(label: Container(
                                    width: 65,
                                    child: Center(
                                      child: Text("Orders",style: SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color:GlobalVariables.textColor,
                                      ),),
                                    ),
                                  ),),
                                  DataColumn(label:
                                  Container(
                                    width: 75,
                                    child: Center(
                                      child: Text("Subscription",style: SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color:GlobalVariables.textColor,
                                      ),),
                                    ),
                                  ),),
                                ],
                                rows: [
                                  DataRow(cells: [
                                    DataCell(Container(
                                        width: 60,
                                        child: Text("Breakfast",style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: GlobalVariables.textColor,
                                        ),)),),
                                    DataCell(
                                      Column(
                                        children: [
                                          Transform.scale(
                                            scale: 0.6,
                                            child: Switch(value: true, onChanged: (val){

                                            }),
                                          ),
                                          SizedBox(height: 5,),
                                          Text("\u20B9 2000")
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              buildSession1(true),
                                              SizedBox(height: 5,),
                                              Text("\u20B9 200")
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              buildSession1(false),
                                              SizedBox(height: 5,),
                                              Text("\u20B9 2000")
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Container(
                                        width: 60,
                                        child: Text("Lunch",style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: GlobalVariables.textColor,
                                        ),)),),
                                    DataCell(
                                      Column(
                                        children: [
                                          Transform.scale(
                                            scale: 0.6,
                                            child: Switch(value: true, onChanged: (val){

                                            }),
                                          ),
                                          SizedBox(height: 5,),
                                          Text("\u20B9 2000")
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              buildSession1(true),
                                              SizedBox(height: 5,),
                                              Text("\u20B9 200")
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              buildSession1(false),
                                              SizedBox(height: 5,),
                                              Text("\u20B9 2000")
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(
                                      Container(
                                          width: 60,
                                          child: Text("Dinner",style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: GlobalVariables.textColor,
                                          ),)),),
                                    DataCell(
                                      Column(
                                        children: [
                                          Transform.scale(
                                            scale: 0.6,
                                            child: Switch(value: true, onChanged: (val){

                                            }),
                                          ),
                                          SizedBox(height: 5,),
                                          Text("\u20B9 2000")
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              buildSession1(true),
                                              SizedBox(height: 5,),
                                              Text("\u20B9 200")
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              buildSession1(false),
                                              SizedBox(height: 5,),
                                              Text("\u20B9 2000")
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),

                                ],
                              ),



                              SizedBox(height: 15,),
                              Row(
                                children: [
                                  Container(
                                      width: 150,
                                      child: Text('${DateFormat('EEE').format(today.add(Duration(days: 1)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 1)))}',style: GlobalVariables.dataItemStyle,)),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(value: true, onChanged: (val){

                                    }),
                                  ),
                                  SizedBox(width: 130,),
                                  Checkbox(value: true, onChanged: (val) {

                                  })
                                ],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                children: [
                                  Container(
                                      width: 150,
                                      child: Text('${DateFormat('EEE').format(today.add(Duration(days: 2)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 2)))}',style: GlobalVariables.dataItemStyle,)),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(value: true, onChanged: (val){

                                    }),
                                  ),
                                  SizedBox(width: 130),
                                  Checkbox(value: true, onChanged: (val) {

                                  })
                                ],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                children: [
                                  Container(
                                      width: 150,
                                      child: Text('${DateFormat('EEE').format(today.add(Duration(days: 3)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 3)))}',style: GlobalVariables.dataItemStyle,)),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(value: true, onChanged: (val){

                                    }),
                                  ),
                                  SizedBox(width: 130),
                                  Checkbox(value: true, onChanged: (val) {

                                  })
                                ],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                children: [
                                  Container(
                                      width: 150,
                                      child: Text('${DateFormat('EEE').format(today.add(Duration(days: 4)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 4)))}',style: GlobalVariables.dataItemStyle,)),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(value: true, onChanged: (val){

                                    }),
                                  ),
                                  SizedBox(width: 130),
                                  Checkbox(value: true, onChanged: (val) {

                                  })
                                ],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                children: [
                                  Container(
                                      width: 150,
                                      child: Text('${DateFormat('EEE').format(today.add(Duration(days: 5)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 5)))}',style: GlobalVariables.dataItemStyle,)),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(value: true, onChanged: (val){

                                    }),
                                  ),
                                  SizedBox(width: 130),
                                  Checkbox(value: true, onChanged: (val) {

                                  })
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 30),
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                CustomTextField(label: "Start Date", controller: TextEditingController(),showCalendar: true,),
                                SizedBox(width: 30,),
                                Column(
                                  children: [
                                    Text("to",style: TextStyle(
                                      fontFamily: 'RenogareSoft',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: GlobalVariables.textColor,
                                    ),),
                                    SizedBox(height: 15,),
                                    Text(":",style: TextStyle(
                                      fontFamily: 'RenogareSoft',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: GlobalVariables.textColor,
                                    ),),
                                  ],
                                ),
                                SizedBox(width: 30,),
                                CustomTextField(label: "End Date", controller: TextEditingController(),showCalendar: true,),
                              ],
                            )
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
            actions: [
              CustomButton(text: "Cancel", onTap: (){
                Navigator.pop(context);
              }, color: Colors.red,textColor: GlobalVariables.textColor,),
              CustomButton(text: "Submit", onTap: (){
                Navigator.pop(context);
              }, color: GlobalVariables.primaryColor,textColor: GlobalVariables.textColor,)
            ],
          );
        });
  }

  static Widget buildSession1(bool offAndOn) {
    return InkWell(
      onTap: () {

      },
      child: Container(
        width: 35,
        height: 30,
        decoration: BoxDecoration(
          color: offAndOn ? GlobalVariables.primaryColor : GlobalVariables.whiteColor,
          border: Border.all(color: GlobalVariables.primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(offAndOn ? 'ON' : 'OFF', style: SafeGoogleFont(
            'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: GlobalVariables.textColor,
          ),),
        ),
      ),
    );
  }
}