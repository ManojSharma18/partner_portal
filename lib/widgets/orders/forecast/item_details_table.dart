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
                            Container(padding: EdgeInsets.only(left: 10*fem), width:100*fem,child: Text("ItemName",style: GlobalVariables.headingStyle,),),
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
                                        Container(  padding: EdgeInsets.only(left: 10*fem),width : 100*fem,child: Text("${index} ${item.dname}",style: GlobalVariables.dataItemStyle,)),
                                        Container(width: 1,color: GlobalVariables.textColor.withOpacity(0.5),),
                                        Container(width: 50*fem,
                                            child: Column(
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(width:40, child: Text("200",style: GlobalVariables.dataItemStyle)),
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
                            width:20*fem,child: Text("Sl no",style: GlobalVariables.headingStyle,),),
                          Container(padding: EdgeInsets.only(left: 10*fem), width:65*fem,child: Text("ItemName",style: GlobalVariables.headingStyle,),),
                          Container(width: 40*fem,child: Padding(
                            padding: EdgeInsets.only(left: 10*fem),
                            child: Center(child: Text("Total",style: GlobalVariables.headingStyle,)),
                          )),
                          Padding(
                            padding: EdgeInsets.only(left: 10*fem),
                            child: Container(width: 60*fem,child: Center(child: Text("Breakfast",style: GlobalVariables.headingStyle,))),
                          ),
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
                            width:15*fem,child: Text("Sl no",style: GlobalVariables.headingStyle,),),
                          Container(padding: EdgeInsets.only(left: 10*fem), width:65*fem,child: Text("ItemName",style: GlobalVariables.headingStyle,),),
                          Container(width: 40*fem,child: Padding(
                            padding: EdgeInsets.only(left: 10*fem),
                            child: Center(child: Text("Total",style: GlobalVariables.headingStyle,)),
                          )),
                          Padding(
                            padding: EdgeInsets.only(left: 10*fem),
                            child: Container(width: 60*fem,child: Center(child: Text("Breakfast",style: GlobalVariables.headingStyle,))),
                          ),
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



