import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_event.dart';
import 'package:partner_admin_portal/bloc/menu/menu_event.dart';
import 'package:partner_admin_portal/bloc/menu/menu_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/manage_settings/manage_settings_variables.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_functions.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_variables.dart';
import 'package:partner_admin_portal/models/standard_menu_model.dart';
import 'package:partner_admin_portal/repository/live_menu_service.dart';
import 'package:partner_admin_portal/repository/menu_services.dart';
import '../../models/live_menu_new_model.dart';
import '../../models/restaurant_menu.dart';
import '../../provider/day_provider.dart';
import '../../repository/live_menu_new_service.dart';

List<Mymenu>  liveMenu = [];



class MenuBloc extends Bloc<MenuEvent,MenuState>{
  final MenuService _menuRepository;

  MenuBloc(this._menuRepository) : super(MenuLoadingState()) {

    on<LoadMenuEvent>((event, emit) async {
      emit(MenuLoadingState());
      try {

        List<Mymenu> menu = [];

        // liveMenu = [];
        //
        // DayProvider dayProvider = event.context.read<DayProvider>();
        //
        // print(dayProvider.selectedDay);

        bool fetchFirstItem = true;


        menu = await _menuRepository.fetchData();




        // MenuEditorVariables.subCategory = await _menuRepository.fetchSubCategory("Veg");
        //
        // MenuEditorVariables.cuisine = await _menuRepository.fetchCuisine();
        //
        // MenuEditorVariables.regional = await _menuRepository.fetchRegional();

        // GlobalVariables.totalFoodItems = menu;
        LiveMenuVariables.foodCategories = {};
        // MenuEditorVariables.menuFoodCategories = {};
        //
        // Set<String> tags = {};
        //
        // Set<String> uniqueRegionalItems = {};
        //
        // Set<String> uniqueCusineItems = {};

        for (var item in menu) {
          Map<String, dynamic> oneItem = {
            '_id' : item.id,
            'uId' : item.uId,
            'name': item.name,
            'disName' : item.dname,
            'availability': item.availability,
            'category': item.category,
            'normalPrice' : item.normalPrice,
            'halfNormalPrice' : item.halfNormalPrice ?? 0.0,
            'packagePrice' : item.packagePrice,
            'preorderPrice' : item.preorderPrice,
            'normalFinalPrice' : item.normalFinalPrice,
            'preOrderFinalPrice'  : item.preorderFinalPrice ?? 0,
            'halfPreorderPrice' : item.halfPreorderPrice ?? 0.0,
            'halfNormalFinalPrice' : item.halfNormalFinalPrice ?? 0.0,
            'halfPreOrderFinalPrice'  : item.halfPreorderFinalPrice ?? 0.0,
            'halfPrice' : item.halfPrice ?? false,
            'available_type' : item?.availableType ?? 0,
            'tag' : item.itemTag,
            'regional' : item.regional,
            'cuisine':item.cuisine,
            'priceRange' : item.priceRange,
            'itemType' : item.itemType,
            'itemSubType' : item.itemSubType,
            'comboType' : item.comboType,
            'rawSource' : item.rawSource,
            'subCategory' : item.subCategory,
            'consumptionMode' : item.consumptionMode ?? [],
            'sunBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession1 ?? 0,
            'sunBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession2 ?? 0,
            'sunBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession3 ?? 0,
            'sunLunchSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession1 ?? 0,
            'sunLunchSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession2 ?? 0,
            'sunLunchSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession3 ?? 0,
            'sunDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession1 ?? 0,
            'sunDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession2 ?? 0,
            'sunDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession3 ?? 0,
            'monBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession1 ?? 0,
            'monBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession2 ?? 0,
            'monBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession3 ?? 0,
            'monLunchSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession1 ?? 0,
            'monLunchSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession2 ?? 0,
            'monLunchSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession3 ?? 0,
            'monDinnerSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession1 ?? 0,
            'monDinnerSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession2 ?? 0,
            'monDinnerSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession3 ?? 0,
            'tueBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession1 ?? 0,
            'tueBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession2 ?? 0,
            'tueBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession3 ?? 0,
            'tueLunchSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession1 ?? 0,
            'tueLunchSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession2 ?? 0,
            'tueLunchSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession3 ?? 0,
            'tueDinnerSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession1 ?? 0,
            'tueDinnerSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession2 ?? 0,
            'tueDinnerSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession3 ?? 0,
            'wedBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession1 ?? 0,
            'wedBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession2 ?? 0,
            'wedBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession3 ?? 0,
            'wedLunchSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession1 ?? 0,
            'wedLunchSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession2 ?? 0,
            'wedLunchSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession3 ?? 0,
            'wedDinnerSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession1 ?? 0,
            'wedDinnerSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession2 ?? 0,
            'wedDinnerSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession3 ?? 0,
            'thuBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession1 ?? 0,
            'thuBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession2 ?? 0,
            'thuBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession3 ?? 0,
            'thuLunchSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession1 ?? 0,
            'thuLunchSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession2 ?? 0,
            'thuLunchSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession3 ?? 0,
            'thuDinnerSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession1 ?? 0,
            'thuDinnerSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession2 ?? 0,
            'thuDinnerSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession3 ?? 0,
            'friBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession1 ?? 0,
            'friBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession2 ?? 0,
            'friBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession3 ?? 0,
            'friLunchSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession1 ?? 0,
            'friLunchSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession2 ?? 0,
            'friLunchSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession3 ?? 0,
            'friDinnerSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession1 ?? 0,
            'friDinnerSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession2 ?? 0,
            'friDinnerSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession3 ?? 0,
            'satBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession1 ?? 0,
            'satBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession2 ?? 0,
            'satBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession3 ?? 0,
            'satLunchSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession1 ?? 0,
            'satLunchSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession2 ?? 0,
            'satLunchSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession3 ?? 0,
            'satDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession1 ?? 0,
            'satDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession2 ?? 0,
            'satDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession3 ?? 0,
            // 'breakfast' : item.fpUnitSessions.breakfast.defaultSession.enabled,
            // 'lunch' : item.fpUnitSessions.lunch.defaultSession.enabled,
            // 'dinner' : item.fpUnitSessions.dinner.defaultSession.enabled,
            // 'breakfastCount' : item.fpUnitSessions.breakfast.defaultSession.availableCount,
            // 'lunchCount' : item.fpUnitSessions.lunch.defaultSession.availableCount,
            // 'dinnerCount' : item.fpUnitSessions.dinner.defaultSession.availableCount,
            // 'breakfastSession1Count' : item.fpUnitSessions.breakfast.session1.availableCount,
            // 'breakfastSession2Count' : item.fpUnitSessions.breakfast.session2.availableCount,
            // 'breakfastSession3Count' : item.fpUnitSessions.breakfast.session3.availableCount,
            // 'breakfastSession4Count' : item.fpUnitSessions.breakfast.session4.availableCount,
            // 'lunchSession1Count' : item.fpUnitSessions.lunch.session1.availableCount,
            // 'lunchSession2Count' : item.fpUnitSessions.lunch.session2.availableCount,
            // 'lunchSession3Count' : item.fpUnitSessions.lunch.session3.availableCount,
            // 'lunchSession4Count' : item.fpUnitSessions.lunch.session4.availableCount,
            // 'dinnerSession1Count' : item.fpUnitSessions.dinner.session1.availableCount,
            // 'dinnerSession2Count' : item.fpUnitSessions.dinner.session2.availableCount,
            // 'dinnerSession3Count' : item.fpUnitSessions.dinner.session3.availableCount,
            // 'dinnerSession4Count' : item.fpUnitSessions.dinner.session4.availableCount,
          };

          // uniqueRegionalItems.add(item.regional);
          // uniqueCusineItems.add(item.cuisine);

          if (LiveMenuVariables.foodCategories[item.itemTag] == null) {
            LiveMenuVariables.foodCategories[item.itemTag] = [];
            // MenuEditorVariables.menuFoodCategories[item.itemTag] = [];
          }

          LiveMenuVariables.foodCategories[item.itemTag]!.add(oneItem);



          // if((item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.breakfastSession1 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.breakfastSession2 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.breakfastSession3 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.breakfastSession4 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.lunchSession1
          //     || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.lunchSession2 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.lunchSession3 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.lunchSession4 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.dinnerSession1 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.dinnerSession2 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.dinnerSession3
          //     || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.dinnerSession4) && item.availability ) {
          //   MenuEditorVariables.menuFoodCategories[item.itemTag]!.add(oneItem);
          //   // liveMenu.add(item);
          // }



          if(fetchFirstItem)
          {
            // LiveMenuVariables.selectItem = oneItem;
            MenuEditorVariables.selectItem = oneItem;
            MenuEditorVariables.selectedCategories.add(oneItem['tag']);
            MenuEditorVariables.tagController.text = oneItem['tag'];
            MenuEditorVariables.selectedItem = "";
            MenuEditorVariables.oldestTagName = oneItem['tag'];
            //  MenuEditorVariables.selectedItem = oneItem['disName'];
            // LiveMenuVariables.selectedCategories.add(oneItem['tag']);
            // MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S1'] = !oneItem['breakfast'];
            fetchFirstItem=false;
          }
        }

        // LiveMenuVariables.foodCategories.forEach((key, value) {
        //   tags.add(key); // Sets automatically handle uniqueness
        // });
        //
        // List<String> stdTags = await _menuRepository.fetchTags();
        // stdTags.forEach((element) {
        //   tags.add(element);
        // });
        //
        // MenuEditorVariables.tags = tags.toList();
        //
        //
        // MenuEditorVariables.regional = uniqueRegionalItems.toList();
        // MenuEditorVariables.cuisine = uniqueCusineItems.toList();

        emit(MenuLoadedState(menu,menu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
        MenuEditorVariables.tags = await _menuRepository.fetchTags();
      } catch (e) {
        print("Menu Error ${e.toString()}");
        emit(ErrorState(e.toString()));
      }
    });

    on<LoadMenuConsumptionModeEvent>((event,emit) async {
      emit(MenuLoadingState());
      try {
        List<String> menuConsumptionMode = MenuEditorVariables.consumptionMode;
        print("Inside menu bloc $menuConsumptionMode");
        emit(MenuConsumptionState(menuConsumptionMode));
      }catch (e){
        emit(ErrorState(e.toString()));
      }
    });

    on<HandleVegEvent>((event,emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];
        print("VEg selected value is");
        print(event.value);
        MenuEditorVariables.isVegChecked = event.value;
        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      }catch(e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<HandleNonVegEvent>((event,emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];
        print("VEg selected value is");
        print(event.value);
        MenuEditorVariables.isNonVegChecked = event.value;
        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      }catch(e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<HandleFoodEvent>((event,emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];
        print("VEg selected value is");
        print(event.value);
        MenuEditorVariables.isFood = event.value;
        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      }catch(e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<HandleBeverageEvent>((event,emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];
        print("VEg selected value is");
        print(event.value);
        MenuEditorVariables.isBeverage = event.value;
        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      }catch(e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<HandleBreakfastEvent>((event,emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];
        print("VEg selected value is");
        print(event.value);
        MenuEditorVariables.isBreakfast = event.value;
        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      }catch(e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<HandleLunchEvent>((event,emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];
        print("VEg selected value is");
        print(event.value);
        MenuEditorVariables.isLunch = event.value;
        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      }catch(e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<HandleDinnerEvent>((event,emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];
        print("VEg selected value is");
        print(event.value);
        MenuEditorVariables.isDinner = event.value;
        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      }catch(e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<HandleBudgetEvent>((event,emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];
        print("VEg selected value is");
        print(event.value);
        MenuEditorVariables.isBudget = event.value;
        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      }catch(e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<HandlePocketFriendlyEvent>((event,emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];
        print("VEg selected value is");
        print(event.value);
        MenuEditorVariables.isPocketFriendly = event.value;
        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      }catch(e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<HandlePremiumEvent>((event,emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];
        print("VEg selected value is");
        print(event.value);
        MenuEditorVariables.isPremium = event.value;
        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      }catch(e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<HandleLuxuryEvent>((event,emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];
        print("VEg selected value is");
        print(event.value);
        MenuEditorVariables.isLuxury = event.value;
        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      }catch(e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<LoadTagsEvent>((event, emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];

        MenuEditorVariables.tags = await _menuRepository.fetchTags();

        
        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      } catch (e) {
        print("Menu Error ${e.toString()}");
        emit(ErrorState(e.toString()));
      }
    });

    on<ItemSelectEvent>((event, emit) async {
      emit(MenuLoadingState());
      try{
        List<Mymenu> menu = [];

        LiveMenuVariables.selectItem = event.item;


        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories,MenuEditorVariables.selectItem));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<MenuItemSelectEvent>((event, emit) async {
      emit(MenuLoadingState());
      try{
        List<Mymenu> menu = [];

        MenuEditorVariables.selectItem = event.menuItem;

        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,
            LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories,
            MenuEditorVariables.selectItem));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<MenuDateSelectEvent>((event, emit) async {
      emit(MenuLoadingState());
      try {
        print("event ${event.date }  and ${event.date.substring(0,3)}");
        final menu = await _menuRepository.fetchData();
        List<Mymenu>  liveMenu = [];
        for (var item in menu) {
          Map<String, dynamic> oneItem = {
            '_id' : item.id,
            'name': item.name,
            'uId' : item.uId,
            'availability': item.availability,
            'category': item.category,
            'normalPrice' : item.normalPrice,
            'packagePrice' : item.packagePrice,
            'preorderPrice' : item.preorderPrice,
            'normalFinalPrice' : item.normalFinalPrice,
            'preOrderFinalPrice'  : item.preorderFinalPrice,
            'available_type' : item?.availableType ?? 0,
            'tag' : item.itemTag,
            'regional' : item.regional,
            'cuisine':item.cuisine,
            'priceRange' : item.priceRange,
            'itemType' : item.itemType,
            'comboType' : item.comboType,
            'rawSource' : item.rawSource,
            'subCategory' : item.subCategory,
            'consumptionMode' : item.consumptionMode ?? [],
            'sunBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession1 ?? 0,
            'sunBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession2 ?? 0,
            'sunBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession3 ?? 0,
            'sunLunchSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession1 ?? 0,
            'sunLunchSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession2 ?? 0,
            'sunLunchSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession3 ?? 0,
            'sunDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession1 ?? 0,
            'sunDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession2 ?? 0,
            'sunDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession3 ?? 0,
            'monBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession1 ?? 0,
            'monBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession2 ?? 0,
            'monBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession3 ?? 0,
            'monLunchSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession1 ?? 0,
            'monLunchSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession2 ?? 0,
            'monLunchSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession3 ?? 0,
            'monDinnerSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession1 ?? 0,
            'monDinnerSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession2 ?? 0,
            'monDinnerSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession3 ?? 0,
            'tueBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession1 ?? 0,
            'tueBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession2 ?? 0,
            'tueBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession3 ?? 0,
            'tueLunchSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession1 ?? 0,
            'tueLunchSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession2 ?? 0,
            'tueLunchSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession3 ?? 0,
            'tueDinnerSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession1 ?? 0,
            'tueDinnerSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession2 ?? 0,
            'tueDinnerSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession3 ?? 0,
            'wedBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession1 ?? 0,
            'wedBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession2 ?? 0,
            'wedBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession3 ?? 0,
            'wedLunchSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession1 ?? 0,
            'wedLunchSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession2 ?? 0,
            'wedLunchSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession3 ?? 0,
            'wedDinnerSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession1 ?? 0,
            'wedDinnerSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession2 ?? 0,
            'wedDinnerSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession3 ?? 0,
            'thuBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession1 ?? 0,
            'thuBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession2 ?? 0,
            'thuBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession3 ?? 0,
            'thuLunchSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession1 ?? 0,
            'thuLunchSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession2 ?? 0,
            'thuLunchSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession3 ?? 0,
            'thuDinnerSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession1 ?? 0,
            'thuDinnerSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession2 ?? 0,
            'thuDinnerSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession3 ?? 0,
            'friBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession1 ?? 0,
            'friBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession2 ?? 0,
            'friBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession3 ?? 0,
            'friLunchSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession1 ?? 0,
            'friLunchSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession2 ?? 0,
            'friLunchSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession3 ?? 0,
            'friDinnerSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession1 ?? 0,
            'friDinnerSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession2 ?? 0,
            'friDinnerSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession3 ?? 0,
            'satBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession1 ?? 0,
            'satBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession2 ?? 0,
            'satBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession3 ?? 0,
            'satLunchSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession1 ?? 0,
            'satLunchSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession2 ?? 0,
            'satLunchSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession3 ?? 0,
            'satDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession1 ?? 0,
            'satDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession2 ?? 0,
            'satDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession3 ?? 0,


            // 'breakfastSession1Count' : item.fpUnitSessions.breakfast.session1.availableCount,
            // 'breakfastSession2Count' : item.fpUnitSessions.breakfast.session2.availableCount,
            // 'breakfastSession3Count' : item.fpUnitSessions.breakfast.session3.availableCount,
            //
            // 'lunchSession1Count' : item.fpUnitSessions.lunch.session1.availableCount,
            // 'lunchSession2Count' : item.fpUnitSessions.lunch.session2.availableCount,
            // 'lunchSession3Count' : item.fpUnitSessions.lunch.session3.availableCount,
            //
            // 'dinnerSession1Count' : item.fpUnitSessions.dinner.session1.availableCount,
            // 'dinnerSession2Count' : item.fpUnitSessions.dinner.session2.availableCount,
            // 'dinnerSession3Count' : item.fpUnitSessions.dinner.session3.availableCount,

          };

          // if (LiveMenuVariables.foodCategories[item.subTag] == null) {
          //   LiveMenuVariables.foodCategories[item.subTag] = [];
          //   MenuEditorVariables.menuFoodCategories[item.subTag] = [];
          // }
          //
          // LiveMenuVariables.foodCategories[item.subTag]!.add(oneItem);


          // if(item.fpUnitAvailDaysAndMeals[event.date.substring(0,3)]!.breakfastSession1) {
          //   MenuEditorVariables.menuFoodCategories[item.subTag]!.add(oneItem);
          //   liveMenu.add(item);
          // }
        }
        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories,MenuEditorVariables.selectItem));
      } catch (e) {
        print("Date menu error ${e.toString()}");
        emit(ErrorState(e.toString()));
      }
    });

    on<AddSectionEvent>((event, emit) async {
      emit(MenuLoadingState());
      try {

        MenuEditorVariables.selectedCategories = Set<String>();

        Map<String, dynamic> req = {
          "ritem_name": "",
          "ritem_dispname": "SAMPLE",
          "ritem_priceRange": null,
          "ritem_itemType": null,
          "ritem_itemSubType": null,
          "ritem_comboType": null,
          "ritem_rawSource": "NON ORGANIC",
          "ritem_category": null,
          "ritem_cuisine": "DEFAULT",
          "ritem_regional": "DEFAULT",
          "ritem_subCategory": "DEFAULT",
          "ritem_normalPrice": 0.0,
          "ritem_packagePrice": 0.0,
          "ritem_preorderPrice": 0.0,
          "ritem_normalFinalPrice" : 0.0,
          "ritem_preorderFinalPrice" : 0.0,
          "ritem_half_preorderPrice" : 0.0,
          "ritem_half_normalFinalPrice" : 0.0,
          "ritem_half_preorderFinalPrice" : 0.0,
          "ritem_half_normalPrice" : 0.0,
          "ritem_half_price" : false,
          "ritem_description" : "Enter your prefered description for Item",
          "ritem_cuisine_description":"Enter your prefered description for Cuisine",
          "ritem_tag": event.tag,
          'ritem_consumption_mode' : ManageSettingsVariables.consumptionMode,
          "ritem_available_type" : 0,
          "fp_unit_avail_days_and_meals": {
            "Sun": {
              "BreakfastSession1": 0,
              "BreakfastSession2": 0,
              "BreakfastSession3": 0,
              "LunchSession1": 0,
              "LunchSession2": 0,
              "LunchSession3": 0,
              "DinnerSession1": 0,
              "DinnerSession2": 0,
              "DinnerSession3": 0,
            },
            "Mon": {
              "BreakfastSession1": 0,
              "BreakfastSession2": 0,
              "BreakfastSession3": 0,
              "LunchSession1": 0,
              "LunchSession2": 0,
              "LunchSession3": 0,
              "DinnerSession1": 0,
              "DinnerSession2": 0,
              "DinnerSession3": 0,
            },
            "Tue": {
              "BreakfastSession1": 0,
              "BreakfastSession2": 0,
              "BreakfastSession3": 0,
              "LunchSession1": 0,
              "LunchSession2": 0,
              "LunchSession3": 0,
              "DinnerSession1": 0,
              "DinnerSession2": 0,
              "DinnerSession3": 0,
            },
            "Wed": {
              "BreakfastSession1": 0,
              "BreakfastSession2": 0,
              "BreakfastSession3": 0,
              "LunchSession1": 0,
              "LunchSession2": 0,
              "LunchSession3": 0,
              "DinnerSession1": 0,
              "DinnerSession2": 0,
              "DinnerSession3": 0,
            },
            "Thu": {
              "BreakfastSession1": 0,
              "BreakfastSession2": 0,
              "BreakfastSession3": 0,
              "LunchSession1": 0,
              "LunchSession2": 0,
              "LunchSession3": 0,
              "DinnerSession1": 0,
              "DinnerSession2": 0,
              "DinnerSession3": 0,
            },
            "Fri": {
              "BreakfastSession1": 0,
              "BreakfastSession2": 0,
              "BreakfastSession3": 0,
              "LunchSession1": 0,
              "LunchSession2": 0,
              "LunchSession3": 0,
              "DinnerSession1": 0,
              "DinnerSession2": 0,
              "DinnerSession3": 0,
            },
            "Sat": {
              "BreakfastSession1": 0,
              "BreakfastSession2": 0,
              "BreakfastSession3": 0,
              "LunchSession1": 0,
              "LunchSession2": 0,
              "LunchSession3": 0,
              "DinnerSession1": 0,
              "DinnerSession2": 0,
              "DinnerSession3": 0,
            }
          },
          "fp_unit_sessions": {
            "Breakfast": {
              "Session1": {},
              "Session2": {},
              "Session3": {},
            },
            "Lunch": {
              "Session1": {},
              "Session2": {},
              "Session3": {},
            },
            "Dinner": {
              "Session1": {},
              "Session2": {},
              "Session3": {},
            }
          },
          "ritem_availability": false
        };

        List<Mymenu> newMenu = [];

        Mymenu item = await _menuRepository.addSection(req);

        Map<String, dynamic> oneItem = {
          '_id' : item.id,
          'name': item.name,
          'disName' : item.dname,
          'availability': item.availability,
          'category': item.category,
          'normalPrice' : item.normalPrice,
          'halfNormalPrice' : item.halfNormalPrice ?? 0.0,
          'packagePrice' : item.packagePrice,
          'preorderPrice' : item.preorderPrice,
          'normalFinalPrice' : item.normalFinalPrice,
          'preOrderFinalPrice'  : item.preorderFinalPrice ?? 0,
          'halfPreorderPrice' : item.halfPreorderPrice ?? 0.0,
          'halfNormalFinalPrice' : item.halfNormalFinalPrice ?? 0.0,
          'halfPreOrderFinalPrice'  : item.halfPreorderFinalPrice ?? 0.0,
          'halfPrice' : item.halfPrice ?? false,
          'available_type' : item?.availableType ?? 0,
          'tag' : item.itemTag,
          'regional' : item.regional,
          'cuisine':item.cuisine,
          'priceRange' : item.priceRange,
          'itemType' : item.itemType,
          'itemSubType' : item.itemSubType,
          'comboType' : item.comboType,
          'rawSource' : item.rawSource,
          'subCategory' : item.subCategory,
          'consumptionMode' : item.consumptionMode ?? [],
          'sunBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession1 ?? 0,
          'sunBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession2 ?? 0,
          'sunBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession3 ?? 0,
          'sunLunchSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession1 ?? 0,
          'sunLunchSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession2 ?? 0,
          'sunLunchSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession3 ?? 0,
          'sunDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession1 ?? 0,
          'sunDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession2 ?? 0,
          'sunDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession3 ?? 0,
          'monBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession1 ?? 0,
          'monBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession2 ?? 0,
          'monBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession3 ?? 0,
          'monLunchSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession1 ?? 0,
          'monLunchSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession2 ?? 0,
          'monLunchSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession3 ?? 0,
          'monDinnerSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession1 ?? 0,
          'monDinnerSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession2 ?? 0,
          'monDinnerSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession3 ?? 0,
          'tueBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession1 ?? 0,
          'tueBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession2 ?? 0,
          'tueBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession3 ?? 0,
          'tueLunchSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession1 ?? 0,
          'tueLunchSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession2 ?? 0,
          'tueLunchSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession3 ?? 0,
          'tueDinnerSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession1 ?? 0,
          'tueDinnerSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession2 ?? 0,
          'tueDinnerSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession3 ?? 0,
          'wedBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession1 ?? 0,
          'wedBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession2 ?? 0,
          'wedBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession3 ?? 0,
          'wedLunchSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession1 ?? 0,
          'wedLunchSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession2 ?? 0,
          'wedLunchSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession3 ?? 0,
          'wedDinnerSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession1 ?? 0,
          'wedDinnerSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession2 ?? 0,
          'wedDinnerSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession3 ?? 0,
          'thuBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession1 ?? 0,
          'thuBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession2 ?? 0,
          'thuBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession3 ?? 0,
          'thuLunchSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession1 ?? 0,
          'thuLunchSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession2 ?? 0,
          'thuLunchSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession3 ?? 0,
          'thuDinnerSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession1 ?? 0,
          'thuDinnerSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession2 ?? 0,
          'thuDinnerSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession3 ?? 0,
          'friBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession1 ?? 0,
          'friBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession2 ?? 0,
          'friBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession3 ?? 0,
          'friLunchSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession1 ?? 0,
          'friLunchSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession2 ?? 0,
          'friLunchSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession3 ?? 0,
          'friDinnerSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession1 ?? 0,
          'friDinnerSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession2 ?? 0,
          'friDinnerSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession3 ?? 0,
          'satBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession1 ?? 0,
          'satBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession2 ?? 0,
          'satBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession3 ?? 0,
          'satLunchSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession1 ?? 0,
          'satLunchSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession2 ?? 0,
          'satLunchSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession3 ?? 0,
          'satDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession1 ?? 0,
          'satDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession2 ?? 0,
          'satDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession3 ?? 0,
          // 'breakfastSession1Count': item.fpUnitSessions.breakfast.session1.availableCount,
          // 'breakfastSession2Count': item.fpUnitSessions.breakfast.session2.availableCount,
          // 'breakfastSession3Count': item.fpUnitSessions.breakfast.session3.availableCount,
          // 'lunchSession1Count': item.fpUnitSessions.lunch.session1.availableCount,
          // 'lunchSession2Count': item.fpUnitSessions.lunch.session2.availableCount,
          // 'lunchSession3Count': item.fpUnitSessions.lunch.session3.availableCount,
          // 'dinnerSession1Count': item.fpUnitSessions.dinner.session1.availableCount,
          // 'dinnerSession2Count': item.fpUnitSessions.dinner.session2.availableCount,
          // 'dinnerSession3Count': item.fpUnitSessions.dinner.session3.availableCount,

        };

        if (event.tag == item.itemTag) {
          MenuEditorVariables.tagController.text = oneItem['tag'];
          MenuEditorVariables.selectedCategories.add(item.itemTag);
        }

        if (LiveMenuVariables.foodCategories[item.itemTag] == null) {
          LiveMenuVariables.foodCategories[item.itemTag] = [];
        }

        LiveMenuVariables.foodCategories[item.itemTag]!.add(oneItem);

        MenuEditorVariables.tagAddType = "imported";

        emit(MenuLoadedState(newMenu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      } catch (e) {
        print(e.toString());
        emit(ErrorState(e.toString()));
      }
    });

    on<SearchItemsEvent>((event, emit) async {

      Set<String> items = {};

      MenuEditorVariables.items = [];

      // LiveMenuVariables.foodCategories.forEach((key, value) {
      //   if(key == event.tagName)
      //     {
      //       value.forEach((element) {
      //         items.add(element['name']);
      //       });
      //     }
      // });

      print("Coming");

      List<String> itemsList = await _menuRepository.fetchDisplayNamesByTagSearch(event.tagName,event.query);


      itemsList.forEach((element) {
        items.add(element.toUpperCase());
      });


      MenuEditorVariables.items = items?.toList() ?? [""];

      List<Mymenu> newMenu = [];


      emit(MenuLoadedState(newMenu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));

    });

    on<AddItemsEvent>((event, emit) async {

      Set<String> items = {};

      MenuEditorVariables.items = [];


      // List<String> itemsList = await _menuRepository.fetchDisplayNamesByTag(event.context,event.tagName);

      List<String> itemsList = await _menuRepository.fetchDisplayNames();


      itemsList.forEach((element) {
        items.add(element.toUpperCase());
      });


      MenuEditorVariables.items = items?.toList() ?? [""];

      List<Mymenu> newMenu = [];


      emit(MenuLoadedState(newMenu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));

    });

    on<AddCuisineEvent>((event, emit) async {

      MenuEditorVariables.cuisine = [];

      MenuEditorVariables.cuisine = await _menuRepository.fetchCuisine();

      List<Mymenu> newMenu = [];

      // MenuEditorFunction.showCuisineDialog(event.context, event.menuContext,event.id,event.displayName);

      emit(MenuLoadedState(newMenu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));

    });

    on<AddRegionalEvent>((event, emit) async {

      MenuEditorVariables.regional = [];

      MenuEditorVariables.regional = await _menuRepository.fetchRegional();

      List<Mymenu> newMenu = [];

      // MenuEditorFunction.showRegionalDialog(event.context, event.menuContext,event.id,event.displayName);

      emit(MenuLoadedState(newMenu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));

    });

    on<AddSubcategoryEvent>((event, emit) async {

      MenuEditorVariables.subCategory = [];

      MenuEditorVariables.subCategory = await _menuRepository.fetchSubCategory(event.category);

      List<Mymenu> newMenu = [];

      // MenuEditorFunction.showSubcategoryDialog(event.context, event.menuContext,event.id,event.category);


      emit(MenuLoadedState(newMenu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));

    });

    on<AddMenuItemEvent>((event, emit) async {

      emit(MenuLoadingState());
      try {

        MenuEditorVariables.selectedCategories = Set<String>();

        print(event.displayName);

        StandardItem? stdItem = await _menuRepository.fetchItemByDisplayName(event.displayName);

        print("Standerd menu item details is ${stdItem}");

        List<Mymenu> newMenu = [];

        Map<String, dynamic> req = {};

        if(stdItem != null) {
          req = {
            "ritem_name": "",
            "ritem_dispname": event.displayName,
            "ritem_priceRange": null,
            "ritem_itemType": stdItem.stdItemType,
            "ritem_itemSubType": stdItem.stdItemSubType,
            "ritem_comboType": stdItem.stdItemComboType,
            "ritem_rawSource": stdItem.stdItemRawSource,
            "ritem_category": stdItem.stdItemCategory,
            "ritem_cuisine": stdItem.stdItemCuisine,
            "ritem_regional": stdItem.stdItemRegional,
            "ritem_subCategory": stdItem.stdItemSubcategory,
            "ritem_normalPrice": 0.0,
            "ritem_packagePrice": 0.0,
            "ritem_preorderPrice": 0.0,
            "ritem_normalFinalPrice" : 0.0,
            "ritem_preorderFinalPrice" : 0.0,
            "ritem_half_preorderPrice" : 0.0,
            "ritem_half_normalFinalPrice" : 0.0,
            "ritem_half_preorderFinalPrice" : 0.0,
            "ritem_half_normalPrice" : 0.0,
            "ritem_half_price" : false,
            "ritem_description" : "Enter your prefered description for Item",
            "ritem_cuisine_description":"Enter your prefered description for Cuisine",
            "ritem_tag": event.tagName,
            'ritem_consumption_mode' : ManageSettingsVariables.consumptionMode,
            "ritem_available_type" : 0,
            "fp_unit_avail_days_and_meals": {
              "Sun": {
                "BreakfastSession1": 0,
                "BreakfastSession2": 0,
                "BreakfastSession3": 0,
                "LunchSession1": 0,
                "LunchSession2": 0,
                "LunchSession3": 0,
                "DinnerSession1": 0,
                "DinnerSession2": 0,
                "DinnerSession3": 0,
              },
              "Mon": {
                "BreakfastSession1": 0,
                "BreakfastSession2": 0,
                "BreakfastSession3": 0,
                "LunchSession1": 0,
                "LunchSession2": 0,
                "LunchSession3": 0,
                "DinnerSession1": 0,
                "DinnerSession2": 0,
                "DinnerSession3": 0,
              },
              "Tue": {
                "BreakfastSession1": 0,
                "BreakfastSession2": 0,
                "BreakfastSession3": 0,
                "LunchSession1": 0,
                "LunchSession2": 0,
                "LunchSession3": 0,
                "DinnerSession1": 0,
                "DinnerSession2": 0,
                "DinnerSession3": 0,
              },
              "Wed": {
                "BreakfastSession1": 0,
                "BreakfastSession2": 0,
                "BreakfastSession3": 0,
                "LunchSession1": 0,
                "LunchSession2": 0,
                "LunchSession3": 0,
                "DinnerSession1": 0,
                "DinnerSession2": 0,
                "DinnerSession3": 0,
              },
              "Thu": {
                "BreakfastSession1": 0,
                "BreakfastSession2": 0,
                "BreakfastSession3": 0,
                "LunchSession1": 0,
                "LunchSession2": 0,
                "LunchSession3": 0,
                "DinnerSession1": 0,
                "DinnerSession2": 0,
                "DinnerSession3": 0,
              },
              "Fri": {
                "BreakfastSession1": 0,
                "BreakfastSession2": 0,
                "BreakfastSession3": 0,
                "LunchSession1": 0,
                "LunchSession2": 0,
                "LunchSession3": 0,
                "DinnerSession1": 0,
                "DinnerSession2": 0,
                "DinnerSession3": 0,
              },
              "Sat": {
                "BreakfastSession1": 0,
                "BreakfastSession2": 0,
                "BreakfastSession3": 0,
                "LunchSession1": 0,
                "LunchSession2": 0,
                "LunchSession3": 0,
                "DinnerSession1": 0,
                "DinnerSession2": 0,
                "DinnerSession3": 0,
              }
            },
            "fp_unit_sessions": {
              "Breakfast": {
                "Session1": {},
                "Session2": {},
                "Session3": {},
              },
              "Lunch": {
                "Session1": {},
                "Session2": {},
                "Session3": {},
              },
              "Dinner": {
                "Session1": {},
                "Session2": {},
                "Session3": {},
              }
            },
            "ritem_availability": false
          };
        } else {
          req = {
            "ritem_name": "",
            "ritem_dispname": event.displayName,
            "ritem_priceRange": null,
            "ritem_itemType": null,
            "ritem_itemSubType": null,
            "ritem_comboType": null,
            "ritem_rawSource": "NON ORGANIC",
            "ritem_category": null,
            "ritem_cuisine": "DEFAULT",
            "ritem_regional": "DEFAULT",
            "ritem_subCategory": "DEFAULT",
            "ritem_normalPrice": 0.0,
            "ritem_packagePrice": 0.0,
            "ritem_preorderPrice": 0.0,
            "ritem_normalFinalPrice" : 0.0,
            "ritem_preorderFinalPrice" : 0.0,
            "ritem_half_preorderPrice" : 0.0,
            "ritem_half_normalFinalPrice" : 0.0,
            "ritem_half_preorderFinalPrice" : 0.0,
            "ritem_half_normalPrice" : 0.0,
            "ritem_half_price" : false,
            "ritem_description" : "Enter your prefered description for Item",
            "ritem_cuisine_description":"Enter your prefered description for Cuisine",
            "ritem_tag": event.tagName,
            'ritem_consumption_mode' : ManageSettingsVariables.consumptionMode,
            "ritem_available_type" : 0,
            "fp_unit_avail_days_and_meals": {
              "Sun": {
                "BreakfastSession1": 0,
                "BreakfastSession2": 0,
                "BreakfastSession3": 0,
                "LunchSession1": 0,
                "LunchSession2": 0,
                "LunchSession3": 0,
                "DinnerSession1": 0,
                "DinnerSession2": 0,
                "DinnerSession3": 0,
              },
              "Mon": {
                "BreakfastSession1": 0,
                "BreakfastSession2": 0,
                "BreakfastSession3": 0,
                "LunchSession1": 0,
                "LunchSession2": 0,
                "LunchSession3": 0,
                "DinnerSession1": 0,
                "DinnerSession2": 0,
                "DinnerSession3": 0,
              },
              "Tue": {
                "BreakfastSession1": 0,
                "BreakfastSession2": 0,
                "BreakfastSession3": 0,
                "LunchSession1": 0,
                "LunchSession2": 0,
                "LunchSession3": 0,
                "DinnerSession1": 0,
                "DinnerSession2": 0,
                "DinnerSession3": 0,
              },
              "Wed": {
                "BreakfastSession1": 0,
                "BreakfastSession2": 0,
                "BreakfastSession3": 0,
                "LunchSession1": 0,
                "LunchSession2": 0,
                "LunchSession3": 0,
                "DinnerSession1": 0,
                "DinnerSession2": 0,
                "DinnerSession3": 0,
              },
              "Thu": {
                "BreakfastSession1": 0,
                "BreakfastSession2": 0,
                "BreakfastSession3": 0,
                "LunchSession1": 0,
                "LunchSession2": 0,
                "LunchSession3": 0,
                "DinnerSession1": 0,
                "DinnerSession2": 0,
                "DinnerSession3": 0,
              },
              "Fri": {
                "BreakfastSession1": 0,
                "BreakfastSession2": 0,
                "BreakfastSession3": 0,
                "LunchSession1": 0,
                "LunchSession2": 0,
                "LunchSession3": 0,
                "DinnerSession1": 0,
                "DinnerSession2": 0,
                "DinnerSession3": 0,
              },
              "Sat": {
                "BreakfastSession1": 0,
                "BreakfastSession2": 0,
                "BreakfastSession3": 0,
                "LunchSession1": 0,
                "LunchSession2": 0,
                "LunchSession3": 0,
                "DinnerSession1": 0,
                "DinnerSession2": 0,
                "DinnerSession3": 0,
              }
            },
            "fp_unit_sessions": {
              "Breakfast": {
                "Session1": {},
                "Session2": {},
                "Session3": {},
              },
              "Lunch": {
                "Session1": {},
                "Session2": {},
                "Session3": {},
              },
              "Dinner": {
                "Session1": {},
                "Session2": {},
                "Session3": {},
              }
            },
            "ritem_availability": false
          };
        }



        Mymenu item = await _menuRepository.addSection(req);

        Map<String, dynamic> oneItem = {
          '_id' : item.id,
          'name': item.name,
          'uId' : item.uId,
          'disName' : item.dname,
          'availability': item.availability,
          'category': item.category,
          'normalPrice' : item.normalPrice,
          'halfNormalPrice' : item.halfNormalPrice ?? 0.0,
          'packagePrice' : item.packagePrice,
          'preorderPrice' : item.preorderPrice,
          'normalFinalPrice' : item.normalFinalPrice,
          'preOrderFinalPrice'  : item.preorderFinalPrice ?? 0,
          'halfPreorderPrice' : item.halfPreorderPrice ?? 0.0,
          'halfNormalFinalPrice' : item.halfNormalFinalPrice ?? 0.0,
          'halfPreOrderFinalPrice'  : item.halfPreorderFinalPrice ?? 0.0,
          'halfPrice' : item.halfPrice ?? false,
          'available_type' : item?.availableType ?? 0,
          'tag' : item.itemTag,
          'regional' : item.regional,
          'cuisine':item.cuisine,
          'priceRange' : item.priceRange,
          'itemType' : item.itemType,
          'itemSubType' : item.itemSubType,
          'comboType' : item.comboType,
          'rawSource' : item.rawSource,
          'subCategory' : item.subCategory,
          'consumptionMode' : item.consumptionMode ?? [],
          'sunBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession1 ?? 0,
          'sunBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession2 ?? 0,
          'sunBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession3 ?? 0,
          'sunLunchSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession1 ?? 0,
          'sunLunchSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession2 ?? 0,
          'sunLunchSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession3 ?? 0,
          'sunDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession1 ?? 0,
          'sunDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession2 ?? 0,
          'sunDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession3 ?? 0,
          'monBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession1 ?? 0,
          'monBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession2 ?? 0,
          'monBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession3 ?? 0,
          'monLunchSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession1 ?? 0,
          'monLunchSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession2 ?? 0,
          'monLunchSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession3 ?? 0,
          'monDinnerSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession1 ?? 0,
          'monDinnerSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession2 ?? 0,
          'monDinnerSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession3 ?? 0,
          'tueBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession1 ?? 0,
          'tueBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession2 ?? 0,
          'tueBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession3 ?? 0,
          'tueLunchSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession1 ?? 0,
          'tueLunchSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession2 ?? 0,
          'tueLunchSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession3 ?? 0,
          'tueDinnerSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession1 ?? 0,
          'tueDinnerSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession2 ?? 0,
          'tueDinnerSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession3 ?? 0,
          'wedBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession1 ?? 0,
          'wedBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession2 ?? 0,
          'wedBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession3 ?? 0,
          'wedLunchSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession1 ?? 0,
          'wedLunchSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession2 ?? 0,
          'wedLunchSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession3 ?? 0,
          'wedDinnerSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession1 ?? 0,
          'wedDinnerSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession2 ?? 0,
          'wedDinnerSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession3 ?? 0,
          'thuBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession1 ?? 0,
          'thuBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession2 ?? 0,
          'thuBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession3 ?? 0,
          'thuLunchSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession1 ?? 0,
          'thuLunchSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession2 ?? 0,
          'thuLunchSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession3 ?? 0,
          'thuDinnerSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession1 ?? 0,
          'thuDinnerSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession2 ?? 0,
          'thuDinnerSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession3 ?? 0,
          'friBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession1 ?? 0,
          'friBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession2 ?? 0,
          'friBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession3 ?? 0,
          'friLunchSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession1 ?? 0,
          'friLunchSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession2 ?? 0,
          'friLunchSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession3 ?? 0,
          'friDinnerSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession1 ?? 0,
          'friDinnerSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession2 ?? 0,
          'friDinnerSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession3 ?? 0,
          'satBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession1 ?? 0,
          'satBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession2 ?? 0,
          'satBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession3 ?? 0,
          'satLunchSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession1 ?? 0,
          'satLunchSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession2 ?? 0,
          'satLunchSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession3 ?? 0,
          'satDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession1 ?? 0,
          'satDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession2 ?? 0,
          'satDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession3 ?? 0,
        };

        if(event.tagName == item.itemTag) {
          MenuEditorVariables.selectedCategories.add(event.tagName);
        }
        LiveMenuVariables.foodCategories[item.itemTag]!.add(oneItem);



        if(event.displayName == oneItem['disName']) {
          LiveMenuVariables.selectedItem = oneItem['disName'];
          LiveMenuVariables.selectItem = oneItem;
          MenuEditorVariables.selectItem = oneItem;
          MenuEditorVariables.selectedItem = oneItem['disName'];
        }

        print("Live menu selecteItem ${LiveMenuVariables.selectItem}");




        emit(MenuLoadedState(newMenu, liveMenu, LiveMenuVariables.foodCategories,
            LiveMenuVariables.selectItem,
            MenuEditorVariables.menuFoodCategories,
            MenuEditorVariables.selectItem));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }

    });

    on<UpdateItemSection>((event, emit) async {
      emit(MenuLoadingState());
      try {

        // event.requestBody["ritem_tag"] = event.tagName;

        Map<String, dynamic> sectionData = {"ritem_tag" : event.tagName};

        await _menuRepository.updateSection(sectionData, event.id);

        event.oneItem['tag'] = event.tagName;

        List<Mymenu> newMenu = [];
        LiveMenuVariables.foodCategories[event.oldTag]!.removeWhere((item) => item['_id'] == event.id);


        LiveMenuVariables.foodCategories[event.tagName]!.add(event.oneItem);

        emit(MenuLoadedState(newMenu, liveMenu, LiveMenuVariables.foodCategories,
            LiveMenuVariables.selectItem,
            MenuEditorVariables.menuFoodCategories,
            MenuEditorVariables.selectItem));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<ReplaceItemSection>((event, emit) async {
      emit(MenuLoadingState());
      try {


        await _menuRepository.deleteMenuItem(event.currentId);

        LiveMenuVariables.foodCategories[event.tagName]!.removeWhere((item) => item['_id'] == event.currentId);

        Map<String, dynamic> sectionData = {"ritem_tag" : event.tagName};

        await _menuRepository.updateSection(sectionData, event.id);

        List<Mymenu> newMenu = [];

        print("Old tad ${event.oldTag}");

        print("New tag ${event.tagName}");

        print("Livemneu variables ${LiveMenuVariables.foodCategories[event.oldTag]}");

        print("Id for old tag is ${event.id}");

        event.oneItem['tag'] = event.tagName;

        LiveMenuVariables.foodCategories[event.oldTag]!.removeWhere((item) => item['_id'] == event.id);

        LiveMenuVariables.foodCategories[event.tagName]!.add(event.oneItem);

        LiveMenuVariables.selectItem = event.oneItem;

        MenuEditorVariables.selectItem = event.oneItem;
        MenuEditorVariables.selectedItem = event.itemName;

        LiveMenuVariables.selectedItem = event.itemName;



        emit(MenuLoadedState(newMenu, liveMenu, LiveMenuVariables.foodCategories,
            LiveMenuVariables.selectItem,
            MenuEditorVariables.menuFoodCategories,
            MenuEditorVariables.selectItem));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<UpdateItemAvailability>((event, emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];

        LiveMenuNewService liveMenuService = LiveMenuNewService();

        MenuEditorVariables.selectItem = event.item;
        Map<String, dynamic> req = {
          "ritem_availability": event.available
        };

        await _menuRepository.updateSection(req, event.id);

        List<Map<String, dynamic>> next5Days = MenuEditorFunction.getNext5Days();
        List<LiveMenuNew> liveMenuDataList = [];

        for (var dayInfo in next5Days) {
          liveMenuDataList.add(
            LiveMenuNew(
              ritemUId:  event.item['uId'],
              ritemDispname: event.item['disName'],
              ritemAvailability: event.available,
              ritemCategory: event.item['category'],
              ritemTag: event.tagName,
              ritemAvailableType: event.item['available_type'],
              day: dayInfo['day'],
              date: dayInfo['dateString'],
              mealsSessionCount: MealSessionCount(
                breakfast: Meal(
                  enabled: true,
                  session1: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount('Breakfast', dayInfo['day'], 1,event.item)),
                  session2: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount('Breakfast', dayInfo['day'], 2,event.item)),
                  session3: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount('Breakfast', dayInfo['day'], 3,event.item)),
                ),
                lunch: Meal(
                  enabled: true,
                  session1: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount('Lunch', dayInfo['day'], 1,event.item)),
                  session2: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount('Lunch', dayInfo['day'], 2,event.item)),
                  session3: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount('Lunch', dayInfo['day'], 3,event.item)),
                ),
                dinner: Meal(
                  enabled: true,
                  session1: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount('Dinner', dayInfo['day'], 1,event.item)),
                  session2: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount('Dinner', dayInfo['day'], 2,event.item)),
                  session3: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount('Dinner', dayInfo['day'], 3,event.item)),
                ),
              ),
            ),
          );
        }


        if(event.available && MenuEditorVariables.selectItem['available_type'] == 1) {
          await liveMenuService.postLiveMenuData(liveMenuDataList);
          MenuEditorFunction.showFlushBarAvailabilitySync(event.context);
        } else if(!event.available && MenuEditorVariables.selectItem['available_type'] == 1){
          await liveMenuService.deleteItems({"ritem_UId" : event.item['uId'],});
          MenuEditorFunction.showFlushBarAvailabilityDisableSync(event.context);
        }



        emit(MenuLoadedState(menu, liveMenu, LiveMenuVariables.foodCategories,
            LiveMenuVariables.selectItem,
            event.menuFoodCategory,
            MenuEditorVariables.selectItem));
      } catch (e) {
        emit(ErrorState(e.toString()));
        print(e.toString());
      }
    });

    on<DeleteItemEvent>((event, emit) async {
      emit(MenuLoadingState());
      try {

       await _menuRepository.deleteMenuItem(event.id);

        List<Mymenu> newMenu = [];

        print(event.tagName);

       print(event.item);

       LiveMenuVariables.foodCategories[event.tagName]!.removeWhere((item) => item['_id'] == event.id);


       if(LiveMenuVariables.foodCategories[event.tagName]!.length == 0) {
         LiveMenuVariables.foodCategories.remove(event.tagName);
         MenuEditorVariables.selectedCategories.add(LiveMenuVariables.foodCategories.keys.first);

         MenuEditorVariables.tagController.text = LiveMenuVariables.foodCategories.keys.first;

         MenuEditorVariables.selectedItem = "";
       } else {
         LiveMenuVariables.selectItem = LiveMenuVariables.foodCategories[event.tagName]!.last;
         MenuEditorVariables.selectItem = LiveMenuVariables.foodCategories[event.tagName]!.last;
         MenuEditorVariables.selectedItem = MenuEditorVariables.selectItem['disName'];
       }


        emit(MenuLoadedState(newMenu, liveMenu, LiveMenuVariables.foodCategories,
            LiveMenuVariables.selectItem,
            MenuEditorVariables.menuFoodCategories,
            MenuEditorVariables.selectItem));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<DeleteSectionEvent>((event, emit) async {
      emit(MenuLoadingState());
      try {

        await _menuRepository.deleteMenuItemsByTag(event.tag);
        List<Mymenu> newMenu = [];

        MenuEditorVariables.selectedCategories.add(LiveMenuVariables.foodCategories.keys.first);

        MenuEditorVariables.tagController.text = LiveMenuVariables.foodCategories.keys.first;

        MenuEditorVariables.selectedItem = "";

        LiveMenuVariables.foodCategories.remove(event.tag);

        emit(MenuLoadedState(newMenu, liveMenu, LiveMenuVariables.foodCategories,
            LiveMenuVariables.selectItem,
            MenuEditorVariables.menuFoodCategories,
            MenuEditorVariables.selectItem));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<ReplaceSectionEvent>((event, emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];
        await _menuRepository.deleteMenuItemsByTag(event.tagName);

        event.requestBody['ritem_tag'] = event.tagName;

        print("REquest body ${event.requestBody}");
        await _menuRepository.addSection(event.requestBody);

        emit(MenuLoadedState(menu, liveMenu, LiveMenuVariables.foodCategories,
            LiveMenuVariables.selectItem,
            MenuEditorVariables.menuFoodCategories,
            MenuEditorVariables.selectItem));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<UpdateTagNameEvent>((event, emit) async {
      emit(MenuLoadingState());
      try {

        List<Mymenu> newMenu = [];
        LiveMenuVariables.foodCategories = {};
        MenuEditorVariables.menuFoodCategories = {};
        await _menuRepository.updateItemsByTag(event.oldTag, event.newTAg);
        MenuEditorVariables.selectedCategories = Set<String>();
        newMenu = await _menuRepository.fetchData();

        for (var item in newMenu) {
          Map<String, dynamic> oneItem = {
            '_id' : item.id,
            'name': item.name,
            'uId' : item.uId,
            'disName' : item.dname,
            'availability': item.availability,
            'category': item.category,
            'normalPrice' : item.normalPrice,
            'halfNormalPrice' : item.halfNormalPrice ?? 0.0,
            'packagePrice' : item.packagePrice,
            'preorderPrice' : item.preorderPrice,
            'normalFinalPrice' : item.normalFinalPrice,
            'preOrderFinalPrice'  : item.preorderFinalPrice ?? 0,
            'halfPreorderPrice' : item.halfPreorderPrice ?? 0.0,
            'halfNormalFinalPrice' : item.halfNormalFinalPrice ?? 0.0,
            'halfPreOrderFinalPrice'  : item.halfPreorderFinalPrice ?? 0.0,
            'halfPrice' : item.halfPrice ?? false,
            'available_type' : item?.availableType ?? 0,
            'tag' : item.itemTag,
            'regional' : item.regional,
            'cuisine':item.cuisine,
            'priceRange' : item.priceRange,
            'itemType' : item.itemType,
            'itemSubType' : item.itemSubType,
            'comboType' : item.comboType,
            'rawSource' : item.rawSource,
            'subCategory' : item.subCategory,
            'consumptionMode' : item.consumptionMode ?? [],
            'sunBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession1 ?? 0,
            'sunBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession2 ?? 0,
            'sunBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession3 ?? 0,
            'sunLunchSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession1 ?? 0,
            'sunLunchSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession2 ?? 0,
            'sunLunchSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession3 ?? 0,
            'sunDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession1 ?? 0,
            'sunDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession2 ?? 0,
            'sunDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession3 ?? 0,
            'monBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession1 ?? 0,
            'monBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession2 ?? 0,
            'monBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession3 ?? 0,
            'monLunchSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession1 ?? 0,
            'monLunchSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession2 ?? 0,
            'monLunchSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession3 ?? 0,
            'monDinnerSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession1 ?? 0,
            'monDinnerSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession2 ?? 0,
            'monDinnerSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession3 ?? 0,
            'tueBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession1 ?? 0,
            'tueBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession2 ?? 0,
            'tueBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession3 ?? 0,
            'tueLunchSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession1 ?? 0,
            'tueLunchSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession2 ?? 0,
            'tueLunchSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession3 ?? 0,
            'tueDinnerSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession1 ?? 0,
            'tueDinnerSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession2 ?? 0,
            'tueDinnerSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession3 ?? 0,
            'wedBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession1 ?? 0,
            'wedBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession2 ?? 0,
            'wedBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession3 ?? 0,
            'wedLunchSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession1 ?? 0,
            'wedLunchSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession2 ?? 0,
            'wedLunchSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession3 ?? 0,
            'wedDinnerSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession1 ?? 0,
            'wedDinnerSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession2 ?? 0,
            'wedDinnerSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession3 ?? 0,
            'thuBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession1 ?? 0,
            'thuBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession2 ?? 0,
            'thuBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession3 ?? 0,
            'thuLunchSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession1 ?? 0,
            'thuLunchSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession2 ?? 0,
            'thuLunchSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession3 ?? 0,
            'thuDinnerSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession1 ?? 0,
            'thuDinnerSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession2 ?? 0,
            'thuDinnerSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession3 ?? 0,
            'friBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession1 ?? 0,
            'friBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession2 ?? 0,
            'friBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession3 ?? 0,
            'friLunchSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession1 ?? 0,
            'friLunchSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession2 ?? 0,
            'friLunchSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession3 ?? 0,
            'friDinnerSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession1 ?? 0,
            'friDinnerSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession2 ?? 0,
            'friDinnerSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession3 ?? 0,
            'satBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession1 ?? 0,
            'satBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession2 ?? 0,
            'satBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession3 ?? 0,
            'satLunchSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession1 ?? 0,
            'satLunchSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession2 ?? 0,
            'satLunchSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession3 ?? 0,
            'satDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession1 ?? 0,
            'satDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession2 ?? 0,
            'satDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession3 ?? 0,
          };


          if (LiveMenuVariables.foodCategories[item.itemTag] == null) {
            LiveMenuVariables.foodCategories[item.itemTag] = [];
            MenuEditorVariables.menuFoodCategories[item.itemTag] = [];
          }

          LiveMenuVariables.foodCategories[item.itemTag]!.add(oneItem);

          if(event.newTAg ==item.itemTag )
            {
              MenuEditorVariables.selectedCategories.add(item.itemTag);
              print(item.itemTag);
              MenuEditorVariables.oldestTagName = event.newTAg;
              MenuEditorVariables.tagController.text = event.newTAg;
            }

        }
        MenuEditorVariables.tagController.text = event.newTAg;

        emit(MenuLoadedState(newMenu, liveMenu, LiveMenuVariables.foodCategories,
            LiveMenuVariables.selectItem,
            MenuEditorVariables.menuFoodCategories,
            MenuEditorVariables.selectItem));
      } catch (e) {
        print("Menu Error ${e.toString()}");
        emit(ErrorState(e.toString()));
      }
    });

    on<UpdateSectionAvailability>((event, emit) async {
      emit(MenuLoadingState());
      try {

        print(event.availability);
        List<Mymenu> newMenu = [];
        LiveMenuVariables.foodCategories = {};
        MenuEditorVariables.selectedCategories = Set<String>();
        MenuEditorVariables.menuFoodCategories = {};
        await _menuRepository.updateByTag(event.tagName, event.availability);

        newMenu = await _menuRepository.fetchData();

        for (var item in newMenu) {
          Map<String, dynamic> oneItem = {
            '_id' : item.id,
            'uId' : item.uId,
            'name': item.name,
            'disName' : item.dname,
            'availability': item.availability,
            'category': item.category,
            'normalPrice' : item.normalPrice,
            'halfNormalPrice' : item.halfNormalPrice ?? 0.0,
            'packagePrice' : item.packagePrice,
            'preorderPrice' : item.preorderPrice,
            'normalFinalPrice' : item.normalFinalPrice,
            'preOrderFinalPrice'  : item.preorderFinalPrice ?? 0,
            'halfPreorderPrice' : item.halfPreorderPrice ?? 0.0,
            'halfNormalFinalPrice' : item.halfNormalFinalPrice ?? 0.0,
            'halfPreOrderFinalPrice'  : item.halfPreorderFinalPrice ?? 0.0,
            'halfPrice' : item.halfPrice ?? false,
            'available_type' : item?.availableType ?? 0,
            'tag' : item.itemTag,
            'regional' : item.regional,
            'cuisine':item.cuisine,
            'priceRange' : item.priceRange,
            'itemType' : item.itemType,
            'itemSubType' : item.itemSubType,
            'comboType' : item.comboType,
            'rawSource' : item.rawSource,
            'subCategory' : item.subCategory,
            'consumptionMode' : item.consumptionMode ?? [],
            'sunBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession1 ?? 0,
            'sunBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession2 ?? 0,
            'sunBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession3 ?? 0,
            'sunLunchSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession1 ?? 0,
            'sunLunchSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession2 ?? 0,
            'sunLunchSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession3 ?? 0,
            'sunDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession1 ?? 0,
            'sunDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession2 ?? 0,
            'sunDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession3 ?? 0,
            'monBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession1 ?? 0,
            'monBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession2 ?? 0,
            'monBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession3 ?? 0,
            'monLunchSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession1 ?? 0,
            'monLunchSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession2 ?? 0,
            'monLunchSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession3 ?? 0,
            'monDinnerSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession1 ?? 0,
            'monDinnerSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession2 ?? 0,
            'monDinnerSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession3 ?? 0,
            'tueBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession1 ?? 0,
            'tueBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession2 ?? 0,
            'tueBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession3 ?? 0,
            'tueLunchSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession1 ?? 0,
            'tueLunchSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession2 ?? 0,
            'tueLunchSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession3 ?? 0,
            'tueDinnerSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession1 ?? 0,
            'tueDinnerSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession2 ?? 0,
            'tueDinnerSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession3 ?? 0,
            'wedBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession1 ?? 0,
            'wedBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession2 ?? 0,
            'wedBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession3 ?? 0,
            'wedLunchSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession1 ?? 0,
            'wedLunchSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession2 ?? 0,
            'wedLunchSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession3 ?? 0,
            'wedDinnerSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession1 ?? 0,
            'wedDinnerSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession2 ?? 0,
            'wedDinnerSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession3 ?? 0,
            'thuBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession1 ?? 0,
            'thuBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession2 ?? 0,
            'thuBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession3 ?? 0,
            'thuLunchSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession1 ?? 0,
            'thuLunchSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession2 ?? 0,
            'thuLunchSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession3 ?? 0,
            'thuDinnerSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession1 ?? 0,
            'thuDinnerSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession2 ?? 0,
            'thuDinnerSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession3 ?? 0,
            'friBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession1 ?? 0,
            'friBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession2 ?? 0,
            'friBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession3 ?? 0,
            'friLunchSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession1 ?? 0,
            'friLunchSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession2 ?? 0,
            'friLunchSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession3 ?? 0,
            'friDinnerSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession1 ?? 0,
            'friDinnerSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession2 ?? 0,
            'friDinnerSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession3 ?? 0,
            'satBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession1 ?? 0,
            'satBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession2 ?? 0,
            'satBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession3 ?? 0,
            'satLunchSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession1 ?? 0,
            'satLunchSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession2 ?? 0,
            'satLunchSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession3 ?? 0,
            'satDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession1 ?? 0,
            'satDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession2 ?? 0,
            'satDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession3 ?? 0,

          };


          if (LiveMenuVariables.foodCategories[item.itemTag] == null) {
            LiveMenuVariables.foodCategories[item.itemTag] = [];
            MenuEditorVariables.menuFoodCategories[item.itemTag] = [];
          }



          if(event.tagName == item.itemTag)
            {
              MenuEditorVariables.selectedCategories.add(event.tagName);
            }

          LiveMenuVariables.foodCategories[item.itemTag]!.add(oneItem);


        }


        emit(MenuLoadedState(newMenu, liveMenu, LiveMenuVariables.foodCategories,
            LiveMenuVariables.selectItem,
            MenuEditorVariables.menuFoodCategories,
            MenuEditorVariables.selectItem));
      } catch (e) {
        print("Menu Error ${e.toString()}");
        emit(ErrorState(e.toString()));
      }
    });

    on<UpdateLiveMenuEvent>((event, emit) async   {
      emit(MenuLoadingState());
      try {

        List<Mymenu> newMenu = [];
        LiveMenuVariables.foodCategories = {};
        MenuEditorVariables.menuFoodCategories = {};
        MenuEditorVariables.selectedCategories = Set<String>();
        await _menuRepository.updateLiveMenu(event.id, event.requestBody);

        LiveMenuNewService liveMenuService = LiveMenuNewService();

        List<Map<String, dynamic>> next5Days = MenuEditorFunction.getNext5Days();
        List<LiveMenuNewSample> liveMenuDataList = [];

        for (var dayInfo in next5Days) {
          liveMenuDataList.add(
            LiveMenuNewSample(
              ritemUId: MenuEditorVariables.selectItem['uId'],
              date: dayInfo['dateString'],
              updateData: MealSessionCount(
                breakfast: Meal(
                  enabled: true,
                  session1: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount1('Breakfast', dayInfo['day'], 1, event.requestBody)),
                  session2: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount1('Breakfast', dayInfo['day'], 2, event.requestBody)),
                  session3: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount1('Breakfast', dayInfo['day'], 3, event.requestBody)),
                ),
                lunch: Meal(
                  enabled: true,
                  session1: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount1('Lunch', dayInfo['day'], 1, event.requestBody)),
                  session2: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount1('Lunch', dayInfo['day'], 2, event.requestBody)),
                  session3: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount1('Lunch', dayInfo['day'], 3, event.requestBody)),
                ),
                dinner: Meal(
                  enabled: true,
                  session1: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount1('Dinner', dayInfo['day'], 1, event.requestBody)),
                  session2: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount1('Dinner', dayInfo['day'], 2, event.requestBody)),
                  session3: Session(enabled: true, availableCount: MenuEditorVariables.getSessionCount1('Dinner', dayInfo['day'], 3, event.requestBody)),
                ),
              ),
            ),
          );

        }

        if(MenuEditorVariables.selectItem['availability'] && MenuEditorVariables.selectItem['available_type'] == 1)
          {
            await liveMenuService.updateItems(liveMenuDataList);
            MenuEditorFunction.showFlushBarAvailability(event.context);
          }

        newMenu = await _menuRepository.fetchData();

        Set<String> uniqueRegionalItems = {};

        Set<String> uniqueCusineItems = {};

        for (var item in newMenu) {
          Map<String, dynamic> oneItem = {
            '_id' : item.id,
            'uId' : item.uId,
            'name': item.name,
            'disName' : item.dname,
            'availability': item.availability,
            'category': item.category,
            'normalPrice' : item.normalPrice,
            'halfNormalPrice' : item.halfNormalPrice ?? 0.0,
            'packagePrice' : item.packagePrice,
            'preorderPrice' : item.preorderPrice,
            'normalFinalPrice' : item.normalFinalPrice,
            'preOrderFinalPrice'  : item.preorderFinalPrice ?? 0,
            'halfPreorderPrice' : item.halfPreorderPrice ?? 0.0,
            'halfNormalFinalPrice' : item.halfNormalFinalPrice ?? 0.0,
            'halfPreOrderFinalPrice'  : item.halfPreorderFinalPrice ?? 0.0,
            'halfPrice' : item.halfPrice ?? false,
            'available_type' : item?.availableType ?? 0,
            'tag' : item.itemTag,
            'regional' : item.regional,
            'cuisine':item.cuisine,
            'priceRange' : item.priceRange,
            'itemType' : item.itemType,
            'itemSubType' : item.itemSubType,
            'comboType' : item.comboType,
            'rawSource' : item.rawSource,
            'subCategory' : item.subCategory,
            'consumptionMode' : item.consumptionMode ?? [],
            'sunBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession1 ?? 0,
            'sunBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession2 ?? 0,
            'sunBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.breakfastSession3 ?? 0,
            'sunLunchSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession1 ?? 0,
            'sunLunchSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession2 ?? 0,
            'sunLunchSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.lunchSession3 ?? 0,
            'sunDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession1 ?? 0,
            'sunDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession2 ?? 0,
            'sunDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sun']?.dinnerSession3 ?? 0,
            'monBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession1 ?? 0,
            'monBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession2 ?? 0,
            'monBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.breakfastSession3 ?? 0,
            'monLunchSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession1 ?? 0,
            'monLunchSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession2 ?? 0,
            'monLunchSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.lunchSession3 ?? 0,
            'monDinnerSession1' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession1 ?? 0,
            'monDinnerSession2' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession2 ?? 0,
            'monDinnerSession3' : item.fpUnitAvailDaysAndMeals['Mon']?.dinnerSession3 ?? 0,
            'tueBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession1 ?? 0,
            'tueBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession2 ?? 0,
            'tueBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.breakfastSession3 ?? 0,
            'tueLunchSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession1 ?? 0,
            'tueLunchSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession2 ?? 0,
            'tueLunchSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.lunchSession3 ?? 0,
            'tueDinnerSession1' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession1 ?? 0,
            'tueDinnerSession2' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession2 ?? 0,
            'tueDinnerSession3' : item.fpUnitAvailDaysAndMeals['Tue']?.dinnerSession3 ?? 0,
            'wedBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession1 ?? 0,
            'wedBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession2 ?? 0,
            'wedBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.breakfastSession3 ?? 0,
            'wedLunchSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession1 ?? 0,
            'wedLunchSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession2 ?? 0,
            'wedLunchSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.lunchSession3 ?? 0,
            'wedDinnerSession1' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession1 ?? 0,
            'wedDinnerSession2' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession2 ?? 0,
            'wedDinnerSession3' : item.fpUnitAvailDaysAndMeals['Wed']?.dinnerSession3 ?? 0,
            'thuBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession1 ?? 0,
            'thuBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession2 ?? 0,
            'thuBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.breakfastSession3 ?? 0,
            'thuLunchSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession1 ?? 0,
            'thuLunchSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession2 ?? 0,
            'thuLunchSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.lunchSession3 ?? 0,
            'thuDinnerSession1' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession1 ?? 0,
            'thuDinnerSession2' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession2 ?? 0,
            'thuDinnerSession3' : item.fpUnitAvailDaysAndMeals['Thu']?.dinnerSession3 ?? 0,
            'friBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession1 ?? 0,
            'friBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession2 ?? 0,
            'friBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.breakfastSession3 ?? 0,
            'friLunchSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession1 ?? 0,
            'friLunchSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession2 ?? 0,
            'friLunchSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.lunchSession3 ?? 0,
            'friDinnerSession1' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession1 ?? 0,
            'friDinnerSession2' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession2 ?? 0,
            'friDinnerSession3' : item.fpUnitAvailDaysAndMeals['Fri']?.dinnerSession3 ?? 0,
            'satBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession1 ?? 0,
            'satBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession2 ?? 0,
            'satBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.breakfastSession3 ?? 0,
            'satLunchSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession1 ?? 0,
            'satLunchSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession2 ?? 0,
            'satLunchSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.lunchSession3 ?? 0,
            'satDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession1 ?? 0,
            'satDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession2 ?? 0,
            'satDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sat']?.dinnerSession3 ?? 0,

          };

          uniqueRegionalItems.add(item.regional);
          uniqueCusineItems.add(item.cuisine);

          if (LiveMenuVariables.foodCategories[item.itemTag] == null) {
            LiveMenuVariables.foodCategories[item.itemTag] = [];
            MenuEditorVariables.menuFoodCategories[item.itemTag] = [];
          }

          LiveMenuVariables.foodCategories[item.itemTag]!.add(oneItem);




          // LiveMenuVariables.selectItem = oneItem;

          // MenuEditorVariables.selectedCategories.add(oneItem['tag']);
          print("${event.id}   ${oneItem['_id']}  ${oneItem['disName']}" );
         if(event.id == oneItem['_id'])
           {
             MenuEditorVariables.selectedItem = oneItem['disName'];
             print("Inside the for loop ${oneItem['disName']}");
             MenuEditorVariables.selectItem = oneItem;
             MenuEditorVariables.selectedCategories.add(item.itemTag);
           }
          // LiveMenuVariables.selectedCategories.add(oneItem['tag']);
          }


        MenuEditorVariables.regional = uniqueRegionalItems.toList();
        MenuEditorVariables.cuisine = uniqueCusineItems.toList();

        emit(MenuLoadedState(newMenu, liveMenu, LiveMenuVariables.foodCategories,
            LiveMenuVariables.selectItem,
            MenuEditorVariables.menuFoodCategories,
            MenuEditorVariables.selectItem));
      } catch (e) {
        print("Menu Errorss ${e.toString()}");
        emit(ErrorState(e.toString()));
      }
    });

  }


}