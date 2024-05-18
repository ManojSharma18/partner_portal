import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_event.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import 'package:partner_admin_portal/constants/global_function.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import '../../repository/order_service.dart';

class OrderBloc extends Bloc<OrderEvent,OrderState> {
  OrderBloc() : super(OrderState(active: false,orderList: GlobalVariables.orders, inProgressList: GlobalVariables.inprogress, closedList: GlobalVariables.closed,status: "Yet to start")){

  }

  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if(event is SwitchEvent){
      GlobalVariables.isOpend = state.active;
      OrderState(active: !state.active,orderList: state.orderList, inProgressList: state.inProgressList, closedList: state.closedList);
    } else
      if(event is BreakfastEvent){
      print(event.mealTime);
      GlobalFunction.selectedMealTime = event.mealTime;
      yield OrderState(active: state.active,mealTime: event.mealTime, orderList: state.orderList, inProgressList: state.inProgressList,closedList: state.closedList);
    }
      else if(event is SessionEvent) {
      GlobalFunction.selectedSession = event.mealSession;
      yield OrderState(active: state.active,mealSession: event.mealSession, orderList: state.orderList, inProgressList: state.inProgressList,closedList: state.closedList);
    }
      else if(event is InProgressEvent){
      print(GlobalFunction.selectedInProgress);
      GlobalFunction.selectedInProgress =event.inProgress;
      yield OrderState(active: state.active,inProgress: event.inProgress, orderList: state.orderList, inProgressList: state.inProgressList,closedList: state.closedList);
    }
      else if(event is SubscriptionEvent){
      GlobalFunction.selectedSubs =event.subs;
      yield OrderState(active: state.active,subsciption: event.subs   , orderList: state.orderList, inProgressList: state.inProgressList,closedList: state.closedList);
    }
    else if(event is ClosedEvent){
      GlobalFunction.selectedClosed = event.closed;
      yield OrderState(active: state.active,closed: event.closed, orderList: state.orderList, inProgressList: state.inProgressList,closedList: state.closedList);
    }
    else if(event is OrderTypeEvent) {
        GlobalFunction.selectedOrders = event.orders;
        yield OrderState(active: state.active,orders: event.orders, orderList: state.orderList, inProgressList: state.inProgressList,closedList: state.closedList);
      }
    else if(event is AmountEvent) {
      GlobalFunction.selectedAmount = event.amount;
      yield OrderState(active: state.active,amount: event.amount, orderList: state.orderList, inProgressList: state.inProgressList,closedList: state.closedList);
    }
    else if(event is OrderRejectEvent) {
        List<Map<String, dynamic>>? deleteOrderList;
        List<Map<String, dynamic>>? addOrderList;

      if(event.isOrderList == true)
        {
          state.orderList[event.index]['Status'] = "Rejected";
           deleteOrderList = List<Map<String, dynamic>>.from(state.orderList);
           addOrderList = List<Map<String, dynamic>>.from(state.closedList);
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

          // if (orderToRemove != null) {
          //   addOrderList.add(orderToRemove);
          //   addOrderList[event.index]['Status'] = "Rejected";
          //   GlobalVariables.closed.add(orderToRemove);
          // } else {
          //   print('Order with ID ${event.ordId} not found.');
          // }
        }
      else {
        state.inProgressList[event.index]['Status'] = "Canceled";
        deleteOrderList = List<Map<String, dynamic>>.from(state.inProgressList);
        addOrderList = List<Map<String, dynamic>>.from(state.closedList);
        Map <String,dynamic> order = deleteOrderList.removeAt(event.index);
        state.inProgressList.removeAt(event.index);
        addOrderList.add(order);
        GlobalVariables.closed.add(order);
      }
      //GlobalVariables.closed[event.index]['Status'] = "Rejected";
      yield state.copyWith(orderList: deleteOrderList,closedList: addOrderList);

    }
    else if(event is CancelAllEvent) {
      print("Length of filtered ${event.filterdList.length}");

        final addOrderList = List<Map<String, dynamic>>.from(state.closedList);
        final ordList = List<Map<String,dynamic>>.from(state.orderList);
        final deleteOrderList = List<Map<String, dynamic>>.from(event.filterdList);
        print(deleteOrderList.length);
       deleteOrderList.forEach((deleteItem) {
        // Find index of the item in ordList that matches deleteItem
        int index = ordList.indexWhere((item) => _isSame(item, deleteItem));

        // Remove the item if found in ordList
        if (index != -1) {
          ordList.removeAt(index);
        }
      });
      for (int i = 0; i < deleteOrderList.length; i++) {
        deleteOrderList[i]['Status'] = "Canceled";
      }
        addOrderList.addAll(List<Map<String, dynamic>>.from(deleteOrderList));

        yield state.copyWith(orderList: ordList,closedList: addOrderList);
      }
    else if (event is OrderAcceptEvent) {
      final deleteOrderList = List<Map<String, dynamic>>.from(state.orderList);
      final addOrderList = List<Map<String, dynamic>>.from(state.inProgressList);
      Map<String, dynamic> orderToRemove = {};

      print("Order ID ${event.ordId}");
      // Find the order with the matching ordId
      for (int i = 0; i < deleteOrderList.length; i++) {
        if (deleteOrderList[i]['Id'] == event.ordId) {
          orderToRemove = deleteOrderList[i];
          deleteOrderList.removeAt(i);
          break;
        }
      }

      if (orderToRemove != null) {
        addOrderList.add(orderToRemove);
        // GlobalVariables.inprogress.add(orderToRemove);
      } else {
        print('Order with ID ${event.ordId} not found.');
      }

      yield state.copyWith(orderList: deleteOrderList, inProgressList: addOrderList);
    }

    else  if (event is OrderStatusEvent) {
      print(event.filteredList[event.index]['Status']);
      print(event.index);
      if (event.filteredList[event.index]['Status'] == "Start") {
        List<Map<String, dynamic>> updatedInProgressList = List.from(state.inProgressList);
        for(int i=0;i<updatedInProgressList.length;i++)
          {
            if(updatedInProgressList[i]["Id"] == event.ordId)
              {
                print("Id is treue and updating");
                updatedInProgressList[i]['Status'] = "Ready";
                break;
              }
          }
        // OrderVariables.orderService.updateOrder(event.ordId, { "fp_unit_ford_status" : "Ready"});
        yield state.copyWith(inProgressList: updatedInProgressList,status: updatedInProgressList[event.index]['Status']);
      }
      else if(event.filteredList[event.index]['Status'] == "Ready"){

        List<Map<String, dynamic>> updatedInProgressList = List.from(state.inProgressList);

        for(int i=0;i<updatedInProgressList.length;i++)
        {
          if(updatedInProgressList[i]["Id"] == event.ordId)
          {

            updatedInProgressList[i]['Status'] = "Delivery out";

            break;
          }
        }
        yield state.copyWith(inProgressList: updatedInProgressList,status: updatedInProgressList[event.index]['Status']);

      }
      else if(event.filteredList[event.index]['Status'] == "Delivery out"){
        List<Map<String, dynamic>> updatedInProgressList = List.from(state.inProgressList);

        for(int i=0;i<updatedInProgressList.length;i++)
        {
          if(updatedInProgressList[i]["Id"] == event.ordId)
          {

            updatedInProgressList[i]['Status'] = "Complete";

            break;
          }
        }
        yield state.copyWith(inProgressList: updatedInProgressList,status: updatedInProgressList[event.index]['Status']);
      }

    }
    else if(event is OrderCompleteEvent) {
      state.inProgressList[event.index]['Status'] = "Completed";
      final deleteOrderList = List<Map<String, dynamic>>.from(state.inProgressList);
      final addOrderList = List<Map<String, dynamic>>.from(state.closedList);
      Map <String,dynamic> order = deleteOrderList.removeAt(event.index);
      addOrderList.add(order);
      GlobalVariables.inprogress.removeAt(event.index);
      GlobalVariables.closed.add(order);


      yield state.copyWith(inProgressList: deleteOrderList,closedList: addOrderList);
    }
    else if (event is SearchEvent) {
      yield* _mapSearchEventToState(event);
    }
    else if(event is SubscriptionCanceledEvent){
      final subsbcriptionOrderList = List<Map<String,dynamic>>.from(state.subscriptionOrderList!);
      final canceledList = List<Map<String,dynamic>>.from(state.canceledList!);
      Map<String,dynamic> subOrder = subsbcriptionOrderList.removeAt(event.index);
      canceledList.add(subOrder);
      GlobalVariables.canceled.add(subOrder);
      yield state.copyWith(subscriptionOrderList: subsbcriptionOrderList,canceledList: canceledList);
      }

  }

  Stream<OrderState> _mapSearchEventToState(SearchEvent event) async* {
    if (event.searchQuery != null && event.searchQuery.isNotEmpty) {
      print(event.searchQuery);
      final List<Map<String, dynamic>> filteredOrders = state.orderList.where((order) {
        return order['number'].contains(event.searchQuery) ||
            order['Id'].toString().toLowerCase().contains(event.searchQuery) ||
            order['CustomerName'].toString().toLowerCase().contains(event.searchQuery) ||
            order['CustomerName'].toString().contains(event.searchQuery);
      }).toList();

      yield state.copyWith(searchQuery: event.searchQuery, orderList: state.orderList,filterList: filteredOrders);
    } else {
      yield state.copyWith(searchQuery: null, orderList: state.orderList);
    }
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

