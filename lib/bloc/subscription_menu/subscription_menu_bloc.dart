import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/subscription_menu/subscription_menu_event.dart';
import 'package:partner_admin_portal/bloc/subscription_menu/subscription_menu_state.dart';

import '../../constants/live_menu_constants/live_menu_variables.dart';
import '../../constants/menu_editor_constants/menu_editor_variables.dart';
import '../../models/restaurant_menu.dart';
import '../../repository/menu_services.dart';

class SubscriptionMenuBloc extends Bloc<SubscriptionMenuEvent,SubscriptionMenuState>{
  final MenuService _menuRepository;

  SubscriptionMenuBloc(this._menuRepository) : super(SubscriptionMenuLoadingState()) {

    on<LoadSubscriptionEvent>((event, emit) async {
      emit(SubscriptionMenuLoadingState());
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
        LiveMenuVariables.subscriptionCategories = {};
        // MenuEditorVariables.menuFoodCategories = {};
        //
        // Set<String> tags = {};
        //
        // Set<String> uniqueRegionalItems = {};
        //
        // Set<String> uniqueCusineItems = {};

        for (var item in menu) {
          Map<String, dynamic> oneItem = {
            '_id': item.id,
            'name': item.name,
            'disName': item.dname,
            'availability': item.availability,
            'category': item.category,
            'normalPrice': item.normalPrice,
            'packagePrice': item.packagePrice,
            'preorderPrice': item.preorderPrice,
            'normalFinalPrice': item.normalFinalPrice,
            'preOrderFinalPrice': item.preorderFinalPrice,
            'tag': item.itemTag,
            'regional': item.regional,
            'cuisine': item.cuisine,
            'priceRange': item.priceRange,
            'itemType': item.itemType,
            'comboType': item.comboType,
            'rawSource': item.rawSource,
            'subCategory': item.subCategory,
            'sunBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession1,
            'sunBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession2,
            'sunBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .breakfastSession3,

            'sunLunchSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession1,
            'sunLunchSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession2,
            'sunLunchSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .lunchSession3,

            'sunDinnerSession1': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession1,
            'sunDinnerSession2': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession2,
            'sunDinnerSession3': item.fpUnitAvailDaysAndMeals['Sun']!
                .dinnerSession3,

            'monBreakfastSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession1,
            'monBreakfastSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession2,
            'monBreakfastSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .breakfastSession3,

            'monLunchSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession1,
            'monLunchSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession2,
            'monLunchSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .lunchSession3,

            'monDinnerSession1': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession1,
            'monDinnerSession2': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession2,
            'monDinnerSession3': item.fpUnitAvailDaysAndMeals['Mon']!
                .dinnerSession3,

            'tueBreakfastSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession1,
            'tueBreakfastSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession2,
            'tueBreakfastSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .breakfastSession3,

            'tueLunchSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession1,
            'tueLunchSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession2,
            'tueLunchSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .lunchSession3,

            'tueDinnerSession1': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession1,
            'tueDinnerSession2': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession2,
            'tueDinnerSession3': item.fpUnitAvailDaysAndMeals['Tue']!
                .dinnerSession3,

            'wedBreakfastSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession1,
            'wedBreakfastSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession2,
            'wedBreakfastSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .breakfastSession3,

            'wedLunchSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession1,
            'wedLunchSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession2,
            'wedLunchSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .lunchSession3,

            'wedDinnerSession1': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession1,
            'wedDinnerSession2': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession2,
            'wedDinnerSession3': item.fpUnitAvailDaysAndMeals['Wed']!
                .dinnerSession3,

            'thuBreakfastSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession1,
            'thuBreakfastSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession2,
            'thuBreakfastSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .breakfastSession3,

            'thuLunchSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession1,
            'thuLunchSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession2,
            'thuLunchSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .lunchSession3,

            'thuDinnerSession1': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession1,
            'thuDinnerSession2': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession2,
            'thuDinnerSession3': item.fpUnitAvailDaysAndMeals['Thu']!
                .dinnerSession3,

            'friBreakfastSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession1,
            'friBreakfastSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession2,
            'friBreakfastSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .breakfastSession3,

            'friLunchSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession1,
            'friLunchSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession2,
            'friLunchSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .lunchSession3,

            'friDinnerSession1': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession1,
            'friDinnerSession2': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession2,
            'friDinnerSession3': item.fpUnitAvailDaysAndMeals['Fri']!
                .dinnerSession3,

            'satBreakfastSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession1,
            'satBreakfastSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession2,
            'satBreakfastSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .breakfastSession3,

            'satLunchSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession1,
            'satLunchSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession2,
            'satLunchSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .lunchSession3,

            'satDinnerSession1': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession1,
            'satDinnerSession2': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession2,
            'satDinnerSession3': item.fpUnitAvailDaysAndMeals['Sat']!
                .dinnerSession3,


            // 'breakfastSession1Count': item.fpUnitSessions.breakfast.session1
            //     .availableCount,
            // 'breakfastSession2Count': item.fpUnitSessions.breakfast.session2
            //     .availableCount,
            // 'breakfastSession3Count': item.fpUnitSessions.breakfast.session3
            //     .availableCount,
            // 'lunchSession1Count': item.fpUnitSessions.lunch.session1
            //     .availableCount,
            // 'lunchSession2Count': item.fpUnitSessions.lunch.session2
            //     .availableCount,
            // 'lunchSession3Count': item.fpUnitSessions.lunch.session3
            //     .availableCount,
            // 'dinnerSession1Count': item.fpUnitSessions.dinner.session1
            //     .availableCount,
            // 'dinnerSession2Count': item.fpUnitSessions.dinner.session2
            //     .availableCount,
            // 'dinnerSession3Count': item.fpUnitSessions.dinner.session3
            //     .availableCount,

          };

          // uniqueRegionalItems.add(item.regional);
          // uniqueCusineItems.add(item.cuisine);

          if (LiveMenuVariables.subscriptionCategories[item.priceRange] ==
              null) {
            LiveMenuVariables.subscriptionCategories[item.priceRange] = [];
            // MenuEditorVariables.menuFoodCategories[item.itemTag] = [];
          }

          if (LiveMenuVariables.subscriptionCategories[item.priceRange]!.length < 5) {
            LiveMenuVariables.subscriptionCategories[item.priceRange]!.add(oneItem);
          }


          // if((item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.breakfastSession1 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.breakfastSession2 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.breakfastSession3 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.breakfastSession4 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.lunchSession1
          //     || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.lunchSession2 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.lunchSession3 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.lunchSession4 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.dinnerSession1 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.dinnerSession2 || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.dinnerSession3
          //     || item.fpUnitAvailDaysAndMeals[dayProvider.selectedDay.substring(0,3)]!.dinnerSession4) && item.availability ) {
          //   MenuEditorVariables.menuFoodCategories[item.itemTag]!.add(oneItem);
          //   // liveMenu.add(item);
          // }
          MenuEditorVariables.selectedSubscriptionCategories.add(item.priceRange);

          if (fetchFirstItem) {
            // LiveMenuVariables.selectItem = oneItem;


            //  MenuEditorVariables.selectedItem = oneItem['disName'];
            // LiveMenuVariables.selectedCategories.add(oneItem['tag']);
            // MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S1'] = !oneItem['breakfast'];
            fetchFirstItem = false;
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

        emit(
            SubscriptionMenuLoadedState(menu, menu, LiveMenuVariables.subscriptionCategories, LiveMenuVariables.selectItem,
            MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectItem));
      } catch (e) {
        print("Menu Error ${e.toString()}");
        emit(SubscriptionMenuErrorState(e.toString()));
      }
    });

  }


}