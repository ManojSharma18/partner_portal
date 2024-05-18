import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/order_forecast/forecast_event.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/order_constants/order_variables.dart';


import 'forecast_state.dart';

class ForecastBloc extends Bloc<ForeCastEvent,ForecastState>{
  ForecastBloc() : super(ForecastState(rowHeights: GlobalVariables.rowHeights, isExpanded: OrderVariables.isExpanded));

  Stream<ForecastState> mapEventToState(ForeCastEvent event) async* {
    if (event is ItemHeightEvent) {
      GlobalVariables.rowHeights[event.index] = GlobalVariables.rowHeights[event.index] == 85 ? 150 : 85;
      yield ForecastState(rowHeights: List.of(GlobalVariables.rowHeights), isExpanded: state.isExpanded);
    }else if(event is ExpandAllEvent)
      {
        print(OrderVariables.isExpanded);
        if(OrderVariables.isExpanded){
          GlobalVariables.rowHeights = List.filled(GlobalVariables.rowHeights.length, 150);
          GlobalVariables.rowHeights = List.filled(GlobalVariables.rowHeights.length, 150);
        }else {
          GlobalVariables.rowHeights = List.filled(GlobalVariables.rowHeights.length, 85);
        }
        OrderVariables.isExpanded = !OrderVariables.isExpanded;
        yield ForecastState(rowHeights: List.of(GlobalVariables.rowHeights), isExpanded: !OrderVariables.isExpanded);
      }
  }

}

