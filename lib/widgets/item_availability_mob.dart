import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_variables.dart';

import '../bloc/menu_editor/menu_editor_bloc.dart';
import '../bloc/menu_editor/menu_editor_event.dart';
import '../bloc/menu_editor/menu_editor_state.dart';
import '../constants/global_variables.dart';
import '../constants/utils.dart';
import 'menu/live_menu/live_menu.dart';

class ItemAvailableMob extends StatefulWidget {
  const ItemAvailableMob({Key? key}) : super(key: key);

  @override
  State<ItemAvailableMob> createState() => _ItemAvailableMobState();
}

class _ItemAvailableMobState extends State<ItemAvailableMob> {

  int selectedOption = 1;
  bool breakfastSelected = false;
  bool lunchSelected = false;
  bool dinnerSelected = false;



  MealTime selectedMealTime = MealTime.Breakfast;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return BlocBuilder<MenuEditorBloc,MenuEditorState>(builder: (BuildContext mcontext, state) {
      return SingleChildScrollView(
        child: Container()
      );
    },

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
  //
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
  // Widget buildMealTimeButton1(MealTime mealTime, String label) {
  //   double baseWidth = 375;
  //   double fem = MediaQuery.of(context).size.width / baseWidth;
  //   double ffem = fem * 0.97;
  //   Color backgroundColor = selectedMealTime == mealTime ? GlobalVariables.textColor : selectedMealTime == MealTime.All ? GlobalVariables.textColor : Colors.white;
  //
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         selectedMealTime = mealTime;
  //       });
  //     },
  //     child: Container(
  //       width: 75*fem,
  //       height: 30,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(color:GlobalVariables.textColor),
  //         color: backgroundColor,
  //       ),
  //       child: Center(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             // Image.asset(
  //             //   getMealTimeImage(mealTime),
  //             //   width: 15.48 * fem,
  //             //   height: 14.09 * fem,
  //             // ),
  //             // SizedBox(width: 7 * fem),
  //             Text(
  //               label,
  //               style: SafeGoogleFont(
  //                 'Poppins',
  //                 fontSize: 10,
  //                 fontWeight: FontWeight.bold,
  //                 height: 1.3102272749 * ffem / fem,
  //                 color: GlobalVariables.primaryColor,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
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
  // void setAllMeal( bool val) {
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
  // void setDay(String d,bool val){
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
  //
  // Widget buildSession(String day, String meal, String sessionKey, bool session) {
  //   return InkWell(
  //     onTap: () {
  //       setState(() {
  //         MenuEditorVariables.daysMealSession[day]![meal]![sessionKey] = !session;
  //       });
  //     },
  //     child: Container(
  //       width: 40,
  //       height: 25,
  //       decoration: BoxDecoration(
  //         color: session ? GlobalVariables.primaryColor : GlobalVariables.whiteColor,
  //         border: Border.all(color: GlobalVariables.primaryColor),
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       child: Center(
  //         child: Text(sessionKey, style: SafeGoogleFont(
  //           'Poppins',
  //           fontSize: 12,
  //           fontWeight: FontWeight.bold,
  //           color: GlobalVariables.textColor,
  //         ),),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget buildSession1(String day, String meal, String sessionKey, bool session) {
  //   return InkWell(
  //     onTap: () {
  //       setState(() {
  //         MenuEditorVariables.daysMealSession[day]![meal]![sessionKey] = !session;
  //       });
  //     },
  //     child: Container(
  //       width: 25,
  //       height: 20,
  //       decoration: BoxDecoration(
  //         color: session ? GlobalVariables.primaryColor : GlobalVariables.whiteColor,
  //         border: Border.all(color: GlobalVariables.primaryColor),
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       child: Center(
  //         child: Text(sessionKey, style: SafeGoogleFont(
  //           'Poppins',
  //           fontSize: 10,
  //           fontWeight: FontWeight.bold,
  //           color: GlobalVariables.textColor,
  //         ),),
  //       ),
  //     ),
  //   );
  // }
}
