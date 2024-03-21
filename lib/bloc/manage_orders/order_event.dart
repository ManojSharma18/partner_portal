import 'package:equatable/equatable.dart';
import 'package:partner_admin_portal/constants/global_function.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu.dart';
import 'package:partner_admin_portal/widgets/orders/manage/manage_orderes.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class SwitchEvent extends OrderEvent {
  final bool active;
  const SwitchEvent(this.active);
}

class BreakfastEvent extends OrderEvent {
  final MealTime mealTime;
  const BreakfastEvent(this.mealTime);
}

class SessionEvent extends OrderEvent {
  final MealSession mealSession;
  const SessionEvent(this.mealSession);
}

class InProgressEvent extends OrderEvent{
  final InProgress inProgress;
  const InProgressEvent(this.inProgress);
}

class ClosedEvent extends OrderEvent{
  final Closed closed;
  const ClosedEvent(this.closed);
}

class OrderTypeEvent extends OrderEvent {
  final Orders orders;
  const OrderTypeEvent(this.orders);
}

class AmountEvent extends OrderEvent{
  final Amount amount;
  const AmountEvent(this.amount);
}

class SubscriptionEvent extends OrderEvent{
  final Subsciption subs;
  const SubscriptionEvent(this.subs);
}

class OrderRejectEvent extends OrderEvent{
  final List<Map<String,dynamic>> orderList;
  final List<Map<String,dynamic>> closedList;
  final int index;
  const OrderRejectEvent(this.orderList, this.index, this.closedList);
}

class OrderAcceptEvent extends OrderEvent {
  final List<Map<String,dynamic>> orderList;
  final List<Map<String,dynamic>> inProgressList;
  final int index;
  final String ordId;
  const OrderAcceptEvent(this.orderList,this.inProgressList,this.index, this.ordId);
}

class OrderStatusEvent extends OrderEvent{
  final List<Map<String,dynamic>> inProgressList;
  final int index;
  final String status;
  const OrderStatusEvent(this.inProgressList,this.index, this.status,);
}

class OrderCompleteEvent extends OrderEvent{
  final int index;
  const OrderCompleteEvent(this.index);
}

class SearchEvent extends OrderEvent{
  final String searchQuery;
  const SearchEvent(this.searchQuery);
}

