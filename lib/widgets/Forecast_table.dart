import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/widgets/small_custom_textfield.dart';

import '../constants/global_variables.dart';
import '../constants/order_constants/order_variables.dart';
import '../constants/utils.dart';

class ForeCastTable extends StatelessWidget {
  const ForeCastTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return ResponsiveBuilder(mobileBuilder: (BuildContext context,BoxConstraints constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
            title:Text("Forecast",style: SafeGoogleFont(
              'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF363563),
            ),)
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height:30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                          textEditingController: OrderVariables.totalController,height: 30,
                          min:0,max:9999,
                          onChanged: (text){

                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width:10),
                  Image(image: AssetImage('assets/images/square.png',),width: 15,height: 15,),

                  InkWell(
                    onTap:(){

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(Icons.refresh,size: 22,color: GlobalVariables.textColor,),
                    ),
                  )
                ],
              ),

              SizedBox(height:20),

              Column(
                children: [
                  DataTable(
                    columnSpacing:0,
                    headingRowHeight: 80,
                    dataRowHeight: 100,
                    border: TableBorder.all(
                        color: Colors.black12,
                        width: 1,
                        style: BorderStyle.solid,
                        borderRadius: BorderRadius.circular(10)),
                    columns:<DataColumn> [
                      DataColumn(label: Row(
                        children: [
                          Text(" ",style:SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ],
                      )),
                      DataColumn(
                          label: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text("Breakfast",style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color:GlobalVariables.textColor,
                              ),),
                              SizedBox(width: 5,),
                              Image(image: AssetImage('assets/images/triangle.png'),width: 15,height: 15,)
                            ],
                          ),
                          SizedBox(height: 5,),
                          Container(
                            width:93*fem,
                            child: Column(
                              children: [
                                Text( OrderVariables.breakfastController.text,style: GlobalVariables.dataItemStyle,),
                                SizedBox(height: 5,),
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
                      )
                      ),
                      DataColumn(label:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text("Lunch",style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color:GlobalVariables.textColor,
                              ),),
                              SizedBox(width: 5,),
                              Image(image: AssetImage('assets/images/square.png',),width: 15,height: 15,)
                            ],
                          ),
                          SizedBox(height: 5,),
                          Container(
                            width:90*fem,
                            child: Column(
                              children: [
                                Text( OrderVariables.lunchController.text,style: GlobalVariables.dataItemStyle,),
                                SizedBox(height: 5,),
                                SmallCustomTextField(
                                  textEditingController: OrderVariables.lunchController,height: 30,fontSize: 11,min: 0,max:9999, width:65,
                                  onChanged: (text){

                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                      ),
                      DataColumn(label:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text("Dinner",style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color:GlobalVariables.textColor,
                              ),),
                              SizedBox(width: 5,),
                              Image(image: AssetImage('assets/images/triangle.png'),width: 15,height: 15,)
                            ],
                          ),
                          SizedBox(height: 5,),
                          Container(
                            width:90*fem,
                            child: Column(
                              children: [
                                Text( OrderVariables.dinnerController.text,style: GlobalVariables.dataItemStyle,),
                                SizedBox(height: 5,),
                                SmallCustomTextField(
                                  textEditingController: OrderVariables.dinnerController,height: 30,fontSize: 11,min: 0,max:9999, width:65,
                                  onChanged: (text){

                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ), )
                    ],
                    rows: <DataRow> [
                      DataRow(cells: <DataCell> [
                        DataCell( Center(
                          child: Text("S1 : ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ), ),
                        DataCell( Container(
                          width:90*fem,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text( OrderVariables.bs1Controller.text,style: GlobalVariables.dataItemStyle,),
                              SizedBox(height: 5,),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){

                                  }
                              ),
                            ],
                          ),
                        ) ),
                        DataCell(Container(
                          width:90*fem,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text( OrderVariables.ls1Controller.text,style: GlobalVariables.dataItemStyle,),
                              SizedBox(height: 5,),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.ls1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999,
                                  width:65,
                                  onChanged:(text){

                                  }
                              ),
                            ],
                          ),
                        ),),
                        DataCell(Center(
                          child: Container(
                            width:90*fem,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text( OrderVariables.ds1Controller.text,style: GlobalVariables.dataItemStyle,),
                                SizedBox(height: 5,),
                                SmallCustomTextField(
                                    textEditingController: OrderVariables.ds1Controller,height: 30,fontSize: 11,
                                    width:65,
                                    min: 0,max:9999,
                                    onChanged:(text){

                                    }
                                ),
                              ],
                            ),
                          ),
                        ),)
                      ]),
                      DataRow(cells: <DataCell> [
                        DataCell( Center(
                          child: Text("S2 : ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ), ),
                        DataCell( Container(
                          width:90*fem,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text( OrderVariables.bs1Controller.text,style: GlobalVariables.dataItemStyle,),
                              SizedBox(height: 5,),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){

                                  }
                              ),
                            ],
                          ),
                        ) ),
                        DataCell(Container(
                          width:90*fem,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text( OrderVariables.ls1Controller.text,style: GlobalVariables.dataItemStyle,),
                              SizedBox(height: 5,),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.ls1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999,
                                  width:65,
                                  onChanged:(text){

                                  }
                              ),
                            ],
                          ),
                        ),),
                        DataCell(Center(
                          child: Container(
                            width:90*fem,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text( OrderVariables.ds1Controller.text,style: GlobalVariables.dataItemStyle,),
                                SizedBox(height: 5,),
                                SmallCustomTextField(
                                    textEditingController: OrderVariables.ds1Controller,height: 30,fontSize: 11,
                                    width:65,
                                    min: 0,max:9999,
                                    onChanged:(text){

                                    }
                                ),
                              ],
                            ),
                          ),
                        ),)
                      ]),
                      DataRow(cells: <DataCell> [
                        DataCell( Center(
                          child: Text("S3 : ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ), ),
                        DataCell( Container(
                          width:90*fem,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text( OrderVariables.bs1Controller.text,style: GlobalVariables.dataItemStyle,),
                              SizedBox(height: 5,),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){

                                  }
                              ),
                            ],
                          ),
                        ) ),
                        DataCell(Container(
                          width:90*fem,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text( OrderVariables.ls1Controller.text,style: GlobalVariables.dataItemStyle,),
                              SizedBox(height: 5,),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.ls1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999,
                                  width:65,
                                  onChanged:(text){

                                  }
                              ),
                            ],
                          ),
                        ),),
                        DataCell(Center(
                          child: Container(
                            width:90*fem,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text( OrderVariables.ds1Controller.text,style: GlobalVariables.dataItemStyle,),
                                SizedBox(height: 5,),
                                SmallCustomTextField(
                                    textEditingController: OrderVariables.ds1Controller,height: 30,fontSize: 11,
                                    width:65,
                                    min: 0,max:9999,
                                    onChanged:(text){

                                    }
                                ),
                              ],
                            ),
                          ),
                        ),)
                      ]),
                      DataRow(cells: <DataCell> [
                        DataCell( Center(
                          child: Text("B1 : ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ), ),
                        DataCell( Container(
                          width:90*fem,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text( OrderVariables.bs1Controller.text,style: GlobalVariables.dataItemStyle,),
                              SizedBox(height: 5,),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){

                                  }
                              ),
                            ],
                          ),
                        ) ),
                        DataCell(Container(
                          width:90*fem,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text( OrderVariables.ls1Controller.text,style: GlobalVariables.dataItemStyle,),
                              SizedBox(height: 5,),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.ls1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999,
                                  width:65,
                                  onChanged:(text){

                                  }
                              ),
                            ],
                          ),
                        ),),
                        DataCell(Center(
                          child: Container(
                            width:90*fem,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text( OrderVariables.ds1Controller.text,style: GlobalVariables.dataItemStyle,),
                                SizedBox(height: 5,),
                                SmallCustomTextField(
                                    textEditingController: OrderVariables.ds1Controller,height: 30,fontSize: 11,
                                    width:65,
                                    min: 0,max:9999,
                                    onChanged:(text){

                                    }
                                ),
                              ],
                            ),
                          ),
                        ),)
                      ]),
                      DataRow(cells: <DataCell> [
                        DataCell( Center(
                          child: Text("B2 : ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                        ), ),
                        DataCell( Container(
                          width:90*fem,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text( OrderVariables.bs1Controller.text,style: GlobalVariables.dataItemStyle,),
                              SizedBox(height: 5,),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){

                                  }
                              ),
                            ],
                          ),
                        ) ),
                        DataCell(Container(
                          width:90*fem,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text( OrderVariables.ls1Controller.text,style: GlobalVariables.dataItemStyle,),
                              SizedBox(height: 5,),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.ls1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999,
                                  width:65,
                                  onChanged:(text){

                                  }
                              ),
                            ],
                          ),
                        ),),
                        DataCell(Center(
                          child: Container(
                            width:90*fem,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text( OrderVariables.ds1Controller.text,style: GlobalVariables.dataItemStyle,),
                                SizedBox(height: 5,),
                                SmallCustomTextField(
                                    textEditingController: OrderVariables.ds1Controller,height: 30,fontSize: 11,
                                    width:65,
                                    min: 0,max:9999,
                                    onChanged:(text){

                                    }
                                ),
                              ],
                            ),
                          ),
                        ),)
                      ]),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 70,
          margin: EdgeInsets.only(left: 15*fem,right: 15*fem),
          color: Colors.grey.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap:(){

                },
                child: Container(
                  width: 130*fem,
                  height: 40,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){

                },
                child: Container(
                  width: 130*fem,
                  height: 40,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: GlobalVariables.primaryColor, // Replace with your primary color
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }, tabletBuilder: (BuildContext context,BoxConstraints constraints){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Total : ",style: SafeGoogleFont(
                'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color:GlobalVariables.textColor,
              ),),
              SizedBox(width:20),
              Container(
                width:40*fem,
                height: 40,
                child: Row(
                  children: [
                    SmallCustomTextField(
                      textEditingController: OrderVariables.totalController,height: 30,
                      min:0,max:9999,
                      onChanged: (text){

                      },
                    ),
                    SizedBox(width: 10,),
                    Text( OrderVariables.totalController.text,style: GlobalVariables.dataItemStyle,)

                  ],
                ),
              ),
              SizedBox(width:10),

              InkWell(
                onTap:(){

                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.refresh,size: 22,color: GlobalVariables.textColor,),
                ),
              )
            ],
          ),

          SizedBox(height:30),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                DataTable(
                  columnSpacing:10,
                  headingRowHeight: 80,
                  columns:<DataColumn> [
                    DataColumn(label: Row(
                      children: [
                        Text(" ",style:SafeGoogleFont(
                          'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:GlobalVariables.textColor,
                        ),),
                      ],
                    )),
                    DataColumn(label: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Breakfast",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color:GlobalVariables.textColor,
                        ),),
                        SizedBox(height: 10,),
                        Container(
                          width:40*fem,
                          height:35,
                          child: Row(
                            children: [
                              SmallCustomTextField(
                                textEditingController: OrderVariables.breakfastController,height: 30,fontSize: 11,
                                width:65,
                                min: 0,max:9999,
                                onChanged: (text){

                                },
                              ),
                              SizedBox(width: 10,),
                              Text( OrderVariables.breakfastController.text,style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ),
                      ],
                    )),
                    DataColumn(label: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Lunch",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color:GlobalVariables.textColor,
                        ),),
                        SizedBox(height: 10,),
                        Container(
                          width:40*fem,
                          height:35,
                          child: Row(
                            children: [
                              SmallCustomTextField(
                                textEditingController: OrderVariables.lunchController,height: 30,fontSize: 11,min: 0,max:9999, width:65,
                                onChanged: (text){

                                },
                              ),
                              SizedBox(width: 10,),
                              Text( OrderVariables.lunchController.text,style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ),
                      ],
                    )),
                    DataColumn(label: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Dinner",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color:GlobalVariables.textColor,
                        ),),
                        SizedBox(height: 10,),
                        Container(
                          width:40*fem,
                          height:35,
                          child: Row(
                            children: [
                              SmallCustomTextField(
                                textEditingController: OrderVariables.dinnerController,height: 30,fontSize: 11,min: 0,max:9999, width:65,
                                onChanged: (text){

                                },
                              ),
                              SizedBox(width: 10,),
                              Text( OrderVariables.dinnerController.text,style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ),
                      ],
                    ), )
                  ],
                  rows: <DataRow> [
                    DataRow(cells: <DataCell> [
                      DataCell(Center(
                        child: Text("S1 : ",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:GlobalVariables.textColor,
                        ),),
                      ),),
                      DataCell(Container(
                        width:40*fem,
                        height:35,
                        child: Row(
                          children: [
                            SmallCustomTextField(
                                textEditingController: OrderVariables.bs1Controller,height: 30,fontSize: 11,
                                min: 0,max:9999, width:65,

                                onChanged:(text){

                                }
                            ),
                            SizedBox(width: 10,),
                            Text( OrderVariables.bs1Controller.text,style: GlobalVariables.dataItemStyle,)
                          ],
                        ),
                      )),
                      DataCell(Container(
                        width:40*fem,
                        height:35,
                        child: Row(
                          children: [
                            SmallCustomTextField(
                                textEditingController: OrderVariables.ls1Controller,height: 30,fontSize: 11,
                                min: 0,max:9999,
                                width:65,
                                onChanged:(text){

                                }
                            ),
                            SizedBox(width: 10,),
                            Text( OrderVariables.ls1Controller.text,style: GlobalVariables.dataItemStyle,)
                          ],
                        ),
                      ),),
                      DataCell(Center(
                        child: Container(
                          width:40*fem,
                          height:35,
                          child: Row(
                            children: [
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.ds1Controller,height: 30,fontSize: 11,
                                  width:65,
                                  min: 0,max:9999,
                                  onChanged:(text){

                                  }
                              ),
                              SizedBox(width: 10,),
                              Text( OrderVariables.ds1Controller.text,style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ),
                      ),)
                    ]),
                    DataRow(cells: <DataCell> [
                      DataCell(Center(
                        child: Text("S2 : ",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:GlobalVariables.textColor,
                        ),),
                      ),),
                      DataCell(Center(
                        child: Container(
                          width:40*fem,
                          height:35,
                          child: Row(
                            children: [
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs2Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999,
                                  width:65,
                                  onChanged:(text){

                                  }
                              ),
                              SizedBox(width: 10,),
                              Text( OrderVariables.bs2Controller.text,style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ),
                      )),
                      DataCell(Center(
                        child: Container(
                          width:40*fem,
                          height:35,
                          child: Row(
                            children: [
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.ls2Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999,
                                  width:65,
                                  onChanged:(text){

                                  }
                              ),
                              SizedBox(width: 10,),
                              Text( OrderVariables.ls2Controller.text,style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ),
                      ),),
                      DataCell(Center(
                        child: Container(
                          width:40*fem,
                          height:35,
                          child: Row(
                            children: [
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.ds2Controller,height: 30,fontSize: 11,
                                  width:65,
                                  min: 0,max:9999,
                                  onChanged:(text){

                                  }
                              ),
                              SizedBox(width: 10,),
                              Text( OrderVariables.ds2Controller.text,style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ),
                      ),)
                    ]),
                    DataRow(cells: <DataCell> [
                      DataCell(Center(
                        child: Text("S3 : ",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:GlobalVariables.textColor,
                        ),),
                      ),),
                      DataCell(Center(
                        child: Container(
                          width:40*fem,
                          height:35,
                          child: Row(
                            children: [
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs3Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999,
                                  width:65,
                                  onChanged:(text){

                                  }
                              ),
                              SizedBox(width: 10,),
                              Text( OrderVariables.bs3Controller.text,style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ),
                      )),
                      DataCell(Center(
                        child: Container(
                          width:40*fem,
                          height:35,
                          child: Row(
                            children: [
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.ls3Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999,
                                  width:65,
                                  onChanged:(text){

                                  }
                              ),
                              SizedBox(width: 10,),
                              Text( OrderVariables.ls3Controller.text,style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ),
                      ),),
                      DataCell(Center(
                        child: Container(
                          width:40*fem,
                          height:35,
                          child: Row(
                            children: [
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.ds3Controller,height: 30,fontSize: 11,
                                  width:65,
                                  min: 0,max:9999,
                                  onChanged:(text){

                                  }
                              ),
                              SizedBox(width: 10,),
                              Text( OrderVariables.ds3Controller.text,style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ),
                      ),)
                    ]),
                    DataRow(cells: <DataCell> [
                      DataCell(Center(
                        child: Text("S4 : ",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:GlobalVariables.textColor,
                        ),),
                      ),),
                      DataCell(Center(
                        child: Container(
                          width:40*fem,
                          height:35,
                          child: Row(
                            children: [
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs4Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999,
                                  width:65,
                                  onChanged:(text){

                                  }
                              ),
                              SizedBox(width: 10,),
                              Text( OrderVariables.bs4Controller.text,style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ),
                      )),
                      DataCell(Center(
                        child: Container(
                          width:40*fem,
                          height:35,
                          child: Row(
                            children: [
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.ls4Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999,
                                  width:65,
                                  onChanged:(text){

                                  }
                              ),
                              SizedBox(width: 10,),
                              Text( OrderVariables.ls4Controller.text,style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ),
                      ),),
                      DataCell(Center(
                        child: Container(
                          width:40*fem,
                          height:35,
                          child: Row(
                            children: [
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.ds4Controller,height: 30,fontSize: 11,
                                  width:65,
                                  min: 0,max:9999,
                                  onChanged:(text){

                                  }
                              ),
                              SizedBox(width: 10,),
                              Text( OrderVariables.ds4Controller.text,style: GlobalVariables.dataItemStyle,)
                            ],
                          ),
                        ),
                      ),)
                    ])
                  ],
                ),
              ],
            ),
          ),

        ],
      );
    }, desktopBuilder: (BuildContext context,BoxConstraints constraints) {
      return Column();
    });
  }
}
