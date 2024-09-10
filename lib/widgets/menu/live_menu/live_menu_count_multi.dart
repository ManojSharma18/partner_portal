import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_functions.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/order_constants/order_variables.dart';
import 'package:partner_admin_portal/widgets/small_custom_textfield.dart';

import '../../../constants/utils.dart';

class LiveMenuCountMulti extends StatefulWidget {
  const LiveMenuCountMulti({super.key});

  @override
  State<LiveMenuCountMulti> createState() => _LiveMenuCountState();
}

class _LiveMenuCountState extends State<LiveMenuCountMulti> {

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SingleChildScrollView(
      child: Container(
        color: GlobalVariables.whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 110*fem,),
                Container(
                  width: 70,
                  child: Text("Total : ",style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color:GlobalVariables.textColor,
                  ),),
                ),
                SizedBox(width:20),
                Container(
                  width:60*fem,
                  height: 40,
                  child: Row(
                    children: [
                      Container(
                          width: 50,
                          child: Text( LiveMenuVariables.total.text,style: GlobalVariables.dataItemStyle,)),
                      SizedBox(width: 20),
                      SmallCustomTextField(
                        textEditingController: LiveMenuVariables.total,height: 30,width: 65,
                        min:0,max:9999,
                        onChanged: (text){
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height:30),
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width:10*fem),
                    Container(
                      width: 30*fem,
                      child: Text("Breakfast: ",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color:GlobalVariables.textColor,
                      ),),
                    ),
                    SizedBox(width:5*fem),
                    Container(
                      width:60*fem,
                      child: Row(
                        children: [
                          Container(
                              width: 50,
                              child: Text( LiveMenuVariables.breakfastTotal.text,style: GlobalVariables.dataItemStyle,)),
                          SizedBox(width: 10*fem),
                          SmallCustomTextField(
                              textEditingController: LiveMenuVariables.breakfastTotal,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

                              }
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5*fem,),
                        Container(
                          width: 70,
                          child: Text("S1 : ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ),
                        SizedBox(width:20),
                        Container(
                          width:60*fem,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( LiveMenuVariables.bfSession1Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 15),
                              SmallCustomTextField(
                                  textEditingController: LiveMenuVariables.bfSession1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){
                                    if (text == null || text.isEmpty) {
                                      LiveMenuVariables.bfSession1Controller.text = '0';  // or the relevant controller
                                      text = '0';
                                    }
                                    LiveMenuFunctions.calculateBreakfastTotal();
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5*fem,),
                        Container(
                          width: 70,
                          child: Text("S2 : ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ),
                        SizedBox(width:20),
                        Container(
                          width:60*fem,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( LiveMenuVariables.bfSession2Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 15),
                              SmallCustomTextField(
                                  textEditingController: LiveMenuVariables.bfSession2Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){
                                    if (text == null || text.isEmpty) {
                                      LiveMenuVariables.bfSession2Controller.text = '0';  // or the relevant controller
                                      text = '0';
                                    }
                                    LiveMenuFunctions.calculateBreakfastTotal();
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5*fem,),
                        Container(
                          width: 70,
                          child: Text("S3 : ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ),
                        SizedBox(width:20),
                        Container(
                          width:60*fem,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( LiveMenuVariables.bfSession3Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 15),
                              SmallCustomTextField(
                                  textEditingController: LiveMenuVariables.bfSession3Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){
                                    if (text == null || text.isEmpty) {
                                      LiveMenuVariables.bfSession3Controller.text = '0';  // or the relevant controller
                                      text = '0';
                                    }
                                    LiveMenuFunctions.calculateBreakfastTotal();
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height:30),
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width:10*fem),
                    Container(
                      width: 30*fem,
                      child: Text("Lunch: ",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color:GlobalVariables.textColor,
                      ),),
                    ),
                    SizedBox(width:5*fem),
                    Container(
                      width:60*fem,
                      child: Row(
                        children: [
                          Container(
                              width: 50,
                              child: Text( LiveMenuVariables.lunchTotal.text,style: GlobalVariables.dataItemStyle,)),
                          SizedBox(width: 10*fem),
                          SmallCustomTextField(
                              textEditingController: LiveMenuVariables.lunchTotal,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

                              }
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5*fem,),
                        Container(
                          width: 70,
                          child: Text("S1 : ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ),
                        SizedBox(width:20),
                        Container(
                          width:60*fem,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( LiveMenuVariables.lnSession1Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 15),
                              SmallCustomTextField(
                                  textEditingController: LiveMenuVariables.lnSession1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){
                                    if (text == null || text.isEmpty) {
                                      LiveMenuVariables.lnSession1Controller.text = '0';  // or the relevant controller
                                      text = '0';
                                    }
                                    LiveMenuFunctions.calculateLunchTotal();
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5*fem,),
                        Container(
                          width: 70,
                          child: Text("S2 : ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ),
                        SizedBox(width:20),
                        Container(
                          width:60*fem,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( LiveMenuVariables.lnSession2Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 15),
                              SmallCustomTextField(
                                  textEditingController: LiveMenuVariables.lnSession2Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){
                                    if (text == null || text.isEmpty) {
                                      LiveMenuVariables.lnSession2Controller.text = '0';  // or the relevant controller
                                      text = '0';
                                    }
                                    LiveMenuFunctions.calculateLunchTotal();
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5*fem,),
                        Container(
                          width: 70,
                          child: Text("S3 : ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ),
                        SizedBox(width:20),
                        Container(
                          width:60*fem,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( LiveMenuVariables.lnSession3Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 15),
                              SmallCustomTextField(
                                  textEditingController: LiveMenuVariables.lnSession3Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){
                                    if (text == null || text.isEmpty) {
                                      LiveMenuVariables.lnSession3Controller.text = '0';  // or the relevant controller
                                      text = '0';
                                    }
                                    LiveMenuFunctions.calculateLunchTotal();
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ],
            ),
            SizedBox(height:30),
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width:10*fem),
                    Container(
                      width: 30*fem,
                      child: Text("Dinner: ",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color:GlobalVariables.textColor,
                      ),),
                    ),
                    SizedBox(width:5*fem),
                    Container(
                      width:60*fem,
                      child: Row(
                        children: [
                          Container(
                              width: 50,
                              child: Text( LiveMenuVariables.dinnerTotal.text,style: GlobalVariables.dataItemStyle,)),
                          SizedBox(width: 10*fem),
                          SmallCustomTextField(
                              textEditingController: LiveMenuVariables.dinnerTotal,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

                              }
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5*fem,),
                        Container(
                          width: 70,
                          child: Text("S1 : ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ),
                        SizedBox(width:20),
                        Container(
                          width:60*fem,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( LiveMenuVariables.dnSession1Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 15),
                              SmallCustomTextField(
                                  textEditingController: LiveMenuVariables.dnSession1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){
                                    if (text == null || text.isEmpty) {
                                      LiveMenuVariables.dnSession1Controller.text = '0';  // or the relevant controller
                                      text = '0';
                                    }
                                    LiveMenuFunctions.calculateDinnerTotal();
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5*fem,),
                        Container(
                          width: 70,
                          child: Text("S2 : ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ),
                        SizedBox(width:20),
                        Container(
                          width:60*fem,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( LiveMenuVariables.dnSession2Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 15),
                              SmallCustomTextField(
                                  textEditingController: LiveMenuVariables.dnSession2Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){
                                    if (text == null || text.isEmpty) {
                                      LiveMenuVariables.dnSession2Controller.text = '0';  // or the relevant controller
                                      text = '0';
                                    }
                                    LiveMenuFunctions.calculateDinnerTotal();
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5*fem,),
                        Container(
                          width: 70,
                          child: Text("S3 : ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ),
                        SizedBox(width:20),
                        Container(
                          width:60*fem,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( LiveMenuVariables.dnSession3Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 15),
                              SmallCustomTextField(
                                  textEditingController: LiveMenuVariables.dnSession3Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){
                                    if (text == null || text.isEmpty) {
                                      LiveMenuVariables.dnSession3Controller.text = '0';  // or the relevant controller
                                      text = '0';
                                    }
                                    LiveMenuFunctions.calculateDinnerTotal();
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
