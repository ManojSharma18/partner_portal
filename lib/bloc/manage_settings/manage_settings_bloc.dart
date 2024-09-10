import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_event.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_state.dart';
import 'package:partner_admin_portal/constants/manage_settings/manage_settings_variables.dart';
import 'package:partner_admin_portal/models/manage_setting.dart';

import '../../repository/manage_setting_service.dart';



class ManageSettingsBloc extends Bloc<ManageSettingEvent,ManageSettingState> {
  ManageSettingsBloc() : super(ManageSettingsLoadingState(),) {

    on<LoadManageSettingEvent>((event, emit) async {
      emit(ManageSettingsLoadingState());
      try {
        ManageSettingService manageSettingService = ManageSettingService();
        ManageSettingModel? manageSetting = await manageSettingService.fetchManageSetting('kaa1');

        if (manageSetting != null) {
          // Store the fetched data in variables
          ManageSettingsVariables.consumptionMode = manageSetting.consumptionMode;
          ManageSettingsVariables.mealData = manageSetting.fpUnitAvailDaysAndMeals;
          ManageSettingsVariables.mealTiming = manageSetting.fpUnitSessions;

          // Print or use the stored data as needed
          print('Consumption Mode: ${ManageSettingsVariables.consumptionMode}');
          print('FP Unit Availability: ${ManageSettingsVariables.mealData}');
          print('FP Unit Sessions: ${ManageSettingsVariables.mealTiming}');
        } else {
          print('Failed to fetch ManageSetting');
        }


        ManageSettingsVariables.restaurantModelController.text = "PREORDER";
        emit(ManageSettingsLoadedState(ManageSettingsVariables.restaurantModelController.text));
      } catch (e) {
        print("MEnu Editor error is ${e.toString()}");
        emit(ManageSettingsErrorState(e.toString()));
      }
    });

    on<ChangeRestaurantModelEvent>((event, emit) async {
      emit(ManageSettingsLoadingState());
      try {

        ManageSettingsVariables.restaurantModelController.text = event.model;
        print("restaurant model ${ManageSettingsVariables.restaurantModelController.text}");
        emit(ManageSettingsLoadedState(ManageSettingsVariables.restaurantModelController.text));
      } catch (e) {
        print("MEnu Editor error is ${e.toString()}");
        emit(ManageSettingsErrorState(e.toString()));
      }
    });

    on<SetMealSessionTimeEvent>((event,emit) async {
      emit(ManageSettingsLoadingState());
      try {

        print("It is working in bloc");
        emit(ManageSettingsLoadedState(ManageSettingsVariables.restaurantModelController.text));
      }
      catch (e) {

       emit(ManageSettingsErrorState(e.toString()));
      }
    });

    on<AddTimingsEvent>((event,emit) async {
      emit(ManageSettingsLoadingState());
      try {
        ManageSettingService manageSettingService = ManageSettingService();
        await manageSettingService.createManageSetting(event.manageSetting);
        emit(ManageSettingsLoadedState(ManageSettingsVariables.restaurantModelController.text));
      } catch (e) {
        print(e.toString());
        ManageSettingsErrorState(e.toString());
      }
    });

    on<UpdateTimingsEvent>((event,emit) async {
      emit(ManageSettingsLoadingState());
      try {
        ManageSettingService manageSettingService = ManageSettingService();
        await manageSettingService.updateManageSetting(event.manageSetting, event.id);
        emit(ManageSettingsLoadedState(ManageSettingsVariables.restaurantModelController.text));
      } catch (e) {
        print(e.toString());
        ManageSettingsErrorState(e.toString());
      }
    });



  }
}
