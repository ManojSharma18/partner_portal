import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';
import '../../small_custom_textfield.dart';
import '../../../constants/utils.dart';

class CountTable extends StatefulWidget {
  const CountTable({Key? key}) : super(key: key);

  @override
  State<CountTable> createState() => _CountTableState();
}

class _CountTableState extends State<CountTable> {

  bool isCountBased = false;

  TextEditingController total = TextEditingController();
  TextEditingController breakfastTotal = TextEditingController();
  TextEditingController lunchTotal = TextEditingController();
  TextEditingController dinnerTotal = TextEditingController();

  TextEditingController bfSession1Controller = TextEditingController();
  TextEditingController bfSession2Controller = TextEditingController();
  TextEditingController bfSession3Controller = TextEditingController();
  TextEditingController bfSession4Controller = TextEditingController();

  TextEditingController lnSession1Controller = TextEditingController();
  TextEditingController lnSession2Controller = TextEditingController();
  TextEditingController lnSession3Controller = TextEditingController();
  TextEditingController lnSession4Controller = TextEditingController();

  TextEditingController dnSession1Controller = TextEditingController();
  TextEditingController dnSession2Controller = TextEditingController();
  TextEditingController dnSession3Controller = TextEditingController();
  TextEditingController dnSession4Controller = TextEditingController();

  Map<String,bool> provider = {'Deliver' : false,'Dine in' : false, 'Pick up':false};

  Map<String,Map<String,bool>> meals = {
    'Breakfast' : {'S1':false,'S2':false,'S3':false},
    'Lunch' : {'S1':false,'S2':false,'S3':false},
    'Dinner' : {'S1':true,'S2':true,'S3':true},
  };


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialValue();
    total.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        title:Text("Count setting",style: SafeGoogleFont(
          'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF363563),
        ),)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [

                    Visibility(
                      visible: isCountBased,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(value:allMeal('Breakfast'), onChanged: (val){
                                    setMeal('Breakfast', allMeal('Breakfast'));
                                  }),
                                  SizedBox(width: 10,),
                                  Text("Breakfast : ",style:  SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:GlobalVariables.textColor,
                                  ),),
                                  SizedBox(width: 10,),
                                  Row(
                                    children: [
                                      session("S1","Breakfast",context),
                                      session("S2","Breakfast",context),
                                      session("S3","Breakfast",context)
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(width:25),
                              Row(
                                children: [
                                  Checkbox(value: allMeal('Lunch'), onChanged: (val){
                                    setMeal("Lunch", allMeal("Lunch"));
                                  }),
                                  SizedBox(width: 10,),
                                  Text("Lunch : ",style:  SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:GlobalVariables.textColor,
                                  ),),
                                  SizedBox(width: 10,),
                                  Row(
                                    children: [
                                      session("S1","Lunch",context),
                                      session("S2","Lunch",context),
                                      session("S3","Lunch",context)
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(width:25),
                              Row(
                                children: [
                                  Checkbox(value: allMeal('Dinner'), onChanged: (val){
                                    setMeal("Dinner", allMeal('Dinner'));
                                  }),
                                  SizedBox(width: 10,),
                                  Text("Dinner : ",style:  SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:GlobalVariables.textColor,
                                  ),),
                                  SizedBox(width: 10,),
                                  Row(
                                    children: [
                                      session("S1","Dinner",context),
                                      session("S2","Dinner",context),
                                      session("S3","Dinner",context)
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 20,),

                          Row(
                            children: [
                              Row(
                                children: [
                                  Checkbox(value: provider['Deliver'], onChanged: (val){
                                    setState(() {
                                      provider['Deliver'] = val!;
                                    });

                                  }),
                                  SizedBox(width: 10,),
                                  Text("Deliver",style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:GlobalVariables.textColor,
                                  ),)
                                ],
                              ),
                              SizedBox(width: 30,),
                              Row(
                                children: [
                                  Checkbox(value: provider['Dine in'], onChanged: (val){
                                    setState(() {
                                      provider['Dine in'] = val!;
                                    });

                                  }),
                                  SizedBox(width: 10,),
                                  Text("Dine in",style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:GlobalVariables.textColor,
                                  ),)
                                ],
                              ),
                              SizedBox(width: 30,),
                              Row(
                                children: [
                                  Checkbox(value: provider['Pick up'], onChanged: (val){
                                    setState(() {
                                      provider['Pick up'] = val!;
                                    });

                                  }),
                                  SizedBox(width: 10,),
                                  Text("Pick up",style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:GlobalVariables.textColor,
                                  ),)
                                ],
                              )
                            ],
                          ),

                          SizedBox(height: 50,),

                        ],
                      ),
                    ),

                    Visibility(
                      visible: !isCountBased,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
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
                                      width:70*fem,
                                      height: 40,
                                      child: SmallCustomTextField(
                                        textEditingController: total,height: 30,
                                        min:0,max:9999,
                                        onChanged: (text){
                                          setState(() {
                                            if(int.parse(total.text) >= 10000)
                                            {
                                              _showExceedLimitAlertDialog(context);
                                            }
                                            int reminder = (int.parse(text!)) % 3;
                                            breakfastTotal.text = (int.parse(text)/3).toInt().toString();
                                            lunchTotal.text = (int.parse(text)/3).toInt().toString();
                                            dinnerTotal.text = ((int.parse(text)/3).toInt()+ reminder).toString();
                                            int reminderBreakfast = (int.parse(breakfastTotal.text)) % 4;
                                            bfSession1Controller.text = (int.parse(breakfastTotal.text)/4).toInt().toString();
                                            bfSession2Controller.text = (int.parse(breakfastTotal.text)/4).toInt().toString();
                                            bfSession3Controller.text = (int.parse(breakfastTotal.text)/4).toInt().toString();
                                            bfSession4Controller.text = ((int.parse(breakfastTotal.text)/4).toInt()+ reminderBreakfast).toString();

                                            int reminderLunch = (int.parse(lunchTotal.text)) % 4;
                                            lnSession1Controller.text = (int.parse(lunchTotal.text)/4).toInt().toString();
                                            lnSession2Controller.text = (int.parse(lunchTotal.text)/4).toInt().toString();
                                            lnSession3Controller.text = (int.parse(lunchTotal.text)/4).toInt().toString();
                                            lnSession4Controller.text = ((int.parse(lunchTotal.text)/4).toInt()+ reminderLunch).toString();

                                            int reminderDinner = (int.parse(dinnerTotal.text)) % 4;
                                            dnSession1Controller.text = (int.parse(dinnerTotal.text)/4).toInt().toString();
                                            dnSession2Controller.text = (int.parse(dinnerTotal.text)/4).toInt().toString();
                                            dnSession3Controller.text = (int.parse(dinnerTotal.text)/4).toInt().toString();
                                            dnSession4Controller.text = ((int.parse(dinnerTotal.text)/4).toInt()+ reminderDinner).toString();
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width:10),

                                    InkWell(
                                      onTap:(){
                                        initialValue();
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
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                  textEditingController: breakfastTotal,height: 30,fontSize: 11,
                                                  min: 0,max:9999,
                                                  onChanged: (text){
                                                    if(int.parse(total.text) >= 1000)
                                                    {
                                                      _showExceedLimitAlertDialog(context);
                                                    }
                                                    setState(() {
                                                      total.text = (int.parse(text!) + int.parse(lunchTotal.text) + int.parse(dinnerTotal.text)).toString();
                                                      int reminderBreakfast = (int.parse(text!)) % 4;
                                                      bfSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                                      bfSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                                      bfSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                                      bfSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderBreakfast).toString();
                                                    });
                                                  },
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
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                  textEditingController: lunchTotal,height: 30,fontSize: 11,min: 0,max:9999,
                                                  onChanged: (text){
                                                    setState(() {
                                                      if(int.parse(total.text) >= 1000)
                                                      {
                                                        _showExceedLimitAlertDialog(context);
                                                      }
                                                      total.text = (int.parse(text!) + int.parse(breakfastTotal.text) + int.parse(dinnerTotal.text)).toString();
                                                      int reminderLunch = (int.parse(text)) % 4;
                                                      lnSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                                      lnSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                                      lnSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                                      lnSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderLunch).toString();
                                                    });
                                                  },
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
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                  textEditingController: dinnerTotal,height: 30,fontSize: 11,min: 0,max:9999,
                                                  onChanged: (text){
                                                    setState(() {
                                                      if(int.parse(total.text) >= 1000)
                                                      {
                                                        _showExceedLimitAlertDialog(context);
                                                      }
                                                      total.text = (int.parse(text!) + int.parse(breakfastTotal.text) + int.parse(lunchTotal.text)).toString();
                                                      int reminderDinner = (int.parse(text)) % 4;
                                                      dnSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                                      dnSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                                      dnSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                                      dnSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderDinner).toString();
                                                    });
                                                  },
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
                                            DataCell(Center(
                                              child: Container(
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                    textEditingController: bfSession1Controller,height: 30,fontSize: 11,
                                                    min: 0,max:9999,
                                                    onChanged:(text){
                                                      setState(() {
                                                        if(int.parse(total.text) >= 1000)
                                                        {
                                                          _showExceedLimitAlertDialog(context);
                                                        }
                                                        breakfastTotal.text = (int.parse(text!) + int.parse(bfSession2Controller.text) + int.parse(bfSession3Controller.text) + int.parse(bfSession4Controller.text) ).toString();
                                                        total.text = (int.parse(breakfastTotal.text) + int.parse(lunchTotal.text) + int.parse(dinnerTotal.text)).toString();
                                                      });
                                                    }
                                                ),
                                              ),
                                            )),
                                            DataCell(Center(
                                              child: Container(
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                    textEditingController: lnSession1Controller,height: 30,fontSize: 11,
                                                    min: 0,max:9999,
                                                    onChanged:(text){
                                                      setState(() {
                                                        if(int.parse(total.text) >= 1000)
                                                        {
                                                          _showExceedLimitAlertDialog(context);
                                                        }
                                                        lunchTotal.text = (int.parse(text!) + int.parse(lnSession2Controller.text) + int.parse(lnSession3Controller.text) + int.parse(lnSession4Controller.text) ).toString();
                                                        total.text = (int.parse(breakfastTotal.text) + int.parse(lunchTotal.text) + int.parse(dinnerTotal.text)).toString();
                                                      });
                                                    }
                                                ),
                                              ),
                                            ),),
                                            DataCell(Center(
                                              child: Container(
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                    textEditingController: dnSession1Controller,height: 30,fontSize: 11,
                                                    min: 0,max:9999,
                                                    onChanged:(text){
                                                      setState(() {
                                                        if(int.parse(total.text) >= 1000)
                                                        {
                                                          _showExceedLimitAlertDialog(context);
                                                        }
                                                        dinnerTotal.text = (int.parse(text!) + int.parse(dnSession2Controller.text) + int.parse(dnSession3Controller.text) + int.parse(dnSession4Controller.text) ).toString();
                                                        total.text = (int.parse(breakfastTotal.text) + int.parse(lunchTotal.text) + int.parse(dinnerTotal.text)).toString();
                                                      });
                                                    }

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
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                    textEditingController: bfSession2Controller,height: 30,fontSize: 11,
                                                    min: 0,max:9999,
                                                    onChanged:(text){
                                                      setState(() {
                                                        if(int.parse(total.text) >= 1000)
                                                        {
                                                          _showExceedLimitAlertDialog(context);
                                                        }
                                                        breakfastTotal.text = (int.parse(text!) + int.parse(bfSession1Controller.text) + int.parse(bfSession3Controller.text) + int.parse(bfSession4Controller.text) ).toString();
                                                        total.text = (int.parse(breakfastTotal.text) + int.parse(lunchTotal.text) + int.parse(dinnerTotal.text)).toString();
                                                      });
                                                    }
                                                ),
                                              ),
                                            )),
                                            DataCell(Center(
                                              child: Container(
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                    textEditingController: lnSession2Controller,height: 30,fontSize: 11,
                                                    min: 0,max:9999,
                                                    onChanged:(text){
                                                      setState(() {
                                                        if(int.parse(total.text) >= 1000)
                                                        {
                                                          _showExceedLimitAlertDialog(context);
                                                        }
                                                        lunchTotal.text = (int.parse(text!) + int.parse(lnSession1Controller.text) + int.parse(lnSession3Controller.text) + int.parse(lnSession4Controller.text) ).toString();
                                                        total.text = (int.parse(breakfastTotal.text) + int.parse(lunchTotal.text) + int.parse(dinnerTotal.text)).toString();
                                                      });
                                                    }
                                                ),
                                              ),
                                            ),),
                                            DataCell(Center(
                                              child: Container(
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                    textEditingController: dnSession2Controller,height: 30,fontSize: 11,
                                                    min: 0,max:9999,
                                                    onChanged:(text){
                                                      setState(() {
                                                        if(int.parse(total.text) >= 1000)
                                                        {
                                                          _showExceedLimitAlertDialog(context);
                                                        }
                                                        dinnerTotal.text = (int.parse(text!) + int.parse(dnSession4Controller.text) + int.parse(dnSession3Controller.text) + int.parse(dnSession1Controller.text) ).toString();
                                                        total.text = (int.parse(breakfastTotal.text) + int.parse(lunchTotal.text) + int.parse(dinnerTotal.text)).toString();
                                                      });
                                                    }
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
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                    textEditingController: bfSession3Controller,height: 30,fontSize: 11,
                                                    min: 0,max:9999,
                                                    onChanged:(text){
                                                      setState(() {
                                                        if(int.parse(total.text) >= 1000)
                                                        {
                                                          _showExceedLimitAlertDialog(context);
                                                        }
                                                        breakfastTotal.text = (int.parse(text!) + int.parse(bfSession2Controller.text) + int.parse(bfSession1Controller.text) + int.parse(bfSession4Controller.text) ).toString();
                                                        total.text = (int.parse(breakfastTotal.text) + int.parse(lunchTotal.text) + int.parse(dinnerTotal.text)).toString();
                                                      });
                                                    }
                                                ),
                                              ),
                                            )),
                                            DataCell(Center(
                                              child: Container(
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                    textEditingController: lnSession3Controller,height: 30,fontSize: 11,
                                                    min: 0,max:9999,
                                                    onChanged:(text){
                                                      setState(() {
                                                        if(int.parse(total.text) >= 1000)
                                                        {
                                                          _showExceedLimitAlertDialog(context);
                                                        }
                                                        lunchTotal.text = (int.parse(text!) + int.parse(lnSession2Controller.text) + int.parse(lnSession1Controller.text) + int.parse(lnSession4Controller.text) ).toString();
                                                        total.text = (int.parse(breakfastTotal.text) + int.parse(lunchTotal.text) + int.parse(dinnerTotal.text)).toString();
                                                      });
                                                    }
                                                ),
                                              ),
                                            ),),
                                            DataCell(Center(
                                              child: Container(
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                    textEditingController: dnSession3Controller,height: 30,fontSize: 11,
                                                    min: 0,max:9999,
                                                    onChanged:(text){
                                                      setState(() {
                                                        if(int.parse(total.text) >= 1000)
                                                        {
                                                          _showExceedLimitAlertDialog(context);
                                                        }
                                                        dinnerTotal.text = (int.parse(text!) + int.parse(dnSession2Controller.text) + int.parse(dnSession4Controller.text) + int.parse(dnSession1Controller.text) ).toString();
                                                        total.text = (int.parse(breakfastTotal.text) + int.parse(lunchTotal.text) + int.parse(dinnerTotal.text)).toString();
                                                      });
                                                    }
                                                ),
                                              ),
                                            ),),
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
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                    textEditingController: bfSession4Controller,height: 30,fontSize: 11,
                                                    min: 0,max:9999,
                                                    onChanged:(text){
                                                      setState(() {
                                                        if(int.parse(total.text) >= 1000)
                                                        {
                                                          _showExceedLimitAlertDialog(context);
                                                        }
                                                        breakfastTotal.text = (int.parse(text!) + int.parse(bfSession2Controller.text) + int.parse(bfSession3Controller.text) + int.parse(bfSession1Controller.text) ).toString();
                                                        total.text = (int.parse(breakfastTotal.text) + int.parse(lunchTotal.text) + int.parse(dinnerTotal.text)).toString();
                                                      });
                                                    }
                                                ),
                                              ),
                                            )),
                                            DataCell(Center(
                                              child: Container(
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                    textEditingController: lnSession4Controller,height: 30,fontSize: 11,
                                                    min: 0,max:9999,
                                                    onChanged:(text){
                                                      setState(() {
                                                        if(int.parse(total.text) >= 1000)
                                                        {
                                                          _showExceedLimitAlertDialog(context);
                                                        }
                                                        lunchTotal.text = (int.parse(text!) + int.parse(lnSession2Controller.text) + int.parse(lnSession3Controller.text) + int.parse(lnSession1Controller.text) ).toString();
                                                        total.text = (int.parse(breakfastTotal.text) + int.parse(lunchTotal.text) + int.parse(dinnerTotal.text)).toString();
                                                      });
                                                    }
                                                ),
                                              ),
                                            ),),
                                            DataCell(Center(
                                              child: Container(
                                                width:70*fem,
                                                height:35,
                                                child: SmallCustomTextField(
                                                    textEditingController: dnSession4Controller,height: 30,fontSize: 11,
                                                    min: 0,max:9999,
                                                    onChanged:(text){
                                                      setState(() {
                                                        if(int.parse(total.text) >= 1000)
                                                        {
                                                          _showExceedLimitAlertDialog(context);
                                                        }
                                                        dinnerTotal.text = (int.parse(text!) + int.parse(dnSession2Controller.text) + int.parse(dnSession3Controller.text) + int.parse(dnSession1Controller.text) ).toString();
                                                        total.text = (int.parse(breakfastTotal.text) + int.parse(lunchTotal.text) + int.parse(dinnerTotal.text)).toString();
                                                      });
                                                    }
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
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap:(){
                  initialValue();
                },
                child: Container(
                  width: 130*fem,
                  margin: EdgeInsets.all(20*fem),
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
                  setState(() {
                    // ItemDetails.checking = false;
                    // if(ItemDetails.displayNameController.text != '')
                    // {
                    //   editFoodName(selectedCategory, selectedItem, ItemDetails.displayNameController.text);
                    // }
                    int totalCount = int.parse(total.text);
                    if(totalCount > 9999)
                    {
                      _showExceedLimitAlertDialog(context);

                    }
                    else if(totalCount<9)
                    {
                      _showExceedLimitAlertDialog1(context);

                    }
                  });
                },
                child: Container(
                  width: 130*fem,
                  margin: EdgeInsets.all(20*fem),
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
          )
        ],
      ),
    );
  }

  void initialValue(){
    setState(() {
      total.text = '0';
      breakfastTotal.text = '0';
      lunchTotal.text = '0';
      dinnerTotal.text = '0';

      bfSession1Controller.text = '0';
      bfSession2Controller.text = '0';
      bfSession3Controller.text = '0';
      bfSession4Controller.text = '0';

      lnSession1Controller.text = '0';
      lnSession2Controller.text = '0';
      lnSession3Controller.text = '0';
      lnSession4Controller.text = '0';

      dnSession1Controller.text = '0';
      dnSession2Controller.text = '0';
      dnSession3Controller.text = '0';
      dnSession4Controller.text = '0';
    });
  }

  bool allMeal(String meal)
  {
    return meals[meal]?.values.every((value) => value == true) ?? false;
  }

  void setMeal(String meal,bool val,)
  {
    setState(() {
      meals[meal]?.forEach((key, _) {
        meals[meal]![key] = !val;
      });
    });
  }
  Widget session(String s,String meal,BuildContext context)
  {
    return InkWell(
      onTap: () {
        setState(() {
          meals[meal]![s] = !(meals[meal]?[s] ?? false);
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 5,right: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: GlobalVariables.primaryColor),
            color: meals[meal]?[s] == true ? Colors.amber : Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(s,style: SafeGoogleFont(
              'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color:GlobalVariables.textColor,
            ),),
          ),
        ),
      ),
    );
  }

  void _showExceedLimitAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning',style: SafeGoogleFont('Poppins',fontSize: 16,fontWeight: FontWeight.bold,color: GlobalVariables.textColor),),
          content: Text('Your total count is exceeding the limit (less than 10000). Do you want to reset?'),
          actions: [
            TextButton(
              onPressed: () {
                initialValue();
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: GlobalVariables.primaryColor,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text('Ok',style: SafeGoogleFont('Poppins',fontSize: 16,fontWeight: FontWeight.bold),))
              ),
            ),
          ],
        );
      },
    );
  }

  void _showExceedLimitAlertDialog1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning',style: SafeGoogleFont('Poppins',fontSize: 16,fontWeight: FontWeight.bold,color: GlobalVariables.textColor),),
          content: Text('Your total count is less than the minimum count. Do you want to reset?'),
          actions: [
            TextButton(
              onPressed: () {
                initialValue();
                Navigator.of(context).pop();
              },
              child:Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: GlobalVariables.primaryColor,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text('Ok',style: SafeGoogleFont('Poppins',fontSize: 16,fontWeight: FontWeight.bold),))
              ),
            ),
          ],
        );
      },
    );
  }
}
