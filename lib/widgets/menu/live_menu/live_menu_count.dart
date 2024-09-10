import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/order_constants/order_variables.dart';
import 'package:partner_admin_portal/widgets/small_custom_textfield.dart';

import '../../../constants/utils.dart';

class LiveMenuCount extends StatefulWidget {
  const LiveMenuCount({super.key});

  @override
  State<LiveMenuCount> createState() => _LiveMenuCountState();
}

class _LiveMenuCountState extends State<LiveMenuCount> {

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height:15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 30*fem,),
            Text("Total : ",style: SafeGoogleFont(
              'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color:GlobalVariables.textColor,
            ),),
            SizedBox(width:20),
            Container(
              width:90*fem,
              height: 40,
              child: Row(
                children: [
                  Text( OrderVariables.totalController.text,style: GlobalVariables.dataItemStyle,),
                  SizedBox(width: 10,),
                  SmallCustomTextField(
                    textEditingController: OrderVariables.totalController,height: 30,width: 65,
                    min:0,max:9999,
                    onChanged: (text){
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height:15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width:70*fem,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Breakfast : ",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color:GlobalVariables.textColor,
                      ),),
                      SizedBox(width: 10,),
                      Container(
                        width:35*fem,
                        height:35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text( OrderVariables.breakfastController.text,style: GlobalVariables.dataItemStyle,),
                            SizedBox(width: 5,),
                            SmallCustomTextField(
                              textEditingController: OrderVariables.breakfastController,height: 30,fontSize: 11,
                              width:65,
                              min: 0,max:9999,
                              onChanged: (text){

                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),

                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width:20*fem,
                      child: Column(
                        children: [
                          Text( OrderVariables.bs1Controller.text,style: GlobalVariables.dataItemStyle,),
                          SmallCustomTextField(
                              textEditingController: OrderVariables.bs1Controller,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

                              }
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      width:20*fem,
                      child: Column(
                        children: [
                          Text( OrderVariables.bs2Controller.text,style: GlobalVariables.dataItemStyle,),

                          SmallCustomTextField(
                              textEditingController: OrderVariables.bs2Controller,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

                              }
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      width:20*fem,
                      child: Column(
                        children: [
                          Text( OrderVariables.bs3Controller.text,style: GlobalVariables.dataItemStyle,),

                          SizedBox(width: 10,),
                          SmallCustomTextField(
                              textEditingController: OrderVariables.bs3Controller,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

                              }
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      width:20*fem,

                      child: Column(
                        children: [
                          Text( OrderVariables.bs4Controller.text,style: GlobalVariables.dataItemStyle,),
                          SmallCustomTextField(
                              textEditingController: OrderVariables.bs4Controller,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

                              }
                          ),

                        ],
                      ),
                    ),
                  ],
                ),


              ],
            ),
            SizedBox(height:30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width:65*fem,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Lunch : ",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color:GlobalVariables.textColor,
                      ),),
                      SizedBox(width: 10,),
                      Container(
                        width:35*fem,
                        height:35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text( OrderVariables.lunchController.text,style: GlobalVariables.dataItemStyle,),
                            SizedBox(width: 5,),
                            SmallCustomTextField(
                              textEditingController: OrderVariables.lunchController,height: 30,fontSize: 11,
                              width:65,
                              min: 0,max:9999,
                              onChanged: (text){

                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),


                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width:20*fem,
                      child: Column(
                        children: [
                          Text( OrderVariables.ls1Controller.text,style: GlobalVariables.dataItemStyle,),

                          SizedBox(width: 10,),
                          SmallCustomTextField(
                              textEditingController: OrderVariables.ls1Controller,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

                              }
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      width:20*fem,
                      child: Column(
                        children: [
                          Text( OrderVariables.ls2Controller.text,style: GlobalVariables.dataItemStyle,),

                          SizedBox(width: 10,),
                          SmallCustomTextField(
                              textEditingController: OrderVariables.ls2Controller,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

                              }
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      width:20*fem,
                      child: Column(
                        children: [
                          Text( OrderVariables.ls3Controller.text,style: GlobalVariables.dataItemStyle,),

                          SizedBox(width: 10,),
                          SmallCustomTextField(
                              textEditingController: OrderVariables.ls3Controller,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

                              }
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      width:20*fem,

                      child: Column(
                        children: [
                          Text( OrderVariables.ls4Controller.text,style: GlobalVariables.dataItemStyle,),

                          SizedBox(width: 10,),
                          SmallCustomTextField(
                              textEditingController: OrderVariables.ls4Controller,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

                              }
                          ),

                        ],
                      ),
                    ),
                  ],
                ),


              ],
            ),
            SizedBox(height:30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 65*fem,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Dinner : ",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color:GlobalVariables.textColor,
                      ),),
                      SizedBox(width: 10,),
                      Container(
                        width:35*fem,
                        height:35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text( OrderVariables.breakfastController.text,style: GlobalVariables.dataItemStyle,),
                            SizedBox(width: 5,),
                            SmallCustomTextField(
                              textEditingController: OrderVariables.breakfastController,height: 30,fontSize: 11,
                              width:65,
                              min: 0,max:9999,
                              onChanged: (text){

                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width:20*fem,
                      child: Column(
                        children: [
                          Text( OrderVariables.ds1Controller.text,style: GlobalVariables.dataItemStyle,),

                          SizedBox(width: 10,),
                          SmallCustomTextField(
                              textEditingController: OrderVariables.ds1Controller,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

                              }
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      width:20*fem,
                      child: Column(
                        children: [
                          Text( OrderVariables.ds2Controller.text,style: GlobalVariables.dataItemStyle,),

                          SizedBox(width: 10,),
                          SmallCustomTextField(
                              textEditingController: OrderVariables.ds2Controller,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

                              }
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      width:20*fem,
                      child: Column(
                        children: [
                          Text( OrderVariables.ds3Controller.text,style: GlobalVariables.dataItemStyle,),

                          SizedBox(width: 10,),
                          SmallCustomTextField(
                              textEditingController: OrderVariables.ds3Controller,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

                              }
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      width:20*fem,

                      child: Column(
                        children: [
                          Text( OrderVariables.ds4Controller.text,style: GlobalVariables.dataItemStyle,),

                          SizedBox(width: 10,),
                          SmallCustomTextField(
                              textEditingController: OrderVariables.ds4Controller,height: 30,fontSize: 11,
                              min: 0,max:9999, width:65,

                              onChanged:(text){

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
        )
      ],
    );
  }
}
