import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';
import '../../../constants/order_constants/order_variables.dart';
import '../../../constants/utils.dart';
import '../../small_custom_textfield.dart';

class OrderMealEdit extends StatefulWidget {
  final String type;
  const OrderMealEdit({super.key, required this.type});

  @override
  State<OrderMealEdit> createState() => _OrderMealEditState();
}

class _OrderMealEditState extends State<OrderMealEdit> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
        title: Row(
          children: [
            Text("Item count",style:SafeGoogleFont(
              'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF363563),
            ),),
            SizedBox(width: 10,),


          ],
        ),
        actions: [
          Transform.scale(
            scaleY: 0.8,
            scaleX: 0.8,
            child: Switch(
              value: true,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor:
              GlobalVariables.textColor.withOpacity(0.6),
              inactiveThumbImage: NetworkImage(
                  "https://wallpapercave.com/wp/wp7632851.jpg"),
              onChanged: (bool value) {
                // mContext.read<MenuBloc>().add(UpdateSectionAvailability(context, MenuEditorVariables.tagController.text, value));
              },
            ),
          )
        ],
      ),
      body: widget.type == "Meal" ? Column(
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
                width:150,
                height: 40,
                child: Row(
                  children: [
                    Container(
                        width: 50,
                        child: Text( OrderVariables.totalController.text,style: GlobalVariables.dataItemStyle,)),
                    SizedBox(width: 20),
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
                width:130,
                child: Row(
                  children: [
                    Container(
                        width: 50,
                        child: Text( OrderVariables.bs1Controller.text,style: GlobalVariables.dataItemStyle,)),
                    SizedBox(width: 10),
                    SmallCustomTextField(
                        textEditingController: OrderVariables.bs1Controller,height: 30,fontSize: 11,
                        min: 0,max:9999, width:65,

                        onChanged:(text){

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
                width:130,
                child: Row(
                  children: [
                    Container(
                        width: 50,
                        child: Text( OrderVariables.bs2Controller.text,style: GlobalVariables.dataItemStyle,)),
                    SizedBox(width: 10),
                    SmallCustomTextField(
                        textEditingController: OrderVariables.bs2Controller,height: 30,fontSize: 11,
                        min: 0,max:9999, width:65,

                        onChanged:(text){

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
                width:130,
                child: Row(
                  children: [
                    Container(
                        width: 50,
                        child: Text( OrderVariables.bs3Controller.text,style: GlobalVariables.dataItemStyle,)),
                    SizedBox(width: 10),
                    SmallCustomTextField(
                        textEditingController: OrderVariables.bs3Controller,height: 30,fontSize: 11,
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
      ) : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 120,),
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
                  width:150,
                  height: 40,
                  child: Row(
                    children: [
                      Container(
                          width: 50,
                          child: Text( OrderVariables.totalController.text,style: GlobalVariables.dataItemStyle,)),
                      SizedBox(width: 10),
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
            SizedBox(height:30),
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width:10*fem),
                    Container(
                      width: 100,
                      child: Column(
                        children: [
                          Text("Breakfast: ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                          SizedBox(height: 10,),
                          Container(
                            width:100,
                            child: Column(
                              children: [
                                Container(
                                    width: 50,
                                    child: Text( OrderVariables.breakfastController.text,style: GlobalVariables.dataItemStyle,)),
                                SizedBox(height: 5,),
                                SmallCustomTextField(
                                    textEditingController: OrderVariables.breakfastController,height: 30,fontSize: 11,
                                    min: 0,max:9999, width:65,

                                    onChanged:(text){

                                    }
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width:5*fem),

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
                          width:150,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( OrderVariables.bs1Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 10),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){

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
                          width:150,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( OrderVariables.bs2Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 10),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs2Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){

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
                          width:150,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( OrderVariables.bs3Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 10),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs3Controller,height: 30,fontSize: 11,
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
            ),
            SizedBox(height:30),
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width:10*fem),
                    Container(
                      width: 100,
                      child: Column(
                        children: [
                          Text("Lunch: ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                          SizedBox(height: 10,),
                          Container(
                            width:100,
                            child: Column(
                              children: [
                                Container(
                                    width: 50,
                                    child: Text( OrderVariables.breakfastController.text,style: GlobalVariables.dataItemStyle,)),
                                SizedBox(height: 5,),
                                SmallCustomTextField(
                                    textEditingController: OrderVariables.breakfastController,height: 30,fontSize: 11,
                                    min: 0,max:9999, width:65,

                                    onChanged:(text){

                                    }
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width:5*fem),

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
                          width:150,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( OrderVariables.bs1Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 10),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){

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
                          width:150,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( OrderVariables.bs2Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 10),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs2Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){

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
                          width:150,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( OrderVariables.bs3Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 10),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs3Controller,height: 30,fontSize: 11,
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
            ),
            SizedBox(height:30),
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width:10*fem),
                    Container(
                      width: 100,
                      child: Column(
                        children: [
                          Text("Dinner: ",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:GlobalVariables.textColor,
                          ),),
                          SizedBox(height: 10,),
                          Container(
                            width:100,
                            child: Column(
                              children: [
                                Container(
                                    width: 50,
                                    child: Text( OrderVariables.breakfastController.text,style: GlobalVariables.dataItemStyle,)),
                                SizedBox(height: 5,),
                                SmallCustomTextField(
                                    textEditingController: OrderVariables.breakfastController,height: 30,fontSize: 11,
                                    min: 0,max:9999, width:65,

                                    onChanged:(text){

                                    }
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width:5*fem),

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
                          width:150,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( OrderVariables.bs1Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 10),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs1Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){

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
                          width:150,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( OrderVariables.bs2Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 10),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs2Controller,height: 30,fontSize: 11,
                                  min: 0,max:9999, width:65,

                                  onChanged:(text){

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
                          width:150,
                          child: Row(
                            children: [
                              Container(
                                  width: 50,
                                  child: Text( OrderVariables.bs3Controller.text,style: GlobalVariables.dataItemStyle,)),
                              SizedBox(width: 10),
                              SmallCustomTextField(
                                  textEditingController: OrderVariables.bs3Controller,height: 30,fontSize: 11,
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
              onTap: (){
                setState(() {

                });
              },
              child: Container(
                width: 150*fem,
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
              onTap: () {


              },
              child: Container(
                width: 150*fem,
                height: 40,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue, // Replace with your primary color
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    "Save changes",
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
  }
}
