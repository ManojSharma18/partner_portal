import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/order_constants/order_funtions.dart';
import 'package:partner_admin_portal/constants/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu.dart';
import '../../../constants/global_function.dart';
import '../../../provider/day_provider.dart';
import '../manage/manage_orderes.dart';

class AnalyseOrdersMobile extends StatelessWidget {
  const AnalyseOrdersMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DayProvider dayProvider = context.watch<DayProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
        title: Row(
          children: [
            Text("${dayProvider.selectedDay}",style:SafeGoogleFont(
              'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF363563),
            ),),
            SizedBox(width: 10,),
            InkWell(
              onTap: () {
                // showDropdownMenu(context);
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
      body: BlocBuilder<OrderBloc,OrderState>(
        builder: (BuildContext context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar:  AppBar(
                        backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
                        toolbarHeight: 1,
                        bottom: TabBar(
                          labelPadding: EdgeInsets.symmetric(horizontal: 5),
                          indicatorWeight: 5, // Adjust the indicator weight
                          indicatorColor: Color(0xfffbb830),
                          unselectedLabelColor: Colors.black54,
                          labelColor: Color(0xFF363563),
                          labelStyle: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF363563),
                          ),
                          tabs: [
                            Tab(text: "Today",),
                            Tab(text: "Tomorrow",)
                          ],
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 5,),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GlobalFunction.buildSubscriptionForOrders(context,Subsciption.All, 'All'),
                                    GlobalFunction.buildSubscriptionForOrders(context,Subsciption.ForOrders, 'For Orders'),
                                    GlobalFunction.buildSubscriptionForOrders(context,Subsciption.Sub, 'Subscriptions'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5,),
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
                              SizedBox(height: 5,),
                              Expanded(
                                child: ListView(
                                  children: [
                                    SizedBox(height: 5),
                                    ...OrderFunctions.buildItemList(context),
                                  ],
                                ),
                              ),


                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(height: 5,),
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
                                margin: EdgeInsets.all(5),
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
                              SizedBox(height: 5,),

                            ],
                          )
                        ],
                      ),
                    )),
              )
            ],
          );
        },
      ),
    );
  }
}
