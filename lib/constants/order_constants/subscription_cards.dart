import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/subscription_order/subscription_order_bloc.dart';
import 'package:partner_admin_portal/bloc/subscription_order/subscription_order_event.dart';
import 'package:partner_admin_portal/bloc/subscription_order/subscription_order_state.dart';
import 'package:partner_admin_portal/constants/order_constants/subscription_variables.dart';

import '../global_function.dart';
import '../global_variables.dart';
import '../utils.dart';

class SubscriptionCards extends StatelessWidget {
  final List<Map<String,dynamic>> filteredList;
  final Map<String,dynamic> currentOrder;
  final int index;
  final String type;
  const SubscriptionCards({Key? key, required this.currentOrder, required this.index, required this.type, required this.filteredList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return BlocBuilder<SubscriptionOrdersBloc,SubscriptionOrdersState>(builder: (BuildContext context, orderState) {

      if(orderState is SubscriptionOrdersLoadingState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if(orderState is ErrorState) {
        return const Center(child: Text("Node server error"),);
      }
      if(orderState is SubscriptionOrdersLoadedState){

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
              SizedBox(height: 5,),
              Container(
                margin:EdgeInsets.only(left: 5*fem,right: 5*fem,top: 5,bottom: 5),
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
              SizedBox(height: 5,),
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
                  itemCount: currentOrder['Items'].length,
                  itemBuilder: (_, itemIndex) {
                    return Container(
                      padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width:50*fem,
                            child: Text(
                              '${currentOrder['Items'][itemIndex]['itemName']} ',
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
                              "${currentOrder['Items'][itemIndex]['count']}",
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
              SizedBox(height: 5,),

              Container(
                height: 0.5,
                color: GlobalVariables.primaryColor,
              ),

              Container(
                margin:EdgeInsets.only(top: 5,bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      currentOrder['Type'],
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
                        child: type == "Inprogress" ?
                        Icon(
                          filteredList[index]['Status'] == "Start"
                              ? Icons.start_rounded
                              : filteredList[index]['Status'] == "Ready"
                              ? Icons.done_rounded
                              : filteredList[index]['Status'] == "Delivery out"
                              ? Icons.delivery_dining
                              : filteredList[index]['Status'] == "Complete"
                              ? Icons.done_all_outlined
                              : Icons.delivery_dining
                          ,
                          color: filteredList[index]['Status'] == "Start"
                              ? Colors.blueGrey
                              : filteredList[index]['Status'] == "Ready"
                              ? Colors.grey
                              : filteredList[index]['Status'] == "Delivery out"
                              ? Colors.blueGrey
                              : filteredList[index]['Status'] == "Complete"
                              ? Colors.blue
                              : Colors.blueGrey,size: 20,) :
                        Icon(currentOrder['Status'] == "Completed" ? Icons.done_all_outlined : Icons.cancel,color: currentOrder['Status'] == "Completed" ?
                        Colors.green : Colors.red,size: 20,),
                    ),

                  ],
                ),
              ),

              Container(
                color: GlobalVariables.primaryColor.withOpacity(0.5),
                height: 1,
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
                            GlobalFunction.showOrderItemsSubscription(index,currentOrder, 200, context,0.0);
                          },
                          child: Row(
                            children: [
                              Text("Items | ${currentOrder['Items'].length} ",
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
                            Visibility(
                              visible: type == "Inprogress",
                              child: InkWell(
                                onTap:(){
                                  context.read<SubscriptionOrdersBloc>().add(OrderCancelEvent(orderState.ordersList, index, orderState.closedList, currentOrder['Id']));
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
                            ),
                            SizedBox(width: 2*fem,),
                            InkWell(
                              onTap:() {
                                // if(state.inProgressList[index]['Status'] == "Complete") {
                                //   context.read<OrderSubscriptionBloc>().add(OrderCompleteEvent(index));
                                //
                                // }else {
                                //   context.read<OrderSubscriptionBloc>().add(OrderStatusEvent(state.inProgressList, index,"Start"));
                                // }

                                if(currentOrder['Status'] == "Complete") {
                                  context.read<SubscriptionOrdersBloc>().add(OrderCompleteEvent(orderState.ordersList,orderState.closedList,index,currentOrder['Id']));

                                } else {
                                  context.read<SubscriptionOrdersBloc>().add(OrderStatusEvent(orderState.ordersList,orderState.closedList,filteredList, index,"Start",currentOrder['Id']));
                                }



                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: currentOrder['Status'] == "Completed" || type == "Inprogress" ? Colors.green : Colors.red,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                                  child: Center(
                                    child: Text(
                                      currentOrder['Status'],
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

      return Container();
    },

    );
  }
}
