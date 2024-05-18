import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/menu_editor/menu_editor_event.dart';
import 'package:partner_admin_portal/bloc/menu_editor/menu_editor_state.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_variables.dart';


class MenuEditorBloc extends Bloc<MenuEditorEvent,MenuEditorState> {

  MenuEditorBloc() : super(MenuEditorLoadingState(),) {

    on<LoadMenuEditorEvent>((event, emit) async {
      emit(MenuEditorLoadingState());
      try {



        emit(MenuEditorLoadedState(MenuEditorVariables.selectedCategories, MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSession));
      } catch (e) {
        print("MEnu Editor error is ${e.toString()}");
        emit(MenuEditorErrorState(e.toString()));
      }
    });

    on<SelectMenuCategoryEvent>((event, emit) async {
      emit(MenuEditorLoadingState());
      try {
        Set<String> updatedCategories = Set.from(event.selectedCategories); // Create a new set instance
        print(updatedCategories);
        if (updatedCategories.contains(event.categoryName)) {
          updatedCategories.remove(event.categoryName);
        } else {
          updatedCategories.add(event.categoryName);
        }

        emit(MenuEditorLoadedState(updatedCategories, event.foodCategories, event.categoryName,MenuEditorVariables.daysMealSession));
      } catch (e) {
        print("MEnu Editor error is ${e.toString()}");
        emit(MenuEditorErrorState(e.toString()));
      }
    });

    on<SelectAllDaysEvent>((event, emit) async {
      emit(MenuEditorLoadingState());
      try {
        print("Bloc is working correctly");
        for (var meals in event.daysMealSession.values) {

          for (var sessionKey in meals.values) {

            for(var s in sessionKey.keys)
            {
              sessionKey[s] = event.val;
            }
          }
        }
        emit(MenuEditorLoadedState(event.selectedCategories, event.foodCategories, event.categoryName, event.daysMealSession));
      } catch (e) {
        emit(MenuEditorErrorState(e.toString()));
      }
    });

    on<SelectMealsEvent>((event, emit) async {
      emit(MenuEditorLoadingState());
      try {
        print("Meal Bloc is working correctly");
        for (var meals in event.daysMealSession.values) {
          var m = meals[event.meal];

          for (var sessionKey in m!.keys) {
            m[sessionKey] = event.val;
          }
        }
        emit(MenuEditorLoadedState(event.selectedCategories, event.foodCategories, event.categoryName, event.daysMealSession));
      } catch (e) {
        emit(MenuEditorErrorState(e.toString()));
      }
    });

    on<SelectSingleDayEvent>((event, emit) async {
      emit(MenuEditorLoadingState());
      try {
        print("Meal Bloc is working correctly");
        for(var day in MenuEditorVariables.daysMealSession.keys)
        {
          var day1 = event.d;
          if(day==day1)
          {
            for(var session in MenuEditorVariables.daysMealSession[day]!.values)
            {
              for(var sessionKey in session.keys)
              {
                session[sessionKey] = event.val;
              }
            }
          }
        }
        emit(MenuEditorLoadedState(event.selectedCategories, event.foodCategories, event.categoryName, event.daysMealSession));
      } catch (e) {
        emit(MenuEditorErrorState(e.toString()));
      }
    });


  }
}
