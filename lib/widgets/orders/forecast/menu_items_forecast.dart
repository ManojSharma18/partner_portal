import 'package:flutter/material.dart';
import 'package:partner_admin_portal/models/restaurant_menu.dart';
import 'package:partner_admin_portal/widgets/custom_button.dart';

import '../../../constants/global_variables.dart';
import '../../../constants/live_menu_constants/live_menu_functions.dart';
import '../../../constants/live_menu_constants/live_menu_variables.dart';
import '../../../models/live_menu_model.dart';
import '../../../repository/menu_services.dart';
import '../../small_custom_textfield.dart';

class MenuItemWidget extends StatefulWidget {
  final Mymenu item;
  static String itemId = '';
  final int index;
  MenuItemWidget({required this.item, required this.index});

  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  late TextEditingController totalCountController;
  late TextEditingController breakfastTotalController;
  late TextEditingController lunchTotalController;
  late TextEditingController dinnerTotalController;
  late TextEditingController bfs1Controller;
  late TextEditingController bfs2Controller;
  late TextEditingController bfs3Controller;
  late TextEditingController bfs4Controller;
  late TextEditingController lns1Controller;
  late TextEditingController lns2Controller;
  late TextEditingController lns3Controller;
  late TextEditingController lns4Controller;
  late TextEditingController dns1Controller;
  late TextEditingController dns2Controller;
  late TextEditingController dns3Controller;
  late TextEditingController dns4Controller;
  double height = 85.0;

  @override
  void initState() {
    super.initState();
    totalCountController = TextEditingController(text: widget.item.totalCount.toString());
    breakfastTotalController = TextEditingController(text: widget.item.fpUnitSessions.breakfast.defaultSession.availableCount.toString());
    lunchTotalController = TextEditingController(text: widget.item.fpUnitSessions.lunch.defaultSession.availableCount.toString());
    dinnerTotalController = TextEditingController(text: widget.item.fpUnitSessions.dinner.defaultSession.availableCount.toString());
    bfs1Controller = TextEditingController(text: widget.item.fpUnitSessions.breakfast.session1.availableCount.toString());
    bfs2Controller = TextEditingController(text: widget.item.fpUnitSessions.breakfast.session2.availableCount.toString());
    bfs3Controller = TextEditingController(text: widget.item.fpUnitSessions.breakfast.session3.availableCount.toString());
    bfs4Controller = TextEditingController(text: widget.item.fpUnitSessions.breakfast.session4.availableCount.toString());
    lns1Controller = TextEditingController(text: widget.item.fpUnitSessions.lunch.session1.availableCount.toString());
    lns2Controller = TextEditingController(text: widget.item.fpUnitSessions.lunch.session2.availableCount.toString());
    lns3Controller = TextEditingController(text: widget.item.fpUnitSessions.lunch.session3.availableCount.toString());
    lns4Controller = TextEditingController(text: widget.item.fpUnitSessions.lunch.session4.availableCount.toString());
    dns1Controller = TextEditingController(text: widget.item.fpUnitSessions.dinner.session1.availableCount.toString());
    dns2Controller = TextEditingController(text: widget.item.fpUnitSessions.dinner.session2.availableCount.toString());
    dns3Controller = TextEditingController(text: widget.item.fpUnitSessions.dinner.session3.availableCount.toString());
    dns4Controller = TextEditingController(text: widget.item.fpUnitSessions.dinner.session4.availableCount.toString());
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      width: 350*fem,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Padding(
                padding: EdgeInsets.only(left: 10*fem,top: 5),
                child: Container(width :5*fem,child: Text("${widget.index+1}",style: GlobalVariables.dataItemStyle,)),
              ),
              Container(width: 1,color: GlobalVariables.textColor.withOpacity(0.5),),
              Padding(
                padding: EdgeInsets.only(left: 10*fem,top: 5),
                child: Container(width :75*fem,child: Text("${widget.item.dname}",style: GlobalVariables.dataItemStyle,)),
              ),
              Container(width: 1,color: GlobalVariables.textColor.withOpacity(0.5),),

              // TextField(
              //   controller: totalCountController,
              //   onChanged: (value) {
              //     setState(() {
              //       widget.item.totalCount = int.tryParse(value) ?? 0;
              //       // Update other counts as needed
              //     });
              //   },
              // ),
              Container(
                width: 50*fem,
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width:40, child: Text(totalCountController.text,style: GlobalVariables.dataItemStyle)),
                        SizedBox(width: 10,),
                        SmallCustomTextField(textEditingController: totalCountController, onChanged: (text) {
                          if(MenuItemWidget.itemId != "" && MenuItemWidget.itemId != widget.item.id)
                          {
                            showAlertDialog(context,MenuItemWidget.itemId,LiveMenuVariables.total.text,LiveMenuVariables.breakfastTotal.text,LiveMenuVariables.lunchTotal.text,LiveMenuVariables.dinnerTotal.text,LiveMenuVariables.bfSession1Controller.text,LiveMenuVariables.bfSession2Controller.text,LiveMenuVariables.bfSession3Controller.text,LiveMenuVariables.bfSession4Controller.text,LiveMenuVariables.lnSession1Controller.text,LiveMenuVariables.lnSession2Controller.text,LiveMenuVariables.lnSession3Controller.text,LiveMenuVariables.lnSession4Controller.text,LiveMenuVariables.dnSession1Controller.text,LiveMenuVariables.dnSession2Controller.text,LiveMenuVariables.dnSession3Controller.text,LiveMenuVariables.dnSession4Controller.text);
                          }
                          MenuItemWidget.itemId = widget.item.id!;
                          LiveMenuVariables.total = totalCountController;
                          LiveMenuVariables.breakfastTotal = breakfastTotalController;
                          LiveMenuVariables.lunchTotal = lunchTotalController;
                          LiveMenuVariables.dinnerTotal = dinnerTotalController;
                          LiveMenuVariables.bfSession1Controller = bfs1Controller;
                          LiveMenuVariables.bfSession2Controller = bfs2Controller;
                          LiveMenuVariables.bfSession3Controller = bfs3Controller;
                          LiveMenuVariables.bfSession4Controller = bfs4Controller;
                          LiveMenuVariables.lnSession1Controller = lns1Controller;
                          LiveMenuVariables.lnSession2Controller = lns2Controller;
                          LiveMenuVariables.lnSession3Controller = lns3Controller;
                          LiveMenuVariables.lnSession4Controller = lns4Controller;
                          LiveMenuVariables.dnSession1Controller = dns1Controller;
                          LiveMenuVariables.dnSession2Controller = dns2Controller;
                          LiveMenuVariables.dnSession3Controller = dns3Controller;
                          LiveMenuVariables.dnSession4Controller = dns4Controller;
                          print("Item id is ${MenuItemWidget.itemId}");
                          int reminder = (int.parse(text!)) % 3;
                          breakfastTotalController.text = (int.parse(text)/3).toInt().toString();
                          lunchTotalController.text = (int.parse(text)/3).toInt().toString();
                          dinnerTotalController.text = ((int.parse(text)/3).toInt()+ reminder).toString();
                          int reminderBreakfast = (int.parse(breakfastTotalController.text)) % 4;
                          bfs1Controller.text = (int.parse(breakfastTotalController.text)/4).toInt().toString();
                          bfs2Controller.text  = (int.parse(breakfastTotalController.text)/4).toInt().toString();
                          bfs3Controller.text = (int.parse(breakfastTotalController.text)/4).toInt().toString();
                          bfs4Controller.text  = ((int.parse(breakfastTotalController.text)/4).toInt()+ reminderBreakfast).toString();

                          int reminderLunch = (int.parse(lunchTotalController.text)) % 4;
                          lns1Controller.text = (int.parse(lunchTotalController.text)/4).toInt().toString();
                          lns2Controller.text = (int.parse(lunchTotalController.text)/4).toInt().toString();
                          lns3Controller.text = (int.parse(lunchTotalController.text)/4).toInt().toString();
                          lns4Controller.text = ((int.parse(lunchTotalController.text)/4).toInt()+ reminderLunch).toString();

                          int reminderDinner = (int.parse(dinnerTotalController.text)) % 4;
                          dns1Controller.text = (int.parse(dinnerTotalController.text)/4).toInt().toString();
                          dns2Controller.text = (int.parse(dinnerTotalController.text)/4).toInt().toString();
                          dns3Controller.text = (int.parse(dinnerTotalController.text)/4).toInt().toString();
                          dns4Controller.text = ((int.parse(dinnerTotalController.text)/4).toInt()+ reminderDinner).toString();
                          if(int.parse(totalCountController.text) > 9999)
                          {
                            LiveMenuFunctions.showExceedLimitAlertDialog(context);
                          }
                        }, min: 1, max: 1,width: 70,height:35,fontSize: 14,),
                      ],
                    ),
                  ],
                ),
              ),

              Container(width: 2,color: GlobalVariables.textColor.withOpacity(0.5),),

              Container(width: 60*fem,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width:40, child: Text(breakfastTotalController.text,style: GlobalVariables.dataItemStyle)),
                        SizedBox(width: 10,),
                        SmallCustomTextField(textEditingController: breakfastTotalController, onChanged: (text) {
                          int reminder = (int.parse(text!)) % 3;
                          breakfastTotalController.text = (int.parse(text)/3).toInt().toString();
                          lunchTotalController.text = (int.parse(text)/3).toInt().toString();
                          dinnerTotalController.text = ((int.parse(text)/3).toInt()+ reminder).toString();
                          int reminderBreakfast = (int.parse(breakfastTotalController.text)) % 4;
                          bfs1Controller.text = (int.parse(breakfastTotalController.text)/4).toInt().toString();
                          bfs2Controller.text = (int.parse(breakfastTotalController.text)/4).toInt().toString();
                          bfs3Controller.text = (int.parse(breakfastTotalController.text)/4).toInt().toString();
                          bfs4Controller.text = ((int.parse(breakfastTotalController.text)/4).toInt()+ reminderBreakfast).toString();

                          int reminderLunch = (int.parse(lunchTotalController.text)) % 4;
                          lns1Controller.text = (int.parse(lunchTotalController.text)/4).toInt().toString();
                          lns2Controller.text = (int.parse(lunchTotalController.text)/4).toInt().toString();
                          lns3Controller.text = (int.parse(lunchTotalController.text)/4).toInt().toString();
                          lns4Controller.text = ((int.parse(lunchTotalController.text)/4).toInt()+ reminderLunch).toString();

                          int reminderDinner = (int.parse(dinnerTotalController.text)) % 4;
                          LiveMenuVariables.dnSession1Controller.text = (int.parse(dinnerTotalController.text)/4).toInt().toString();
                          LiveMenuVariables.dnSession2Controller.text = (int.parse(dinnerTotalController.text)/4).toInt().toString();
                          LiveMenuVariables.dnSession3Controller.text = (int.parse(dinnerTotalController.text)/4).toInt().toString();
                          LiveMenuVariables.dnSession4Controller.text = ((int.parse(dinnerTotalController.text)/4).toInt()+ reminderDinner).toString();
                          if(int.parse(totalCountController.text) > 9999)
                          {
                            LiveMenuFunctions.showExceedLimitAlertDialog(context);
                          }
                        }, min: 1, max: 1,width: 70,height:35,fontSize: 14,),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Visibility(
                      visible:height == 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(bfs1Controller.text,style: GlobalVariables.dataItemStyle),
                              SizedBox(height: 5,),
                              SmallCustomTextField(textEditingController:bfs1Controller,onChanged:(text){

                                LiveMenuVariables.breakfastTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.bfSession2Controller.text) + int.parse(LiveMenuVariables.bfSession3Controller.text) + int.parse(LiveMenuVariables.bfSession4Controller.text) ).toString();
                                LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                {
                                  LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                }
                              }, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                              SizedBox(height: 5,),
                              Text("S1",style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(bfs2Controller.text,style: GlobalVariables.dataItemStyle),
                              SizedBox(height: 5,),
                              SmallCustomTextField(textEditingController: bfs2Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,
                                  onChanged:(text){
                                    LiveMenuVariables.breakfastTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.bfSession1Controller.text) + int.parse(LiveMenuVariables.bfSession3Controller.text) + int.parse(LiveMenuVariables.bfSession4Controller.text) ).toString();
                                    LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                    if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                    {
                                      LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                    }
                                  }),
                              SizedBox(height: 5,),
                              Text("S2",style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(bfs3Controller.text,style: GlobalVariables.dataItemStyle),
                              SizedBox(height: 5,),
                              SmallCustomTextField(textEditingController: bfs3Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11, onChanged:(text){

                                LiveMenuVariables.breakfastTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.bfSession2Controller.text) + int.parse(LiveMenuVariables.bfSession1Controller.text) + int.parse(LiveMenuVariables.bfSession4Controller.text) ).toString();
                                LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                {
                                  LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                }
                              }),
                              SizedBox(height: 5,),
                              Text("S3",style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(bfs4Controller.text,style: GlobalVariables.dataItemStyle),
                              SizedBox(height: 5,),
                              SmallCustomTextField(textEditingController: bfs4Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,
                                  onChanged:(text){
                                    LiveMenuVariables.breakfastTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.bfSession2Controller.text) + int.parse(LiveMenuVariables.bfSession3Controller.text) + int.parse(LiveMenuVariables.bfSession1Controller.text) ).toString();
                                    LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                    if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                    {
                                      LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                    }
                                  }),
                              SizedBox(height: 5,),
                              Text("S4",style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Container(width: 1,color: GlobalVariables.textColor.withOpacity(0.5),),

              Container(width: 60*fem,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width:40, child: Text(lunchTotalController.text,style: GlobalVariables.dataItemStyle)),
                        SizedBox(width: 10,),
                        SmallCustomTextField(textEditingController: lunchTotalController, onChanged: (text) {
                          int reminder = (int.parse(text!)) % 3;
                          LiveMenuVariables.breakfastTotal.text = (int.parse(text)/3).toInt().toString();
                          LiveMenuVariables.lunchTotal.text = (int.parse(text)/3).toInt().toString();
                          LiveMenuVariables.dinnerTotal.text = ((int.parse(text)/3).toInt()+ reminder).toString();
                          int reminderBreakfast = (int.parse(LiveMenuVariables.breakfastTotal.text)) % 4;
                          LiveMenuVariables.bfSession1Controller.text = (int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt().toString();
                          LiveMenuVariables.bfSession2Controller.text = (int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt().toString();
                          LiveMenuVariables.bfSession3Controller.text = (int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt().toString();
                          LiveMenuVariables.bfSession4Controller.text = ((int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt()+ reminderBreakfast).toString();

                          int reminderLunch = (int.parse(LiveMenuVariables.lunchTotal.text)) % 4;
                          LiveMenuVariables.lnSession1Controller.text = (int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt().toString();
                          LiveMenuVariables.lnSession2Controller.text = (int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt().toString();
                          LiveMenuVariables.lnSession3Controller.text = (int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt().toString();
                          LiveMenuVariables.lnSession4Controller.text = ((int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt()+ reminderLunch).toString();

                          int reminderDinner = (int.parse(LiveMenuVariables.dinnerTotal.text)) % 4;
                          LiveMenuVariables.dnSession1Controller.text = (int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt().toString();
                          LiveMenuVariables.dnSession2Controller.text = (int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt().toString();
                          LiveMenuVariables.dnSession3Controller.text = (int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt().toString();
                          LiveMenuVariables.dnSession4Controller.text = ((int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt()+ reminderDinner).toString();
                          if(int.parse(LiveMenuVariables.total.text) > 9999)
                          {
                            LiveMenuFunctions.showExceedLimitAlertDialog(context);
                          }
                        }, min: 1, max: 1,width: 70,height:35,fontSize: 14,),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Visibility(
                      visible:height == 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(lns1Controller.text,style: GlobalVariables.dataItemStyle),
                              SizedBox(height: 5,),
                              SmallCustomTextField(textEditingController:lns1Controller,
                                onChanged:(text){

                                  LiveMenuVariables.lunchTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.lnSession2Controller.text) + int.parse(LiveMenuVariables.lnSession3Controller.text) + int.parse(LiveMenuVariables.lnSession4Controller.text) ).toString();
                                  LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                  if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                  {
                                    LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                  }
                                },min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                              SizedBox(height: 5,),
                              Text("S1",style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                          Column(
                            children: [
                              Text(lns2Controller.text,style: GlobalVariables.dataItemStyle),
                              SizedBox(height: 5,),
                              SmallCustomTextField(textEditingController: lns2Controller,
                                onChanged:(text){
                                  LiveMenuVariables.lunchTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.lnSession1Controller.text) + int.parse(LiveMenuVariables.lnSession3Controller.text) + int.parse(LiveMenuVariables.lnSession4Controller.text) ).toString();
                                  LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                  if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                  {
                                    LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                  }
                                },min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                              SizedBox(height: 5,),
                              Text("S2",style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                          Column(
                            children: [
                              Text(lns3Controller.text,style: GlobalVariables.dataItemStyle),
                              SizedBox(height: 5,),
                              SmallCustomTextField(textEditingController: lns3Controller,onChanged:(text){
                                LiveMenuVariables.lunchTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.lnSession2Controller.text) + int.parse(LiveMenuVariables.lnSession1Controller.text) + int.parse(LiveMenuVariables.lnSession4Controller.text) ).toString();
                                LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                {
                                  LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                }
                              }, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                              SizedBox(height: 5,),
                              Text("S3",style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                          Column(
                            children: [
                              Text(lns4Controller.text,style: GlobalVariables.dataItemStyle),
                              SizedBox(height: 5,),
                              SmallCustomTextField(textEditingController: lns4Controller,onChanged:(text){

                                LiveMenuVariables.lunchTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.lnSession2Controller.text) + int.parse(LiveMenuVariables.lnSession3Controller.text) + int.parse(LiveMenuVariables.lnSession1Controller.text) ).toString();
                                LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                {
                                  LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                }
                              }, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                              SizedBox(height: 5,),
                              Text("S4",style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Container(width: 1,color: GlobalVariables.textColor.withOpacity(0.5),),

              Container(width: 60*fem,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width:40, child: Text(dinnerTotalController.text,style: GlobalVariables.dataItemStyle)),
                        SizedBox(width: 10,),
                        SmallCustomTextField(textEditingController: dinnerTotalController, onChanged: (text) {
                          int reminder = (int.parse(text!)) % 3;
                          LiveMenuVariables.breakfastTotal.text = (int.parse(text)/3).toInt().toString();
                          LiveMenuVariables.lunchTotal.text = (int.parse(text)/3).toInt().toString();
                          LiveMenuVariables.dinnerTotal.text = ((int.parse(text)/3).toInt()+ reminder).toString();
                          int reminderBreakfast = (int.parse(LiveMenuVariables.breakfastTotal.text)) % 4;
                          LiveMenuVariables.bfSession1Controller.text = (int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt().toString();
                          LiveMenuVariables.bfSession2Controller.text = (int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt().toString();
                          LiveMenuVariables.bfSession3Controller.text = (int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt().toString();
                          LiveMenuVariables.bfSession4Controller.text = ((int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt()+ reminderBreakfast).toString();

                          int reminderLunch = (int.parse(LiveMenuVariables.lunchTotal.text)) % 4;
                          LiveMenuVariables.lnSession1Controller.text = (int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt().toString();
                          LiveMenuVariables.lnSession2Controller.text = (int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt().toString();
                          LiveMenuVariables.lnSession3Controller.text = (int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt().toString();
                          LiveMenuVariables.lnSession4Controller.text = ((int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt()+ reminderLunch).toString();

                          int reminderDinner = (int.parse(LiveMenuVariables.dinnerTotal.text)) % 4;
                          LiveMenuVariables.dnSession1Controller.text = (int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt().toString();
                          LiveMenuVariables.dnSession2Controller.text = (int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt().toString();
                          LiveMenuVariables.dnSession3Controller.text = (int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt().toString();
                          LiveMenuVariables.dnSession4Controller.text = ((int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt()+ reminderDinner).toString();
                          if(int.parse(LiveMenuVariables.total.text) > 9999)
                          {
                            LiveMenuFunctions.showExceedLimitAlertDialog(context);
                          }
                        }, min: 1, max: 1,width: 70,height:35,fontSize: 14,),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Visibility(
                      visible:height == 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(dns1Controller.text,style: GlobalVariables.dataItemStyle),
                              SizedBox(height: 5,),
                              SmallCustomTextField(textEditingController: dns1Controller,
                                onChanged:(text){

                                  LiveMenuVariables.dinnerTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.dnSession2Controller.text) + int.parse(LiveMenuVariables.dnSession3Controller.text) + int.parse(LiveMenuVariables.dnSession4Controller.text) ).toString();
                                  LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                  if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                  {
                                    LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                  }
                                },min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                              SizedBox(height: 5,),
                              Text("S1",style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                          Column(
                            children: [
                              Text(dns2Controller.text,style: GlobalVariables.dataItemStyle),
                              SizedBox(height: 5,),
                              SmallCustomTextField(textEditingController:dns2Controller, onChanged:(text){
                                LiveMenuVariables.dinnerTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.dnSession4Controller.text) + int.parse(LiveMenuVariables.dnSession3Controller.text) + int.parse(LiveMenuVariables.dnSession1Controller.text) ).toString();
                                LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                {
                                  LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                }
                              },min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                              SizedBox(height: 5,),
                              Text("S2",style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                          Column(
                            children: [
                              Text(dns3Controller.text,style: GlobalVariables.dataItemStyle),
                              SizedBox(height: 5,),
                              SmallCustomTextField(textEditingController: dns3Controller,onChanged:(text){
                                LiveMenuVariables.dinnerTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.dnSession2Controller.text) + int.parse(LiveMenuVariables.dnSession4Controller.text) + int.parse(LiveMenuVariables.dnSession1Controller.text) ).toString();
                                LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                {
                                  LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                }
                              }, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                              SizedBox(height: 5,),
                              Text("S3",style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                          Column(
                            children: [
                              Text(dns4Controller.text,style: GlobalVariables.dataItemStyle),
                              SizedBox(height: 5,),
                              SmallCustomTextField(textEditingController: dns4Controller, onChanged:(text){

                                LiveMenuVariables.dinnerTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.dnSession2Controller.text) + int.parse(LiveMenuVariables.dnSession3Controller.text) + int.parse(LiveMenuVariables.dnSession1Controller.text) ).toString();
                                LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                {
                                  LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                }
                              },min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                              SizedBox(height: 5,),
                              Text("S4",style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              ),
              SizedBox(width: 5*fem,),

              InkWell(
                  onTap:(){
                    // context.read<ForecastBloc>().add(ItemHeightEvent(index,GlobalVariables.rowHeights));
                    print(breakfastTotalController.text);
                    setState(() {
                      if(height==85.0)
                        {
                          height = 150.0;
                        }else{
                        height=85.0;
                      }

                    });
                  },
                  child: Icon(Icons.more_horiz_rounded,size: 20,color: GlobalVariables.textColor.withOpacity(0.8),)),


              // Other text fields for breakfastTotal, lunchTotal, dinnerTotal
            ],
          ),
          Container(height: 0.5,color: GlobalVariables.textColor.withOpacity(0.5),)
        ],
      ),
    );
  }



  void showAlertDialog(BuildContext context,String id,String total,String breakfastTotal,String lunchTotal,String dinnerTotal,String bfs1Total,String bfs2Total,String bfs3Total,String bfs4Total,String lns1Total,String lns2Total,String lns3Total,String lns4Total,String dns1Total,String dns2Total,String dns3Total,String dns4Total,) {
    // Create the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Do you want to save changes?"),
      content: Text("This is an alert dialog. "),
      actions: [
      CustomButton(text: "Update", onTap: (){
        print("$bfs1Total $bfs2Total $bfs3Total $bfs4Total");
          Map<String, dynamic> requestBody = {
            "totalCount":int.parse(total),
            "fp_unit_sessions": {
              "Breakfast": {
                "Default": {
                  "Enabled": true,
                  "availableCount": int.parse(breakfastTotal),
                },
                "Session1": {
                  "Enabled": true,
                  "availableCount": int.parse(bfs1Total),
                },
                "Session2": {
                  "Enabled": true,
                  "availableCount": int.parse(bfs2Total),
                },
                "Session3": {
                  "Enabled": true,
                  "availableCount": int.parse(bfs3Total),
                },
                "Session4": {
                  "Enabled": true,
                  "availableCount": int.parse(bfs3Total),
                },
              },
              "Lunch": {
                "Default": {
                  "Enabled": true,
                  "availableCount": int.parse(lunchTotal),
                },
                "Session1": {
                  "Enabled": true,
                  "availableCount": int.parse(lns1Total),
                },
                "Session2": {
                  "Enabled": true,
                  "availableCount": int.parse(lns2Total),
                },
                "Session3": {
                  "Enabled": true,
                  "availableCount": int.parse(lns3Total),
                },
                "Session4": {
                  "Enabled": true,
                  "availableCount": int.parse(lns4Total),
                },
              },
              "Dinner": {
                "Default": {
                  "Enabled": true,
                  "availableCount": int.parse(dinnerTotal),
                },
                "Session1": {
                  "Enabled": true,
                  "availableCount": int.parse(dns1Total),
                },
                "Session2": {
                  "Enabled": true,
                  "availableCount": int.parse(dns2Total),
                },
                "Session3": {
                  "Enabled": true,
                  "availableCount": int.parse(dns3Total),
                },
                "Session4": {
                  "Enabled": true,
                  "availableCount": int.parse(dns4Total),
                },
              },
            },
          };
          MenuService menuService = MenuService();
          menuService.updateLiveMenu(id, requestBody);
          Navigator.pop(context);

      }, color: GlobalVariables.textColor)
      ],
    );

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // @override
  // void dispose() {
  //   totalCountController.dispose();
  //   breakfastTotalController.dispose();
  //   lunchTotalController.dispose();
  //   dinnerTotalController.dispose();
  //   super.dispose();
  // }

}