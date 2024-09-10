import 'package:equatable/equatable.dart';

abstract class DaysTimeEvent extends Equatable {
  DaysTimeEvent();

  @override
  List<Object?> get props => [];
}

class AllDayEvent extends DaysTimeEvent{
  final bool selected;
  AllDayEvent(this.selected);
}

class BreakfastEvent extends DaysTimeEvent {
  final bool breakfastSelected;
  BreakfastEvent(this.breakfastSelected);
}

class LunchEvent extends DaysTimeEvent {
  final bool lunchSelected;
  LunchEvent(this.lunchSelected);
}

class DinnerEvent extends DaysTimeEvent {
  final bool dinnerSelected;
  DinnerEvent(this.dinnerSelected);
}

class AllMealDayEvent extends DaysTimeEvent {
  final String day;
  final bool allMealDay;
  AllMealDayEvent(this.day,this.allMealDay);
}

class MealSelectedEvent extends DaysTimeEvent {
  final String day;
  final String mealType;
  final bool selected;

  MealSelectedEvent({required this.day, required this.mealType, required this.selected});
}

class setTimeEvent extends DaysTimeEvent {

}