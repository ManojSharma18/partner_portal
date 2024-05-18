import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_event.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_state.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_functions.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';

class LiveMenuBloc extends Bloc<LiveMenuEvent,LiveMenuState>{
  LiveMenuBloc() : super(LiveMenuState(selectedCategories: LiveMenuVariables.selectedCategories, foodCategories: LiveMenuVariables.foodCategories, itemName: LiveMenuVariables.selectedItem));

  Stream<LiveMenuState> mapEventToState(LiveMenuEvent event) async* {
    if (event is SelectCategoryEvent) {
      Set<String> updatedCategories = Set.from(state.selectedCategories); // Create a new set instance
      print(updatedCategories);
      if (updatedCategories.contains(event.categoryName)) {
        updatedCategories.remove(event.categoryName);
      } else {
        updatedCategories.add(event.categoryName);
      }
      print(updatedCategories);
      yield state.copyWith(selectedCategories: updatedCategories, categoryName: event.categoryName);
    }
    if(event is AddItemEvent){
      Map<String, List<Map<String,dynamic>>> updatedCategory = Map<String, List<Map<String,dynamic>>>.from(state.foodCategories);
      Map<String, dynamic> newItem = {'name': event.itemName, 'availability': event.availability};
      updatedCategory[event.categoryName]!.add(newItem);
      print(updatedCategory[event.categoryName]);
      yield state.copyWith(foodCategories: updatedCategory,categoryName: event.categoryName,item: newItem);
    }
    if(event is SelectItemEvent){
      LiveMenuVariables.selectedItem = event.item;
      yield state.copyWith(foodCategories: state.foodCategories,itemName: event.item);
    }
    if(event is MealSelectEvent){
      LiveMenuFunctions.selectedMealTime = event.mealTime;
      yield state.copyWith(foodCategories: state.foodCategories,mealTime: event.mealTime);    }
    if(event is CategoryEvent){
      if (event.categoryContainsMatch) {
        if ( LiveMenuVariables.selectedCategories.contains(event.category)) {
          LiveMenuVariables.selectedCategories.remove(event.category);
        } else {
          LiveMenuVariables.selectedCategories.add(event.category);
        }
      }
      yield LiveMenuState(selectedCategories: LiveMenuVariables.selectedCategories, foodCategories: LiveMenuVariables.foodCategories, itemName: LiveMenuVariables.selectedItem);
    }
  }

}

