import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_event.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import 'package:partner_admin_portal/bloc/orders/orders_bloc.dart';
import 'package:partner_admin_portal/bloc/orders/orders_event.dart';
import 'package:partner_admin_portal/bloc/orders/orders_state.dart';
import 'package:partner_admin_portal/constants/global_function.dart';
import 'package:partner_admin_portal/constants/order_constants/for_order_cards.dart';
import 'package:partner_admin_portal/repository/order_service.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu.dart';
import 'package:partner_admin_portal/widgets/orders/manage/manage_orders_mob.dart';
import 'package:partner_admin_portal/widgets/orders/manage/manage_orders_tab.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/order_constants/order_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/order_model.dart';

enum Orders { All,Pickup,Dinein,Deliver}

enum Inprogress {All,Preparing,ReadyToDeliver,OutforDeliver}

class ManageOrders extends StatefulWidget {
  final String query;
  const ManageOrders({Key? key, required this.query}) : super(key: key);

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> with SingleTickerProviderStateMixin {

  Orders selectedOrders = Orders.All;
  Inprogress prepare = Inprogress.All;

  late TabController _tabController;



  String searchedQuery = "";

  OrderService orderService = OrderService();

  List<OrderModel> orders= [];

  void fetchOrders() async {
    orders =  await orderService.fetchOrders();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0;
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return BlocProvider(
      create: (BuildContext context) => OrdersBloc(
          OrderService()
      )..add(LoadOrdersEvent()),
      child: BlocBuilder<OrdersBloc,OrdersState>(builder: (BuildContext context, state) {
        if(state is OrdersLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(state is OrderErrorState) {
          return const Center(child: Text("Node server error"),);
        }
        if(state is OrdersLoadedState) {
          print("I am also here as well");
          return ResponsiveBuilder(
              mobileBuilder: (BuildContext context,BoxConstraints constraint){
                return ManageOrdersMob(tabController: _tabController,  filteredOrders: OrderVariables.filteredOrders, inprogress: GlobalVariables.inprogress);
              },
              tabletBuilder:  (BuildContext context,BoxConstraints constraint){
            OrderVariables.filteredOrders = GlobalVariables.orders.where((order) {
              return order['number'].contains(widget.query) || order['Id'].toString().toLowerCase().contains(widget.query) || order['CustomerName'].toString().toLowerCase().contains(widget.query) || order['CustomerName'].toString().contains(widget.query)  ;
            }).toList();
            return ManageOrdersTab(tabController: _tabController, searchedQuery: widget.query,);
          }, desktopBuilder: (BuildContext context,BoxConstraints constraint){
            if (widget.query != null && widget.query.isNotEmpty) {
              // Apply filtering only if widget.query is not empty
              OrderVariables.filteredOrders = state.ordersList.where((order) {
                return order['number'].contains(widget.query) ||
                    order['Id'].toString().toLowerCase().contains(widget.query) ||
                    order['CustomerName'].toString().toLowerCase().contains(widget.query) ||
                    order['CustomerName'].toString().contains(widget.query);
              }).toList();

              OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                return order['number'].contains(widget.query) ||
                    order['Id'].toString().toLowerCase().contains(widget.query) ||
                    order['CustomerName'].toString().toLowerCase().contains(widget.query) ||
                    order['CustomerName'].toString().contains(widget.query);
              }).toList();

              OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                return order['number'].contains(widget.query) ||
                    order['Id'].toString().toLowerCase().contains(widget.query) ||
                    order['CustomerName'].toString().toLowerCase().contains(widget.query) ||
                    order['CustomerName'].toString().contains(widget.query);
              }).toList();

            }
            else {
              // If widget.query is empty or null, show all items
              OrderVariables.filteredOrders = state.ordersList;
              OrderVariables.filteredInprogressOrders = state.inprogressList;
              OrderVariables.filteredClosedOrders = state.closedList;
            }

            if(GlobalFunction.selectedMealTime == MealTime.Breakfast)
            {

              if(GlobalFunction.selectedSession == MealSession.All) {

                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Breakfast');
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Breakfast');
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Breakfast');
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Ready');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Delivery out');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast') &&
                            order['Status'].contains('Start');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast') &&
                            order['Status'].contains('Preparing');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast') &&
                            order['Status'].contains('Complete');
                      }).toList();
                }

                print("Filterd variv ${OrderVariables.filteredInprogressOrders}");
                print(GlobalFunction.selectedInProgress);

                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Rejected');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Completed');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Canceled');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Incomplete');
                  }).toList();
                }

              }
              else if(GlobalFunction.selectedSession == MealSession.Session1) {

                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Breakfast') && order['Session'].contains('s1');
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Breakfast') && order['Session'].contains('s1');
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Breakfast') && order['Session'].contains('s1');
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Ready') && order['Session'].contains('s1');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Delivery out') && order['Session'].contains('s1');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast') && order['Session'].contains('s1')  &&
                            order['Status'].contains('Start');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast')&& order['Session'].contains('s1')  &&
                            order['Status'].contains('Preparing');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast') && order['Session'].contains('s1')  &&
                            order['Status'].contains('Complete');
                      }).toList();
                }

                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Rejected') && order['Session'].contains('s1');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Completed') && order['Session'].contains('s1');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Canceled') && order['Session'].contains('s1');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Incomplete') && order['Session'].contains('s1');
                  }).toList();
                }

              }
              else if(GlobalFunction.selectedSession == MealSession.Session2) {
                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Breakfast') && order['Session'].contains('s2');
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Breakfast') && order['Session'].contains('s2');
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Breakfast') && order['Session'].contains('s2');
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Ready') && order['Session'].contains('s2');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Delivery out') && order['Session'].contains('s2');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast') && order['Session'].contains('s2')  &&
                            order['Status'].contains('Start');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast')&& order['Session'].contains('s2')  &&
                            order['Status'].contains('Preparing');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast') && order['Session'].contains('s2')  &&
                            order['Status'].contains('Complete');
                      }).toList();
                }

                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Rejected') && order['Session'].contains('s2');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Completed') && order['Session'].contains('s2');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Canceled') && order['Session'].contains('s2');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Incomplete') && order['Session'].contains('s2');
                  }).toList();
                }

              }
              else if(GlobalFunction.selectedSession == MealSession.Session3) {
                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Breakfast') && order['Session'].contains('s3');
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Breakfast') && order['Session'].contains('s3');
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Breakfast') && order['Session'].contains('s3');
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Ready') && order['Session'].contains('s3');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Delivery out') && order['Session'].contains('s3');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast') && order['Session'].contains('s3')  &&
                            order['Status'].contains('Start');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast')&& order['Session'].contains('s3')  &&
                            order['Status'].contains('Preparing');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast') && order['Session'].contains('s3')  &&
                            order['Status'].contains('Complete');
                      }).toList();
                }

                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Rejected') && order['Session'].contains('s3');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Completed') && order['Session'].contains('s3');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Canceled') && order['Session'].contains('s3');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Incomplete') && order['Session'].contains('s3');
                  }).toList();
                }

              }
              else if(GlobalFunction.selectedSession == MealSession.Session4) {
                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Breakfast') && order['Session'].contains('s4');
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Breakfast') && order['Session'].contains('s4');
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Breakfast') && order['Session'].contains('s4');
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Ready') && order['Session'].contains('s4');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Delivery out') && order['Session'].contains('s4');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast') && order['Session'].contains('s4')  &&
                            order['Status'].contains('Start');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast')&& order['Session'].contains('s4')  &&
                            order['Status'].contains('Preparing');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Breakfast') && order['Session'].contains('s4')  &&
                            order['Status'].contains('Complete');
                      }).toList();
                }

                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Rejected') && order['Session'].contains('s4');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Completed') && order['Session'].contains('s4');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Canceled') && order['Session'].contains('s4');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Breakfast') && order['Status'].contains('Incomplete') && order['Session'].contains('s4');
                  }).toList();
                }

              }

            }
            else  if(GlobalFunction.selectedMealTime == MealTime.Lunch)
            {
              if(GlobalFunction.selectedSession == MealSession.All) {
                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Lunch');
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Lunch');
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Lunch');
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Ready');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Delivery out');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Start');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Preparing');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Complete');
                      }).toList();
                }

                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Rejected');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Completed');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Canceled');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Incomplete');
                  }).toList();
                }

              }

              else if(GlobalFunction.selectedSession == MealSession.Session1) {
                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Lunch') && order['Session'].contains('s1') ;
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Lunch') && order['Session'].contains('s1') ;
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Lunch') && order['Session'].contains('s1') ;
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Ready') && order['Session'].contains('s1') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Delivery out') && order['Session'].contains('s1');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Start') && order['Session'].contains('s1') ;
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Preparing') && order['Session'].contains('s1');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Complete') && order['Session'].contains('s1');
                      }).toList();
                }

                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Rejected') && order['Session'].contains('s1');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Completed') && order['Session'].contains('s1');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Canceled') && order['Session'].contains('s1');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Incomplete') && order['Session'].contains('s1');
                  }).toList();
                }
              }

              else if(GlobalFunction.selectedSession == MealSession.Session2){
                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Lunch') && order['Session'].contains('s2') ;
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Lunch') && order['Session'].contains('s2') ;
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Lunch') && order['Session'].contains('s2') ;
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Ready') && order['Session'].contains('s2') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Delivery out') && order['Session'].contains('s2');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Start') && order['Session'].contains('s2') ;
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Preparing') && order['Session'].contains('s2');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Complete') && order['Session'].contains('s2');
                      }).toList();
                }

                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Rejected') && order['Session'].contains('s2');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Completed') && order['Session'].contains('s2');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Canceled') && order['Session'].contains('s2');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Incomplete') && order['Session'].contains('s2');
                  }).toList();
                }
              }
              else if(GlobalFunction.selectedSession == MealSession.Session3){
                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Lunch') && order['Session'].contains('s3') ;
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Lunch') && order['Session'].contains('s3') ;
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Lunch') && order['Session'].contains('s3') ;
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Ready') && order['Session'].contains('s3') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Delivery out') && order['Session'].contains('s3');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Start') && order['Session'].contains('s3') ;
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Preparing') && order['Session'].contains('s3');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Complete') && order['Session'].contains('s3');
                      }).toList();
                }

                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Rejected') && order['Session'].contains('s3');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Completed') && order['Session'].contains('s3');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Canceled') && order['Session'].contains('s3');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Incomplete') && order['Session'].contains('s3');
                  }).toList();
                }

              }
              else if(GlobalFunction.selectedSession == MealSession.Session4){
                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Lunch') && order['Session'].contains('s4') ;
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Lunch') && order['Session'].contains('s4') ;
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Lunch') && order['Session'].contains('s4') ;
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Ready') && order['Session'].contains('s4') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Delivery out') && order['Session'].contains('s4');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Start') && order['Session'].contains('s4') ;
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Preparing') && order['Session'].contains('s4');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Lunch') &&
                            order['Status'].contains('Complete') && order['Session'].contains('s4');
                      }).toList();
                }

                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Rejected') && order['Session'].contains('s4');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Completed') && order['Session'].contains('s4');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Canceled') && order['Session'].contains('s4');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Lunch') && order['Status'].contains('Incomplete') && order['Session'].contains('s4');
                  }).toList();
                }
              }
            }
            else if(GlobalFunction.selectedMealTime == MealTime.Dinner)
            {
              if(GlobalFunction.selectedSession == MealSession.All) {
                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Dinner');
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Dinner');
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Dinner');
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Ready');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Delivery out');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner') &&
                            order['Status'].contains('Start');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner') &&
                            order['Status'].contains('Preparing');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner') &&
                            order['Status'].contains('Complete');
                      }).toList();
                }

                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Rejected');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Completed');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Canceled');
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Incomplete');
                  }).toList();
                }

              } else if(GlobalFunction.selectedSession == MealSession.Session1){
                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Dinner') && order['Session'].contains('s1') ;
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Dinner') && order['Session'].contains('s1') ;
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Dinner') && order['Session'].contains('s1') ;
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Ready') && order['Session'].contains('s1');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Delivery out') && order['Session'].contains('s1') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner') && order['Session'].contains('s1') &&
                            order['Status'].contains('Start');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner') && order['Session'].contains('s1')  &&
                            order['Status'].contains('Preparing');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner')&& order['Session'].contains('s1')  &&
                            order['Status'].contains('Complete');
                      }).toList();
                }

                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Rejected') && order['Session'].contains('s1') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Completed') && order['Session'].contains('s1') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Canceled') && order['Session'].contains('s1') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Incomplete') && order['Session'].contains('s1') ;
                  }).toList();
                }

              }
              else if(GlobalFunction.selectedSession == MealSession.Session2){
                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Dinner') && order['Session'].contains('s2') ;
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Dinner') && order['Session'].contains('s2') ;
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Dinner') && order['Session'].contains('s2') ;
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Ready') && order['Session'].contains('s2');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Delivery out') && order['Session'].contains('s2') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner') && order['Session'].contains('s2') &&
                            order['Status'].contains('Start');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner') && order['Session'].contains('s2')  &&
                            order['Status'].contains('Preparing');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner')&& order['Session'].contains('s2')  &&
                            order['Status'].contains('Complete');
                      }).toList();
                }


                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Rejected') && order['Session'].contains('s2') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Completed') && order['Session'].contains('s2') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Canceled') && order['Session'].contains('s3') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Incomplete') && order['Session'].contains('s4') ;
                  }).toList();
                }

              } else if(GlobalFunction.selectedSession == MealSession.Session3){
                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Dinner') && order['Session'].contains('s3') ;
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Dinner') && order['Session'].contains('s3') ;
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Dinner') && order['Session'].contains('s3') ;
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Ready') && order['Session'].contains('s3');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Delivery out') && order['Session'].contains('s3') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner') && order['Session'].contains('s3') &&
                            order['Status'].contains('Start');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner') && order['Session'].contains('s3')  &&
                            order['Status'].contains('Preparing');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner')&& order['Session'].contains('s3')  &&
                            order['Status'].contains('Complete');
                      }).toList();
                }

                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Rejected') && order['Session'].contains('s3') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Completed') && order['Session'].contains('s3') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Canceled') && order['Session'].contains('s3') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Incomplete') && order['Session'].contains('s3') ;
                  }).toList();
                }

              } else if(GlobalFunction.selectedSession == MealSession.Session4){
                OrderVariables.filteredOrders = state.ordersList.where((order) {
                  return order['Meal'].contains('Dinner') && order['Session'].contains('s4') ;
                }).toList();

                OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                  return order['Meal'].contains('Dinner') && order['Session'].contains('s4') ;
                }).toList();

                OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                  return order['Meal'].contains('Dinner') && order['Session'].contains('s4') ;
                }).toList();

                if(GlobalFunction.selectedInProgress == InProgress.Ready) {
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Ready') && order['Session'].contains('s4');
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.DeliveyOut){
                  OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Delivery out') && order['Session'].contains('s4') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.YetToStart) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner') && order['Session'].contains('s4') &&
                            order['Status'].contains('Start');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.Preparing) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner') && order['Session'].contains('s4')  &&
                            order['Status'].contains('Preparing');
                      }).toList();
                }
                else if(GlobalFunction.selectedInProgress == InProgress.PickedUp) {
                  OrderVariables.filteredInprogressOrders =
                      state.inprogressList.where((order) {
                        return order['Meal'].contains('Dinner')&& order['Session'].contains('s4')  &&
                            order['Status'].contains('Complete');
                      }).toList();
                }

                if(GlobalFunction.selectedClosed == Closed.Rejected) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Rejected') && order['Session'].contains('s4') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Completed) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Completed') && order['Session'].contains('s4') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Canceled') && order['Session'].contains('s4') ;
                  }).toList();
                }
                else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
                  OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                    return order['Meal'].contains('Dinner') && order['Status'].contains('Incomplete') && order['Session'].contains('s4') ;
                  }).toList();
                }
              }
            }
            else if(GlobalFunction.selectedSession == MealSession.Session1)
            {
              OrderVariables.filteredOrders = state.ordersList.where((order) {
                return order['Session'].contains('s1');
              }).toList();

              OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                return order['Session'].contains('s1');
              }).toList();

              OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                return order['Session'].contains('s1');
              }).toList();
            }
            else if(GlobalFunction.selectedSession == MealSession.Session2)
            {
              OrderVariables.filteredOrders = state.ordersList.where((order) {
                return order['Session'].contains('s2');
              }).toList();

              OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                return order['Session'].contains('s2');
              }).toList();

              OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                return order['Session'].contains('s2');
              }).toList();
            }
            else if(GlobalFunction.selectedSession == MealSession.Session3)
            {
              OrderVariables.filteredOrders = state.ordersList.where((order) {
                return order['Session'].contains('s3');
              }).toList();

              OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                return order['Session'].contains('s3');
              }).toList();

              OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                return order['Session'].contains('s3');
              }).toList();
            }
            else if(GlobalFunction.selectedSession == MealSession.Session4)
            {
              OrderVariables.filteredOrders = state.ordersList.where((order) {
                return order['Session'].contains('s4');
              }).toList();

              OrderVariables.filteredInprogressOrders = state.inprogressList.where((order) {
                return order['Session'].contains('s4');
              }).toList();

              OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                return order['Session'].contains('s4');
              }).toList();
            }
            else  if(GlobalFunction.selectedClosed == Closed.Rejected) {
              OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                return  order['Status'].contains('Rejected');
              }).toList();
            }
            else if(GlobalFunction.selectedClosed == Closed.Completed) {
              OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                return order['Status'].contains('Completed') ;
              }).toList();
            }
            else if(GlobalFunction.selectedClosed == Closed.Cancelled) {
              OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                return  order['Status'].contains('Canceled');
              }).toList();
            }
            else if(GlobalFunction.selectedClosed == Closed.inCompleted) {
              OrderVariables.filteredClosedOrders = state.closedList.where((order) {
                return order['Status'].contains('Incomplete');
              }).toList();
            }

            if(OrderVariables.isPickup){
              OrderVariables.filteredOrders = state.ordersList.where((order) {
                return order['Type'].contains('Pick up');
              }).toList();
            }

            if(OrderVariables.isDeliver){
              OrderVariables.filteredOrders = state.ordersList.where((order) {
                return order['Type'].contains('Deliver');
              }).toList();
            }

            if(OrderVariables.isDineIn){
              OrderVariables.filteredOrders = state.ordersList.where((order) {
                return order['Type'].contains('Dine in');
              }).toList();
            }

            if(OrderVariables.isPickup && OrderVariables.isDeliver) {
              OrderVariables.filteredOrders = state.ordersList.where((order) {
                return order['Type'].contains('Pick up') || order['Type'].contains('Deliver');
              }).toList();
            }

            if(OrderVariables.isPickup && OrderVariables.isDineIn) {
              OrderVariables.filteredOrders = state.ordersList.where((order) {
                return order['Type'].contains('Dine in') || order['Type'].contains('Deliver');
              }).toList();
            }

            if(OrderVariables.isDineIn && OrderVariables.isDeliver) {
              OrderVariables.filteredOrders = state.ordersList.where((order) {
                return order['Type'].contains('Dine in') || order['Type'].contains('Deliver');
              }).toList();
            }

            if(OrderVariables.isDineIn && OrderVariables.isDeliver && OrderVariables.isPickup) {
              OrderVariables.filteredOrders = state.ordersList.where((order) {
                return order['Type'].contains('Dine in') || order['Type'].contains('Deliver') || order['Type'].contains('Pick up');
              }).toList();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height:50,
                  child: DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      appBar:AppBar(
                        toolbarHeight: 0,
                        backgroundColor:GlobalVariables.lightColor,
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 400,
                                height: 50,
                                child: TabBar(
                                  controller: _tabController,
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
                                  physics: NeverScrollableScrollPhysics(),
                                  tabs: [
                                    Tab(text: 'New'),
                                    Tab(text: 'In progress'),
                                    Tab(text: 'Closed',)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ),
                  ),
                ),
                SizedBox(height: 0,),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex:2,
                        child: Container(
                          width:300,
                          margin: EdgeInsets.only(left: 0),
                          color: GlobalVariables.whiteColor,
                          child: DefaultTabController(
                            length: 3,
                            child: Scaffold(
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
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      Container(
                                        color: GlobalVariables.whiteColor,
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Container(
                                              color: GlobalVariables.whiteColor,
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
                                              color: GlobalVariables.whiteColor,
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
                                          ],
                                        ),
                                      ),

                                    ],
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
                                  itemCount: OrderVariables.filteredOrders.length,
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
                                    print("Inside the list ${OrderVariables.filteredOrders.length}");
                                    double totalAmount = 0.0;
                                    // state.orderList.sort(compareTime);

                                    final currentOrder = OrderVariables.filteredOrders[index];

                                    return ForOrderCard(currentOrder: currentOrder,index: index, orderStatus: 'New', filteredList: OrderVariables.filteredOrders,);
                                  }
                              ),
                            ),
                            Container(
                              color: GlobalVariables.whiteColor,
                              child: GridView.builder(
                                  itemCount: OrderVariables.filteredInprogressOrders.length,
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
                                    final currentOrder = OrderVariables.filteredInprogressOrders[index];
                                    return ForOrderCard(currentOrder: currentOrder, index: index, orderStatus: "Inprogress", filteredList: OrderVariables.filteredInprogressOrders,);
                                  }
                              ),
                            ),
                            Container(
                              color: GlobalVariables.whiteColor,
                              child: BlocBuilder<OrderBloc,OrderState>(
                                builder: (BuildContext context, OrderState state) {
                                  if(state is OrderState) {
                                    // state.closedList.sort(compareTime);
                                    return GridView.builder(
                                        itemCount: OrderVariables.filteredClosedOrders.length,
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
                                          final currentOrder = OrderVariables.filteredClosedOrders[index];
                                          return ForOrderCard(currentOrder: currentOrder, index: index, orderStatus: "Closed", filteredList: OrderVariables.filteredClosedOrders,);
                                        }
                                    );
                                  } else{
                                    return CircularProgressIndicator();
                                  }
                                },

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

  Widget buildOrderButton(Orders orders, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedOrders == orders ? GlobalVariables.textColor : selectedOrders == Orders.All ? GlobalVariables.textColor : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOrders = orders;
        });
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

  Widget buildInprogressButton(Inprogress prepares, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = prepare == prepares ? GlobalVariables.textColor : prepare == Inprogress.All ? GlobalVariables.textColor : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          prepare = prepares;
        });
      },
      child: Container(
        width: 75,
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
              fontSize: 9,
              fontWeight: FontWeight.bold,
              height: 1.3102272749 * ffem / fem,
              color: GlobalVariables.primaryColor,
            ),
          ),
        ),
      ),
    );
  }


}
