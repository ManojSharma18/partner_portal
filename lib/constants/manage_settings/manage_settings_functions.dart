
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_event.dart';

import '../../bloc/manage_settings/manage_settings_state.dart';
import '../../bloc/time/time_bloc.dart';
import '../../bloc/time/time_event.dart';
import '../global_variables.dart';
import '../utils.dart';
import 'manage_settings_variables.dart';

class SessionData {
  String startTime;
  String endTime;
  SessionData({required this.startTime, required this.endTime});
}

class ManageSettingFunction{

  static Widget buildSessionRow(int index, List<SessionData> sessionData, String selectTimeStart, String selectTimeEnd,String meal) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("S${(index + 1).toString()}",
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
            // GlobalFunction.showTimePickerDialog(context,"Session${index+1}","StartTime",meal);
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
                  Text(
                    "${ManageSettingsVariables.mealTiming[meal]!["Session${index+1}"]!["StartTime"]}",
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
            // GlobalFunction.showTimePickerDialog(context,"Session${index+1}","EndTime",meal);
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
                  Text("${ManageSettingsVariables.mealTiming[meal]!["Session${index+1}"]!["EndTime"]!}",
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
          visible: index < 3,
          child: InkWell(
            onTap: () {

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

      ],
    );
  }

  static Widget mealTimeWidget(String meal,bool session)
  {
    return Row(
      children: [
        SizedBox(width: 30,),
        Container(
          width: 70,
          child: Text(meal,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Open Sans',
              fontSize: 15,
              color: GlobalVariables.textColor,
            ),
          ),
        ),
        SizedBox(width: 45,),
        // timeContainer(widget.mealTiming[meal]!['Default']!['StartTime']!,'Default',"StartTime",meal),

        // BlocBuilder<TimeSelectionBloc,TimeSelectState>(builder: (context,state) {
        //   return TimeController(time: widget.mealTiming[meal]!['Default']!['StartTime']!,
        //       session: 'Default', timeString: "StartTime", meal: meal);
        // }),


        Container(
          margin: EdgeInsets.only(left: 5),
          child: Text(":",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Open Sans',
              fontSize: 15,
              color: GlobalVariables.textColor,
            ),
          ),
        ),
        SizedBox(width:  25,),
        //timeContainer(widget.mealTiming[meal]!['Default']!['EndTime']!,'Default',"EndTime",meal),
        // TimeController(time: widget.mealTiming[meal]!['Default']!['EndTime']!,
        //     session: 'Default', timeString: "EndTime", meal: meal),
        SizedBox(width:  30,),

      ],
    );
  }

  static bool areAllMealsSelected() {
    return ManageSettingsVariables.mealData.values.isNotEmpty &&
        ManageSettingsVariables.mealData.values.every((dayMeals) =>
            dayMeals.values.every((meal) => meal));
  }

  static void selectAllMeals(bool selected) {
    ManageSettingsVariables.mealData.forEach((day, meals) {
      ManageSettingsVariables.mealData[day]?.updateAll((key, value) => value = selected);
    });
  }

  static bool areAllBreakfastMealsSelected() {
    return ManageSettingsVariables.mealData.values.every((dayMeals) => dayMeals['Breakfast'] ?? false);
  }

  static bool areAllLunchMealsSelected() {
    return ManageSettingsVariables.mealData.values.every((dayMeals) => dayMeals['Lunch'] ?? false);
  }

  static bool areAllDinnerMealsSelected() {
    return ManageSettingsVariables.mealData.values.every((dayMeals) => dayMeals['Dinner'] ?? false);
  }

  static bool areAllMealsSelectedForDay(String day) {
    return ManageSettingsVariables.mealData[day]?.values.every((meal) => meal) ?? false;
  }

  static void selectAllMealsForDay(String day, bool selected) {
    ManageSettingsVariables.mealData[day]?.updateAll((key, value) => value = selected);
  }

  static void enableTimeSession() {

    ManageSettingsVariables.mealData.forEach((day, meals) {
      if (meals['Breakfast'] != true) {
        ManageSettingsVariables.breakfast = false;
      }
    });

    ManageSettingsVariables.mealData.forEach((day, meals) {
      if (meals['Lunch'] != true) {
        ManageSettingsVariables.lunch = false;
      }
    });

    ManageSettingsVariables.mealData.forEach((day, meals) {
      if (meals['Dinner'] != true) {
        ManageSettingsVariables.dinner = false;
      }
    });

    ManageSettingsVariables.mealData.forEach((day, meals) {
      if (meals['Breakfast'] == true) {
        ManageSettingsVariables.breakfast = true;
      }
    });

    ManageSettingsVariables.mealData.forEach((day, meals) {
      if (meals['Lunch'] == true) {
        ManageSettingsVariables.lunch = true;
      }
    });

    ManageSettingsVariables.mealData.forEach((day, meals) {
      if (meals['Dinner'] == true) {
        ManageSettingsVariables.dinner = true;
      }
    });
  }


  static bool areAllMealsSelectedSub() {
    return ManageSettingsVariables.mealDataSub.values.isNotEmpty &&
        ManageSettingsVariables.mealDataSub.values.every((dayMeals) =>
            dayMeals.values.every((meal) => meal));
  }

  static void selectAllMealsSub(bool selected) {
    ManageSettingsVariables.mealDataSub.forEach((day, meals) {
      ManageSettingsVariables.mealDataSub[day]?.updateAll((key, value) => value = selected);
    });
  }

  static bool areAllBreakfastMealsSelectedSub() {
    return ManageSettingsVariables.mealDataSub.values.every((dayMeals) => dayMeals['Breakfast'] ?? false);
  }

  static bool areAllLunchMealsSelectedSub() {
    return ManageSettingsVariables.mealDataSub.values.every((dayMeals) => dayMeals['Lunch'] ?? false);
  }

  static bool areAllDinnerMealsSelectedSub() {
    return ManageSettingsVariables.mealDataSub.values.every((dayMeals) => dayMeals['Dinner'] ?? false);
  }

  static bool areAllMealsSelectedForDaySub(String day) {
    return ManageSettingsVariables.mealDataSub[day]?.values.every((meal) => meal) ?? false;
  }

  static void selectAllMealsForDaySub(String day, bool selected) {
    ManageSettingsVariables.mealDataSub[day]?.updateAll((key, value) => value = selected);
  }

  static void enableTimeSessionSub() {

    ManageSettingsVariables.mealDataSub.forEach((day, meals) {
      if (meals['Breakfast'] != true) {
        ManageSettingsVariables.breakfast = false;
      }
    });

    ManageSettingsVariables.mealDataSub.forEach((day, meals) {
      if (meals['Lunch'] != true) {
        ManageSettingsVariables.lunch = false;
      }
    });

    ManageSettingsVariables.mealDataSub.forEach((day, meals) {
      if (meals['Dinner'] != true) {
        ManageSettingsVariables.dinner = false;
      }
    });

    ManageSettingsVariables.mealDataSub.forEach((day, meals) {
      if (meals['Breakfast'] == true) {
        ManageSettingsVariables.breakfast = true;
      }
    });

    ManageSettingsVariables.mealDataSub.forEach((day, meals) {
      if (meals['Lunch'] == true) {
        ManageSettingsVariables.lunch = true;
      }
    });

    ManageSettingsVariables.mealDataSub.forEach((day, meals) {
      if (meals['Dinner'] == true) {
        ManageSettingsVariables.dinner = true;
      }
    });
  }

  static TimeOfDay buildTimeOfDay(int selectedHour, int selectedMinute, bool isAM) {
    if (!isAM && selectedHour != 12) {
      selectedHour += 12;
    }
    return TimeOfDay(hour: selectedHour % 24, minute: selectedMinute);
  }

  static bool isTimeInRange(TimeOfDay time, TimeOfDay start, TimeOfDay end) {

    int currentTimeInMinutes = time.hour * 60 + time.minute;
    int startTimeInMinutes = start.hour * 60 + start.minute;
    int endTimeInMinutes = end.hour * 60 + end.minute;
    return currentTimeInMinutes > startTimeInMinutes && currentTimeInMinutes < endTimeInMinutes;
  }

  // static void showTimePickerDialog(BuildContext context,String session,String timeString,String meal) async {
  //   bool move = true;
  //   double baseWidth = 375;
  //   double fem = MediaQuery.of(context).size.width / baseWidth;
  //   double ffem = fem * 0.97;
  //   final updatedTime = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       TimeOfDay updatedTime = TimeOfDay(hour: GlobalVariables.currentTime.hour + 1, minute: GlobalVariables.currentTime.minute);
  //       return StatefulBuilder(
  //         builder: (BuildContext context,
  //             void Function(void Function()) setState) {
  //           return AlertDialog(
  //             title: Text('Select Time'),
  //             content: Container(
  //               width: 350,
  //               height: 300,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       _buildScrollableList(
  //                         values: List.generate(12, (index) => index + 1),
  //                         onChanged: (value) {
  //                           setState(() {
  //                             GlobalVariables.selectedHour = value; // Update the selected hour value
  //                           });
  //                         },
  //                         selectedValue: GlobalVariables.selectedHour, // Pass the selected hour value
  //                       ),
  //                       Text(":", style: TextStyle(
  //                         fontSize: 35,
  //                       ),),
  //                       _buildScrollableList(
  //                         values: [00, 15, 30, 45],
  //                         onChanged: (value) {
  //                           setState(() {
  //                             GlobalVariables.selectedMinute =
  //                                 value; // Update the selected minute value
  //                           });
  //                         },
  //                         selectedValue: GlobalVariables.selectedMinute, // Pass the selected minute value
  //                       ),
  //                       _buildAMPMSelector(
  //                         isAM: GlobalVariables.isAM,
  //                         onAMPMChanged: (value) {
  //                           setState(() {
  //                             GlobalVariables.isAM = value; // Update the AM/PM value in the state
  //                           });
  //                         },
  //                       ),
  //
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             actions: [
  //               GestureDetector(
  //                 onTap: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  //                   child: Text(
  //                     'CANCEL',
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.w600,
  //                       height: 1.3298874768 * ffem / fem,
  //                       color: Color(0xfffbb830),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               GestureDetector(
  //                 onTap: () {
  //
  //                   if (isBreakfastTime(GlobalVariables.selectedHour, GlobalVariables.isAM)) {
  //                     TimeOfDay time = buildTimeOfDay(GlobalVariables.selectedHour, GlobalVariables.selectedMinute, GlobalVariables.isAM);
  //                     if(meal == "Breakfast")
  //                     {
  //                       if (isTimeInRange(time, TimeOfDay(hour: 2, minute: 0), TimeOfDay(hour: 11, minute: 59)))
  //                       {
  //                         UtilFunctions.mealTiming[meal]![session]![timeString] = buildTimeOfDay(GlobalVariables.selectedHour, GlobalVariables.selectedMinute, GlobalVariables.isAM).format(context);
  //                       }
  //                       else{
  //                         print("Invalid time");
  //                       }
  //                     }
  //                   }
  //                   else {
  //                     print('Selected time is outside the allowed range for breakfast.');
  //                   }
  //                   updatedTime =  TimeOfDay(hour: GlobalVariables.currentTime.hour + 1, minute: GlobalVariables.currentTime.minute);
  //                   Navigator.of(context).pop(updatedTime);
  //                 },
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  //                   child: Text(
  //                     'OK',
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.w600,
  //                       height: 1.3298874768 * ffem / fem,
  //                       color: Color(0xfffbb830),
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  //
  //
  //   if (updatedTime != null) {
  //     TimeOfDay time = buildTimeOfDay(GlobalVariables.selectedHour, GlobalVariables.selectedMinute, GlobalVariables.isAM);
  //     if(meal == "Breakfast")
  //     {
  //       if (isTimeInRange(time, TimeOfDay(hour: 2, minute: 0), TimeOfDay(hour: 11, minute: 59)))
  //       {
  //         UtilFunctions.mealTiming[meal]![session]![timeString] = buildTimeOfDay(GlobalVariables.selectedHour, GlobalVariables.selectedMinute, GlobalVariables.isAM).format(context);
  //       }
  //       else{
  //         showSnackBar(context, "Please select the time between 02:00 AM to 12:00 PM");
  //         move = false;
  //       }
  //     }
  //     else if(meal == "Lunch"){
  //       if (isTimeInRange(time, TimeOfDay(hour: 4, minute: 30), TimeOfDay(hour: 16, minute: 30)))
  //       {
  //         UtilFunctions.mealTiming[meal]![session]![timeString] = buildTimeOfDay(GlobalVariables.selectedHour, GlobalVariables.selectedMinute, GlobalVariables.isAM).format(context);
  //       }
  //       else{
  //         showSnackBar(context, "Please select the time between 04:30 AM to 04:30 PM");
  //         move = false;
  //
  //       }
  //     }
  //     else if(meal == "Dinner"){
  //       if (isTimeInRange(time, TimeOfDay(hour: 16, minute: 30), TimeOfDay(hour: 23, minute: 59)))
  //       {
  //         UtilFunctions.mealTiming[meal]![session]![timeString] = buildTimeOfDay(GlobalVariables.selectedHour, GlobalVariables.selectedMinute, GlobalVariables.isAM).format(context);
  //       }
  //       else{
  //         showSnackBar(context, "Please select the time between 04:30 PM to 02:00 AM");
  //         move = false;
  //       }
  //     }
  //   }
  //   if(move)
  //   {
  //     TimeOfDay timeOfDay = TimeOfDay(hour: !GlobalVariables.isAM ? GlobalVariables.selectedHour+12 : GlobalVariables.selectedHour, minute: GlobalVariables.selectedMinute);
  //     print("Time of the day $timeOfDay");
  //     BlocProvider.of<TimeSelectionBloc>(context).add(
  //       SelectTimeEvent(timeOfDay, meal, session, timeString,context),
  //     );
  //   }
  //
  // }

  static void showTimePickerDialog(BuildContext managecontext,String session,String timeString,String meal) async {
    bool move = true;
    double baseWidth = 375;
    double fem = MediaQuery.of(managecontext).size.width / baseWidth;
    double ffem = fem * 0.97;
    final updatedTime = await showDialog(
      context: managecontext,
      builder: (BuildContext context) {
        TimeOfDay? updatedTime = TimeOfDay(hour: ManageSettingsVariables.currentTime.hour + 1, minute: ManageSettingsVariables.currentTime.minute);
        return BlocBuilder<ManageSettingsBloc,ManageSettingState>(builder: (BuildContext context, state) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return AlertDialog(
                title: Text('Select Time'),
                content: Container(
                  width: 350,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildScrollableList(
                            values: List.generate(12, (index) => index + 1),
                            onChanged: (value) {
                              setState(() {
                                ManageSettingsVariables.selectedHour = value; // Update the selected hour value
                              });
                            },
                            selectedValue: ManageSettingsVariables.selectedHour, // Pass the selected hour value
                          ),
                          Text(":", style: TextStyle(
                            fontSize: 35,
                          ),),
                          _buildScrollableList(
                            values: [00, 15, 30, 45],
                            onChanged: (value) {
                              setState(() {
                                ManageSettingsVariables.selectedMinute =
                                    value; // Update the selected minute value
                              });
                            },
                            selectedValue: ManageSettingsVariables.selectedMinute, // Pass the selected minute value
                          ),
                          _buildAMPMSelector(
                            isAM: ManageSettingsVariables.isAM,
                            onAMPMChanged: (value) {
                              setState(() {
                                ManageSettingsVariables.isAM = value; // Update the AM/PM value in the state
                              });
                            },
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      updatedTime = null;
                      move = false;
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.3298874768 * ffem / fem,
                          color: Color(0xfffbb830),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                      TimeOfDay time = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM);

                      if(meal == "Breakfast")
                      {
                        if(timeString == "StartTime")
                        {
                          if (isTimeInRange(time, TimeOfDay(hour: 2, minute: 0), TimeOfDay(hour: 11, minute: 59)))
                          {
                            ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                            Navigator.of(context).pop(updatedTime);
                          }
                          else {
                            Flushbar(
                              title: "Time out of range",
                              backgroundGradient: LinearGradient(
                                colors: [GlobalVariables.textColor, Colors.teal],
                              ),
                              backgroundColor: Colors.red,
                              messageText: Text('Please select the time between 02:00 AM to 12:00 PM',style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.primaryColor,
                              )),
                              boxShadows: [
                                BoxShadow(
                                  color: GlobalVariables.textColor,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                              duration: Duration(seconds: 2),
                            ).show(context);
                          }
                        }
                        else {
                          if (isTimeInRange(time, TimeOfDay(hour: 2, minute: 0), TimeOfDay(hour: 11, minute: 59)))
                          {
                            if(session == "Session2"){
                              if(ManageSettingsVariables.mealTiming['Breakfast']!['Session1']!['EndTime'] != '-- -- --') {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']!['Session1']!['EndTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session2 end time should be greater than session1 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                } else {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session2 end time should not be equal to session1 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }
                              else {

                                if(ManageSettingsVariables.mealTiming['Breakfast']![session]!['StartTime'] != '-- -- --')
                                {
                                  TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']![session]!['StartTime']);
                                  int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                  if (comparisonResult < 0) {
                                    Navigator.of(context).pop(updatedTime);
                                    ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                  }
                                  else if (comparisonResult > 0) {
                                    Flushbar(
                                      title: "Time validation",
                                      message: 'End time should be greater than start time kdsf d',
                                      backgroundGradient: LinearGradient(
                                        colors: [GlobalVariables.textColor, Colors.teal],
                                      ),
                                      backgroundColor: Colors.red,
                                      boxShadows: [
                                        BoxShadow(
                                          color: GlobalVariables.textColor,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                      duration: Duration(seconds: 2),
                                    ).show(context);
                                  }
                                }
                                else {
                                  showFlushbar(context,"Time selection validation","Select start time before end time");
                                }

                              }
                            }
                            else if(session == "Session3") {
                              if(ManageSettingsVariables.mealTiming['Breakfast']!['Session2']!['EndTime'] != '-- -- --') {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']!['Session2']!['EndTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session3 end time should be greater than session2 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                } else {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session3 end time should not be equal to session2 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }

                              else {
                                if(ManageSettingsVariables.mealTiming['Breakfast']![session]!['StartTime'] != '-- -- --') {
                                  TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']![session]!['StartTime']);
                                  int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                  if (comparisonResult < 0) {
                                    Navigator.of(context).pop(updatedTime);
                                    ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                  }
                                  else if (comparisonResult > 0) {
                                    Flushbar(
                                      title: "Time validation",
                                      message: 'End time should be greater than start time',
                                      backgroundGradient: LinearGradient(
                                        colors: [GlobalVariables.textColor, Colors.teal],
                                      ),
                                      backgroundColor: Colors.red,
                                      boxShadows: [
                                        BoxShadow(
                                          color: GlobalVariables.textColor,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                      duration: Duration(seconds: 2),
                                    ).show(context);
                                  }
                                } else {
                                  showFlushbar(context,"Time selection validation","Select start time before end time");
                                }


                              }
                            }
                            else {
                              if(ManageSettingsVariables.mealTiming['Breakfast']![session]!['StartTime'] != '-- -- --' )
                              {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']![session]!['StartTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'End time should be greater than start time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }
                              else{
                                showFlushbar(context,"Time selection validation","Select start time before end time");
                              }
                            }



                          }
                          else{
                            Flushbar(
                              title: "Time out of range",
                              message: 'Please select the time between 02:00 AM to 12:00 PM',
                              backgroundGradient: LinearGradient(
                                colors: [GlobalVariables.textColor, Colors.teal],
                              ),
                              backgroundColor: Colors.red,
                              boxShadows: [
                                BoxShadow(
                                  color: GlobalVariables.textColor,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                              duration: Duration(seconds: 2),
                            ).show(context);
                          }

                        }
                      } else if(meal == "Lunch")
                      {

                        if(timeString == "StartTime")
                        {
                          if (isTimeInRange(time, TimeOfDay(hour: 4, minute: 30), TimeOfDay(hour: 16, minute: 30)))
                          {
                            ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                            Navigator.of(context).pop(updatedTime);
                          }
                          else {
                            Flushbar(
                              title: "Time out of range",
                              backgroundGradient: LinearGradient(
                                colors: [GlobalVariables.textColor, Colors.teal],
                              ),
                              backgroundColor: Colors.red,
                              messageText: Text('Please select the time between 04:00 AM to 04:00 PM',style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.primaryColor,
                              )),
                              boxShadows: [
                                BoxShadow(
                                  color: GlobalVariables.textColor,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                              duration: Duration(seconds: 2),
                            ).show(context);
                          }
                        }
                        else {
                          if (isTimeInRange(time, TimeOfDay(hour: 4, minute: 30), TimeOfDay(hour: 16, minute: 30)))
                          {
                            if(session == "Session2"){
                              if(ManageSettingsVariables.mealTiming['Lunch']!['Session1']!['EndTime'] != '-- -- --') {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Lunch']!['Session1']!['EndTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session2 end time should be greater than session1 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                } else {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session2 end time should not be equal to session1 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }
                              else {

                                if(ManageSettingsVariables.mealTiming['Lunch']![session]!['StartTime'] != '-- -- --')
                                {
                                  TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Lunch']![session]!['StartTime']);
                                  int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                  if (comparisonResult < 0) {
                                    Navigator.of(context).pop(updatedTime);
                                    ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                  }
                                  else if (comparisonResult > 0) {
                                    Flushbar(
                                      title: "Time validation",
                                      message: 'End time should be greater than start time kdsf d',
                                      backgroundGradient: LinearGradient(
                                        colors: [GlobalVariables.textColor, Colors.teal],
                                      ),
                                      backgroundColor: Colors.red,
                                      boxShadows: [
                                        BoxShadow(
                                          color: GlobalVariables.textColor,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                      duration: Duration(seconds: 2),
                                    ).show(context);
                                  }
                                }
                                else {
                                  showFlushbar(context,"Time selection validation","Select start time before end time");
                                }

                              }
                            }
                            else if(session == "Session3") {
                              if(ManageSettingsVariables.mealTiming['Lunch']!['Session2']!['EndTime'] != '-- -- --') {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Lunch']!['Session2']!['EndTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session3 end time should be greater than session2 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                } else {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session3 end time should not be equal to session2 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }

                              else {
                                if(ManageSettingsVariables.mealTiming['Lunch']![session]!['StartTime'] != '-- -- --') {
                                  TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Lunch']![session]!['StartTime']);
                                  int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                  if (comparisonResult < 0) {
                                    Navigator.of(context).pop(updatedTime);
                                    ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                  }
                                  else if (comparisonResult > 0) {
                                    Flushbar(
                                      title: "Time validation",
                                      message: 'End time should be greater than start time',
                                      backgroundGradient: LinearGradient(
                                        colors: [GlobalVariables.textColor, Colors.teal],
                                      ),
                                      backgroundColor: Colors.red,
                                      boxShadows: [
                                        BoxShadow(
                                          color: GlobalVariables.textColor,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                      duration: Duration(seconds: 2),
                                    ).show(context);
                                  }
                                } else {
                                  showFlushbar(context,"Time selection validation","Select start time before end time");
                                }


                              }
                            }
                            else {
                              if(ManageSettingsVariables.mealTiming['Lunch']![session]!['StartTime'] != '-- -- --' )
                              {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Lunch']![session]!['StartTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'End time should be greater than start time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }
                              else{
                                showFlushbar(context,"Time selection validation","Select start time before end time");
                              }
                            }



                          }
                          else{
                            Flushbar(
                              title: "Time out of range",
                              message: 'Please select the time between 04:00 AM to 04:00 PM',
                              backgroundGradient: LinearGradient(
                                colors: [GlobalVariables.textColor, Colors.teal],
                              ),
                              backgroundColor: Colors.red,
                              boxShadows: [
                                BoxShadow(
                                  color: GlobalVariables.textColor,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                              duration: Duration(seconds: 2),
                            ).show(context);
                          }

                        }
                      } else if(meal == "Dinner")
                      {
                        if(timeString == "StartTime")
                        {
                          if (isTimeInRange(time, TimeOfDay(hour: 16, minute: 30), TimeOfDay(hour: 23, minute: 59)))
                          {
                            ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                            Navigator.of(context).pop(updatedTime);
                          }
                          else {
                            Flushbar(
                              title: "Time out of range",
                              backgroundGradient: LinearGradient(
                                colors: [GlobalVariables.textColor, Colors.teal],
                              ),
                              backgroundColor: Colors.red,
                              messageText: Text('Please select the time between 04:00 AM to 11:59 PM',style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.primaryColor,
                              )),
                              boxShadows: [
                                BoxShadow(
                                  color: GlobalVariables.textColor,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                              duration: Duration(seconds: 2),
                            ).show(context);
                          }
                        }
                        else {
                          if (isTimeInRange(time, TimeOfDay(hour: 16, minute: 30), TimeOfDay(hour: 23, minute: 59)))
                          {
                            if(session == "Session2"){
                              if(ManageSettingsVariables.mealTiming['Dinner']!['Session1']!['EndTime'] != '-- -- --') {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Dinner']!['Session1']!['EndTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session2 end time should be greater than session1 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                } else {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session2 end time should not be equal to session1 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }
                              else {

                                if(ManageSettingsVariables.mealTiming['Dinner']![session]!['StartTime'] != '-- -- --')
                                {
                                  TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Dinner']![session]!['StartTime']);
                                  int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                  if (comparisonResult < 0) {
                                    Navigator.of(context).pop(updatedTime);
                                    ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                  }
                                  else if (comparisonResult > 0) {
                                    Flushbar(
                                      title: "Time validation",
                                      message: 'End time should be greater than start time',
                                      backgroundGradient: LinearGradient(
                                        colors: [GlobalVariables.textColor, Colors.teal],
                                      ),
                                      backgroundColor: Colors.red,
                                      boxShadows: [
                                        BoxShadow(
                                          color: GlobalVariables.textColor,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                      duration: Duration(seconds: 2),
                                    ).show(context);
                                  }
                                }
                                else {
                                  showFlushbar(context,"Time selection validation","Select start time before end time");
                                }

                              }
                            }
                            else if(session == "Session3") {
                              if(ManageSettingsVariables.mealTiming['Dinner']!['Session2']!['EndTime'] != '-- -- --') {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Dinner']!['Session2']!['EndTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session3 end time should be greater than session2 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                } else {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session3 end time should not be equal to session2 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }

                              else {
                                if(ManageSettingsVariables.mealTiming['Dinner']![session]!['StartTime'] != '-- -- --') {
                                  TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Dinner']![session]!['StartTime']);
                                  int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                  if (comparisonResult < 0) {
                                    Navigator.of(context).pop(updatedTime);
                                    ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                  }
                                  else if (comparisonResult > 0) {
                                    Flushbar(
                                      title: "Time validation",
                                      message: 'End time should be greater than start time',
                                      backgroundGradient: LinearGradient(
                                        colors: [GlobalVariables.textColor, Colors.teal],
                                      ),
                                      backgroundColor: Colors.red,
                                      boxShadows: [
                                        BoxShadow(
                                          color: GlobalVariables.textColor,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                      duration: Duration(seconds: 2),
                                    ).show(context);
                                  }
                                } else {
                                  showFlushbar(context,"Time selection validation","Select start time before end time");
                                }


                              }
                            }
                            else {
                              if(ManageSettingsVariables.mealTiming['Dinner']![session]!['StartTime'] != '-- -- --' )
                              {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Dinner']![session]!['StartTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'End time should be greater than start time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }
                              else{
                                showFlushbar(context,"Time selection validation","Select start time before end time");
                              }
                            }



                          }
                          else{
                            Flushbar(
                              title: "Time out of range",
                              message: 'Please select the time between 04:00 AM to 11:59 PM',
                              backgroundGradient: LinearGradient(
                                colors: [GlobalVariables.textColor, Colors.teal],
                              ),
                              backgroundColor: Colors.red,
                              boxShadows: [
                                BoxShadow(
                                  color: GlobalVariables.textColor,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                              duration: Duration(seconds: 2),
                            ).show(context);
                          }

                        }
                      }
                      updatedTime =  TimeOfDay(hour: ManageSettingsVariables.currentTime.hour + 1, minute: ManageSettingsVariables.currentTime.minute);


                      ManageSettingsVariables.breakfastTimings = [];
                      ManageSettingsVariables.lunchTimings = [];
                      ManageSettingsVariables.dinnerTimings = [];

                      setState(() {
                        ManageSettingsVariables.mealTiming.forEach((mealType, sessions) {
                          sessions.forEach((session, timing) {
                            String startTime = timing['StartTime'];
                            String endTime = timing['EndTime'];

                            if(mealType == "Breakfast" && startTime != '-- -- --' )
                            {
                              ManageSettingsVariables.breakfastTimings.add(startTime);
                            }
                            else if(mealType == "Lunch" && startTime != '-- -- --')
                            {
                              ManageSettingsVariables.lunchTimings.add(startTime);
                            }
                            else if(mealType == "Dinner" && startTime != '-- -- --'){
                              ManageSettingsVariables.dinnerTimings.add(startTime);
                            }

                            if(mealType == "Breakfast" && endTime != '-- -- --' )
                            {
                              ManageSettingsVariables.breakfastTimings.add(endTime);
                            }
                            else if(mealType == "Lunch" && endTime != '-- -- --')
                            {
                              ManageSettingsVariables.lunchTimings.add(endTime);
                            }
                            else if(mealType == "Dinner" && endTime != '-- -- --'){
                              ManageSettingsVariables.dinnerTimings.add(endTime);
                            }

                            ManageSettingsVariables.breakfastTimings.sort((a, b) => parseTime(a).compareTo(parseTime(b)));
                            ManageSettingsVariables.lunchTimings.sort((a, b) => parseTime(a).compareTo(parseTime(b)));
                            ManageSettingsVariables.dinnerTimings.sort((a, b) => parseTime(a).compareTo(parseTime(b)));

                            print("Start time for breakfast ${ManageSettingsVariables.breakfastTimings}");
                            print("Start time for Lunch ${ManageSettingsVariables.lunchTimings}");
                            print("Start time for dinner ${ManageSettingsVariables.dinnerTimings}");
                          });
                        });
                      });

                      ManageSettingsVariables.mealTiming['Breakfast']!['Default']!['StartTime'];
                      managecontext.read<ManageSettingsBloc>().add(SetMealSessionTimeEvent(context));

                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.3298874768 * ffem / fem,
                          color: Color(0xfffbb830),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },

        );
      },
    );

    if (updatedTime != null) {
      TimeOfDay time = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM);
      if(meal == "Breakfast")
      {
        if (isTimeInRange(time, TimeOfDay(hour: 2, minute: 0), TimeOfDay(hour: 11, minute: 59)))
        {
          if(timeString == "StartTime")
          {
            if (isTimeInRange(time, TimeOfDay(hour: 2, minute: 0), TimeOfDay(hour: 11, minute: 59)))
            {
              ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
            }
            else{
              print("Invalid time");
            }
          }
          else {
            if (isTimeInRange(time, TimeOfDay(hour: 2, minute: 0), TimeOfDay(hour: 11, minute: 59)))
            {
              if(ManageSettingsVariables.mealTiming['Breakfast']![session]!['StartTime'] != '-- -- --' )
              {
                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']![session]!['StartTime']);

                int comparisonResult = compareTimeOfDay(timeOfDay, time);

                if (comparisonResult < 0) {
                  ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
                }
                else if (comparisonResult > 0) {
                  // showFlushbar(managecontext, "Time validation", 'End time should be greater than start time');
                } else {
                  print('${formatTimeOfDay(timeOfDay)} is the same as ${formatTimeOfDay(time)}');
                }

              }
              else {

              }

            }
            else{
              print("Invalid time");
            }

          }
          // ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour,ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
        }
        else{
          showSnackBar(managecontext, "Please select the time between 02:00 AM to 12:00 PM");
          move = false;
        }
      }
      else if(meal == "Lunch"){
        if (isTimeInRange(time, TimeOfDay(hour: 4, minute: 30), TimeOfDay(hour: 16, minute: 30)))
        {
          if(timeString == "StartTime")
          {
            if (isTimeInRange(time, TimeOfDay(hour: 4, minute: 40), TimeOfDay(hour: 16, minute: 30)))
            {
              ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
            }
            else{
              print("Invalid time");
            }
          }
          else {
            if (isTimeInRange(time, TimeOfDay(hour: 4, minute: 30), TimeOfDay(hour: 16, minute: 30)))
            {
              if(ManageSettingsVariables.mealTiming['Lunch']![session]!['StartTime'] != '-- -- --' )
              {
                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Lunch']![session]!['StartTime']);

                int comparisonResult = compareTimeOfDay(timeOfDay, time);

                if (comparisonResult < 0) {
                  ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
                } else if (comparisonResult > 0) {
                  showFlushbar(managecontext, "Time validation", 'End time should be greater than start time');
                } else {
                  print('${formatTimeOfDay(timeOfDay)} is the same as ${formatTimeOfDay(time)}');
                }

              }
              else {

              }

            }
            else{
              print("Invalid time");
            }

          }
          // ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour,ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
        }
        else{
          showSnackBar(managecontext, "Please select the time between 04:30 AM to 04:30 PM");
          move = false;

        }
      }
      else if(meal == "Dinner"){
        if (isTimeInRange(time, TimeOfDay(hour: 16, minute: 30), TimeOfDay(hour: 23, minute: 59)))
        {
          if(timeString == "StartTime")
          {
            if (isTimeInRange(time, TimeOfDay(hour: 16, minute: 30), TimeOfDay(hour: 23, minute: 59)))
            {
              ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
            }
            else{
              print("Invalid time");
            }
          }
          else {
            if (isTimeInRange(time, TimeOfDay(hour: 16, minute: 30), TimeOfDay(hour: 23, minute: 59)))
            {
              if(ManageSettingsVariables.mealTiming['Dinner']![session]!['StartTime'] != '-- -- --' )
              {
                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTiming['Dinner']![session]!['StartTime']);

                int comparisonResult = compareTimeOfDay(timeOfDay, time);

                if (comparisonResult < 0) {
                  ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
                } else if (comparisonResult > 0) {
                  showFlushbar(managecontext, "Time validation", 'End time should be greater than start time');
                } else {
                  print('${formatTimeOfDay(timeOfDay)} is the same as ${formatTimeOfDay(time)}');
                }

              }
              else {

              }

            }
            else{
              print("Invalid time");
            }

          }
          // ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour,ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
        }
        else{
          showSnackBar(managecontext, "Please select the time between 04:30 AM to 04:30 PM");
          move = false;

        }
      }
    }
    if(move)
    {
      TimeOfDay timeOfDay = TimeOfDay(hour: !ManageSettingsVariables.isAM ? ManageSettingsVariables.selectedHour+12 : ManageSettingsVariables.selectedHour, minute: ManageSettingsVariables.selectedMinute);
      print("Time of the day $timeOfDay");
      BlocProvider.of<TimeSelectionBloc>(managecontext).add(
        SelectTimeEvent(timeOfDay, meal, session, timeString,managecontext),
      );
    }

  }

  static void showTimePickerSubDialog(BuildContext managecontext,String session,String timeString,String meal) async {
    bool move = true;
    double baseWidth = 375;
    double fem = MediaQuery.of(managecontext).size.width / baseWidth;
    double ffem = fem * 0.97;
    final updatedTime = await showDialog(
      context: managecontext,
      builder: (BuildContext context) {
        TimeOfDay? updatedTime = TimeOfDay(hour: ManageSettingsVariables.currentTime.hour + 1, minute: ManageSettingsVariables.currentTime.minute);
        return BlocBuilder<ManageSettingsBloc,ManageSettingState>(builder: (BuildContext context, state) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return AlertDialog(
                title: Text('Select Time'),
                content: Container(
                  width: 350,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildScrollableList(
                            values: List.generate(12, (index) => index + 1),
                            onChanged: (value) {
                              setState(() {
                                ManageSettingsVariables.selectedHour = value; // Update the selected hour value
                              });
                            },
                            selectedValue: ManageSettingsVariables.selectedHour, // Pass the selected hour value
                          ),
                          Text(":", style: TextStyle(
                            fontSize: 35,
                          ),),
                          _buildScrollableList(
                            values: [00, 15, 30, 45],
                            onChanged: (value) {
                              setState(() {
                                ManageSettingsVariables.selectedMinute =
                                    value; // Update the selected minute value
                              });
                            },
                            selectedValue: ManageSettingsVariables.selectedMinute, // Pass the selected minute value
                          ),
                          _buildAMPMSelector(
                            isAM: ManageSettingsVariables.isAM,
                            onAMPMChanged: (value) {
                              setState(() {
                                ManageSettingsVariables.isAM = value; // Update the AM/PM value in the state
                              });
                            },
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      updatedTime = null;
                      move = false;
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.3298874768 * ffem / fem,
                          color: Color(0xfffbb830),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                      TimeOfDay time = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM);

                      if(meal == "Breakfast")
                      {
                        if(timeString == "StartTime")
                        {
                          if (isTimeInRange(time, TimeOfDay(hour: 2, minute: 0), TimeOfDay(hour: 11, minute: 59)))
                          {
                            ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                            Navigator.of(context).pop(updatedTime);
                          }
                          else {
                            Flushbar(
                              title: "Time out of range",
                              backgroundGradient: LinearGradient(
                                colors: [GlobalVariables.textColor, Colors.teal],
                              ),
                              backgroundColor: Colors.red,
                              messageText: Text('Please select the time between 02:00 AM to 12:00 PM',style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.primaryColor,
                              )),
                              boxShadows: [
                                BoxShadow(
                                  color: GlobalVariables.textColor,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                              duration: Duration(seconds: 2),
                            ).show(context);
                          }
                        }
                        else {
                          if (isTimeInRange(time, TimeOfDay(hour: 2, minute: 0), TimeOfDay(hour: 11, minute: 59)))
                          {
                            if(session == "Session2"){
                              if(ManageSettingsVariables.mealTimingSub['Breakfast']!['Session1']!['EndTime'] != '-- -- --') {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Breakfast']!['Session1']!['EndTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session2 end time should be greater than session1 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                } else {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session2 end time should not be equal to session1 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }
                              else {

                                if(ManageSettingsVariables.mealTimingSub['Breakfast']![session]!['StartTime'] != '-- -- --')
                                {
                                  TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Breakfast']![session]!['StartTime']);
                                  int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                  if (comparisonResult < 0) {
                                    Navigator.of(context).pop(updatedTime);
                                    ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                  }
                                  else if (comparisonResult > 0) {
                                    Flushbar(
                                      title: "Time validation",
                                      message: 'End time should be greater than start time kdsf d',
                                      backgroundGradient: LinearGradient(
                                        colors: [GlobalVariables.textColor, Colors.teal],
                                      ),
                                      backgroundColor: Colors.red,
                                      boxShadows: [
                                        BoxShadow(
                                          color: GlobalVariables.textColor,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                      duration: Duration(seconds: 2),
                                    ).show(context);
                                  }
                                }
                                else {
                                  showFlushbar(context,"Time selection validation","Select start time before end time");
                                }

                              }
                            }
                            else if(session == "Session3") {
                              if(ManageSettingsVariables.mealTimingSub['Breakfast']!['Session2']!['EndTime'] != '-- -- --') {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Breakfast']!['Session2']!['EndTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session3 end time should be greater than session2 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                } else {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session3 end time should not be equal to session2 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }

                              else {
                                if(ManageSettingsVariables.mealTimingSub['Breakfast']![session]!['StartTime'] != '-- -- --') {
                                  TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Breakfast']![session]!['StartTime']);
                                  int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                  if (comparisonResult < 0) {
                                    Navigator.of(context).pop(updatedTime);
                                    ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                  }
                                  else if (comparisonResult > 0) {
                                    Flushbar(
                                      title: "Time validation",
                                      message: 'End time should be greater than start time',
                                      backgroundGradient: LinearGradient(
                                        colors: [GlobalVariables.textColor, Colors.teal],
                                      ),
                                      backgroundColor: Colors.red,
                                      boxShadows: [
                                        BoxShadow(
                                          color: GlobalVariables.textColor,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                      duration: Duration(seconds: 2),
                                    ).show(context);
                                  }
                                } else {
                                  showFlushbar(context,"Time selection validation","Select start time before end time");
                                }


                              }
                            }
                            else {
                              if(ManageSettingsVariables.mealTimingSub['Breakfast']![session]!['StartTime'] != '-- -- --' )
                              {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Breakfast']![session]!['StartTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'End time should be greater than start time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }
                              else{
                                showFlushbar(context,"Time selection validation","Select start time before end time");
                              }
                            }



                          }
                          else{
                            Flushbar(
                              title: "Time out of range",
                              message: 'Please select the time between 02:00 AM to 12:00 PM',
                              backgroundGradient: LinearGradient(
                                colors: [GlobalVariables.textColor, Colors.teal],
                              ),
                              backgroundColor: Colors.red,
                              boxShadows: [
                                BoxShadow(
                                  color: GlobalVariables.textColor,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                              duration: Duration(seconds: 2),
                            ).show(context);
                          }

                        }
                      } else if(meal == "Lunch") {
                        if(timeString == "StartTime")
                        {
                          if (isTimeInRange(time, TimeOfDay(hour: 4, minute: 30), TimeOfDay(hour: 16, minute: 30)))
                          {
                            ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                            Navigator.of(context).pop(updatedTime);
                          }
                          else {
                            Flushbar(
                              title: "Time out of range",
                              backgroundGradient: LinearGradient(
                                colors: [GlobalVariables.textColor, Colors.teal],
                              ),
                              backgroundColor: Colors.red,
                              messageText: Text('Please select the time between 04:00 AM to 04:00 PM',style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.primaryColor,
                              )),
                              boxShadows: [
                                BoxShadow(
                                  color: GlobalVariables.textColor,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                              duration: Duration(seconds: 2),
                            ).show(context);
                          }
                        }
                        else {
                          if (isTimeInRange(time, TimeOfDay(hour: 4, minute: 30), TimeOfDay(hour: 16, minute: 30)))
                          {
                            if(session == "Session2"){
                              if(ManageSettingsVariables.mealTimingSub['Lunch']!['Session1']!['EndTime'] != '-- -- --') {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Lunch']!['Session1']!['EndTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session2 end time should be greater than session1 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                } else {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session2 end time should not be equal to session1 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }
                              else {

                                if(ManageSettingsVariables.mealTimingSub['Lunch']![session]!['StartTime'] != '-- -- --')
                                {
                                  TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Lunch']![session]!['StartTime']);
                                  int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                  if (comparisonResult < 0) {
                                    Navigator.of(context).pop(updatedTime);
                                    ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                  }
                                  else if (comparisonResult > 0) {
                                    Flushbar(
                                      title: "Time validation",
                                      message: 'End time should be greater than start time kdsf d',
                                      backgroundGradient: LinearGradient(
                                        colors: [GlobalVariables.textColor, Colors.teal],
                                      ),
                                      backgroundColor: Colors.red,
                                      boxShadows: [
                                        BoxShadow(
                                          color: GlobalVariables.textColor,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                      duration: Duration(seconds: 2),
                                    ).show(context);
                                  }
                                }
                                else {
                                  showFlushbar(context,"Time selection validation","Select start time before end time");
                                }

                              }
                            }
                            else if(session == "Session3") {
                              if(ManageSettingsVariables.mealTimingSub['Lunch']!['Session2']!['EndTime'] != '-- -- --') {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Lunch']!['Session2']!['EndTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session3 end time should be greater than session2 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                } else {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session3 end time should not be equal to session2 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }

                              else {
                                if(ManageSettingsVariables.mealTimingSub['Lunch']![session]!['StartTime'] != '-- -- --') {
                                  TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Lunch']![session]!['StartTime']);
                                  int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                  if (comparisonResult < 0) {
                                    Navigator.of(context).pop(updatedTime);
                                    ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                  }
                                  else if (comparisonResult > 0) {
                                    Flushbar(
                                      title: "Time validation",
                                      message: 'End time should be greater than start time',
                                      backgroundGradient: LinearGradient(
                                        colors: [GlobalVariables.textColor, Colors.teal],
                                      ),
                                      backgroundColor: Colors.red,
                                      boxShadows: [
                                        BoxShadow(
                                          color: GlobalVariables.textColor,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                      duration: Duration(seconds: 2),
                                    ).show(context);
                                  }
                                } else {
                                  showFlushbar(context,"Time selection validation","Select start time before end time");
                                }


                              }
                            }
                            else {
                              if(ManageSettingsVariables.mealTimingSub['Lunch']![session]!['StartTime'] != '-- -- --' )
                              {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Lunch']![session]!['StartTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'End time should be greater than start time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }
                              else{
                                showFlushbar(context,"Time selection validation","Select start time before end time");
                              }
                            }



                          }
                          else{
                            Flushbar(
                              title: "Time out of range",
                              message: 'Please select the time between 04:00 AM to 04:00 PM',
                              backgroundGradient: LinearGradient(
                                colors: [GlobalVariables.textColor, Colors.teal],
                              ),
                              backgroundColor: Colors.red,
                              boxShadows: [
                                BoxShadow(
                                  color: GlobalVariables.textColor,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                              duration: Duration(seconds: 2),
                            ).show(context);
                          }

                        }
                      } else if(meal == "Dinner") {
                        if(timeString == "StartTime")
                        {
                          if (isTimeInRange(time, TimeOfDay(hour: 16, minute: 30), TimeOfDay(hour: 23, minute: 59)))
                          {
                            ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                            Navigator.of(context).pop(updatedTime);
                          }
                          else {
                            Flushbar(
                              title: "Time out of range",
                              backgroundGradient: LinearGradient(
                                colors: [GlobalVariables.textColor, Colors.teal],
                              ),
                              backgroundColor: Colors.red,
                              messageText: Text('Please select the time between 04:00 AM to 11:59 PM',style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.primaryColor,
                              )),
                              boxShadows: [
                                BoxShadow(
                                  color: GlobalVariables.textColor,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                              duration: Duration(seconds: 2),
                            ).show(context);
                          }
                        }
                        else {
                          if (isTimeInRange(time, TimeOfDay(hour: 16, minute: 30), TimeOfDay(hour: 23, minute: 59)))
                          {
                            if(session == "Session2"){
                              if(ManageSettingsVariables.mealTimingSub['Dinner']!['Session1']!['EndTime'] != '-- -- --') {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Dinner']!['Session1']!['EndTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session2 end time should be greater than session1 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                } else {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session2 end time should not be equal to session1 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }
                              else {

                                if(ManageSettingsVariables.mealTimingSub['Dinner']![session]!['StartTime'] != '-- -- --')
                                {
                                  TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Dinner']![session]!['StartTime']);
                                  int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                  if (comparisonResult < 0) {
                                    Navigator.of(context).pop(updatedTime);
                                    ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                  }
                                  else if (comparisonResult > 0) {
                                    Flushbar(
                                      title: "Time validation",
                                      message: 'End time should be greater than start time',
                                      backgroundGradient: LinearGradient(
                                        colors: [GlobalVariables.textColor, Colors.teal],
                                      ),
                                      backgroundColor: Colors.red,
                                      boxShadows: [
                                        BoxShadow(
                                          color: GlobalVariables.textColor,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                      duration: Duration(seconds: 2),
                                    ).show(context);
                                  }
                                }
                                else {
                                  showFlushbar(context,"Time selection validation","Select start time before end time");
                                }

                              }
                            }
                            else if(session == "Session3") {
                              if(ManageSettingsVariables.mealTimingSub['Dinner']!['Session2']!['EndTime'] != '-- -- --') {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Dinner']!['Session2']!['EndTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session3 end time should be greater than session2 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                } else {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'Session3 end time should not be equal to session2 end time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }

                              else {
                                if(ManageSettingsVariables.mealTimingSub['Dinner']![session]!['StartTime'] != '-- -- --') {
                                  TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Dinner']![session]!['StartTime']);
                                  int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                  if (comparisonResult < 0) {
                                    Navigator.of(context).pop(updatedTime);
                                    ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                  }
                                  else if (comparisonResult > 0) {
                                    Flushbar(
                                      title: "Time validation",
                                      message: 'End time should be greater than start time',
                                      backgroundGradient: LinearGradient(
                                        colors: [GlobalVariables.textColor, Colors.teal],
                                      ),
                                      backgroundColor: Colors.red,
                                      boxShadows: [
                                        BoxShadow(
                                          color: GlobalVariables.textColor,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                      duration: Duration(seconds: 2),
                                    ).show(context);
                                  }
                                } else {
                                  showFlushbar(context,"Time selection validation","Select start time before end time");
                                }


                              }
                            }
                            else {
                              if(ManageSettingsVariables.mealTimingSub['Dinner']![session]!['StartTime'] != '-- -- --' )
                              {
                                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Dinner']![session]!['StartTime']);
                                int comparisonResult = compareTimeOfDay(timeOfDay, time);
                                if (comparisonResult < 0) {
                                  Navigator.of(context).pop(updatedTime);
                                  ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(context);
                                }
                                else if (comparisonResult > 0) {
                                  Flushbar(
                                    title: "Time validation",
                                    message: 'End time should be greater than start time',
                                    backgroundGradient: LinearGradient(
                                      colors: [GlobalVariables.textColor, Colors.teal],
                                    ),
                                    backgroundColor: Colors.red,
                                    boxShadows: [
                                      BoxShadow(
                                        color: GlobalVariables.textColor,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }

                              }
                              else{
                                showFlushbar(context,"Time selection validation","Select start time before end time");
                              }
                            }



                          }
                          else{
                            Flushbar(
                              title: "Time out of range",
                              message: 'Please select the time between 04:00 AM to 11:59 PM',
                              backgroundGradient: LinearGradient(
                                colors: [GlobalVariables.textColor, Colors.teal],
                              ),
                              backgroundColor: Colors.red,
                              boxShadows: [
                                BoxShadow(
                                  color: GlobalVariables.textColor,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                              duration: Duration(seconds: 2),
                            ).show(context);
                          }

                        }
                      }
                      updatedTime =  TimeOfDay(hour: ManageSettingsVariables.currentTime.hour + 1, minute: ManageSettingsVariables.currentTime.minute);


                      ManageSettingsVariables.breakfastTimingsSub = [];
                      ManageSettingsVariables.lunchTimingsSub = [];
                      ManageSettingsVariables.dinnerTimingsSub = [];

                      setState(() {
                        ManageSettingsVariables.mealTimingSub.forEach((mealType, sessions) {
                          sessions.forEach((session, timing) {
                            String startTime = timing['StartTime'];
                            String endTime = timing['EndTime'];

                            if(mealType == "Breakfast" && startTime != '-- -- --' )
                            {
                              ManageSettingsVariables.breakfastTimingsSub.add(startTime);
                            }
                            else if(mealType == "Lunch" && startTime != '-- -- --')
                            {
                              ManageSettingsVariables.lunchTimingsSub.add(startTime);
                            }
                            else if(mealType == "Dinner" && startTime != '-- -- --'){
                              ManageSettingsVariables.dinnerTimingsSub.add(startTime);
                            }

                            if(mealType == "Breakfast" && endTime != '-- -- --' )
                            {
                              ManageSettingsVariables.breakfastTimingsSub.add(endTime);
                            }
                            else if(mealType == "Lunch" && endTime != '-- -- --')
                            {
                              ManageSettingsVariables.lunchTimingsSub.add(endTime);
                            }
                            else if(mealType == "Dinner" && endTime != '-- -- --'){
                              ManageSettingsVariables.dinnerTimingsSub.add(endTime);
                            }

                            ManageSettingsVariables.breakfastTimingsSub.sort((a, b) => parseTime(a).compareTo(parseTime(b)));
                            ManageSettingsVariables.lunchTimingsSub.sort((a, b) => parseTime(a).compareTo(parseTime(b)));
                            ManageSettingsVariables.dinnerTimingsSub.sort((a, b) => parseTime(a).compareTo(parseTime(b)));

                          });
                        });
                      });

                      managecontext.read<ManageSettingsBloc>().add(SetMealSessionTimeEvent(context));

                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.3298874768 * ffem / fem,
                          color: Color(0xfffbb830),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },

        );
      },
    );

    if (updatedTime != null) {
      TimeOfDay time = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM);
      if(meal == "Breakfast")
      {
        if (isTimeInRange(time, TimeOfDay(hour: 2, minute: 0), TimeOfDay(hour: 11, minute: 59)))
        {
          if(timeString == "StartTime")
          {
            if (isTimeInRange(time, TimeOfDay(hour: 2, minute: 0), TimeOfDay(hour: 11, minute: 59)))
            {
              ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
            }
            else{
              print("Invalid time");
            }
          }
          else {
            if (isTimeInRange(time, TimeOfDay(hour: 2, minute: 0), TimeOfDay(hour: 11, minute: 59)))
            {
              if(ManageSettingsVariables.mealTimingSub['Breakfast']![session]!['StartTime'] != '-- -- --' )
              {
                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Breakfast']![session]!['StartTime']);

                int comparisonResult = compareTimeOfDay(timeOfDay, time);

                if (comparisonResult < 0) {
                  ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
                }
                else if (comparisonResult > 0) {
                  // showFlushbar(managecontext, "Time validation", 'End time should be greater than start time');
                } else {
                  print('${formatTimeOfDay(timeOfDay)} is the same as ${formatTimeOfDay(time)}');
                }

              }
              else {

              }

            }
            else{
              print("Invalid time");
            }

          }
          // ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour,ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
        }
        else{
          showSnackBar(managecontext, "Please select the time between 02:00 AM to 12:00 PM");
          move = false;
        }
      }
      else if(meal == "Lunch"){
        if (isTimeInRange(time, TimeOfDay(hour: 4, minute: 30), TimeOfDay(hour: 16, minute: 30)))
        {
          if(timeString == "StartTime")
          {
            if (isTimeInRange(time, TimeOfDay(hour: 4, minute: 40), TimeOfDay(hour: 16, minute: 30)))
            {
              ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
            }
            else{
              print("Invalid time");
            }
          }
          else {
            if (isTimeInRange(time, TimeOfDay(hour: 4, minute: 30), TimeOfDay(hour: 16, minute: 30)))
            {
              if(ManageSettingsVariables.mealTimingSub['Lunch']![session]!['StartTime'] != '-- -- --' )
              {
                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Lunch']![session]!['StartTime']);

                int comparisonResult = compareTimeOfDay(timeOfDay, time);

                if (comparisonResult < 0) {
                  ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
                } else if (comparisonResult > 0) {
                  showFlushbar(managecontext, "Time validation", 'End time should be greater than start time');
                } else {
                  print('${formatTimeOfDay(timeOfDay)} is the same as ${formatTimeOfDay(time)}');
                }

              }
              else {

              }

            }
            else{
              print("Invalid time");
            }

          }
          // ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour,ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
        }
        else{
          showSnackBar(managecontext, "Please select the time between 04:30 AM to 04:30 PM");
          move = false;

        }
      }
      else if(meal == "Dinner"){
        if (isTimeInRange(time, TimeOfDay(hour: 16, minute: 30), TimeOfDay(hour: 23, minute: 59)))
        {
          if(timeString == "StartTime")
          {
            if (isTimeInRange(time, TimeOfDay(hour: 16, minute: 30), TimeOfDay(hour: 23, minute: 59)))
            {
              ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
            }
            else{
              print("Invalid time");
            }
          }
          else {
            if (isTimeInRange(time, TimeOfDay(hour: 16, minute: 30), TimeOfDay(hour: 23, minute: 59)))
            {
              if(ManageSettingsVariables.mealTimingSub['Dinner']![session]!['StartTime'] != '-- -- --' )
              {
                TimeOfDay timeOfDay = parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Dinner']![session]!['StartTime']);

                int comparisonResult = compareTimeOfDay(timeOfDay, time);

                if (comparisonResult < 0) {
                  ManageSettingsVariables.mealTimingSub[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
                } else if (comparisonResult > 0) {
                  showFlushbar(managecontext, "Time validation", 'End time should be greater than start time');
                } else {
                  print('${formatTimeOfDay(timeOfDay)} is the same as ${formatTimeOfDay(time)}');
                }

              }
              else {

              }

            }
            else{
              print("Invalid time");
            }

          }
          // ManageSettingsVariables.mealTiming[meal]![session]![timeString] = buildTimeOfDay(ManageSettingsVariables.selectedHour,ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(managecontext);
        }
        else{
          showSnackBar(managecontext, "Please select the time between 04:30 AM to 04:30 PM");
          move = false;

        }
      }
    }
    if(move)
    {
      TimeOfDay timeOfDay = TimeOfDay(hour: !ManageSettingsVariables.isAM ? ManageSettingsVariables.selectedHour+12 : ManageSettingsVariables.selectedHour, minute: ManageSettingsVariables.selectedMinute);
      print("Time of the day $timeOfDay");
      BlocProvider.of<TimeSelectionBloc>(managecontext).add(
        SelectTimeSubEvent(timeOfDay, meal, session, timeString,managecontext),
      );
    }

  }

  static void showFlushbar(BuildContext context,String title,String message) async {
    await Flushbar(
      title: title,
      message: message,
      backgroundGradient: LinearGradient(
        colors: [GlobalVariables.textColor, Colors.teal],
      ),
      backgroundColor: Colors.red,
      boxShadows: [
        BoxShadow(
          color: GlobalVariables.textColor,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        ),
      ],
      duration: Duration(seconds: 2),
    ).show(context).then((value) => Navigator.pop(context));
  }

  static TimeOfDay parseTimeOfDay(String timeString) {
    final parts = timeString.split(RegExp(r'[:\s]'));
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final period = parts[2].toUpperCase();

    int hour24 = hour;
    if (period == 'PM' && hour != 12) {
      hour24 = hour + 12;
    } else if (period == 'AM' && hour == 12) {
      hour24 = 0;
    }

    return TimeOfDay(hour: hour24, minute: minute);
  }

  static String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  static int compareTimeOfDay(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour != time2.hour) {
      return time1.hour - time2.hour;
    }
    return time1.minute - time2.minute;
  }


  static DateTime parseTime(String time) {
    // Extract hours, minutes, and period (AM/PM)
    final timeParts = time.split(' ');
    final period = timeParts[1];
    final hourMinute = timeParts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);

    // Adjust hours for AM/PM
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(1970, 1, 1, hour, minute);
  }


  static Widget _buildScrollableList({
    required List<int> values,
    required ValueChanged<int> onChanged,
    required int selectedValue,
  }) {
    return Container(
      height: 180.0 ,
      width: 70,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 70, // Height of each item
        diameterRatio: 1.5, // Adjust this value as needed
        offAxisFraction: -0.5,
        physics: FixedExtentScrollPhysics(), // Allow only one item to be selected
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (BuildContext context, int index) {
            final value = values[index];
            bool isSelected = value == selectedValue;
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xfffbb830).withOpacity(0.3) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                child: Text(
                   value < 10 ? '0${value}' : value.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    color: isSelected ? Color(0xfffbb830) : GlobalVariables.textColor,
                  ),
                ),
              ),
            );
          },
          childCount: values.length,
        ),
        onSelectedItemChanged: (index) {
          onChanged(values[index]);
        },
      ),
    );
  }

  static Widget _buildAMPMSelector({
    required bool isAM,
    required ValueChanged<bool> onAMPMChanged,
  }) {
    return Container(
      width: 50.0,
      height: 150.0,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              onAMPMChanged(true); // Set to AM
            },
            child: Container(
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isAM ? Color(0xfffbb830).withOpacity(0.3) : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  'AM',
                  style: TextStyle(
                    fontSize: 20,
                    color: isAM ? Color(0xfffbb830) : GlobalVariables.textColor,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onAMPMChanged(false); // Set to PM
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: !isAM ? Color(0xfffbb830).withOpacity(0.3) : Colors.transparent,
              ),

              child: Center(
                child: Text(
                  'PM',
                  style: TextStyle(
                    fontSize: 20,
                    color: !isAM ? Color(0xfffbb830) : GlobalVariables.textColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static bool isBreakfastTime(int hour, bool isAM) {
    return isAM || (hour >= 2 && hour < 12);
  }

  static bool isLunchTime(int hour, bool isAM) {
    return isAM || (hour >= 7 && hour < 5);
  }

  static bool isDinnerTime(int hour, bool isAM) {
    return isAM || (hour >= 5 && hour < 11);
  }

}