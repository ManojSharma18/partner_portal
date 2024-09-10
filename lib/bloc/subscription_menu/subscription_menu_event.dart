import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


@immutable
abstract class SubscriptionMenuEvent extends Equatable{
  const SubscriptionMenuEvent();
}


class LoadSubscriptionEvent extends SubscriptionMenuEvent {
  final BuildContext context;

  LoadSubscriptionEvent(this.context);
  @override
  List<Object?> get props =>  [];
}




