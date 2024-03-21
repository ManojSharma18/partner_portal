import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/widgets/orders/forecast/item_details_table.dart';
import '../../../constants/global_function.dart';
import '../../../constants/utils.dart';
import '../../menu/live_menu/live_menu.dart';
import '../manage/manage_orderes.dart';

class AnalyseOrders extends StatelessWidget {
  const AnalyseOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc,OrderState>(
      builder: (BuildContext context, state) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 60,
                color: Colors.grey.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 15,),
                        GlobalFunction.buildMealButton(context,MealTime.All,'All'),
                        SizedBox(width: 15,),
                        GlobalFunction.buildMealButton(context,MealTime.Breakfast,'Breakfast'),
                        SizedBox(width: 15,),
                        GlobalFunction.buildMealButton(context,MealTime.Lunch,'Lunch'),
                        SizedBox(width: 15,),
                        GlobalFunction.buildMealButton(context,MealTime.Dinner,'Dinner'),
                        SizedBox(width: 15,),

                      ],
                    ),

                    Container(
                      width: 2,
                      color: GlobalVariables.primaryColor.withOpacity(0.3),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlobalFunction.buildSubscriptionForOrders(context,Subsciption.All, 'All'),
                        SizedBox(width: 15,),
                        GlobalFunction.buildSubscriptionForOrders(context,Subsciption.ForOrders, 'For Orders'),
                        SizedBox(width: 15,),
                        GlobalFunction.buildSubscriptionForOrders(context,Subsciption.Sub, 'Subscriptions'),
                        SizedBox(width: 15,),
                      ],
                    ),

                    Container(
                      width: 2,
                      color: GlobalVariables.primaryColor.withOpacity(0.3),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlobalFunction.buildOrderButton(context,Orders.All, 'All'),
                        SizedBox(width: 15,),
                        GlobalFunction.buildOrderButton(context,Orders.Pickup, 'Pick up'),
                        SizedBox(width: 15,),
                        GlobalFunction.buildOrderButton(context,Orders.All, 'Dine'),
                        SizedBox(width: 15,),
                        GlobalFunction.buildOrderButton(context,Orders.All, 'Deliver'),
                        SizedBox(width: 15,),
                      ],
                    ),

                  ],
                ),
              ),
              Expanded(
                child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                  appBar:  AppBar(
                    backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
                    toolbarHeight: 1,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(50.0),
                      child: Row(
                        children: [
                          Container(
                            width: 400,
                            child: TabBar(
                              labelPadding: EdgeInsets.symmetric(horizontal: 5),
                              indicatorWeight: 5, // Adjust the indicator weight
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
                                Tab(text: "Today",),
                                Tab(text: "Tomorrow",)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                      body: TabBarView(
                        children: [
                          ItemDetailsTable(),
                          DataTable(
                              columns: <DataColumn>[
                                DataColumn(label: Text("ItemName"),),
                                DataColumn(label: Text("Total")),
                                DataColumn(label: Text("Breakfast")),
                                DataColumn(label: Text("Lunch")),
                                DataColumn(label: Text("Dinner"))
                              ],
                              rows: [])
                        ],
                      ),
                )),
              )
            ],
          ),
        );
      },
    );
  }
}
