import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_functions.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/widgets/small_custom_textfield.dart';

import '../bloc/menu_editor/menu_editor_bloc.dart';
import '../bloc/menu_editor/menu_editor_event.dart';
import '../bloc/menu_editor/menu_editor_state.dart';
import '../constants/manage_settings/manage_settings_functions.dart';
import '../constants/manage_settings/manage_settings_variables.dart';
import '../constants/menu_editor_constants/menu_editor_variables.dart';
import '../constants/order_constants/order_variables.dart';
import '../constants/utils.dart';

class ItemAvailability1 extends StatefulWidget {
  final GlobalKey<FormState> checkKey;
  final MenuLoadedState? menuLoadedState;
  const ItemAvailability1({Key? key, required this.checkKey, this.menuLoadedState}) : super(key: key);

  @override
  State<ItemAvailability1> createState() => _ItemAvailabilityState();
}

class _ItemAvailabilityState extends State<ItemAvailability1> {

  bool breakfastSelected = false;
  bool lunchSelected = false;
  bool dinnerSelected = false;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return BlocProvider(
      create: (BuildContext context) => MenuEditorBloc(
      )..add(LoadMenuEditorEvent()),
      child: BlocBuilder<MenuEditorBloc,MenuEditorState>(builder: (BuildContext context, state) {
        if(state is MenuEditorLoadingState){
          return Center(child: CircularProgressIndicator(),);
        }
        if(state is MenuEditorLoadedState) {
          if(widget.menuLoadedState is MenuLoadedState)
          {
            return ResponsiveBuilder(
                mobileBuilder: (BuildContext context,BoxConstraints constraints){
                  return Container();
                },
                tabletBuilder: (BuildContext context,BoxConstraints constraints){
                  return Container(
                    padding: EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 70*fem,
                                    child: RadioListTile(
                                      title: Text('Item available on selection',style: SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: GlobalVariables.textColor,
                                      ),),
                                      value: 0,
                                      groupValue: MenuEditorVariables.selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          MenuEditorVariables.availabilityFlag = true;
                                          MenuEditorVariables.selectedOption = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 100*fem,
                                    child: RadioListTile(
                                      title: Text('Item available on selected schedule ',style:
                                      SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color:GlobalVariables.textColor,
                                      ),),
                                      value: 1,
                                      groupValue: MenuEditorVariables.selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          MenuEditorVariables.availabilityFlag = true;
                                          MenuEditorVariables.selectedOption = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),


                            ],
                          ),



                          Visibility(
                            visible: MenuEditorVariables.selectedOption == 1,
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DataTable(
                                        columnSpacing: 10,
                                        border: TableBorder.all(
                                            color: Colors.black12,
                                            width: 0.5,
                                            style: BorderStyle.solid,
                                            borderRadius: BorderRadius.circular(10)),
                                        columns: <DataColumn> [
                                          DataColumn(
                                              label: Row(
                                                children: [
                                                  Text("Days",style:SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: GlobalVariables.textColor,
                                                  ),),
                                                ],
                                              )),
                                          DataColumn(
                                              label: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  SizedBox(width: 50,),
                                                  Text("Breakfast",style:SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: GlobalVariables.textColor,
                                                  ),),

                                                ],
                                              )),
                                          DataColumn(
                                              label: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(width: 50,),
                                                  Text("Lunch",style:SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: GlobalVariables.textColor,
                                                  ),),

                                                ],
                                              )),
                                          DataColumn(
                                              label: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(width: 50,),
                                                  Text("Dinner",style:SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: GlobalVariables.textColor,
                                                  ),),

                                                ],
                                              )),
                                        ],
                                        rows: MenuEditorVariables.daysMealSession.keys.map((String day) {
                                          var meals = MenuEditorVariables.daysMealSession1[day] ?? const {};
                                          var breakfast = meals['Breakfast'];
                                          var lunch = meals['Lunch'];
                                          var dinner = meals['Dinner'];
                                          return DataRow(cells: <DataCell>[
                                            DataCell(
                                                Row(
                                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(day,style:SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: GlobalVariables.textColor,
                                                    ),),

                                                  ],
                                                )),
                                            DataCell(
                                                Row(
                                                  children: [
                                                    buildSession2(day, "Breakfast", "S1", breakfast!['S1']!),
                                                    SizedBox(width: 5,),
                                                    buildSession2(day, "Breakfast", "S2", breakfast['S2']!),
                                                    SizedBox(width: 5,),
                                                    buildSession2(day, "Breakfast", "S3", breakfast['S3']!),
                                                    // SizedBox(width: 3,),
                                                    // buildSession2(day, "Breakfast", "S4", breakfast['S4']!),
                                                  ],
                                                )
                                            ),
                                            DataCell(
                                                Row(
                                                  children: [
                                                    buildSession2(day, "Lunch", "S1", lunch!['S1']!),
                                                    SizedBox(width: 5,),
                                                    buildSession2(day, "Lunch", "S2", lunch['S2']!),
                                                    SizedBox(width: 5,),
                                                    buildSession2(day, "Lunch", "S3", lunch['S3']!),
                                                    // SizedBox(width: 3,),
                                                    // buildSession2(day, "Lunch", "S4", lunch['S4']!),
                                                  ],
                                                )
                                            ),
                                            DataCell(
                                                Row(
                                                  children: [
                                                    buildSession2(day, "Dinner", "S1", dinner!['S1']!),
                                                    SizedBox(width: 5,),
                                                    buildSession2(day, "Dinner", "S2", dinner['S2']!),
                                                    SizedBox(width: 5,),
                                                    buildSession2(day, "Dinner", "S3", dinner['S3']!),
                                                    // SizedBox(width: 3,),
                                                    // buildSession2(day, "Dinner", "S4", dinner['S4']!),
                                                  ],
                                                )
                                            ),
                                          ]);
                                        }).toList()
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                },
                desktopBuilder: (BuildContext context,BoxConstraints constraints){
                  return Container(
                    padding: EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 70*fem,
                                    child: RadioListTile(
                                      title: Text('Item available on selection',style: SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: GlobalVariables.textColor,
                                      ),),
                                      value: 0,
                                      groupValue: MenuEditorVariables.selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          MenuEditorVariables.availabilityFlag = true;
                                          MenuEditorVariables.selectedOption = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 100*fem,
                                    child: RadioListTile(
                                      title: Text('Item available on selected schedule ',style:
                                      SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color:GlobalVariables.textColor,
                                      ),),
                                      value: 1,
                                      groupValue: MenuEditorVariables.selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          MenuEditorVariables.availabilityFlag = true;
                                          MenuEditorVariables.selectedOption = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),


                            ],
                          ),



                          Visibility(
                            visible: MenuEditorVariables.selectedOption == 1,
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DataTable(
                                        columnSpacing: 10,
                                        border: TableBorder.all(
                                            color: Colors.black12,
                                            width: 0.5,
                                            style: BorderStyle.solid,
                                            borderRadius: BorderRadius.circular(10)),
                                        columns: <DataColumn> [
                                          DataColumn(
                                              label: Row(
                                                children: [
                                                  Text("Days",style:SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: GlobalVariables.textColor,
                                                  ),),
                                                ],
                                              )),
                                          DataColumn(
                                              label: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  SizedBox(width: 50,),
                                                  Text("Breakfast",style:SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: GlobalVariables.textColor,
                                                  ),),

                                                ],
                                              )),
                                          DataColumn(
                                              label: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(width: 50,),
                                                  Text("Lunch",style:SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: GlobalVariables.textColor,
                                                  ),),

                                                ],
                                              )),
                                          DataColumn(
                                              label: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(width: 50,),
                                                  Text("Dinner",style:SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: GlobalVariables.textColor,
                                                  ),),

                                                ],
                                              )),
                                        ],
                                        rows: MenuEditorVariables.daysMealSession.keys.map((String day) {
                                          var meals = MenuEditorVariables.daysMealSession1[day] ?? const {};
                                          var breakfast = meals['Breakfast'];
                                          var lunch = meals['Lunch'];
                                          var dinner = meals['Dinner'];
                                          return DataRow(cells: <DataCell>[
                                            DataCell(
                                                Row(
                                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(day,style:SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: GlobalVariables.textColor,
                                                    ),),

                                                  ],
                                                )),
                                            DataCell(
                                                Row(
                                                  children: [
                                                    buildSession2(day, "Breakfast", "S1", breakfast!['S1']!),
                                                    SizedBox(width: 5,),
                                                    buildSession2(day, "Breakfast", "S2", breakfast['S2']!),
                                                    SizedBox(width: 5,),
                                                    buildSession2(day, "Breakfast", "S3", breakfast['S3']!),
                                                    // SizedBox(width: 3,),
                                                    // buildSession2(day, "Breakfast", "S4", breakfast['S4']!),
                                                  ],
                                                )
                                            ),
                                            DataCell(
                                                Row(
                                                  children: [
                                                    buildSession2(day, "Lunch", "S1", lunch!['S1']!),
                                                    SizedBox(width: 5,),
                                                    buildSession2(day, "Lunch", "S2", lunch['S2']!),
                                                    SizedBox(width: 5,),
                                                    buildSession2(day, "Lunch", "S3", lunch['S3']!),
                                                    // SizedBox(width: 3,),
                                                    // buildSession2(day, "Lunch", "S4", lunch['S4']!),
                                                  ],
                                                )
                                            ),
                                            DataCell(
                                                Row(
                                                  children: [
                                                    buildSession2(day, "Dinner", "S1", dinner!['S1']!),
                                                    SizedBox(width: 5,),
                                                    buildSession2(day, "Dinner", "S2", dinner['S2']!),
                                                    SizedBox(width: 5,),
                                                    buildSession2(day, "Dinner", "S3", dinner['S3']!),
                                                    // SizedBox(width: 3,),
                                                    // buildSession2(day, "Dinner", "S4", dinner['S4']!),
                                                  ],
                                                )
                                            ),
                                          ]);
                                        }).toList()
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                });
          }

        }
        return Container();
      },

      ),
    );
  }

  // bool _areAllBreakfastSessionSelected(String meal) {
  //   for(var meals in MenuEditorVariables.daysMealSession.values)
  //   {
  //     var m = meals[meal];
  //
  //     for(var session in m!.values)
  //     {
  //       if(!session)
  //       {
  //         return false;
  //       }
  //     }
  //   }
  //   return true;
  // }

  // bool _areAllDays() {
  //   for(var meals in MenuEditorVariables.daysMealSession.values)
  //   {
  //
  //     for(var session in meals.values)
  //     {
  //       for(var s in session.values)
  //       {
  //         if(!s)
  //         {
  //           return false;
  //         }
  //       }
  //     }
  //   }
  //   return true;
  // }
  //
  // void setMeal(String meal, bool val) {
  //   for (var meals in MenuEditorVariables.daysMealSession.values) {
  //     var m = meals[meal];
  //
  //     for (var sessionKey in m!.keys) {
  //       setState(() {
  //         m[sessionKey] = val;
  //       });
  //     }
  //   }
  // }
  //
  // void setAllMeal(bool val) {
  //   for (var meals in MenuEditorVariables.daysMealSession.values) {
  //
  //     for (var sessionKey in meals.values) {
  //
  //       for(var s in sessionKey.keys)
  //       {
  //         setState(() {
  //           sessionKey[s] = val;
  //         });
  //       }
  //     }
  //   }
  // }
  //
  // bool _aredaysSessions(String d) {
  //   for (var day in MenuEditorVariables.daysMealSession.keys) {
  //     var day1 = d;
  //     if (day == day1) {
  //       for (var session in MenuEditorVariables.daysMealSession[day]!.values) {
  //         for (var s in session.values) {
  //           if (!s) {
  //             return false;
  //           }
  //         }
  //       }
  //     }
  //   }
  //   return true;
  // }
  //
  // void setDay(String d,bool val) {
  //   for(var day in MenuEditorVariables.daysMealSession.keys)
  //   {
  //     var day1 = d;
  //     if(day==day1)
  //     {
  //       for(var session in MenuEditorVariables.daysMealSession[day]!.values)
  //       {
  //         for(var sessionKey in session.keys)
  //         {
  //           setState(() {
  //             session[sessionKey] = val;
  //           });
  //         }
  //       }
  //     }
  //   }
  // }

  Widget buildSession(String day, String meal, String sessionKey, bool session) {
    return InkWell(
      onTap: () {
        TextEditingController _textFieldController = TextEditingController();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Enter value for $sessionKey"),
              content: TextField(
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Enter value here"),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    setState(() {
                      // Assuming you want to store the entered value in some state.
                      // Update the corresponding value in the state.
                      // MenuEditorVariables.daysMealSession[day]![meal]![sessionKey] = _textFieldController.text;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 40,
        height: 25,
        decoration: BoxDecoration(
          color: session ? GlobalVariables.primaryColor : GlobalVariables.whiteColor,
          border: Border.all(color: GlobalVariables.primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            sessionKey,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: GlobalVariables.textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSession2(String day, String meal, String sessionKey, Map<String, dynamic> session) {
    return InkWell(
      onTap: () {
        TextEditingController _textFieldController = TextEditingController();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Enter count for $sessionKey",style: TextStyle(
                fontFamily: 'RenogareSoft',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: GlobalVariables.textColor,
              ),),
              content: TextField(
                controller: _textFieldController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintStyle: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: GlobalVariables.textColor,
                    ),
                    hintText: "Enter count"),
                onSubmitted: (val){
                  MenuEditorVariables.availabilityFlag = true;
                  setState(() {
                    int count = int.tryParse(_textFieldController.text) ?? 0;
                    MenuEditorVariables.daysMealSession1[day]![meal]![sessionKey]!['count'] = count;
                    // print(MenuEditorVariables.daysMealSession1);
                  });
                  Navigator.of(context).pop();
                },
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    MenuEditorVariables.availabilityFlag = true;
                    int count = int.tryParse(_textFieldController.text) ?? 0;
                    Navigator.of(context).pop();
                    checkOverlapping(day, meal, sessionKey, MenuEditorVariables.daysMealSession1,count);

                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 42,
        height: 30,
        decoration: BoxDecoration(
          color: session['count'] != 0 ? GlobalVariables.primaryColor : GlobalVariables.whiteColor,
          border: Border.all(color: GlobalVariables.primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
               session['count'] == 0 ? sessionKey : session['count'].toString(),
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 12,
                  fontWeight: session['count'] == 0 ? FontWeight.bold : FontWeight.w500,
                  color: GlobalVariables.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkOverlapping(
      String day,
      String meal,
      String session,
      Map<String, Map<String, Map<String, Map<String, dynamic>>>> dayMealSession,
      int count,
      ) {

    TimeOfDay s1EndTime = ManageSettingFunction.parseTimeOfDay(
        ManageSettingsVariables.mealTiming[meal]!['Session1']!['EndTime']);
    TimeOfDay s2EndTime = ManageSettingFunction.parseTimeOfDay(
        ManageSettingsVariables.mealTiming[meal]!['Session2']!['EndTime']);
    TimeOfDay s2StartTime = ManageSettingFunction.parseTimeOfDay(
        ManageSettingsVariables.mealTiming[meal]!['Session2']!['StartTime']);
    TimeOfDay s3StartTime = ManageSettingFunction.parseTimeOfDay(
        ManageSettingsVariables.mealTiming[meal]!['Session3']!['StartTime']);

    int overlap3Sessions = ManageSettingFunction.compareTimeOfDay(s1EndTime, s3StartTime);
    int overlapSession1AndSession2 = ManageSettingFunction.compareTimeOfDay(s1EndTime, s2StartTime);
    int overlapSession2AndSession3 = ManageSettingFunction.compareTimeOfDay(s2EndTime, s3StartTime);
    int overlapSession1AndSession3 = ManageSettingFunction.compareTimeOfDay(s1EndTime, s3StartTime);

    void handleOverlap(
        String currentSession,
        String otherSession,
        int overlap,
        String message,
        ) {
      if (overlap > 0) {
        if (session == currentSession) {
          if (dayMealSession[day]![meal]![otherSession]!['count'] > 0) {
            showOverlappingMessage(context, message, currentSession, otherSession,
                count, day, meal);
          } else {
            setState(() {
              MenuEditorVariables.daysMealSession1[day]![meal]![session]!['count'] =
                  count;
            });
          }
        }
        else if (session == otherSession) {
          if (dayMealSession[day]![meal]![currentSession]!['count'] > 0) {
            showOverlappingMessage(context, message, otherSession, currentSession,
                count, day, meal);
          } else {
            setState(() {
              MenuEditorVariables.daysMealSession1[day]![meal]![session]!['count'] =
                  count;
            });
          }
        }
        else {
          setState(() {
            MenuEditorVariables.daysMealSession1[day]![meal]![session]!['count'] =
                count;
          });
        }
      }
    }

    handleOverlap('S1', 'S2', overlapSession1AndSession2, "Session2 overlapping with session1, you cannot add the same items to overlapping sessions. Do you want to add item to session 1?");
    handleOverlap('S1', 'S3', overlapSession1AndSession3, "Session3 overlapping with session1, you cannot add the same items to overlapping sessions. Do you want to add item to session 1?");
    handleOverlap('S2', 'S3', overlapSession2AndSession3, "Session3 overlapping with session2, you cannot add the same items to overlapping sessions. Do you want to add item to session 2?");
  }


  void showOverlappingMessage(BuildContext context,String message,String updatingSession,String setCountZeroSession,int count,String day,String meal,) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Session Overlapped",style: GlobalVariables.dataItemStyle,),
          content: Container(
              width: 300,
              margin: EdgeInsets.all(15),
              child: Expanded(
                  child: Text("${message}",style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: GlobalVariables.textColor,
                  ),))),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // Close the AlertDialog
              },
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.whiteColor,
                    border: Border.all(color: GlobalVariables.textColor),
                    borderRadius: BorderRadius.circular(3)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'CANCEL',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: GlobalVariables.textColor,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  MenuEditorVariables.daysMealSession1[day]![meal]![setCountZeroSession]!['count'] = 0;
                  MenuEditorVariables.daysMealSession1[day]![meal]![updatingSession]!['count'] = count;
                  // print(" day $day meal $meal session $session session key $sessionKey");
                });
                Navigator.of(context).pop(); // Close the AlertDialog
              },
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.primaryColor,
                    border: Border.all(color: GlobalVariables.primaryColor),
                    borderRadius: BorderRadius.circular(3)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'CONFIRM',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: GlobalVariables.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}
