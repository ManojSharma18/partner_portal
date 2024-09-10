import 'package:flutter/material.dart';

import '../../../constants/global_function.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../orders/forecast/item_details_table.dart';
import '../../orders/manage/manage_orderes.dart';

class Forecast extends StatefulWidget {
  const Forecast({super.key});

  @override
  State<Forecast> createState() => _ForecastState();
}

class _ForecastState extends State<Forecast> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade100
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.white,
                    child: DefaultTabController(
                      length: 1,
                      child: Scaffold(
                        appBar:AppBar(
                          toolbarHeight: 0,
                          backgroundColor:GlobalVariables.primaryColor.withOpacity(0.2),
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(50.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 1,
                                  child: TabBar(
                                    isScrollable: false,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    labelPadding: EdgeInsets.symmetric(horizontal: 5),
                                    indicatorColor: Color(0xfffbb830),
                                    unselectedLabelColor: Colors.black54,
                                    labelColor: Color(0xFF363563),
                                    labelStyle: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF363563),
                                    ),
                                    tabs: [
                                      Tab(text: ''),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 30,),
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
                                SizedBox(width: 30,),

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
                        ),
                        body: TabBarView(
                          children: [
                            Container(
                              color: GlobalVariables.whiteColor,
                              child: Column(
                                children: [

                                  Expanded(child: ItemDetailsTable(loaded: true,)),
                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black26,
                  width: 1,
                ),
                Container(
                  color: Colors.black26,
                  width: 1,
                ),

              ],
            ),
          ),


        ],
      ),


    );
  }
}
