import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:partner_admin_portal/bloc/order_forecast/forecast_bloc.dart';
import 'package:partner_admin_portal/bloc/order_forecast/forecast_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_functions.dart';
import 'package:partner_admin_portal/constants/order_constants/order_variables.dart';
import 'package:partner_admin_portal/models/live_menu_model.dart';
import 'package:partner_admin_portal/widgets/custom_button.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/widgets/small_custom_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/menu/menu_bloc.dart';
import '../../../bloc/menu/menu_event.dart';
import '../../../bloc/menu/menu_state.dart';
import '../../../bloc/order_forecast/forecast_event.dart';
import '../../../constants/live_menu_constants/live_menu_variables.dart';
import '../../../repository/menu_services.dart';
import 'menu_items_forecast.dart';


class ItemDetailsTable extends StatelessWidget {
   bool loaded;
   ItemDetailsTable({Key? key, required this.loaded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return BlocProvider(
      create: (BuildContext context) => MenuBloc(
          MenuService()
      )..add(LoadMenuEvent(context)),
      child: BlocBuilder<MenuBloc,MenuState>(
        builder: (BuildContext context, menuState) {
          if(menuState is MenuLoadingState){
            return Center(child: CircularProgressIndicator(color: GlobalVariables.primaryColor,));
          }
          if(menuState is ErrorState) {
            return const Center(child: Text("Error"),);
          }
          if(menuState is MenuLoadedState) {

            return ResponsiveBuilder(
                mobileBuilder: (BuildContext context,BoxConstraints constraints) {
              return BlocProvider(
                create: (BuildContext context) => MenuBloc(
                    MenuService()
                )..add(LoadMenuEvent(context)),
                child: BlocBuilder<ForecastBloc,ForecastState>(builder: (BuildContext context, state) {
                  return  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 350*fem,
                        height: 60,
                        color:Color(0xFF363563).withOpacity(0.9),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10*fem),
                              width:100*fem,child: Text("ItemName",style: GlobalVariables.headingStyle,),),
                            Container(width: 50*fem,child: Center(child: Text("Total",style: GlobalVariables.headingStyle,))),
                            Container(width: 60*fem,child: Center(child: Text("Breakfast",style: GlobalVariables.headingStyle,))),
                            Container(width: 60*fem,child: Center(child: Text("Lunch",style: GlobalVariables.headingStyle,))),
                            Container(width: 60*fem,child: Center(child: Text("Dinner",style: GlobalVariables.headingStyle,))),

                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: menuState.menus.length,
                            itemBuilder: (context,index) {
                              final item = menuState.menus[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:350*fem,
                                    height:GlobalVariables.rowHeights[index],
                                    child: Row(
                                      children: [
                                        Container(  padding: EdgeInsets.only(left: 10*fem),width : 100*fem,child: Text("${index} ${item.name}",style: GlobalVariables.dataItemStyle,)),
                                        Container(width: 1,color: GlobalVariables.textColor.withOpacity(0.5),),
                                        Container(width: 50*fem,
                                            child: Column(
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(width:40, child: Text(item.totalCount.toString(),style: GlobalVariables.dataItemStyle)),
                                                    SizedBox(width: 10,),
                                                    SmallCustomTextField(textEditingController: LiveMenuVariables.total, min: 1, max: 1,width: 70,height:35,fontSize: 14,)
                                                  ],
                                                ),
                                              ],
                                            )),
                                        Container(width: 1,color: GlobalVariables.textColor.withOpacity(0.5),),
                                        Container(width:60*fem,
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(width:40,child: Text(LiveMenuVariables.breakfastTotal.text.toString(),style: GlobalVariables.dataItemStyle)),
                                                    SizedBox(width: 10,),
                                                    SmallCustomTextField(textEditingController: LiveMenuVariables.breakfastTotal, min: 1, max: 1,width: 70,height:35,fontSize: 14,)
                                                  ],
                                                ),
                                                SizedBox(height: 20,),
                                                Visibility(
                                                  visible:GlobalVariables.rowHeights[index] == 150,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(LiveMenuVariables.bfSession1Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                          SizedBox(height: 5,),
                                                          SmallCustomTextField(textEditingController: LiveMenuVariables.bfSession1Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                                          SizedBox(height: 5,),
                                                          Text("S1",style: GlobalVariables.dataItemStyle,)
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(LiveMenuVariables.bfSession2Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                          SizedBox(height: 5,),
                                                          SmallCustomTextField(textEditingController: LiveMenuVariables.bfSession1Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                                          SizedBox(height: 5,),
                                                          Text("S2",style: GlobalVariables.dataItemStyle,)
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(LiveMenuVariables.bfSession3Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                          SizedBox(height: 5,),
                                                          SmallCustomTextField(textEditingController: LiveMenuVariables.bfSession1Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                                          SizedBox(height: 5,),
                                                          Text("S3",style: GlobalVariables.dataItemStyle,)
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(LiveMenuVariables.bfSession4Controller.text..toString(),style: GlobalVariables.dataItemStyle),
                                                          SizedBox(height: 5,),
                                                          SmallCustomTextField(textEditingController:LiveMenuVariables.bfSession1Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                                          SizedBox(height: 5,),
                                                          Text("S4",style: GlobalVariables.dataItemStyle,)
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                        Container(width: 1,color: GlobalVariables.textColor.withOpacity(0.5),),
                                        Container(width:60*fem,child: Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(width:40,child: Text(LiveMenuVariables.lunchTotal.toString(),style: GlobalVariables.dataItemStyle)),
                                                SizedBox(width: 10,),
                                                SmallCustomTextField(textEditingController: LiveMenuVariables.lunchTotal, min: 1, max: 1,width: 70,height:35,fontSize: 14,)
                                              ],
                                            ),
                                            SizedBox(height: 20,),
                                            Visibility(
                                              visible:GlobalVariables.rowHeights[index] == 150,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(LiveMenuVariables.lnSession1Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                      SizedBox(height: 5,),
                                                      SmallCustomTextField(textEditingController: LiveMenuVariables.lnSession1Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                                      SizedBox(height: 5,),
                                                      Text("S1",style: GlobalVariables.dataItemStyle,)
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(LiveMenuVariables.lnSession2Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                      SizedBox(height: 5,),
                                                      SmallCustomTextField(textEditingController: LiveMenuVariables.lnSession2Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                                      SizedBox(height: 5,),
                                                      Text("S2",style: GlobalVariables.dataItemStyle,)
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(LiveMenuVariables.lnSession3Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                      SizedBox(height: 5,),
                                                      SmallCustomTextField(textEditingController: LiveMenuVariables.lnSession3Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                                      SizedBox(height: 5,),
                                                      Text("S3",style: GlobalVariables.dataItemStyle,)
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(LiveMenuVariables.lnSession4Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                      SizedBox(height: 5,),
                                                      SmallCustomTextField(textEditingController: LiveMenuVariables.lnSession4Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                                      SizedBox(height: 5,),
                                                      Text("S4",style: GlobalVariables.dataItemStyle,)
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                        Container(width: 1,color: GlobalVariables.textColor.withOpacity(0.5),),
                                        Container(width:60*fem,
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(width:40,child: Text(LiveMenuVariables.dinnerTotal.text.toString(),style: GlobalVariables.dataItemStyle)),
                                                    SizedBox(width: 10,),
                                                    SmallCustomTextField(textEditingController: LiveMenuVariables.dinnerTotal, min: 1, max: 1,width: 70,height:35,fontSize: 14,)
                                                  ],
                                                ),
                                                SizedBox(height: 20,),
                                                Visibility(
                                                  visible:GlobalVariables.rowHeights[index] == 150,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(LiveMenuVariables.dnSession1Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                          SizedBox(height: 5,),
                                                          SmallCustomTextField(textEditingController: LiveMenuVariables.dnSession1Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                                          SizedBox(height: 5,),
                                                          Text("S1",style: GlobalVariables.dataItemStyle,)
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(LiveMenuVariables.dnSession2Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                          SizedBox(height: 5,),
                                                          SmallCustomTextField(textEditingController: LiveMenuVariables.dnSession2Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                                          SizedBox(height: 5,),
                                                          Text("S2",style: GlobalVariables.dataItemStyle,)
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(LiveMenuVariables.dnSession3Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                          SizedBox(height: 5,),
                                                          SmallCustomTextField(textEditingController: LiveMenuVariables.dnSession3Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                                          SizedBox(height: 5,),
                                                          Text("S3",style: GlobalVariables.dataItemStyle,)
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(LiveMenuVariables.dnSession4Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                          SizedBox(height: 5,),
                                                          SmallCustomTextField(textEditingController: LiveMenuVariables.dnSession4Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                                          SizedBox(height: 5,),
                                                          Text("S4",style: GlobalVariables.dataItemStyle,)
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                        SizedBox(width: 7*fem,),
                                        InkWell(
                                            onTap:(){
                                              context.read<ForecastBloc>().add(ItemHeightEvent(index,GlobalVariables.rowHeights));
                                            },
                                            child: Icon(Icons.more_horiz_rounded,size: 20,color: GlobalVariables.textColor.withOpacity(0.8),))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 350*fem,
                                    height: 1,
                                    color: GlobalVariables.textColor.withOpacity(0.2),
                                  ),
                                ],
                              );
                            }),
                      )

                    ],
                  );
                },
                ),
              );
            }, tabletBuilder: (BuildContext context,BoxConstraints constraints){
              return BlocBuilder<ForecastBloc,ForecastState>(builder: (BuildContext context, state) {
                return  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 350*fem,
                      height: 60,
                      color:Color(0xFF363563).withOpacity(0.9),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10*fem),
                            width:50*fem,child: Text("ItemName",style: GlobalVariables.headingStyle,),),
                          Container(width: 35*fem,child: Center(child: Text("Total",style: GlobalVariables.headingStyle,))),
                          Container(width: 70*fem,child: Center(child: Text("Breakfast",style: GlobalVariables.headingStyle,))),
                          Container(width: 70*fem,child: Center(child: Text("Lunch",style: GlobalVariables.headingStyle,))),
                          Container(width: 70*fem,child: Center(child: Text("Dinner",style: GlobalVariables.headingStyle,))),
                          InkWell(
                              onTap: (){
                                context.read<ForecastBloc>().add(ExpandAllEvent(OrderVariables.isExpanded));
                              },
                              child: Container(width: 20*fem,child: Center(child: Icon(OrderVariables.isExpanded ?Icons.keyboard_arrow_down  :Icons.keyboard_arrow_up,size: 25,color: GlobalVariables.whiteColor,)))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: menuState.menus.length,
                          itemBuilder: (context,index) {
                            final item = menuState.menus[index];
                            LiveMenuVariables.total = TextEditingController(text: item.totalCount.toString());
                            LiveMenuVariables.breakfastTotal = TextEditingController(text: item.fpUnitSessions.breakfast.defaultSession.availableCount.toString());
                            LiveMenuVariables.lunchTotal = TextEditingController(text: item.fpUnitSessions.lunch.defaultSession.availableCount.toString());
                            LiveMenuVariables.dinnerTotal = TextEditingController(text: item.fpUnitSessions.dinner.defaultSession.availableCount.toString());
                            LiveMenuVariables.bfSession1Controller = TextEditingController(text: item.fpUnitSessions.breakfast.session1.availableCount.toString());
                            LiveMenuVariables.bfSession2Controller = TextEditingController(text: item.fpUnitSessions.breakfast.session2.availableCount.toString());
                            LiveMenuVariables.bfSession3Controller = TextEditingController(text: item.fpUnitSessions.breakfast.session3.availableCount.toString());
                            LiveMenuVariables.bfSession4Controller = TextEditingController(text: item.fpUnitSessions.breakfast.session4.availableCount.toString());
                            LiveMenuVariables.lnSession1Controller = TextEditingController(text: item.fpUnitSessions.lunch.session1.availableCount.toString());
                            LiveMenuVariables.lnSession2Controller = TextEditingController(text: item.fpUnitSessions.lunch.session2.availableCount.toString());
                            LiveMenuVariables.lnSession3Controller = TextEditingController(text: item.fpUnitSessions.lunch.session3.availableCount.toString());
                            LiveMenuVariables.lnSession4Controller = TextEditingController(text: item.fpUnitSessions.lunch.session4.availableCount.toString());
                            LiveMenuVariables.dnSession1Controller = TextEditingController(text: item.fpUnitSessions.dinner.session1.availableCount.toString());
                            LiveMenuVariables.dnSession2Controller = TextEditingController(text: item.fpUnitSessions.dinner.session2.availableCount.toString());
                            LiveMenuVariables.dnSession3Controller = TextEditingController(text: item.fpUnitSessions.dinner.session3.availableCount.toString());
                            LiveMenuVariables.dnSession4Controller = TextEditingController(text: item.fpUnitSessions.dinner.session4.availableCount.toString());
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:350*fem,
                                  height:GlobalVariables.rowHeights[index],
                                  child: Row(
                                    children: [
                                      Container(  padding: EdgeInsets.only(left: 10*fem),width : 50*fem,child: Text(item.name,style: GlobalVariables.dataItemStyle,)),
                                      Container(width: 1,color: GlobalVariables.textColor.withOpacity(0.5),),
                                      Container(width: 35*fem,
                                          child: Column(
                                            mainAxisAlignment:MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment :CrossAxisAlignment.center,
                                                children: [
                                                  Container( child: Text(LiveMenuVariables.total.text.toString(),style: GlobalVariables.dataItemStyle)),
                                                  SizedBox(height: 5,),
                                                  SmallCustomTextField(textEditingController: LiveMenuVariables.total, onChanged: (text){

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
                                                  }, min: 1, max: 1,width: 70,height:35,fontSize: 14,)
                                                ],
                                              ),
                                            ],
                                          )),
                                      Container(width: 1,color: GlobalVariables.textColor.withOpacity(0.5),),
                                      Container(width:70*fem,
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(width:40,child: Text(LiveMenuVariables.breakfastTotal.text.toString(),style: GlobalVariables.dataItemStyle)),
                                                  SizedBox(width: 10,),
                                                  SmallCustomTextField(textEditingController: LiveMenuVariables.breakfastTotal,onChanged: (text){

                                                    LiveMenuVariables.total.text = (int.parse(text!) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                    int reminderBreakfast = (int.parse(text!)) % 4;
                                                    LiveMenuVariables.bfSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                                    LiveMenuVariables.bfSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                                    LiveMenuVariables.bfSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                                    LiveMenuVariables.bfSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderBreakfast).toString();
                                                    if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                    {
                                                      LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                                    }
                                                  }, min: 1, max: 1,width: 70,height:35,fontSize: 14,)
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Visibility(
                                                visible:GlobalVariables.rowHeights[index] == 150,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(LiveMenuVariables.bfSession1Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                        SizedBox(height: 5,),
                                                        SmallCustomTextField(textEditingController:LiveMenuVariables.bfSession1Controller,onChanged:(text){

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
                                                        Text(LiveMenuVariables.bfSession2Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                        SizedBox(height: 5,),
                                                        SmallCustomTextField(textEditingController: LiveMenuVariables.bfSession2Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,
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
                                                        Text(LiveMenuVariables.bfSession3Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                        SizedBox(height: 5,),
                                                        SmallCustomTextField(textEditingController: LiveMenuVariables.bfSession3Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11, onChanged:(text){

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
                                                        Text(LiveMenuVariables.bfSession4Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                        SizedBox(height: 5,),
                                                        SmallCustomTextField(textEditingController: LiveMenuVariables.bfSession1Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,
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
                                          )),
                                      Container(width: 1,color: GlobalVariables.textColor.withOpacity(0.5),),
                                      Container(width:70*fem,child: Column(
                                        children: [
                                          SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(width:40,child: Text(LiveMenuVariables.lunchTotal.text.toString(),style: GlobalVariables.dataItemStyle)),
                                              SizedBox(width: 10,),
                                              SmallCustomTextField(textEditingController: LiveMenuVariables.lunchTotal, onChanged: (text){

                                                LiveMenuVariables.total.text = (int.parse(text!) + int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                int reminderLunch = (int.parse(text)) % 4;
                                                LiveMenuVariables.lnSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                                LiveMenuVariables.lnSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                                LiveMenuVariables.lnSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                                LiveMenuVariables.lnSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderLunch).toString();

                                                if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                {
                                                  LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                                }
                                              }, min: 1, max: 1,width: 70,height:35,fontSize: 14,)
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Visibility(
                                            visible:GlobalVariables.rowHeights[index] == 150,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(LiveMenuVariables.lnSession1Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                    SizedBox(height: 5,),
                                                    SmallCustomTextField(textEditingController:LiveMenuVariables.lnSession1Controller,
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
                                                    Text(LiveMenuVariables.lnSession2Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                    SizedBox(height: 5,),
                                                    SmallCustomTextField(textEditingController: LiveMenuVariables.lnSession2Controller,
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
                                                    Text(LiveMenuVariables.lnSession3Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                    SizedBox(height: 5,),
                                                    SmallCustomTextField(textEditingController: LiveMenuVariables.lnSession3Controller,onChanged:(text){
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
                                                    Text(LiveMenuVariables.lnSession4Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                    SizedBox(height: 5,),
                                                    SmallCustomTextField(textEditingController: LiveMenuVariables.lnSession4Controller,onChanged:(text){

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
                                      )),
                                      Container(width: 1,color: GlobalVariables.textColor.withOpacity(0.5),),
                                      Container(width:70*fem,
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(width:40,child: Text(LiveMenuVariables.dinnerTotal.text.toString(),style: GlobalVariables.dataItemStyle)),
                                                  SizedBox(width: 10,),
                                                  SmallCustomTextField(textEditingController: LiveMenuVariables.dinnerTotal, onChanged: (text){

                                                    LiveMenuVariables.total.text = (int.parse(text!) + int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text)).toString();
                                                    int reminderDinner = (int.parse(text)) % 4;
                                                    LiveMenuVariables.dnSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                                    LiveMenuVariables.dnSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                                    LiveMenuVariables.dnSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                                    LiveMenuVariables.dnSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderDinner).toString();
                                                    if(int.parse(LiveMenuVariables.total.text) >= 1000)
                                                    {
                                                      LiveMenuFunctions.showExceedLimitAlertDialog(context);
                                                    }
                                                  }, min: 1, max: 1,width: 70,height:35,fontSize: 14,)
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Visibility(
                                                visible:GlobalVariables.rowHeights[index] == 150,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(LiveMenuVariables.dnSession1Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                        SizedBox(height: 5,),
                                                        SmallCustomTextField(textEditingController: LiveMenuVariables.dnSession1Controller,
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
                                                        Text(LiveMenuVariables.dnSession2Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                        SizedBox(height: 5,),
                                                        SmallCustomTextField(textEditingController:LiveMenuVariables.dnSession2Controller, onChanged:(text){
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
                                                        Text(LiveMenuVariables.dnSession3Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                        SizedBox(height: 5,),
                                                        SmallCustomTextField(textEditingController: LiveMenuVariables.dnSession3Controller,onChanged:(text){
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
                                                        Text(LiveMenuVariables.dnSession3Controller.text.toString(),style: GlobalVariables.dataItemStyle),
                                                        SizedBox(height: 5,),
                                                        SmallCustomTextField(textEditingController: LiveMenuVariables.dnSession4Controller, onChanged:(text){

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
                                          )),
                                      SizedBox(width: 7*fem,),
                                      InkWell(
                                          onTap:(){
                                            context.read<ForecastBloc>().add(ItemHeightEvent(index,GlobalVariables.rowHeights));
                                          },
                                          child: Icon(Icons.more_horiz_rounded,size: 20,color: GlobalVariables.textColor.withOpacity(0.8),)),
                                      SizedBox(width: 4*fem,),
                                      CustomButton(text: "Update", onTap: () {
                                        print(item.id);
                                        Map<String, dynamic> requestBody = {
                                          "totalCount":int.parse(LiveMenuVariables.total.text),
                                          "fp_unit_sessions": {
                                            "Breakfast": {
                                              "Default": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.breakfastTotal.text),
                                              },
                                              "Session1": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.bfSession1Controller.text),
                                              },
                                              "Session2": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.bfSession2Controller.text),
                                              },
                                              "Session3": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.bfSession3Controller.text),
                                              },
                                              "Session4": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.bfSession4Controller.text),
                                              },
                                            },
                                            "Lunch": {
                                              "Default": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.lunchTotal.text),
                                              },
                                              "Session1": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.lnSession1Controller.text),
                                              },
                                              "Session2": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.lnSession2Controller.text),
                                              },
                                              "Session3": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.lnSession3Controller.text),
                                              },
                                              "Session4": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.lnSession4Controller.text),
                                              },
                                            },
                                            "Dinner": {
                                              "Default": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.dinnerTotal.text),
                                              },
                                              "Session1": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.dnSession1Controller.text),
                                              },
                                              "Session2": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.dnSession2Controller.text),
                                              },
                                              "Session3": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.dnSession3Controller.text),
                                              },
                                              "Session4": {
                                                "Enabled": true,
                                                "availableCount": int.parse(LiveMenuVariables.dnSession4Controller.text),
                                              },
                                            },
                                          },
                                        };
                                        MenuService menuService = MenuService();
                                        menuService.updateLiveMenu(item.id!, requestBody);
                                      }, color: GlobalVariables.textColor)

                                    ],
                                  ),
                                ),
                                Container(
                                  width: 350*fem,
                                  height: 1,
                                  color: GlobalVariables.textColor.withOpacity(0.2),
                                ),
                              ],
                            );
                          }),
                    )

                  ],
                );
              },
              );
            }, desktopBuilder: (BuildContext context,BoxConstraints constraints) {
              return BlocBuilder<ForecastBloc,ForecastState>(builder: (BuildContext context, state) {
                return  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 350*fem,
                      height: 60,
                      color:Color(0xFF363563).withOpacity(0.9),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10*fem),
                            width:75*fem,child: Text("ItemName",style: GlobalVariables.headingStyle,),),
                          Container(width: 50*fem,child: Center(child: Text("Total",style: GlobalVariables.headingStyle,))),
                          Container(width: 60*fem,child: Center(child: Text("Breakfast",style: GlobalVariables.headingStyle,))),
                          Container(width: 60*fem,child: Center(child: Text("Lunch",style: GlobalVariables.headingStyle,))),
                          Container(width: 60*fem,child: Center(child: Text("Dinner",style: GlobalVariables.headingStyle,))),
                          InkWell(
                              onTap: (){
                                context.read<ForecastBloc>().add(ExpandAllEvent(OrderVariables.isExpanded));
                              },
                              child: Container(width: 20*fem,child: Center(child: Icon(OrderVariables.isExpanded ?Icons.keyboard_arrow_down  :Icons.keyboard_arrow_up,size: 25,color: GlobalVariables.whiteColor,)))),
                        ],
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                          itemCount: menuState.liveMenu.length,
                          itemBuilder: (context, index) {
                            final item = menuState.liveMenu[index];

                            return MenuItemWidget(item: item,index:index ,);
                          },
                        )

                    )
                  ],
                );
              },
              );
            });
          }
          return Container();
        },

      ),
    );
  }
}



