import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import 'package:partner_admin_portal/bloc/subscription_order/subscription_order_state.dart';
import 'package:partner_admin_portal/constants/order_constants/subscription_cards.dart';

import '../../../bloc/subscription_order/subscription_order_bloc.dart';
import '../../../bloc/subscription_order/subscription_order_event.dart';
import '../../../constants/global_function.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/order_constants/subscription_variables.dart';
import '../../../constants/utils.dart';
import '../../../repository/order_service.dart';
import '../../menu/live_menu/live_menu.dart';
import 'manage_orderes.dart';
import '../../responsive_builder.dart';

class ManageSubscription extends StatefulWidget {
  final String query;
  const ManageSubscription({Key? key, required this.query}) : super(key: key);

  @override
  State<ManageSubscription> createState() => _ManageSubscriptionState();
}

class _ManageSubscriptionState extends State<ManageSubscription> with SingleTickerProviderStateMixin {
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 0;

  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return  BlocProvider(
      create: (BuildContext context) => SubscriptionOrdersBloc(
          OrderService()
      )..add(LoadSubscriptionOrdersEvent()),
      child: BlocBuilder<SubscriptionOrdersBloc,SubscriptionOrdersState>(builder: (BuildContext context, orderState) {
        if(orderState is SubscriptionOrdersLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(orderState is ErrorState) {
          return const Center(child: Text("Node server error"),);
        }
        if(orderState is SubscriptionOrdersLoadedState){
          print("IN subscription order state ${orderState.orders}");
          filters(orderState);
         return ResponsiveBuilder(
              mobileBuilder: (BuildContext context,BoxConstraints constraint){
                return Column();
              }, tabletBuilder:  (BuildContext context,BoxConstraints constraint) {
            return BlocBuilder<OrderBloc,OrderState>(builder: (BuildContext context, OrderState state) {
              filters(orderState);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
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
                                    controller: _tabController,
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
                                  controller: _tabController,
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
                                                GlobalFunction.buildOrderButton(context,Orders.Dinein, 'Dine'),
                                                GlobalFunction.buildOrderButton(context,Orders.Deliver, 'Deliver'),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GlobalFunction.buildInProgressButton(context, InProgress.All, 'All'),
                                              GlobalFunction.buildInProgressButton(context, InProgress.YetToStart, 'Yet to start'),
                                              GlobalFunction.buildInProgressButton(context, InProgress.Preparing, 'Preparing'),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            child:  Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                GlobalFunction.buildInProgressButton(context, InProgress.Ready, 'Ready'),
                                                GlobalFunction.buildInProgressButton(context, InProgress.DeliveyOut, 'Delivery Out'),
                                                GlobalFunction.buildInProgressButton(context, InProgress.PickedUp, 'Picked up'),
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
                                          SizedBox(height: 10,),
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                GlobalFunction.buildAmountButton(context, Amount.Budget, 'Budget'),
                                                GlobalFunction.buildAmountButton(context, Amount.Luxury, 'Luxury'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                GlobalFunction.buildOrderButton(context,Orders.Dinein, 'Dine'),
                                                GlobalFunction.buildOrderButton(context,Orders.Deliver, 'Deliver'),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                GlobalFunction.buildClosedButton(context, Closed.All, "All"),
                                                GlobalFunction.buildClosedButton(context, Closed.Cancelled, "Cancelled"),
                                                GlobalFunction.buildClosedButton(context, Closed.Completed, "Completed"),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                GlobalFunction.buildClosedButton(context, Closed.inCompleted, "In completed"),
                                                GlobalFunction.buildClosedButton(context, Closed.Rejected, "Rejected"),
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
                                          SizedBox(height: 10,),
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                GlobalFunction.buildAmountButton(context, Amount.Budget, 'Budget'),
                                                GlobalFunction.buildAmountButton(context, Amount.Luxury, 'Luxury'),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
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
                            controller: _tabController,
                            children: [
                              Container(
                                color: GlobalVariables.whiteColor,
                                child: GridView.builder(
                                    itemCount: SubscriptionVariables.filteredInprogressOrders.length,
                                    scrollDirection: Axis.vertical,
                                    padding: EdgeInsets.all(20),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        crossAxisSpacing: 20,
                                        mainAxisExtent: 430,
                                        childAspectRatio: 5,
                                        mainAxisSpacing: 30
                                    ),
                                    itemBuilder: (context,index) {
                                      final currentOrder =  SubscriptionVariables.filteredInprogressOrders[index];
                                      return SubscriptionCards(currentOrder: currentOrder, index: index, type: 'Inprogress', filteredList: SubscriptionVariables.filteredInprogressOrders,);
                                    }
                                ),
                              ),

                              Container(
                                color: GlobalVariables.whiteColor,
                                child: GridView.builder(
                                    itemCount: SubscriptionVariables.filteredClosedOrders.length,
                                    scrollDirection: Axis.vertical,
                                    padding: EdgeInsets.all(20),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        crossAxisSpacing: 20,
                                        mainAxisExtent: 430,
                                        childAspectRatio: 5,
                                        mainAxisSpacing: 30
                                    ),
                                    itemBuilder: (context,index) {
                                      final currentOrder =  SubscriptionVariables.filteredClosedOrders[index];
                                      return SubscriptionCards(currentOrder: currentOrder, index: index, type: 'Closed', filteredList: SubscriptionVariables.filteredClosedOrders,);
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },

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
                                  controller: _tabController,
                                  physics: NeverScrollableScrollPhysics(),
                                  tabs: [
                                    Tab(text: 'In progress'),
                                    Tab(text: 'Closed'),

                                  ],
                                ),
                              ),
                              body: TabBarView(
                                controller: _tabController,
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
                                              GlobalFunction.buildOrderButton(context,Orders.Dinein, 'Dine'),
                                              GlobalFunction.buildOrderButton(context,Orders.Deliver, 'Deliver'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GlobalFunction.buildInProgressButton(context, InProgress.All, 'All'),
                                            GlobalFunction.buildInProgressButton(context, InProgress.YetToStart, 'Yet to start'),
                                            GlobalFunction.buildInProgressButton(context, InProgress.Preparing, 'Preparing'),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child:  Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GlobalFunction.buildInProgressButton(context, InProgress.Ready, 'Ready'),
                                              GlobalFunction.buildInProgressButton(context, InProgress.DeliveyOut, 'Delivery Out'),
                                              GlobalFunction.buildInProgressButton(context, InProgress.PickedUp, 'Picked up'),
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
                                        SizedBox(height: 10,),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              GlobalFunction.buildAmountButton(context, Amount.Budget, 'Budget'),
                                              GlobalFunction.buildAmountButton(context, Amount.Luxury, 'Luxury'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                              GlobalFunction.buildOrderButton(context,Orders.Dinein, 'Dine'),
                                              GlobalFunction.buildOrderButton(context,Orders.Deliver, 'Deliver'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GlobalFunction.buildClosedButton(context, Closed.All, "All"),
                                              GlobalFunction.buildClosedButton(context, Closed.Cancelled, "Cancelled"),
                                              GlobalFunction.buildClosedButton(context, Closed.Completed, "Completed"),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              GlobalFunction.buildClosedButton(context, Closed.inCompleted, "In completed"),
                                              GlobalFunction.buildClosedButton(context, Closed.Rejected, "Rejected"),
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
                                        SizedBox(height: 10,),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              GlobalFunction.buildAmountButton(context, Amount.Budget, 'Budget'),
                                              GlobalFunction.buildAmountButton(context, Amount.Luxury, 'Luxury'),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
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
                          controller: _tabController,
                          children: [
                            Container(
                              color: GlobalVariables.whiteColor,
                              child: GridView.builder(
                                  itemCount: SubscriptionVariables.filteredInprogressOrders.length,
                                  scrollDirection: Axis.vertical,
                                  padding: EdgeInsets.all(20),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 20,
                                      mainAxisExtent: 430,
                                      childAspectRatio: 5,
                                      mainAxisSpacing: 30
                                  ),
                                  itemBuilder: (context,index) {
                                    final currentOrder =  SubscriptionVariables.filteredInprogressOrders[index];
                                    return SubscriptionCards(currentOrder: currentOrder, index: index, type: 'Inprogress', filteredList: SubscriptionVariables.filteredInprogressOrders,);
                                  }
                              ),
                            ),

                            Container(
                              color: GlobalVariables.whiteColor,
                              child: GridView.builder(
                                  itemCount: SubscriptionVariables.filteredClosedOrders.length,
                                  scrollDirection: Axis.vertical,
                                  padding: EdgeInsets.all(20),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 20,
                                      mainAxisExtent: 430,
                                      childAspectRatio: 5,
                                      mainAxisSpacing: 30
                                  ),
                                  itemBuilder: (context,index) {
                                    final currentOrder =  SubscriptionVariables.filteredClosedOrders[index];
                                    return SubscriptionCards(currentOrder: currentOrder, index: index, type: 'Closed', filteredList: SubscriptionVariables.filteredClosedOrders,);
                                  }
                              ),
                            ),
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
        return Container();
      },

      ),
    );
  }

    void filters(SubscriptionOrdersLoadedState state) {

    if (widget.query != null && widget.query.isNotEmpty) {
      // Apply filtering only if widget.query is not empty
      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return order['number'].contains(widget.query) ||
            order['Id'].toString().toLowerCase().contains(widget.query) ||
            order['CustomerName'].toString().toLowerCase().contains(widget.query) ||
            order['CustomerName'].toString().contains(widget.query);
      }).toList();

      SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
        return order['number'].contains(widget.query) ||
            order['Id'].toString().toLowerCase().contains(widget.query) ||
            order['CustomerName'].toString().toLowerCase().contains(widget.query) ||
            order['CustomerName'].toString().contains(widget.query);
      }).toList();

    }
    else {
      SubscriptionVariables.filteredInprogressOrders = state.ordersList;
      SubscriptionVariables.filteredClosedOrders = state.closedList;
    }

    if (GlobalFunction.selectedMealTime == MealTime.Breakfast) {
      mealSessionFilters(state, 'Breakfast');
    }
    else if (GlobalFunction.selectedMealTime == MealTime.Lunch) {
      mealSessionFilters(state, 'Lunch');
    }
    else if (GlobalFunction.selectedMealTime == MealTime.Dinner) {
      mealSessionFilters(state, 'Dinner');
    }
    else if(GlobalFunction.selectedSession == MealSession.Session1) {
      sessionFilter(state, "s1");
    }else if(GlobalFunction.selectedSession == MealSession.Session2) {
      sessionFilter(state, "s2");
    }else if(GlobalFunction.selectedSession == MealSession.Session3) {
      sessionFilter(state, "s3");
    }else if(GlobalFunction.selectedSession == MealSession.Session4) {
      sessionFilter(state, "s4");
    } else  if(GlobalFunction.selectedClosed == Closed.Rejected) {
      SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
        return  order['Status'].contains('Rejected');
      }).toList();
    }
    else if(GlobalFunction.selectedClosed == Closed.Completed) {
      SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
        return order['Status'].contains('Completed') ;
      }).toList();
    }
    else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
      SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
        return  order['Status'].contains('Canceled');
      }).toList();
    }
    else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
      SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
        return order['Status'].contains('Incomplete');
      }).toList();
    }
    else if(GlobalFunction.selectedAmount == Amount.Budget) {

      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return order['budgetType'].contains('Budget');
      }).toList();

      SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
        return order['budgetType'].contains('Budget');
      }).toList();
    }
    else if(GlobalFunction.selectedAmount == Amount.Premium) {

      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return order['budgetType'].contains('Premium');
      }).toList();

      SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
        return order['budgetType'].contains('Premium');
      }).toList();
    }
    else if(GlobalFunction.selectedAmount == Amount.Luxury) {

      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return order['budgetType'].contains('Luxury');
      }).toList();

      SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
        return order['budgetType'].contains('Luxury');
      }).toList();
    }
    else if(GlobalFunction.selectedAmount == Amount.Pocket) {

      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return order['budgetType'].contains('Pocket friendly');
      }).toList();

      SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
        return order['budgetType'].contains('Pocket friendly');
      }).toList();
    }
    else if(GlobalFunction.selectedInProgress == InProgress.Ready) {
      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return  order['Status'].contains('Ready');
      }).toList();
    }
    else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut) {
      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return  order['Status'].contains('Delivery out');
      }).toList();
    }
    else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return  order['Status'].contains('Preparing');
      }).toList();
    }
    else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return  order['Status'].contains('Start');
      }).toList();
    }
    else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return  order['Status'].contains('Complete');
      }).toList();
    }
    else if(GlobalFunction.selectedOrders == Orders.Pickup) {
      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return  order['Type'].contains('Pick up');
      }).toList();
    } else if(GlobalFunction.selectedOrders == Orders.Deliver) {
      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return  order['Type'].contains('Deliver');
      }).toList();
    } else if(GlobalFunction.selectedOrders == Orders.Dinein) {
      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return  order['Type'].contains('Dine in');
      }).toList();
    }

  }

    void mealSessionFilters(SubscriptionOrdersLoadedState state,String meal,) {
      if(GlobalFunction.selectedSession == MealSession.All) {
      SubscriptionVariables.filteredInprogressOrders =
          state.ordersList.where((order) {
            return order['Meal'].contains(meal);
          }).toList();

      SubscriptionVariables.filteredClosedOrders =
          state.closedList.where((order) {
            return order['Meal'].contains(meal);
          }).toList();

      if(GlobalFunction.selectedInProgress == InProgress.Ready){
        inprogresFilter(state, meal, 'Ready');
      } else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
           inprogresFilter(state, meal, 'Delivery out');
        }
        else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
          inprogresFilter(state, meal, 'Start');
        }
        else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
           inprogresFilter(state, meal, 'Preparing');
        }
        else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
           inprogresFilter(state, meal, 'Complete');
        }


        if(GlobalFunction.selectedClosed == Closed.Rejected) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Rejected');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.Completed) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Completed');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Canceled');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Incomplete');
          }).toList();
        }

         if(GlobalFunction.selectedAmount == Amount.Budget) {

        SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
          return order['Meal'].contains(meal) && order['budgetType'].contains('Budget');
        }).toList();

        SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
          return  order['Meal'].contains(meal) &&order['budgetType'].contains('Budget');
        }).toList();
      }
         else if(GlobalFunction.selectedAmount == Amount.Premium) {

        SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
          return order['Meal'].contains(meal) && order['budgetType'].contains('Premium');
        }).toList();

        SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
          return  order['Meal'].contains(meal) && order['budgetType'].contains('Premium');
        }).toList();
      }
         else if(GlobalFunction.selectedAmount == Amount.Luxury) {

        SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
          return order['Meal'].contains(meal) &&order['budgetType'].contains('Luxury');
        }).toList();

        SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
          return  order['Meal'].contains(meal) && order['budgetType'].contains('Luxury');
        }).toList();
      }
         else if(GlobalFunction.selectedAmount == Amount.Pocket) {

        SubscriptionVariables.filteredInprogressOrders = state.ordersList.where(( order) {
          return order['Meal'].contains(meal) && order['budgetType'].contains('Pocket friendly');
        }).toList();

        SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
          return order['Meal'].contains(meal) && order['budgetType'].contains('Pocket friendly');
        }).toList();
      }

      }
      else if(GlobalFunction.selectedSession == MealSession.Session1) {

          SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
          return order['Meal'].contains(meal) && order['Session'].contains('s1');
        }).toList();

          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
          return order['Meal'].contains(meal) && order['Session'].contains('s1');
        }).toList();

        if(GlobalFunction.selectedInProgress == InProgress.Ready) {
          inprogresFilter(state, meal, 'Ready',session: 's1');
        }
        else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
         inprogresFilter(state, meal, 'Delivery out',session: 's1');
        }
        else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
          inprogresFilter(state, meal, 'Start',session: 's1');
        }
        else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
          inprogresFilter(state, meal, 'Preparing',session: 's1');
        }
        else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
          inprogresFilter(state, meal, 'Complete',session: 's1');
        }

        if(GlobalFunction.selectedClosed == Closed.Rejected) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Rejected') && order['Session'].contains('s1');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.Completed) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Completed') && order['Session'].contains('s1');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Canceled') && order['Session'].contains('s1');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Incomplete') && order['Session'].contains('s1');
          }).toList();
        }

          if(GlobalFunction.selectedAmount == Amount.Budget) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Budget')  && order['Session'].contains('s1');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return  order['Meal'].contains(meal) &&order['budgetType'].contains('Budget')  && order['Session'].contains('s1');
            }).toList();
          }
          else if(GlobalFunction.selectedAmount == Amount.Premium) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Premium')  && order['Session'].contains('s1');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return  order['Meal'].contains(meal) && order['budgetType'].contains('Premium')  && order['Session'].contains('s1');
            }).toList();
          }
          else if(GlobalFunction.selectedAmount == Amount.Luxury) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
              return order['Meal'].contains(meal) &&order['budgetType'].contains('Luxury')  && order['Session'].contains('s1');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return  order['Meal'].contains(meal) && order['budgetType'].contains('Luxury')  && order['Session'].contains('s1');
            }).toList();
          }
          else if(GlobalFunction.selectedAmount == Amount.Pocket) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where(( order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Pocket friendly')  && order['Session'].contains('s1');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Pocket friendly') && order['Session'].contains('s1') ;
            }).toList();
          }

      }
      else if(GlobalFunction.selectedSession == MealSession.Session2) {


          SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
          return order['Meal'].contains(meal) && order['Session'].contains('s2');
        }).toList();

          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
          return order['Meal'].contains(meal) && order['Session'].contains('s2');
        }).toList();

          if(GlobalFunction.selectedInProgress == InProgress.Ready) {
            inprogresFilter(state, meal, 'Ready',session: 's2');
          }
          else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
            inprogresFilter(state, meal, 'Delivery out',session: 's2');
          }
          else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
            inprogresFilter(state, meal, 'Start',session: 's2');
          }
          else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
            inprogresFilter(state, meal, 'Preparing',session: 's2');
          }
          else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
            inprogresFilter(state, meal, 'Complete',session: 's2');
          }

        if(GlobalFunction.selectedClosed == Closed.Rejected) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Rejected') && order['Session'].contains('s2');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.Completed) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Completed') && order['Session'].contains('s2');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Canceled') && order['Session'].contains('s2');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Incomplete') && order['Session'].contains('s2');
          }).toList();
        }

          if(GlobalFunction.selectedAmount == Amount.Budget) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Budget')  && order['Session'].contains('s2');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return  order['Meal'].contains(meal) &&order['budgetType'].contains('Budget')  && order['Session'].contains('s2');
            }).toList();
          }
          else if(GlobalFunction.selectedAmount == Amount.Premium) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Premium')  && order['Session'].contains('s2');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return  order['Meal'].contains(meal) && order['budgetType'].contains('Premium')  && order['Session'].contains('s2');
            }).toList();
          }
          else if(GlobalFunction.selectedAmount == Amount.Luxury) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
              return order['Meal'].contains(meal) &&order['budgetType'].contains('Luxury')  && order['Session'].contains('s3');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return  order['Meal'].contains(meal) && order['budgetType'].contains('Luxury')  && order['Session'].contains('s3');
            }).toList();
          }
          else if(GlobalFunction.selectedAmount == Amount.Pocket) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where(( order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Pocket friendly')  && order['Session'].contains('s4');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Pocket friendly') && order['Session'].contains('s4') ;
            }).toList();
          }

      }
      else if(GlobalFunction.selectedSession == MealSession.Session3) {


          SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
          return order['Meal'].contains(meal) && order['Session'].contains('s3');
        }).toList();

          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
          return order['Meal'].contains(meal) && order['Session'].contains('s3');
        }).toList();

          if(GlobalFunction.selectedInProgress == InProgress.Ready) {
            inprogresFilter(state, meal, 'Ready',session: 's3');
          }
          else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
            inprogresFilter(state, meal, 'Delivery out',session: 's3');
          }
          else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
            inprogresFilter(state, meal, 'Start',session: 's3');
          }
          else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
            inprogresFilter(state, meal, 'Preparing',session: 's3');
          }
          else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
            inprogresFilter(state, meal, 'Complete',session: 's3');
          }

        if(GlobalFunction.selectedClosed == Closed.Rejected) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Rejected') && order['Session'].contains('s3');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.Completed) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Completed') && order['Session'].contains('s3');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Canceled') && order['Session'].contains('s3');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Incomplete') && order['Session'].contains('s3');
          }).toList();
        }

          if(GlobalFunction.selectedAmount == Amount.Budget) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Budget')  && order['Session'].contains('s3');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return  order['Meal'].contains(meal) &&order['budgetType'].contains('Budget')  && order['Session'].contains('s3');
            }).toList();
          }
          else if(GlobalFunction.selectedAmount == Amount.Premium) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Premium')  && order['Session'].contains('s3');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return  order['Meal'].contains(meal) && order['budgetType'].contains('Premium')  && order['Session'].contains('s3');
            }).toList();
          }
          else if(GlobalFunction.selectedAmount == Amount.Luxury) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
              return order['Meal'].contains(meal) &&order['budgetType'].contains('Luxury')  && order['Session'].contains('s3');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return  order['Meal'].contains(meal) && order['budgetType'].contains('Luxury')  && order['Session'].contains('s3');
            }).toList();
          }
          else if(GlobalFunction.selectedAmount == Amount.Pocket) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where(( order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Pocket friendly')  && order['Session'].contains('s3');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Pocket friendly') && order['Session'].contains('s3') ;
            }).toList();
          }

      }
      else if(GlobalFunction.selectedSession == MealSession.Session4) {

          SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
          return order['Meal'].contains(meal) && order['Session'].contains('s4');
        }).toList();

          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
          return order['Meal'].contains(meal) && order['Session'].contains('s4');
        }).toList();

          if(GlobalFunction.selectedInProgress == InProgress.Ready) {
            inprogresFilter(state, meal, 'Ready',session: 's4');
          }
          else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
            inprogresFilter(state, meal, 'Delivery out',session: 's4');
          }
          else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
            inprogresFilter(state, meal, 'Start',session: 's4');
          }
          else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
            inprogresFilter(state, meal, 'Preparing',session: 's4');
          }
          else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
            inprogresFilter(state, meal, 'Complete',session: 's4');
          }

        if(GlobalFunction.selectedClosed == Closed.Rejected) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Rejected') && order['Session'].contains('s4');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.Completed) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Completed') && order['Session'].contains('s4');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Canceled') && order['Session'].contains('s4');
          }).toList();
        }
        else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
          SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
            return order['Meal'].contains(meal) && order['Status'].contains('Incomplete') && order['Session'].contains('s4');
          }).toList();
        }

          if(GlobalFunction.selectedAmount == Amount.Budget) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Budget')  && order['Session'].contains('s4');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return  order['Meal'].contains(meal) &&order['budgetType'].contains('Budget')  && order['Session'].contains('s4');
            }).toList();
          }
          else if(GlobalFunction.selectedAmount == Amount.Premium) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Premium')  && order['Session'].contains('s4');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return  order['Meal'].contains(meal) && order['budgetType'].contains('Premium')  && order['Session'].contains('s4');
            }).toList();
          }
          else if(GlobalFunction.selectedAmount == Amount.Luxury) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
              return order['Meal'].contains(meal) &&order['budgetType'].contains('Luxury')  && order['Session'].contains('s4');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return  order['Meal'].contains(meal) && order['budgetType'].contains('Luxury')  && order['Session'].contains('s4');
            }).toList();
          }
          else if(GlobalFunction.selectedAmount == Amount.Pocket) {

            SubscriptionVariables.filteredInprogressOrders = state.ordersList.where(( order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Pocket friendly')  && order['Session'].contains('s4');
            }).toList();

            SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
              return order['Meal'].contains(meal) && order['budgetType'].contains('Pocket friendly') && order['Session'].contains('s4') ;
            }).toList();
          }

      }
    }

    void sessionFilter(SubscriptionOrdersLoadedState state,String session){
      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return order['Session'].contains(session);
      }).toList();

      SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
        return order['Session'].contains(session);
      }).toList();

      if(GlobalFunction.selectedAmount == Amount.Budget) {

        SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
          return order['Session'].contains(session) && order['budgetType'].contains('Budget');
        }).toList();

        SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
          return  order['Session'].contains(session) &&order['budgetType'].contains('Budget');
        }).toList();
      }
      else if(GlobalFunction.selectedAmount == Amount.Premium) {

        SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
          return order['Session'].contains(session) && order['budgetType'].contains('Premium')  ;
        }).toList();

        SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
          return  order['Session'].contains(session) && order['budgetType'].contains('Premium') ;
        }).toList();
      }
      else if(GlobalFunction.selectedAmount == Amount.Luxury) {

        SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
          return order['Session'].contains(session) &&order['budgetType'].contains('Luxury');
        }).toList();

        SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
          return  order['Session'].contains(session) && order['budgetType'].contains('Luxury');
        }).toList();
      }
      else if(GlobalFunction.selectedAmount == Amount.Pocket) {

        SubscriptionVariables.filteredInprogressOrders = state.ordersList.where(( order) {
          return order['Session'].contains(session) && order['budgetType'].contains('Pocket friendly');
        }).toList();

        SubscriptionVariables.filteredClosedOrders = state.closedList.where((order) {
          return order['Session'].contains(session) && order['budgetType'].contains('Pocket friendly');
        }).toList();
      }

    }

    void inprogresFilter(SubscriptionOrdersLoadedState state,String meal,String status, {String? session}) {
      SubscriptionVariables.filteredInprogressOrders = state.ordersList.where((order) {
        return order['Meal'].contains(meal) && order['Status'].contains(status) && order['Session'].contains(session);
      }).toList();
    }

}
