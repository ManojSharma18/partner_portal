import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/orders/orders_state.dart';
import 'package:partner_admin_portal/constants/order_constants/order_variables.dart';
import 'package:partner_admin_portal/constants/utils.dart';
import 'package:partner_admin_portal/repository/order_service.dart';
import 'package:partner_admin_portal/widgets/Forecast_table.dart';
import 'package:partner_admin_portal/widgets/small_custom_textfield.dart';

import '../../bloc/orders/orders_bloc.dart';
import '../../bloc/orders/orders_event.dart';
import '../global_variables.dart';
import '../live_menu_constants/live_menu_variables.dart';

class OrderFunctions {

  static List<Widget> buildItemList(BuildContext context) {
    List<Widget> itemList = [];

    for (var itemDetail in OrderVariables.itemDetails) {
      String itemName = itemDetail["name"];
      itemList.add(buildDismissibleItem1(context, itemName,itemDetail["total"],itemDetail["breakfast"],itemDetail["lunch"],itemDetail["Dinner"]));
    }

    return itemList;
  }

  static Widget buildDismissibleItem1(BuildContext context,String item,int total,int breakfast,int lunch, int dinner)
  {
    TextEditingController totalController = TextEditingController(text: total.toString());
    TextEditingController breakfastController = TextEditingController(text: breakfast.toString());
    TextEditingController lunchController = TextEditingController(text: lunch.toString());
    TextEditingController dinnerController = TextEditingController(text: dinner.toString());
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
    return InkWell(
      onTap: (){

      },
      child: Container(
        margin: EdgeInsets.only(left:10,right: 10,bottom:10),
        decoration: BoxDecoration(
          color: LiveMenuVariables.selectedItem == item ? Colors.grey.shade200 : GlobalVariables.whiteColor,
          borderRadius: BorderRadius.circular(10),boxShadow: [
          BoxShadow(
            color: Colors.grey, // You can set the shadow color here
            blurRadius: 5, // Adjust the blur radius as needed
            offset: Offset(0, 2), // Adjust the offset to control the shadow's position
          ),
        ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: LiveMenuVariables.selectedItem==item,
              child: Container(
                width: 5,
                height:150,
                decoration: BoxDecoration(
                    color:  GlobalVariables.textColor,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),topRight: Radius.circular(30))
                ),
                margin:EdgeInsets.only(left: 10*fem),

              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    margin: EdgeInsets.only(left: 0,top: 10),
                    padding: EdgeInsets.only(left: 0),
                    child: ListTile(
                      title: Container(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                width: 250*fem,
                                child: Text(
                                  item,
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 13*fem,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.textColor,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(total.toString(),style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                          SizedBox(width: 5,),
                          Image(image: AssetImage('assets/images/square.png',),width: 15,height: 15,)
                        ],
                      ),

                      leading: Container(
                        margin: EdgeInsets.fromLTRB(0, 0*fem, 2, 1.5),
                        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration (
                          border: Border.all(color: Color(0xff3d9414)),
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Center(
                          // rectangle1088pGR (946:2202)
                          child: SizedBox(
                            height: 5,
                            width:5,
                            child: Container(
                              decoration: BoxDecoration (
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(color: Color(0xff3d9414)),
                                color: Color(0xff3d9414),
                              ),
                            ),
                          ),
                        ),
                      )

                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.only(left: 25*fem,right: 15*fem),
                    padding: EdgeInsets.only(left: 5*fem,right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(breakfast.toString(),style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color:GlobalVariables.textColor,
                                ),),
                                SizedBox(width: 5,),
                                Image(image: AssetImage('assets/images/triangle.png'),width: 15,height: 15,)
                              ],
                            ),
                            SizedBox(height:10),
                            Text("Breakfast",style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color:GlobalVariables.textColor,
                            ),),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(lunch.toString(),style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color:GlobalVariables.textColor,
                                ),),
                                SizedBox(width: 5,),
                                Image(image: AssetImage('assets/images/down.png'),width: 15,height: 15,)
                              ],
                            ),

                            SizedBox(height: 10,),
                            Container(
                              child: Text("Lunch",style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color:GlobalVariables.textColor,
                              ),),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(dinner.toString(),style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color:GlobalVariables.textColor,
                                ),),
                                SizedBox(width: 5,),
                                Image(image: AssetImage('assets/images/triangle.png'),width: 15,height: 15,)
                              ],
                            ),
                            SizedBox(height: 10,),
                            Text("Dinner",style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color:GlobalVariables.textColor,
                            ),),
                          ],
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Material(child: ForeCastTable())));
                            },
                            child: Icon(Icons.arrow_forward_ios,color: GlobalVariables.textColor.withOpacity(0.9),size: 20,)
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: 20,),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static int compareTime(Map<String, dynamic> a, Map<String, dynamic> b) {
    DateTime timeA = DateFormat('hh:mm a').parse(a['Time']);
    DateTime timeB = DateFormat('hh:mm a').parse(b['Time']);
    return OrderVariables.ascending ? timeA.compareTo(timeB) : timeB.compareTo(timeA);
  }

  static void showFilterAlert(BuildContext OrderContext,BuildContext showContext,) {
    showDialog(
      context: showContext,
      builder: (BuildContext contexts) {
        return BlocProvider(
          create: (BuildContext context) => OrdersBloc(
              OrderService()
          )..add(LoadOrdersEvent()),
          child: BlocBuilder<OrdersBloc,OrdersState>(builder: (BuildContext context, state) {
            if(state is OrdersLoadedState) {
              return AlertDialog(
                content: Container(
                  width: 350,
                  height: 500,
                  child: CustomPopupOrderItem(
                    isPickup: OrderVariables.isPickup,
                    isDeliver: OrderVariables.isDeliver,
                    isDineIn: OrderVariables.isDineIn,
                    onPickupChanged: OrderFunctions.handlePickupChange,
                    onDeliverChanged:OrderFunctions.handleDeliverChange,
                    onDineInChanged: OrderFunctions.handleDineInChange,
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      OrderContext.read<OrdersBloc>().add(LoadOrdersEvent());
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                          color: GlobalVariables.primaryColor,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Text("Set",style: GlobalVariables.dataItemStyle,)),
                    ),
                  )
                ],
              );
            }
            return AlertDialog(
              content: Container(
                width: 350,
                height: 500,
                child: CustomPopupOrderItem(
                  isPickup: OrderVariables.isPickup,
                  isDeliver: OrderVariables.isDeliver,
                  isDineIn: OrderVariables.isDineIn,
                  onPickupChanged: OrderFunctions.handlePickupChange,
                  onDeliverChanged:OrderFunctions.handleDeliverChange,
                  onDineInChanged: OrderFunctions.handleDineInChange,
                ),
              ),
              actions: [

              ],
            );
          },
          ),
        );
      },
    );
  }

  static void handlePickupChange(BuildContext context,bool? value) {
    context.read<OrdersBloc>().add(HandlePickupEvent(context, value!));
  }

  static void handleDeliverChange(BuildContext context,bool? value) {
    context.read<OrdersBloc>().add(HandleDeliverEvent(context, value!));
  }

  static void handleDineInChange(BuildContext context,bool? value) {
    context.read<OrdersBloc>().add(HandleDineInEvent(context, value!));
  }
}

class CustomPopupOrderItem extends StatefulWidget {
  final bool isPickup;
  final bool isDeliver;
  final bool isDineIn;
  final Function(BuildContext, bool?) onPickupChanged;
  final Function(BuildContext, bool?) onDeliverChanged;
  final Function(BuildContext, bool?) onDineInChanged;



  CustomPopupOrderItem({
    required this.isPickup,
    required this.isDeliver,
    required this.isDineIn,
    required this.onPickupChanged, required this.onDeliverChanged, required this.onDineInChanged,
  });

  @override
  State<CustomPopupOrderItem> createState() => _CustomPopupMenuItemState();
}

class _CustomPopupMenuItemState extends State<CustomPopupOrderItem> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => OrdersBloc(
          OrderService()
      )..add(LoadOrdersEvent()),
      child: BlocBuilder<OrdersBloc,OrdersState>(builder: (BuildContext orderContext, state) {
        if(state is OrdersLoadedState)  {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Deliver mode',
                      style: GlobalVariables.headingStyle,
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: OrderVariables.isPickup,
                        onChanged: (bool? value) => widget.onPickupChanged(orderContext, value),
                      ),
                      Text('Pick up',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: OrderVariables.isDeliver,
                        onChanged: (bool? value) => widget.onDeliverChanged(orderContext, value),
                      ),
                      Text('Deliver',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: OrderVariables.isDineIn,
                        onChanged: (bool? value) => widget.onDineInChanged(orderContext, value),
                      ),
                      Text('Dine in',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),


                ],
              ),


            ],
          );
        }
        return  Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Deliver mode',
                    style: GlobalVariables.headingStyle,
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: OrderVariables.isPickup,
                      onChanged: (bool? value) => widget.onPickupChanged(orderContext, value),
                    ),
                    Text('Pick up',style: GlobalVariables.dataItemStyle,),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: OrderVariables.isDeliver,
                      onChanged: (bool? value) => widget.onDeliverChanged(orderContext, value),
                    ),
                    Text('Deliver',style: GlobalVariables.dataItemStyle,),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: OrderVariables.isDineIn,
                      onChanged: (bool? value) => widget.onDineInChanged(orderContext, value),
                    ),
                    Text('Dine in',style: GlobalVariables.dataItemStyle,),
                  ],
                ),


              ],
            ),


          ],
        );
      },

      ),
    );
  }
}
