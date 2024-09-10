import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/order_constants/order_variables.dart';
import 'package:partner_admin_portal/widgets/small_custom_textfield.dart';

import '../../../constants/live_menu_constants/live_menu_functions.dart';
import '../../../constants/utils.dart';

class LiveMenuCountLunch extends StatefulWidget {
  const LiveMenuCountLunch({super.key});

  @override
  State<LiveMenuCountLunch> createState() => _LiveMenuCountState();
}

class _LiveMenuCountState extends State<LiveMenuCountLunch> {

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
                        child: Text( LiveMenuVariables.lunchTotal.text,style: GlobalVariables.dataItemStyle,)),
                    SizedBox(width: 20),
                    SmallCustomTextField(
                      textEditingController: LiveMenuVariables.lunchTotal,height: 30,width: 65,
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
                        child: Text( LiveMenuVariables.lnSession1Controller.text,style: GlobalVariables.dataItemStyle,)),
                    SizedBox(width: 20),
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
                        child: Text( LiveMenuVariables.lnSession2Controller.text,style: GlobalVariables.dataItemStyle,)),
                    SizedBox(width: 20),
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
                        child: Text( LiveMenuVariables.lnSession3Controller.text,style: GlobalVariables.dataItemStyle,)),
                    SizedBox(width: 20),
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
    );
  }
}
