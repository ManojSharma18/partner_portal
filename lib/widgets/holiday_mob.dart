import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/widgets/custom_button.dart';

import '../constants/global_variables.dart';
import '../constants/utils.dart';
import 'custom_textfield.dart';

class HolidayPage extends StatefulWidget {
  const HolidayPage({super.key});

  @override
  State<HolidayPage> createState() => _HolidayPageState();
}

class _HolidayPageState extends State<HolidayPage> {

  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        title: Text("Set vecation",style: SafeGoogleFont(
        'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: GlobalVariables.primaryColor,
    ),
      ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: 600,
        child: DefaultTabController(
          length: 2, // Number of tabs
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: GlobalVariables.primaryColor.withOpacity(0.3),
              toolbarHeight: 1,
              bottom: TabBar(
                labelPadding: EdgeInsets.symmetric(horizontal: 5),

                // Adjust the indicator weight
                indicatorColor: Color(0xfffbb830),
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: Colors.black54,
                labelColor: Color(0xFF363563),
                labelStyle: SafeGoogleFont(
                  'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF363563),
                ),
                tabs: [
                  Tab(text: 'Week'),
                  Tab(text: 'Range',)
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10*fem),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Container(
                                width: 110*fem,
                                child: Text('${DateFormat('EEE').format(today.add(Duration(days: 0)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 0)))}',style: GlobalVariables.dataItemStyle,)),

                            Transform.scale(
                              scale: 0.8,
                              child: Switch(value: true, onChanged: (val){

                              }),
                            ),
                            SizedBox(width: 130*fem,),
                            Checkbox(value: false, onChanged: (val) {

                            })
                          ],
                        ),
                        SizedBox(height: 10,),

                        DataTable(
                          dataRowHeight: 80,
                          columnSpacing: 10,

                          border: TableBorder.all(
                              color: Colors.black12,
                              width: 1,
                              style: BorderStyle.solid,
                              borderRadius: BorderRadius.circular(10)),
                          columns: [
                            DataColumn(label: Container(width: 60*fem,child: Text(''))),
                            DataColumn(label: Container(width: 65*fem,child: Text(''))),
                            DataColumn(label: Container(
                              width: 65*fem,
                              child: Center(
                                child: Text("Orders",style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color:GlobalVariables.textColor,
                                ),),
                              ),
                            ),),
                            DataColumn(label:
                            Container(
                              width: 70*fem,
                              child: Center(
                                child: Text("Subscription",style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color:GlobalVariables.textColor,
                                ),),
                              ),
                            ),),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Container(
                                  width: 60*fem,
                                  child: Text("Breakfast",style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.textColor,
                                  ),)),),
                              DataCell(
                                Column(
                                  children: [
                                    Transform.scale(
                                      scale: 0.6,
                                      child: Switch(value: true, onChanged: (val){

                                      }),
                                    ),
                                    SizedBox(height: 5,),
                                    Text("\u20B9 2000")
                                  ],
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        buildSession1(true),
                                        SizedBox(height: 5,),
                                        Text("\u20B9 200")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        buildSession1(false),
                                        SizedBox(height: 5,),
                                        Text("\u20B9 2000")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            DataRow(cells: [
                              DataCell(Container(
                                  width: 60*fem,
                                  child: Text("Lunch",style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.textColor,
                                  ),)),),
                              DataCell(
                                Column(
                                  children: [
                                    Transform.scale(
                                      scale: 0.6,
                                      child: Switch(value: true, onChanged: (val){

                                      }),
                                    ),
                                    SizedBox(height: 5,),
                                    Text("\u20B9 2000")
                                  ],
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        buildSession1(true),
                                        SizedBox(height: 5,),
                                        Text("\u20B9 200")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        buildSession1(false),
                                        SizedBox(height: 5,),
                                        Text("\u20B9 2000")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            DataRow(cells: [
                              DataCell(
                                Container(
                                  width: 60*fem,
                                  child: Text("Dinner",style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.textColor,
                                  ),)),),
                              DataCell(
                                Column(
                                  children: [
                                    Transform.scale(
                                      scale: 0.6,
                                      child: Switch(value: true, onChanged: (val){

                                      }),
                                    ),
                                    SizedBox(height: 5,),
                                    Text("\u20B9 2000")
                                  ],
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        buildSession1(true),
                                        SizedBox(height: 5,),
                                        Text("\u20B9 200")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        buildSession1(false),
                                        SizedBox(height: 5,),
                                        Text("\u20B9 2000")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]),

                          ],
                        ),

                        // Visibility(
                        //     child: Column(
                        //       children: [
                        //         Row(
                        //           children: [
                        //             Column(
                        //               children: [
                        //                 Transform.scale(
                        //                   scale: 0.6,
                        //                   child: Switch(value: true, onChanged: (val){
                        //
                        //                   }),
                        //                 ),
                        //                 SizedBox(height: 5,),
                        //                 Container(
                        //                     width: 80,
                        //                     child: Text("Breakfast",style: GlobalVariables.dataItemStyle,)),
                        //                 SizedBox(height: 5,),
                        //                 Text("\u20B9 2000")
                        //               ],
                        //             ),
                        //             SizedBox(width: 50,),
                        //             Column(
                        //               children: [
                        //                 Transform.scale(
                        //                   scale: 0.6,
                        //                   child: Switch(value: true, onChanged: (val){
                        //
                        //                   }),
                        //                 ),
                        //                 SizedBox(height: 5,),
                        //                 Text("Preorder",style: GlobalVariables.dataItemStyle,),
                        //                 SizedBox(height: 5,),
                        //                 Text("\u20B9 200")
                        //               ],
                        //             ),
                        //             SizedBox(width: 50,),
                        //             Column(
                        //               children: [
                        //                 Transform.scale(
                        //                   scale: 0.6,
                        //                   child: Switch(value: true, onChanged: (val){
                        //
                        //                   }),
                        //                 ),
                        //                 SizedBox(height: 5,),
                        //                 Text("Subscription",style: GlobalVariables.dataItemStyle,),
                        //                 SizedBox(height: 5,),
                        //                 Text("\u20B9 2000")
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //
                        //         SizedBox(height: 10,),
                        //         Row(
                        //           children: [
                        //             Column(
                        //               children: [
                        //                 Transform.scale(
                        //                   scale: 0.6,
                        //                   child: Switch(value: true, onChanged: (val){
                        //
                        //                   }),
                        //                 ),
                        //                 SizedBox(height: 5,),
                        //                 Container(width:80,child: Text("Lunch",style: GlobalVariables.dataItemStyle,)),
                        //                 SizedBox(height: 5,),
                        //                 Text("\u20B9 2000")
                        //               ],
                        //             ),
                        //             SizedBox(width: 50,),
                        //             Column(
                        //               children: [
                        //                 Transform.scale(
                        //                   scale: 0.6,
                        //                   child: Switch(value: true, onChanged: (val){
                        //
                        //                   }),
                        //                 ),
                        //                 SizedBox(height: 5,),
                        //                 Text("Preorder",style: GlobalVariables.dataItemStyle,),
                        //                 SizedBox(height: 5,),
                        //                 Text("\u20B9 200")
                        //               ],
                        //             ),
                        //             SizedBox(width: 50,),
                        //             Column(
                        //               children: [
                        //                 Transform.scale(
                        //                   scale: 0.6,
                        //                   child: Switch(value: true, onChanged: (val){
                        //
                        //                   }),
                        //                 ),
                        //                 SizedBox(height: 5,),
                        //                 Text("Subscription",style: GlobalVariables.dataItemStyle,),
                        //                 SizedBox(height: 5,),
                        //                 Text("\u20B9 2000")
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(height: 10,),
                        //         Row(
                        //           children: [
                        //             Column(
                        //               children: [
                        //                 Transform.scale(
                        //                   scale: 0.6,
                        //                   child: Switch(value: true, onChanged: (val){
                        //
                        //                   }),
                        //                 ),
                        //                 SizedBox(height: 5,),
                        //                 Container(width:80,child: Text("Dinner",style: GlobalVariables.dataItemStyle,)),
                        //                 SizedBox(height: 5,),
                        //                 Text("\u20B9 2000")
                        //               ],
                        //             ),
                        //             SizedBox(width: 50,),
                        //             Column(
                        //               children: [
                        //                 Transform.scale(
                        //                   scale: 0.6,
                        //                   child: Switch(value: true, onChanged: (val){
                        //
                        //                   }),
                        //                 ),
                        //                 SizedBox(height: 5,),
                        //                 Text("Preorder",style: GlobalVariables.dataItemStyle,),
                        //                 SizedBox(height: 5,),
                        //                 Text("\u20B9 200")
                        //               ],
                        //             ),
                        //             SizedBox(width: 50,),
                        //             Column(
                        //               children: [
                        //                 Transform.scale(
                        //                   scale: 0.6,
                        //                   child: Switch(value: true, onChanged: (val){
                        //
                        //                   }),
                        //                 ),
                        //                 SizedBox(height: 5,),
                        //                 Text("Subscription",style: GlobalVariables.dataItemStyle,),
                        //                 SizedBox(height: 5,),
                        //                 Text("\u20B9 2000")
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ],
                        //
                        //     )),

                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Container(
                                width: 110*fem,
                                child: Text('${DateFormat('EEE').format(today.add(Duration(days: 1)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 1)))}',style: GlobalVariables.dataItemStyle,)),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(value: true, onChanged: (val){

                              }),
                            ),
                            SizedBox(width: 130*fem,),
                            Checkbox(value: true, onChanged: (val) {

                            })
                          ],
                        ),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Container(
                                width: 110*fem,
                                child: Text('${DateFormat('EEE').format(today.add(Duration(days: 2)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 2)))}',style: GlobalVariables.dataItemStyle,)),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(value: true, onChanged: (val){

                              }),
                            ),
                            SizedBox(width: 130*fem,),
                            Checkbox(value: true, onChanged: (val) {

                            })
                          ],
                        ),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Container(
                                width: 110*fem,
                                child: Text('${DateFormat('EEE').format(today.add(Duration(days: 3)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 3)))}',style: GlobalVariables.dataItemStyle,)),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(value: true, onChanged: (val){

                              }),
                            ),
                            SizedBox(width: 130*fem,),
                            Checkbox(value: true, onChanged: (val) {

                            })
                          ],
                        ),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Container(
                                width: 110*fem,
                                child: Text('${DateFormat('EEE').format(today.add(Duration(days: 4)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 4)))}',style: GlobalVariables.dataItemStyle,)),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(value: true, onChanged: (val){

                              }),
                            ),
                            SizedBox(width: 130*fem,),
                            Checkbox(value: true, onChanged: (val) {

                            })
                          ],
                        ),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Container(
                                width: 110*fem,
                                child: Text('${DateFormat('EEE').format(today.add(Duration(days: 5)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 5)))}',style: GlobalVariables.dataItemStyle,)),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(value: true, onChanged: (val){

                              }),
                            ),
                            SizedBox(width: 130*fem,),
                            Checkbox(value: true, onChanged: (val) {

                            })
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10*fem),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          CustomTextField(label: "Start Date", controller: TextEditingController(),showCalendar: true,width: 150*fem,),
                          SizedBox(width: 15*fem,),
                          Column(
                            children: [
                              Text("to",style: TextStyle(
                                fontFamily: 'RenogareSoft',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: GlobalVariables.textColor,
                              ),),
                              SizedBox(height: 15,),
                              Text(":",style: TextStyle(
                                fontFamily: 'RenogareSoft',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: GlobalVariables.textColor,
                              ),),
                            ],
                          ),
                          SizedBox(width: 15*fem,),
                          CustomTextField(label: "End Date", controller: TextEditingController(),showCalendar: true,width: 150*fem,),
                        ],
                      )
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 10*fem,right: 10*fem),
        color: Colors.grey.shade100,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(text: "Cancel", onTap: (){
              Navigator.pop(context);
            }, color: Colors.red,textColor: GlobalVariables.textColor,),
            CustomButton(text: "Submit", onTap: (){
              Navigator.pop(context);
            }, color: GlobalVariables.primaryColor,textColor: GlobalVariables.textColor,)
          ],
        ),
      ),
    );
  }

  Widget buildSession1(bool offAndOn) {
    return InkWell(
      onTap: () {
        setState(() {

        });
      },
      child: Container(
        width: 35,
        height: 30,
        decoration: BoxDecoration(
          color: offAndOn ? GlobalVariables.primaryColor : GlobalVariables.whiteColor,
          border: Border.all(color: GlobalVariables.primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(offAndOn ? 'ON' : 'OFF', style: SafeGoogleFont(
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
