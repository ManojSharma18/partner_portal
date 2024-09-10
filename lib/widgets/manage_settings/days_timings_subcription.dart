import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_state.dart';
import 'package:partner_admin_portal/bloc/menu/menu_state.dart';
import 'package:partner_admin_portal/constants/manage_settings/manage_settings_variables.dart';
import '../../bloc/days_timings/days_time_bloc.dart';
import '../../bloc/days_timings/days_time_state.dart';
import '../../bloc/time/time_bloc.dart';
import '../../bloc/time/time_state.dart';
import '../../constants/global_variables.dart';
import '../../constants/manage_settings/manage_settings_functions.dart';
import '../../constants/utils.dart';
import '../responsive_builder.dart';

class DaysTimingsSubscription extends StatefulWidget {
  final Map<String, Map<String, bool>> mealDataSub;
  final Map<String,Map<String,Map<String,dynamic>>> mealTimingSub;
  const DaysTimingsSubscription({Key? key,required this.mealDataSub, required this.mealTimingSub}) : super(key: key);

  @override
  State<DaysTimingsSubscription> createState() => _DaysTimingsState();
}

class _DaysTimingsState extends State<DaysTimingsSubscription> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    ManageSettingFunction.enableTimeSession();

    return BlocBuilder<ManageSettingsBloc,ManageSettingState>(builder: (BuildContext context, state) {
      if(state is ManageSettingsLoadingState) {
        return Center(child: CircularProgressIndicator(),);
      }
      if(state is ManageSettingsLoadedState){
        return ResponsiveBuilder(
            mobileBuilder: (BuildContext context, BoxConstraints constraints) {
              return BlocBuilder<DaysTimeBloc,DaysTimeState>
                (builder: (context,state) {
                return  Container(
                  margin: EdgeInsets.only(top:0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        SizedBox(height: 30,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 350*fem,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffffffff),
                                  border: Border.all(color: Colors.black12)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10 * fem, right: 10 * fem, top: 20 * fem),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Operational days and meals",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Open Sans',
                                            fontSize: 15,
                                            color: GlobalVariables.textColor,
                                          ),),

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  Container(
                                    margin: EdgeInsets.only(left: 10*fem, right: 30,),
                                    child: DataTable(
                                      columnSpacing: 30 * fem,
                                      headingRowHeight: 80,
                                      border: TableBorder.all(color: Colors.black12,
                                          width: 0.3,
                                          style: BorderStyle.solid,
                                          borderRadius: BorderRadius.circular(10)),
                                      columns: <DataColumn>[
                                        DataColumn(
                                          label: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Days', style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 10*fem,
                                                fontWeight: FontWeight.bold,
                                                color: GlobalVariables.primaryColor,
                                              )),
                                              SizedBox(height: 5,),
                                              Checkbox(
                                                value: ManageSettingFunction.areAllMealsSelected(),
                                                activeColor: GlobalVariables.textColor,
                                                checkColor: GlobalVariables.primaryColor,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    ManageSettingFunction.selectAllMeals(value ?? false);
                                                  });
                                                },
                                                materialTapTargetSize: MaterialTapTargetSize
                                                    .shrinkWrap,
                                                // to remove extra padding
                                                visualDensity: VisualDensity.compact,
                                                // to reduce spacing
                                                tristate: false,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith<Color?>((
                                                    Set<MaterialState> states) {
                                                  // Set the color to white when the checkbox is not selected
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                  }
                                                  return Colors
                                                      .white; // Use white color when the checkbox is not selected
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataColumn(
                                          label: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Breakfast', style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 9*fem,
                                                fontWeight: FontWeight.bold,
                                                color: GlobalVariables.primaryColor,
                                              )),
                                              SizedBox(height: 5,),
                                              Checkbox(
                                                activeColor: GlobalVariables.textColor,
                                                checkColor: GlobalVariables.primaryColor,
                                                value: ManageSettingFunction.areAllBreakfastMealsSelected(),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    ManageSettingsVariables.mealData.forEach((day, meals) {
                                                      ManageSettingsVariables.mealData[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealData[day]!['Breakfast'] =
                                                          value ?? false;
                                                    });
                                                  });
                                                },
                                                materialTapTargetSize: MaterialTapTargetSize
                                                    .shrinkWrap,
                                                // to remove extra padding
                                                visualDensity: VisualDensity.compact,
                                                // to reduce spacing
                                                tristate: false,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith<Color?>((
                                                    Set<MaterialState> states) {
                                                  // Set the color to white when the checkbox is not selected
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                  }
                                                  return Colors
                                                      .white; // Use white color when the checkbox is not selected
                                                }),
                                              )

                                            ],
                                          ),
                                        ),
                                        DataColumn(
                                          label: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Lunch', style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 9*fem,
                                                fontWeight: FontWeight.bold,
                                                color: GlobalVariables.primaryColor,
                                              )),
                                              SizedBox(height: 5,),
                                              Checkbox(
                                                value: ManageSettingFunction.areAllLunchMealsSelected(),
                                                activeColor: GlobalVariables.textColor,
                                                checkColor: GlobalVariables.primaryColor,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    ManageSettingsVariables.mealData.forEach((day, meals) {
                                                      ManageSettingsVariables.mealData[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealData[day]!['Lunch'] =
                                                          value ?? false;
                                                    });
                                                  });
                                                },
                                                materialTapTargetSize: MaterialTapTargetSize
                                                    .shrinkWrap,
                                                // to remove extra padding
                                                visualDensity: VisualDensity.compact,
                                                // to reduce spacing
                                                tristate: false,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith<Color?>((
                                                    Set<MaterialState> states) {
                                                  // Set the color to white when the checkbox is not selected
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                  }
                                                  return Colors.white; // Use white color when the checkbox is not selected
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataColumn(
                                          label: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Dinner', style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 9*fem,
                                                fontWeight: FontWeight.bold,
                                                color: GlobalVariables.primaryColor,
                                              )),
                                              SizedBox(height: 5,),
                                              Checkbox(
                                                value: ManageSettingFunction.areAllDinnerMealsSelected(),
                                                activeColor: GlobalVariables.textColor,
                                                checkColor:GlobalVariables.primaryColor,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    ManageSettingsVariables.mealData.forEach((day, meals) {
                                                      ManageSettingsVariables.mealData[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealData[day]!['Dinner'] =
                                                          value ?? false;
                                                    });
                                                  });
                                                },
                                                materialTapTargetSize: MaterialTapTargetSize
                                                    .shrinkWrap,
                                                // to remove extra padding
                                                visualDensity: VisualDensity.compact,
                                                // to reduce spacing
                                                tristate: false,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith<Color?>((
                                                    Set<MaterialState> states) {
                                                  // Set the color to white when the checkbox is not selected
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                  }
                                                  return Colors
                                                      .white; // Use white color when the checkbox is not selected
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                      rows: ManageSettingsVariables.mealData.keys.map((String day) {
                                        var meals = ManageSettingsVariables.mealData[day] ??
                                            const {}; // Handling nullable map
                                        return DataRow(cells: <DataCell>[
                                          DataCell(
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(day, style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff1d1517),
                                                )),
                                                Checkbox(
                                                  value: ManageSettingFunction.areAllMealsSelectedForDay(
                                                      day),
                                                  activeColor: GlobalVariables.textColor,
                                                  checkColor: GlobalVariables.primaryColor,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      ManageSettingFunction.selectAllMealsForDay(
                                                          day, value ?? false);
                                                    });
                                                  },
                                                  materialTapTargetSize: MaterialTapTargetSize
                                                      .shrinkWrap,
                                                  // to remove extra padding
                                                  visualDensity: VisualDensity.compact,
                                                  // to reduce spacing
                                                  tristate: false,
                                                  fillColor: MaterialStateProperty
                                                      .resolveWith<Color?>((
                                                      Set<MaterialState> states) {
                                                    // Set the color to white when the checkbox is not selected
                                                    if (states.contains(
                                                        MaterialState.selected)) {
                                                      return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                    }
                                                    return Colors
                                                        .white; // Use white color when the checkbox is not selected
                                                  }),
                                                )


                                              ],
                                            ),
                                          ),
                                          DataCell(
                                              Center(
                                                child: Checkbox(
                                                  value: meals['Breakfast'] ?? false,
                                                  activeColor: GlobalVariables.textColor,
                                                  checkColor: GlobalVariables.primaryColor,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      ManageSettingsVariables.mealData[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealData[day]!['Breakfast'] =
                                                          value ?? false;
                                                    });
                                                  },
                                                  materialTapTargetSize: MaterialTapTargetSize
                                                      .shrinkWrap,
                                                  // to remove extra padding
                                                  visualDensity: VisualDensity.compact,
                                                  // to reduce spacing
                                                  tristate: false,
                                                  fillColor: MaterialStateProperty
                                                      .resolveWith<Color?>((
                                                      Set<MaterialState> states) {
                                                    // Set the color to white when the checkbox is not selected
                                                    if (states.contains(
                                                        MaterialState.selected)) {
                                                      return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                    }
                                                    return Colors
                                                        .white; // Use white color when the checkbox is not selected
                                                  }),
                                                ),
                                              )

                                          ),
                                          DataCell(
                                              Center(
                                                child: Checkbox(
                                                  value: meals['Lunch'] ?? false,
                                                  activeColor: GlobalVariables.textColor,
                                                  checkColor: GlobalVariables.primaryColor,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      ManageSettingsVariables.mealData[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealData[day]!['Lunch'] =
                                                          value ?? false;
                                                    });
                                                  },
                                                  materialTapTargetSize: MaterialTapTargetSize
                                                      .shrinkWrap,
                                                  // to remove extra padding
                                                  visualDensity: VisualDensity.compact,
                                                  // to reduce spacing
                                                  tristate: false,
                                                  fillColor: MaterialStateProperty
                                                      .resolveWith<Color?>((
                                                      Set<MaterialState> states) {
                                                    // Set the color to white when the checkbox is not selected
                                                    if (states.contains(
                                                        MaterialState.selected)) {
                                                      return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                    }
                                                    return Colors
                                                        .white; // Use white color when the checkbox is not selected
                                                  }),
                                                ),
                                              )

                                          ),
                                          DataCell(
                                              Center(
                                                child: Checkbox(
                                                  value: meals['Dinner'] ?? false,
                                                  activeColor:GlobalVariables.textColor,
                                                  checkColor: GlobalVariables.primaryColor,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      ManageSettingsVariables.mealData[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealData[day]!['Dinner'] =
                                                          value ?? false;
                                                    });
                                                  },
                                                  materialTapTargetSize: MaterialTapTargetSize
                                                      .shrinkWrap,
                                                  // to remove extra padding
                                                  visualDensity: VisualDensity.compact,
                                                  // to reduce spacing
                                                  tristate: false,
                                                  fillColor: MaterialStateProperty
                                                      .resolveWith<Color?>((
                                                      Set<MaterialState> states) {
                                                    // Set the color to white when the checkbox is not selected
                                                    if (states.contains(
                                                        MaterialState.selected)) {
                                                      return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                    }
                                                    return Colors
                                                        .white; // Use white color when the checkbox is not selected
                                                  }),
                                                ),
                                              )

                                          ),
                                        ]);
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
                            Container(
                              width: 350 * fem,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffffffff),
                                  border: Border.all(color: Colors.black12)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10 * fem, right: 30, top: 20 * fem),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Operational sessions and business model", style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Open Sans',
                                          fontSize: 15,
                                          color: GlobalVariables.textColor,

                                        ),),

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 90*fem, bottom: 10),
                                        child: Text("Start time",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Open Sans',
                                            fontSize: 12*fem,
                                            color: GlobalVariables.textColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 25*fem, bottom: 10),
                                        child: Text("to",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Open Sans',
                                            fontSize: 12*fem,
                                            color: GlobalVariables.textColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 25*fem, bottom: 10),
                                        child: Text("End time",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Open Sans',
                                            fontSize: 12*fem,
                                            color: GlobalVariables.textColor,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),

                                  Visibility(
                                    visible: ManageSettingsVariables.breakfast,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // SizedBox(width: 30,),
                                        // Container(
                                        //   width: 70,
                                        //   child: Text("Breakfast",
                                        //     style: TextStyle(
                                        //       fontWeight: FontWeight.w600,
                                        //       fontFamily: 'Open Sans',
                                        //       fontSize: 15,
                                        //       color: Colors.black,
                                        //     ),
                                        //   ),
                                        // ),
                                        // SizedBox(width: 20,),
                                        SizedBox(height: 10,),
                                        mealTimeWidgetMob("Breakfast",ManageSettingsVariables.isBreakfastSessionEnabled,ManageSettingsVariables.defaultBreakfastPreorder,ManageSettingsVariables.defaultBreakfastSubscription),
                                        SizedBox(height: 0,),
                                        Container(
                                          margin: EdgeInsets.only(left: 10*fem),
                                          width: 450,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width:70*fem,
                                                    child: Text("Subscription",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 12,
                                                        color: GlobalVariables.textColor,
                                                      ),),
                                                  ),
                                                  SizedBox(width: 10*fem,),
                                                  Text(
                                                    '${ManageSettingsVariables.breakfastTimingsSub.isEmpty
                                                        ? ManageSettingsVariables.mealTimingSub['Breakfast']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.breakfastTimingsSub[0]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  SizedBox(width: 55*fem,),
                                                  Text(
                                                    '${ManageSettingsVariables.breakfastTimingsSub.isEmpty
                                                        ? ManageSettingsVariables.mealTimingSub['Breakfast']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.breakfastTimingsSub.length == 1 ?
                                                    ManageSettingsVariables.mealTimingSub['Breakfast']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.breakfastTimingsSub[ManageSettingsVariables.breakfastTimingsSub.length -1 ]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15,),
                                              for (int index = 0; index < ManageSettingsVariables.sessionsSub.length && index < 4; index++)
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 45*fem,),
                                                        _buildSessionRowMob(index, ManageSettingsVariables.sessionsSub, ManageSettingsVariables.selectedStartTimeBFSub, ManageSettingsVariables.selectedEndTimeBFSub,'Breakfast'),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Visibility(
                                    visible: ManageSettingsVariables.lunch,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10,),
                                        mealTimeWidgetMob("Lunch",ManageSettingsVariables.isLunchSessionEnabled,ManageSettingsVariables.defaultLunchPreorder,ManageSettingsVariables.defaultLunchSubscription),
                                        SizedBox(height: 0,),
                                        Container(
                                          margin: EdgeInsets.only(left: 10*fem),
                                          width: 450,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width:70*fem,
                                                    child: Text("Subscription",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 12,
                                                        color: GlobalVariables.textColor,
                                                      ),),
                                                  ),
                                                  SizedBox(width: 10*fem,),
                                                  Text(
                                                    '${ManageSettingsVariables.lunchTimings.isEmpty
                                                        ? ManageSettingsVariables.mealTiming['Lunch']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.lunchTimings[0]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  SizedBox(width: 55*fem,),
                                                  Text(
                                                    '${ManageSettingsVariables.lunchTimings.isEmpty
                                                        ? ManageSettingsVariables.mealTiming['Lunch']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.lunchTimings.length == 1 ?
                                                    ManageSettingsVariables.mealTiming['Lunch']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.lunchTimings[ManageSettingsVariables.lunchTimings.length -1 ]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15,),
                                              for (int index = 0; index < ManageSettingsVariables.lunchSessionsSub.length && index < 4; index++)
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 45*fem,),
                                                        _buildSessionRowMob(index, ManageSettingsVariables.lunchSessionsSub, ManageSettingsVariables.selectedStartTimeLunchSub, ManageSettingsVariables.selectedEndTimeLunchSub,'Lunch'),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Visibility(
                                    visible: ManageSettingsVariables.dinner,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10,),
                                        mealTimeWidgetMob("Dinner",ManageSettingsVariables.isDinnerSessionEnabled,ManageSettingsVariables.defaultDinnerPreorder,ManageSettingsVariables.defaultDinnerSubscription),
                                        SizedBox(height: 0,),
                                        Container(
                                          margin: EdgeInsets.only(left: 10*fem),
                                          width: 450,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width:70*fem,
                                                    child: Text("Subscription",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 12,
                                                        color: GlobalVariables.textColor,
                                                      ),),
                                                  ),
                                                  SizedBox(width: 10*fem,),
                                                  Text(
                                                    '${ManageSettingsVariables.dinnerTimings.isEmpty
                                                        ? ManageSettingsVariables.mealTiming['Dinner']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.dinnerTimings[0]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  SizedBox(width: 55*fem,),
                                                  Text(
                                                    '${ManageSettingsVariables.dinnerTimings.isEmpty
                                                        ? ManageSettingsVariables.mealTiming['Dinner']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.dinnerTimings.length == 1 ?
                                                    ManageSettingsVariables.mealTiming['Dinner']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.dinnerTimings[ManageSettingsVariables.dinnerTimings.length -1 ]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15,),
                                              for (int index = 0; index <
                                                  ManageSettingsVariables.dinnerSessionsSub.length && index < 4; index++)
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 45*fem,),
                                                        _buildSessionRowMob(index, ManageSettingsVariables.dinnerSessionsSub, ManageSettingsVariables.selectedStartTimeDinnerSub, ManageSettingsVariables.selectedEndTimeDinnerSub,"Dinner"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),

                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  right: 50, top: 30, bottom: 30),
                              width: 250,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () {

                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black, backgroundColor: Color(0xfffbb830),
                                  // Text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5), // Circular border radius
                                  ),
                                ),
                                child: Text(
                                  'Update',
                                  style: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Open Sans',
                                    fontSize: 18,
                                  ),
                                  // Text color
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
            tabletBuilder: (BuildContext context, BoxConstraints constraints) {
              return BlocBuilder<DaysTimeBloc,DaysTimeState>
                (builder: (context,state) {
                return  Container(
                  margin: EdgeInsets.only(top:0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        SizedBox(height: 30,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffffffff),
                                  border: Border.all(color: Colors.black12)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 30, right: 30, top: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Operational days and meals",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Open Sans',
                                            fontSize: 18,
                                            color: GlobalVariables.textColor,
                                          ),),

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  Container(
                                    margin: EdgeInsets.only(left: 30, right: 30,),
                                    child: DataTable(
                                      columnSpacing: 50,
                                      headingRowHeight: 100,
                                      border: TableBorder.all(color: Colors.black12,
                                          width: 0.3,
                                          style: BorderStyle.solid,
                                          borderRadius: BorderRadius.circular(10)),
                                      columns: <DataColumn>[
                                        DataColumn(
                                          label: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Days', style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: GlobalVariables.primaryColor,
                                              )),
                                              SizedBox(height: 5,),
                                              Checkbox(
                                                value: ManageSettingFunction.areAllMealsSelected(),
                                                activeColor: GlobalVariables.textColor,
                                                checkColor: GlobalVariables.primaryColor,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    ManageSettingFunction.selectAllMeals(value ?? false);
                                                  });
                                                },
                                                materialTapTargetSize: MaterialTapTargetSize
                                                    .shrinkWrap,
                                                // to remove extra padding
                                                visualDensity: VisualDensity.compact,
                                                // to reduce spacing
                                                tristate: false,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith<Color?>((
                                                    Set<MaterialState> states) {
                                                  // Set the color to white when the checkbox is not selected
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                  }
                                                  return Colors
                                                      .white; // Use white color when the checkbox is not selected
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataColumn(
                                          label: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Breakfast', style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: GlobalVariables.primaryColor,
                                              )),
                                              SizedBox(height: 5,),
                                              Checkbox(
                                                activeColor: GlobalVariables.textColor,
                                                checkColor: GlobalVariables.primaryColor,
                                                value: ManageSettingFunction.areAllBreakfastMealsSelected(),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    ManageSettingsVariables.mealDataSub.forEach((day, meals) {
                                                      ManageSettingsVariables.mealDataSub[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealDataSub[day]!['Breakfast'] =
                                                          value ?? false;
                                                    });
                                                  });
                                                },
                                                materialTapTargetSize: MaterialTapTargetSize
                                                    .shrinkWrap,
                                                // to remove extra padding
                                                visualDensity: VisualDensity.compact,
                                                // to reduce spacing
                                                tristate: false,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith<Color?>((
                                                    Set<MaterialState> states) {
                                                  // Set the color to white when the checkbox is not selected
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                  }
                                                  return Colors
                                                      .white; // Use white color when the checkbox is not selected
                                                }),
                                              )

                                            ],
                                          ),
                                        ),
                                        DataColumn(
                                          label: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Lunch', style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: GlobalVariables.primaryColor,
                                              )),
                                              SizedBox(height: 5,),
                                              Checkbox(
                                                value: ManageSettingFunction.areAllLunchMealsSelected(),
                                                activeColor: GlobalVariables.textColor,
                                                checkColor: GlobalVariables.primaryColor,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    ManageSettingsVariables.mealDataSub.forEach((day, meals) {
                                                      ManageSettingsVariables.mealDataSub[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealDataSub[day]!['Lunch'] =
                                                          value ?? false;
                                                    });
                                                  });
                                                },
                                                materialTapTargetSize: MaterialTapTargetSize
                                                    .shrinkWrap,
                                                // to remove extra padding
                                                visualDensity: VisualDensity.compact,
                                                // to reduce spacing
                                                tristate: false,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith<Color?>((
                                                    Set<MaterialState> states) {
                                                  // Set the color to white when the checkbox is not selected
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                  }
                                                  return Colors.white; // Use white color when the checkbox is not selected
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataColumn(
                                          label: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Dinner', style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: GlobalVariables.primaryColor,
                                              )),
                                              SizedBox(height: 5,),
                                              Checkbox(
                                                value: ManageSettingFunction.areAllDinnerMealsSelected(),
                                                activeColor: GlobalVariables.textColor,
                                                checkColor:GlobalVariables.primaryColor,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    ManageSettingsVariables.mealDataSub.forEach((day, meals) {
                                                      ManageSettingsVariables.mealDataSub[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealDataSub[day]!['Dinner'] =
                                                          value ?? false;
                                                    });
                                                  });
                                                },
                                                materialTapTargetSize: MaterialTapTargetSize
                                                    .shrinkWrap,
                                                // to remove extra padding
                                                visualDensity: VisualDensity.compact,
                                                // to reduce spacing
                                                tristate: false,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith<Color?>((
                                                    Set<MaterialState> states) {
                                                  // Set the color to white when the checkbox is not selected
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                  }
                                                  return Colors
                                                      .white; // Use white color when the checkbox is not selected
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                      rows: ManageSettingsVariables.mealDataSub.keys.map((String day) {
                                        var meals = ManageSettingsVariables.mealDataSub[day] ??
                                            const {}; // Handling nullable map
                                        return DataRow(cells: <DataCell>[
                                          DataCell(
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(day, style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff1d1517),
                                                )),
                                                Checkbox(
                                                  value: ManageSettingFunction.areAllMealsSelectedForDay(
                                                      day),
                                                  activeColor: GlobalVariables.textColor,
                                                  checkColor: GlobalVariables.primaryColor,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      ManageSettingFunction.selectAllMealsForDay(
                                                          day, value ?? false);
                                                    });
                                                  },
                                                  materialTapTargetSize: MaterialTapTargetSize
                                                      .shrinkWrap,
                                                  // to remove extra padding
                                                  visualDensity: VisualDensity.compact,
                                                  // to reduce spacing
                                                  tristate: false,
                                                  fillColor: MaterialStateProperty
                                                      .resolveWith<Color?>((
                                                      Set<MaterialState> states) {
                                                    // Set the color to white when the checkbox is not selected
                                                    if (states.contains(
                                                        MaterialState.selected)) {
                                                      return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                    }
                                                    return Colors
                                                        .white; // Use white color when the checkbox is not selected
                                                  }),
                                                )


                                              ],
                                            ),
                                          ),
                                          DataCell(
                                              Center(
                                                child: Checkbox(
                                                  value: meals['Breakfast'] ?? false,
                                                  activeColor: GlobalVariables.textColor,
                                                  checkColor: GlobalVariables.primaryColor,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      ManageSettingsVariables.mealDataSub[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealDataSub[day]!['Breakfast'] =
                                                          value ?? false;
                                                    });
                                                  },
                                                  materialTapTargetSize: MaterialTapTargetSize
                                                      .shrinkWrap,
                                                  // to remove extra padding
                                                  visualDensity: VisualDensity.compact,
                                                  // to reduce spacing
                                                  tristate: false,
                                                  fillColor: MaterialStateProperty
                                                      .resolveWith<Color?>((
                                                      Set<MaterialState> states) {
                                                    // Set the color to white when the checkbox is not selected
                                                    if (states.contains(
                                                        MaterialState.selected)) {
                                                      return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                    }
                                                    return Colors
                                                        .white; // Use white color when the checkbox is not selected
                                                  }),
                                                ),
                                              )

                                          ),
                                          DataCell(
                                              Center(
                                                child: Checkbox(
                                                  value: meals['Lunch'] ?? false,
                                                  activeColor: GlobalVariables.textColor,
                                                  checkColor: GlobalVariables.primaryColor,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      ManageSettingsVariables.mealDataSub[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealDataSub[day]!['Lunch'] =
                                                          value ?? false;
                                                    });
                                                  },
                                                  materialTapTargetSize: MaterialTapTargetSize
                                                      .shrinkWrap,
                                                  // to remove extra padding
                                                  visualDensity: VisualDensity.compact,
                                                  // to reduce spacing
                                                  tristate: false,
                                                  fillColor: MaterialStateProperty
                                                      .resolveWith<Color?>((
                                                      Set<MaterialState> states) {
                                                    // Set the color to white when the checkbox is not selected
                                                    if (states.contains(
                                                        MaterialState.selected)) {
                                                      return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                    }
                                                    return Colors
                                                        .white; // Use white color when the checkbox is not selected
                                                  }),
                                                ),
                                              )

                                          ),
                                          DataCell(
                                              Center(
                                                child: Checkbox(
                                                  value: meals['Dinner'] ?? false,
                                                  activeColor:GlobalVariables.textColor,
                                                  checkColor: GlobalVariables.primaryColor,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      ManageSettingsVariables.mealDataSub[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealDataSub[day]!['Dinner'] =
                                                          value ?? false;
                                                    });
                                                  },
                                                  materialTapTargetSize: MaterialTapTargetSize
                                                      .shrinkWrap,
                                                  // to remove extra padding
                                                  visualDensity: VisualDensity.compact,
                                                  // to reduce spacing
                                                  tristate: false,
                                                  fillColor: MaterialStateProperty
                                                      .resolveWith<Color?>((
                                                      Set<MaterialState> states) {
                                                    // Set the color to white when the checkbox is not selected
                                                    if (states.contains(
                                                        MaterialState.selected)) {
                                                      return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                    }
                                                    return Colors
                                                        .white; // Use white color when the checkbox is not selected
                                                  }),
                                                ),
                                              )

                                          ),
                                        ]);
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
                            Container(
                              width: 300 * fem,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffffffff),
                                  border: Border.all(color: Colors.black12)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 30, right: 30, top: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Operational sessions and business model", style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Open Sans',
                                          fontSize: 18,
                                          color: GlobalVariables.textColor,

                                        ),),

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 175, bottom: 10),
                                        child: Text("Start time",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Open Sans',
                                            fontSize: 15,
                                            color: GlobalVariables.textColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 50, bottom: 10),
                                        child: Text("to",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Open Sans',
                                            fontSize: 15,
                                            color: GlobalVariables.textColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 50, bottom: 10),
                                        child: Text("End time",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Open Sans',
                                            fontSize: 15,
                                            color: GlobalVariables.textColor,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),

                                  Visibility(
                                    visible: ManageSettingsVariables.breakfast,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // SizedBox(width: 30,),
                                        // Container(
                                        //   width: 70,
                                        //   child: Text("Breakfast",
                                        //     style: TextStyle(
                                        //       fontWeight: FontWeight.w600,
                                        //       fontFamily: 'Open Sans',
                                        //       fontSize: 15,
                                        //       color: Colors.black,
                                        //     ),
                                        //   ),
                                        // ),
                                        // SizedBox(width: 20,),
                                        SizedBox(height: 10,),
                                        mealTimeWidget("Breakfast",ManageSettingsVariables.isBreakfastSessionEnabled,ManageSettingsVariables.defaultBreakfastPreorder,ManageSettingsVariables.defaultBreakfastSubscription),
                                        SizedBox(height: 30,),
                                        Container(
                                          margin: EdgeInsets.only(left: 50),
                                          width: 180*fem,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width:110,
                                                    child: Text("Subscription",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 15,
                                                        color: GlobalVariables.textColor,
                                                      ),),
                                                  ),
                                                  SizedBox(width: 15,),
                                                  Text(
                                                    '${ManageSettingsVariables.breakfastTimingsSub.isEmpty
                                                        ? ManageSettingsVariables.mealTimingSub['Breakfast']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.breakfastTimingsSub[0]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  SizedBox(width: 110,),
                                                  Text(
                                                    '${ManageSettingsVariables.breakfastTimingsSub.isEmpty
                                                        ? ManageSettingsVariables.mealTimingSub['Breakfast']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.breakfastTimingsSub.length == 1 ?
                                                    ManageSettingsVariables.mealTimingSub['Breakfast']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.breakfastTimingsSub[ManageSettingsVariables.breakfastTimingsSub.length -1 ]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15,),
                                              for (int index = 0; index < ManageSettingsVariables.sessionsSub.length && index < 3; index++)
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 60,),
                                                        _buildSessionRow(index, ManageSettingsVariables.sessionsSub, ManageSettingsVariables.selectedStartTimeBFSub, ManageSettingsVariables.selectedEndTimeBFSub,'Breakfast'),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Visibility(
                                    visible: ManageSettingsVariables.lunch,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10,),
                                        mealTimeWidget("Lunch",ManageSettingsVariables.isLunchSessionEnabled,ManageSettingsVariables.defaultLunchPreorder,ManageSettingsVariables.defaultLunchSubscription),
                                        SizedBox(height: 30,),
                                        Container(
                                          margin: EdgeInsets.only(left: 50),
                                          width: 180 * fem,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width:110,
                                                    child: Text("Subscription",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 15,
                                                        color: GlobalVariables.textColor,
                                                      ),),
                                                  ),
                                                  SizedBox(width: 15,),
                                                  Text(
                                                    '${ManageSettingsVariables.lunchTimingsSub.isEmpty
                                                        ? ManageSettingsVariables.mealTimingSub['Lunch']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.lunchTimingsSub[0]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  SizedBox(width: 110,),
                                                  Text(
                                                    '${ManageSettingsVariables.lunchTimingsSub.isEmpty
                                                        ? ManageSettingsVariables.mealTimingSub['Lunch']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.lunchTimingsSub.length == 1 ?
                                                    ManageSettingsVariables.mealTimingSub['Lunch']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.lunchTimingsSub[ManageSettingsVariables.lunchTimingsSub.length -1 ]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15,),
                                              for (int index = 0; index < ManageSettingsVariables.lunchSessionsSub.length && index < 3; index++)
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 60,),
                                                        _buildSessionRow(index, ManageSettingsVariables.lunchSessionsSub, ManageSettingsVariables.selectedStartTimeLunchSub, ManageSettingsVariables.selectedEndTimeLunchSub,'Lunch'),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Visibility(
                                    visible: ManageSettingsVariables.dinner,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10,),
                                        mealTimeWidget("Dinner",ManageSettingsVariables.isDinnerSessionEnabled,ManageSettingsVariables.defaultDinnerPreorder,ManageSettingsVariables.defaultDinnerSubscription),
                                        SizedBox(height: 30,),
                                        Container(
                                          margin: EdgeInsets.only(left: 50),
                                          width: 180 * fem,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width:110,
                                                    child: Text("Subscription",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 15,
                                                        color: GlobalVariables.textColor,
                                                      ),),
                                                  ),
                                                  SizedBox(width: 15,),
                                                  Text(
                                                    '${ManageSettingsVariables.dinnerTimingsSub.isEmpty
                                                        ? ManageSettingsVariables.mealTimingSub['Dinner']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.dinnerTimingsSub[0]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  SizedBox(width: 110,),
                                                  Text(
                                                    '${ManageSettingsVariables.dinnerTimingsSub.isEmpty
                                                        ? ManageSettingsVariables.mealTimingSub['Dinner']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.dinnerTimingsSub.length == 1 ?
                                                    ManageSettingsVariables.mealTimingSub['Dinner']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.dinnerTimingsSub[ManageSettingsVariables.dinnerTimingsSub.length -1 ]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15,),
                                              for (int index = 0; index < ManageSettingsVariables.dinnerSessionsSub.length && index < 3; index++)
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(width:60),
                                                        _buildSessionRow(index, ManageSettingsVariables.dinnerSessionsSub,
                                                            ManageSettingsVariables.selectedStartTimeDinnerSub,
                                                            ManageSettingsVariables.selectedEndTimeDinnerSub,"Dinner"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),

                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  right: 50, top: 30, bottom: 30),
                              width: 250,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () {

                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black, backgroundColor: Color(0xfffbb830),
                                  // Text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5), // Circular border radius
                                  ),
                                ),
                                child: Text(
                                  'Update',
                                  style: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Open Sans',
                                    fontSize: 18,
                                  ),
                                  // Text color
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
            desktopBuilder: (BuildContext context, BoxConstraints constraints) {
              return BlocBuilder<DaysTimeBloc,DaysTimeState>
                (builder: (context,state) {
                return  Container(
                  margin: EdgeInsets.only(top:0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffffffff),
                                  border: Border.all(color: Colors.black12)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 30, right: 30, top: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Operational days and meals",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Open Sans',
                                            fontSize: 18,
                                            color: GlobalVariables.textColor,
                                          ),),

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  Container(
                                    margin: EdgeInsets.only(left: 30, right: 30,),
                                    child: DataTable(
                                      columnSpacing: 50,
                                      headingRowHeight: 100,
                                      border: TableBorder.all(color: Colors.black12,
                                          width: 0.3,
                                          style: BorderStyle.solid,
                                          borderRadius: BorderRadius.circular(10)),
                                      columns: <DataColumn>[
                                        DataColumn(
                                          label: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Days', style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: GlobalVariables.primaryColor,
                                              )),
                                              SizedBox(height: 5,),
                                              Checkbox(
                                                value: ManageSettingFunction.areAllMealsSelectedSub(),
                                                activeColor: GlobalVariables.textColor,
                                                checkColor: GlobalVariables.primaryColor,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    ManageSettingFunction.selectAllMealsSub(value ?? false);
                                                  });
                                                },
                                                materialTapTargetSize: MaterialTapTargetSize
                                                    .shrinkWrap,
                                                // to remove extra padding
                                                visualDensity: VisualDensity.compact,
                                                // to reduce spacing
                                                tristate: false,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith<Color?>((
                                                    Set<MaterialState> states) {
                                                  // Set the color to white when the checkbox is not selected
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                  }
                                                  return Colors
                                                      .white; // Use white color when the checkbox is not selected
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataColumn(
                                          label: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Breakfast', style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: GlobalVariables.primaryColor,
                                              )),
                                              SizedBox(height: 5,),
                                              Checkbox(
                                                activeColor: GlobalVariables.textColor,
                                                checkColor: GlobalVariables.primaryColor,
                                                value: ManageSettingFunction.areAllBreakfastMealsSelectedSub(),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    ManageSettingsVariables.mealDataSub.forEach((day, meals) {
                                                      ManageSettingsVariables.mealDataSub[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealDataSub[day]!['Breakfast'] =
                                                          value ?? false;
                                                    });
                                                  });
                                                },
                                                materialTapTargetSize: MaterialTapTargetSize
                                                    .shrinkWrap,
                                                // to remove extra padding
                                                visualDensity: VisualDensity.compact,
                                                // to reduce spacing
                                                tristate: false,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith<Color?>((
                                                    Set<MaterialState> states) {
                                                  // Set the color to white when the checkbox is not selected
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                  }
                                                  return Colors
                                                      .white; // Use white color when the checkbox is not selected
                                                }),
                                              )

                                            ],
                                          ),
                                        ),
                                        DataColumn(
                                          label: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Lunch', style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: GlobalVariables.primaryColor,
                                              )),
                                              SizedBox(height: 5,),
                                              Checkbox(
                                                value: ManageSettingFunction.areAllLunchMealsSelectedSub(),
                                                activeColor: GlobalVariables.textColor,
                                                checkColor: GlobalVariables.primaryColor,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    ManageSettingsVariables.mealDataSub.forEach((day, meals) {
                                                      ManageSettingsVariables.mealDataSub[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealDataSub[day]!['Lunch'] =
                                                          value ?? false;
                                                    });
                                                  });
                                                },
                                                materialTapTargetSize: MaterialTapTargetSize
                                                    .shrinkWrap,
                                                // to remove extra padding
                                                visualDensity: VisualDensity.compact,
                                                // to reduce spacing
                                                tristate: false,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith<Color?>((
                                                    Set<MaterialState> states) {
                                                  // Set the color to white when the checkbox is not selected
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                  }
                                                  return Colors.white; // Use white color when the checkbox is not selected
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataColumn(
                                          label: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Dinner', style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: GlobalVariables.primaryColor,
                                              )),
                                              SizedBox(height: 5,),
                                              Checkbox(
                                                value: ManageSettingFunction.areAllDinnerMealsSelectedSub(),
                                                activeColor: GlobalVariables.textColor,
                                                checkColor:GlobalVariables.primaryColor,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    ManageSettingsVariables.mealDataSub.forEach((day, meals) {
                                                      ManageSettingsVariables.mealDataSub[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealDataSub[day]!['Dinner'] =
                                                          value ?? false;
                                                    });
                                                  });
                                                },
                                                materialTapTargetSize: MaterialTapTargetSize
                                                    .shrinkWrap,
                                                // to remove extra padding
                                                visualDensity: VisualDensity.compact,
                                                // to reduce spacing
                                                tristate: false,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith<Color?>((
                                                    Set<MaterialState> states) {
                                                  // Set the color to white when the checkbox is not selected
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                  }
                                                  return Colors
                                                      .white; // Use white color when the checkbox is not selected
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                      rows: ManageSettingsVariables.mealDataSub.keys.map((String day) {
                                        var meals = ManageSettingsVariables.mealDataSub[day] ??
                                            const {}; // Handling nullable map
                                        return DataRow(cells: <DataCell>[
                                          DataCell(
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(day, style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff1d1517),
                                                )),
                                                Checkbox(
                                                  value: ManageSettingFunction.areAllMealsSelectedForDaySub(
                                                      day),
                                                  activeColor: GlobalVariables.textColor,
                                                  checkColor: GlobalVariables.primaryColor,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      ManageSettingFunction.selectAllMealsForDaySub(
                                                          day, value ?? false);
                                                    });
                                                  },
                                                  materialTapTargetSize: MaterialTapTargetSize
                                                      .shrinkWrap,
                                                  // to remove extra padding
                                                  visualDensity: VisualDensity.compact,
                                                  // to reduce spacing
                                                  tristate: false,
                                                  fillColor: MaterialStateProperty
                                                      .resolveWith<Color?>((
                                                      Set<MaterialState> states) {
                                                    // Set the color to white when the checkbox is not selected
                                                    if (states.contains(
                                                        MaterialState.selected)) {
                                                      return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                    }
                                                    return Colors
                                                        .white; // Use white color when the checkbox is not selected
                                                  }),
                                                )


                                              ],
                                            ),
                                          ),
                                          DataCell(
                                              Center(
                                                child: Checkbox(
                                                  value: meals['Breakfast'] ?? false,
                                                  activeColor: GlobalVariables.textColor,
                                                  checkColor: GlobalVariables.primaryColor,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      ManageSettingsVariables.mealDataSub[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealDataSub[day]!['Breakfast'] =
                                                          value ?? false;
                                                    });
                                                  },
                                                  materialTapTargetSize: MaterialTapTargetSize
                                                      .shrinkWrap,
                                                  // to remove extra padding
                                                  visualDensity: VisualDensity.compact,
                                                  // to reduce spacing
                                                  tristate: false,
                                                  fillColor: MaterialStateProperty
                                                      .resolveWith<Color?>((
                                                      Set<MaterialState> states) {
                                                    // Set the color to white when the checkbox is not selected
                                                    if (states.contains(
                                                        MaterialState.selected)) {
                                                      return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                    }
                                                    return Colors
                                                        .white; // Use white color when the checkbox is not selected
                                                  }),
                                                ),
                                              )

                                          ),
                                          DataCell(
                                              Center(
                                                child: Checkbox(
                                                  value: meals['Lunch'] ?? false,
                                                  activeColor: GlobalVariables.textColor,
                                                  checkColor: GlobalVariables.primaryColor,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      ManageSettingsVariables.mealDataSub[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealDataSub[day]!['Lunch'] =
                                                          value ?? false;
                                                    });
                                                  },
                                                  materialTapTargetSize: MaterialTapTargetSize
                                                      .shrinkWrap,
                                                  // to remove extra padding
                                                  visualDensity: VisualDensity.compact,
                                                  // to reduce spacing
                                                  tristate: false,
                                                  fillColor: MaterialStateProperty
                                                      .resolveWith<Color?>((
                                                      Set<MaterialState> states) {
                                                    // Set the color to white when the checkbox is not selected
                                                    if (states.contains(
                                                        MaterialState.selected)) {
                                                      return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                    }
                                                    return Colors
                                                        .white; // Use white color when the checkbox is not selected
                                                  }),
                                                ),
                                              )

                                          ),
                                          DataCell(
                                              Center(
                                                child: Checkbox(
                                                  value: meals['Dinner'] ?? false,
                                                  activeColor:GlobalVariables.textColor,
                                                  checkColor: GlobalVariables.primaryColor,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      ManageSettingsVariables.mealDataSub[day] ??= {
                                                      }; // Initialize the map if it's null
                                                      ManageSettingsVariables.mealDataSub[day]!['Dinner'] =
                                                          value ?? false;
                                                    });
                                                  },
                                                  materialTapTargetSize: MaterialTapTargetSize
                                                      .shrinkWrap,
                                                  // to remove extra padding
                                                  visualDensity: VisualDensity.compact,
                                                  // to reduce spacing
                                                  tristate: false,
                                                  fillColor: MaterialStateProperty
                                                      .resolveWith<Color?>((
                                                      Set<MaterialState> states) {
                                                    // Set the color to white when the checkbox is not selected
                                                    if (states.contains(
                                                        MaterialState.selected)) {
                                                      return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                                                    }
                                                    return Colors
                                                        .white; // Use white color when the checkbox is not selected
                                                  }),
                                                ),
                                              )

                                          ),
                                        ]);
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                ],
                              ),
                            ),
                            SizedBox(width: 10 * fem,),
                            Container(
                              width: 180 * fem,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffffffff),
                                  border: Border.all(color: Colors.black12)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 30, right: 30, top: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Operational sessions and business model", style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Open Sans',
                                          fontSize: 18,
                                          color: GlobalVariables.textColor,

                                        ),),

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 175, bottom: 10),
                                        child: Text("Start time",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Open Sans',
                                            fontSize: 15,
                                            color: GlobalVariables.textColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 50, bottom: 10),
                                        child: Text("to",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Open Sans',
                                            fontSize: 15,
                                            color: GlobalVariables.textColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 50, bottom: 10),
                                        child: Text("End time",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Open Sans',
                                            fontSize: 15,
                                            color: GlobalVariables.textColor,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),

                                  Visibility(
                                    visible: ManageSettingsVariables.breakfast,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // SizedBox(width: 30,),
                                        // Container(
                                        //   width: 70,
                                        //   child: Text("Breakfast",
                                        //     style: TextStyle(
                                        //       fontWeight: FontWeight.w600,
                                        //       fontFamily: 'Open Sans',
                                        //       fontSize: 15,
                                        //       color: Colors.black,
                                        //     ),
                                        //   ),
                                        // ),
                                        // SizedBox(width: 20,),
                                        SizedBox(height: 10,),
                                        mealTimeWidget("Breakfast",ManageSettingsVariables.isBreakfastSessionEnabled,ManageSettingsVariables.defaultBreakfastPreorder,ManageSettingsVariables.defaultBreakfastSubscription),
                                        SizedBox(height: 30,),
                                        Container(
                                          margin: EdgeInsets.only(left: 50),
                                          width: 180*fem,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width:110,
                                                    child: Text("Subscription",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 15,
                                                        color: GlobalVariables.textColor,
                                                      ),),
                                                  ),
                                                  SizedBox(width: 15,),
                                                  Text(
                                                    '${ManageSettingsVariables.breakfastTimingsSub.isEmpty
                                                        ? ManageSettingsVariables.mealTimingSub['Breakfast']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.breakfastTimingsSub[0]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  SizedBox(width: 110,),
                                                  Text(
                                                    '${ManageSettingsVariables.breakfastTimingsSub.isEmpty
                                                        ? ManageSettingsVariables.mealTimingSub['Breakfast']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.breakfastTimingsSub.length == 1 ?
                                                    ManageSettingsVariables.mealTimingSub['Breakfast']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.breakfastTimingsSub[ManageSettingsVariables.breakfastTimingsSub.length -1 ]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15,),
                                              for (int index = 0; index < ManageSettingsVariables.sessionsSub.length && index < 3; index++)
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 60,),
                                                        _buildSessionRow(index, ManageSettingsVariables.sessionsSub, ManageSettingsVariables.selectedStartTimeBFSub, ManageSettingsVariables.selectedEndTimeBFSub,'Breakfast'),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Visibility(
                                    visible: ManageSettingsVariables.lunch,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10,),
                                        mealTimeWidget("Lunch",ManageSettingsVariables.isLunchSessionEnabled,ManageSettingsVariables.defaultLunchPreorder,ManageSettingsVariables.defaultLunchSubscription),
                                        SizedBox(height: 30,),
                                        Container(
                                          margin: EdgeInsets.only(left: 50),
                                          width: 180 * fem,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width:110,
                                                    child: Text("Subscription",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 15,
                                                        color: GlobalVariables.textColor,
                                                      ),),
                                                  ),
                                                  SizedBox(width: 15,),
                                                  Text(
                                                    '${ManageSettingsVariables.lunchTimingsSub.isEmpty
                                                        ? ManageSettingsVariables.mealTimingSub['Lunch']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.lunchTimingsSub[0]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  SizedBox(width: 110,),
                                                  Text(
                                                    '${ManageSettingsVariables.lunchTimingsSub.isEmpty
                                                        ? ManageSettingsVariables.mealTimingSub['Lunch']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.lunchTimingsSub.length == 1 ?
                                                    ManageSettingsVariables.mealTimingSub['Lunch']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.lunchTimingsSub[ManageSettingsVariables.lunchTimingsSub.length -1 ]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15,),
                                              for (int index = 0; index < ManageSettingsVariables.lunchSessionsSub.length && index < 3; index++)
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 60,),
                                                        _buildSessionRow(index, ManageSettingsVariables.lunchSessionsSub, ManageSettingsVariables.selectedStartTimeLunchSub, ManageSettingsVariables.selectedEndTimeLunchSub,'Lunch'),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Visibility(
                                    visible: ManageSettingsVariables.dinner,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10,),
                                        mealTimeWidget("Dinner",ManageSettingsVariables.isDinnerSessionEnabled,ManageSettingsVariables.defaultDinnerPreorder,ManageSettingsVariables.defaultDinnerSubscription),
                                        SizedBox(height: 30,),
                                        Container(
                                          margin: EdgeInsets.only(left: 50),
                                          width: 180 * fem,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width:110,
                                                    child: Text("Subscription",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 15,
                                                        color: GlobalVariables.textColor,
                                                      ),),
                                                  ),
                                                  SizedBox(width: 15,),
                                                  Text(
                                                    '${ManageSettingsVariables.dinnerTimingsSub.isEmpty
                                                        ? ManageSettingsVariables.mealTimingSub['Dinner']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.dinnerTimingsSub[0]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  SizedBox(width: 110,),
                                                  Text(
                                                    '${ManageSettingsVariables.dinnerTimingsSub.isEmpty
                                                        ? ManageSettingsVariables.mealTimingSub['Dinner']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.dinnerTimingsSub.length == 1 ?
                                                    ManageSettingsVariables.mealTimingSub['Dinner']!['Default']!['StartTime']
                                                        : ManageSettingsVariables.dinnerTimingsSub[ManageSettingsVariables.dinnerTimingsSub.length -1 ]}',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15,),
                                              for (int index = 0; index < ManageSettingsVariables.dinnerSessionsSub.length && index < 3; index++)
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(width:60),
                                                        _buildSessionRow(index, ManageSettingsVariables.dinnerSessionsSub,
                                                            ManageSettingsVariables.selectedStartTimeDinnerSub,
                                                            ManageSettingsVariables.selectedEndTimeDinnerSub,"Dinner"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),

                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  right: 50, top: 30, bottom: 30),
                              width: 250,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () {

                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black, backgroundColor: Color(0xfffbb830),
                                  // Text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5), // Circular border radius
                                  ),
                                ),
                                child: Text(
                                  'Update',
                                  style: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Open Sans',
                                    fontSize: 18,
                                  ),
                                  // Text color
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
            });
      }
      return Center(child: CircularProgressIndicator(),);
    },

    );
  }

  Widget _buildSessionRow(int index, List<SessionData> sessionData, String selectTimeStart, String selectTimeEnd,String meal) {
    String startTime = widget.mealTimingSub[meal]!["Session${index+1}"]!["StartTime"]!;
    String endTime = widget.mealTimingSub[meal]!["Session${index+1}"]!["EndTime"]!;
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    if(sessionData.length == 0) {
      sessionData.add(SessionData(startTime: "", endTime: ""));
    }
    return BlocBuilder<TimeSelectionBloc,TimeSelectState>(builder: (context,state) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("B${(index + 1).toString()}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Open Sans',
              fontSize: 15,
              color: GlobalVariables.textColor,
            ),
          ),
          SizedBox(width: 20,),
          InkWell(
            onTap: () {
              ManageSettingFunction.showTimePickerSubDialog(context,"Session${index+1}","StartTime",meal);
            },
            child: Container(
              height: 40,
              width: 130,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.alarm, color: Color(0xfffbb830), size: 15,),
                    SizedBox(width: 20,),
                    Text(
                      "${ManageSettingsVariables.mealTimingSub[meal]!["Session${index+1}"]!["StartTime"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Open Sans',
                        fontSize: 14,
                        color: GlobalVariables.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25),
            child: Text(":",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Open Sans',
                fontSize: 15,
                color: GlobalVariables.textColor,
              ),
            ),
          ),
          SizedBox(width: 25,),
          InkWell(
            onTap: () {
              ManageSettingFunction.showTimePickerSubDialog(context,"Session${index+1}","EndTime",meal);
            },
            child: Container(
              width: 130,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.alarm, color: Color(0xfffbb830), size: 15,),
                    SizedBox(width: 20,),
                    Text("${widget.mealTimingSub[meal]!["Session${index+1}"]!["EndTime"]!}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Open Sans',
                        fontSize: 14,
                        color: GlobalVariables.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
              visible: index >= 0,
              child: SizedBox(width: 10,)
          ),
          Visibility(
            visible: index >= 0,
            child: InkWell(
              onTap: () {
                setState(() {
                  if(sessionData.length > 1)
                    {
                      sessionData.removeAt(index);
                      if(sessionData.length == 0) {
                        widget.mealTimingSub[meal]!["Default"]!["Enabled"] =true;
                        widget.mealTimingSub[meal]!["Session1"]!["Enabled"] = false;
                      }
                    }
                });

              },
              child: Container(
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Center(
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10,),
          Visibility(
            visible: index < 2,
            child: InkWell(
              onTap: () {
                setState(() {
                  print("working");
                  if(sessionData.length < 3) {
                    sessionData.add(SessionData(startTime: "", endTime: ""));
                  }
                  widget.mealTimingSub[meal]!["Session${index+2}"]!["Enabled"] = true;
                });
              },
              child: Container(
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xfffbb830),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),

          Visibility(
              visible: index == 2,
              child: SizedBox(width: 25,)),

          Visibility(
              visible: ManageSettingsVariables.restaurantModelController.text == "Both",
              child: SizedBox(width:  25,)),
          Visibility(
            visible: ManageSettingsVariables.restaurantModelController.text == "Both",
            child: Checkbox(value:
            index == 0 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession1Preorder
                :index == 1 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession2Preorder
                : index == 2 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession3Preorder
                : index == 3 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession4Preorder
                : index == 0 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession1Preorder
                : index == 1 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession2Preorder
                : index == 2 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession3Preorder
                : index == 3 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession4Preorder
                : index == 0 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession1Preorder
                : index == 1 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession2Preorder
                : index == 2 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession3Preorder
                : index == 3 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession4Preorder
                : false
              ,
              onChanged: (val){
                setState(() {
                  if(meal == "Breakfast" && index == 0) {
                    ManageSettingsVariables.breakfastSession1Preorder = !ManageSettingsVariables.breakfastSession1Preorder;
                  } else if(meal == "Breakfast" && index == 1) {
                    ManageSettingsVariables.breakfastSession2Preorder = !ManageSettingsVariables.breakfastSession2Preorder;
                  } else if(meal == "Breakfast" && index == 2) {
                    ManageSettingsVariables.breakfastSession3Preorder = !ManageSettingsVariables.breakfastSession3Preorder;
                  } else if(meal == "Breakfast" && index == 3) {
                    ManageSettingsVariables.breakfastSession4Preorder = !ManageSettingsVariables.breakfastSession4Preorder;
                  } else if(meal == "Lunch" && index == 0) {
                    ManageSettingsVariables.lunchSession1Preorder = !ManageSettingsVariables.lunchSession1Preorder;
                  } else if(meal == "Lunch" && index == 1) {
                    ManageSettingsVariables.lunchSession2Preorder = !ManageSettingsVariables.lunchSession2Preorder;
                  } else if(meal == "Lunch" && index == 2) {
                    ManageSettingsVariables.lunchSession3Preorder = !ManageSettingsVariables.lunchSession3Preorder;
                  } else if(meal == "Lunch" && index == 3) {
                    ManageSettingsVariables.lunchSession4Preorder = !ManageSettingsVariables.lunchSession4Preorder;
                  } else if(meal == "Dinner" && index == 0) {
                    ManageSettingsVariables.dinnerSession1Preorder = !ManageSettingsVariables.dinnerSession1Preorder;
                  } else if(meal == "Dinner" && index == 1) {
                    ManageSettingsVariables.dinnerSession2Preorder = !ManageSettingsVariables.dinnerSession2Preorder;
                  } else if(meal == "Dinner" && index == 2) {
                    ManageSettingsVariables.dinnerSession3Preorder = !ManageSettingsVariables.dinnerSession3Preorder;
                  } else if(meal == "Dinner" && index == 3) {
                    ManageSettingsVariables.dinnerSession4Preorder = !ManageSettingsVariables.dinnerSession4Preorder;
                  }
                });
              },
              checkColor: GlobalVariables.primaryColor,
              fillColor: MaterialStateProperty
                  .resolveWith<Color?>((
                  Set<MaterialState> states) {
                if (states.contains(
                    MaterialState.selected)) {
                  return GlobalVariables.textColor;
                }
                return Colors.white;
              }),
              activeColor: GlobalVariables.textColor,
            ),
          ),

          Visibility(
              visible: ManageSettingsVariables.restaurantModelController.text == "Both",
              child: SizedBox(width:  40,)),
          Visibility(
            visible: ManageSettingsVariables.restaurantModelController.text == "Both",
            child: Checkbox(value:
            index == 0 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession1Subscription
                :index == 1 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession2Subscription
                : index == 2 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession3Subscription
                : index == 3 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession4Subscription
                : index == 0 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession1Subscription
                :index == 1 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession2Subscription
                : index == 2 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession3Subscription
                : index == 3 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession4Subscription
                : index == 0 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession1Subscription
                :index == 1 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession2Subscription
                : index == 2 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession3Subscription
                : index == 3 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession4Subscription
                : false
              ,
              onChanged: (val){
                setState(() {
                  if(meal == "Breakfast" && index == 0) {
                    ManageSettingsVariables.breakfastSession1Subscription = !ManageSettingsVariables.breakfastSession1Subscription;
                  } else if(meal == "Breakfast" && index == 1) {
                    ManageSettingsVariables.breakfastSession2Subscription = !ManageSettingsVariables.breakfastSession2Subscription;
                  } else if(meal == "Breakfast" && index == 2) {
                    ManageSettingsVariables.breakfastSession3Subscription = !ManageSettingsVariables.breakfastSession3Subscription;
                  } else if(meal == "Breakfast" && index == 3) {
                    ManageSettingsVariables.breakfastSession4Subscription = !ManageSettingsVariables.breakfastSession4Subscription;
                  } else if(meal == "Lunch" && index == 0) {
                    ManageSettingsVariables.lunchSession1Subscription = !ManageSettingsVariables.lunchSession1Subscription;
                  } else if(meal == "Lunch" && index == 1) {
                    ManageSettingsVariables.lunchSession2Subscription = !ManageSettingsVariables.lunchSession2Subscription;
                  } else if(meal == "Lunch" && index == 2) {
                    ManageSettingsVariables.lunchSession3Subscription = !ManageSettingsVariables.lunchSession3Subscription;
                  } else if(meal == "Lunch" && index == 3) {
                    ManageSettingsVariables.lunchSession4Subscription = !ManageSettingsVariables.lunchSession4Subscription;
                  } else if(meal == "Dinner" && index == 0) {
                    ManageSettingsVariables.dinnerSession1Subscription = !ManageSettingsVariables.dinnerSession1Subscription;
                  } else if(meal == "Dinner" && index == 1) {
                    ManageSettingsVariables.dinnerSession2Subscription = !ManageSettingsVariables.dinnerSession2Subscription;
                  } else if(meal == "Dinner" && index == 2) {
                    ManageSettingsVariables.dinnerSession3Subscription = !ManageSettingsVariables.dinnerSession3Subscription;
                  } else if(meal == "Dinner" && index == 3) {
                    ManageSettingsVariables.dinnerSession4Subscription = !ManageSettingsVariables.dinnerSession4Subscription;
                  }
                });
              },
              checkColor: GlobalVariables.primaryColor,
              fillColor: MaterialStateProperty
                  .resolveWith<Color?>((
                  Set<MaterialState> states) {
                if (states.contains(
                    MaterialState.selected)) {
                  return GlobalVariables.textColor;
                }
                return Colors.white;
              }),
              activeColor: GlobalVariables.textColor,
            ),
          ),

        ],
      ); });
  }

  Widget _buildSessionRowMob(int index, List<SessionData> sessionData, String selectTimeStart, String selectTimeEnd,String meal) {
    String startTime = widget.mealTimingSub[meal]!["Session${index+1}"]!["StartTime"]!;
    String endTime = widget.mealTimingSub[meal]!["Session${index+1}"]!["EndTime"]!;
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    if(sessionData.length == 0) {
      sessionData.add(SessionData(startTime: "", endTime: ""));
    }
    return BlocBuilder<TimeSelectionBloc,TimeSelectState>(builder: (context,state) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Text("B${(index + 1).toString()}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Open Sans',
              fontSize: 12*fem,
              color: GlobalVariables.textColor,
            ),
          ),
          SizedBox(width: 10 * fem,),
          InkWell(
            onTap: () {
              ManageSettingFunction.showTimePickerSubDialog(context,"Session${index+1}","StartTime",meal);
            },
            child: Container(
              height: 40,
              width: 85*fem,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.alarm, color: Color(0xfffbb830), size: 15,),
                    SizedBox(width: 5 * fem,),
                    Text(
                      "${ManageSettingsVariables.mealTimingSub[meal]!["Session${index+1}"]!["StartTime"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Open Sans',
                        fontSize: 11*fem,
                        color: GlobalVariables.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 13*fem),
            child: Text(":",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Open Sans',
                fontSize: 15,
                color: GlobalVariables.textColor,
              ),
            ),
          ),
          SizedBox(width: 13 * fem,),
          InkWell(
            onTap: () {
              ManageSettingFunction.showTimePickerSubDialog(context,"Session${index+1}","EndTime",meal);
            },
            child: Container(
              width:85*fem,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.alarm, color: Color(0xfffbb830), size: 15,),
                    SizedBox(width: 5*fem,),
                    Text("${widget.mealTimingSub[meal]!["Session${index+1}"]!["EndTime"]!}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Open Sans',
                        fontSize: 11*fem,
                        color: GlobalVariables.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
              visible: index >= 0,
              child: SizedBox(width: 7 * fem,)
          ),
          Visibility(
            visible: index >= 0,
            child: InkWell(
              onTap: () {
                setState(() {
                  if(sessionData.length>1)
                    {
                      sessionData.removeAt(index);
                      if(sessionData.length == 0) {
                        widget.mealTimingSub[meal]!["Default"]!["Enabled"] =true;
                        widget.mealTimingSub[meal]!["Session1"]!["Enabled"] = false;
                      }
                    }
                });

              },
              child: Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Center(
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 7 * fem,),
          Visibility(
            visible: index < 2,
            child: InkWell(
              onTap: () {
                setState(() {
                  print("working");
                  if(sessionData.length < 3) {
                    sessionData.add(SessionData(startTime: "", endTime: ""));
                  }
                  widget.mealTimingSub[meal]!["Session${index+2}"]!["Enabled"] = true;
                });
              },
              child: Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xfffbb830),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),

          Visibility(
              visible: index == 3,
              child: SizedBox(width: 25,)),

          Visibility(
              visible: ManageSettingsVariables.restaurantModelController.text == "Both",
              child: SizedBox(width:  25,)),
          Visibility(
            visible: ManageSettingsVariables.restaurantModelController.text == "Both",
            child: Checkbox(value:
            index == 0 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession1Preorder
                :index == 1 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession2Preorder
                : index == 2 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession3Preorder
                : index == 3 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession4Preorder
                : index == 0 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession1Preorder
                : index == 1 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession2Preorder
                : index == 2 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession3Preorder
                : index == 3 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession4Preorder
                : index == 0 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession1Preorder
                : index == 1 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession2Preorder
                : index == 2 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession3Preorder
                : index == 3 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession4Preorder
                : false
              ,
              onChanged: (val){
                setState(() {
                  if(meal == "Breakfast" && index == 0) {
                    ManageSettingsVariables.breakfastSession1Preorder = !ManageSettingsVariables.breakfastSession1Preorder;
                  } else if(meal == "Breakfast" && index == 1) {
                    ManageSettingsVariables.breakfastSession2Preorder = !ManageSettingsVariables.breakfastSession2Preorder;
                  } else if(meal == "Breakfast" && index == 2) {
                    ManageSettingsVariables.breakfastSession3Preorder = !ManageSettingsVariables.breakfastSession3Preorder;
                  } else if(meal == "Breakfast" && index == 3) {
                    ManageSettingsVariables.breakfastSession4Preorder = !ManageSettingsVariables.breakfastSession4Preorder;
                  } else if(meal == "Lunch" && index == 0) {
                    ManageSettingsVariables.lunchSession1Preorder = !ManageSettingsVariables.lunchSession1Preorder;
                  } else if(meal == "Lunch" && index == 1) {
                    ManageSettingsVariables.lunchSession2Preorder = !ManageSettingsVariables.lunchSession2Preorder;
                  } else if(meal == "Lunch" && index == 2) {
                    ManageSettingsVariables.lunchSession3Preorder = !ManageSettingsVariables.lunchSession3Preorder;
                  } else if(meal == "Lunch" && index == 3) {
                    ManageSettingsVariables.lunchSession4Preorder = !ManageSettingsVariables.lunchSession4Preorder;
                  } else if(meal == "Dinner" && index == 0) {
                    ManageSettingsVariables.dinnerSession1Preorder = !ManageSettingsVariables.dinnerSession1Preorder;
                  } else if(meal == "Dinner" && index == 1) {
                    ManageSettingsVariables.dinnerSession2Preorder = !ManageSettingsVariables.dinnerSession2Preorder;
                  } else if(meal == "Dinner" && index == 2) {
                    ManageSettingsVariables.dinnerSession3Preorder = !ManageSettingsVariables.dinnerSession3Preorder;
                  } else if(meal == "Dinner" && index == 3) {
                    ManageSettingsVariables.dinnerSession4Preorder = !ManageSettingsVariables.dinnerSession4Preorder;
                  }
                });
              },
              checkColor: GlobalVariables.primaryColor,
              fillColor: MaterialStateProperty
                  .resolveWith<Color?>((
                  Set<MaterialState> states) {
                if (states.contains(
                    MaterialState.selected)) {
                  return GlobalVariables.textColor;
                }
                return Colors.white;
              }),
              activeColor: GlobalVariables.textColor,
            ),
          ),

          Visibility(
              visible: ManageSettingsVariables.restaurantModelController.text == "Both",
              child: SizedBox(width:  40,)),
          Visibility(
            visible: ManageSettingsVariables.restaurantModelController.text == "Both",
            child: Checkbox(value:
            index == 0 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession1Subscription
                :index == 1 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession2Subscription
                : index == 2 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession3Subscription
                : index == 3 && meal == "Breakfast"
                ? ManageSettingsVariables.breakfastSession4Subscription
                : index == 0 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession1Subscription
                :index == 1 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession2Subscription
                : index == 2 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession3Subscription
                : index == 3 && meal == "Lunch"
                ? ManageSettingsVariables.lunchSession4Subscription
                : index == 0 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession1Subscription
                :index == 1 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession2Subscription
                : index == 2 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession3Subscription
                : index == 3 && meal == "Dinner"
                ? ManageSettingsVariables.dinnerSession4Subscription
                : false
              ,
              onChanged: (val){
                setState(() {
                  if(meal == "Breakfast" && index == 0) {
                    ManageSettingsVariables.breakfastSession1Subscription = !ManageSettingsVariables.breakfastSession1Subscription;
                  } else if(meal == "Breakfast" && index == 1) {
                    ManageSettingsVariables.breakfastSession2Subscription = !ManageSettingsVariables.breakfastSession2Subscription;
                  } else if(meal == "Breakfast" && index == 2) {
                    ManageSettingsVariables.breakfastSession3Subscription = !ManageSettingsVariables.breakfastSession3Subscription;
                  } else if(meal == "Breakfast" && index == 3) {
                    ManageSettingsVariables.breakfastSession4Subscription = !ManageSettingsVariables.breakfastSession4Subscription;
                  } else if(meal == "Lunch" && index == 0) {
                    ManageSettingsVariables.lunchSession1Subscription = !ManageSettingsVariables.lunchSession1Subscription;
                  } else if(meal == "Lunch" && index == 1) {
                    ManageSettingsVariables.lunchSession2Subscription = !ManageSettingsVariables.lunchSession2Subscription;
                  } else if(meal == "Lunch" && index == 2) {
                    ManageSettingsVariables.lunchSession3Subscription = !ManageSettingsVariables.lunchSession3Subscription;
                  } else if(meal == "Lunch" && index == 3) {
                    ManageSettingsVariables.lunchSession4Subscription = !ManageSettingsVariables.lunchSession4Subscription;
                  } else if(meal == "Dinner" && index == 0) {
                    ManageSettingsVariables.dinnerSession1Subscription = !ManageSettingsVariables.dinnerSession1Subscription;
                  } else if(meal == "Dinner" && index == 1) {
                    ManageSettingsVariables.dinnerSession2Subscription = !ManageSettingsVariables.dinnerSession2Subscription;
                  } else if(meal == "Dinner" && index == 2) {
                    ManageSettingsVariables.dinnerSession3Subscription = !ManageSettingsVariables.dinnerSession3Subscription;
                  } else if(meal == "Dinner" && index == 3) {
                    ManageSettingsVariables.dinnerSession4Subscription = !ManageSettingsVariables.dinnerSession4Subscription;
                  }
                });
              },
              checkColor: GlobalVariables.primaryColor,
              fillColor: MaterialStateProperty
                  .resolveWith<Color?>((
                  Set<MaterialState> states) {
                if (states.contains(
                    MaterialState.selected)) {
                  return GlobalVariables.textColor;
                }
                return Colors.white;
              }),
              activeColor: GlobalVariables.textColor,
            ),
          ),

        ],
      ); });
  }

  Widget mealTimeWidget(String meal,bool session,bool sessionPreorder,bool sessionSubscription)
  {
    return Row(
      children: [
        SizedBox(width: 30,),
        Container(
          width: 110,
          child: Text(meal,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF363563),
            ),
          ),
        ),
        SizedBox(width: 45,),
        // timeContainer(widget.mealTiming[meal]!['Default']!['StartTime']!,'Default',"StartTime",meal),
        //
        // BlocBuilder<TimeSelectionBloc,TimeSelectState>(builder: (context,state) {
        //   return TimeController(time: widget.mealTimingSub[meal]!['Default']!['StartTime']!,
        //       session: 'Default', timeString: "StartTime", meal: meal);
        // }),
        //
        //
        // Container(
        //   margin: EdgeInsets.only(left: 25),
        //   child: Text(":",
        //     style: TextStyle(
        //       fontWeight: FontWeight.w600,
        //       fontFamily: 'Open Sans',
        //       fontSize: 15,
        //       color: GlobalVariables.textColor,
        //     ),
        //   ),
        // ),
        // SizedBox(width:  25,),
        // // timeContainer(widget.mealTiming[meal]!['Default']!['EndTime']!,'Default',"EndTime",meal),
        // TimeController(time: widget.mealTimingSub[meal]!['Default']!['EndTime']!,
        //     session: 'Default', timeString: "EndTime", meal: meal),
        // SizedBox(width:  30,),
        // Checkbox(
        //   value: widget.mealTimingSub[meal]!['Default']!['Enabled'], onChanged: (val){
        //   setState(() {
        //     if (meal == "Dinner") {
        //       ManageSettingsVariables.isDinnerSessionEnabled = val ?? false;
        //       if(val == false) {
        //         ManageSettingsVariables.dinnerSessions = [SessionData(startTime: "", endTime: "")];
        //         ManageSettingsVariables.dinnerSession1Preorder = false;
        //         ManageSettingsVariables.dinnerSession2Preorder = false;
        //         ManageSettingsVariables.dinnerSession3Preorder = false;
        //         ManageSettingsVariables.dinnerSession4Preorder = false;
        //         ManageSettingsVariables.dinnerSession1Subscription = false;
        //         ManageSettingsVariables.dinnerSession2Subscription = false;
        //         ManageSettingsVariables.dinnerSession3Subscription = false;
        //         ManageSettingsVariables.dinnerSession4Subscription = false;
        //       }
        //       widget.mealTimingSub["Dinner"]!["Default"]!["Enabled"] = val ?? false;
        //       widget.mealTimingSub["Dinner"]!["Session1"]!["Enabled"] = !widget.mealTimingSub["Dinner"]!["Session1"]!["Enabled"];
        //       _buildSessionRow(0, ManageSettingsVariables.dinnerSessions, ManageSettingsVariables.selectedStartTimeDinner, ManageSettingsVariables.selectedEndTimeDinner,'Dinner');
        //     }
        //     else if (meal == "Lunch") {
        //       ManageSettingsVariables.isLunchSessionEnabled = val ?? false;
        //       if(val == false) {
        //         ManageSettingsVariables.lunchSessions = [SessionData(startTime: "", endTime: "")];
        //         ManageSettingsVariables.lunchSession1Preorder = false;
        //         ManageSettingsVariables.lunchSession2Preorder = false;
        //         ManageSettingsVariables.lunchSession3Preorder = false;
        //         ManageSettingsVariables.lunchSession4Preorder = false;
        //
        //         ManageSettingsVariables.lunchSession1Subscription = false;
        //         ManageSettingsVariables.lunchSession2Subscription = false;
        //         ManageSettingsVariables.lunchSession3Subscription = false;
        //         ManageSettingsVariables.lunchSession4Subscription = false;
        //       }
        //       widget.mealTimingSub["Lunch"]!["Default"]!["Enabled"] = val ?? false;
        //       widget.mealTimingSub["Lunch"]!["Session1"]!["Enabled"] = !widget.mealTimingSub["Lunch"]!["Session1"]!["Enabled"];
        //       _buildSessionRow(0, ManageSettingsVariables.lunchSessions, ManageSettingsVariables.selectedStartTimeLunch, ManageSettingsVariables.selectedEndTimeLunch,'Lunch');
        //     }
        //     else{
        //       ManageSettingsVariables.isBreakfastSessionEnabled = val ?? false;
        //       if(val == false) {
        //         ManageSettingsVariables.sessions = [SessionData(startTime: "", endTime: "")];
        //         ManageSettingsVariables.breakfastSession1Preorder = false;
        //         ManageSettingsVariables.breakfastSession2Preorder = false;
        //         ManageSettingsVariables.breakfastSession3Preorder = false;
        //         ManageSettingsVariables.breakfastSession4Preorder = false;
        //
        //         ManageSettingsVariables.breakfastSession1Subscription = false;
        //         ManageSettingsVariables.breakfastSession2Subscription = false;
        //         ManageSettingsVariables.breakfastSession3Subscription = false;
        //         ManageSettingsVariables.breakfastSession4Subscription = false;
        //       }
        //       widget.mealTimingSub["Breakfast"]!["Default"]!["Enabled"] = val ?? false;
        //       widget.mealTimingSub["Breakfast"]!["Session1"]!["Enabled"] = !widget.mealTimingSub["Breakfast"]!["Session1"]!["Enabled"];
        //       _buildSessionRow(0, ManageSettingsVariables.sessions, ManageSettingsVariables.selectedStartTimeBF, ManageSettingsVariables.selectedEndTimeBF,'Breakfast');
        //     }
        //   });
        // },
        //   checkColor: GlobalVariables.primaryColor,
        //   fillColor: MaterialStateProperty
        //       .resolveWith<Color?>((
        //       Set<MaterialState> states) {
        //     if (states.contains(
        //         MaterialState.selected)) {
        //       return GlobalVariables.textColor;
        //     }
        //     return Colors.white;
        //   }),
        //   activeColor: GlobalVariables.textColor,
        // ),
        // SizedBox(width:  35,),
        //
        // Visibility(
        //   visible: ManageSettingsVariables.restaurantModelController.text == "Both",
        //   child: Checkbox(value: sessionPreorder, onChanged: (val){
        //
        //     setState(() {
        //       if(meal == "Breakfast") {
        //         ManageSettingsVariables.defaultBreakfastPreorder = !ManageSettingsVariables.defaultBreakfastPreorder;
        //       } else if(meal == "Lunch") {
        //         ManageSettingsVariables.defaultLunchPreorder = !ManageSettingsVariables.defaultLunchPreorder;
        //       } else if(meal == "Dinner") {
        //         ManageSettingsVariables.defaultDinnerPreorder = !ManageSettingsVariables.defaultDinnerPreorder;
        //       }
        //
        //     });
        //   },
        //     checkColor: GlobalVariables.primaryColor,
        //     fillColor: MaterialStateProperty
        //         .resolveWith<Color?>((
        //         Set<MaterialState> states) {
        //       if (states.contains(
        //           MaterialState.selected)) {
        //         return GlobalVariables.textColor;
        //       }
        //       return Colors.white;
        //     }),
        //     activeColor: GlobalVariables.textColor,
        //   ),
        // ),
        //
        // SizedBox(width:  40,),
        //
        // Visibility(
        //   visible: ManageSettingsVariables.restaurantModelController.text == "Both",
        //   child: Checkbox(value: sessionSubscription, onChanged: (val){
        //     setState(() {
        //       if(meal == "Breakfast") {
        //         ManageSettingsVariables.defaultBreakfastSubscription = !ManageSettingsVariables.defaultBreakfastSubscription;
        //       } else if(meal == "Lunch") {
        //         ManageSettingsVariables.defaultLunchSubscription = !ManageSettingsVariables.defaultLunchSubscription;
        //       } else {
        //         ManageSettingsVariables.defaultDinnerSubscription = !ManageSettingsVariables.defaultDinnerSubscription;
        //       }
        //     });
        //   },
        //     checkColor: GlobalVariables.primaryColor,
        //     fillColor: MaterialStateProperty
        //         .resolveWith<Color?>((
        //         Set<MaterialState> states) {
        //       if (states.contains(
        //           MaterialState.selected)) {
        //         return GlobalVariables.textColor;
        //       }
        //       return Colors.white;
        //     }),
        //     activeColor: GlobalVariables.textColor,
        //   ),
        // )
      ],
    );
  }

  Widget mealTimeWidgetMob(String meal,bool session,bool sessionPreorder,bool sessionSubscription)
  {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 5*fem),
          width: 75*fem,
          child: Text(meal,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF363563),
            ),
          ),
        ),
        SizedBox(height: 10,),
        // Row(
        //   children: [
        //
        //     SizedBox(width: 35*fem,),
        //     // timeContainer(widget.mealTiming[meal]!['Default']!['StartTime']!,'Default',"StartTime",meal),
        //
        //     BlocBuilder<TimeSelectionBloc,TimeSelectState>(builder: (context,state) {
        //       return TimeControllerMob(time: widget.mealTimingSub[meal]!['Default']!['StartTime']!,
        //           session: 'Default', timeString: "StartTime", meal: meal);
        //     }),
        //
        //
        //     Container(
        //       margin: EdgeInsets.only(left: 13*fem),
        //       child: Text(":",
        //         style: TextStyle(
        //           fontWeight: FontWeight.w600,
        //           fontFamily: 'Open Sans',
        //           fontSize: 12*fem,
        //           color: GlobalVariables.textColor,
        //         ),
        //       ),
        //     ),
        //     SizedBox(width:  13*fem,),
        //     // timeContainer(widget.mealTiming[meal]!['Default']!['EndTime']!,'Default',"EndTime",meal),
        //     TimeControllerMob(time: widget.mealTimingSub[meal]!['Default']!['EndTime']!,
        //         session: 'Default', timeString: "EndTime", meal: meal),
        //     SizedBox(width:  10*fem,),
        //     Checkbox(value: widget.mealTimingSub[meal]!['Default']!['Enabled'], onChanged: (val){
        //       setState(() {
        //         if (meal == "Dinner") {
        //           ManageSettingsVariables.isDinnerSessionEnabled = val ?? false;
        //           if(val == false) {
        //             ManageSettingsVariables.dinnerSessions = [SessionData(startTime: "", endTime: "")];
        //             ManageSettingsVariables.dinnerSession1Preorder = false;
        //             ManageSettingsVariables.dinnerSession2Preorder = false;
        //             ManageSettingsVariables.dinnerSession3Preorder = false;
        //             ManageSettingsVariables.dinnerSession4Preorder = false;
        //             ManageSettingsVariables.dinnerSession1Subscription = false;
        //             ManageSettingsVariables.dinnerSession2Subscription = false;
        //             ManageSettingsVariables.dinnerSession3Subscription = false;
        //             ManageSettingsVariables.dinnerSession4Subscription = false;
        //           }
        //           widget.mealTimingSub["Dinner"]!["Default"]!["Enabled"] = val ?? false;
        //           widget.mealTimingSub["Dinner"]!["Session1"]!["Enabled"] = !widget.mealTimingSub["Dinner"]!["Session1"]!["Enabled"];
        //           _buildSessionRow(0, ManageSettingsVariables.dinnerSessions, ManageSettingsVariables.selectedStartTimeDinner, ManageSettingsVariables.selectedEndTimeDinner,'Dinner');
        //         }
        //         else if (meal == "Lunch") {
        //           ManageSettingsVariables.isLunchSessionEnabled = val ?? false;
        //           if(val == false) {
        //             ManageSettingsVariables.lunchSessions = [SessionData(startTime: "", endTime: "")];
        //             ManageSettingsVariables.lunchSession1Preorder = false;
        //             ManageSettingsVariables.lunchSession2Preorder = false;
        //             ManageSettingsVariables.lunchSession3Preorder = false;
        //             ManageSettingsVariables.lunchSession4Preorder = false;
        //
        //             ManageSettingsVariables.lunchSession1Subscription = false;
        //             ManageSettingsVariables.lunchSession2Subscription = false;
        //             ManageSettingsVariables.lunchSession3Subscription = false;
        //             ManageSettingsVariables.lunchSession4Subscription = false;
        //           }
        //           widget.mealTimingSub["Lunch"]!["Default"]!["Enabled"] = val ?? false;
        //           widget.mealTimingSub["Lunch"]!["Session1"]!["Enabled"] = !widget.mealTimingSub["Lunch"]!["Session1"]!["Enabled"];
        //           _buildSessionRow(0, ManageSettingsVariables.lunchSessions, ManageSettingsVariables.selectedStartTimeLunch, ManageSettingsVariables.selectedEndTimeLunch,'Lunch');
        //         }
        //         else{
        //           ManageSettingsVariables.isBreakfastSessionEnabled = val ?? false;
        //           if(val == false) {
        //             ManageSettingsVariables.sessions = [SessionData(startTime: "", endTime: "")];
        //             ManageSettingsVariables.breakfastSession1Preorder = false;
        //             ManageSettingsVariables.breakfastSession2Preorder = false;
        //             ManageSettingsVariables.breakfastSession3Preorder = false;
        //             ManageSettingsVariables.breakfastSession4Preorder = false;
        //
        //             ManageSettingsVariables.breakfastSession1Subscription = false;
        //             ManageSettingsVariables.breakfastSession2Subscription = false;
        //             ManageSettingsVariables.breakfastSession3Subscription = false;
        //             ManageSettingsVariables.breakfastSession4Subscription = false;
        //           }
        //           widget.mealTimingSub["Breakfast"]!["Default"]!["Enabled"] = val ?? false;
        //           widget.mealTimingSub["Breakfast"]!["Session1"]!["Enabled"] = !widget.mealTimingSub["Breakfast"]!["Session1"]!["Enabled"];
        //           _buildSessionRow(0, ManageSettingsVariables.sessions, ManageSettingsVariables.selectedStartTimeBF, ManageSettingsVariables.selectedEndTimeBF,'Breakfast');
        //         }
        //       });
        //     },
        //       checkColor: GlobalVariables.primaryColor,
        //       fillColor: MaterialStateProperty
        //           .resolveWith<Color?>((
        //           Set<MaterialState> states) {
        //         if (states.contains(
        //             MaterialState.selected)) {
        //           return GlobalVariables.textColor;
        //         }
        //         return Colors.white;
        //       }),
        //       activeColor: GlobalVariables.textColor,
        //     ),
        //
        //
        //     Visibility(
        //       visible: ManageSettingsVariables.restaurantModelController.text == "Both",
        //       child: Checkbox(value: sessionPreorder, onChanged: (val){
        //
        //         setState(() {
        //           if(meal == "Breakfast") {
        //             ManageSettingsVariables.defaultBreakfastPreorder = !ManageSettingsVariables.defaultBreakfastPreorder;
        //           } else if(meal == "Lunch") {
        //             ManageSettingsVariables.defaultLunchPreorder = !ManageSettingsVariables.defaultLunchPreorder;
        //           } else if(meal == "Dinner") {
        //             ManageSettingsVariables.defaultDinnerPreorder = !ManageSettingsVariables.defaultDinnerPreorder;
        //           }
        //
        //         });
        //       },
        //         checkColor: GlobalVariables.primaryColor,
        //         fillColor: MaterialStateProperty
        //             .resolveWith<Color?>((
        //             Set<MaterialState> states) {
        //           if (states.contains(
        //               MaterialState.selected)) {
        //             return GlobalVariables.textColor;
        //           }
        //           return Colors.white;
        //         }),
        //         activeColor: GlobalVariables.textColor,
        //       ),
        //     ),
        //
        //
        //
        //     Visibility(
        //       visible: ManageSettingsVariables.restaurantModelController.text == "Both",
        //       child: Checkbox(value: sessionSubscription, onChanged: (val){
        //         setState(() {
        //           if(meal == "Breakfast") {
        //             ManageSettingsVariables.defaultBreakfastSubscription = !ManageSettingsVariables.defaultBreakfastSubscription;
        //           } else if(meal == "Lunch") {
        //             ManageSettingsVariables.defaultLunchSubscription = !ManageSettingsVariables.defaultLunchSubscription;
        //           } else {
        //             ManageSettingsVariables.defaultDinnerSubscription = !ManageSettingsVariables.defaultDinnerSubscription;
        //           }
        //         });
        //       },
        //         checkColor: GlobalVariables.primaryColor,
        //         fillColor: MaterialStateProperty
        //             .resolveWith<Color?>((
        //             Set<MaterialState> states) {
        //           if (states.contains(
        //               MaterialState.selected)) {
        //             return GlobalVariables.textColor;
        //           }
        //           return Colors.white;
        //         }),
        //         activeColor: GlobalVariables.textColor,
        //       ),
        //     )
        //   ],
        // ),
      ],
    );
  }

}