import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/order_forecast/forecast_event.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';


import 'forecast_state.dart';

class ForecastBloc extends Bloc<ForeCastEvent,ForecastState>{
  ForecastBloc() : super(ForecastState(rowHeights: GlobalVariables.rowHeights));

  Stream<ForecastState> mapEventToState(ForeCastEvent event) async* {
    if (event is ItemHeightEvent) {
      GlobalVariables.rowHeights[event.index] = GlobalVariables.rowHeights[event.index] == 70 ? 150 : 70;
      yield ForecastState(rowHeights: List.of(GlobalVariables.rowHeights));
    }
  }

}

