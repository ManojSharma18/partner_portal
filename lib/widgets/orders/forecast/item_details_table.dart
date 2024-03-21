import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:partner_admin_portal/bloc/order_forecast/forecast_bloc.dart';
import 'package:partner_admin_portal/bloc/order_forecast/forecast_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/widgets/small_custom_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/order_forecast/forecast_event.dart';

class ItemDetailsTable extends StatelessWidget {
  const ItemDetailsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
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
                itemCount: GlobalVariables.itemDetails.length,
                itemBuilder: (context,index) {
                  final item = GlobalVariables.itemDetails[index];
                  TextEditingController totalController = TextEditingController(text: item['total'].toString());
                  TextEditingController breakfastController = TextEditingController(text: item['breakfast'].toString());
                  TextEditingController lunchController = TextEditingController(text: item['lunch'].toString());
                  TextEditingController dinnerController = TextEditingController(text: item['Dinner'].toString());

                  TextEditingController bs1Controller = TextEditingController(text: item['bs1'].toString());
                  TextEditingController bs2Controller = TextEditingController(text: item['bs2'].toString());
                  TextEditingController bs3Controller = TextEditingController(text: item['bs3'].toString());
                  TextEditingController bs4Controller = TextEditingController(text: item['bs4'].toString());
                  TextEditingController ls1Controller = TextEditingController(text: item['ls1'].toString());
                  TextEditingController ls2Controller = TextEditingController(text: item['ls2'].toString());
                  TextEditingController ls3Controller = TextEditingController(text: item['ls3'].toString());
                  TextEditingController ls4Controller = TextEditingController(text: item['ls4'].toString());
                  TextEditingController ds1Controller = TextEditingController(text: item['ds1'].toString());
                  TextEditingController ds2Controller = TextEditingController(text: item['ds2'].toString());
                  TextEditingController ds3Controller = TextEditingController(text: item['ds3'].toString());
                  TextEditingController ds4Controller = TextEditingController(text: item['ds4'].toString());

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width:350*fem,
                        height:GlobalVariables.rowHeights[index],
                        child: Row(
                          children: [
                            Container(  padding: EdgeInsets.only(left: 10*fem),width : 100*fem,child: Text(item['name'],style: GlobalVariables.dataItemStyle,)),
                            Container(width: 1,color: GlobalVariables.textColor.withOpacity(0.5),),
                            Container(width: 50*fem,
                                child: Column(
                                  mainAxisAlignment:MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(width:40, child: Text(item['total'].toString(),style: GlobalVariables.dataItemStyle)),
                                        SizedBox(width: 10,),
                                        SmallCustomTextField(textEditingController: totalController, min: 1, max: 1,width: 70,height:35,fontSize: 14,)
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
                                        Container(width:40,child: Text(item['breakfast'].toString(),style: GlobalVariables.dataItemStyle)),
                                        SizedBox(width: 10,),
                                        SmallCustomTextField(textEditingController: breakfastController, min: 1, max: 1,width: 70,height:35,fontSize: 14,)
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
                                              Text(item['bs1'].toString(),style: GlobalVariables.dataItemStyle),
                                              SizedBox(height: 5,),
                                              SmallCustomTextField(textEditingController: bs1Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                              SizedBox(height: 5,),
                                              Text("S1",style: GlobalVariables.dataItemStyle,)
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(item['bs2'].toString(),style: GlobalVariables.dataItemStyle),
                                              SizedBox(height: 5,),
                                              SmallCustomTextField(textEditingController: bs2Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                              SizedBox(height: 5,),
                                              Text("S2",style: GlobalVariables.dataItemStyle,)
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(item['bs3'].toString(),style: GlobalVariables.dataItemStyle),
                                              SizedBox(height: 5,),
                                              SmallCustomTextField(textEditingController: bs3Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                              SizedBox(height: 5,),
                                              Text("S3",style: GlobalVariables.dataItemStyle,)
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(item['bs4'].toString(),style: GlobalVariables.dataItemStyle),
                                              SizedBox(height: 5,),
                                              SmallCustomTextField(textEditingController: bs4Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
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
                                    Container(width:40,child: Text(item['lunch'].toString(),style: GlobalVariables.dataItemStyle)),
                                    SizedBox(width: 10,),
                                    SmallCustomTextField(textEditingController: lunchController, min: 1, max: 1,width: 70,height:35,fontSize: 14,)
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
                                          Text(item['ls1'].toString(),style: GlobalVariables.dataItemStyle),
                                          SizedBox(height: 5,),
                                          SmallCustomTextField(textEditingController: ls1Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                          SizedBox(height: 5,),
                                          Text("S1",style: GlobalVariables.dataItemStyle,)
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(item['ls2'].toString(),style: GlobalVariables.dataItemStyle),
                                          SizedBox(height: 5,),
                                          SmallCustomTextField(textEditingController: ls2Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                          SizedBox(height: 5,),
                                          Text("S2",style: GlobalVariables.dataItemStyle,)
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(item['ls3'].toString(),style: GlobalVariables.dataItemStyle),
                                          SizedBox(height: 5,),
                                          SmallCustomTextField(textEditingController: ls3Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                          SizedBox(height: 5,),
                                          Text("S3",style: GlobalVariables.dataItemStyle,)
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(item['ls4'].toString(),style: GlobalVariables.dataItemStyle),
                                          SizedBox(height: 5,),
                                          SmallCustomTextField(textEditingController: ls4Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
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
                                        Container(width:40,child: Text(item['Dinner'].toString(),style: GlobalVariables.dataItemStyle)),
                                        SizedBox(width: 10,),
                                        SmallCustomTextField(textEditingController: dinnerController, min: 1, max: 1,width: 70,height:35,fontSize: 14,)
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
                                              Text(item['ds1'].toString(),style: GlobalVariables.dataItemStyle),
                                              SizedBox(height: 5,),
                                              SmallCustomTextField(textEditingController: ds1Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                              SizedBox(height: 5,),
                                              Text("S1",style: GlobalVariables.dataItemStyle,)
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(item['ds2'].toString(),style: GlobalVariables.dataItemStyle),
                                              SizedBox(height: 5,),
                                              SmallCustomTextField(textEditingController: ds2Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                              SizedBox(height: 5,),
                                              Text("S2",style: GlobalVariables.dataItemStyle,)
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(item['ds3'].toString(),style: GlobalVariables.dataItemStyle),
                                              SizedBox(height: 5,),
                                              SmallCustomTextField(textEditingController: ds3Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
                                              SizedBox(height: 5,),
                                              Text("S3",style: GlobalVariables.dataItemStyle,)
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(item['ds4'].toString(),style: GlobalVariables.dataItemStyle),
                                              SizedBox(height: 5,),
                                              SmallCustomTextField(textEditingController: ds4Controller, min: 1, max: 1,width: 50,height:35,fontSize: 11,),
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
    );
  }
}
