import 'package:equatable/equatable.dart';

class DaysTimeState extends Equatable {
  final bool allDay;
  final bool breakfast;
  final bool lunch;
  final bool dinner;
  final bool allMealDay;

  DaysTimeState({
    required this.allDay,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.allMealDay,
  });

  @override
  List<Object?> get props => [allDay, breakfast, lunch, dinner, allMealDay];

  DaysTimeState copyWith({
    bool? allDay,
    bool? breakfast,
    bool? lunch,
    bool? dinner,
    bool? allMealDay,
  }) {
    return DaysTimeState(
      allDay: allDay ?? this.allDay,
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
      allMealDay: allMealDay ?? this.allMealDay,
    );
  }
}
