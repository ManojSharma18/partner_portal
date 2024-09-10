import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_functions.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_functions.dart';
import 'package:partner_admin_portal/constants/order_constants/order_variables.dart';
import 'package:partner_admin_portal/widgets/small_custom_textfield.dart';

import '../../../constants/manage_settings/manage_settings_functions.dart';
import '../../../constants/manage_settings/manage_settings_variables.dart';
import '../../../constants/utils.dart';

class LiveMenuCountBreakfast extends StatefulWidget {
  const LiveMenuCountBreakfast({super.key});

  @override
  State<LiveMenuCountBreakfast> createState() => _LiveMenuCountState();
}

class _LiveMenuCountState extends State<LiveMenuCountBreakfast> {

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      color: GlobalVariables.whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height:15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 30*fem,),
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
                width:90*fem,
                height: 40,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                        child: Text( LiveMenuVariables.breakfastTotal.text,style: GlobalVariables.dataItemStyle,)),
                    SizedBox(width: 20),
                    SmallCustomTextField(
                      textEditingController:  LiveMenuVariables.breakfastTotal,height: 30,width: 65,
                      min:0,max:9999,
                      onChanged: (text){
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height:25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 30*fem,),
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
                width:90*fem,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                        child: Text( OrderVariables.bs1Controller.text,style: GlobalVariables.dataItemStyle,)),
                    SizedBox(width: 20),
                    SmallCustomTextField(
                        textEditingController: LiveMenuVariables.bfSession1Controller,height: 30,fontSize: 11,
                        min: 0,max:9999, width:65,

                      onChanged: (text) {
                        // Check if the text is blank or null, and set it to '0' if it is
                        if (text == null || text.isEmpty) {
                          LiveMenuVariables.bfSession1Controller.text = '0';  // or the relevant controller
                          text = '0';
                        }
                        LiveMenuFunctions.calculateBreakfastTotal();
                      },

                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 30*fem,),
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
                width:90*fem,
                child: Row(
                  children: [
                    Container(
                        width: 50,
                        child: Text( LiveMenuVariables.bfSession2Controller.text,style: GlobalVariables.dataItemStyle,)),
                    SizedBox(width: 20),
                    SmallCustomTextField(
                        textEditingController: LiveMenuVariables.bfSession2Controller,height: 30,fontSize: 11,
                        min: 0,max:9999, width:65,

                        onChanged:(text) {
                          TimeOfDay s1EndTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']!['Session1']!['EndTime']);
                          TimeOfDay s2EndTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']!['Session2']!['EndTime']);
                          TimeOfDay s2StartTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']!['Session2']!['StartTime']);
                          TimeOfDay s3StartTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']!['Session3']!['StartTime']);

                          int overlapSession1AndSession2 = ManageSettingFunction.compareTimeOfDay(s1EndTime, s2StartTime);

                          if(overlapSession1AndSession2 > 0 && int.parse(LiveMenuVariables.bfSession1Controller.text) > 0) {
                            showOverlappingMessage(context, "Session 2 overlapping with session 1 if u want to increase the count your session 1 count will be zero. Do you want to increase?");
                          }

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
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 30*fem,),
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
                width:90*fem,
                child: Row(
                  children: [
                    Container(
                        width: 50,
                        child: Text( LiveMenuVariables.bfSession3Controller.text,style: GlobalVariables.dataItemStyle,)),
                    SizedBox(width: 20),
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
          // SizedBox(height: 20,),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     SizedBox(width: 30*fem,),
          //     Container(
          //       width: 70,
          //       child: Text("S4 : ",style: SafeGoogleFont(
          //         'Poppins',
          //         fontSize: 15,
          //         fontWeight: FontWeight.bold,
          //         color:GlobalVariables.textColor,
          //       ),),
          //     ),
          //     SizedBox(width:20),
          //     Container(
          //       width:90*fem,
          //       child: Row(
          //         children: [
          //           Container(
          //               width: 50,
          //               child: Text( OrderVariables.bs4Controller.text,style: GlobalVariables.dataItemStyle,)),
          //           SizedBox(width: 20,),
          //           SmallCustomTextField(
          //               textEditingController: OrderVariables.bs4Controller,height: 30,fontSize: 11,
          //               min: 0,max:9999, width:65,
          //
          //               onChanged:(text){
          //
          //               }
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  void showOverlappingMessage(BuildContext context,String message,) {
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
                  LiveMenuVariables.bfSession1Controller.text = '0';
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
