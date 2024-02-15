import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/responsive_builder.dart';

import '../constants/utils.dart';

class ItemAvailability extends StatefulWidget {
  const ItemAvailability({Key? key}) : super(key: key);

  @override
  State<ItemAvailability> createState() => _ItemAvailabilityState();
}

class _ItemAvailabilityState extends State<ItemAvailability> {
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


  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return ResponsiveBuilder(mobileBuilder: (BuildContext context,BoxConstraints constraints){
      return Container();
    }, tabletBuilder: (BuildContext context,BoxConstraints constraints){
      return Container();
    }, desktopBuilder: (BuildContext context,BoxConstraints constraints){
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
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 100*fem,
                        child: RadioListTile(
                          title: Text('Item available all time when restaurant is open',style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: GlobalVariables.textColor,
                          ),),
                          value: 2,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  RadioListTile(
                    title: Text('Item available on selected schedule when restaurant is working',style:
                    SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color:GlobalVariables.textColor,
                    ),),
                    value: 3,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                ],
              ),

              Visibility(
                visible: selectedOption != 1,
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
                            columnSpacing: 30,
                            border: TableBorder.all(
                                color: Colors.black12,
                                width: 0.5,
                                style: BorderStyle.solid,
                                borderRadius: BorderRadius.circular(10)),
                            columns: <DataColumn> [
                              DataColumn(
                                  label: Text("Days",style:SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.textColor,
                                  ),)),
                              DataColumn(label: Row(
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
                            rows: daysMealSession.keys.map((String day) {
                              var meals = daysMealSession[day] ?? const {};
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
}
