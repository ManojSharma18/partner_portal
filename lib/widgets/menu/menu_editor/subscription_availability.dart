import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/menu_editor/menu_editor_state.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_variables.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';

import '../../../bloc/menu_editor/menu_editor_bloc.dart';
import '../../../bloc/menu_editor/menu_editor_event.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';

class SubscriptionAvailability extends StatefulWidget {
  const SubscriptionAvailability({super.key});

  @override
  State<SubscriptionAvailability> createState() => _SubscriptionAvailabilityState();
}

class _SubscriptionAvailabilityState extends State<SubscriptionAvailability> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return ResponsiveBuilder(mobileBuilder: (BuildContext context,BoxConstraints constraints){
      return BlocBuilder<MenuEditorBloc,MenuEditorState>(builder: (BuildContext mcontext, state) {
        return Center(
            child: Container(

              child:  DataTable(
                  columnSpacing: 10,
                  dataRowHeight: 60,
                  border: TableBorder.all(
                      color: Colors.black12,
                      width: 0.5,
                      style: BorderStyle.solid,
                      borderRadius: BorderRadius.circular(10)),
                  columns: <DataColumn> [
                    DataColumn(
                        label: Column(
                          children: [
                            Text("Days",style:SafeGoogleFont(
                              'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.textColor,
                            ),),
                            SizedBox(height: 5,),
                            Checkbox(
                                value: _areAllDaysMob(),
                                onChanged: (val) {
                                  mcontext.read<MenuEditorBloc>().add(SelectAllDaysSubEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSubMob, val!));
                                })
                          ],
                        )),
                    DataColumn(label: Container(
                      width: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          Text("Breakfast",style:SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: GlobalVariables.textColor,
                          ),),
                          SizedBox(height: 3,),
                          Checkbox(
                              value: _areAllBreakfastSessionSelectedMob('Breakfast'),
                              onChanged: (val) {
                                context.read<MenuEditorBloc>().add(SelectMealsEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSubMob,'Breakfast', val!));
                              })
                        ],
                      ),
                    )),
                    DataColumn(
                        label: Container(
                          width: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text("Lunch",style:SafeGoogleFont(
                                'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.textColor,
                              ),),
                              SizedBox(height: 3,),
                              Checkbox(value: _areAllBreakfastSessionSelectedMob('Lunch'), onChanged: (val){
                                context.read<MenuEditorBloc>().add(SelectMealsEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSubMob,'Lunch', val!));
                              })
                            ],
                          ),
                        )),
                    DataColumn(
                        label: Container(
                          width: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text("Dinner",style:SafeGoogleFont(
                                'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.textColor,
                              ),),
                              SizedBox(height: 3,),
                              Checkbox(value: _areAllBreakfastSessionSelectedMob('Dinner'), onChanged: (val){
                                context.read<MenuEditorBloc>().add(SelectMealsEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSubMob,'Dinner', val!));
                              })
                            ],
                          ),
                        )),
                  ],
                  rows: MenuEditorVariables.daysMealSessionSubMob.keys.map((String day) {
                    var meals = MenuEditorVariables.daysMealSessionSubMob[day] ?? const {};
                    var breakfast = meals['Breakfast'];
                    var lunch = meals['Lunch'];
                    var dinner = meals['Dinner'];
                    return DataRow(cells: <DataCell>[
                      DataCell(
                          Column(
                            mainAxisAlignment:MainAxisAlignment.center,
                            children: [
                              Text(day,style:SafeGoogleFont(
                                'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.textColor,
                              ),),
                              SizedBox(height: 3,),
                              Checkbox(value: _aredaysSessionsMob(day), onChanged: (value){
                                context.read<MenuEditorBloc>().add(SelectSingleDayEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSubMob,day, value!));
                              })
                            ],
                          )),
                      DataCell(
                          Row(
                            mainAxisAlignment : MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 3,),
                              buildSession1Mob(day, "Breakfast", "B1", breakfast!['B1']!),
                              SizedBox(width: 5,),
                              buildSession1Mob(day, "Breakfast", "B2", breakfast['B2']!),
                            ],
                          )
                      ),
                      DataCell(
                          Row(
                            mainAxisAlignment : MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 3,),
                              buildSession1Mob(day, "Lunch", "B1", lunch!['B1']!),
                              SizedBox(width: 5,),
                              buildSession1Mob(day, "Lunch", "B2", lunch['B2']!),
                            ],
                          )
                      ),
                      DataCell(
                          Row(
                            mainAxisAlignment : MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 3,),
                              buildSession1Mob(day, "Dinner", "B1", dinner!['B1']!),
                              SizedBox(width: 5,),
                              buildSession1Mob(day, "Dinner", "B2", dinner['B2']!),
                            ],
                          )
                      ),
                    ]);
                  }).toList()
              ),
            )
        );
      },

      );
    },
        tabletBuilder: (BuildContext context,BoxConstraints constraints){
      return Column(
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
                      groupValue: MenuEditorVariables.selectedOptionSub,
                      onChanged: (value) {
                        setState(() {
                          MenuEditorVariables.selectedOptionSub = value!;
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
                      groupValue: MenuEditorVariables.selectedOptionSub,
                      onChanged: (value) {
                        setState(() {
                          MenuEditorVariables.selectedOptionSub = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),


            ],
          ),
          SizedBox(height: 20,),
          Visibility(
            visible: MenuEditorVariables.selectedOptionSub ==1,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(left: 30, right: 30,),
                child: DataTable(
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
                                    context.read<MenuEditorBloc>().add(SelectAllDaysSubEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSub, val!));
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
                                context.read<MenuEditorBloc>().add(SelectMealsEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSub,'Breakfast', val!));
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
                              Checkbox(
                                  value: _areAllBreakfastSessionSelected('Lunch'),
                                  onChanged: (val) {
                                    context.read<MenuEditorBloc>().add(SelectMealsEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSub,'Lunch', val!));
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
                              Checkbox(
                                  value: _areAllBreakfastSessionSelected('Dinner'),
                                  onChanged: (val) {
                                    context.read<MenuEditorBloc>().add(SelectMealsEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSub,'Dinner', val!));
                                  })
                            ],
                          )),
                    ],
                    rows: MenuEditorVariables.daysMealSessionSub.keys.map((String day) {
                      var meals = MenuEditorVariables.daysMealSessionSub[day] ?? const {};
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
                                  context.read<MenuEditorBloc>().add(SelectSingleDayEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSub,day, value!));
                                })
                              ],
                            )),
                        DataCell(
                            Row(
                              mainAxisAlignment : MainAxisAlignment.start,
                              children: [
                                buildSession1(day, "Breakfast", "B1", breakfast!['B1']!),
                                SizedBox(width: 5,),
                                buildSession1(day, "Breakfast", "B2", breakfast['B2']!),
                                SizedBox(width: 5,),
                                buildSession1(day, "Breakfast", "B3", breakfast['B3']!),
                              ],
                            )
                        ),
                        DataCell(
                            Row(
                              mainAxisAlignment : MainAxisAlignment.start,
                              children: [
                                buildSession1(day, "Lunch", "B1", lunch!['B1']!),
                                SizedBox(width: 5,),
                                buildSession1(day, "Lunch", "B2", lunch['B2']!),
                                SizedBox(width: 5,),
                                buildSession1(day, "Lunch", "B3", lunch['B3']!),
                              ],
                            )
                        ),
                        DataCell(
                            Row(
                              mainAxisAlignment : MainAxisAlignment.start,
                              children: [
                                buildSession1(day, "Dinner", "B1", dinner!['B1']!),
                                SizedBox(width: 5,),
                                buildSession1(day, "Dinner", "B2", dinner['B2']!),
                                SizedBox(width: 5,),
                                buildSession1(day, "Dinner", "B3", dinner['B3']!),
                              ],
                            )
                        ),
                      ]);
                    }).toList()
                ),
              ),
            ),
          ),
        ],
      );
    },
        desktopBuilder: (BuildContext context,BoxConstraints constraints){
          return Column(
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
                          groupValue: MenuEditorVariables.selectedOptionSub,
                          onChanged: (value) {
                            setState(() {
                              MenuEditorVariables.selectedOptionSub = value!;
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
                          groupValue: MenuEditorVariables.selectedOptionSub,
                          onChanged: (value) {
                            setState(() {
                              MenuEditorVariables.selectedOptionSub = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),


                ],
              ),
              SizedBox(height: 20,),
              Visibility(
                visible: MenuEditorVariables.selectedOptionSub ==1,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 30, right: 30,),
                    child: DataTable(
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
                                        context.read<MenuEditorBloc>().add(SelectAllDaysSubEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSub, val!));
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
                                    context.read<MenuEditorBloc>().add(SelectMealsEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSub,'Breakfast', val!));
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
                                  Checkbox(
                                      value: _areAllBreakfastSessionSelected('Lunch'),
                                      onChanged: (val) {
                                        context.read<MenuEditorBloc>().add(SelectMealsEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSub,'Lunch', val!));
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
                                  Checkbox(
                                      value: _areAllBreakfastSessionSelected('Dinner'),
                                      onChanged: (val) {
                                        context.read<MenuEditorBloc>().add(SelectMealsEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSub,'Dinner', val!));
                                      })
                                ],
                              )),
                        ],
                        rows: MenuEditorVariables.daysMealSessionSub.keys.map((String day) {
                          var meals = MenuEditorVariables.daysMealSessionSub[day] ?? const {};
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
                                      context.read<MenuEditorBloc>().add(SelectSingleDayEvent(MenuEditorVariables.selectedCategories,MenuEditorVariables.menuFoodCategories, MenuEditorVariables.selectedItem,MenuEditorVariables.daysMealSessionSub,day, value!));
                                    })
                                  ],
                                )),
                            DataCell(
                                Row(
                                  mainAxisAlignment : MainAxisAlignment.start,
                                  children: [
                                    buildSession1(day, "Breakfast", "B1", breakfast!['B1']!),
                                    SizedBox(width: 5,),
                                    buildSession1(day, "Breakfast", "B2", breakfast['B2']!),
                                    SizedBox(width: 5,),
                                    buildSession1(day, "Breakfast", "B3", breakfast['B3']!),
                                  ],
                                )
                            ),
                            DataCell(
                                Row(
                                  mainAxisAlignment : MainAxisAlignment.start,
                                  children: [
                                    buildSession1(day, "Lunch", "B1", lunch!['B1']!),
                                    SizedBox(width: 5,),
                                    buildSession1(day, "Lunch", "B2", lunch['B2']!),
                                    SizedBox(width: 5,),
                                    buildSession1(day, "Lunch", "B3", lunch['B3']!),
                                  ],
                                )
                            ),
                            DataCell(
                                Row(
                                  mainAxisAlignment : MainAxisAlignment.start,
                                  children: [
                                    buildSession1(day, "Dinner", "B1", dinner!['B1']!),
                                    SizedBox(width: 5,),
                                    buildSession1(day, "Dinner", "B2", dinner['B2']!),
                                    SizedBox(width: 5,),
                                    buildSession1(day, "Dinner", "B3", dinner['B3']!),
                                  ],
                                )
                            ),
                          ]);
                        }).toList()
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget buildSession2(String day, String meal, String sessionKey, Map<String, dynamic> session) {
    return InkWell(
      onTap: () {
        TextEditingController _textFieldController = TextEditingController();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Enter count for $sessionKey"),
              content: TextField(
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Enter count here"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
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
                    setState(() {
                      int count = int.tryParse(_textFieldController.text) ?? 0;
                      MenuEditorVariables.daysMealSessionSub1[day]![meal]![sessionKey]!['count'] = count;
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

  bool _areAllBreakfastSessionSelected(String meal) {
    for(var meals in MenuEditorVariables.daysMealSessionSub.values)
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
    for(var meals in MenuEditorVariables.daysMealSessionSub.values)
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
    for (var meals in MenuEditorVariables.daysMealSessionSub.values) {
      var m = meals[meal];

      for (var sessionKey in m!.keys) {
        setState(() {
          m[sessionKey] = val;
        });
      }
    }
  }

  void setAllMeal(bool val) {
    for (var meals in MenuEditorVariables.daysMealSessionSub.values) {

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
    for (var day in MenuEditorVariables.daysMealSessionSub.keys) {
      var day1 = d;
      if (day == day1) {
        for (var session in MenuEditorVariables.daysMealSessionSub[day]!.values) {
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
    for(var day in MenuEditorVariables.daysMealSessionSub.keys)
    {
      var day1 = d;
      if(day==day1)
      {
        for(var session in MenuEditorVariables.daysMealSessionSub[day]!.values)
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
          MenuEditorVariables.daysMealSessionSub[day]![meal]![sessionKey] = !session;
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
          MenuEditorVariables.daysMealSessionSub[day]![meal]![sessionKey] = !session;
        });
      },
      child: Container(
        width: 35,
        height: 25,
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


  bool _areAllBreakfastSessionSelectedMob(String meal) {
    for(var meals in MenuEditorVariables.daysMealSessionSubMob.values)
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

  bool _areAllDaysMob() {
    for(var meals in MenuEditorVariables.daysMealSessionSubMob.values)
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

  void setMealMob(String meal, bool val) {
    for (var meals in MenuEditorVariables.daysMealSessionSubMob.values) {
      var m = meals[meal];

      for (var sessionKey in m!.keys) {
        setState(() {
          m[sessionKey] = val;
        });
      }
    }
  }

  void setAllMealMob(bool val) {
    for (var meals in MenuEditorVariables.daysMealSessionSubMob.values) {

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

  bool _aredaysSessionsMob(String d) {
    for (var day in MenuEditorVariables.daysMealSessionSubMob.keys) {
      var day1 = d;
      if (day == day1) {
        for (var session in MenuEditorVariables.daysMealSessionSubMob[day]!.values) {
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

  void setDayMob(String d,bool val) {
    for(var day in MenuEditorVariables.daysMealSessionSubMob.keys)
    {
      var day1 = d;
      if(day==day1)
      {
        for(var session in MenuEditorVariables.daysMealSessionSubMob[day]!.values)
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



  Widget buildSession1Mob(String day, String meal, String sessionKey, bool session) {
    return InkWell(
      onTap: () {
        setState(() {
          MenuEditorVariables.daysMealSessionSubMob[day]![meal]![sessionKey] = !session;
        });
      },
      child: Container(
        width: 35,
        height: 25,
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
