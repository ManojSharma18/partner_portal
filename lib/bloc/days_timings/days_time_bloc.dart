import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/manage_settings/manage_settings_variables.dart';
import 'days_time_event.dart';
import 'days_time_state.dart';

class DaysTimeBloc extends Bloc<DaysTimeEvent, DaysTimeState> {
  DaysTimeBloc()
      : super(DaysTimeState(
      allDay: false, breakfast: false, lunch: false, dinner: false,allMealDay: false));

  @override
  Stream<DaysTimeState> mapEventToState(DaysTimeEvent event) async* {
    if (event is AllDayEvent) {
      ManageSettingsVariables.mealData.forEach((day, meals) {
        ManageSettingsVariables.mealData[day]?.updateAll((key, value) => value = event.selected);
      });
      yield DaysTimeState(
          allDay: event.selected,
          breakfast: event.selected,
          lunch: event.selected,
          dinner: event.selected, allMealDay: event.selected);
    }
    else if (event is BreakfastEvent) {
      ManageSettingsVariables.mealData.forEach((day, meals) {
        ManageSettingsVariables.mealData[day] ??= {};
        ManageSettingsVariables.mealData[day]!['Breakfast'] = event.breakfastSelected;
      });
      bool allDayChecked = state.lunch && state.dinner && event.breakfastSelected;
      yield DaysTimeState(
          allDay: allDayChecked,
          breakfast: event.breakfastSelected,
          lunch: state.lunch,
          dinner: state.dinner, allMealDay: state.allMealDay);
    } else if (event is LunchEvent) {
      ManageSettingsVariables.mealData.forEach((day, meals) {
        ManageSettingsVariables.mealData[day] ??= {};
        ManageSettingsVariables.mealData[day]!['Lunch'] = event.lunchSelected;
      });
      bool allDayChecked = state.breakfast && state.dinner && event.lunchSelected;
      yield DaysTimeState(
          allDay: allDayChecked,
          breakfast: state.breakfast,
          lunch: event.lunchSelected,
          dinner: state.dinner, allMealDay: state.allMealDay);
    } else if (event is DinnerEvent) {
      ManageSettingsVariables.mealData.forEach((day, meals) {
        ManageSettingsVariables.mealData[day] ??= {};
        ManageSettingsVariables.mealData[day]!['Dinner'] = event.dinnerSelected;
      });
      bool allDayChecked = state.breakfast && state.lunch && event.dinnerSelected;
      yield DaysTimeState(
          allDay: allDayChecked,
          breakfast: state.breakfast,
          lunch: state.lunch,
          dinner: event.dinnerSelected, allMealDay: state.allMealDay);
    }

    else if (event is MealSelectedEvent) {
      // Handle MealSelectedEvent
      ManageSettingsVariables.mealData[event.day] ??= {};
      ManageSettingsVariables.mealData[event.day]![event.mealType] = event.selected;

      bool allMealsSelectedForDay = ManageSettingsVariables.mealData[event.day]!.values.every((value) => value);
      yield state.copyWith(
        allMealDay: allMealsSelectedForDay,
      );
    }
  }
}
