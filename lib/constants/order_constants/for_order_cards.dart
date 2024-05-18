import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import 'package:partner_admin_portal/bloc/orders/orders_bloc.dart';
import 'package:partner_admin_portal/bloc/orders/orders_state.dart';
import 'package:partner_admin_portal/constants/order_constants/order_variables.dart';
import '../../bloc/orders/orders_event.dart';
import '../global_function.dart';
import '../global_variables.dart';
import '../utils.dart';

class ForOrderCard extends StatelessWidget {
  final List<Map<String,dynamic>> filteredList;
  final Map<String,dynamic> currentOrder;
  final int index;
  final String orderStatus;
  double totalAmount = 0.0;
   ForOrderCard({Key? key, required this.currentOrder, required this.index, required this.orderStatus, required this.filteredList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return BlocBuilder<OrdersBloc,OrdersState>(builder: (BuildContext context, OrdersState state) {
      if(state is OrderErrorState){
        return Center(child: Text("Error"),);
      }
      if(state is OrdersLoadedState) {
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
              SizedBox(height: 5,),
              Container(
                margin:EdgeInsets.only(left: 5*fem,right: 5*fem,top: 5,bottom: 5),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.call,color: Colors.green,size: 20,),
                    Row(
                      children: [
                        Tooltip(
                          message: "${currentOrder['number']}",
                          child: Row(
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
                        ),
                        SizedBox(width: 15,),
                        Tooltip(
                          message: "${currentOrder['d_mob']}",
                          child: Row(
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
                  itemCount: currentOrder['Items'].length,
                  itemBuilder: (_, itemIndex) {
                    int serialNumber = itemIndex + 1;
                    totalAmount +=currentOrder['Items'][itemIndex]['price'] ;
                    return Container(
                      padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width:45*fem,
                            child: Text(
                              '${serialNumber}. ${currentOrder['Items'][itemIndex]['itemName']} ',
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
              Container(
                height: 0.5,
                color: GlobalVariables.primaryColor,
              ),

              Container(
                margin:EdgeInsets.only(top: 10,bottom: 10),
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
                        child: orderStatus == "New" ?  Icon(Icons.timelapse_outlined,color: Colors.blueGrey,size: 20,) : orderStatus == "Closed" ?
                        Icon( currentOrder['Status'] == "Completed" ? Icons.done_all_outlined : Icons.cancel,color: currentOrder['Status'] == "Completed" ? Colors.green : Colors.red,size: 20,)
                            : Icon(
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
                              : Colors.blueGrey,size: 20,)
                    ),

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
                            orderStatus == "New" ? GlobalFunction.showOrderItems(index,currentOrder, 200, context,totalAmount) : orderStatus == "Closed" ? GlobalFunction.showItemsInprogressAndClosed(index, 200, context, state.closedList,totalAmount) : GlobalFunction.showItemsInprogressAndClosed(index, 200, context, state.inprogressList,totalAmount);
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
                        orderStatus == "New"
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap:(){
                                context.read<OrdersBloc>().add(OrdersRejectEvent(state.ordersList,state.inprogressList, index,state.closedList,currentOrder['Id']));
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
                              onTap:() async{
                                context.read<OrdersBloc>().add(OrdersAcceptEvent(state.ordersList, state.inprogressList, state.closedList, index, currentOrder['Id']));
                                print("-------- ${currentOrder['_id']}");
                                await OrderVariables.orderService.updateOrder(currentOrder['_id'], { "fp_unit_ford_status" : "Start"});
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
                            : orderStatus == "Closed"
                            ? Row(
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
                                  color: currentOrder['Status'] == "Completed" ? Colors.green : Colors.red,

                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                                  child: Center(
                                    child: Text(
                                      "${currentOrder['Status']}",
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
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap:(){
                                 context.read<OrdersBloc>().add(OrdersCancelEvent(state.ordersList,state.inprogressList,index,state.closedList,currentOrder['Id']));
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
                            SizedBox(width: 2*fem,),
                            InkWell(
                              onTap:() {
                                if(filteredList[index]['Status'] == "Complete") {
                                  context.read<OrdersBloc>().add(OrdersCompleteEvent(state.ordersList,state.inprogressList, state.closedList, filteredList, index,currentOrder['Id']));

                                } else {
                                  context.read<OrdersBloc>().add(OrdersStatusEvent(state.ordersList,state.inprogressList,state.closedList,filteredList,index,state.inprogressList[index]['Status'],currentOrder['Id']));
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
                                      "${filteredList[index]['Status']}",
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
      return Container();
    },

    );
  }
}
