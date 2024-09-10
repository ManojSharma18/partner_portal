import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/constants/manage_settings/manage_settings_functions.dart';
import 'package:partner_admin_portal/constants/manage_settings/manage_settings_variables.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';

import '../../bloc/time/time_bloc.dart';
import '../../bloc/time/time_state.dart';
import '../../constants/global_variables.dart';

class TimeControllerMob extends StatelessWidget {
  final String time;
  final String session;
  final String timeString;
  final String meal;
  const TimeControllerMob({Key? key, required this.time, required this.session, required this.timeString, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return  BlocBuilder<TimeSelectionBloc,TimeSelectState>(builder: (context,state) {
      return  InkWell(
        onTap: () async {
          ManageSettingFunction.showTimePickerDialog(context, session, timeString, meal);
        },
        child: Container(
          width: 85*fem,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black26),
          ),
          child: Center(
            child: Text(
              '${ManageSettingsVariables.mealTiming[meal]![session]![timeString]}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Open Sans',
                fontSize: 13,
                color: GlobalVariables.textColor,
              ),
            ),
          ),
        ),
      );
    });

  }
}