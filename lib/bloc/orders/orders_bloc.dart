import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/orders/orders_event.dart';
import 'package:partner_admin_portal/bloc/orders/orders_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/order_constants/order_variables.dart';
import '../../repository/order_service.dart';

class OrdersBloc extends Bloc<OrdersEvent,OrdersState>{
  final OrderService _orderService;

  OrdersBloc(this._orderService) : super(OrdersLoadingState()) {
    on<LoadOrdersEvent>((event, emit) async {
      emit(OrdersLoadingState());
      try {
        final orders = await _orderService.fetchOrders();

        OrderVariables.orders = orders;

        for (final ord in orders) {
          List<Map<String, dynamic>> itemDetails = [];

          for (final item in ord.fpUnitFordItems) {
            Map<String, dynamic> oneItem = {
              "itemName": item.itemName,
              "count": item.count,
              "price": item.price
            };
            itemDetails.add(oneItem);
          }

          Map<String, dynamic> oneOrder = {
            "_id": ord.id,
            "Id": ord.fpUnitFordId,
            "Restaurant": ord.fpUnitName,
            "Date": ord.fpUnitFordDate,
            "Time": ord.fpUnitFordTime,
            "CustomerName": ord.cUid,
            "number": ord.cMobNo,
            "Amount": ord.fpUnitFordAmt,
            "Status": "Start",
            "dname": ord.dName,
            "Items": itemDetails,
            "Type": ord.fpUnitFordCMode,
            "d_mob": ord.dName,
            "Meal": ord.fpUnitFordMeal,
            "Session": ord.fpUnitFordMealSession,
            "Address": "Home",
            "rating": 0,
            "order": ord.fpUnitFordType,
          };
          if (GlobalVariables.loadFirstTime) {
            GlobalVariables.orders.add(oneOrder);
          }
        }
        GlobalVariables.loadFirstTime = false;

        emit(OrdersLoadedState(orders, GlobalVariables.orders, GlobalVariables.inprogress, GlobalVariables.closed));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });

    on<HandlePickupEvent>((event, emit) async {
      emit(OrdersLoadingState());
      try {
        final orders = await _orderService.fetchOrders();
        OrderVariables.orders = orders;

        OrderVariables.isPickup = event.value;

        emit(OrdersLoadedState(orders, GlobalVariables.orders, GlobalVariables.inprogress, GlobalVariables.closed));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });

    on<HandleDeliverEvent>((event, emit) async {
      emit(OrdersLoadingState());
      try {
        final orders = await _orderService.fetchOrders();
        OrderVariables.orders = orders;

        OrderVariables.isDeliver = event.value;

        emit(OrdersLoadedState(orders, GlobalVariables.orders, GlobalVariables.inprogress, GlobalVariables.closed));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });

    on<HandleDineInEvent>((event, emit) async {
      emit(OrdersLoadingState());
      try {
        final orders = await _orderService.fetchOrders();
        OrderVariables.orders = orders;

        OrderVariables.isDineIn = event.value;

        emit(OrdersLoadedState(orders, GlobalVariables.orders, GlobalVariables.inprogress, GlobalVariables.closed));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });

    on<OrdersAcceptEvent>((event, emit) async {
      emit(OrdersLoadingState());
      try {
        final deleteOrderList = List<Map<String, dynamic>>.from(
            event.orderList);
        final addOrderList = List<Map<String, dynamic>>.from(
            event.inProgressList);
        Map<String, dynamic> orderToRemove = {};

        print(deleteOrderList.length);
        for (int i = 0; i < deleteOrderList.length; i++) {
          if (deleteOrderList[i]['Id'] == event.ordId) {
            orderToRemove = deleteOrderList[i];
            deleteOrderList.removeAt(i);
            break;
          }
        }

        if (orderToRemove != null) {
          addOrderList.add(orderToRemove);
        } else {
          print('Order with ID ${event.ordId} not found.');
        }
        emit(OrdersLoadedState([], deleteOrderList, addOrderList, event.closedList));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });

    on<OrdersRejectEvent>((event, emit) async {
      emit(OrdersLoadingState());
      try {
        List<Map<String, dynamic>>? deleteOrderList;
        List<Map<String, dynamic>>? addOrderList;
        event.orderList[event.index]['Status'] = "Rejected";
        deleteOrderList = List<Map<String, dynamic>>.from(event.orderList);
        addOrderList = List<Map<String, dynamic>>.from(event.closedList);
        Map<String, dynamic> orderToRemove = {};
        for (int i = 0; i < deleteOrderList.length; i++) {
          if (deleteOrderList[i]['Id'] == event.ordId) {
            orderToRemove = deleteOrderList[i];
            deleteOrderList.removeAt(i);
            orderToRemove['Status'] = "Rejected";
            addOrderList.add(orderToRemove);
            break;
          }
        }
        emit(OrdersLoadedState(
            [], deleteOrderList!, event.inProgressList, addOrderList!));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });

    on<OrdersCancelEvent>((event, emit) async {
      emit(OrdersLoadingState());
      try {
        print(event.index);
        List<Map<String, dynamic>>? deleteOrderList;
        List<Map<String, dynamic>>? addOrderList;
        // event.inProgressList[event.index]['Status'] = "Canceled";
        deleteOrderList = List<Map<String, dynamic>>.from(event.inProgressList);
        addOrderList = List<Map<String, dynamic>>.from(event.closedList);
        Map<String, dynamic> orderToRemove = {};
        print("Indexes are ${deleteOrderList.length}");
        for (int i = 0; i < deleteOrderList.length; i++) {
          if (deleteOrderList[i]['Id'] == event.ordId) {
            orderToRemove = deleteOrderList[i];
            orderToRemove['Status'] = "Canceled";
            deleteOrderList.removeAt(i);
            addOrderList.add(orderToRemove);
            break;
          }
        }
        emit(OrdersLoadedState([], event.ordersList, deleteOrderList, addOrderList));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });

    on<CancelAllOrderEvent>((event, emit) async {
      emit(OrdersLoadingState());
      try {
        print("Coming here ");
        final addOrderList = List<Map<String, dynamic>>.from(event.closedList);
        final ordList = List<Map<String, dynamic>>.from(event.ordersList);
        final deleteOrderList = List<Map<String, dynamic>>.from(event.filterdList);
        print(deleteOrderList.length);
        deleteOrderList.forEach((deleteItem) {
          // Find index of the item in ordList that matches deleteItem
          int index = ordList.indexWhere((item) => _isSame(item, deleteItem));

          // Remove the item if found in ordList
          if (index != -1) {
            ordList.removeAt(index);
            event.ordersList.removeAt(index);
          }
        });
        for (int i = 0; i < deleteOrderList.length; i++) {
          deleteOrderList[i]['Status'] = "Canceled";
        }
        addOrderList.addAll(List<Map<String, dynamic>>.from(deleteOrderList));
        event.closedList.addAll(List<Map<String, dynamic>>.from(deleteOrderList));

        print("Order Liost ${ordList.length}");
        print("Closed List ${addOrderList}");

        emit(OrdersLoadedState([], event.ordersList, event.inProgressList, event.closedList));
      } catch (e) {
        print("ERror is ${e.toString()}");
        emit(OrderErrorState(e.toString()));
      }
    });

    on<OrdersStatusEvent>((event, emit) async {
      emit(OrdersLoadingState());
      try {
        List<Map<String, dynamic>> updatedInProgressList = [];
        if (event.filteredList[event.index]['Status'] == "Start") {
          updatedInProgressList = List.from(event.inprogressList);
          for (int i = 0; i < updatedInProgressList.length; i++) {
            if (event.ordId == updatedInProgressList[i]['Id']) {
              updatedInProgressList[i]['Status'] = "Ready";
            }
          }
        }
        else if (event.filteredList[event.index]['Status'] == "Ready") {
          updatedInProgressList = List.from(event.inprogressList);
          for (int i = 0; i < updatedInProgressList.length; i++) {
            if (event.ordId == updatedInProgressList[i]['Id']) {
              updatedInProgressList[i]['Status'] = "Delivery out";
            }
          }
        }
        else if (event.filteredList[event.index]['Status'] == "Delivery out") {
          updatedInProgressList = List.from(event.inprogressList);
          for (int i = 0; i < updatedInProgressList.length; i++) {
            if (event.ordId == updatedInProgressList[i]['Id']) {
              updatedInProgressList[i]['Status'] = "Complete";
            }
          }
        }
        emit(OrdersLoadedState(OrderVariables.orders, event.ordersList, updatedInProgressList, event.closedList));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });

    on<OrdersCompleteEvent>((event, emit) async {
      emit(OrdersLoadingState());
      try {
        final deleteOrderList = List<Map<String, dynamic>>.from(event.filterList);
        deleteOrderList[event.index]['Status'] = "Completed";
        final addOrderList = List<Map<String, dynamic>>.from(event.closedList);
        Map<String, dynamic> order = deleteOrderList.removeAt(event.index);
        addOrderList.add(order);
        for(int i=0;i<event.inprogressList.length;i++)
          {
            if(event.inprogressList[i]['Id'] == event.ordId) {
              event.inprogressList.removeAt(i);
              break;
            }
          }
        emit(OrdersLoadedState([], event.ordersList, event.inprogressList, addOrderList));
      } catch (e) {
        emit(OrderErrorState(e.toString()));
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