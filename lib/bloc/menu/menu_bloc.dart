import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_event.dart';
import 'package:partner_admin_portal/bloc/menu/menu_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_functions.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_variables.dart';
import 'package:partner_admin_portal/repository/menu_services.dart';
import '../../models/restaurant_menu.dart';
import '../../provider/day_provider.dart';

List<Mymenu>  liveMenu = [];



class MenuBloc extends Bloc<MenuEvent,MenuState>{
  final MenuService _menuRepository;

  MenuBloc(this._menuRepository) : super(MenuLoadingState()) {

    on<LoadMenuEvent>((event, emit) async {
      emit(MenuLoadingState());
      try {
        List<Mymenu> menu = [];

        DayProvider dayProvider = event.context.read<DayProvider>();

        print(dayProvider.selectedDay);


        bool fetchFirstItem = true;
        menu = await _menuRepository.fetchData();


        GlobalVariables.totalFoodItems = menu;
        LiveMenuVariables.foodCategories = {};
        MenuEditorVariables.menuFoodCategories = {};

        MenuEditorVariables.tags = await  _menuRepository.fetchTags();

        for (var item in menu) {
          Map<String, dynamic> oneItem = {
            '_id' : item.id,
            'name': item.name,
            'disName' : item.dname,
            'availability': item.availability,
            'category': item.category,
            'totalCount' : item.totalCount,
            'normalPrice' : item.normalPrice,
            'packagePrice' : item.packagePrice,
            'preorderPrice' : item.preorderPrice,
            'subTag': item.subTag,
            'tag' : item.itemTag,
            'priceRange' : item.priceRange,
            'itemType' : item.itemType,
            'itemSubType' : item.subTag,
            'comboType' : item.comboType,
            'rawSource' : item.rawSource,
            'subCategory' : item.subCategory,
            'sunBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sun']!.breakfastSession1,
            'sunBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sun']!.breakfastSession2,
            'sunBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sun']!.breakfastSession3,
            'sunBreakfastSession4' : item.fpUnitAvailDaysAndMeals['Sun']!.breakfastSession4,
            'sunLunchSession1' : item.fpUnitAvailDaysAndMeals['Sun']!.lunchSession1,
            'sunLunchSession2' : item.fpUnitAvailDaysAndMeals['Sun']!.lunchSession2,
            'sunLunchSession3' : item.fpUnitAvailDaysAndMeals['Sun']!.lunchSession3,
            'sunLunchSession4' : item.fpUnitAvailDaysAndMeals['Sun']!.lunchSession4,
            'sunDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sun']!.dinnerSession1,
            'sunDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sun']!.dinnerSession2,
            'sunDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sun']!.dinnerSession3,
            'sunDinnerSession4' : item.fpUnitAvailDaysAndMeals['Sun']!.dinnerSession4,
            'monBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Mon']!.breakfastSession1,
            'monBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Mon']!.breakfastSession2,
            'monBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Mon']!.breakfastSession3,
            'monBreakfastSession4' : item.fpUnitAvailDaysAndMeals['Mon']!.breakfastSession4,
            'monLunchSession1' : item.fpUnitAvailDaysAndMeals['Mon']!.lunchSession1,
            'monLunchSession2' : item.fpUnitAvailDaysAndMeals['Mon']!.lunchSession2,
            'monLunchSession3' : item.fpUnitAvailDaysAndMeals['Mon']!.lunchSession3,
            'monLunchSession4' : item.fpUnitAvailDaysAndMeals['Mon']!.lunchSession4,
            'monDinnerSession1' : item.fpUnitAvailDaysAndMeals['Mon']!.dinnerSession1,
            'monDinnerSession2' : item.fpUnitAvailDaysAndMeals['Mon']!.dinnerSession2,
            'monDinnerSession3' : item.fpUnitAvailDaysAndMeals['Mon']!.dinnerSession3,
            'monDinnerSession4' : item.fpUnitAvailDaysAndMeals['Mon']!.dinnerSession4,
            'tueBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Tue']!.breakfastSession1,
            'tueBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Tue']!.breakfastSession2,
            'tueBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Tue']!.breakfastSession3,
            'tueBreakfastSession4' : item.fpUnitAvailDaysAndMeals['Tue']!.breakfastSession4,
            'tueLunchSession1' : item.fpUnitAvailDaysAndMeals['Tue']!.lunchSession1,
            'tueLunchSession2' : item.fpUnitAvailDaysAndMeals['Tue']!.lunchSession2,
            'tueLunchSession3' : item.fpUnitAvailDaysAndMeals['Tue']!.lunchSession3,
            'tueLunchSession4' : item.fpUnitAvailDaysAndMeals['Tue']!.lunchSession4,
            'tueDinnerSession1' : item.fpUnitAvailDaysAndMeals['Tue']!.dinnerSession1,
            'tueDinnerSession2' : item.fpUnitAvailDaysAndMeals['Tue']!.dinnerSession2,
            'tueDinnerSession3' : item.fpUnitAvailDaysAndMeals['Tue']!.dinnerSession3,
            'tueDinnerSession4' : item.fpUnitAvailDaysAndMeals['Tue']!.dinnerSession4,
            'wedBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Wed']!.breakfastSession1,
            'wedBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Wed']!.breakfastSession2,
            'wedBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Wed']!.breakfastSession3,
            'wedBreakfastSession4' : item.fpUnitAvailDaysAndMeals['Wed']!.breakfastSession4,
            'wedLunchSession1' : item.fpUnitAvailDaysAndMeals['Wed']!.lunchSession1,
            'wedLunchSession2' : item.fpUnitAvailDaysAndMeals['Wed']!.lunchSession2,
            'wedLunchSession3' : item.fpUnitAvailDaysAndMeals['Wed']!.lunchSession3,
            'wedLunchSession4' : item.fpUnitAvailDaysAndMeals['Wed']!.lunchSession4,
            'wedDinnerSession1' : item.fpUnitAvailDaysAndMeals['Wed']!.dinnerSession1,
            'wedDinnerSession2' : item.fpUnitAvailDaysAndMeals['Wed']!.dinnerSession2,
            'wedDinnerSession3' : item.fpUnitAvailDaysAndMeals['Wed']!.dinnerSession3,
            'wedDinnerSession4' : item.fpUnitAvailDaysAndMeals['Wed']!.dinnerSession4,
            'thuBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Thu']!.breakfastSession1,
            'thuBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Thu']!.breakfastSession2,
            'thuBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Thu']!.breakfastSession3,
            'thuBreakfastSession4' : item.fpUnitAvailDaysAndMeals['Thu']!.breakfastSession4,
            'thuLunchSession1' : item.fpUnitAvailDaysAndMeals['Thu']!.lunchSession1,
            'thuLunchSession2' : item.fpUnitAvailDaysAndMeals['Thu']!.lunchSession2,
            'thuLunchSession3' : item.fpUnitAvailDaysAndMeals['Thu']!.lunchSession3,
            'thuLunchSession4' : item.fpUnitAvailDaysAndMeals['Thu']!.lunchSession4,
            'thuDinnerSession1' : item.fpUnitAvailDaysAndMeals['Thu']!.dinnerSession1,
            'thuDinnerSession2' : item.fpUnitAvailDaysAndMeals['Thu']!.dinnerSession2,
            'thuDinnerSession3' : item.fpUnitAvailDaysAndMeals['Thu']!.dinnerSession3,
            'thuDinnerSession4' : item.fpUnitAvailDaysAndMeals['Thu']!.dinnerSession4,
            'friBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Fri']!.breakfastSession1,
            'friBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Fri']!.breakfastSession2,
            'friBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Fri']!.breakfastSession3,
            'friBreakfastSession4' : item.fpUnitAvailDaysAndMeals['Fri']!.breakfastSession4,
            'friLunchSession1' : item.fpUnitAvailDaysAndMeals['Fri']!.lunchSession1,
            'friLunchSession2' : item.fpUnitAvailDaysAndMeals['Fri']!.lunchSession2,
            'friLunchSession3' : item.fpUnitAvailDaysAndMeals['Fri']!.lunchSession3,
            'friLunchSession4' : item.fpUnitAvailDaysAndMeals['Fri']!.lunchSession4,
            'friDinnerSession1' : item.fpUnitAvailDaysAndMeals['Fri']!.dinnerSession1,
            'friDinnerSession2' : item.fpUnitAvailDaysAndMeals['Fri']!.dinnerSession2,
            'friDinnerSession3' : item.fpUnitAvailDaysAndMeals['Fri']!.dinnerSession3,
            'friDinnerSession4' : item.fpUnitAvailDaysAndMeals['Fri']!.dinnerSession4,
            'satBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sat']!.breakfastSession1,
            'satBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sat']!.breakfastSession2,
            'satBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sat']!.breakfastSession3,
            'satBreakfastSession4' : item.fpUnitAvailDaysAndMeals['Sat']!.breakfastSession4,
            'satLunchSession1' : item.fpUnitAvailDaysAndMeals['Sat']!.lunchSession1,
            'satLunchSession2' : item.fpUnitAvailDaysAndMeals['Sat']!.lunchSession2,
            'satLunchSession3' : item.fpUnitAvailDaysAndMeals['Sat']!.lunchSession3,
            'satLunchSession4' : item.fpUnitAvailDaysAndMeals['Sat']!.lunchSession4,
            'satDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sat']!.dinnerSession1,
            'satDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sat']!.dinnerSession2,
            'satDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sat']!.dinnerSession3,
            'satDinnerSession4' : item.fpUnitAvailDaysAndMeals['Sat']!.dinnerSession4,

            'breakfast' : item.fpUnitSessions.breakfast.defaultSession.enabled,
            'lunch' : item.fpUnitSessions.lunch.defaultSession.enabled,
            'dinner' : item.fpUnitSessions.dinner.defaultSession.enabled,
            'breakfastCount' : item.fpUnitSessions.breakfast.defaultSession.availableCount,
            'lunchCount' : item.fpUnitSessions.lunch.defaultSession.availableCount,
            'dinnerCount' : item.fpUnitSessions.dinner.defaultSession.availableCount,
            'breakfastSession1Count' : item.fpUnitSessions.breakfast.session1.availableCount,
            'breakfastSession2Count' : item.fpUnitSessions.breakfast.session2.availableCount,
            'breakfastSession3Count' : item.fpUnitSessions.breakfast.session3.availableCount,
            'breakfastSession4Count' : item.fpUnitSessions.breakfast.session4.availableCount,
            'lunchSession1Count' : item.fpUnitSessions.lunch.session1.availableCount,
            'lunchSession2Count' : item.fpUnitSessions.lunch.session2.availableCount,
            'lunchSession3Count' : item.fpUnitSessions.lunch.session3.availableCount,
            'lunchSession4Count' : item.fpUnitSessions.lunch.session4.availableCount,
            'dinnerSession1Count' : item.fpUnitSessions.dinner.session1.availableCount,
            'dinnerSession2Count' : item.fpUnitSessions.dinner.session2.availableCount,
            'dinnerSession3Count' : item.fpUnitSessions.dinner.session3.availableCount,
            'dinnerSession4Count' : item.fpUnitSessions.dinner.session4.availableCount,
          };


          if (LiveMenuVariables.foodCategories[item.itemTag] == null) {
            LiveMenuVariables.foodCategories[item.itemTag] = [];
            MenuEditorVariables.menuFoodCategories[item.itemTag] = [];
          }

          LiveMenuVariables.foodCategories[item.itemTag]!.add(oneItem);



          if((item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.breakfastSession1 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.breakfastSession2 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.breakfastSession3 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.breakfastSession4 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.lunchSession1
              || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.lunchSession2 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.lunchSession3 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.lunchSession4 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.dinnerSession1 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.dinnerSession2 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.dinnerSession3
              || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.dinnerSession4) && item.availability ) {
            MenuEditorVariables.menuFoodCategories[item.itemTag]!.add(oneItem);
            liveMenu.add(item);
          }



          if(fetchFirstItem)
          {
            LiveMenuVariables.selectItem = oneItem;
            MenuEditorVariables.selectItem = oneItem;
            MenuEditorVariables.selectedCategories.add(oneItem['tag']);
            MenuEditorVariables.tagController.text = oneItem['tag'];
            MenuEditorVariables.selectedItem = "";
            //  MenuEditorVariables.selectedItem = oneItem['disName'];
            LiveMenuVariables.selectedCategories.add(oneItem['tag']);
            // MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S1'] = !oneItem['breakfast'];
            fetchFirstItem=false;
          }
        }
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


        emit(MenuLoadedState(menu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories,MenuEditorVariables.selectItem));
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
            'availability': item.availability,
            'category': item.category,
            'totalCount' : item.totalCount,
            'normalPrice' : item.normalPrice,
            'packagePrice' : item.packagePrice,
            'preorderPrice' : item.preorderPrice,
            'subTag': item.subTag,
            'tag' : item.itemTag,
            'priceRange' : item.priceRange,
            'itemType' : item.itemType,
            'itemSubType' : item.subTag,
            'comboType' : item.comboType,
            'rawSource' : item.rawSource,
            'subCategory' : item.subCategory,
            'sunBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sun']!.breakfastSession1,
            'sunBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sun']!.breakfastSession2,
            'sunBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sun']!.breakfastSession3,
            'sunBreakfastSession4' : item.fpUnitAvailDaysAndMeals['Sun']!.breakfastSession4,
            'sunLunchSession1' : item.fpUnitAvailDaysAndMeals['Sun']!.lunchSession1,
            'sunLunchSession2' : item.fpUnitAvailDaysAndMeals['Sun']!.lunchSession2,
            'sunLunchSession3' : item.fpUnitAvailDaysAndMeals['Sun']!.lunchSession3,
            'sunLunchSession4' : item.fpUnitAvailDaysAndMeals['Sun']!.lunchSession4,
            'sunDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sun']!.dinnerSession1,
            'sunDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sun']!.dinnerSession2,
            'sunDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sun']!.dinnerSession3,
            'sunDinnerSession4' : item.fpUnitAvailDaysAndMeals['Sun']!.dinnerSession4,
            'monBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Mon']!.breakfastSession1,
            'monBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Mon']!.breakfastSession2,
            'monBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Mon']!.breakfastSession3,
            'monBreakfastSession4' : item.fpUnitAvailDaysAndMeals['Mon']!.breakfastSession4,
            'monLunchSession1' : item.fpUnitAvailDaysAndMeals['Mon']!.lunchSession1,
            'monLunchSession2' : item.fpUnitAvailDaysAndMeals['Mon']!.lunchSession2,
            'monLunchSession3' : item.fpUnitAvailDaysAndMeals['Mon']!.lunchSession3,
            'monLunchSession4' : item.fpUnitAvailDaysAndMeals['Mon']!.lunchSession4,
            'monDinnerSession1' : item.fpUnitAvailDaysAndMeals['Mon']!.dinnerSession1,
            'monDinnerSession2' : item.fpUnitAvailDaysAndMeals['Mon']!.dinnerSession2,
            'monDinnerSession3' : item.fpUnitAvailDaysAndMeals['Mon']!.dinnerSession3,
            'monDinnerSession4' : item.fpUnitAvailDaysAndMeals['Mon']!.dinnerSession4,
            'tueBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Tue']!.breakfastSession1,
            'tueBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Tue']!.breakfastSession2,
            'tueBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Tue']!.breakfastSession3,
            'tueBreakfastSession4' : item.fpUnitAvailDaysAndMeals['Tue']!.breakfastSession4,
            'tueLunchSession1' : item.fpUnitAvailDaysAndMeals['Tue']!.lunchSession1,
            'tueLunchSession2' : item.fpUnitAvailDaysAndMeals['Tue']!.lunchSession2,
            'tueLunchSession3' : item.fpUnitAvailDaysAndMeals['Tue']!.lunchSession3,
            'tueLunchSession4' : item.fpUnitAvailDaysAndMeals['Tue']!.lunchSession4,
            'tueDinnerSession1' : item.fpUnitAvailDaysAndMeals['Tue']!.dinnerSession1,
            'tueDinnerSession2' : item.fpUnitAvailDaysAndMeals['Tue']!.dinnerSession2,
            'tueDinnerSession3' : item.fpUnitAvailDaysAndMeals['Tue']!.dinnerSession3,
            'tueDinnerSession4' : item.fpUnitAvailDaysAndMeals['Tue']!.dinnerSession4,
            'wedBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Wed']!.breakfastSession1,
            'wedBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Wed']!.breakfastSession2,
            'wedBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Wed']!.breakfastSession3,
            'wedBreakfastSession4' : item.fpUnitAvailDaysAndMeals['Wed']!.breakfastSession4,
            'wedLunchSession1' : item.fpUnitAvailDaysAndMeals['Wed']!.lunchSession1,
            'wedLunchSession2' : item.fpUnitAvailDaysAndMeals['Wed']!.lunchSession2,
            'wedLunchSession3' : item.fpUnitAvailDaysAndMeals['Wed']!.lunchSession3,
            'wedLunchSession4' : item.fpUnitAvailDaysAndMeals['Wed']!.lunchSession4,
            'wedDinnerSession1' : item.fpUnitAvailDaysAndMeals['Wed']!.dinnerSession1,
            'wedDinnerSession2' : item.fpUnitAvailDaysAndMeals['Wed']!.dinnerSession2,
            'wedDinnerSession3' : item.fpUnitAvailDaysAndMeals['Wed']!.dinnerSession3,
            'wedDinnerSession4' : item.fpUnitAvailDaysAndMeals['Wed']!.dinnerSession4,
            'thuBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Thu']!.breakfastSession1,
            'thuBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Thu']!.breakfastSession2,
            'thuBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Thu']!.breakfastSession3,
            'thuBreakfastSession4' : item.fpUnitAvailDaysAndMeals['Thu']!.breakfastSession4,
            'thuLunchSession1' : item.fpUnitAvailDaysAndMeals['Thu']!.lunchSession1,
            'thuLunchSession2' : item.fpUnitAvailDaysAndMeals['Thu']!.lunchSession2,
            'thuLunchSession3' : item.fpUnitAvailDaysAndMeals['Thu']!.lunchSession3,
            'thuLunchSession4' : item.fpUnitAvailDaysAndMeals['Thu']!.lunchSession4,
            'thuDinnerSession1' : item.fpUnitAvailDaysAndMeals['Thu']!.dinnerSession1,
            'thuDinnerSession2' : item.fpUnitAvailDaysAndMeals['Thu']!.dinnerSession2,
            'thuDinnerSession3' : item.fpUnitAvailDaysAndMeals['Thu']!.dinnerSession3,
            'thuDinnerSession4' : item.fpUnitAvailDaysAndMeals['Thu']!.dinnerSession4,
            'friBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Fri']!.breakfastSession1,
            'friBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Fri']!.breakfastSession2,
            'friBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Fri']!.breakfastSession3,
            'friBreakfastSession4' : item.fpUnitAvailDaysAndMeals['Fri']!.breakfastSession4,
            'friLunchSession1' : item.fpUnitAvailDaysAndMeals['Fri']!.lunchSession1,
            'friLunchSession2' : item.fpUnitAvailDaysAndMeals['Fri']!.lunchSession2,
            'friLunchSession3' : item.fpUnitAvailDaysAndMeals['Fri']!.lunchSession3,
            'friLunchSession4' : item.fpUnitAvailDaysAndMeals['Fri']!.lunchSession4,
            'friDinnerSession1' : item.fpUnitAvailDaysAndMeals['Fri']!.dinnerSession1,
            'friDinnerSession2' : item.fpUnitAvailDaysAndMeals['Fri']!.dinnerSession2,
            'friDinnerSession3' : item.fpUnitAvailDaysAndMeals['Fri']!.dinnerSession3,
            'friDinnerSession4' : item.fpUnitAvailDaysAndMeals['Fri']!.dinnerSession4,
            'satBreakfastSession1' : item.fpUnitAvailDaysAndMeals['Sat']!.breakfastSession1,
            'satBreakfastSession2' : item.fpUnitAvailDaysAndMeals['Sat']!.breakfastSession2,
            'satBreakfastSession3' : item.fpUnitAvailDaysAndMeals['Sat']!.breakfastSession3,
            'satBreakfastSession4' : item.fpUnitAvailDaysAndMeals['Sat']!.breakfastSession4,
            'satLunchSession1' : item.fpUnitAvailDaysAndMeals['Sat']!.lunchSession1,
            'satLunchSession2' : item.fpUnitAvailDaysAndMeals['Sat']!.lunchSession2,
            'satLunchSession3' : item.fpUnitAvailDaysAndMeals['Sat']!.lunchSession3,
            'satLunchSession4' : item.fpUnitAvailDaysAndMeals['Sat']!.lunchSession4,
            'satDinnerSession1' : item.fpUnitAvailDaysAndMeals['Sat']!.dinnerSession1,
            'satDinnerSession2' : item.fpUnitAvailDaysAndMeals['Sat']!.dinnerSession2,
            'satDinnerSession3' : item.fpUnitAvailDaysAndMeals['Sat']!.dinnerSession3,
            'satDinnerSession4' : item.fpUnitAvailDaysAndMeals['Sat']!.dinnerSession4,
            'breakfastCount' : item.fpUnitSessions.breakfast.defaultSession.availableCount,
            'lunchCount' : item.fpUnitSessions.lunch.defaultSession.availableCount,
            'dinnerCount' : item.fpUnitSessions.dinner.defaultSession.availableCount,
            'breakfastSession1Count' : item.fpUnitSessions.breakfast.session1.availableCount,
            'breakfastSession2Count' : item.fpUnitSessions.breakfast.session2.availableCount,
            'breakfastSession3Count' : item.fpUnitSessions.breakfast.session3.availableCount,
            'breakfastSession4Count' : item.fpUnitSessions.breakfast.session4.availableCount,
            'lunchSession1Count' : item.fpUnitSessions.lunch.session1.availableCount,
            'lunchSession2Count' : item.fpUnitSessions.lunch.session2.availableCount,
            'lunchSession3Count' : item.fpUnitSessions.lunch.session3.availableCount,
            'lunchSession4Count' : item.fpUnitSessions.lunch.session4.availableCount,
            'dinnerSession1Count' : item.fpUnitSessions.dinner.session1.availableCount,
            'dinnerSession2Count' : item.fpUnitSessions.dinner.session2.availableCount,
            'dinnerSession3Count' : item.fpUnitSessions.dinner.session3.availableCount,
            'dinnerSession4Count' : item.fpUnitSessions.dinner.session4.availableCount,
          };

          if (LiveMenuVariables.foodCategories[item.subTag] == null) {
            LiveMenuVariables.foodCategories[item.subTag] = [];
            MenuEditorVariables.menuFoodCategories[item.subTag] = [];
          }

          LiveMenuVariables.foodCategories[item.subTag]!.add(oneItem);


          if(item.fpUnitAvailDaysAndMeals[event.date.substring(0,3)]!.breakfastSession1) {
            MenuEditorVariables.menuFoodCategories[item.subTag]!.add(oneItem);
            liveMenu.add(item);
          }
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
        Map<String,dynamic> req = {
          "std_itm_name": "",
          "std_itm_dispname": "sample",
          "std_itm_subTag": "",
          "std_itm_priceRange": "",
          "std_itm_itemType": "",
          "std_itm_itemSubType": "",
          "std_itm_comboType": "",
          "std_itm_rawSource": "",
          "std_itm_category": "",
          "std_itm_cuisine": "",
          "std_itm_regional": "",
          "std_itm_subCategory": "",
          "std_itm_normalPrice": 0.0,
          "std_itm_packagePrice": 0.0,
          "std_itm_preorderPrice": 0.0,
          "std_itm_tag" : event.tag,
          "fp_unit_avail_days_and_meals": {
            "Sun": { "Breakfast": false, "Lunch": false, "Dinner": false, "BreakfastSession1": false, "BreakfastSession2": false, "BreakfastSession3": false, "BreakfastSession4": false, "LunchSession1": false, "LunchSession2": false, "LunchSession3": false, "LunchSession4": false, "DinnerSession1": false, "DinnerSession2": false, "DinnerSession3": false, "DinnerSession4": false },
            "Mon": { "Breakfast": false, "Lunch": false, "Dinner": false, "BreakfastSession1": false, "BreakfastSession2": false, "BreakfastSession3": false, "BreakfastSession4": false, "LunchSession1": false, "LunchSession2": false, "LunchSession3": false, "LunchSession4": false, "DinnerSession1": false, "DinnerSession2": false, "DinnerSession3": false, "DinnerSession4": false },
            "Tue": { "Breakfast": false, "Lunch": false, "Dinner": false, "BreakfastSession1": false, "BreakfastSession2": false, "BreakfastSession3": false, "BreakfastSession4": false, "LunchSession1": false, "LunchSession2": false, "LunchSession3": false, "LunchSession4": false, "DinnerSession1": false, "DinnerSession2": false, "DinnerSession3": false, "DinnerSession4": false },
            "Wed": { "Breakfast": false, "Lunch": false, "Dinner": false, "BreakfastSession1": false, "BreakfastSession2": false, "BreakfastSession3": false, "BreakfastSession4": false, "LunchSession1": false, "LunchSession2": false, "LunchSession3": false, "LunchSession4": false, "DinnerSession1": false, "DinnerSession2": false, "DinnerSession3": false, "DinnerSession4": false },
            "Thu": { "Breakfast": false, "Lunch": false, "Dinner": false, "BreakfastSession1": false, "BreakfastSession2": false, "BreakfastSession3": false, "BreakfastSession4": false, "LunchSession1": false, "LunchSession2": false, "LunchSession3": false, "LunchSession4": false, "DinnerSession1": false, "DinnerSession2": false, "DinnerSession3": false, "DinnerSession4": false },
            "Fri": { "Breakfast": false, "Lunch": false, "Dinner": false, "BreakfastSession1": false, "BreakfastSession2": false, "BreakfastSession3": false, "BreakfastSession4": false, "LunchSession1": false, "LunchSession2": false, "LunchSession3": false, "LunchSession4": false, "DinnerSession1": false, "DinnerSession2": false, "DinnerSession3": false, "DinnerSession4": false },
            "Sat": { "Breakfast": false, "Lunch": false, "Dinner": false, "BreakfastSession1": false, "BreakfastSession2": false, "BreakfastSession3": false, "BreakfastSession4": false, "LunchSession1": false, "LunchSession2": false, "LunchSession3": false, "LunchSession4": false, "DinnerSession1": false, "DinnerSession2": false, "DinnerSession3": false, "DinnerSession4": false }
          },
          "fp_unit_sessions": {
            "Breakfast": {
              "Default": {},
              "Session1": {},
              "Session2": {},
              "Session3": {},
              "Session4": {}
            },
            "Lunch": {
              "Default": {},
              "Session1": {},
              "Session2": {},
              "Session3": {},
              "Session4": {}
            },
            "Dinner": {
              "Default": {},
              "Session1": {},
              "Session2": {},
              "Session3": {},
              "Session4": {}
            }
          }
          ,
          "std_itm_availability": false
        };

        List<Mymenu> newMenu = [];
        LiveMenuVariables.foodCategories = {};
        MenuEditorVariables.menuFoodCategories = {};
        await _menuRepository.addSection(req);

        newMenu = await _menuRepository.fetchData();

        for (var item in newMenu) {
          Map<String, dynamic> oneItem = {
            '_id': item.id,
            'name': item.name,
            'disName': item.dname,
            'availability': item.availability,
            'category': item.category,
            'totalCount': item.totalCount,
            'normalPrice': item.normalPrice,
            'packagePrice': item.packagePrice,
            'preorderPrice': item.preorderPrice,
            'subTag': item.subTag,
            'tag': item.itemTag,
            'priceRange': item.priceRange,
            'itemType': item.itemType,
            'itemSubType': item.subTag,
            'comboType': item.comboType,
            'rawSource': item.rawSource,
            'subCategory': item.subCategory,
            'sunBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession1,
            'sunBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession2,
            'sunBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession3,
            'sunBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession4,
            'sunLunchSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession1,
            'sunLunchSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession2,
            'sunLunchSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession3,
            'sunLunchSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession4,
            'sunDinnerSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession1,
            'sunDinnerSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession2,
            'sunDinnerSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession3,
            'sunDinnerSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession4,
            'monBreakfastSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession1,
            'monBreakfastSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession2,
            'monBreakfastSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession3,
            'monBreakfastSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession4,
            'monLunchSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession1,
            'monLunchSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession2,
            'monLunchSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession3,
            'monLunchSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession4,
            'monDinnerSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession1,
            'monDinnerSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession2,
            'monDinnerSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession3,
            'monDinnerSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession4,
            'tueBreakfastSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession1,
            'tueBreakfastSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession2,
            'tueBreakfastSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession3,
            'tueBreakfastSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession4,
            'tueLunchSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession1,
            'tueLunchSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession2,
            'tueLunchSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession3,
            'tueLunchSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession4,
            'tueDinnerSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession1,
            'tueDinnerSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession2,
            'tueDinnerSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession3,
            'tueDinnerSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession4,
            'wedBreakfastSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession1,
            'wedBreakfastSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession2,
            'wedBreakfastSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession3,
            'wedBreakfastSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession4,
            'wedLunchSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession1,
            'wedLunchSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession2,
            'wedLunchSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession3,
            'wedLunchSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession4,
            'wedDinnerSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession1,
            'wedDinnerSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession2,
            'wedDinnerSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession3,
            'wedDinnerSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession4,
            'thuBreakfastSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession1,
            'thuBreakfastSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession2,
            'thuBreakfastSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession3,
            'thuBreakfastSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession4,
            'thuLunchSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession1,
            'thuLunchSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession2,
            'thuLunchSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession3,
            'thuLunchSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession4,
            'thuDinnerSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession1,
            'thuDinnerSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession2,
            'thuDinnerSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession3,
            'thuDinnerSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession4,
            'friBreakfastSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession1,
            'friBreakfastSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession2,
            'friBreakfastSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession3,
            'friBreakfastSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession4,
            'friLunchSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession1,
            'friLunchSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession2,
            'friLunchSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession3,
            'friLunchSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession4,
            'friDinnerSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession1,
            'friDinnerSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession2,
            'friDinnerSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession3,
            'friDinnerSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession4,
            'satBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession1,
            'satBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession2,
            'satBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession3,
            'satBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession4,
            'satLunchSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession1,
            'satLunchSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession2,
            'satLunchSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession3,
            'satLunchSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession4,
            'satDinnerSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession1,
            'satDinnerSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession2,
            'satDinnerSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession3,
            'satDinnerSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession4,

            'breakfast': item.fpUnitSessions.breakfast.defaultSession.enabled,
            'lunch': item.fpUnitSessions.lunch.defaultSession.enabled,
            'dinner': item.fpUnitSessions.dinner.defaultSession.enabled,
            'breakfastCount': item.fpUnitSessions.breakfast.defaultSession
                .availableCount,
            'lunchCount': item.fpUnitSessions.lunch.defaultSession
                .availableCount,
            'dinnerCount': item.fpUnitSessions.dinner.defaultSession
                .availableCount,
            'breakfastSession1Count': item.fpUnitSessions.breakfast.session1
                .availableCount,
            'breakfastSession2Count': item.fpUnitSessions.breakfast.session2
                .availableCount,
            'breakfastSession3Count': item.fpUnitSessions.breakfast.session3
                .availableCount,
            'breakfastSession4Count': item.fpUnitSessions.breakfast.session4
                .availableCount,
            'lunchSession1Count': item.fpUnitSessions.lunch.session1
                .availableCount,
            'lunchSession2Count': item.fpUnitSessions.lunch.session2
                .availableCount,
            'lunchSession3Count': item.fpUnitSessions.lunch.session3
                .availableCount,
            'lunchSession4Count': item.fpUnitSessions.lunch.session4
                .availableCount,
            'dinnerSession1Count': item.fpUnitSessions.dinner.session1
                .availableCount,
            'dinnerSession2Count': item.fpUnitSessions.dinner.session2
                .availableCount,
            'dinnerSession3Count': item.fpUnitSessions.dinner.session3
                .availableCount,
            'dinnerSession4Count': item.fpUnitSessions.dinner.session4
                .availableCount,
          };


          if (LiveMenuVariables.foodCategories[item.itemTag] == null) {
            LiveMenuVariables.foodCategories[item.itemTag] = [];
            MenuEditorVariables.menuFoodCategories[item.itemTag] = [];
          }

          LiveMenuVariables.foodCategories[item.itemTag]!.add(oneItem);

        }

        emit(MenuLoadedState(newMenu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }


    });

    on<AddItemsEvent>((event, emit) async {

      MenuEditorVariables.items = [];

      MenuEditorVariables.items = await _menuRepository.fetchDisplayNamesByTag(event.context,event.tagName);

      List<Mymenu> newMenu = [];
      LiveMenuVariables.foodCategories = {};
      MenuEditorVariables.menuFoodCategories = {};

      MenuEditorFunction.showAddItemDialog(event.tagName, event.context, event.menuContext, event.foodCategories);

      newMenu = await _menuRepository.fetchData();

      for (var item in newMenu) {
        Map<String, dynamic> oneItem = {
          '_id': item.id,
          'name': item.name,
          'disName': item.dname,
          'availability': item.availability,
          'category': item.category,
          'totalCount': item.totalCount,
          'normalPrice': item.normalPrice,
          'packagePrice': item.packagePrice,
          'preorderPrice': item.preorderPrice,
          'subTag': item.subTag,
          'tag': item.itemTag,
          'priceRange': item.priceRange,
          'itemType': item.itemType,
          'itemSubType': item.subTag,
          'comboType': item.comboType,
          'rawSource': item.rawSource,
          'subCategory': item.subCategory,
          'sunBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sun']!
              .breakfastSession1,
          'sunBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sun']!
              .breakfastSession2,
          'sunBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sun']!
              .breakfastSession3,
          'sunBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sun']!
              .breakfastSession4,
          'sunLunchSession1': item.fpUnitAvailDaysAndMeals['Sun']!
              .lunchSession1,
          'sunLunchSession2': item.fpUnitAvailDaysAndMeals['Sun']!
              .lunchSession2,
          'sunLunchSession3': item.fpUnitAvailDaysAndMeals['Sun']!
              .lunchSession3,
          'sunLunchSession4': item.fpUnitAvailDaysAndMeals['Sun']!
              .lunchSession4,
          'sunDinnerSession1': item.fpUnitAvailDaysAndMeals['Sun']!
              .dinnerSession1,
          'sunDinnerSession2': item.fpUnitAvailDaysAndMeals['Sun']!
              .dinnerSession2,
          'sunDinnerSession3': item.fpUnitAvailDaysAndMeals['Sun']!
              .dinnerSession3,
          'sunDinnerSession4': item.fpUnitAvailDaysAndMeals['Sun']!
              .dinnerSession4,
          'monBreakfastSession1': item.fpUnitAvailDaysAndMeals['Mon']!
              .breakfastSession1,
          'monBreakfastSession2': item.fpUnitAvailDaysAndMeals['Mon']!
              .breakfastSession2,
          'monBreakfastSession3': item.fpUnitAvailDaysAndMeals['Mon']!
              .breakfastSession3,
          'monBreakfastSession4': item.fpUnitAvailDaysAndMeals['Mon']!
              .breakfastSession4,
          'monLunchSession1': item.fpUnitAvailDaysAndMeals['Mon']!
              .lunchSession1,
          'monLunchSession2': item.fpUnitAvailDaysAndMeals['Mon']!
              .lunchSession2,
          'monLunchSession3': item.fpUnitAvailDaysAndMeals['Mon']!
              .lunchSession3,
          'monLunchSession4': item.fpUnitAvailDaysAndMeals['Mon']!
              .lunchSession4,
          'monDinnerSession1': item.fpUnitAvailDaysAndMeals['Mon']!
              .dinnerSession1,
          'monDinnerSession2': item.fpUnitAvailDaysAndMeals['Mon']!
              .dinnerSession2,
          'monDinnerSession3': item.fpUnitAvailDaysAndMeals['Mon']!
              .dinnerSession3,
          'monDinnerSession4': item.fpUnitAvailDaysAndMeals['Mon']!
              .dinnerSession4,
          'tueBreakfastSession1': item.fpUnitAvailDaysAndMeals['Tue']!
              .breakfastSession1,
          'tueBreakfastSession2': item.fpUnitAvailDaysAndMeals['Tue']!
              .breakfastSession2,
          'tueBreakfastSession3': item.fpUnitAvailDaysAndMeals['Tue']!
              .breakfastSession3,
          'tueBreakfastSession4': item.fpUnitAvailDaysAndMeals['Tue']!
              .breakfastSession4,
          'tueLunchSession1': item.fpUnitAvailDaysAndMeals['Tue']!
              .lunchSession1,
          'tueLunchSession2': item.fpUnitAvailDaysAndMeals['Tue']!
              .lunchSession2,
          'tueLunchSession3': item.fpUnitAvailDaysAndMeals['Tue']!
              .lunchSession3,
          'tueLunchSession4': item.fpUnitAvailDaysAndMeals['Tue']!
              .lunchSession4,
          'tueDinnerSession1': item.fpUnitAvailDaysAndMeals['Tue']!
              .dinnerSession1,
          'tueDinnerSession2': item.fpUnitAvailDaysAndMeals['Tue']!
              .dinnerSession2,
          'tueDinnerSession3': item.fpUnitAvailDaysAndMeals['Tue']!
              .dinnerSession3,
          'tueDinnerSession4': item.fpUnitAvailDaysAndMeals['Tue']!
              .dinnerSession4,
          'wedBreakfastSession1': item.fpUnitAvailDaysAndMeals['Wed']!
              .breakfastSession1,
          'wedBreakfastSession2': item.fpUnitAvailDaysAndMeals['Wed']!
              .breakfastSession2,
          'wedBreakfastSession3': item.fpUnitAvailDaysAndMeals['Wed']!
              .breakfastSession3,
          'wedBreakfastSession4': item.fpUnitAvailDaysAndMeals['Wed']!
              .breakfastSession4,
          'wedLunchSession1': item.fpUnitAvailDaysAndMeals['Wed']!
              .lunchSession1,
          'wedLunchSession2': item.fpUnitAvailDaysAndMeals['Wed']!
              .lunchSession2,
          'wedLunchSession3': item.fpUnitAvailDaysAndMeals['Wed']!
              .lunchSession3,
          'wedLunchSession4': item.fpUnitAvailDaysAndMeals['Wed']!
              .lunchSession4,
          'wedDinnerSession1': item.fpUnitAvailDaysAndMeals['Wed']!
              .dinnerSession1,
          'wedDinnerSession2': item.fpUnitAvailDaysAndMeals['Wed']!
              .dinnerSession2,
          'wedDinnerSession3': item.fpUnitAvailDaysAndMeals['Wed']!
              .dinnerSession3,
          'wedDinnerSession4': item.fpUnitAvailDaysAndMeals['Wed']!
              .dinnerSession4,
          'thuBreakfastSession1': item.fpUnitAvailDaysAndMeals['Thu']!
              .breakfastSession1,
          'thuBreakfastSession2': item.fpUnitAvailDaysAndMeals['Thu']!
              .breakfastSession2,
          'thuBreakfastSession3': item.fpUnitAvailDaysAndMeals['Thu']!
              .breakfastSession3,
          'thuBreakfastSession4': item.fpUnitAvailDaysAndMeals['Thu']!
              .breakfastSession4,
          'thuLunchSession1': item.fpUnitAvailDaysAndMeals['Thu']!
              .lunchSession1,
          'thuLunchSession2': item.fpUnitAvailDaysAndMeals['Thu']!
              .lunchSession2,
          'thuLunchSession3': item.fpUnitAvailDaysAndMeals['Thu']!
              .lunchSession3,
          'thuLunchSession4': item.fpUnitAvailDaysAndMeals['Thu']!
              .lunchSession4,
          'thuDinnerSession1': item.fpUnitAvailDaysAndMeals['Thu']!
              .dinnerSession1,
          'thuDinnerSession2': item.fpUnitAvailDaysAndMeals['Thu']!
              .dinnerSession2,
          'thuDinnerSession3': item.fpUnitAvailDaysAndMeals['Thu']!
              .dinnerSession3,
          'thuDinnerSession4': item.fpUnitAvailDaysAndMeals['Thu']!
              .dinnerSession4,
          'friBreakfastSession1': item.fpUnitAvailDaysAndMeals['Fri']!
              .breakfastSession1,
          'friBreakfastSession2': item.fpUnitAvailDaysAndMeals['Fri']!
              .breakfastSession2,
          'friBreakfastSession3': item.fpUnitAvailDaysAndMeals['Fri']!
              .breakfastSession3,
          'friBreakfastSession4': item.fpUnitAvailDaysAndMeals['Fri']!
              .breakfastSession4,
          'friLunchSession1': item.fpUnitAvailDaysAndMeals['Fri']!
              .lunchSession1,
          'friLunchSession2': item.fpUnitAvailDaysAndMeals['Fri']!
              .lunchSession2,
          'friLunchSession3': item.fpUnitAvailDaysAndMeals['Fri']!
              .lunchSession3,
          'friLunchSession4': item.fpUnitAvailDaysAndMeals['Fri']!
              .lunchSession4,
          'friDinnerSession1': item.fpUnitAvailDaysAndMeals['Fri']!
              .dinnerSession1,
          'friDinnerSession2': item.fpUnitAvailDaysAndMeals['Fri']!
              .dinnerSession2,
          'friDinnerSession3': item.fpUnitAvailDaysAndMeals['Fri']!
              .dinnerSession3,
          'friDinnerSession4': item.fpUnitAvailDaysAndMeals['Fri']!
              .dinnerSession4,
          'satBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sat']!
              .breakfastSession1,
          'satBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sat']!
              .breakfastSession2,
          'satBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sat']!
              .breakfastSession3,
          'satBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sat']!
              .breakfastSession4,
          'satLunchSession1': item.fpUnitAvailDaysAndMeals['Sat']!
              .lunchSession1,
          'satLunchSession2': item.fpUnitAvailDaysAndMeals['Sat']!
              .lunchSession2,
          'satLunchSession3': item.fpUnitAvailDaysAndMeals['Sat']!
              .lunchSession3,
          'satLunchSession4': item.fpUnitAvailDaysAndMeals['Sat']!
              .lunchSession4,
          'satDinnerSession1': item.fpUnitAvailDaysAndMeals['Sat']!
              .dinnerSession1,
          'satDinnerSession2': item.fpUnitAvailDaysAndMeals['Sat']!
              .dinnerSession2,
          'satDinnerSession3': item.fpUnitAvailDaysAndMeals['Sat']!
              .dinnerSession3,
          'satDinnerSession4': item.fpUnitAvailDaysAndMeals['Sat']!
              .dinnerSession4,

          'breakfast': item.fpUnitSessions.breakfast.defaultSession.enabled,
          'lunch': item.fpUnitSessions.lunch.defaultSession.enabled,
          'dinner': item.fpUnitSessions.dinner.defaultSession.enabled,
          'breakfastCount': item.fpUnitSessions.breakfast.defaultSession
              .availableCount,
          'lunchCount': item.fpUnitSessions.lunch.defaultSession
              .availableCount,
          'dinnerCount': item.fpUnitSessions.dinner.defaultSession
              .availableCount,
          'breakfastSession1Count': item.fpUnitSessions.breakfast.session1
              .availableCount,
          'breakfastSession2Count': item.fpUnitSessions.breakfast.session2
              .availableCount,
          'breakfastSession3Count': item.fpUnitSessions.breakfast.session3
              .availableCount,
          'breakfastSession4Count': item.fpUnitSessions.breakfast.session4
              .availableCount,
          'lunchSession1Count': item.fpUnitSessions.lunch.session1
              .availableCount,
          'lunchSession2Count': item.fpUnitSessions.lunch.session2
              .availableCount,
          'lunchSession3Count': item.fpUnitSessions.lunch.session3
              .availableCount,
          'lunchSession4Count': item.fpUnitSessions.lunch.session4
              .availableCount,
          'dinnerSession1Count': item.fpUnitSessions.dinner.session1
              .availableCount,
          'dinnerSession2Count': item.fpUnitSessions.dinner.session2
              .availableCount,
          'dinnerSession3Count': item.fpUnitSessions.dinner.session3
              .availableCount,
          'dinnerSession4Count': item.fpUnitSessions.dinner.session4
              .availableCount,
        };


        if (LiveMenuVariables.foodCategories[item.itemTag] == null) {
          LiveMenuVariables.foodCategories[item.itemTag] = [];
          MenuEditorVariables.menuFoodCategories[item.itemTag] = [];
        }

        LiveMenuVariables.foodCategories[item.itemTag]!.add(oneItem);

      }

      emit(MenuLoadedState(newMenu,liveMenu,LiveMenuVariables.foodCategories,LiveMenuVariables.selectItem,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));

    });

    on<AddMenuItemEvent>((event, emit) async {

      emit(MenuLoadingState());
      try {
        Map<String, dynamic> req = {
          "std_itm_name": "",
          "std_itm_dispname": event.displayName,
          "std_itm_subTag": "",
          "std_itm_priceRange": "",
          "std_itm_itemType": "",
          "std_itm_itemSubType": "",
          "std_itm_comboType": "",
          "std_itm_rawSource": "",
          "std_itm_category": "",
          "std_itm_cuisine": "",
          "std_itm_regional": "",
          "std_itm_subCategory": "",
          "std_itm_normalPrice": 0.0,
          "std_itm_packagePrice": 0.0,
          "std_itm_preorderPrice": 0.0,
          "std_itm_tag": event.tagName,
          "fp_unit_avail_days_and_meals": {
            "Sun": {
              "Breakfast": false,
              "Lunch": false,
              "Dinner": false,
              "BreakfastSession1": false,
              "BreakfastSession2": false,
              "BreakfastSession3": false,
              "BreakfastSession4": false,
              "LunchSession1": false,
              "LunchSession2": false,
              "LunchSession3": false,
              "LunchSession4": false,
              "DinnerSession1": false,
              "DinnerSession2": false,
              "DinnerSession3": false,
              "DinnerSession4": false
            },
            "Mon": {
              "Breakfast": false,
              "Lunch": false,
              "Dinner": false,
              "BreakfastSession1": false,
              "BreakfastSession2": false,
              "BreakfastSession3": false,
              "BreakfastSession4": false,
              "LunchSession1": false,
              "LunchSession2": false,
              "LunchSession3": false,
              "LunchSession4": false,
              "DinnerSession1": false,
              "DinnerSession2": false,
              "DinnerSession3": false,
              "DinnerSession4": false
            },
            "Tue": {
              "Breakfast": false,
              "Lunch": false,
              "Dinner": false,
              "BreakfastSession1": false,
              "BreakfastSession2": false,
              "BreakfastSession3": false,
              "BreakfastSession4": false,
              "LunchSession1": false,
              "LunchSession2": false,
              "LunchSession3": false,
              "LunchSession4": false,
              "DinnerSession1": false,
              "DinnerSession2": false,
              "DinnerSession3": false,
              "DinnerSession4": false
            },
            "Wed": {
              "Breakfast": false,
              "Lunch": false,
              "Dinner": false,
              "BreakfastSession1": false,
              "BreakfastSession2": false,
              "BreakfastSession3": false,
              "BreakfastSession4": false,
              "LunchSession1": false,
              "LunchSession2": false,
              "LunchSession3": false,
              "LunchSession4": false,
              "DinnerSession1": false,
              "DinnerSession2": false,
              "DinnerSession3": false,
              "DinnerSession4": false
            },
            "Thu": {
              "Breakfast": false,
              "Lunch": false,
              "Dinner": false,
              "BreakfastSession1": false,
              "BreakfastSession2": false,
              "BreakfastSession3": false,
              "BreakfastSession4": false,
              "LunchSession1": false,
              "LunchSession2": false,
              "LunchSession3": false,
              "LunchSession4": false,
              "DinnerSession1": false,
              "DinnerSession2": false,
              "DinnerSession3": false,
              "DinnerSession4": false
            },
            "Fri": {
              "Breakfast": false,
              "Lunch": false,
              "Dinner": false,
              "BreakfastSession1": false,
              "BreakfastSession2": false,
              "BreakfastSession3": false,
              "BreakfastSession4": false,
              "LunchSession1": false,
              "LunchSession2": false,
              "LunchSession3": false,
              "LunchSession4": false,
              "DinnerSession1": false,
              "DinnerSession2": false,
              "DinnerSession3": false,
              "DinnerSession4": false
            },
            "Sat": {
              "Breakfast": false,
              "Lunch": false,
              "Dinner": false,
              "BreakfastSession1": false,
              "BreakfastSession2": false,
              "BreakfastSession3": false,
              "BreakfastSession4": false,
              "LunchSession1": false,
              "LunchSession2": false,
              "LunchSession3": false,
              "LunchSession4": false,
              "DinnerSession1": false,
              "DinnerSession2": false,
              "DinnerSession3": false,
              "DinnerSession4": false
            }
          },
          "fp_unit_sessions": {
            "Breakfast": {
              "Default": {},
              "Session1": {},
              "Session2": {},
              "Session3": {},
              "Session4": {}
            },
            "Lunch": {
              "Default": {},
              "Session1": {},
              "Session2": {},
              "Session3": {},
              "Session4": {}
            },
            "Dinner": {
              "Default": {},
              "Session1": {},
              "Session2": {},
              "Session3": {},
              "Session4": {}
            }
          }
          ,
          "std_itm_availability": false
        };
        await _menuRepository.addSection(req);

        List<Mymenu> newMenu = [];

        LiveMenuVariables.foodCategories = {};
        MenuEditorVariables.menuFoodCategories = {};

        newMenu = await _menuRepository.fetchData();

        for (var item in newMenu) {
          Map<String, dynamic> oneItem = {
            '_id': item.id,
            'name': item.name,
            'disName': item.dname,
            'availability': item.availability,
            'category': item.category,
            'totalCount': item.totalCount,
            'normalPrice': item.normalPrice,
            'packagePrice': item.packagePrice,
            'preorderPrice': item.preorderPrice,
            'subTag': item.subTag,
            'tag': item.itemTag,
            'priceRange': item.priceRange,
            'itemType': item.itemType,
            'itemSubType': item.subTag,
            'comboType': item.comboType,
            'rawSource': item.rawSource,
            'subCategory': item.subCategory,
            'sunBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession1,
            'sunBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession2,
            'sunBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession3,
            'sunBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession4,
            'sunLunchSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession1,
            'sunLunchSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession2,
            'sunLunchSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession3,
            'sunLunchSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession4,
            'sunDinnerSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession1,
            'sunDinnerSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession2,
            'sunDinnerSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession3,
            'sunDinnerSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession4,
            'monBreakfastSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession1,
            'monBreakfastSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession2,
            'monBreakfastSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession3,
            'monBreakfastSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession4,
            'monLunchSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession1,
            'monLunchSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession2,
            'monLunchSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession3,
            'monLunchSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession4,
            'monDinnerSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession1,
            'monDinnerSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession2,
            'monDinnerSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession3,
            'monDinnerSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession4,
            'tueBreakfastSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession1,
            'tueBreakfastSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession2,
            'tueBreakfastSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession3,
            'tueBreakfastSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession4,
            'tueLunchSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession1,
            'tueLunchSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession2,
            'tueLunchSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession3,
            'tueLunchSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession4,
            'tueDinnerSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession1,
            'tueDinnerSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession2,
            'tueDinnerSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession3,
            'tueDinnerSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession4,
            'wedBreakfastSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession1,
            'wedBreakfastSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession2,
            'wedBreakfastSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession3,
            'wedBreakfastSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession4,
            'wedLunchSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession1,
            'wedLunchSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession2,
            'wedLunchSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession3,
            'wedLunchSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession4,
            'wedDinnerSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession1,
            'wedDinnerSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession2,
            'wedDinnerSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession3,
            'wedDinnerSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession4,
            'thuBreakfastSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession1,
            'thuBreakfastSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession2,
            'thuBreakfastSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession3,
            'thuBreakfastSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession4,
            'thuLunchSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession1,
            'thuLunchSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession2,
            'thuLunchSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession3,
            'thuLunchSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession4,
            'thuDinnerSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession1,
            'thuDinnerSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession2,
            'thuDinnerSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession3,
            'thuDinnerSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession4,
            'friBreakfastSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession1,
            'friBreakfastSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession2,
            'friBreakfastSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession3,
            'friBreakfastSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession4,
            'friLunchSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession1,
            'friLunchSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession2,
            'friLunchSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession3,
            'friLunchSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession4,
            'friDinnerSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession1,
            'friDinnerSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession2,
            'friDinnerSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession3,
            'friDinnerSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession4,
            'satBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession1,
            'satBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession2,
            'satBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession3,
            'satBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession4,
            'satLunchSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession1,
            'satLunchSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession2,
            'satLunchSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession3,
            'satLunchSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession4,
            'satDinnerSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession1,
            'satDinnerSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession2,
            'satDinnerSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession3,
            'satDinnerSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession4,

            'breakfast': item.fpUnitSessions.breakfast.defaultSession.enabled,
            'lunch': item.fpUnitSessions.lunch.defaultSession.enabled,
            'dinner': item.fpUnitSessions.dinner.defaultSession.enabled,
            'breakfastCount': item.fpUnitSessions.breakfast.defaultSession
                .availableCount,
            'lunchCount': item.fpUnitSessions.lunch.defaultSession
                .availableCount,
            'dinnerCount': item.fpUnitSessions.dinner.defaultSession
                .availableCount,
            'breakfastSession1Count': item.fpUnitSessions.breakfast.session1
                .availableCount,
            'breakfastSession2Count': item.fpUnitSessions.breakfast.session2
                .availableCount,
            'breakfastSession3Count': item.fpUnitSessions.breakfast.session3
                .availableCount,
            'breakfastSession4Count': item.fpUnitSessions.breakfast.session4
                .availableCount,
            'lunchSession1Count': item.fpUnitSessions.lunch.session1
                .availableCount,
            'lunchSession2Count': item.fpUnitSessions.lunch.session2
                .availableCount,
            'lunchSession3Count': item.fpUnitSessions.lunch.session3
                .availableCount,
            'lunchSession4Count': item.fpUnitSessions.lunch.session4
                .availableCount,
            'dinnerSession1Count': item.fpUnitSessions.dinner.session1
                .availableCount,
            'dinnerSession2Count': item.fpUnitSessions.dinner.session2
                .availableCount,
            'dinnerSession3Count': item.fpUnitSessions.dinner.session3
                .availableCount,
            'dinnerSession4Count': item.fpUnitSessions.dinner.session4
                .availableCount,
          };


          if (LiveMenuVariables.foodCategories[item.itemTag] == null) {
            LiveMenuVariables.foodCategories[item.itemTag] = [];
            MenuEditorVariables.menuFoodCategories[item.itemTag] = [];
          }

          LiveMenuVariables.foodCategories[item.itemTag]!.add(oneItem);

        }

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

        Map<String, dynamic> req = {
          "std_itm_name": "",
          "std_itm_dispname": event.itemName,
          "std_itm_subTag": "",
          "std_itm_priceRange": "",
          "std_itm_itemType": "",
          "std_itm_itemSubType": "",
          "std_itm_comboType": "",
          "std_itm_rawSource": "",
          "std_itm_category": "",
          "std_itm_cuisine": "",
          "std_itm_regional": "",
          "std_itm_subCategory": "",
          "std_itm_normalPrice": 0.0,
          "std_itm_packagePrice": 0.0,
          "std_itm_preorderPrice": 0.0,
          "std_itm_tag": event.tagName,
          "fp_unit_avail_days_and_meals": {
            "Sun": {
              "Breakfast": false,
              "Lunch": false,
              "Dinner": false,
              "BreakfastSession1": false,
              "BreakfastSession2": false,
              "BreakfastSession3": false,
              "BreakfastSession4": false,
              "LunchSession1": false,
              "LunchSession2": false,
              "LunchSession3": false,
              "LunchSession4": false,
              "DinnerSession1": false,
              "DinnerSession2": false,
              "DinnerSession3": false,
              "DinnerSession4": false
            },
            "Mon": {
              "Breakfast": false,
              "Lunch": false,
              "Dinner": false,
              "BreakfastSession1": false,
              "BreakfastSession2": false,
              "BreakfastSession3": false,
              "BreakfastSession4": false,
              "LunchSession1": false,
              "LunchSession2": false,
              "LunchSession3": false,
              "LunchSession4": false,
              "DinnerSession1": false,
              "DinnerSession2": false,
              "DinnerSession3": false,
              "DinnerSession4": false
            },
            "Tue": {
              "Breakfast": false,
              "Lunch": false,
              "Dinner": false,
              "BreakfastSession1": false,
              "BreakfastSession2": false,
              "BreakfastSession3": false,
              "BreakfastSession4": false,
              "LunchSession1": false,
              "LunchSession2": false,
              "LunchSession3": false,
              "LunchSession4": false,
              "DinnerSession1": false,
              "DinnerSession2": false,
              "DinnerSession3": false,
              "DinnerSession4": false
            },
            "Wed": {
              "Breakfast": false,
              "Lunch": false,
              "Dinner": false,
              "BreakfastSession1": false,
              "BreakfastSession2": false,
              "BreakfastSession3": false,
              "BreakfastSession4": false,
              "LunchSession1": false,
              "LunchSession2": false,
              "LunchSession3": false,
              "LunchSession4": false,
              "DinnerSession1": false,
              "DinnerSession2": false,
              "DinnerSession3": false,
              "DinnerSession4": false
            },
            "Thu": {
              "Breakfast": false,
              "Lunch": false,
              "Dinner": false,
              "BreakfastSession1": false,
              "BreakfastSession2": false,
              "BreakfastSession3": false,
              "BreakfastSession4": false,
              "LunchSession1": false,
              "LunchSession2": false,
              "LunchSession3": false,
              "LunchSession4": false,
              "DinnerSession1": false,
              "DinnerSession2": false,
              "DinnerSession3": false,
              "DinnerSession4": false
            },
            "Fri": {
              "Breakfast": false,
              "Lunch": false,
              "Dinner": false,
              "BreakfastSession1": false,
              "BreakfastSession2": false,
              "BreakfastSession3": false,
              "BreakfastSession4": false,
              "LunchSession1": false,
              "LunchSession2": false,
              "LunchSession3": false,
              "LunchSession4": false,
              "DinnerSession1": false,
              "DinnerSession2": false,
              "DinnerSession3": false,
              "DinnerSession4": false
            },
            "Sat": {
              "Breakfast": false,
              "Lunch": false,
              "Dinner": false,
              "BreakfastSession1": false,
              "BreakfastSession2": false,
              "BreakfastSession3": false,
              "BreakfastSession4": false,
              "LunchSession1": false,
              "LunchSession2": false,
              "LunchSession3": false,
              "LunchSession4": false,
              "DinnerSession1": false,
              "DinnerSession2": false,
              "DinnerSession3": false,
              "DinnerSession4": false
            }
          },
          "fp_unit_sessions": {
            "Breakfast": {
              "Default": {},
              "Session1": {},
              "Session2": {},
              "Session3": {},
              "Session4": {}
            },
            "Lunch": {
              "Default": {},
              "Session1": {},
              "Session2": {},
              "Session3": {},
              "Session4": {}
            },
            "Dinner": {
              "Default": {},
              "Session1": {},
              "Session2": {},
              "Session3": {},
              "Session4": {}
            }
          }
          ,
          "std_itm_availability": false
        };

        await _menuRepository.updateSection(req, event.id);

        List<Mymenu> newMenu = [];

        LiveMenuVariables.foodCategories = {};
        MenuEditorVariables.menuFoodCategories = {};

        newMenu = await _menuRepository.fetchData();

        for (var item in newMenu) {
          Map<String, dynamic> oneItem = {
            '_id': item.id,
            'name': item.name,
            'disName': item.dname,
            'availability': item.availability,
            'category': item.category,
            'totalCount': item.totalCount,
            'normalPrice': item.normalPrice,
            'packagePrice': item.packagePrice,
            'preorderPrice': item.preorderPrice,
            'subTag': item.subTag,
            'tag': item.itemTag,
            'priceRange': item.priceRange,
            'itemType': item.itemType,
            'itemSubType': item.subTag,
            'comboType': item.comboType,
            'rawSource': item.rawSource,
            'subCategory': item.subCategory,
            'sunBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession1,
            'sunBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession2,
            'sunBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession3,
            'sunBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession4,
            'sunLunchSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession1,
            'sunLunchSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession2,
            'sunLunchSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession3,
            'sunLunchSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession4,
            'sunDinnerSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession1,
            'sunDinnerSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession2,
            'sunDinnerSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession3,
            'sunDinnerSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession4,
            'monBreakfastSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession1,
            'monBreakfastSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession2,
            'monBreakfastSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession3,
            'monBreakfastSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession4,
            'monLunchSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession1,
            'monLunchSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession2,
            'monLunchSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession3,
            'monLunchSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession4,
            'monDinnerSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession1,
            'monDinnerSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession2,
            'monDinnerSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession3,
            'monDinnerSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession4,
            'tueBreakfastSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession1,
            'tueBreakfastSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession2,
            'tueBreakfastSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession3,
            'tueBreakfastSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession4,
            'tueLunchSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession1,
            'tueLunchSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession2,
            'tueLunchSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession3,
            'tueLunchSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession4,
            'tueDinnerSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession1,
            'tueDinnerSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession2,
            'tueDinnerSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession3,
            'tueDinnerSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession4,
            'wedBreakfastSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession1,
            'wedBreakfastSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession2,
            'wedBreakfastSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession3,
            'wedBreakfastSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession4,
            'wedLunchSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession1,
            'wedLunchSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession2,
            'wedLunchSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession3,
            'wedLunchSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession4,
            'wedDinnerSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession1,
            'wedDinnerSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession2,
            'wedDinnerSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession3,
            'wedDinnerSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession4,
            'thuBreakfastSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession1,
            'thuBreakfastSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession2,
            'thuBreakfastSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession3,
            'thuBreakfastSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession4,
            'thuLunchSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession1,
            'thuLunchSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession2,
            'thuLunchSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession3,
            'thuLunchSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession4,
            'thuDinnerSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession1,
            'thuDinnerSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession2,
            'thuDinnerSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession3,
            'thuDinnerSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession4,
            'friBreakfastSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession1,
            'friBreakfastSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession2,
            'friBreakfastSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession3,
            'friBreakfastSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession4,
            'friLunchSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession1,
            'friLunchSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession2,
            'friLunchSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession3,
            'friLunchSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession4,
            'friDinnerSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession1,
            'friDinnerSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession2,
            'friDinnerSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession3,
            'friDinnerSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession4,
            'satBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession1,
            'satBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession2,
            'satBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession3,
            'satBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession4,
            'satLunchSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession1,
            'satLunchSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession2,
            'satLunchSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession3,
            'satLunchSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession4,
            'satDinnerSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession1,
            'satDinnerSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession2,
            'satDinnerSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession3,
            'satDinnerSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession4,

            'breakfast': item.fpUnitSessions.breakfast.defaultSession.enabled,
            'lunch': item.fpUnitSessions.lunch.defaultSession.enabled,
            'dinner': item.fpUnitSessions.dinner.defaultSession.enabled,
            'breakfastCount': item.fpUnitSessions.breakfast.defaultSession
                .availableCount,
            'lunchCount': item.fpUnitSessions.lunch.defaultSession
                .availableCount,
            'dinnerCount': item.fpUnitSessions.dinner.defaultSession
                .availableCount,
            'breakfastSession1Count': item.fpUnitSessions.breakfast.session1
                .availableCount,
            'breakfastSession2Count': item.fpUnitSessions.breakfast.session2
                .availableCount,
            'breakfastSession3Count': item.fpUnitSessions.breakfast.session3
                .availableCount,
            'breakfastSession4Count': item.fpUnitSessions.breakfast.session4
                .availableCount,
            'lunchSession1Count': item.fpUnitSessions.lunch.session1
                .availableCount,
            'lunchSession2Count': item.fpUnitSessions.lunch.session2
                .availableCount,
            'lunchSession3Count': item.fpUnitSessions.lunch.session3
                .availableCount,
            'lunchSession4Count': item.fpUnitSessions.lunch.session4
                .availableCount,
            'dinnerSession1Count': item.fpUnitSessions.dinner.session1
                .availableCount,
            'dinnerSession2Count': item.fpUnitSessions.dinner.session2
                .availableCount,
            'dinnerSession3Count': item.fpUnitSessions.dinner.session3
                .availableCount,
            'dinnerSession4Count': item.fpUnitSessions.dinner.session4
                .availableCount,
          };


          if (LiveMenuVariables.foodCategories[item.itemTag] == null) {
            LiveMenuVariables.foodCategories[item.itemTag] = [];
            MenuEditorVariables.menuFoodCategories[item.itemTag] = [];
          }

          LiveMenuVariables.foodCategories[item.itemTag]!.add(oneItem);

        }


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

        print(event.available);
        MenuEditorVariables.selectItem = event.item;
        Map<String, dynamic> req = {
          "std_itm_availability": event.available
        };

        await _menuRepository.updateSection(req, event.id);

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
        List<Mymenu> menu = [];
       await _menuRepository.deleteMenuItem(event.id);List<Mymenu> newMenu = [];

        LiveMenuVariables.foodCategories = {};
        MenuEditorVariables.menuFoodCategories = {};

        newMenu = await _menuRepository.fetchData();

        for (var item in newMenu) {
          Map<String, dynamic> oneItem = {
            '_id': item.id,
            'name': item.name,
            'disName': item.dname,
            'availability': item.availability,
            'category': item.category,
            'totalCount': item.totalCount,
            'normalPrice': item.normalPrice,
            'packagePrice': item.packagePrice,
            'preorderPrice': item.preorderPrice,
            'subTag': item.subTag,
            'tag': item.itemTag,
            'priceRange': item.priceRange,
            'itemType': item.itemType,
            'itemSubType': item.subTag,
            'comboType': item.comboType,
            'rawSource': item.rawSource,
            'subCategory': item.subCategory,
            'sunBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession1,
            'sunBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession2,
            'sunBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession3,
            'sunBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession4,
            'sunLunchSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession1,
            'sunLunchSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession2,
            'sunLunchSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession3,
            'sunLunchSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession4,
            'sunDinnerSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession1,
            'sunDinnerSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession2,
            'sunDinnerSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession3,
            'sunDinnerSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession4,
            'monBreakfastSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession1,
            'monBreakfastSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession2,
            'monBreakfastSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession3,
            'monBreakfastSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession4,
            'monLunchSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession1,
            'monLunchSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession2,
            'monLunchSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession3,
            'monLunchSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession4,
            'monDinnerSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession1,
            'monDinnerSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession2,
            'monDinnerSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession3,
            'monDinnerSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession4,
            'tueBreakfastSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession1,
            'tueBreakfastSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession2,
            'tueBreakfastSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession3,
            'tueBreakfastSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession4,
            'tueLunchSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession1,
            'tueLunchSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession2,
            'tueLunchSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession3,
            'tueLunchSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession4,
            'tueDinnerSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession1,
            'tueDinnerSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession2,
            'tueDinnerSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession3,
            'tueDinnerSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession4,
            'wedBreakfastSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession1,
            'wedBreakfastSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession2,
            'wedBreakfastSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession3,
            'wedBreakfastSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession4,
            'wedLunchSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession1,
            'wedLunchSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession2,
            'wedLunchSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession3,
            'wedLunchSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession4,
            'wedDinnerSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession1,
            'wedDinnerSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession2,
            'wedDinnerSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession3,
            'wedDinnerSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession4,
            'thuBreakfastSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession1,
            'thuBreakfastSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession2,
            'thuBreakfastSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession3,
            'thuBreakfastSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession4,
            'thuLunchSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession1,
            'thuLunchSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession2,
            'thuLunchSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession3,
            'thuLunchSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession4,
            'thuDinnerSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession1,
            'thuDinnerSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession2,
            'thuDinnerSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession3,
            'thuDinnerSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession4,
            'friBreakfastSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession1,
            'friBreakfastSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession2,
            'friBreakfastSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession3,
            'friBreakfastSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession4,
            'friLunchSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession1,
            'friLunchSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession2,
            'friLunchSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession3,
            'friLunchSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession4,
            'friDinnerSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession1,
            'friDinnerSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession2,
            'friDinnerSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession3,
            'friDinnerSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession4,
            'satBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession1,
            'satBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession2,
            'satBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession3,
            'satBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession4,
            'satLunchSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession1,
            'satLunchSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession2,
            'satLunchSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession3,
            'satLunchSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession4,
            'satDinnerSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession1,
            'satDinnerSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession2,
            'satDinnerSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession3,
            'satDinnerSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession4,

            'breakfast': item.fpUnitSessions.breakfast.defaultSession.enabled,
            'lunch': item.fpUnitSessions.lunch.defaultSession.enabled,
            'dinner': item.fpUnitSessions.dinner.defaultSession.enabled,
            'breakfastCount': item.fpUnitSessions.breakfast.defaultSession
                .availableCount,
            'lunchCount': item.fpUnitSessions.lunch.defaultSession
                .availableCount,
            'dinnerCount': item.fpUnitSessions.dinner.defaultSession
                .availableCount,
            'breakfastSession1Count': item.fpUnitSessions.breakfast.session1
                .availableCount,
            'breakfastSession2Count': item.fpUnitSessions.breakfast.session2
                .availableCount,
            'breakfastSession3Count': item.fpUnitSessions.breakfast.session3
                .availableCount,
            'breakfastSession4Count': item.fpUnitSessions.breakfast.session4
                .availableCount,
            'lunchSession1Count': item.fpUnitSessions.lunch.session1
                .availableCount,
            'lunchSession2Count': item.fpUnitSessions.lunch.session2
                .availableCount,
            'lunchSession3Count': item.fpUnitSessions.lunch.session3
                .availableCount,
            'lunchSession4Count': item.fpUnitSessions.lunch.session4
                .availableCount,
            'dinnerSession1Count': item.fpUnitSessions.dinner.session1
                .availableCount,
            'dinnerSession2Count': item.fpUnitSessions.dinner.session2
                .availableCount,
            'dinnerSession3Count': item.fpUnitSessions.dinner.session3
                .availableCount,
            'dinnerSession4Count': item.fpUnitSessions.dinner.session4
                .availableCount,
          };


          if (LiveMenuVariables.foodCategories[item.itemTag] == null) {
            LiveMenuVariables.foodCategories[item.itemTag] = [];
            MenuEditorVariables.menuFoodCategories[item.itemTag] = [];
          }

          LiveMenuVariables.foodCategories[item.itemTag]!.add(oneItem);

        }



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

        Map<String,dynamic> req = {
          "std_itm_name": "",
          "std_itm_dispname": "sample",
          "std_itm_subTag": "",
          "std_itm_priceRange": "",
          "std_itm_itemType": "",
          "std_itm_itemSubType": "",
          "std_itm_comboType": "",
          "std_itm_rawSource": "",
          "std_itm_category": "",
          "std_itm_cuisine": "",
          "std_itm_regional": "",
          "std_itm_subCategory": "",
          "std_itm_normalPrice": 0.0,
          "std_itm_packagePrice": 0.0,
          "std_itm_preorderPrice": 0.0,
          "std_itm_tag" : event.tagName,
          "fp_unit_avail_days_and_meals": {
            "Sun": { "Breakfast": false, "Lunch": false, "Dinner": false, "BreakfastSession1": false, "BreakfastSession2": false, "BreakfastSession3": false, "BreakfastSession4": false, "LunchSession1": false, "LunchSession2": false, "LunchSession3": false, "LunchSession4": false, "DinnerSession1": false, "DinnerSession2": false, "DinnerSession3": false, "DinnerSession4": false },
            "Mon": { "Breakfast": false, "Lunch": false, "Dinner": false, "BreakfastSession1": false, "BreakfastSession2": false, "BreakfastSession3": false, "BreakfastSession4": false, "LunchSession1": false, "LunchSession2": false, "LunchSession3": false, "LunchSession4": false, "DinnerSession1": false, "DinnerSession2": false, "DinnerSession3": false, "DinnerSession4": false },
            "Tue": { "Breakfast": false, "Lunch": false, "Dinner": false, "BreakfastSession1": false, "BreakfastSession2": false, "BreakfastSession3": false, "BreakfastSession4": false, "LunchSession1": false, "LunchSession2": false, "LunchSession3": false, "LunchSession4": false, "DinnerSession1": false, "DinnerSession2": false, "DinnerSession3": false, "DinnerSession4": false },
            "Wed": { "Breakfast": false, "Lunch": false, "Dinner": false, "BreakfastSession1": false, "BreakfastSession2": false, "BreakfastSession3": false, "BreakfastSession4": false, "LunchSession1": false, "LunchSession2": false, "LunchSession3": false, "LunchSession4": false, "DinnerSession1": false, "DinnerSession2": false, "DinnerSession3": false, "DinnerSession4": false },
            "Thu": { "Breakfast": false, "Lunch": false, "Dinner": false, "BreakfastSession1": false, "BreakfastSession2": false, "BreakfastSession3": false, "BreakfastSession4": false, "LunchSession1": false, "LunchSession2": false, "LunchSession3": false, "LunchSession4": false, "DinnerSession1": false, "DinnerSession2": false, "DinnerSession3": false, "DinnerSession4": false },
            "Fri": { "Breakfast": false, "Lunch": false, "Dinner": false, "BreakfastSession1": false, "BreakfastSession2": false, "BreakfastSession3": false, "BreakfastSession4": false, "LunchSession1": false, "LunchSession2": false, "LunchSession3": false, "LunchSession4": false, "DinnerSession1": false, "DinnerSession2": false, "DinnerSession3": false, "DinnerSession4": false },
            "Sat": { "Breakfast": false, "Lunch": false, "Dinner": false, "BreakfastSession1": false, "BreakfastSession2": false, "BreakfastSession3": false, "BreakfastSession4": false, "LunchSession1": false, "LunchSession2": false, "LunchSession3": false, "LunchSession4": false, "DinnerSession1": false, "DinnerSession2": false, "DinnerSession3": false, "DinnerSession4": false }
          },
          "fp_unit_sessions": {
            "Breakfast": {
              "Default": {},
              "Session1": {},
              "Session2": {},
              "Session3": {},
              "Session4": {}
            },
            "Lunch": {
              "Default": {},
              "Session1": {},
              "Session2": {},
              "Session3": {},
              "Session4": {}
            },
            "Dinner": {
              "Default": {},
              "Session1": {},
              "Session2": {},
              "Session3": {},
              "Session4": {}
            }
          }
          ,
          "std_itm_availability": false
        };
        await _menuRepository.addSection(req);

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

        newMenu = await _menuRepository.fetchData();

        for (var item in newMenu) {
          Map<String, dynamic> oneItem = {
            '_id': item.id,
            'name': item.name,
            'disName': item.dname,
            'availability': item.availability,
            'category': item.category,
            'totalCount': item.totalCount,
            'normalPrice': item.normalPrice,
            'packagePrice': item.packagePrice,
            'preorderPrice': item.preorderPrice,
            'subTag': item.subTag,
            'tag': item.itemTag,
            'priceRange': item.priceRange,
            'itemType': item.itemType,
            'itemSubType': item.subTag,
            'comboType': item.comboType,
            'rawSource': item.rawSource,
            'subCategory': item.subCategory,
            'sunBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession1,
            'sunBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession2,
            'sunBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession3,
            'sunBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession4,
            'sunLunchSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession1,
            'sunLunchSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession2,
            'sunLunchSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession3,
            'sunLunchSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession4,
            'sunDinnerSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession1,
            'sunDinnerSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession2,
            'sunDinnerSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession3,
            'sunDinnerSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession4,
            'monBreakfastSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession1,
            'monBreakfastSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession2,
            'monBreakfastSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession3,
            'monBreakfastSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession4,
            'monLunchSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession1,
            'monLunchSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession2,
            'monLunchSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession3,
            'monLunchSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession4,
            'monDinnerSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession1,
            'monDinnerSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession2,
            'monDinnerSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession3,
            'monDinnerSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession4,
            'tueBreakfastSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession1,
            'tueBreakfastSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession2,
            'tueBreakfastSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession3,
            'tueBreakfastSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession4,
            'tueLunchSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession1,
            'tueLunchSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession2,
            'tueLunchSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession3,
            'tueLunchSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession4,
            'tueDinnerSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession1,
            'tueDinnerSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession2,
            'tueDinnerSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession3,
            'tueDinnerSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession4,
            'wedBreakfastSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession1,
            'wedBreakfastSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession2,
            'wedBreakfastSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession3,
            'wedBreakfastSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession4,
            'wedLunchSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession1,
            'wedLunchSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession2,
            'wedLunchSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession3,
            'wedLunchSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession4,
            'wedDinnerSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession1,
            'wedDinnerSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession2,
            'wedDinnerSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession3,
            'wedDinnerSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession4,
            'thuBreakfastSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession1,
            'thuBreakfastSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession2,
            'thuBreakfastSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession3,
            'thuBreakfastSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession4,
            'thuLunchSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession1,
            'thuLunchSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession2,
            'thuLunchSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession3,
            'thuLunchSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession4,
            'thuDinnerSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession1,
            'thuDinnerSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession2,
            'thuDinnerSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession3,
            'thuDinnerSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession4,
            'friBreakfastSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession1,
            'friBreakfastSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession2,
            'friBreakfastSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession3,
            'friBreakfastSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession4,
            'friLunchSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession1,
            'friLunchSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession2,
            'friLunchSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession3,
            'friLunchSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession4,
            'friDinnerSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession1,
            'friDinnerSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession2,
            'friDinnerSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession3,
            'friDinnerSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession4,
            'satBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession1,
            'satBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession2,
            'satBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession3,
            'satBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession4,
            'satLunchSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession1,
            'satLunchSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession2,
            'satLunchSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession3,
            'satLunchSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession4,
            'satDinnerSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession1,
            'satDinnerSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession2,
            'satDinnerSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession3,
            'satDinnerSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession4,

            'breakfast': item.fpUnitSessions.breakfast.defaultSession.enabled,
            'lunch': item.fpUnitSessions.lunch.defaultSession.enabled,
            'dinner': item.fpUnitSessions.dinner.defaultSession.enabled,
            'breakfastCount': item.fpUnitSessions.breakfast.defaultSession
                .availableCount,
            'lunchCount': item.fpUnitSessions.lunch.defaultSession
                .availableCount,
            'dinnerCount': item.fpUnitSessions.dinner.defaultSession
                .availableCount,
            'breakfastSession1Count': item.fpUnitSessions.breakfast.session1
                .availableCount,
            'breakfastSession2Count': item.fpUnitSessions.breakfast.session2
                .availableCount,
            'breakfastSession3Count': item.fpUnitSessions.breakfast.session3
                .availableCount,
            'breakfastSession4Count': item.fpUnitSessions.breakfast.session4
                .availableCount,
            'lunchSession1Count': item.fpUnitSessions.lunch.session1
                .availableCount,
            'lunchSession2Count': item.fpUnitSessions.lunch.session2
                .availableCount,
            'lunchSession3Count': item.fpUnitSessions.lunch.session3
                .availableCount,
            'lunchSession4Count': item.fpUnitSessions.lunch.session4
                .availableCount,
            'dinnerSession1Count': item.fpUnitSessions.dinner.session1
                .availableCount,
            'dinnerSession2Count': item.fpUnitSessions.dinner.session2
                .availableCount,
            'dinnerSession3Count': item.fpUnitSessions.dinner.session3
                .availableCount,
            'dinnerSession4Count': item.fpUnitSessions.dinner.session4
                .availableCount,
          };


          if (LiveMenuVariables.foodCategories[item.itemTag] == null) {
            LiveMenuVariables.foodCategories[item.itemTag] = [];
            MenuEditorVariables.menuFoodCategories[item.itemTag] = [];
          }

          LiveMenuVariables.foodCategories[item.itemTag]!.add(oneItem);


          //
          //   if(fetchFirstItem)
          //   {
          //     LiveMenuVariables.selectItem = oneItem;
          //     MenuEditorVariables.selectItem = oneItem;
          //     MenuEditorVariables.selectedCategories.add(oneItem['tag']);
          //     MenuEditorVariables.selectedItem = oneItem['disName'];
          //     LiveMenuVariables.selectedCategories.add(oneItem['tag']);
          //     // MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S1'] = !oneItem['breakfast'];
          //     fetchFirstItem=false;
          //   }
          // }
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

    on<UpdateSectionAvailability>((event, emit) async {
      emit(MenuLoadingState());
      try {

        print(event.availability);
        List<Mymenu> newMenu = [];
        LiveMenuVariables.foodCategories = {};
        MenuEditorVariables.menuFoodCategories = {};
        await _menuRepository.updateByTag(event.tagName, event.availability);

        newMenu = await _menuRepository.fetchData();

        for (var item in newMenu) {
          Map<String, dynamic> oneItem = {
            '_id': item.id,
            'name': item.name,
            'disName': item.dname,
            'availability': item.availability,
            'category': item.category,
            'totalCount': item.totalCount,
            'normalPrice': item.normalPrice,
            'packagePrice': item.packagePrice,
            'preorderPrice': item.preorderPrice,
            'subTag': item.subTag,
            'tag': item.itemTag,
            'priceRange': item.priceRange,
            'itemType': item.itemType,
            'itemSubType': item.subTag,
            'comboType': item.comboType,
            'rawSource': item.rawSource,
            'subCategory': item.subCategory,
            'sunBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession1,
            'sunBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession2,
            'sunBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession3,
            'sunBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession4,
            'sunLunchSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession1,
            'sunLunchSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession2,
            'sunLunchSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession3,
            'sunLunchSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession4,
            'sunDinnerSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession1,
            'sunDinnerSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession2,
            'sunDinnerSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession3,
            'sunDinnerSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession4,
            'monBreakfastSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession1,
            'monBreakfastSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession2,
            'monBreakfastSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession3,
            'monBreakfastSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession4,
            'monLunchSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession1,
            'monLunchSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession2,
            'monLunchSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession3,
            'monLunchSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession4,
            'monDinnerSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession1,
            'monDinnerSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession2,
            'monDinnerSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession3,
            'monDinnerSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession4,
            'tueBreakfastSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession1,
            'tueBreakfastSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession2,
            'tueBreakfastSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession3,
            'tueBreakfastSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession4,
            'tueLunchSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession1,
            'tueLunchSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession2,
            'tueLunchSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession3,
            'tueLunchSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession4,
            'tueDinnerSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession1,
            'tueDinnerSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession2,
            'tueDinnerSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession3,
            'tueDinnerSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession4,
            'wedBreakfastSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession1,
            'wedBreakfastSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession2,
            'wedBreakfastSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession3,
            'wedBreakfastSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession4,
            'wedLunchSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession1,
            'wedLunchSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession2,
            'wedLunchSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession3,
            'wedLunchSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession4,
            'wedDinnerSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession1,
            'wedDinnerSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession2,
            'wedDinnerSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession3,
            'wedDinnerSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession4,
            'thuBreakfastSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession1,
            'thuBreakfastSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession2,
            'thuBreakfastSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession3,
            'thuBreakfastSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession4,
            'thuLunchSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession1,
            'thuLunchSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession2,
            'thuLunchSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession3,
            'thuLunchSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession4,
            'thuDinnerSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession1,
            'thuDinnerSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession2,
            'thuDinnerSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession3,
            'thuDinnerSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession4,
            'friBreakfastSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession1,
            'friBreakfastSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession2,
            'friBreakfastSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession3,
            'friBreakfastSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession4,
            'friLunchSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession1,
            'friLunchSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession2,
            'friLunchSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession3,
            'friLunchSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession4,
            'friDinnerSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession1,
            'friDinnerSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession2,
            'friDinnerSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession3,
            'friDinnerSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession4,
            'satBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession1,
            'satBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession2,
            'satBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession3,
            'satBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession4,
            'satLunchSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession1,
            'satLunchSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession2,
            'satLunchSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession3,
            'satLunchSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession4,
            'satDinnerSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession1,
            'satDinnerSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession2,
            'satDinnerSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession3,
            'satDinnerSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession4,

            'breakfast': item.fpUnitSessions.breakfast.defaultSession.enabled,
            'lunch': item.fpUnitSessions.lunch.defaultSession.enabled,
            'dinner': item.fpUnitSessions.dinner.defaultSession.enabled,
            'breakfastCount': item.fpUnitSessions.breakfast.defaultSession
                .availableCount,
            'lunchCount': item.fpUnitSessions.lunch.defaultSession
                .availableCount,
            'dinnerCount': item.fpUnitSessions.dinner.defaultSession
                .availableCount,
            'breakfastSession1Count': item.fpUnitSessions.breakfast.session1
                .availableCount,
            'breakfastSession2Count': item.fpUnitSessions.breakfast.session2
                .availableCount,
            'breakfastSession3Count': item.fpUnitSessions.breakfast.session3
                .availableCount,
            'breakfastSession4Count': item.fpUnitSessions.breakfast.session4
                .availableCount,
            'lunchSession1Count': item.fpUnitSessions.lunch.session1
                .availableCount,
            'lunchSession2Count': item.fpUnitSessions.lunch.session2
                .availableCount,
            'lunchSession3Count': item.fpUnitSessions.lunch.session3
                .availableCount,
            'lunchSession4Count': item.fpUnitSessions.lunch.session4
                .availableCount,
            'dinnerSession1Count': item.fpUnitSessions.dinner.session1
                .availableCount,
            'dinnerSession2Count': item.fpUnitSessions.dinner.session2
                .availableCount,
            'dinnerSession3Count': item.fpUnitSessions.dinner.session3
                .availableCount,
            'dinnerSession4Count': item.fpUnitSessions.dinner.session4
                .availableCount,
          };


          if (LiveMenuVariables.foodCategories[item.itemTag] == null) {
            LiveMenuVariables.foodCategories[item.itemTag] = [];
            MenuEditorVariables.menuFoodCategories[item.itemTag] = [];
          }

          LiveMenuVariables.foodCategories[item.itemTag]!.add(oneItem);


          //
          //   if(fetchFirstItem)
          //   {
          //     LiveMenuVariables.selectItem = oneItem;
          //     MenuEditorVariables.selectItem = oneItem;
          //     MenuEditorVariables.selectedCategories.add(oneItem['tag']);
          //     MenuEditorVariables.selectedItem = oneItem['disName'];
          //     LiveMenuVariables.selectedCategories.add(oneItem['tag']);
          //     // MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S1'] = !oneItem['breakfast'];
          //     fetchFirstItem=false;
          //   }
          // }
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

    on<UpdateLiveMenuEvent>((event, emit) async {
      emit(MenuLoadingState());
      try {

        List<Mymenu> newMenu = [];
        LiveMenuVariables.foodCategories = {};
        MenuEditorVariables.menuFoodCategories = {};
        await _menuRepository.updateLiveMenu(event.id, event.requestBody);

        newMenu = await _menuRepository.fetchData();

        for (var item in newMenu) {
          Map<String, dynamic> oneItem = {
            '_id': item.id,
            'name': item.name,
            'disName': item.dname,
            'availability': item.availability,
            'category': item.category,
            'totalCount': item.totalCount,
            'normalPrice': item.normalPrice,
            'packagePrice': item.packagePrice,
            'preorderPrice': item.preorderPrice,
            'subTag': item.subTag,
            'tag': item.itemTag,
            'priceRange': item.priceRange,
            'itemType': item.itemType,
            'itemSubType': item.subTag,
            'comboType': item.comboType,
            'rawSource': item.rawSource,
            'subCategory': item.subCategory,
            'sunBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession1,
            'sunBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession2,
            'sunBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession3,
            'sunBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession4,
            'sunLunchSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession1,
            'sunLunchSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession2,
            'sunLunchSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession3,
            'sunLunchSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession4,
            'sunDinnerSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession1,
            'sunDinnerSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession2,
            'sunDinnerSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession3,
            'sunDinnerSession4': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession4,
            'monBreakfastSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession1,
            'monBreakfastSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession2,
            'monBreakfastSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession3,
            'monBreakfastSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession4,
            'monLunchSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession1,
            'monLunchSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession2,
            'monLunchSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession3,
            'monLunchSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession4,
            'monDinnerSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession1,
            'monDinnerSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession2,
            'monDinnerSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession3,
            'monDinnerSession4': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession4,
            'tueBreakfastSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession1,
            'tueBreakfastSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession2,
            'tueBreakfastSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession3,
            'tueBreakfastSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession4,
            'tueLunchSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession1,
            'tueLunchSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession2,
            'tueLunchSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession3,
            'tueLunchSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession4,
            'tueDinnerSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession1,
            'tueDinnerSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession2,
            'tueDinnerSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession3,
            'tueDinnerSession4': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession4,
            'wedBreakfastSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession1,
            'wedBreakfastSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession2,
            'wedBreakfastSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession3,
            'wedBreakfastSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession4,
            'wedLunchSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession1,
            'wedLunchSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession2,
            'wedLunchSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession3,
            'wedLunchSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession4,
            'wedDinnerSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession1,
            'wedDinnerSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession2,
            'wedDinnerSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession3,
            'wedDinnerSession4': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession4,
            'thuBreakfastSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession1,
            'thuBreakfastSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession2,
            'thuBreakfastSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession3,
            'thuBreakfastSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession4,
            'thuLunchSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession1,
            'thuLunchSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession2,
            'thuLunchSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession3,
            'thuLunchSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession4,
            'thuDinnerSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession1,
            'thuDinnerSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession2,
            'thuDinnerSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession3,
            'thuDinnerSession4': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession4,
            'friBreakfastSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession1,
            'friBreakfastSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession2,
            'friBreakfastSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession3,
            'friBreakfastSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession4,
            'friLunchSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession1,
            'friLunchSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession2,
            'friLunchSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession3,
            'friLunchSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession4,
            'friDinnerSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession1,
            'friDinnerSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession2,
            'friDinnerSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession3,
            'friDinnerSession4': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession4,
            'satBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession1,
            'satBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession2,
            'satBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession3,
            'satBreakfastSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession4,
            'satLunchSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession1,
            'satLunchSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession2,
            'satLunchSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession3,
            'satLunchSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession4,
            'satDinnerSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession1,
            'satDinnerSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession2,
            'satDinnerSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession3,
            'satDinnerSession4': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession4,

            'breakfast': item.fpUnitSessions.breakfast.defaultSession.enabled,
            'lunch': item.fpUnitSessions.lunch.defaultSession.enabled,
            'dinner': item.fpUnitSessions.dinner.defaultSession.enabled,
            'breakfastCount': item.fpUnitSessions.breakfast.defaultSession
                .availableCount,
            'lunchCount': item.fpUnitSessions.lunch.defaultSession
                .availableCount,
            'dinnerCount': item.fpUnitSessions.dinner.defaultSession
                .availableCount,
            'breakfastSession1Count': item.fpUnitSessions.breakfast.session1
                .availableCount,
            'breakfastSession2Count': item.fpUnitSessions.breakfast.session2
                .availableCount,
            'breakfastSession3Count': item.fpUnitSessions.breakfast.session3
                .availableCount,
            'breakfastSession4Count': item.fpUnitSessions.breakfast.session4
                .availableCount,
            'lunchSession1Count': item.fpUnitSessions.lunch.session1
                .availableCount,
            'lunchSession2Count': item.fpUnitSessions.lunch.session2
                .availableCount,
            'lunchSession3Count': item.fpUnitSessions.lunch.session3
                .availableCount,
            'lunchSession4Count': item.fpUnitSessions.lunch.session4
                .availableCount,
            'dinnerSession1Count': item.fpUnitSessions.dinner.session1
                .availableCount,
            'dinnerSession2Count': item.fpUnitSessions.dinner.session2
                .availableCount,
            'dinnerSession3Count': item.fpUnitSessions.dinner.session3
                .availableCount,
            'dinnerSession4Count': item.fpUnitSessions.dinner.session4
                .availableCount,
          };


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
           }
          // LiveMenuVariables.selectedCategories.add(oneItem['tag']);
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

  }


}