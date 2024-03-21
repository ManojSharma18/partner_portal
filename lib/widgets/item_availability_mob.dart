import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  Map<String,Map<String,bool>> mealSessions = {
    'Breakfast' : {"s1" : true,"s2" : false, "s3" : false},
    "Lunch" : {"s1" : true,"s2" : true, "s3" : true},
    "Dinner" : {"s1" : true,"s2" : false, "s3" : false}
  };

  Map<String,Map<String,Map<String,bool>>> daysMealSession = {
    "Sun" :
    {
      "Breakfast" : { "S1" : true,"S2" : true,"S3" : true,"S4" : true },
      "Lunch" : { "S1" : true,"S2" : true,"S3" : true , "S4" : false},
      "Dinner" : { "S1" : true,"S2" : true,"S3" : true , "S4" : false },
    },
    "Mon" :
    {
      "Breakfast" : { "S1" : false,"S2" : false,"S3" : false,"S4" : false },
      "Lunch" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
      "Dinner" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
    },
    "Tue" :
    {
      "Breakfast" : { "S1" : false,"S2" : false,"S3" : false,"S4" : false },
      "Lunch" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
      "Dinner" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
    },
    "Wed" :
    {
      "Breakfast" : { "S1" : false,"S2" : false,"S3" : false,"S4" : false },
      "Lunch" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
      "Dinner" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
    },
    "Thu" :
    {
      "Breakfast" : { "S1" : false,"S2" : false,"S3" : false,"S4" : false },
      "Lunch" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
      "Dinner" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
    },
    "Fri" :
    {
      "Breakfast" : { "S1" : false,"S2" : false,"S3" : false,"S4" : false },
      "Lunch" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
      "Dinner" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
    },
    "Sat" :
    {
      "Breakfast" : { "S1" : false,"S2" : false,"S3" : false,"S4" : false },
      "Lunch" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
      "Dinner" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
    },
  };

  MealTime selectedMealTime = MealTime.Breakfast;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildMealTimeButton1(MealTime.Breakfast, 'Breakfast'),
                buildMealTimeButton1(MealTime.Lunch, 'Lunch'),
                buildMealTimeButton1(MealTime.Dinner, 'Dinner'),
              ],
            ),
          ),
          SizedBox(height: 30,),

          Visibility(
            visible: selectedMealTime ==  MealTime.Breakfast,
            child: Column(
              children: [
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
                                        setAllMeal(val!);
                                      })
                                ],
                              )),
                          DataColumn(label: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 20,),
                              Text("Breakfast session",style:SafeGoogleFont(
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
                        ],
                        rows: daysMealSession.keys.map((String day) {
                          var meals = daysMealSession[day] ?? const {};
                          var breakfast = meals['Breakfast'];
                          var lunch = meals['Lunch'];
                          var dinner = meals['Dinner'];
                          return DataRow(cells: <DataCell>[
                            DataCell(
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
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

                          ]);
                        }).toList()
                    ),
                  ],
                )
              ],
            ),
          ),
          Visibility(
            visible: selectedMealTime ==  MealTime.Lunch,
            child: Row(
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
                                    setAllMeal(val!);
                                  })
                            ],
                          )),

                      DataColumn(
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 20,),
                              Text("Lunch sessions",style:SafeGoogleFont(
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

                    ],
                    rows: daysMealSession.keys.map((String day) {
                      var meals = daysMealSession[day] ?? const {};
                      var breakfast = meals['Breakfast'];
                      var lunch = meals['Lunch'];
                      var dinner = meals['Dinner'];
                      return DataRow(cells: <DataCell>[
                        DataCell(
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
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
                      ]);
                    }).toList()
                ),
              ],
            ),
          ),
          Visibility(
            visible: selectedMealTime ==  MealTime.Dinner,
            child: Column(
              children: [
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
                                        setAllMeal(val!);
                                      })
                                ],
                              )),

                          DataColumn(
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 20,),
                                  Text("Dinner sessions",style:SafeGoogleFont(
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
                        rows: daysMealSession.keys.map((String day) {
                          var meals = daysMealSession[day] ?? const {};
                          var breakfast = meals['Breakfast'];
                          var lunch = meals['Lunch'];
                          var dinner = meals['Dinner'];
                          return DataRow(cells: <DataCell>[
                            DataCell(
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 130*fem,
                margin: EdgeInsets.all(20*fem),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black54),
                ),
                child: Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    // ItemDetails.checking = false;
                    // if(ItemDetails.displayNameController.text != '')
                    // {
                    //   editFoodName(selectedCategory, selectedItem, ItemDetails.displayNameController.text);
                    // }
                  });
                },
                child: Container(
                  width: 130*fem,
                  margin: EdgeInsets.all(20*fem),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue, // Replace with your primary color
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "Save changes",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
          
        ],
      ),
    );
  }

  bool _areAllBreakfastSessionSelected(String meal) {
    for(var meals in daysMealSession.values)
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
    for(var meals in daysMealSession.values)
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

  Widget buildMealTimeButton1(MealTime mealTime, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedMealTime == mealTime ? GlobalVariables.textColor : selectedMealTime == MealTime.All ? GlobalVariables.textColor : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMealTime = mealTime;
        });
      },
      child: Container(
        width: 75*fem,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color:GlobalVariables.textColor),
          color: backgroundColor,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   getMealTimeImage(mealTime),
              //   width: 15.48 * fem,
              //   height: 14.09 * fem,
              // ),
              // SizedBox(width: 7 * fem),
              Text(
                label,
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1.3102272749 * ffem / fem,
                  color: GlobalVariables.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setMeal(String meal, bool val) {
    for (var meals in daysMealSession.values) {
      var m = meals[meal];

      for (var sessionKey in m!.keys) {
        setState(() {
          m[sessionKey] = val;
        });
      }
    }
  }

  void setAllMeal( bool val) {
    for (var meals in daysMealSession.values) {

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
    for (var day in daysMealSession.keys) {
      var day1 = d;
      if (day == day1) {
        for (var session in daysMealSession[day]!.values) {
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

  void setDay(String d,bool val){
    for(var day in daysMealSession.keys)
    {
      var day1 = d;
      if(day==day1)
      {
        for(var session in daysMealSession[day]!.values)
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
          daysMealSession[day]![meal]![sessionKey] = !session;
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
          daysMealSession[day]![meal]![sessionKey] = !session;
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
