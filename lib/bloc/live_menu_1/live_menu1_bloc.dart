import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/live_menu_1/live_menu1_event.dart';
import 'package:partner_admin_portal/bloc/live_menu_1/live_menu1_state.dart';
import 'package:partner_admin_portal/models/live_menu_model.dart';
import 'package:partner_admin_portal/models/live_menu_new_model.dart';
import 'package:partner_admin_portal/repository/live_menu_new_service.dart';
import 'package:partner_admin_portal/repository/live_menu_service.dart';

import '../../constants/global_variables.dart';
import '../../constants/live_menu_constants/live_menu_variables.dart';
import '../../constants/menu_editor_constants/menu_editor_variables.dart';
import '../../models/restaurant_menu.dart';
import '../../provider/day_provider.dart';
import '../../repository/menu_services.dart';

class LiveMenu1Bloc extends Bloc<LiveMenu1Event,LiveMenu1State> {
  final LiveMenuService _liveMenuService;

  LiveMenu1Bloc(this._liveMenuService) : super(LiveMenu1LoadingState()) {

    on<LoadLiveMenu1Event>((event, emit) async {
      emit(LiveMenu1LoadingState());
      try {
        List<LiveMenuModel> liveMenu = [];

        DayProvider dayProvider = event.context.read<DayProvider>();

        // liveMenu = await _liveMenuService.fetchData();

        LiveMenuNewService liveMenuNewService = LiveMenuNewService();

        List<LiveMenuNew> liveMenuNew = [];

        liveMenuNew = await liveMenuNewService.fetchData();

        LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesLunch = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesDinner = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesAll = {};


        for(var item in liveMenuNew) {
          Map<String,dynamic> oneItem = {
            'ritem_UId' : item.ritemUId,
            'disName' : item.ritemDispname,
            'day' : item.day,
            'tag' : item.ritemTag,
            'date' : item.date,
            'ritem_availability' : item.ritemAvailability,
            'ritem_availability_type': item.ritemAvailability,
            'breakfastEnable' : item.mealsSessionCount.breakfast.enabled,
            'lunchEnable' : item.mealsSessionCount.lunch.enabled,
            'dinnerEnable' : item.mealsSessionCount.dinner.enabled,
            'breakfastSession1' : item.mealsSessionCount.breakfast.session1.availableCount,
            'breakfastSession2' : item.mealsSessionCount.breakfast.session2.availableCount,
            'breakfastSession3' : item.mealsSessionCount.breakfast.session3.availableCount,
            'breakfastSession1Enable' : item.mealsSessionCount.breakfast.session1.enabled,
            'breakfastSession2Enable' : item.mealsSessionCount.breakfast.session2.enabled,
            'breakfastSession3Enable' : item.mealsSessionCount.breakfast.session3.enabled,
            'lunchSession1Enable' : item.mealsSessionCount.lunch.session1.enabled,
            'lunchSession2Enable' : item.mealsSessionCount.lunch.session2.enabled,
            'lunchSession3Enable' : item.mealsSessionCount.lunch.session3.enabled,
            'dinnerSession1Enable' : item.mealsSessionCount.dinner.session1.enabled,
            'dinnerSession2Enable' : item.mealsSessionCount.dinner.session2.enabled,
            'dinnerSession3Enable' : item.mealsSessionCount.dinner.session3.enabled,
            'lunchSession1' : item.mealsSessionCount.lunch.session1.availableCount,
            'lunchSession2' : item.mealsSessionCount.lunch.session2.availableCount,
            'lunchSession3' : item.mealsSessionCount.lunch.session3.availableCount,
            'dinnerSession1' : item.mealsSessionCount.dinner.session1.availableCount,
            'dinnerSession2' : item.mealsSessionCount.dinner.session2.availableCount,
            'dinnerSession3' : item.mealsSessionCount.dinner.session3.availableCount,
          };

          if (LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag] = [];
          }

          GlobalVariables.selectedDay = dayProvider.selectedDay;

          if(oneItem['day'].toString().substring(0,3) == dayProvider.selectedDay.substring(0,3) && (oneItem['breakfastSession1'] > 0 || oneItem['breakfastSession2'] > 0 || oneItem['breakfastSession3'] > 0 ) && (oneItem['lunchSession1'] == 0 && oneItem['lunchSession2'] == 0 && oneItem['lunchSession3'] == 0 && (oneItem['dinnerSession1'] == 0 && oneItem['dinnerSession2'] == 0 && oneItem['dinnerSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesBreakfast.add(item.ritemTag);
          } else if(oneItem['day'].toString().substring(0,3) == dayProvider.selectedDay.substring(0,3) && (oneItem['lunchSession1'] > 0 || oneItem['lunchSession2'] > 0 || oneItem['lunchSession3'] > 0 )  && (oneItem['breakfastSession1'] == 0 && oneItem['breakfastSession2'] == 0 && oneItem['breakfastSession3'] == 0 && (oneItem['dinnerSession1'] == 0 && oneItem['dinnerSession2'] == 0 && oneItem['dinnerSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesLunch.add(item.ritemTag);
          } else if(oneItem['day'].toString().substring(0,3) == dayProvider.selectedDay.substring(0,3) && (oneItem['dinnerSession1'] > 0 || oneItem['dinnerSession2'] > 0 || oneItem['dinnerSession3'] > 0 ) && (oneItem['lunchSession1'] == 0 && oneItem['lunchSession2'] == 0 && oneItem['lunchSession3'] == 0 && (oneItem['breakfastSession1'] == 0 && oneItem['breakfastSession2'] == 0 && oneItem['breakfastSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesDinner.add(item.ritemTag);
          } else if(oneItem['day'].toString().substring(0,3) == dayProvider.selectedDay.substring(0,3) && (oneItem['dinnerSession1'] > 0 || oneItem['dinnerSession2'] > 0 || oneItem['dinnerSession3'] > 0 || oneItem['breakfastSession1'] > 0 || oneItem['breakfastSession2'] > 0 || oneItem['breakfastSession3'] > 0 || oneItem['lunchSession1'] > 0 || oneItem['lunchSession2'] > 0 || oneItem['lunchSession3'] > 0   )) {
            LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesAll.add(item.ritemTag);
          }


        }

        emit(LiveMenu1LoadedState(
          LiveMenuVariables.selectedCategoriesBreakfast,
          LiveMenuVariables.selectedCategoriesLunch,
          LiveMenuVariables.selectedCategoriesDinner,
          LiveMenuVariables.selectedCategoriesAll,
            liveMenu, liveMenu,
            LiveMenuVariables.liveMenufoodCategoriesBreakfast,
          LiveMenuVariables.liveMenufoodCategoriesLunch,
          LiveMenuVariables.liveMenufoodCategoriesDinner,
          LiveMenuVariables.liveMenufoodCategoriesAll,
            LiveMenuVariables.liveMenuSelectItemBreakfast,
          LiveMenuVariables.liveMenuSelectItemLunch,
          LiveMenuVariables.liveMenuSelectItemDinner,
          LiveMenuVariables.liveMenuSelectItemAll,
        ));
      } catch (e) {
        print("Live menu error ${e.toString()}");
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });

    on<LiveMenuDateSelectEvent>((event, emit) async {
      emit(LiveMenu1LoadingState());
      try {
        print("event ${event.date }  and ${event.date.substring(0,3)}");
        List<String> keysToRemove = [];
        List<LiveMenuModel> liveMenu = [];
        liveMenu = await _liveMenuService.fetchData();


        LiveMenuNewService liveMenuNewService = LiveMenuNewService();

        List<LiveMenuNew> liveMenuNew = [];

        liveMenuNew = await liveMenuNewService.fetchData();

        LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesLunch = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesDinner = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesAll = {};

        for(var item in liveMenuNew) {
          Map<String,dynamic> oneItem = {
            'ritem_UId' : item.ritemUId,
            'disName' : item.ritemDispname,
            'day' : item.day,
            'tag' : item.ritemTag,
            'date' : item.date,
            'ritem_availability' : item.ritemAvailability,
            'ritem_availability_type': item.ritemAvailability,
            'breakfastEnable' : item.mealsSessionCount.breakfast.enabled,
            'lunchEnable' : item.mealsSessionCount.lunch.enabled,
            'dinnerEnable' : item.mealsSessionCount.dinner.enabled,
            'breakfastSession1' : item.mealsSessionCount.breakfast.session1.availableCount,
            'breakfastSession2' : item.mealsSessionCount.breakfast.session2.availableCount,
            'breakfastSession3' : item.mealsSessionCount.breakfast.session3.availableCount,
            'breakfastSession1Enable' : item.mealsSessionCount.breakfast.session1.enabled,
            'breakfastSession2Enable' : item.mealsSessionCount.breakfast.session2.enabled,
            'breakfastSession3Enable' : item.mealsSessionCount.breakfast.session3.enabled,
            'lunchSession1Enable' : item.mealsSessionCount.lunch.session1.enabled,
            'lunchSession2Enable' : item.mealsSessionCount.lunch.session2.enabled,
            'lunchSession3Enable' : item.mealsSessionCount.lunch.session3.enabled,
            'dinnerSession1Enable' : item.mealsSessionCount.dinner.session1.enabled,
            'dinnerSession2Enable' : item.mealsSessionCount.dinner.session2.enabled,
            'dinnerSession3Enable' : item.mealsSessionCount.dinner.session3.enabled,
            'lunchSession1' : item.mealsSessionCount.lunch.session1.availableCount,
            'lunchSession2' : item.mealsSessionCount.lunch.session2.availableCount,
            'lunchSession3' : item.mealsSessionCount.lunch.session3.availableCount,
            'dinnerSession1' : item.mealsSessionCount.dinner.session1.availableCount,
            'dinnerSession2' : item.mealsSessionCount.dinner.session2.availableCount,
            'dinnerSession3' : item.mealsSessionCount.dinner.session3.availableCount,
          };

          if (LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag] = [];
          }


          if(oneItem['day'].toString().substring(0,3) == event.date.substring(0,3) && (oneItem['breakfastSession1'] > 0 || oneItem['breakfastSession2'] > 0 || oneItem['breakfastSession3'] > 0 ) && (oneItem['lunchSession1'] == 0 && oneItem['lunchSession2'] == 0 && oneItem['lunchSession3'] == 0 && (oneItem['dinnerSession1'] == 0 && oneItem['dinnerSession2'] == 0 && oneItem['dinnerSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesBreakfast.add(item.ritemTag);
          } else if(oneItem['day'].toString().substring(0,3) == event.date.substring(0,3) && (oneItem['lunchSession1'] > 0 || oneItem['lunchSession2'] > 0 || oneItem['lunchSession3'] > 0 )  && (oneItem['breakfastSession1'] == 0 && oneItem['breakfastSession2'] == 0 && oneItem['breakfastSession3'] == 0 && (oneItem['dinnerSession1'] == 0 && oneItem['dinnerSession2'] == 0 && oneItem['dinnerSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesLunch.add(item.ritemTag);
          } else if(oneItem['day'].toString().substring(0,3) == event.date.substring(0,3) && (oneItem['dinnerSession1'] > 0 || oneItem['dinnerSession2'] > 0 || oneItem['dinnerSession3'] > 0 ) && (oneItem['lunchSession1'] == 0 && oneItem['lunchSession2'] == 0 && oneItem['lunchSession3'] == 0 && (oneItem['breakfastSession1'] == 0 && oneItem['breakfastSession2'] == 0 && oneItem['breakfastSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesDinner.add(item.ritemTag);
          } else if(oneItem['day'].toString().substring(0,3) == event.date.substring(0,3) && (oneItem['dinnerSession1'] > 0 || oneItem['dinnerSession2'] > 0 || oneItem['dinnerSession3'] > 0 || oneItem['breakfastSession1'] > 0 || oneItem['breakfastSession2'] > 0 || oneItem['breakfastSession3'] > 0 || oneItem['lunchSession1'] > 0 || oneItem['lunchSession2'] > 0 || oneItem['lunchSession3'] > 0   )) {
            LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesAll.add(item.ritemTag);
          }

          LiveMenuVariables.liveMenufoodCategoriesBreakfast.forEach((key, category) {
            if (category.isEmpty) {
              keysToRemove.add(key);
            }
          });

          keysToRemove.forEach((key) {
            LiveMenuVariables.liveMenufoodCategoriesBreakfast.remove(key);
          });




        }


        emit(LiveMenu1LoadedState(
          LiveMenuVariables.selectedCategoriesBreakfast,
            LiveMenuVariables.selectedCategoriesLunch,
            LiveMenuVariables.selectedCategoriesDinner,
          LiveMenuVariables.selectedCategoriesAll,
            liveMenu,liveMenu,
          LiveMenuVariables.liveMenufoodCategoriesBreakfast,
          LiveMenuVariables.liveMenufoodCategoriesLunch,
          LiveMenuVariables.liveMenufoodCategoriesDinner,
          LiveMenuVariables.liveMenufoodCategoriesAll,
          LiveMenuVariables.liveMenuSelectItemBreakfast,
          LiveMenuVariables.liveMenuSelectItemLunch,
          LiveMenuVariables.liveMenuSelectItemDinner,
          LiveMenuVariables.liveMenuSelectItemAll,
        ));
      } catch (e) {
        print("Date menu error ${e.toString()}");
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });

    on<SelectLiveMenuBreakfastCategoryEvent>((event, emit) async {
      emit(LiveMenu1LoadingState());
      try {

        Set<String> updatedCategories = Set<String>();

        if (updatedCategories.contains(event.categoryName)) {
          updatedCategories.remove(event.categoryName);
        } else {
          updatedCategories = {event.categoryName};
        }
        emit(LiveMenu1LoadedState(
            updatedCategories,
            LiveMenuVariables.selectedCategoriesLunch,
            LiveMenuVariables.selectedCategoriesDinner,
          LiveMenuVariables.selectedCategoriesAll,
            [],[],
          LiveMenuVariables.liveMenufoodCategoriesBreakfast,
          LiveMenuVariables.liveMenufoodCategoriesLunch,
          LiveMenuVariables.liveMenufoodCategoriesDinner,
          LiveMenuVariables.liveMenufoodCategoriesAll,
          LiveMenuVariables.liveMenuSelectItemBreakfast,
          LiveMenuVariables.liveMenuSelectItemLunch,
          LiveMenuVariables.liveMenuSelectItemDinner,
            LiveMenuVariables.liveMenuSelectItemAll
        ));
      } catch (e) {
        print("MEnu Editor error is ${e.toString()}");
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });

    on<LiveMenuBreakfastItemSelectEvent>((event, emit) async {
      emit(LiveMenu1LoadingState());
      try{

        LiveMenuVariables.liveMenuSelectItemBreakfast = event.menuItem;


        emit(LiveMenu1LoadedState(
            LiveMenuVariables.selectedCategoriesBreakfast,
            LiveMenuVariables.selectedCategoriesLunch,
            LiveMenuVariables.selectedCategoriesDinner,
            LiveMenuVariables.selectedCategoriesAll,
            [],[],
          LiveMenuVariables.liveMenufoodCategoriesBreakfast,
          LiveMenuVariables.liveMenufoodCategoriesLunch,
          LiveMenuVariables.liveMenufoodCategoriesDinner,
            LiveMenuVariables.liveMenufoodCategoriesAll,
          LiveMenuVariables.liveMenuSelectItemBreakfast,
          LiveMenuVariables.liveMenuSelectItemLunch,
          LiveMenuVariables.liveMenuSelectItemDinner,
            LiveMenuVariables.liveMenuSelectItemAll));
      } catch (e) {
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });

    on<SelectLiveMenuLunchCategoryEvent>((event, emit) async {
      emit(LiveMenu1LoadingState());
      try {

        Set<String> updatedCategories = Set<String>();

        if (updatedCategories.contains(event.categoryName)) {
          updatedCategories.remove(event.categoryName);
        } else {
          updatedCategories = {event.categoryName};
        }
        emit(LiveMenu1LoadedState(
          LiveMenuVariables.selectedCategoriesBreakfast,
          updatedCategories,
          LiveMenuVariables.selectedCategoriesDinner,
          LiveMenuVariables.selectedCategoriesAll,
          [],[],
          LiveMenuVariables.liveMenufoodCategoriesBreakfast,
          LiveMenuVariables.liveMenufoodCategoriesLunch,
          LiveMenuVariables.liveMenufoodCategoriesDinner,
          LiveMenuVariables.liveMenufoodCategoriesAll,
          LiveMenuVariables.liveMenuSelectItemBreakfast,
          LiveMenuVariables.liveMenuSelectItemLunch,
          LiveMenuVariables.liveMenuSelectItemDinner,
          LiveMenuVariables.liveMenuSelectItemAll,
        ));
      } catch (e) {
        print("MEnu Editor error is ${e.toString()}");
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });

    on<LiveMenuLunchItemSelectEvent>((event, emit) async {
      emit(LiveMenu1LoadingState());
      try{

        LiveMenuVariables.liveMenuSelectItemLunch = event.menuItem;


        emit(LiveMenu1LoadedState(
            LiveMenuVariables.selectedCategoriesBreakfast,
            LiveMenuVariables.selectedCategoriesLunch,
            LiveMenuVariables.selectedCategoriesDinner,
            LiveMenuVariables.selectedCategoriesAll,
            [],[],
            LiveMenuVariables.liveMenufoodCategoriesBreakfast,
            LiveMenuVariables.liveMenufoodCategoriesLunch,
            LiveMenuVariables.liveMenufoodCategoriesDinner,
            LiveMenuVariables.liveMenufoodCategoriesAll,
            LiveMenuVariables.liveMenuSelectItemBreakfast,
            LiveMenuVariables.liveMenuSelectItemLunch,
            LiveMenuVariables.liveMenuSelectItemDinner,
            LiveMenuVariables.liveMenuSelectItemAll
        ));
      } catch (e) {
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });

    on<SelectLiveMenuDinnerCategoryEvent>((event, emit) async {
      emit(LiveMenu1LoadingState());
      try {

        Set<String> updatedCategories = Set<String>();

        if (updatedCategories.contains(event.categoryName)) {
          updatedCategories.remove(event.categoryName);
        } else {
          updatedCategories = {event.categoryName};
        }
        emit(LiveMenu1LoadedState(
          LiveMenuVariables.selectedCategoriesBreakfast,
          LiveMenuVariables.selectedCategoriesLunch,
          updatedCategories,
          LiveMenuVariables.selectedCategoriesAll,
          [],[],
          LiveMenuVariables.liveMenufoodCategoriesBreakfast,
          LiveMenuVariables.liveMenufoodCategoriesLunch,
          LiveMenuVariables.liveMenufoodCategoriesDinner,
          LiveMenuVariables.liveMenufoodCategoriesAll,
          LiveMenuVariables.liveMenuSelectItemBreakfast,
          LiveMenuVariables.liveMenuSelectItemLunch,
          LiveMenuVariables.liveMenuSelectItemDinner,
          LiveMenuVariables.liveMenuSelectItemAll,
        ));
      } catch (e) {
        print("MEnu Editor error is ${e.toString()}");
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });

    on<LiveMenuDinnerItemSelectEvent>((event, emit) async {
      emit(LiveMenu1LoadingState());
      try{

        LiveMenuVariables.liveMenuSelectItemDinner = event.menuItem;


        emit(LiveMenu1LoadedState(
            LiveMenuVariables.selectedCategoriesBreakfast,
            LiveMenuVariables.selectedCategoriesLunch,
            LiveMenuVariables.selectedCategoriesDinner,
            LiveMenuVariables.selectedCategoriesAll,
            [],[],
            LiveMenuVariables.liveMenufoodCategoriesBreakfast,
            LiveMenuVariables.liveMenufoodCategoriesLunch,
            LiveMenuVariables.liveMenufoodCategoriesDinner,
            LiveMenuVariables.liveMenufoodCategoriesAll,
            LiveMenuVariables.liveMenuSelectItemBreakfast,
            LiveMenuVariables.liveMenuSelectItemLunch,
            LiveMenuVariables.liveMenuSelectItemDinner,
            LiveMenuVariables.liveMenuSelectItemAll
        ));
      } catch (e) {
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });

    on<SelectLiveMenuAllCategoryEvent>((event, emit) async {
      emit(LiveMenu1LoadingState());
      try {

        Set<String> updatedCategories = Set<String>();

        if (updatedCategories.contains(event.categoryName)) {
          updatedCategories.remove(event.categoryName);
        } else {
          updatedCategories = {event.categoryName};
        }
        emit(LiveMenu1LoadedState(
          LiveMenuVariables.selectedCategoriesBreakfast,
          LiveMenuVariables.selectedCategoriesLunch,
          LiveMenuVariables.selectedCategoriesDinner,
          updatedCategories,
          [],[],
          LiveMenuVariables.liveMenufoodCategoriesBreakfast,
          LiveMenuVariables.liveMenufoodCategoriesLunch,
          LiveMenuVariables.liveMenufoodCategoriesDinner,
          LiveMenuVariables.liveMenufoodCategoriesAll,
          LiveMenuVariables.liveMenuSelectItemBreakfast,
          LiveMenuVariables.liveMenuSelectItemLunch,
          LiveMenuVariables.liveMenuSelectItemDinner,
          LiveMenuVariables.liveMenuSelectItemAll,
        ));
      } catch (e) {
        print("MEnu Editor error is ${e.toString()}");
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });

    on<LiveMenuAllItemSelectEvent>((event, emit) async {
      emit(LiveMenu1LoadingState());
      try{

        LiveMenuVariables.liveMenuSelectItemAll = event.menuItem;


        emit(LiveMenu1LoadedState(
            LiveMenuVariables.selectedCategoriesBreakfast,
            LiveMenuVariables.selectedCategoriesLunch,
            LiveMenuVariables.selectedCategoriesDinner,
            LiveMenuVariables.selectedCategoriesAll,
            [],[],
            LiveMenuVariables.liveMenufoodCategoriesBreakfast,
            LiveMenuVariables.liveMenufoodCategoriesLunch,
            LiveMenuVariables.liveMenufoodCategoriesDinner,
            LiveMenuVariables.liveMenufoodCategoriesAll,
            LiveMenuVariables.liveMenuSelectItemBreakfast,
            LiveMenuVariables.liveMenuSelectItemLunch,
            LiveMenuVariables.liveMenuSelectItemDinner,
            LiveMenuVariables.liveMenuSelectItemAll
        ));
      } catch (e) {
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });

    on<DeleteItemEvent>((event,emit) async {
      emit(LiveMenu1LoadingState());
      try {
        LiveMenuNewService liveMenuNewService = LiveMenuNewService();

        await liveMenuNewService.deleteItem(event.data);

        event.foodCategories[event.tagName]!.removeWhere((item) => item['ritem_UId'] == event.data["ritem_UId"] );

        // LiveMenuVariables.foodCategories[event.tagName]!.removeWhere((item) => item['_id'] == event.id);

        emit(LiveMenu1LoadedState(
            LiveMenuVariables.selectedCategoriesBreakfast,
            LiveMenuVariables.selectedCategoriesLunch,
            LiveMenuVariables.selectedCategoriesDinner,
            LiveMenuVariables.selectedCategoriesAll,
            [],[],
            LiveMenuVariables.liveMenufoodCategoriesBreakfast,
            LiveMenuVariables.liveMenufoodCategoriesLunch,
            LiveMenuVariables.liveMenufoodCategoriesDinner,
            LiveMenuVariables.liveMenufoodCategoriesAll,
            LiveMenuVariables.liveMenuSelectItemBreakfast,
            LiveMenuVariables.liveMenuSelectItemLunch,
            LiveMenuVariables.liveMenuSelectItemDinner,
            LiveMenuVariables.liveMenuSelectItemAll
        ));
      }catch(e) {
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });

    on<UpdateItemEvent>((event,emit) async {
      emit(LiveMenu1LoadingState());
      try {

        LiveMenuNewService liveMenuNewService = LiveMenuNewService();

        await liveMenuNewService.updateItem(event.data);

        List<LiveMenuNew> liveMenuNew = [];

        liveMenuNew = await liveMenuNewService.fetchData();

        print("DAte ${GlobalVariables.selectedDay}");

        LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesLunch = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesDinner = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesAll = {};

        for(var item in liveMenuNew) {
          Map<String,dynamic> oneItem = {
            'ritem_UId' : item.ritemUId,
            'disName' : item.ritemDispname,
            'day' : item.day,
            'tag' : item.ritemTag,
            'date' : item.date,
            'ritem_availability' : item.ritemAvailability,
            'ritem_availability_type': item.ritemAvailability,
            'breakfastEnable' : item.mealsSessionCount.breakfast.enabled,
            'lunchEnable' : item.mealsSessionCount.lunch.enabled,
            'dinnerEnable' : item.mealsSessionCount.dinner.enabled,
            'breakfastSession1' : item.mealsSessionCount.breakfast.session1.availableCount,
            'breakfastSession2' : item.mealsSessionCount.breakfast.session2.availableCount,
            'breakfastSession3' : item.mealsSessionCount.breakfast.session3.availableCount,
            'breakfastSession1Enable' : item.mealsSessionCount.breakfast.session1.enabled,
            'breakfastSession2Enable' : item.mealsSessionCount.breakfast.session2.enabled,
            'breakfastSession3Enable' : item.mealsSessionCount.breakfast.session3.enabled,
            'lunchSession1Enable' : item.mealsSessionCount.lunch.session1.enabled,
            'lunchSession2Enable' : item.mealsSessionCount.lunch.session2.enabled,
            'lunchSession3Enable' : item.mealsSessionCount.lunch.session3.enabled,
            'dinnerSession1Enable' : item.mealsSessionCount.dinner.session1.enabled,
            'dinnerSession2Enable' : item.mealsSessionCount.dinner.session2.enabled,
            'dinnerSession3Enable' : item.mealsSessionCount.dinner.session3.enabled,
            'lunchSession1' : item.mealsSessionCount.lunch.session1.availableCount,
            'lunchSession2' : item.mealsSessionCount.lunch.session2.availableCount,
            'lunchSession3' : item.mealsSessionCount.lunch.session3.availableCount,
            'dinnerSession1' : item.mealsSessionCount.dinner.session1.availableCount,
            'dinnerSession2' : item.mealsSessionCount.dinner.session2.availableCount,
            'dinnerSession3' : item.mealsSessionCount.dinner.session3.availableCount,
          };

          if (LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag] = [];
          }

          if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['breakfastSession1'] > 0 || oneItem['breakfastSession2'] > 0 || oneItem['breakfastSession3'] > 0 ) && (oneItem['lunchSession1'] == 0 && oneItem['lunchSession2'] == 0 && oneItem['lunchSession3'] == 0 && (oneItem['dinnerSession1'] == 0 && oneItem['dinnerSession2'] == 0 && oneItem['dinnerSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesBreakfast.add(item.ritemTag);
          }
          else if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['lunchSession1'] > 0 || oneItem['lunchSession2'] > 0 || oneItem['lunchSession3'] > 0 )  && (oneItem['breakfastSession1'] == 0 && oneItem['breakfastSession2'] == 0 && oneItem['breakfastSession3'] == 0 && (oneItem['dinnerSession1'] == 0 && oneItem['dinnerSession2'] == 0 && oneItem['dinnerSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesLunch.add(item.ritemTag);
          } else if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['dinnerSession1'] > 0 || oneItem['dinnerSession2'] > 0 || oneItem['dinnerSession3'] > 0 ) && (oneItem['lunchSession1'] == 0 && oneItem['lunchSession2'] == 0 && oneItem['lunchSession3'] == 0 && (oneItem['breakfastSession1'] == 0 && oneItem['breakfastSession2'] == 0 && oneItem['breakfastSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesDinner.add(item.ritemTag);
          } else if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['dinnerSession1'] > 0 || oneItem['dinnerSession2'] > 0 || oneItem['dinnerSession3'] > 0 || oneItem['breakfastSession1'] > 0 || oneItem['breakfastSession2'] > 0 || oneItem['breakfastSession3'] > 0 || oneItem['lunchSession1'] > 0 || oneItem['lunchSession2'] > 0 || oneItem['lunchSession3'] > 0   )) {
            LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesAll.add(item.ritemTag);
          }


        }

        emit(LiveMenu1LoadedState(
            LiveMenuVariables.selectedCategoriesBreakfast,
            LiveMenuVariables.selectedCategoriesLunch,
            LiveMenuVariables.selectedCategoriesDinner,
            LiveMenuVariables.selectedCategoriesAll,
            [],[],
            LiveMenuVariables.liveMenufoodCategoriesBreakfast,
            LiveMenuVariables.liveMenufoodCategoriesLunch,
            LiveMenuVariables.liveMenufoodCategoriesDinner,
            LiveMenuVariables.liveMenufoodCategoriesAll,
            LiveMenuVariables.liveMenuSelectItemBreakfast,
            LiveMenuVariables.liveMenuSelectItemLunch,
            LiveMenuVariables.liveMenuSelectItemDinner,
            LiveMenuVariables.liveMenuSelectItemAll
        ));
      }catch(e) {
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });


    on<AddLiveMenuItemEvent>((event,emit) async {
      emit(LiveMenu1LoadingState());
      try {
        LiveMenuNewService liveMenuNewService = LiveMenuNewService();

        await liveMenuNewService.postLiveMenuData(event.data);

        List<LiveMenuNew> liveMenuNew = [];

        liveMenuNew = await liveMenuNewService.fetchData();

        LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesLunch = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesDinner = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesAll = {};


        for(var item in liveMenuNew) {
          Map<String,dynamic> oneItem = {
            'ritem_UId' : item.ritemUId,
            'disName' : item.ritemDispname,
            'day' : item.day,
            'tag' : item.ritemTag,
            'date' : item.date,
            'ritem_availability' : item.ritemAvailability,
            'ritem_availability_type': item.ritemAvailability,
            'breakfastEnable' : item.mealsSessionCount.breakfast.enabled,
            'lunchEnable' : item.mealsSessionCount.lunch.enabled,
            'dinnerEnable' : item.mealsSessionCount.dinner.enabled,
            'breakfastSession1' : item.mealsSessionCount.breakfast.session1.availableCount,
            'breakfastSession2' : item.mealsSessionCount.breakfast.session2.availableCount,
            'breakfastSession3' : item.mealsSessionCount.breakfast.session3.availableCount,
            'breakfastSession1Enable' : item.mealsSessionCount.breakfast.session1.enabled,
            'breakfastSession2Enable' : item.mealsSessionCount.breakfast.session2.enabled,
            'breakfastSession3Enable' : item.mealsSessionCount.breakfast.session3.enabled,
            'lunchSession1Enable' : item.mealsSessionCount.lunch.session1.enabled,
            'lunchSession2Enable' : item.mealsSessionCount.lunch.session2.enabled,
            'lunchSession3Enable' : item.mealsSessionCount.lunch.session3.enabled,
            'dinnerSession1Enable' : item.mealsSessionCount.dinner.session1.enabled,
            'dinnerSession2Enable' : item.mealsSessionCount.dinner.session2.enabled,
            'dinnerSession3Enable' : item.mealsSessionCount.dinner.session3.enabled,
            'lunchSession1' : item.mealsSessionCount.lunch.session1.availableCount,
            'lunchSession2' : item.mealsSessionCount.lunch.session2.availableCount,
            'lunchSession3' : item.mealsSessionCount.lunch.session3.availableCount,
            'dinnerSession1' : item.mealsSessionCount.dinner.session1.availableCount,
            'dinnerSession2' : item.mealsSessionCount.dinner.session2.availableCount,
            'dinnerSession3' : item.mealsSessionCount.dinner.session3.availableCount,
          };

          if (LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag] = [];
          }

          if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['breakfastSession1'] > 0 || oneItem['breakfastSession2'] > 0 || oneItem['breakfastSession3'] > 0 ) && (oneItem['lunchSession1'] == 0 && oneItem['lunchSession2'] == 0 && oneItem['lunchSession3'] == 0 && (oneItem['dinnerSession1'] == 0 && oneItem['dinnerSession2'] == 0 && oneItem['dinnerSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesBreakfast.add(item.ritemTag);
          }
          else if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['lunchSession1'] > 0 || oneItem['lunchSession2'] > 0 || oneItem['lunchSession3'] > 0 )  && (oneItem['breakfastSession1'] == 0 && oneItem['breakfastSession2'] == 0 && oneItem['breakfastSession3'] == 0 && (oneItem['dinnerSession1'] == 0 && oneItem['dinnerSession2'] == 0 && oneItem['dinnerSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesLunch.add(item.ritemTag);
          } else if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['dinnerSession1'] > 0 || oneItem['dinnerSession2'] > 0 || oneItem['dinnerSession3'] > 0 ) && (oneItem['lunchSession1'] == 0 && oneItem['lunchSession2'] == 0 && oneItem['lunchSession3'] == 0 && (oneItem['breakfastSession1'] == 0 && oneItem['breakfastSession2'] == 0 && oneItem['breakfastSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesDinner.add(item.ritemTag);
          } else if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['dinnerSession1'] > 0 || oneItem['dinnerSession2'] > 0 || oneItem['dinnerSession3'] > 0 || oneItem['breakfastSession1'] > 0 || oneItem['breakfastSession2'] > 0 || oneItem['breakfastSession3'] > 0 || oneItem['lunchSession1'] > 0 || oneItem['lunchSession2'] > 0 || oneItem['lunchSession3'] > 0   )) {
            LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesAll.add(item.ritemTag);
          }


        }

        emit(LiveMenu1LoadedState(
            LiveMenuVariables.selectedCategoriesBreakfast,
            LiveMenuVariables.selectedCategoriesLunch,
            LiveMenuVariables.selectedCategoriesDinner,
            LiveMenuVariables.selectedCategoriesAll,
            [],[],
            LiveMenuVariables.liveMenufoodCategoriesBreakfast,
            LiveMenuVariables.liveMenufoodCategoriesLunch,
            LiveMenuVariables.liveMenufoodCategoriesDinner,
            LiveMenuVariables.liveMenufoodCategoriesAll,
            LiveMenuVariables.liveMenuSelectItemBreakfast,
            LiveMenuVariables.liveMenuSelectItemLunch,
            LiveMenuVariables.liveMenuSelectItemDinner,
            LiveMenuVariables.liveMenuSelectItemAll
        ));
      }catch(e) {
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });

    on<AddLiveMenuItemFromLiveMenuEvent>((event,emit) async {
      emit(LiveMenu1LoadingState());
      try {
        LiveMenuNewService liveMenuNewService = LiveMenuNewService();

        await liveMenuNewService.postLiveMenuDataFromLiveMenu(event.data);

        List<LiveMenuNew> liveMenuNew = [];

        liveMenuNew = await liveMenuNewService.fetchData();

        LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesLunch = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesDinner = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesAll = {};


        for(var item in liveMenuNew) {
          Map<String,dynamic> oneItem = {
            'ritem_UId' : item.ritemUId,
            'disName' : item.ritemDispname,
            'day' : item.day,
            'tag' : item.ritemTag,
            'date' : item.date,
            'ritem_availability' : item.ritemAvailability,
            'ritem_availability_type': item.ritemAvailability,
            'breakfastEnable' : item.mealsSessionCount.breakfast.enabled,
            'lunchEnable' : item.mealsSessionCount.lunch.enabled,
            'dinnerEnable' : item.mealsSessionCount.dinner.enabled,
            'breakfastSession1' : item.mealsSessionCount.breakfast.session1.availableCount,
            'breakfastSession2' : item.mealsSessionCount.breakfast.session2.availableCount,
            'breakfastSession3' : item.mealsSessionCount.breakfast.session3.availableCount,
            'breakfastSession1Enable' : item.mealsSessionCount.breakfast.session1.enabled,
            'breakfastSession2Enable' : item.mealsSessionCount.breakfast.session2.enabled,
            'breakfastSession3Enable' : item.mealsSessionCount.breakfast.session3.enabled,
            'lunchSession1Enable' : item.mealsSessionCount.lunch.session1.enabled,
            'lunchSession2Enable' : item.mealsSessionCount.lunch.session2.enabled,
            'lunchSession3Enable' : item.mealsSessionCount.lunch.session3.enabled,
            'dinnerSession1Enable' : item.mealsSessionCount.dinner.session1.enabled,
            'dinnerSession2Enable' : item.mealsSessionCount.dinner.session2.enabled,
            'dinnerSession3Enable' : item.mealsSessionCount.dinner.session3.enabled,
            'lunchSession1' : item.mealsSessionCount.lunch.session1.availableCount,
            'lunchSession2' : item.mealsSessionCount.lunch.session2.availableCount,
            'lunchSession3' : item.mealsSessionCount.lunch.session3.availableCount,
            'dinnerSession1' : item.mealsSessionCount.dinner.session1.availableCount,
            'dinnerSession2' : item.mealsSessionCount.dinner.session2.availableCount,
            'dinnerSession3' : item.mealsSessionCount.dinner.session3.availableCount,
          };

          if (LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag] = [];
          }

          if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['breakfastSession1'] > 0 || oneItem['breakfastSession2'] > 0 || oneItem['breakfastSession3'] > 0 ) && (oneItem['lunchSession1'] == 0 && oneItem['lunchSession2'] == 0 && oneItem['lunchSession3'] == 0 && (oneItem['dinnerSession1'] == 0 && oneItem['dinnerSession2'] == 0 && oneItem['dinnerSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesBreakfast.add(item.ritemTag);
          }
          else if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['lunchSession1'] > 0 || oneItem['lunchSession2'] > 0 || oneItem['lunchSession3'] > 0 )  && (oneItem['breakfastSession1'] == 0 && oneItem['breakfastSession2'] == 0 && oneItem['breakfastSession3'] == 0 && (oneItem['dinnerSession1'] == 0 && oneItem['dinnerSession2'] == 0 && oneItem['dinnerSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesLunch.add(item.ritemTag);
          } else if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['dinnerSession1'] > 0 || oneItem['dinnerSession2'] > 0 || oneItem['dinnerSession3'] > 0 ) && (oneItem['lunchSession1'] == 0 && oneItem['lunchSession2'] == 0 && oneItem['lunchSession3'] == 0 && (oneItem['breakfastSession1'] == 0 && oneItem['breakfastSession2'] == 0 && oneItem['breakfastSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesDinner.add(item.ritemTag);
          } else if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['dinnerSession1'] > 0 || oneItem['dinnerSession2'] > 0 || oneItem['dinnerSession3'] > 0 || oneItem['breakfastSession1'] > 0 || oneItem['breakfastSession2'] > 0 || oneItem['breakfastSession3'] > 0 || oneItem['lunchSession1'] > 0 || oneItem['lunchSession2'] > 0 || oneItem['lunchSession3'] > 0   )) {
            LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesAll.add(item.ritemTag);
          }


        }

        emit(LiveMenu1LoadedState(
            LiveMenuVariables.selectedCategoriesBreakfast,
            LiveMenuVariables.selectedCategoriesLunch,
            LiveMenuVariables.selectedCategoriesDinner,
            LiveMenuVariables.selectedCategoriesAll,
            [],[],
            LiveMenuVariables.liveMenufoodCategoriesBreakfast,
            LiveMenuVariables.liveMenufoodCategoriesLunch,
            LiveMenuVariables.liveMenufoodCategoriesDinner,
            LiveMenuVariables.liveMenufoodCategoriesAll,
            LiveMenuVariables.liveMenuSelectItemBreakfast,
            LiveMenuVariables.liveMenuSelectItemLunch,
            LiveMenuVariables.liveMenuSelectItemDinner,
            LiveMenuVariables.liveMenuSelectItemAll
        ));
      }catch(e) {
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });

    on<UpdateLiveMenuItemEvent>((event,emit) async {
      emit(LiveMenu1LoadingState());
      try {
        LiveMenuNewService liveMenuNewService = LiveMenuNewService();

        await liveMenuNewService.updateItems(event.data);

        List<LiveMenuNew> liveMenuNew = [];

        liveMenuNew = await liveMenuNewService.fetchData();

        LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesLunch = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesDinner = {};
        LiveMenuVariables.liveMenuNewfoodCategoriesAll = {};


        for(var item in liveMenuNew) {
          Map<String,dynamic> oneItem = {
            'ritem_UId' : item.ritemUId,
            'disName' : item.ritemDispname,
            'day' : item.day,
            'tag' : item.ritemTag,
            'date' : item.date,
            'ritem_availability' : item.ritemAvailability,
            'ritem_availability_type': item.ritemAvailability,
            'breakfastEnable' : item.mealsSessionCount.breakfast.enabled,
            'lunchEnable' : item.mealsSessionCount.lunch.enabled,
            'dinnerEnable' : item.mealsSessionCount.dinner.enabled,
            'breakfastSession1' : item.mealsSessionCount.breakfast.session1.availableCount,
            'breakfastSession2' : item.mealsSessionCount.breakfast.session2.availableCount,
            'breakfastSession3' : item.mealsSessionCount.breakfast.session3.availableCount,
            'breakfastSession1Enable' : item.mealsSessionCount.breakfast.session1.enabled,
            'breakfastSession2Enable' : item.mealsSessionCount.breakfast.session2.enabled,
            'breakfastSession3Enable' : item.mealsSessionCount.breakfast.session3.enabled,
            'lunchSession1Enable' : item.mealsSessionCount.lunch.session1.enabled,
            'lunchSession2Enable' : item.mealsSessionCount.lunch.session2.enabled,
            'lunchSession3Enable' : item.mealsSessionCount.lunch.session3.enabled,
            'dinnerSession1Enable' : item.mealsSessionCount.dinner.session1.enabled,
            'dinnerSession2Enable' : item.mealsSessionCount.dinner.session2.enabled,
            'dinnerSession3Enable' : item.mealsSessionCount.dinner.session3.enabled,
            'lunchSession1' : item.mealsSessionCount.lunch.session1.availableCount,
            'lunchSession2' : item.mealsSessionCount.lunch.session2.availableCount,
            'lunchSession3' : item.mealsSessionCount.lunch.session3.availableCount,
            'dinnerSession1' : item.mealsSessionCount.dinner.session1.availableCount,
            'dinnerSession2' : item.mealsSessionCount.dinner.session2.availableCount,
            'dinnerSession3' : item.mealsSessionCount.dinner.session3.availableCount,
          };

          if (LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag] = [];
          }

          if (LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag] == null) {
            LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag] = [];
          }

          if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['breakfastSession1'] > 0 || oneItem['breakfastSession2'] > 0 || oneItem['breakfastSession3'] > 0 ) && (oneItem['lunchSession1'] == 0 && oneItem['lunchSession2'] == 0 && oneItem['lunchSession3'] == 0 && (oneItem['dinnerSession1'] == 0 && oneItem['dinnerSession2'] == 0 && oneItem['dinnerSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesBreakfast.add(item.ritemTag);
          }
          else if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['lunchSession1'] > 0 || oneItem['lunchSession2'] > 0 || oneItem['lunchSession3'] > 0 )  && (oneItem['breakfastSession1'] == 0 && oneItem['breakfastSession2'] == 0 && oneItem['breakfastSession3'] == 0 && (oneItem['dinnerSession1'] == 0 && oneItem['dinnerSession2'] == 0 && oneItem['dinnerSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesLunch[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesLunch.add(item.ritemTag);
          }
          else if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['dinnerSession1'] > 0 || oneItem['dinnerSession2'] > 0 || oneItem['dinnerSession3'] > 0 ) && (oneItem['lunchSession1'] == 0 && oneItem['lunchSession2'] == 0 && oneItem['lunchSession3'] == 0 && (oneItem['breakfastSession1'] == 0 && oneItem['breakfastSession2'] == 0 && oneItem['breakfastSession3'] == 0))  ) {
            LiveMenuVariables.liveMenuNewfoodCategoriesDinner[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesDinner.add(item.ritemTag);
          }
          else if(oneItem['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3) && (oneItem['dinnerSession1'] > 0 || oneItem['dinnerSession2'] > 0 || oneItem['dinnerSession3'] > 0 || oneItem['breakfastSession1'] > 0 || oneItem['breakfastSession2'] > 0 || oneItem['breakfastSession3'] > 0 || oneItem['lunchSession1'] > 0 || oneItem['lunchSession2'] > 0 || oneItem['lunchSession3'] > 0   )) {
            LiveMenuVariables.liveMenuNewfoodCategoriesAll[item.ritemTag]!.add(oneItem);
            LiveMenuVariables.selectedCategoriesAll.add(item.ritemTag);
          }

        }

        emit(LiveMenu1LoadedState(
            LiveMenuVariables.selectedCategoriesBreakfast,
            LiveMenuVariables.selectedCategoriesLunch,
            LiveMenuVariables.selectedCategoriesDinner,
            LiveMenuVariables.selectedCategoriesAll,
            [],[],
            LiveMenuVariables.liveMenufoodCategoriesBreakfast,
            LiveMenuVariables.liveMenufoodCategoriesLunch,
            LiveMenuVariables.liveMenufoodCategoriesDinner,
            LiveMenuVariables.liveMenufoodCategoriesAll,
            LiveMenuVariables.liveMenuSelectItemBreakfast,
            LiveMenuVariables.liveMenuSelectItemLunch,
            LiveMenuVariables.liveMenuSelectItemDinner,
            LiveMenuVariables.liveMenuSelectItemAll
        ));
      }catch(e) {
        emit(LiveMenu1ErrorState(e.toString()));
      }
    });


  }
}