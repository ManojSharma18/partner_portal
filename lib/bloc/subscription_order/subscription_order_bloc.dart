import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/subscription_order/subscription_order_event.dart';
import 'package:partner_admin_portal/bloc/subscription_order/subscription_order_state.dart';
import 'package:partner_admin_portal/constants/order_constants/subscription_variables.dart';
import 'package:partner_admin_portal/models/subscription_order_model.dart';

import '../../repository/order_service.dart';

class SubscriptionOrdersBloc extends Bloc<SubscriptionOrdersEvent,SubscriptionOrdersState>{
  final OrderService _orderService;

  SubscriptionOrdersBloc(this._orderService) : super(SubscriptionOrdersLoadingState()) {
    on<LoadSubscriptionOrdersEvent>((event, emit) async {
      emit(SubscriptionOrdersLoadingState());
      try {
        print("Orders are 121 }");
        List<SubscriptionOrderModel> orders = [];
         orders = await _orderService.fetchSubscriptionOrders();

        SubscriptionVariables.subscriptionOrders = orders;

        print("Orders are 121 ${orders.length}");

        // OrderVariables.orders = orders;

        for (final ord in orders) {

          List<Map<String,dynamic>> itemDetails = [];

          for(final item in ord.fpUnitFordItems)
          {
            Map<String,dynamic> oneItem = {
              "itemName" : item.itemName,
              "count" : item.count,
              "price" : item.price
            };
            itemDetails.add(oneItem);
          }
          Map<String, dynamic> oneOrder = {
            "_id" : ord.id,
            "Id" : ord.fpUnitFordId,
            "Restaurant" : ord.fpUnitName,
            "Date" : ord.fpUnitFordDate,
            "Time" : ord.fpUnitFordTime,
            "CustomerName" : ord.cUid,
            "number" : ord.cMobNo,
            "Amount" : ord.fpUnitFordAmt,
            "Status" : "Start",
            "dname" :  ord.dName,
            "Items" : itemDetails,
            "Type" : ord.fpUnitFordCMode,
            "d_mob" : ord.dName,
            "budgetType" : ord.fpUnitForBtype,
            "Meal" : ord.fpUnitFordMeal,
            "Session" : ord.fpUnitFordMealSession,
            "Address" : "Home",
            "rating" :  0,
            "order" : ord.fpUnitFordType,
          };
          if(SubscriptionVariables.loadFirstTime){
            SubscriptionVariables.orders.add(oneOrder);
          }
        }

        SubscriptionVariables.loadFirstTime = false;

        print("Length ${SubscriptionVariables.orders.length}");

        emit(SubscriptionOrdersLoadedState(orders,SubscriptionVariables.orders,SubscriptionVariables.closed));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });



    on<OrderStatusEvent>((event, emit) async {
      emit(SubscriptionOrdersLoadingState());
      try {
        List<Map<String, dynamic>> updatedInProgressList = [];
        if (event.filteredList[event.index]['Status'] == "Start") {
          updatedInProgressList = List.from(event.orderList);
          for (int i = 0; i < updatedInProgressList.length; i++) {
            if (event.ordId == updatedInProgressList[i]['Id']) {
              updatedInProgressList[i]['Status'] = "Ready";
            }
          }
        }
        else  if (event.filteredList[event.index]['Status'] == "Ready") {
          updatedInProgressList = List.from(event.orderList);
          for (int i = 0; i < updatedInProgressList.length; i++) {
            if (event.ordId == updatedInProgressList[i]['Id']) {
              updatedInProgressList[i]['Status'] = "Delivery out";
            }
          }
        }
        else  if (event.filteredList[event.index]['Status'] == "Delivery out") {
          updatedInProgressList = List.from(event.orderList);
          for (int i = 0; i < updatedInProgressList.length; i++) {
            if (event.ordId == updatedInProgressList[i]['Id']) {
              updatedInProgressList[i]['Status'] = "Complete";
            }
          }
        }

        emit(SubscriptionOrdersLoadedState([] ,updatedInProgressList,event.closedList));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<OrderCancelEvent>((event, emit) async {
      emit(SubscriptionOrdersLoadingState());
      try {
        List<Map<String, dynamic>>? deleteOrderList;
        List<Map<String, dynamic>>? addOrderList;
        // event.inProgressList[event.index]['Status'] = "Canceled";
        deleteOrderList = List<Map<String, dynamic>>.from(event.orderList);
        addOrderList = List<Map<String, dynamic>>.from(event.closedList);
        Map<String, dynamic> orderToRemove = {};
        print("Indexes are ${deleteOrderList.length}");
        for (int i = 0; i < deleteOrderList.length; i++) {
          if (deleteOrderList[i]['Id'] == event.ordId) {
            orderToRemove = deleteOrderList[i];
            orderToRemove['Status'] = "Canceled";
            deleteOrderList.removeAt(i);
            event.orderList.removeAt(i);
            addOrderList.add(orderToRemove);
            event.closedList.add(orderToRemove);
            break;
          }
        }
        emit(SubscriptionOrdersLoadedState([],event.orderList,addOrderList));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<OrderCompleteEvent>((event, emit) async {
      emit(SubscriptionOrdersLoadingState());
      try {

        for(int i=0;i<event.orderList.length;i++)
        {
          if(event.orderList[i]['Id'] == event.ordId) {
            event.orderList[i]['Status'] = 'Completed';
            Map<String, dynamic> order = event.orderList.removeAt(i);
            event.closedList.add(order);
            break;
          }
        }
        emit(SubscriptionOrdersLoadedState([],event.orderList,event.closedList));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<CancelAllEventSubscription>((event, emit) async {
      emit(SubscriptionOrdersLoadingState());
      try {
        final addOrderList = List<Map<String, dynamic>>.from(event.closedList);
        final ordList = List<Map<String,dynamic>>.from(event.orderList);
        final deleteOrderList = List<Map<String, dynamic>>.from(event.filterdList);

        deleteOrderList.forEach((deleteItem) {
          // Find index of the item in ordList that matches deleteItem
          int index = ordList.indexWhere((item) => _isSame(item, deleteItem));

          // Remove the item if found in ordList
          if (index != -1) {
            ordList.removeAt(index);
            event.orderList.removeAt(index);
          }
        });
        for (int i = 0; i < deleteOrderList.length; i++) {
          deleteOrderList[i]['Status'] = "Canceled";
        }
        addOrderList.addAll(List<Map<String, dynamic>>.from(deleteOrderList));
        event.closedList.addAll(List<Map<String, dynamic>>.from(deleteOrderList));

        emit(SubscriptionOrdersLoadedState([],ordList,addOrderList));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });

  }

  bool _isSame(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    if (map1.length != map2.length) return false;

    for (var key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) {
        return false;
      }
    }

    return true;
  }


}