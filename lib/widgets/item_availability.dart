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
              return ResponsiveBuilder(
                  mobileBuilder: (BuildContext context,BoxConstraints constraints){
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: RadioListTile(
                                        title: Text('Item available on selection',style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: GlobalVariables.textColor,
                                        ),),
                                        value: 1,
                                        groupValue: MenuEditorVariables.selectedOption,
                                        onChanged: (value) {
                                          setState(() {
                                            MenuEditorVariables.selectedOption = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    Container(

                                      child: RadioListTile(
                                        title: Text('Item available on selected schedule',style:
                                        SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color:GlobalVariables.textColor,
                                        ),),
                                        value: 3,
                                        groupValue: MenuEditorVariables.selectedOption,
                                        onChanged: (value) {
                                          setState(() {
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
                              visible: MenuEditorVariables.selectedOption != 1,
                              child: Column(
                                children: [
                                  // SizedBox(height: 20,),
                                  // _buildMealSession(context, "Breakfast", breakfastSelected),
                                  // SizedBox(height: 10,),
                                  // _buildMealSession(context, "Lunch", lunchSelected),
                                  // SizedBox(height: 10,),
                                  // _buildMealSession(context, "Dinner", dinnerSelected),
                                  // SizedBox(height: 20,),
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      DataTable(
                                          columnSpacing: 15,
                                          border: TableBorder.all(
                                              color: Colors.black12,
                                              width: 0.5,
                                              style: BorderStyle.solid,
                                              borderRadius: BorderRadius.circular(10)),
                                          columns: <DataColumn> [
                                            DataColumn(
                                                label: Column(
                                                  children: [
                                                    Text("Days",
                                                      style:SafeGoogleFont(
                                                        'Poppins',
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        color: GlobalVariables.textColor,
                                                      ),),
                                                    // SizedBox(width: 10,),
                                                    Checkbox(
                                                        value: _areAllDays(),
                                                        onChanged: (val) {
                                                          setAllMeal(val!);
                                                        })
                                                  ],
                                                )),
                                            DataColumn(label: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                SizedBox(width: 20,),
                                                Text("Breakfast",style:SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: GlobalVariables.textColor,
                                                ),),
                                                Checkbox(
                                                    value: _areAllBreakfastSessionSelected('Breakfast'),
                                                    onChanged: (val) {
                                                      setMeal('Breakfast',val!);
                                                    })
                                              ],
                                            )),
                                            DataColumn(
                                                label: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: 20,),
                                                    Text("Lunch",style:SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: GlobalVariables.textColor,
                                                    ),),
                                                    Checkbox(value: _areAllBreakfastSessionSelected('Lunch'), onChanged: (val){
                                                      setMeal('Lunch', val!);
                                                    })
                                                  ],
                                                )),
                                            DataColumn(
                                                label: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: 20,),
                                                    Text("Dinner",style:SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: GlobalVariables.textColor,
                                                    ),),
                                                    Checkbox(value: _areAllBreakfastSessionSelected('Dinner'), onChanged: (val){
                                                      setMeal('Dinner', val!);
                                                    })
                                                  ],
                                                )),
                                          ],
                                          rows: MenuEditorVariables.daysMealSession.keys.map((String day) {
                                            var meals = MenuEditorVariables.daysMealSession[day] ?? const {};
                                            var breakfast = meals['Breakfast'];
                                            var lunch = meals['Lunch'];
                                            var dinner = meals['Dinner'];
                                            return DataRow(cells: <DataCell>[
                                              DataCell(
                                                  Column(
                                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(day,style:SafeGoogleFont(
                                                        'Poppins',
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        color: GlobalVariables.textColor,
                                                      ),),
                                                      Checkbox(value: _aredaysSessions(day), onChanged: (value){
                                                        setDay(day, value!);
                                                      })
                                                    ],
                                                  )),
                                              DataCell(
                                                  Row(
                                                    children: [
                                                      buildSession1(day, "Breakfast", "S1", breakfast!['S1']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Breakfast", "S2", breakfast['S2']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Breakfast", "S3", breakfast['S3']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Breakfast", "S4", breakfast['S4']!),
                                                    ],
                                                  )
                                              ),
                                              DataCell(
                                                  Row(
                                                    children: [
                                                      buildSession1(day, "Lunch", "S1", lunch!['S1']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Lunch", "S2", lunch['S2']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Lunch", "S3", lunch['S3']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Lunch", "S4", lunch['S4']!),
                                                    ],
                                                  )
                                              ),
                                              DataCell(
                                                  Row(
                                                    children: [
                                                      buildSession1(day, "Dinner", "S1", dinner!['S1']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Dinner", "S2", dinner['S2']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Dinner", "S3", dinner['S3']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Dinner", "S4", dinner['S4']!),
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
                                        value: 1,
                                        groupValue: MenuEditorVariables.selectedOption,
                                        onChanged: (value) {
                                          setState(() {
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
                                        value: 3,
                                        groupValue: MenuEditorVariables.selectedOption,
                                        onChanged: (value) {
                                          setState(() {
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
                              visible: MenuEditorVariables.selectedOption != 1,
                              child: Column(
                                children: [
                                  // SizedBox(height: 20,),
                                  // _buildMealSession(context, "Breakfast", breakfastSelected),
                                  // SizedBox(height: 10,),
                                  // _buildMealSession(context, "Lunch", lunchSelected),
                                  // SizedBox(height: 10,),
                                  // _buildMealSession(context, "Dinner", dinnerSelected),
                                  // SizedBox(height: 20,),
                                  SizedBox(height: 20,),
                                  Row(
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
                                                    SizedBox(width: 20,),
                                                    Checkbox(
                                                        value: _areAllDays(),
                                                        onChanged: (val) {
                                                          context.read<MenuEditorBloc>().add(SelectAllDaysEvent(state.selectedCategories,state.foodCategories,state.itemName,state.daysMealSession, val!));
                                                        })
                                                  ],
                                                )),
                                            DataColumn(label: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                SizedBox(width: 25,),
                                                Text("Breakfast",style:SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: GlobalVariables.textColor,
                                                ),),
                                                Checkbox(
                                                    value: _areAllBreakfastSessionSelected('Breakfast'),
                                                    onChanged: (val) {
                                                      context.read<MenuEditorBloc>().add(SelectMealsEvent(state.selectedCategories,state.foodCategories,state.itemName,state.daysMealSession,'Breakfast', val!));
                                                    })
                                              ],
                                            )),
                                            DataColumn(
                                                label: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: 25,),
                                                    Text("Lunch",style:SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: GlobalVariables.textColor,
                                                    ),),
                                                    Checkbox(value: _areAllBreakfastSessionSelected('Lunch'), onChanged: (val){
                                                      context.read<MenuEditorBloc>().add(SelectMealsEvent(state.selectedCategories,state.foodCategories,state.itemName,state.daysMealSession,'Lunch', val!));
                                                    })
                                                  ],
                                                )),
                                            DataColumn(
                                                label: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: 25,),
                                                    Text("Dinner",style:SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: GlobalVariables.textColor,
                                                    ),),
                                                    Checkbox(value: _areAllBreakfastSessionSelected('Dinner'), onChanged: (val){
                                                      context.read<MenuEditorBloc>().add(SelectMealsEvent(state.selectedCategories,state.foodCategories,state.itemName,state.daysMealSession,'Dinner', val!));
                                                    })
                                                  ],
                                                )),
                                          ],
                                          rows: MenuEditorVariables.daysMealSession.keys.map((String day) {
                                            var meals = MenuEditorVariables.daysMealSession[day] ?? const {};
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
                                                      Checkbox(value: _aredaysSessions(day), onChanged: (value){
                                                        context.read<MenuEditorBloc>().add(SelectSingleDayEvent(state.selectedCategories,state.foodCategories,state.itemName,state.daysMealSession,day, value!));
                                                      })
                                                    ],
                                                  )),
                                              DataCell(
                                                  Row(
                                                    crossAxisAlignment : CrossAxisAlignment.center,
                                                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      buildSession1(day, "Breakfast", "S1", breakfast!['S1']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Breakfast", "S2", breakfast['S2']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Breakfast", "S3", breakfast['S3']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Breakfast", "S4", breakfast['S4']!),
                                                    ],
                                                  )
                                              ),
                                              DataCell(
                                                  Row(
                                                    crossAxisAlignment : CrossAxisAlignment.center,
                                                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      buildSession1(day, "Lunch", "S1", lunch!['S1']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Lunch", "S2", lunch['S2']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Lunch", "S3", lunch['S3']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Lunch", "S4", lunch['S4']!),
                                                    ],
                                                  )
                                              ),
                                              DataCell(
                                                  Row(
                                                    crossAxisAlignment : CrossAxisAlignment.center,
                                                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      buildSession1(day, "Dinner", "S1", dinner!['S1']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Dinner", "S2", dinner['S2']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Dinner", "S3", dinner['S3']!),
                                                      SizedBox(width: 3,),
                                                      buildSession1(day, "Dinner", "S4", dinner['S4']!),
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
                                        value: 1,
                                        groupValue: MenuEditorVariables.selectedOption,
                                        onChanged: (value) {
                                          setState(() {
                                            MenuEditorVariables.selectedOption = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: 150*fem,
                                      child: RadioListTile(
                                        title: Text('Item available on selected schedule when restaurant is working',style:
                                        SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color:GlobalVariables.textColor,
                                        ),),
                                        value: 3,
                                        groupValue: MenuEditorVariables.selectedOption,
                                        onChanged: (value) {
                                          setState(() {
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
                              visible: MenuEditorVariables.selectedOption != 1,
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),
                                  Row(
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
                                                    SizedBox(width: 20,),
                                                    Checkbox(
                                                        value: _areAllDays(),
                                                        onChanged: (val) {
                                                          //context.read<MenuEditorBloc>().add(SelectAllDaysEvent(state.daysMealSession, val!));
                                                        })
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
                                                    Checkbox(
                                                        value: _areAllBreakfastSessionSelected('Breakfast'),
                                                        onChanged: (val) {
                                                          setMeal('Breakfast',val!);
                                                        })
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
                                                    Checkbox(value: _areAllBreakfastSessionSelected('Lunch'), onChanged: (val){
                                                      setMeal('Lunch', val!);
                                                    })
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
                                                    Checkbox(value: _areAllBreakfastSessionSelected('Dinner'), onChanged: (val){
                                                      setMeal('Dinner', val!);
                                                    })
                                                  ],
                                                )),
                                          ],
                                          rows: MenuEditorVariables.daysMealSession.keys.map((String day) {
                                            var meals = MenuEditorVariables.daysMealSession[day] ?? const {};
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
                                                      Checkbox(value: _aredaysSessions(day), onChanged: (value){
                                                        setDay(day, value!);
                                                      })
                                                    ],
                                                  )),
                                              DataCell(
                                                  Row(
                                                    children: [
                                                      buildSession(day, "Breakfast", "S1", breakfast!['S1']!),
                                                      SizedBox(width: 5,),
                                                      buildSession(day, "Breakfast", "S2", breakfast['S2']!),
                                                      SizedBox(width: 5,),
                                                      buildSession(day, "Breakfast", "S3", breakfast['S3']!),
                                                      SizedBox(width: 5,),
                                                      buildSession(day, "Breakfast", "S4", breakfast['S4']!),
                                                    ],
                                                  )
                                              ),
                                              DataCell(
                                                  Row(
                                                    children: [
                                                      buildSession(day, "Lunch", "S1", lunch!['S1']!),
                                                      SizedBox(width: 5,),
                                                      buildSession(day, "Lunch", "S2", lunch['S2']!),
                                                      SizedBox(width: 5,),
                                                      buildSession(day, "Lunch", "S3", lunch['S3']!),
                                                      SizedBox(width: 5,),
                                                      buildSession(day, "Lunch", "S4", lunch['S4']!),
                                                    ],
                                                  )
                                              ),
                                              DataCell(
                                                  Row(
                                                    children: [
                                                      buildSession(day, "Dinner", "S1", dinner!['S1']!),
                                                      SizedBox(width: 5,),
                                                      buildSession(day, "Dinner", "S2", dinner['S2']!),
                                                      SizedBox(width: 5,),
                                                      buildSession(day, "Dinner", "S3", dinner['S3']!),
                                                      SizedBox(width: 5,),
                                                      buildSession(day, "Dinner", "S4", dinner['S4']!),
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

  bool _areAllBreakfastSessionSelected(String meal) {
    for(var meals in MenuEditorVariables.daysMealSession.values)
    {
      var m = meals[meal];

      for(var session in m!.values)
      {
        if(!session)
          {
            return false;
          }
      }
    }
    return true;
  }

  bool _areAllDays() {
    for(var meals in MenuEditorVariables.daysMealSession.values)
    {

      for(var session in meals.values)
      {
        for(var s in session.values)
          {
            if(!s)
            {
              return false;
            }
          }
      }
    }
    return true;
  }

  void setMeal(String meal, bool val) {
    for (var meals in MenuEditorVariables.daysMealSession.values) {
      var m = meals[meal];

      for (var sessionKey in m!.keys) {
        setState(() {
          m[sessionKey] = val;
        });
      }
    }
  }

  void setAllMeal(bool val) {
    for (var meals in MenuEditorVariables.daysMealSession.values) {

      for (var sessionKey in meals.values) {

        for(var s in sessionKey.keys)
          {
            setState(() {
              sessionKey[s] = val;
            });
          }
      }
    }
  }

  bool _aredaysSessions(String d) {
    for (var day in MenuEditorVariables.daysMealSession.keys) {
      var day1 = d;
      if (day == day1) {
        for (var session in MenuEditorVariables.daysMealSession[day]!.values) {
          for (var s in session.values) {
            if (!s) {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  void setDay(String d,bool val) {
    for(var day in MenuEditorVariables.daysMealSession.keys)
      {
        var day1 = d;
        if(day==day1)
          {
            for(var session in MenuEditorVariables.daysMealSession[day]!.values)
              {
                for(var sessionKey in session.keys)
                  {
                    setState(() {
                      session[sessionKey] = val;
                    });
                  }
              }
          }
      }
  }

  Widget buildSession(String day, String meal, String sessionKey, bool session) {
    return InkWell(
      onTap: () {
        setState(() {
          MenuEditorVariables.daysMealSession[day]![meal]![sessionKey] = !session;
        });
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
          child: Text(sessionKey, style: SafeGoogleFont(
            'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: GlobalVariables.textColor,
          ),),
        ),
      ),
    );
  }

  Widget buildSession1(String day, String meal, String sessionKey, bool session) {
    return InkWell(
      onTap: () {
        setState(() {
          MenuEditorVariables.daysMealSession[day]![meal]![sessionKey] = !session;
        });
      },
      child: Container(
        width: 25,
        height: 20,
        decoration: BoxDecoration(
          color: session ? GlobalVariables.primaryColor : GlobalVariables.whiteColor,
          border: Border.all(color: GlobalVariables.primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(sessionKey, style: SafeGoogleFont(
            'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: GlobalVariables.textColor,
          ),),
        ),
      ),
    );
  }
}
