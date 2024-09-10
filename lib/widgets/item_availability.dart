import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';

import '../bloc/menu_editor/menu_editor_bloc.dart';
import '../bloc/menu_editor/menu_editor_event.dart';
import '../bloc/menu_editor/menu_editor_state.dart';
import '../constants/menu_editor_constants/menu_editor_variables.dart';
import '../constants/utils.dart';

class ItemAvailability extends StatefulWidget {
  final GlobalKey<FormState> checkKey;
  final MenuLoadedState? menuLoadedState;
  const ItemAvailability({Key? key, required this.checkKey, this.menuLoadedState}) : super(key: key);

  @override
  State<ItemAvailability> createState() => _ItemAvailabilityState();
}

class _ItemAvailabilityState extends State<ItemAvailability> {

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
              return Container();
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
  //         {
  //           return false;
  //         }
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
  //         {
  //           if(!s)
  //           {
  //             return false;
  //           }
  //         }
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
  //         {
  //           setState(() {
  //             sessionKey[s] = val;
  //           });
  //         }
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
  //     {
  //       var day1 = d;
  //       if(day==day1)
  //         {
  //           for(var session in MenuEditorVariables.daysMealSession[day]!.values)
  //             {
  //               for(var sessionKey in session.keys)
  //                 {
  //                   setState(() {
  //                     session[sessionKey] = val;
  //                   });
  //                 }
  //             }
  //         }
  //     }
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
  //           fontSize: 10,
  //           fontWeight: FontWeight.bold,
  //           color: GlobalVariables.textColor,
  //         ),),
  //       ),
  //     ),
  //   );
  // }
}
