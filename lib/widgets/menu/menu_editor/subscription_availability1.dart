import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_variables.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';

import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';

class SubscriptionAvailability1 extends StatefulWidget {
  const SubscriptionAvailability1({super.key});

  @override
  State<SubscriptionAvailability1> createState() => _SubscriptionAvailabilityState();
}

class _SubscriptionAvailabilityState extends State<SubscriptionAvailability1> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return ResponsiveBuilder(
        mobileBuilder: (BuildContext context,BoxConstraints constraints){
      return Center(
          child: Container(
            margin: EdgeInsets.only(left: 10*fem, right: 10*fem,),
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
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: GlobalVariables.textColor,
                          ),),
                        ],
                      )),
                  DataColumn(
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 15,),
                          Container(
                            width: 55,
                            child: Text("Breakfast",style:SafeGoogleFont(
                              'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.textColor,
                            ),),
                          ),
                          SizedBox(width: 15,),
                        ],
                      )),
                  DataColumn(
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 15,),
                          Container(
                            width: 50,
                            child: Text("Lunch   ",style:SafeGoogleFont(
                              'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.textColor,
                            ),),
                          ),
                          SizedBox(width: 15,),
                        ],
                      )),
                  DataColumn(
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 15,),
                          Container(
                            width: 50,
                            child: Text("Dinner  ",style:SafeGoogleFont(
                              'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.textColor,
                            ),),
                          ),
                          SizedBox(width: 15,),
                        ],
                      )),
                ],
                rows: MenuEditorVariables.daysMealSessionSub.keys.map((String day) {
                  var meals = MenuEditorVariables.daysMealSessionSub1[day] ?? const {};
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
                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                          children: [
                            buildSessionMob(day, "Breakfast", "B1", breakfast!['B1']!),

                            buildSessionMob(day, "Breakfast", "B2", breakfast['B2']!),

                          ],
                        )
                    ),
                    DataCell(
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                          children: [
                            buildSessionMob(day, "Lunch", "B1", lunch!['B1']!),

                            buildSessionMob(day, "Lunch", "B2", lunch['B2']!),

                          ],
                        )
                    ),
                    DataCell(
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                          children: [
                            buildSessionMob(day, "Dinner", "B1", dinner!['B1']!),

                            buildSessionMob(day, "Dinner", "B2", dinner['B2']!),

                          ],
                        )
                    ),
                  ]);
                }).toList()
            ),
          )
      );
    }, tabletBuilder: (BuildContext context,BoxConstraints constraints){
      return Center(
          child: Column(
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
              Container(
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
                            ],
                          )),
                      DataColumn(
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 20,),
                              Container(
                                width: 80,
                                child: Text("Breakfast",style:SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: GlobalVariables.textColor,
                                ),),
                              ),
                              SizedBox(width: 20,),
                            ],
                          )),
                      DataColumn(
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 20,),
                              Container(
                                width: 80,
                                child: Text("Lunch   ",style:SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: GlobalVariables.textColor,
                                ),),
                              ),
                              SizedBox(width: 20,),
                            ],
                          )),
                      DataColumn(
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 20,),
                              Container(
                                width: 80,
                                child: Text("Dinner  ",style:SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: GlobalVariables.textColor,
                                ),),
                              ),
                              SizedBox(width: 20,),
                            ],
                          )),
                    ],
                    rows: MenuEditorVariables.daysMealSessionSub.keys.map((String day) {
                      var meals = MenuEditorVariables.daysMealSessionSub1[day] ?? const {};
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
                              mainAxisAlignment:MainAxisAlignment.start,
                              children: [
                                buildSession2(day, "Breakfast", "B1", breakfast!['B1']!),
                                SizedBox(width: 5,),
                                buildSession2(day, "Breakfast", "B2", breakfast['B2']!),
                                SizedBox(width: 5,),
                                buildSession2(day, "Breakfast", "B3", breakfast['B3']!),

                              ],
                            )
                        ),
                        DataCell(
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceAround,
                              children: [
                                buildSession2(day, "Lunch", "B1", lunch!['B1']!),
                                SizedBox(width: 5,),
                                buildSession2(day, "Lunch", "B2", lunch['B2']!),
                                SizedBox(width: 5,),
                                buildSession2(day, "Lunch", "B3", breakfast['B3']!),

                              ],
                            )
                        ),
                        DataCell(
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceAround,
                              children: [
                                buildSession2(day, "Dinner", "B1", dinner!['B1']!),
                                SizedBox(width: 5,),
                                buildSession2(day, "Dinner", "B2", dinner['B2']!),
                                SizedBox(width: 5,),
                                buildSession2(day, "Dinner", "B3", dinner['B3']!),

                              ],
                            )
                        ),
                      ]);
                    }).toList()
                ),
              ),
            ],
          )
      );
    },
        desktopBuilder: (BuildContext context,BoxConstraints constraints){
      return Center(
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
                        ],
                      )),
                  DataColumn(
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 20,),
                          Container(
                            width: 80,
                            child: Text("Breakfast",style:SafeGoogleFont(
                              'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.textColor,
                            ),),
                          ),
                          SizedBox(width: 20,),
                        ],
                      )),
                  DataColumn(
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20,),
                          Container(
                            width: 80,
                            child: Text("Lunch   ",style:SafeGoogleFont(
                              'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.textColor,
                            ),),
                          ),
                          SizedBox(width: 20,),
                        ],
                      )),
                  DataColumn(
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20,),
                          Container(
                            width: 80,
                            child: Text("Dinner  ",style:SafeGoogleFont(
                              'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.textColor,
                            ),),
                          ),
                          SizedBox(width: 20,),
                        ],
                      )),
                ],
                rows: MenuEditorVariables.daysMealSessionSub.keys.map((String day) {
                  var meals = MenuEditorVariables.daysMealSessionSub1[day] ?? const {};
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
                          mainAxisAlignment:MainAxisAlignment.start,
                          children: [
                            buildSession2(day, "Breakfast", "B1", breakfast!['B1']!),
                            SizedBox(width: 5,),
                            buildSession2(day, "Breakfast", "B2", breakfast['B2']!),
                            SizedBox(width: 5,),
                            buildSession2(day, "Breakfast", "B3", breakfast['B3']!),

                          ],
                        )
                    ),
                    DataCell(
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                          children: [
                            buildSession2(day, "Lunch", "B1", lunch!['B1']!),
                            SizedBox(width: 5,),
                            buildSession2(day, "Lunch", "B2", lunch['B2']!),
                            SizedBox(width: 5,),
                            buildSession2(day, "Lunch", "B3", breakfast['B3']!),

                          ],
                        )
                    ),
                    DataCell(
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceAround,
                          children: [
                            buildSession2(day, "Dinner", "B1", dinner!['B1']!),
                            SizedBox(width: 5,),
                            buildSession2(day, "Dinner", "B2", dinner['B2']!),
                            SizedBox(width: 5,),
                            buildSession2(day, "Dinner", "B3", dinner['B3']!),

                          ],
                        )
                    ),
                  ]);
                }).toList()
            ),
          )
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
                    hintText: "Enter count"
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4)
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

  Widget buildSessionMob(String day, String meal, String sessionKey, Map<String, dynamic> session) {
    return InkWell(
      onTap: () {
        TextEditingController _textFieldController = TextEditingController();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Enter count for $sessionKey",style: TextStyle(
                fontFamily: 'RenogareSoft',
                fontSize: 12,
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
                    hintText: "Enter count"
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3)
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
        width: 38,
        height: 27,
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
}