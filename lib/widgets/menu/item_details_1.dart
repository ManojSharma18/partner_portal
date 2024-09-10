import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
import 'package:partner_admin_portal/bloc/menu/menu_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_event.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_functions.dart';
import 'package:partner_admin_portal/constants/utils.dart';
import 'package:partner_admin_portal/widgets/custom_textfield_price.dart';

import '../../bloc/menu/menu_state.dart';
import '../../constants/global_variables.dart';
import '../../constants/menu_editor_constants/menu_editor_variables.dart';
import '../../repository/menu_services.dart';
import '../custom_drop_down_textfeild.dart';
import '../custom_textfield.dart';
import '../item_details.dart';
import '../responsive_builder.dart';

class ItemDetails1 extends StatefulWidget {
  final Map<String, dynamic> item;
  final String resource;
  static bool checking = false;
  final String type;
  final BuildContext? menuContext;
  const ItemDetails1({Key? key, required this.resource, this.menuContext, required this.item, required this.type,}) : super(key: key);

  @override
  State<ItemDetails1> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails1> {


  TextEditingController descriptionController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController cuisineController = TextEditingController();


  OrderType _selectedOrderType = OrderType.normal;


  List<String> rawSource = ["ORGANIC","NON ORGANIC"];
  List<String> category = ["VEG","NON VEG",];
  List<String> subCategory = ["Jain","Halal"];

  List<String> type = ["FOOD","BEVERAGE"];
  List<String> subType1 = [];
  List<String> subType2 = [];






  Map<String, List<Map<String,dynamic>>> foodCategories = {
    'South indian breakfast': [
      {'name' : 'Idli', 'availability' : true},
      {'name' :'Poori','availability' : false},
      {'name' : 'Shavige bath','availability' : false }
    ],

    'North indian breakfast': [
      {'name' : 'Chole bature', 'availability' : true},
      {'name' :'Rava chilla','availability' : false},
      {'name' : 'Pav bhaji','availability' : true }
    ],

    'South indian palya': [
      {'name' : 'Beans palya', 'availability' : true},
      {'name' :'Balekayi palya','availability' : false},
      {'name' : 'Soppin palya','availability' : false }
    ],

    'North indian subzi': [
      {'name' : 'Aloo moongere ki sabzi', 'availability' : true},
      {'name' : 'Aloo bhindi','availability' : false},
      {'name' : 'Gobo mater','availability' : false }
    ],

    'South indian ricebath': [
      {'name' : 'lemon rice', 'availability' : true},
      {'name' :'puliyogare','availability' : false},
      {'name' : 'tomoto anna','availability' : false }
    ],

    'South indian sambar': [
      {'name' : 'onion sambar', 'availability' : true},
      {'name' :'drumstick sambar','availability' : false},
      {'name' : 'mixed vegitables sambar','availability' : false }
    ],

    'South indian sweets': [
      {'name' : 'Akki payasa', 'availability' : true},
      {'name' :'Godhi payasa','availability' : false},
      {'name' : 'shavide payasa','availability' : false }
    ],

  };


  TextEditingController cuisineDescriptionController = TextEditingController();

  List<Combo> comboList = [];

  bool basic = true;
  bool advance = false;

  void enableBasic(){
    setState(() {
      basic = !basic;
      advance = !advance;
    });
  }

  void enableAdvance(){
    setState(() {
      advance = !advance;
    });
  }

  List<String> sections = [];
  List<String> items = [];
  @override
  void initState() {
    super.initState();
    // if(MenuEditorVariables.typeController.text == "FOOD" || MenuEditorVariables.typeController.text == "Food") {
    //   subType1 = ["SELECT ","PREPARE TO EAT","READY TO EAT",];
    //   MenuEditorVariables.subTypeController.text = subType1[0];
    // } else {
    //   subType2 = ["SELECT","PREPARE TO DRINK","READY TO DRINK",];
    //   MenuEditorVariables.subTypeController.text = subType2[0];
    // }
    gstController.text = '5%';
    sectionController.text = 'South indian breakfast';

  }

  double finalPrice = 0.0;

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  bool normalReadonly = false;

  bool preorderReadOnly = false;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    // MenuEditorVariables.regionalController.text = widget.item['regional'];
    //MenuEditorVariables.nameController.text = widget.name;

    print("IN Item Details ${MenuEditorVariables.regionalController.text}");

    print("IN Item Details ${MenuEditorVariables.consumptionMode}");

    return BlocBuilder<MenuBloc,MenuState>(builder: (menuContext, state) {
      if(state is MenuLoadingState){
        return Center(child: CircularProgressIndicator(),);
      }else if(state is MenuLoadedState) {
        return ResponsiveBuilder(
            mobileBuilder: (BuildContext context,BoxConstraints constraints){
              return widget.item['disName'] == ''
                  ? Container()
                  : Container(
                padding: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Container(
                            width: 150*fem,
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      activeColor: GlobalVariables.primaryColor,
                                      value: OrderType.normal,
                                      groupValue: _selectedOrderType,

                                      onChanged: (value) {
                                        setState(() {
                                          _selectedOrderType = OrderType.normal;
                                        });
                                      },
                                    ),
                                    Text('Normal Price',style: TextStyle(
                                      fontFamily: 'RenogareSoft',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: GlobalVariables.textColor,
                                    ),),
                                  ],
                                ),
                                SizedBox(width: 10,),
                                Row(
                                  children: [
                                    Radio(
                                      activeColor: GlobalVariables.primaryColor,
                                      value: OrderType.preorder,
                                      groupValue: _selectedOrderType,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedOrderType = OrderType.preorder;
                                        });
                                      },
                                    ),
                                    Text('Preorder Price',style: TextStyle(
                                      fontFamily: 'RenogareSoft',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: GlobalVariables.textColor,
                                    ),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [


                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(label: "Normal price", controller: MenuEditorVariables.normalPriceController,width: 35*fem,
                                onChanged: (val){
                                  double normalPrice;
                                  double pacakgingPrice;
                                  try {
                                    normalPrice = double.parse(MenuEditorVariables.normalPriceController.text);
                                  } catch (e) {
                                    print('Invalid double: ${MenuEditorVariables.normalPriceController.text}');
                                    normalPrice = 0.0;
                                  }
                                  try {
                                    pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                  } catch (e) {
                                    print('Invalid double: ${MenuEditorVariables.packagindController.text}');
                                    pacakgingPrice=0.0;
                                  }
                                  setState(() {
                                    MenuEditorVariables.normalFinalPrice =  normalPrice + ((5*normalPrice)/100) + pacakgingPrice;
                                    if(_selectedOrderType ==OrderType.normal)
                                    {

                                    }
                                  });
                                },),
                              SizedBox(height: 10,),
                              Container(
                                width: 35*fem,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Final Price",style: TextStyle(
                                          fontFamily: 'RenogareSoft',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: GlobalVariables.textColor,
                                        ),),
                                        SizedBox(width: 5,),
                                        Tooltip(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              border: Border.all(color: Colors.grey),
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Open Sans',
                                            fontSize: 10,
                                            color: Colors.white,
                                            wordSpacing: 0.23,
                                            letterSpacing: 0.23,
                                          ),
                                          message:  'Please ensure the item price matches the price in your menu', // Provide a default value if widget.suffixTooltip is null
                                          child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2,),
                                    Text("\u{20B9} $finalPrice", style: TextStyle(
                                      fontFamily: 'RenogareSoft',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: GlobalVariables.textColor,
                                    ),),
                                    SizedBox(height: 2,),

                                  ],
                                ),
                              ),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(label: "Packaging price", controller: MenuEditorVariables.packagindController,width: 35*fem,
                                onChanged: (val){
                                  double normalPrice;
                                  double preOrderPrice;
                                  double pacakgingPrice;
                                  try {
                                    normalPrice = double.parse(MenuEditorVariables.normalPriceController.text);
                                    preOrderPrice = double.parse(MenuEditorVariables.preorderPriceController.text);
                                  } catch (e) {
                                    print('Invalid double: ${MenuEditorVariables.normalPriceController.text}');
                                    normalPrice = 0.0;
                                    preOrderPrice=0.0;
                                  }
                                  try {
                                    pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                  } catch (e) {
                                    print('Invalid double: ${MenuEditorVariables.packagindController.text}');
                                    pacakgingPrice=0.0;
                                  }
                                  setState(() {
                                    if(_selectedOrderType == OrderType.normal)
                                    {
                                      finalPrice =  normalPrice + ((5*(normalPrice+pacakgingPrice))/100) + pacakgingPrice;
                                    }
                                    else if(_selectedOrderType == OrderType.preorder){
                                      finalPrice =  preOrderPrice + ((5*(preOrderPrice+pacakgingPrice))/100) + pacakgingPrice;
                                    }
                                  });
                                },),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Checkbox(value:MenuEditorVariables.gstPayment, onChanged: (val){
                                    double pacakgingPrice;
                                    try {
                                      pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                    } catch (e) {
                                      print('Invalid double: ${MenuEditorVariables.packagindController.text}');
                                      pacakgingPrice=0.0;
                                    }
                                    setState(() {
                                      MenuEditorVariables.gstPayment = val!;
                                      print("Val $MenuEditorVariables.gstPayment");

                                      if(_selectedOrderType == OrderType.normal)
                                      {
                                        if(MenuEditorVariables.gstPayment)
                                        {
                                          // finalPrice = finalPrice + pacakgingPrice;
                                          finalPrice = int.parse(MenuEditorVariables.normalPriceController.text) + ((5*(int.parse(MenuEditorVariables.normalPriceController.text)+pacakgingPrice))/100) +  pacakgingPrice;
                                        }
                                        else{
                                          // finalPrice =  normalPrice + ((5*(normalPrice+pacakgingPrice))/100) + pacakgingPrice;
                                          finalPrice = int.parse(MenuEditorVariables.normalPriceController.text) + ((5*(int.parse(MenuEditorVariables.normalPriceController.text)))/100);
                                        }
                                      }
                                      else{
                                        if(MenuEditorVariables.gstPayment)
                                        {
                                          // finalPrice = finalPrice + pacakgingPrice;
                                          finalPrice = int.parse(MenuEditorVariables.preorderPriceController.text) + ((5*(int.parse(MenuEditorVariables.preorderPriceController.text)+pacakgingPrice))/100) +  pacakgingPrice;
                                        }
                                        else{
                                          // finalPrice =  normalPrice + ((5*(normalPrice+pacakgingPrice))/100) + pacakgingPrice;
                                          finalPrice = int.parse(MenuEditorVariables.preorderPriceController.text) + ((5*(int.parse(MenuEditorVariables.preorderPriceController.text)))/100);
                                        }
                                      }

                                    });
                                  }),
                                  SizedBox(width: 2*fem,),
                                  Text("Including\npacking",style:  TextStyle(
                                    fontFamily: 'BertSans',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff1d1517),
                                  ),)

                                ],
                              ),
                            ],
                          ),

                          Container(
                            width: 2,
                            height: 120,
                            color: GlobalVariables.primaryColor,
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(label: "Preorder price", controller: MenuEditorVariables.preorderPriceController,width: 40*fem,
                                onChanged: (val){
                                  setState(() {
                                    double preorderPrice;
                                    double pacakgingPrice;
                                    try {
                                      preorderPrice = double.parse(MenuEditorVariables.preorderPriceController.text);
                                    } catch (e) {
                                      print('Invalid double: ${MenuEditorVariables.preorderPriceController.text}');
                                      preorderPrice = 0.0;
                                    }
                                    try {
                                      pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                    } catch (e) {
                                      print('Invalid double: ${MenuEditorVariables.packagindController.text}');
                                      pacakgingPrice=0.0;
                                    }
                                    setState(() {

                                      if(_selectedOrderType ==OrderType.preorder)
                                      {
                                        finalPrice = preorderPrice;
                                      }
                                    });
                                  });
                                },),
                              SizedBox(height: 10,),
                              Container(
                                width: 40*fem,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Final Price",style: TextStyle(
                                          fontFamily: 'RenogareSoft',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: GlobalVariables.textColor,
                                        ),),
                                        SizedBox(width: 5,),
                                        Tooltip(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              border: Border.all(color: Colors.grey),
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Open Sans',
                                            fontSize: 10,
                                            color: Colors.white,
                                            wordSpacing: 0.23,
                                            letterSpacing: 0.23,
                                          ),
                                          message:  'Please ensure the item price matches the price in your menu', // Provide a default value if widget.suffixTooltip is null
                                          child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2,),
                                    Text("\u{20B9} $finalPrice", style: TextStyle(
                                      fontFamily: 'RenogareSoft',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: GlobalVariables.textColor,
                                    ),),
                                    SizedBox(height: 2,),

                                  ],
                                ),
                              ),

                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(label: "Packaging price", controller: MenuEditorVariables.packagindController,width: 40*fem,
                                onChanged: (val){
                                  double normalPrice;
                                  double preOrderPrice;
                                  double pacakgingPrice;
                                  try {
                                    normalPrice = double.parse(MenuEditorVariables.normalPriceController.text);
                                    preOrderPrice = double.parse(MenuEditorVariables.preorderPriceController.text);
                                  } catch (e) {
                                    print('Invalid double: ${MenuEditorVariables.normalPriceController.text}');
                                    normalPrice = 0.0;
                                    preOrderPrice=0.0;
                                  }
                                  try {
                                    pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                  } catch (e) {
                                    print('Invalid double: ${MenuEditorVariables.packagindController.text}');
                                    pacakgingPrice=0.0;
                                  }
                                  setState(() {
                                    if(_selectedOrderType == OrderType.normal)
                                    {
                                      finalPrice =  normalPrice + ((5*(normalPrice+pacakgingPrice))/100) + pacakgingPrice;
                                    }
                                    else if(_selectedOrderType == OrderType.preorder){
                                      finalPrice =  preOrderPrice + ((5*(preOrderPrice+pacakgingPrice))/100) + pacakgingPrice;
                                    }
                                  });
                                },),
                              SizedBox(height:10 ,),
                              Row(
                                children: [
                                  Checkbox(value:MenuEditorVariables.gstPayment, onChanged: (val){
                                    double pacakgingPrice;
                                    try {
                                      pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                    } catch (e) {
                                      print('Invalid double: ${MenuEditorVariables.packagindController.text}');
                                      pacakgingPrice=0.0;
                                    }
                                    setState(() {
                                      MenuEditorVariables.gstPayment = val!;
                                      print("Val $MenuEditorVariables.gstPayment");

                                      if(_selectedOrderType == OrderType.normal)
                                      {
                                        if(MenuEditorVariables.gstPayment)
                                        {
                                          // finalPrice = finalPrice + pacakgingPrice;
                                          finalPrice = int.parse(MenuEditorVariables.normalPriceController.text) + ((5*(int.parse(MenuEditorVariables.normalPriceController.text)+pacakgingPrice))/100) +  pacakgingPrice;
                                        }
                                        else{
                                          // finalPrice =  normalPrice + ((5*(normalPrice+pacakgingPrice))/100) + pacakgingPrice;
                                          finalPrice = int.parse(MenuEditorVariables.normalPriceController.text) + ((5*(int.parse(MenuEditorVariables.normalPriceController.text)))/100);
                                        }
                                      }
                                      else{
                                        if(MenuEditorVariables.gstPayment)
                                        {
                                          // finalPrice = finalPrice + pacakgingPrice;
                                          finalPrice = int.parse(MenuEditorVariables.preorderPriceController.text) + ((5*(int.parse(MenuEditorVariables.preorderPriceController.text)+pacakgingPrice))/100) +  pacakgingPrice;
                                        }
                                        else{
                                          // finalPrice =  normalPrice + ((5*(normalPrice+pacakgingPrice))/100) + pacakgingPrice;
                                          finalPrice = int.parse(MenuEditorVariables.preorderPriceController.text) + ((5*(int.parse(MenuEditorVariables.preorderPriceController.text)))/100);
                                        }
                                      }

                                    });
                                  }),
                                  SizedBox(width: 2*fem,),
                                  Text("Including\npacking",style:  TextStyle(
                                    fontFamily: 'BertSans',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff1d1517),
                                  ),)

                                ],
                              ),
                            ],
                          ),

                        ],
                      ),
                      SizedBox(height: 15,),
                      Container(height: 1,color: GlobalVariables.primaryColor,),
                      SizedBox(height: 15,),
                      Visibility(
                        visible: basic,
                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                CustomTextField(label: "Display name", controller: MenuEditorVariables.displayNameController,width: 120*fem,onChanged: (val) {
                                  setState(() {
                                    setState(() {
                                      ItemDetails.checking = true;
                                      // Update the selected item to immediately reflect changes in the display name
                                      MenuEditorVariables.selectedItem = val!;
                                      widget.item['disName'] = MenuEditorVariables.selectedItem;
                                      print(widget.item['disName']);
                                    });
                                  });

                                },),
                                CustomTextField(label: "Name", controller: MenuEditorVariables.nameController,width: 70*fem,onChanged: (val) {

                                },),
                              ],
                            ),
                            SizedBox(height: 25,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextField(label: "Sub tag", controller: MenuEditorVariables.subTagController,width: 45*fem,),
                                CustomTextField(label: "Price range", controller: MenuEditorVariables.budgetController,width: 45*fem,isDropdown: true,dropdownItems: MenuEditorVariables.budget,
                                  onChanged: (val) {

                                  },),
                                CustomTextField(label: "Item type", controller: MenuEditorVariables.typeController,width: 45*fem,isDropdown: true,dropdownItems: type,onChanged: (val) {

                                },),
                                CustomTextField(label: "Item subtype", controller: MenuEditorVariables.subTypeController,width: 45*fem,isDropdown: true,dropdownItems: subType1,
                                  onChanged: (val) {

                                  },),

                              ],
                            ),

                            SizedBox(height: 25,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextField(label: "Combo type", controller: MenuEditorVariables.comboController,width: 45*fem,isDropdown: true,dropdownItems: ['Single','Combo'],
                                  onChanged: (val){

                                    setState(() {
                                      MenuEditorVariables.comboController.text = val!;
                                    });
                                  },
                                ),
                                CustomTextField(label: "Raw source", controller: MenuEditorVariables.rawSourceController,width: 45*fem,isDropdown: true,dropdownItems: rawSource,),
                                CustomTextField(label: "Category", controller: MenuEditorVariables.categoryController,width: 45*fem,isDropdown: true,dropdownItems: category,
                                  onChanged: (val) {

                                  },),
                                CustomTextField(label: "Sub category", controller: MenuEditorVariables.subCategoryController,width: 45*fem,isDropdown: true,dropdownItems: subCategory,
                                  onChanged: (val) {

                                  },),
                              ],
                            ),

                            SizedBox(height: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                SizedBox(height: 20,),
                                TextField(
                                  maxLines: 2,
                                  controller: descriptionController,
                                  onChanged: (val) {

                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Enter Description for your item',
                                    labelStyle: TextStyle(
                                      fontFamily: 'BertSans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff1d1517),
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),


                              ],
                            ),


                            SizedBox(height: 20,),
                            Visibility(
                              visible: MenuEditorVariables.comboController.text == 'Combo',
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 25),
                                    width: 20,
                                    child: Text("1",style: TextStyle(
                                      fontFamily: 'RenogareSoft',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: GlobalVariables.textColor,
                                    ),),
                                  ),
                                  SizedBox(width: 5*fem,),
                                  CustomTextField(label: "Sections", controller: sectionController,width: 55*fem,isDropdown: true,dropdownItems:sections,
                                    onChanged: (val) {
                                      print("VAlue $val");
                                      setState(() {
                                        items = [];
                                        foodCategories.forEach((key, value) {
                                          value.forEach((element) {
                                            if(key == val)
                                            {
                                              print(element['name']);
                                              items.add(element['name']);
                                            }
                                          });
                                        });
                                      });
                                    },
                                  ),
                                  SizedBox(width: 10*fem,),
                                  CustomTextField(label: 'Search for item',
                                    width: 55*fem,
                                    controller: itemController,
                                    suffixWidget: Icon(Icons.search),
                                    dropdownItems: items,
                                    isDropdown: true,
                                    onChanged: (val) {
                                      setState(() {
                                        comboList.add(Combo(items: val!, section: sectionController.text));
                                        print("The Combo is ${comboList.toString()}");
                                        comboList.forEach((element) {
                                          print(element.items);
                                        });
                                      });
                                    },
                                    showSearchBox1: true,
                                    // dropdownAuto: true,
                                  ),
                                  SizedBox(width: 10,),

                                ],
                              ),
                            ),
                            Visibility(
                              visible: MenuEditorVariables.comboController.text == 'Combo',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int index = 0; index <= comboList.length && index  < 13; index++ )
                                    Column(
                                      children: [
                                        buildCombo(index,items),
                                        SizedBox(height: 0),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              );
            },
            tabletBuilder: (BuildContext context,BoxConstraints constraints){
              print("I am also cimnng here as well");
              return widget.item['disName'] == '' ? Container()
                  : Container(
                padding: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 5*fem,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text.rich(
                                TextSpan(
                                  text: '',  // Initial text, can be left empty or removed
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '*',  // Asterisk symbol
                                      style: TextStyle(
                                        fontFamily: 'RenogareSoft',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '  All prices are inclusive of taxes',  // Space before the text
                                      style: TextStyle(
                                        fontFamily: 'RenogareSoft',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [
                                  // CustomTextFieldPrice(
                                  //   label: "Normal price",
                                  //   required: true,
                                  //   controller: MenuEditorVariables.normalPriceController,
                                  //   width: 40 * fem,
                                  //   onlyDigits: true,
                                  //   readOnly: true,
                                  //   onTap: (){
                                  //     MenuEditorFunction.showPriceDialogueNormal(context,menuContext, "Normal",state);
                                  //   },
                                  //   onChanged: (val) {
                                  //     MenuEditorVariables.priceFlag = true;
                                  //     if (_debounce?.isActive ?? false) _debounce!.cancel();
                                  //     _debounce = Timer(const Duration(milliseconds: 500), () {
                                  //       if (val!.isEmpty) {
                                  //         setState(() {
                                  //           MenuEditorVariables.normalPriceController.text = '0';
                                  //         });
                                  //       } else if (val.startsWith('.')) {
                                  //         setState(() {
                                  //           MenuEditorVariables.normalPriceController.text = '0$val';
                                  //         });
                                  //       }
                                  //
                                  //       double normalPrice;
                                  //       double packagingPrice;
                                  //       try {
                                  //         normalPrice = double.parse(MenuEditorVariables.normalPriceController.text);
                                  //         packagingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                  //       } catch (e) {
                                  //         normalPrice = 0.0;
                                  //         packagingPrice = 0.0;
                                  //       }
                                  //
                                  //       setState(() {
                                  //         if (MenuEditorVariables.gstPayment) {
                                  //           MenuEditorVariables.normalFinalPrice = (normalPrice + packagingPrice) + ((5 * (normalPrice + packagingPrice)) / 100);
                                  //           MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                                  //         } else {
                                  //           MenuEditorVariables.normalFinalPrice = (normalPrice + packagingPrice) + ((normalPrice * 5) / 100);
                                  //           MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                                  //         }
                                  //       });
                                  //     });
                                  //   },
                                  // ),

                                  // SizedBox(width: 10*fem,),
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     Row(
                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                  //       children: [
                                  //         Text("Final Price",style: TextStyle(
                                  //           fontFamily: 'RenogareSoft',
                                  //           fontSize: 14,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: GlobalVariables.textColor,
                                  //         ),),
                                  //         SizedBox(width: 5,),
                                  //         Tooltip(
                                  //           height: 40,
                                  //           decoration: BoxDecoration(
                                  //               color: Colors.grey,
                                  //               border: Border.all(color: Colors.grey),
                                  //               borderRadius: BorderRadius.circular(5)
                                  //           ),
                                  //           textStyle: TextStyle(
                                  //             fontWeight: FontWeight.w300,
                                  //             fontFamily: 'Open Sans',
                                  //             fontSize: 10,
                                  //             color: Colors.white,
                                  //             wordSpacing: 0.23,
                                  //             letterSpacing: 0.23,
                                  //           ),
                                  //           message:  'Please ensure the item price matches the price in your menu', // Provide a default value if widget.suffixTooltip is null
                                  //           child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     SizedBox(height: 2,),
                                  //     Text("\u{20B9} ${MenuEditorVariables.normalFinalPrice}", style: TextStyle(
                                  //       fontFamily: 'RenogareSoft',
                                  //       fontSize: 15,
                                  //       fontWeight: FontWeight.w600,
                                  //       color: GlobalVariables.textColor,
                                  //     ),),
                                  //     SizedBox(height: 2,),
                                  //
                                  //   ],
                                  // ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Normal price",style: TextStyle(
                                            fontFamily: 'RenogareSoft',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: GlobalVariables.textColor,
                                          ),),
                                          SizedBox(width: 5*fem,),
                                          Tooltip(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Open Sans',
                                              fontSize: 10,
                                              color: Colors.white,
                                              wordSpacing: 0.23,
                                              letterSpacing: 0.23,
                                            ),
                                            message:  'Please ensure the item price matches the price in your menu', // Provide a default value if widget.suffixTooltip is null
                                            child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                                          ),
                                          SizedBox(width: 5*fem,),
                                          InkWell(
                                              onTap: (){
                                                MenuEditorFunction.showPriceDialogueNormal(context,menuContext, "Normal",state);
                                              },
                                              child: Icon(Icons.edit, size: 18))
                                        ],
                                      ),
                                      SizedBox(height: 2,),
                                      Text("\u{20B9} ${MenuEditorVariables.normalPriceController.text}",
                                        style: TextStyle(
                                          fontFamily: 'RenogareSoft',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: GlobalVariables.textColor,
                                        ),),
                                      SizedBox(height: 2,),

                                    ],
                                  ),

                                ],
                              ),
                              SizedBox(height: 30,),
                              Row(
                                children: [
                                  // CustomTextFieldPrice(label: "Preorder price", controller: MenuEditorVariables.preorderPriceController,width: 40*fem,
                                  //   onlyDigits: true,
                                  //   required: true,
                                  //   readOnly: true,
                                  //   onTap: (){
                                  //     MenuEditorFunction.showPriceDialoguePreorder(context,menuContext, "Preorder",state);
                                  //   },
                                  //   onChanged: (val){
                                  //     MenuEditorVariables.priceFlag = true;
                                  //     if (val!.isEmpty) {
                                  //       MenuEditorVariables.preorderPriceController.text = '0';
                                  //       val = '0';
                                  //     } else if (val.startsWith('.')) {
                                  //       MenuEditorVariables.preorderPriceController.text = '0$val';
                                  //       val = '0$val';
                                  //     }
                                  //     setState(() {
                                  //       double preorderPrice;
                                  //       double pacakgingPrice;
                                  //       try {
                                  //         preorderPrice = double.parse(MenuEditorVariables.preorderPriceController.text);
                                  //         pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                  //       } catch (e) {
                                  //         preorderPrice = 0.0;
                                  //         pacakgingPrice = 0.0;
                                  //       }
                                  //
                                  //       setState(() {
                                  //         if(MenuEditorVariables.gstPayment){
                                  //           MenuEditorVariables.preOrderFinalPrice =  (preorderPrice + pacakgingPrice) + ((5*(preorderPrice  + pacakgingPrice))/100);
                                  //           MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                                  //         }else {
                                  //           MenuEditorVariables.preOrderFinalPrice = (preorderPrice  + pacakgingPrice) + ((preorderPrice  * 5)/100);
                                  //           MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                                  //         }
                                  //       });
                                  //
                                  //     });
                                  //   },
                                  // ),
                                  // SizedBox(width: 10*fem,),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Preorder price",style: TextStyle(
                                            fontFamily: 'RenogareSoft',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: GlobalVariables.textColor,
                                          ),),
                                          SizedBox(width: 5*fem,),
                                          Tooltip(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Open Sans',
                                              fontSize: 10,
                                              color: Colors.white,
                                              wordSpacing: 0.23,
                                              letterSpacing: 0.23,
                                            ),
                                            message:  'Please ensure the item price matches the price in your menu', // Provide a default value if widget.suffixTooltip is null
                                            child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                                          ),
                                          SizedBox(width: 5*fem,),
                                          InkWell(
                                              onTap: (){
                                                MenuEditorFunction.showPriceDialoguePreorder(context,menuContext, "Preorder",state);
                                              },
                                              child: Icon(Icons.edit, size: 18))
                                        ],
                                      ),
                                      SizedBox(height: 2,),
                                      Text("\u{20B9} ${MenuEditorVariables.preorderPriceController.text}",
                                        style: TextStyle(
                                          fontFamily: 'RenogareSoft',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: GlobalVariables.textColor,
                                        ),),
                                      SizedBox(height: 2,),

                                    ],
                                  ),

                                ],
                              ),

                            ],
                          ),
                          SizedBox(width: 30*fem,),

                          Container(
                            width: 2,
                            height: 220,
                            color: GlobalVariables.primaryColor,
                          ),

                          SizedBox(width: 20*fem,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  Checkbox(value: MenuEditorVariables.halfSelected, onChanged: (val){
                                    setState(() {
                                      MenuEditorVariables.priceFlag = true;
                                      MenuEditorVariables.halfSelected = val!;
                                    });
                                  }),
                                  SizedBox(width: 10,),
                                  Text('Half plate',style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.textColor,
                                  ),)
                                ],
                              ),
                              SizedBox(height: 10,),

                              Visibility(
                                visible:MenuEditorVariables.halfSelected ,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Half normal price",style: TextStyle(
                                              fontFamily: 'RenogareSoft',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: GlobalVariables.textColor,
                                            ),),
                                            SizedBox(width: 5*fem,),
                                            Tooltip(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontFamily: 'Open Sans',
                                                fontSize: 10,
                                                color: Colors.white,
                                                wordSpacing: 0.23,
                                                letterSpacing: 0.23,
                                              ),
                                              message:  'Please ensure the item price matches the price in your menu', // Provide a default value if widget.suffixTooltip is null
                                              child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                                            ),
                                            SizedBox(width: 5*fem,),
                                            InkWell(
                                                onTap: (){
                                                  MenuEditorFunction.showPriceDialogueHalfNormal(context,menuContext, "Normal",state);
                                                },
                                                child: Icon(Icons.edit, size: 18))
                                          ],
                                        ),
                                        SizedBox(height: 2,),
                                        Text("\u{20B9} ${MenuEditorVariables.halfNormalPriceController.text}",
                                          style: TextStyle(
                                            fontFamily: 'RenogareSoft',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: GlobalVariables.textColor,
                                          ),),
                                        SizedBox(height: 2,),

                                      ],
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: 30,),

                              Visibility(
                                visible: MenuEditorVariables.halfSelected,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Half preorder price",style: TextStyle(
                                              fontFamily: 'RenogareSoft',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: GlobalVariables.textColor,
                                            ),),
                                            SizedBox(width: 5*fem,),
                                            Tooltip(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontFamily: 'Open Sans',
                                                fontSize: 10,
                                                color: Colors.white,
                                                wordSpacing: 0.23,
                                                letterSpacing: 0.23,
                                              ),
                                              message:  'Please ensure the item price matches the price in your menu', // Provide a default value if widget.suffixTooltip is null
                                              child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                                            ),
                                            SizedBox(width: 5*fem,),
                                            InkWell(
                                                onTap: (){
                                                  MenuEditorFunction.showPriceDialogueHalfPreorder(context,menuContext, "Preorder",state);
                                                },
                                                child: Icon(Icons.edit, size: 18))
                                          ],
                                        ),
                                        SizedBox(height: 2,),
                                        Text("\u{20B9} ${MenuEditorVariables.halfPreorderPriceController.text}",
                                          style: TextStyle(
                                            fontFamily: 'RenogareSoft',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: GlobalVariables.textColor,
                                          ),),
                                        SizedBox(height: 2,),

                                      ],
                                    ),

                                  ],
                                ),
                              ),

                            ],
                          ),

                          // Column(
                          //   children: [
                          //     Row(
                          //       children: [
                          //
                          //         CustomTextField(label: "Packaging price", controller: MenuEditorVariables.packagindController,width: 40*fem,
                          //           onlyDigits: true,
                          //           onChanged: (val) {
                          //             MenuEditorVariables.priceFlag = true;
                          //             if (val!.isEmpty) {
                          //               MenuEditorVariables.packagindController.text = '0';
                          //               val = '0';
                          //             } else if (val.startsWith('.')) {
                          //               MenuEditorVariables.packagindController.text = '0$val';
                          //               val = '0$val';
                          //             }
                          //             double normalPrice;
                          //             double preOrderPrice;
                          //             double pacakgingPrice;
                          //             double halfNormalPrice;
                          //             double halfPreorderPrice;
                          //             try {
                          //               normalPrice = double.parse(MenuEditorVariables.normalPriceController.text);
                          //               preOrderPrice = double.parse(MenuEditorVariables.preorderPriceController.text);
                          //               pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                          //               halfNormalPrice = double.parse(MenuEditorVariables.halfNormalPriceController.text);
                          //               halfPreorderPrice = double.parse(MenuEditorVariables.halfPreorderPriceController.text);
                          //             } catch (e) {
                          //               normalPrice = 0.0;
                          //               preOrderPrice=0.0;
                          //               pacakgingPrice=0.0;
                          //               halfNormalPrice =0.0;
                          //               halfPreorderPrice=0.0;
                          //             }
                          //
                          //             setState(() {
                          //               if(MenuEditorVariables.gstPayment)
                          //                 {
                          //                   if(int.parse(MenuEditorVariables.normalPriceController.text) > 0)
                          //                     {
                          //                       MenuEditorVariables.normalFinalPrice = (normalPrice+pacakgingPrice) + ((5*(normalPrice+pacakgingPrice))/100);
                          //                       MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                          //                     }
                          //                   if(int.parse(MenuEditorVariables.preorderPriceController.text) > 0)
                          //                     {
                          //                       MenuEditorVariables.preOrderFinalPrice =  (preOrderPrice+pacakgingPrice) + ((5*(preOrderPrice+pacakgingPrice))/100);
                          //                       MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                          //                     }
                          //
                          //                   if(int.parse(MenuEditorVariables.halfNormalPriceController.text) > 0)
                          //                   {
                          //                     MenuEditorVariables.halfNormalFinalPrice = (halfNormalPrice+pacakgingPrice) + ((5*(halfNormalPrice+pacakgingPrice))/100);
                          //                     MenuEditorVariables.halfNormalFinalPrice = double.parse(MenuEditorVariables.halfNormalFinalPrice.toStringAsFixed(2));
                          //                   }
                          //                   if(int.parse(MenuEditorVariables.halfPreorderPriceController.text) > 0)
                          //                   {
                          //                     MenuEditorVariables.halfPreOrderFinalPrice =  (halfPreorderPrice+pacakgingPrice) + ((5*(halfPreorderPrice+pacakgingPrice))/100);
                          //                     MenuEditorVariables.halfPreOrderFinalPrice = double.parse(MenuEditorVariables.halfPreOrderFinalPrice.toStringAsFixed(2));
                          //                   }
                          //
                          //                 } else {
                          //
                          //                 if(int.parse(MenuEditorVariables.normalPriceController.text) > 0)
                          //                   {
                          //                     MenuEditorVariables.normalFinalPrice =    normalPrice + ((5*(normalPrice))/100) + pacakgingPrice;
                          //                     MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                          //                   }
                          //
                          //                 if(int.parse(MenuEditorVariables.preorderPriceController.text) > 0){
                          //                   MenuEditorVariables.preOrderFinalPrice =  preOrderPrice + ((5*(preOrderPrice))/100) + pacakgingPrice;
                          //                   MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                          //                 }
                          //
                          //                 if(int.parse(MenuEditorVariables.halfNormalPriceController.text) > 0)
                          //                 {
                          //                   MenuEditorVariables.halfNormalFinalPrice =    halfNormalPrice + ((5*(halfNormalPrice))/100) + pacakgingPrice;
                          //                   MenuEditorVariables.halfNormalFinalPrice = double.parse(MenuEditorVariables.halfNormalFinalPrice.toStringAsFixed(2));
                          //                 }
                          //
                          //                 if(int.parse(MenuEditorVariables.halfPreorderPriceController.text) > 0){
                          //                   MenuEditorVariables.halfPreOrderFinalPrice =  halfPreorderPrice + ((5*(halfPreorderPrice))/100) + pacakgingPrice;
                          //                   MenuEditorVariables.halfPreOrderFinalPrice = double.parse(MenuEditorVariables.halfPreOrderFinalPrice.toStringAsFixed(2));
                          //                 }
                          //
                          //
                          //               }
                          //             });
                          //           },),
                          //       ],
                          //     ),
                          //     SizedBox(height: 20,),
                          //     Row(
                          //       children: [
                          //         Checkbox(value:MenuEditorVariables.gstPayment, onChanged: (val){
                          //           MenuEditorVariables.priceFlag = true;
                          //           double pacakgingPrice;
                          //           try {
                          //             pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                          //           } catch (e) {
                          //             pacakgingPrice=0.0;
                          //           }
                          //           setState(() {
                          //             MenuEditorVariables.gstPayment = val!;
                          //             if(MenuEditorVariables.gstPayment)
                          //             {
                          //
                          //               MenuEditorVariables.normalFinalPrice = (int.parse(MenuEditorVariables.normalPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.normalPriceController.text)+pacakgingPrice))/100);
                          //               MenuEditorVariables.preOrderFinalPrice = (int.parse(MenuEditorVariables.preorderPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.preorderPriceController.text)+pacakgingPrice))/100);
                          //
                          //               MenuEditorVariables.halfNormalFinalPrice = (int.parse(MenuEditorVariables.halfNormalPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.halfNormalPriceController.text)+pacakgingPrice))/100);
                          //               MenuEditorVariables.halfPreOrderFinalPrice = (int.parse(MenuEditorVariables.halfPreorderPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.halfPreorderPriceController.text)+pacakgingPrice))/100);
                          //             }
                          //             else{
                          //               MenuEditorVariables.normalFinalPrice = (int.parse(MenuEditorVariables.normalPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.normalPriceController.text)))/100);
                          //               MenuEditorVariables.preOrderFinalPrice = (int.parse(MenuEditorVariables.preorderPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.preorderPriceController.text)))/100);
                          //
                          //               MenuEditorVariables.halfNormalFinalPrice = (int.parse(MenuEditorVariables.halfNormalPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.halfNormalPriceController.text)))/100);
                          //               MenuEditorVariables.halfPreOrderFinalPrice = (int.parse(MenuEditorVariables.halfPreorderPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.halfPreorderPriceController.text)))/100) ;
                          //             }
                          //
                          //
                          //           });
                          //         }),
                          //         SizedBox(width: 5,),
                          //         Text("Including packing",style:  TextStyle(
                          //           fontFamily: 'BertSans',
                          //           fontSize: 12,
                          //           fontWeight: FontWeight.w600,
                          //           color: Color(0xff1d1517),
                          //         ),)
                          //
                          //       ],
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      Container(height: 1,color: GlobalVariables.primaryColor,),
                      SizedBox(height: 15,),
                      Visibility(
                        visible: basic,
                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                CustomTextField(label: "Display name", controller: MenuEditorVariables.displayNameController,width: widget.type == "Tab" ? 160*fem : 130*fem,
                                  digitsAndLetters: true,
                                  required: true,
                                  onChanged: (val)
                                {
                                  MenuEditorVariables.displayNameFlag = true;
                                  if (val!.startsWith(' ')) {
                                    MenuEditorVariables.displayNameController.text = val.trimLeft();
                                    MenuEditorVariables.displayNameController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: MenuEditorVariables.displayNameController.text.length),
                                    );
                                  }
                                  ItemDetails.checking = true;
                                },

                                  displayCount: true,),
                                CustomTextField(label: "Price range", controller: MenuEditorVariables.budgetController,width: 45*fem,isDropdown: true,dropdownItems: MenuEditorVariables.budget,
                                  selectedValue: MenuEditorVariables.budgetController.text,
                                  isChangedDropDown: true,
                                  required: true,
                                  onChangedDropdown: (val){
                                    setState(() {
                                      MenuEditorVariables.propertyFlag = true;
                                      MenuEditorVariables.budgetController.text = val!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 25,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                CustomTextField(label: "Combo type", controller: MenuEditorVariables.comboController,width: 45*fem,isDropdown: true,dropdownItems: ['SINGLE','COMBO'],
                                  selectedValue: MenuEditorVariables.comboController.text,
                                  isChangedDropDown: true,
                                  required: true,
                                  onChanged: (val){
                                    ItemDetails.enable = true;
                                    setState(() {
                                      MenuEditorVariables.comboController.text = val!;
                                    });
                                  },
                                  onChangedDropdown: (val){
                                    MenuEditorVariables.propertyFlag = true;
                                    setState(() {
                                      MenuEditorVariables.comboController.text = val!;
                                    });
                                  },
                                ),
                                CustomTextField(label: "Item type", controller: MenuEditorVariables.typeController,width: 45*fem,isDropdown: true,dropdownItems: type,
                                  required: true,
                                  onChanged: (val) {
                                    ItemDetails.enable = true;
                                    setState(() {
                                      if(MenuEditorVariables.typeController.text == "FOOD") {
                                        subType1 = ["Prepare to eat","Ready to eat"];
                                        MenuEditorVariables.subTypeController.text = 'SELECT';
                                      } else {
                                        subType1 = ["Prepare to drink","Ready to drink"];
                                        MenuEditorVariables.subTypeController.text = 'SELECT';
                                      }
                                    });
                                },
                                  isChangedDropDown: true,
                                  onChangedDropdown: (val){
                                    MenuEditorVariables.propertyFlag = true;
                                    MenuEditorVariables.typeController.text = val!;
                                    setState(() {
                                      if(MenuEditorVariables.typeController.text == "FOOD" || MenuEditorVariables.typeController.text == "Food") {
                                        subType1 = ["SELECT ","PREPARE TO EAT","READY TO EAT",];
                                        MenuEditorVariables.subTypeController.text = subType1[0];
                                      } else {
                                        subType2 = ["SELECT","PREPARE TO DRINK","READY TO DRINK",];
                                        MenuEditorVariables.subTypeController.text = subType2[0];
                                      }
                                    });
                                  },
                                  selectedValue: MenuEditorVariables.typeController.text,
                                ),
                                CustomTextField(label: "Sub type", controller: MenuEditorVariables.subTypeController,
                                  width: 45*fem,
                                  required: true,
                                  isDropdown: true,
                                  dropdownItems: MenuEditorVariables.typeController.text == "Food" ||
                                      MenuEditorVariables.typeController.text == "FOOD" ? subType1 : subType2,
                                  selectedValue: MenuEditorVariables.subTypeController.text,
                                  isChangedDropDown: true,
                                  onChangedDropdown: (val){
                                    MenuEditorVariables.subTypeController.text = val!;
                                    MenuEditorVariables.propertyFlag = true;
                                  },
                                ),
                                CustomTextField(label: "Category", controller: MenuEditorVariables.categoryController,width: 45*fem,
                                  isDropdown: true,
                                  required: true,
                                  dropdownItems: ['VEG','NON VEG'],
                                  selectedValue: MenuEditorVariables.categoryController.text,
                                  isChangedDropDown: true,
                                  isCategory: true,
                                  onChangedDropdown: (val){
                                    setState(() {
                                      MenuEditorVariables.propertyFlag = true;
                                      MenuEditorVariables.categoryController.text = val!;
                                    });
                                  },
                                ),

                              ],
                            ),

                            SizedBox(height: 25,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BlocProvider(
                                  key: UniqueKey(),
                                  create: (BuildContext context) =>MenuBloc(
                                    MenuService(),
                                  )..add(LoadMenuConsumptionModeEvent(context)),
                                  child: BlocBuilder<MenuBloc,MenuState>(
                                    builder: (context, state) {
                                      print("Inside the menu bloc multi select file is ${MenuEditorVariables.consumptionMode}");

                                      if(state is MenuConsumptionState) {
                                        MenuEditorVariables.consumptionMode = state.consumptionMode;
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width:90*fem,
                                                margin:EdgeInsets.only(top:0,left:0*fem),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("Item default consumption mode",
                                                      style: TextStyle(
                                                        fontFamily: 'RenogareSoft',
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: GlobalVariables.textColor,
                                                      ),),
                                                  ],
                                                )),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              height: 43,
                                              child: MultiSelectDropdown.simpleList(
                                                list: ['Pick up', 'Delivery', 'Dine in',],
                                                width: 85*fem,
                                                initiallySelected:  state.consumptionMode,
                                                onChange: (newList) {
                                                  MenuEditorVariables.propertyFlag = true;
                                                  MenuEditorVariables.consumptionMode = newList.cast<String>();
                                                },
                                                includeSearch: true,
                                                includeSelectAll: true,
                                                boxDecoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  color: Colors.white,
                                                ),
                                                // checkboxFillColor: Color(0xfffbb830),
                                                textStyle:  SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 3.2*fem,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff1d1517),
                                                ),// Add your hint text or label here
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return Center(child: CircularProgressIndicator(),);
                                      // return Container(
                                      //     width: 90*fem,
                                      //     height: 80,
                                      //     child: MultiSelectDropdowns(
                                      //       dropdownItems: ['Pick up', 'Delivery', 'Dine in'],
                                      //       onChanged: (selectedItems) {
                                      //         print('Selected Items: $selectedItems');
                                      //         setState(() {
                                      //           MenuEditorVariables.propertyFlag = true;
                                      //           MenuEditorVariables.consumptionMode = selectedItems;
                                      //         });
                                      //       },
                                      //       selectedValues: MenuEditorVariables.selectItem['consumptionMode'] ?? [],
                                      //       label: 'Consumption mode',
                                      //       controller: MenuEditorVariables.consumptionModeController,
                                      //       required: true,
                                      //       height: 50,
                                      //       width: 90 * fem,
                                      //     )
                                      // );
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: MenuEditorVariables.consumptionMode.contains('Pick up') || MenuEditorVariables.consumptionMode.contains('Delivery') ,
                                  child: CustomTextFieldPrice(label: "Packaging price", controller: MenuEditorVariables.packagindController,width: 45*fem,
                                    onlyDigits: true,
                                    readOnly: true,
                                    onTap: (){

                                    },
                                    onChanged: (val) {
                                      MenuEditorVariables.priceFlag = true;
                                      if (val!.isEmpty) {
                                        MenuEditorVariables.packagindController.text = '0';
                                        val = '0';
                                      } else if (val.startsWith('.')) {
                                        MenuEditorVariables.packagindController.text = '0$val';
                                        val = '0$val';
                                      }
                                      double normalPrice;
                                      double preOrderPrice;
                                      double pacakgingPrice;
                                      double halfNormalPrice;
                                      double halfPreorderPrice;
                                      try {
                                        normalPrice = double.parse(MenuEditorVariables.normalPriceController.text);
                                        preOrderPrice = double.parse(MenuEditorVariables.preorderPriceController.text);
                                        pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                        halfNormalPrice = double.parse(MenuEditorVariables.halfNormalPriceController.text);
                                        halfPreorderPrice = double.parse(MenuEditorVariables.halfPreorderPriceController.text);
                                      } catch (e) {
                                        normalPrice = 0.0;
                                        preOrderPrice=0.0;
                                        pacakgingPrice=0.0;
                                        halfNormalPrice =0.0;
                                        halfPreorderPrice=0.0;
                                      }

                                      setState(() {
                                        if(MenuEditorVariables.gstPayment)
                                        {
                                          if(int.parse(MenuEditorVariables.normalPriceController.text) > 0)
                                          {
                                            MenuEditorVariables.normalFinalPrice = (normalPrice+pacakgingPrice) + ((5*(normalPrice+pacakgingPrice))/100);
                                            MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                                          }
                                          if(int.parse(MenuEditorVariables.preorderPriceController.text) > 0)
                                          {
                                            MenuEditorVariables.preOrderFinalPrice =  (preOrderPrice+pacakgingPrice) + ((5*(preOrderPrice+pacakgingPrice))/100);
                                            MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                                          }

                                          if(int.parse(MenuEditorVariables.halfNormalPriceController.text) > 0)
                                          {
                                            MenuEditorVariables.halfNormalFinalPrice = (halfNormalPrice+pacakgingPrice) + ((5*(halfNormalPrice+pacakgingPrice))/100);
                                            MenuEditorVariables.halfNormalFinalPrice = double.parse(MenuEditorVariables.halfNormalFinalPrice.toStringAsFixed(2));
                                          }
                                          if(int.parse(MenuEditorVariables.halfPreorderPriceController.text) > 0)
                                          {
                                            MenuEditorVariables.halfPreOrderFinalPrice =  (halfPreorderPrice+pacakgingPrice) + ((5*(halfPreorderPrice+pacakgingPrice))/100);
                                            MenuEditorVariables.halfPreOrderFinalPrice = double.parse(MenuEditorVariables.halfPreOrderFinalPrice.toStringAsFixed(2));
                                          }

                                        } else {

                                          if(int.parse(MenuEditorVariables.normalPriceController.text) > 0)
                                          {
                                            MenuEditorVariables.normalFinalPrice =    normalPrice + ((5*(normalPrice))/100) + pacakgingPrice;
                                            MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                                          }

                                          if(int.parse(MenuEditorVariables.preorderPriceController.text) > 0){
                                            MenuEditorVariables.preOrderFinalPrice =  preOrderPrice + ((5*(preOrderPrice))/100) + pacakgingPrice;
                                            MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                                          }

                                          if(int.parse(MenuEditorVariables.halfNormalPriceController.text) > 0)
                                          {
                                            MenuEditorVariables.halfNormalFinalPrice =    halfNormalPrice + ((5*(halfNormalPrice))/100) + pacakgingPrice;
                                            MenuEditorVariables.halfNormalFinalPrice = double.parse(MenuEditorVariables.halfNormalFinalPrice.toStringAsFixed(2));
                                          }

                                          if(int.parse(MenuEditorVariables.halfPreorderPriceController.text) > 0){
                                            MenuEditorVariables.halfPreOrderFinalPrice =  halfPreorderPrice + ((5*(halfPreorderPrice))/100) + pacakgingPrice;
                                            MenuEditorVariables.halfPreOrderFinalPrice = double.parse(MenuEditorVariables.halfPreOrderFinalPrice.toStringAsFixed(2));
                                          }


                                        }
                                      });
                                    },),
                                ),
                                CustomTextField(label: "Cuisine", controller: MenuEditorVariables.cuisineController,width: 45*fem,
                                  readOnly: true,
                                  onTap: (){
                                    MenuEditorFunction.showCuisineDialog(context, menuContext,widget.item['_id'],widget.item['disName']);
                                  },
                                  onChanged: (val) {
                                    ItemDetails.enable = true;
                                  },
                                  onChangedDropdown: (val){
                                    MenuEditorVariables.propertyFlag = true;
                                  },
                                ),
                              ],
                            ),

                            SizedBox(height: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                SizedBox(height: 20,),
                                TextField(
                                  maxLines: 2,
                                  controller: descriptionController,
                                  onChanged: (val) {

                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Enter Description for your item',
                                    labelStyle: TextStyle(
                                      fontFamily: 'BertSans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff1d1517),
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),


                              ],
                            ),

                            SizedBox(height: 20,),
                            Visibility(
                              visible: MenuEditorVariables.comboController.text == 'Combo',
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 25),
                                    width: 20,
                                    child: Text("1",style: TextStyle(
                                      fontFamily: 'RenogareSoft',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: GlobalVariables.textColor,
                                    ),),
                                  ),
                                  SizedBox(width: 5*fem,),
                                  CustomTextField(label: "Sections", controller: sectionController,width: 55*fem,isDropdown: true,dropdownItems:sections,
                                    onChanged: (val) {
                                      print("VAlue $val");
                                      setState(() {
                                        items = [];
                                        foodCategories.forEach((key, value) {
                                          value.forEach((element) {
                                            if(key == val)
                                            {
                                              print(element['name']);
                                              items.add(element['name']);
                                            }
                                          });
                                        });
                                      });
                                    },
                                  ),
                                  SizedBox(width: 10*fem,),
                                  CustomTextField(label: 'Search for item',
                                    width: 55*fem,
                                    controller: itemController,
                                    suffixWidget: Icon(Icons.search),
                                    dropdownItems: items,
                                    isDropdown: true,
                                    onChanged: (val) {
                                      setState(() {
                                        comboList.add(Combo(items: val!, section: sectionController.text));
                                        print("The Combo is ${comboList.toString()}");
                                        comboList.forEach((element) {
                                          print(element.items);
                                        });
                                      });
                                    },
                                    showSearchBox1: true,
                                    // dropdownAuto: true,
                                  ),
                                  SizedBox(width: 10,),

                                ],
                              ),
                            ),
                            Visibility(
                              visible: MenuEditorVariables.comboController.text == 'Combo',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int index = 0; index <= comboList.length && index  < 13; index++ )
                                    Column(
                                      children: [
                                        buildCombo(index,items),
                                        SizedBox(height: 0),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20,),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Advanced",style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.textColor,
                            ),),
                            InkWell(
                              onTap: (){
                                enableAdvance();
                              },
                                child: Icon(advance ?  Icons.arrow_drop_up:Icons.arrow_drop_down ,color: GlobalVariables.primaryColor,size: 30,)),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(height: 1,color: GlobalVariables.primaryColor,),
                      SizedBox(height: 20,),
                      Visibility(
                        visible: advance,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextField(label: "Raw source", controller: MenuEditorVariables.rawSourceController,width: 45*fem,isDropdown: true,dropdownItems: rawSource,
                                  onChangedDropdown: (val){
                                    MenuEditorVariables.propertyFlag = true;
                                    MenuEditorVariables.rawSourceController.text = val!;
                                  },
                                  selectedValue: MenuEditorVariables.rawSourceController.text,
                                ),
                                CustomTextField(label: "Sub category", controller: MenuEditorVariables.subCategoryController,width: 45*fem,showSearchBox1: true,
                                  readOnly: true,
                                  onTap: (){
                                    MenuEditorFunction.showSubCategoriesDialogs(context, menuContext,widget.item['_id'],widget.item['disName'],MenuEditorVariables.categoryController.text);
                                    // menuContext.read<MenuBloc>().add(AddSubcategoryEvent(context, menuContext, MenuEditorVariables.categoryController.text,widget.item['_id'],widget.item['disName']));
                                  },
                                ),
                                CustomTextField(label: "Regional", controller: MenuEditorVariables.regionalController,width: 45*fem,showSearchBox1: true,
                                  readOnly: true,
                                  onTap: (){
                                    // menuContext.read<MenuBloc>().add(AddRegionalEvent(context, menuContext,widget.item['_id'],widget.item['disName']));
                                    MenuEditorFunction.showRegionalDialogs(context, menuContext,widget.item['_id'],widget.item['disName']);
                                  },

                                  // onTap: () {
                                  // print("On TAp is Working");
                                  //   MenuEditorVariables.regional = [];
                                  // },
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                SizedBox(height: 20,),
                                TextField(
                                  maxLines: 3,
                                  controller: cuisineDescriptionController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Description for your cuisine',
                                    border: OutlineInputBorder(),
                                    labelStyle:TextStyle(
                                      fontFamily: 'BertSans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff1d1517),
                                    ),
                                  ),
                                ),


                              ],
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              );
            },
            desktopBuilder: (BuildContext context,BoxConstraints constraints){
              return widget.item['disName'] == '' ? Container()
                  : Container(
                padding: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 5*fem,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text.rich(
                                TextSpan(
                                  text: '',  // Initial text, can be left empty or removed
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '*',  // Asterisk symbol
                                      style: TextStyle(
                                        fontFamily: 'RenogareSoft',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '  All prices are inclusive of taxes',  // Space before the text
                                      style: TextStyle(
                                        fontFamily: 'RenogareSoft',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [
                                  // CustomTextFieldPrice(
                                  //   label: "Normal price",
                                  //   required: true,
                                  //   controller: MenuEditorVariables.normalPriceController,
                                  //   width: 40 * fem,
                                  //   onlyDigits: true,
                                  //   readOnly: true,
                                  //   onTap: (){
                                  //     MenuEditorFunction.showPriceDialogueNormal(context,menuContext, "Normal",state);
                                  //   },
                                  //   onChanged: (val) {
                                  //     MenuEditorVariables.priceFlag = true;
                                  //     if (_debounce?.isActive ?? false) _debounce!.cancel();
                                  //     _debounce = Timer(const Duration(milliseconds: 500), () {
                                  //       if (val!.isEmpty) {
                                  //         setState(() {
                                  //           MenuEditorVariables.normalPriceController.text = '0';
                                  //         });
                                  //       } else if (val.startsWith('.')) {
                                  //         setState(() {
                                  //           MenuEditorVariables.normalPriceController.text = '0$val';
                                  //         });
                                  //       }
                                  //
                                  //       double normalPrice;
                                  //       double packagingPrice;
                                  //       try {
                                  //         normalPrice = double.parse(MenuEditorVariables.normalPriceController.text);
                                  //         packagingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                  //       } catch (e) {
                                  //         normalPrice = 0.0;
                                  //         packagingPrice = 0.0;
                                  //       }
                                  //
                                  //       setState(() {
                                  //         if (MenuEditorVariables.gstPayment) {
                                  //           MenuEditorVariables.normalFinalPrice = (normalPrice + packagingPrice) + ((5 * (normalPrice + packagingPrice)) / 100);
                                  //           MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                                  //         } else {
                                  //           MenuEditorVariables.normalFinalPrice = (normalPrice + packagingPrice) + ((normalPrice * 5) / 100);
                                  //           MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                                  //         }
                                  //       });
                                  //     });
                                  //   },
                                  // ),

                                  // SizedBox(width: 10*fem,),
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     Row(
                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                  //       children: [
                                  //         Text("Final Price",style: TextStyle(
                                  //           fontFamily: 'RenogareSoft',
                                  //           fontSize: 14,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: GlobalVariables.textColor,
                                  //         ),),
                                  //         SizedBox(width: 5,),
                                  //         Tooltip(
                                  //           height: 40,
                                  //           decoration: BoxDecoration(
                                  //               color: Colors.grey,
                                  //               border: Border.all(color: Colors.grey),
                                  //               borderRadius: BorderRadius.circular(5)
                                  //           ),
                                  //           textStyle: TextStyle(
                                  //             fontWeight: FontWeight.w300,
                                  //             fontFamily: 'Open Sans',
                                  //             fontSize: 10,
                                  //             color: Colors.white,
                                  //             wordSpacing: 0.23,
                                  //             letterSpacing: 0.23,
                                  //           ),
                                  //           message:  'Please ensure the item price matches the price in your menu', // Provide a default value if widget.suffixTooltip is null
                                  //           child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     SizedBox(height: 2,),
                                  //     Text("\u{20B9} ${MenuEditorVariables.normalFinalPrice}", style: TextStyle(
                                  //       fontFamily: 'RenogareSoft',
                                  //       fontSize: 15,
                                  //       fontWeight: FontWeight.w600,
                                  //       color: GlobalVariables.textColor,
                                  //     ),),
                                  //     SizedBox(height: 2,),
                                  //
                                  //   ],
                                  // ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Normal price",style: TextStyle(
                                            fontFamily: 'RenogareSoft',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: GlobalVariables.textColor,
                                          ),),
                                          SizedBox(width: 5*fem,),
                                          Tooltip(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Open Sans',
                                              fontSize: 10,
                                              color: Colors.white,
                                              wordSpacing: 0.23,
                                              letterSpacing: 0.23,
                                            ),
                                            message:  'Please ensure the item price matches the price in your menu', // Provide a default value if widget.suffixTooltip is null
                                            child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                                          ),
                                          SizedBox(width: 5*fem,),
                                          InkWell(
                                              onTap: (){
                                                MenuEditorFunction.showPriceDialogueNormal(context,menuContext, "Normal",state);
                                              },
                                              child: Icon(Icons.edit, size: 18))
                                        ],
                                      ),
                                      SizedBox(height: 2,),
                                      Text("\u{20B9} ${MenuEditorVariables.normalPriceController.text}",
                                        style: TextStyle(
                                          fontFamily: 'RenogareSoft',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: GlobalVariables.textColor,
                                        ),),
                                      SizedBox(height: 2,),

                                    ],
                                  ),

                                ],
                              ),
                              SizedBox(height: 30,),
                              Row(
                                children: [
                                  // CustomTextFieldPrice(label: "Preorder price", controller: MenuEditorVariables.preorderPriceController,width: 40*fem,
                                  //   onlyDigits: true,
                                  //   required: true,
                                  //   readOnly: true,
                                  //   onTap: (){
                                  //     MenuEditorFunction.showPriceDialoguePreorder(context,menuContext, "Preorder",state);
                                  //   },
                                  //   onChanged: (val){
                                  //     MenuEditorVariables.priceFlag = true;
                                  //     if (val!.isEmpty) {
                                  //       MenuEditorVariables.preorderPriceController.text = '0';
                                  //       val = '0';
                                  //     } else if (val.startsWith('.')) {
                                  //       MenuEditorVariables.preorderPriceController.text = '0$val';
                                  //       val = '0$val';
                                  //     }
                                  //     setState(() {
                                  //       double preorderPrice;
                                  //       double pacakgingPrice;
                                  //       try {
                                  //         preorderPrice = double.parse(MenuEditorVariables.preorderPriceController.text);
                                  //         pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                  //       } catch (e) {
                                  //         preorderPrice = 0.0;
                                  //         pacakgingPrice = 0.0;
                                  //       }
                                  //
                                  //       setState(() {
                                  //         if(MenuEditorVariables.gstPayment){
                                  //           MenuEditorVariables.preOrderFinalPrice =  (preorderPrice + pacakgingPrice) + ((5*(preorderPrice  + pacakgingPrice))/100);
                                  //           MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                                  //         }else {
                                  //           MenuEditorVariables.preOrderFinalPrice = (preorderPrice  + pacakgingPrice) + ((preorderPrice  * 5)/100);
                                  //           MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                                  //         }
                                  //       });
                                  //
                                  //     });
                                  //   },
                                  // ),
                                  // SizedBox(width: 10*fem,),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Preorder price",style: TextStyle(
                                            fontFamily: 'RenogareSoft',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: GlobalVariables.textColor,
                                          ),),
                                          SizedBox(width: 5*fem,),
                                          Tooltip(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Open Sans',
                                              fontSize: 10,
                                              color: Colors.white,
                                              wordSpacing: 0.23,
                                              letterSpacing: 0.23,
                                            ),
                                            message:  'Please ensure the item price matches the price in your menu', // Provide a default value if widget.suffixTooltip is null
                                            child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                                          ),
                                          SizedBox(width: 5*fem,),
                                          InkWell(
                                              onTap: (){
                                                MenuEditorFunction.showPriceDialoguePreorder(context,menuContext, "Preorder",state);
                                              },
                                              child: Icon(Icons.edit, size: 18))
                                        ],
                                      ),
                                      SizedBox(height: 2,),
                                      Text("\u{20B9} ${MenuEditorVariables.preorderPriceController.text}",
                                        style: TextStyle(
                                          fontFamily: 'RenogareSoft',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: GlobalVariables.textColor,
                                        ),),
                                      SizedBox(height: 2,),

                                    ],
                                  ),

                                ],
                              ),

                            ],
                          ),
                          SizedBox(width: 30*fem,),

                          Container(
                            width: 2,
                            height: 220,
                            color: GlobalVariables.primaryColor,
                          ),

                          SizedBox(width: 20*fem,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  Checkbox(value: MenuEditorVariables.halfSelected, onChanged: (val){
                                    setState(() {
                                      MenuEditorVariables.priceFlag = true;
                                      MenuEditorVariables.halfSelected = val!;
                                    });
                                  }),
                                  SizedBox(width: 10,),
                                  Text('Half plate',style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.textColor,
                                  ),)
                                ],
                              ),
                              SizedBox(height: 10,),

                              Visibility(
                                visible:MenuEditorVariables.halfSelected ,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Half normal price",style: TextStyle(
                                              fontFamily: 'RenogareSoft',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: GlobalVariables.textColor,
                                            ),),
                                            SizedBox(width: 5*fem,),
                                            Tooltip(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontFamily: 'Open Sans',
                                                fontSize: 10,
                                                color: Colors.white,
                                                wordSpacing: 0.23,
                                                letterSpacing: 0.23,
                                              ),
                                              message:  'Please ensure the item price matches the price in your menu', // Provide a default value if widget.suffixTooltip is null
                                              child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                                            ),
                                            SizedBox(width: 5*fem,),
                                            InkWell(
                                                onTap: (){
                                                  MenuEditorFunction.showPriceDialogueHalfNormal(context,menuContext, "Normal",state);
                                                },
                                                child: Icon(Icons.edit, size: 18))
                                          ],
                                        ),
                                        SizedBox(height: 2,),
                                        Text("\u{20B9} ${MenuEditorVariables.halfNormalPriceController.text}",
                                          style: TextStyle(
                                            fontFamily: 'RenogareSoft',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: GlobalVariables.textColor,
                                          ),),
                                        SizedBox(height: 2,),

                                      ],
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: 30,),

                              Visibility(
                                visible: MenuEditorVariables.halfSelected,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Half preorder price",style: TextStyle(
                                              fontFamily: 'RenogareSoft',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: GlobalVariables.textColor,
                                            ),),
                                            SizedBox(width: 5*fem,),
                                            Tooltip(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontFamily: 'Open Sans',
                                                fontSize: 10,
                                                color: Colors.white,
                                                wordSpacing: 0.23,
                                                letterSpacing: 0.23,
                                              ),
                                              message:  'Please ensure the item price matches the price in your menu', // Provide a default value if widget.suffixTooltip is null
                                              child: Icon(Icons.info, color: Colors.blueGrey, size: 15,),
                                            ),
                                            SizedBox(width: 5*fem,),
                                            InkWell(
                                                onTap: (){
                                                  MenuEditorFunction.showPriceDialogueHalfPreorder(context,menuContext, "Preorder",state);
                                                },
                                                child: Icon(Icons.edit, size: 18))
                                          ],
                                        ),
                                        SizedBox(height: 2,),
                                        Text("\u{20B9} ${MenuEditorVariables.halfPreorderPriceController.text}",
                                          style: TextStyle(
                                            fontFamily: 'RenogareSoft',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: GlobalVariables.textColor,
                                          ),),
                                        SizedBox(height: 2,),

                                      ],
                                    ),

                                  ],
                                ),
                              ),

                            ],
                          ),

                          // Column(
                          //   children: [
                          //     Row(
                          //       children: [
                          //
                          //         CustomTextField(label: "Packaging price", controller: MenuEditorVariables.packagindController,width: 40*fem,
                          //           onlyDigits: true,
                          //           onChanged: (val) {
                          //             MenuEditorVariables.priceFlag = true;
                          //             if (val!.isEmpty) {
                          //               MenuEditorVariables.packagindController.text = '0';
                          //               val = '0';
                          //             } else if (val.startsWith('.')) {
                          //               MenuEditorVariables.packagindController.text = '0$val';
                          //               val = '0$val';
                          //             }
                          //             double normalPrice;
                          //             double preOrderPrice;
                          //             double pacakgingPrice;
                          //             double halfNormalPrice;
                          //             double halfPreorderPrice;
                          //             try {
                          //               normalPrice = double.parse(MenuEditorVariables.normalPriceController.text);
                          //               preOrderPrice = double.parse(MenuEditorVariables.preorderPriceController.text);
                          //               pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                          //               halfNormalPrice = double.parse(MenuEditorVariables.halfNormalPriceController.text);
                          //               halfPreorderPrice = double.parse(MenuEditorVariables.halfPreorderPriceController.text);
                          //             } catch (e) {
                          //               normalPrice = 0.0;
                          //               preOrderPrice=0.0;
                          //               pacakgingPrice=0.0;
                          //               halfNormalPrice =0.0;
                          //               halfPreorderPrice=0.0;
                          //             }
                          //
                          //             setState(() {
                          //               if(MenuEditorVariables.gstPayment)
                          //                 {
                          //                   if(int.parse(MenuEditorVariables.normalPriceController.text) > 0)
                          //                     {
                          //                       MenuEditorVariables.normalFinalPrice = (normalPrice+pacakgingPrice) + ((5*(normalPrice+pacakgingPrice))/100);
                          //                       MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                          //                     }
                          //                   if(int.parse(MenuEditorVariables.preorderPriceController.text) > 0)
                          //                     {
                          //                       MenuEditorVariables.preOrderFinalPrice =  (preOrderPrice+pacakgingPrice) + ((5*(preOrderPrice+pacakgingPrice))/100);
                          //                       MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                          //                     }
                          //
                          //                   if(int.parse(MenuEditorVariables.halfNormalPriceController.text) > 0)
                          //                   {
                          //                     MenuEditorVariables.halfNormalFinalPrice = (halfNormalPrice+pacakgingPrice) + ((5*(halfNormalPrice+pacakgingPrice))/100);
                          //                     MenuEditorVariables.halfNormalFinalPrice = double.parse(MenuEditorVariables.halfNormalFinalPrice.toStringAsFixed(2));
                          //                   }
                          //                   if(int.parse(MenuEditorVariables.halfPreorderPriceController.text) > 0)
                          //                   {
                          //                     MenuEditorVariables.halfPreOrderFinalPrice =  (halfPreorderPrice+pacakgingPrice) + ((5*(halfPreorderPrice+pacakgingPrice))/100);
                          //                     MenuEditorVariables.halfPreOrderFinalPrice = double.parse(MenuEditorVariables.halfPreOrderFinalPrice.toStringAsFixed(2));
                          //                   }
                          //
                          //                 } else {
                          //
                          //                 if(int.parse(MenuEditorVariables.normalPriceController.text) > 0)
                          //                   {
                          //                     MenuEditorVariables.normalFinalPrice =    normalPrice + ((5*(normalPrice))/100) + pacakgingPrice;
                          //                     MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                          //                   }
                          //
                          //                 if(int.parse(MenuEditorVariables.preorderPriceController.text) > 0){
                          //                   MenuEditorVariables.preOrderFinalPrice =  preOrderPrice + ((5*(preOrderPrice))/100) + pacakgingPrice;
                          //                   MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                          //                 }
                          //
                          //                 if(int.parse(MenuEditorVariables.halfNormalPriceController.text) > 0)
                          //                 {
                          //                   MenuEditorVariables.halfNormalFinalPrice =    halfNormalPrice + ((5*(halfNormalPrice))/100) + pacakgingPrice;
                          //                   MenuEditorVariables.halfNormalFinalPrice = double.parse(MenuEditorVariables.halfNormalFinalPrice.toStringAsFixed(2));
                          //                 }
                          //
                          //                 if(int.parse(MenuEditorVariables.halfPreorderPriceController.text) > 0){
                          //                   MenuEditorVariables.halfPreOrderFinalPrice =  halfPreorderPrice + ((5*(halfPreorderPrice))/100) + pacakgingPrice;
                          //                   MenuEditorVariables.halfPreOrderFinalPrice = double.parse(MenuEditorVariables.halfPreOrderFinalPrice.toStringAsFixed(2));
                          //                 }
                          //
                          //
                          //               }
                          //             });
                          //           },),
                          //       ],
                          //     ),
                          //     SizedBox(height: 20,),
                          //     Row(
                          //       children: [
                          //         Checkbox(value:MenuEditorVariables.gstPayment, onChanged: (val){
                          //           MenuEditorVariables.priceFlag = true;
                          //           double pacakgingPrice;
                          //           try {
                          //             pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                          //           } catch (e) {
                          //             pacakgingPrice=0.0;
                          //           }
                          //           setState(() {
                          //             MenuEditorVariables.gstPayment = val!;
                          //             if(MenuEditorVariables.gstPayment)
                          //             {
                          //
                          //               MenuEditorVariables.normalFinalPrice = (int.parse(MenuEditorVariables.normalPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.normalPriceController.text)+pacakgingPrice))/100);
                          //               MenuEditorVariables.preOrderFinalPrice = (int.parse(MenuEditorVariables.preorderPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.preorderPriceController.text)+pacakgingPrice))/100);
                          //
                          //               MenuEditorVariables.halfNormalFinalPrice = (int.parse(MenuEditorVariables.halfNormalPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.halfNormalPriceController.text)+pacakgingPrice))/100);
                          //               MenuEditorVariables.halfPreOrderFinalPrice = (int.parse(MenuEditorVariables.halfPreorderPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.halfPreorderPriceController.text)+pacakgingPrice))/100);
                          //             }
                          //             else{
                          //               MenuEditorVariables.normalFinalPrice = (int.parse(MenuEditorVariables.normalPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.normalPriceController.text)))/100);
                          //               MenuEditorVariables.preOrderFinalPrice = (int.parse(MenuEditorVariables.preorderPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.preorderPriceController.text)))/100);
                          //
                          //               MenuEditorVariables.halfNormalFinalPrice = (int.parse(MenuEditorVariables.halfNormalPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.halfNormalPriceController.text)))/100);
                          //               MenuEditorVariables.halfPreOrderFinalPrice = (int.parse(MenuEditorVariables.halfPreorderPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.halfPreorderPriceController.text)))/100) ;
                          //             }
                          //
                          //
                          //           });
                          //         }),
                          //         SizedBox(width: 5,),
                          //         Text("Including packing",style:  TextStyle(
                          //           fontFamily: 'BertSans',
                          //           fontSize: 12,
                          //           fontWeight: FontWeight.w600,
                          //           color: Color(0xff1d1517),
                          //         ),)
                          //
                          //       ],
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      Container(height: 1,color: GlobalVariables.primaryColor,),
                      SizedBox(height: 15,),
                      Visibility(
                        visible: basic,
                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                CustomTextField(label: "Display name", controller: MenuEditorVariables.displayNameController,width: widget.type == "Tab" ? 160*fem : 130*fem,
                                  digitsAndLetters: true,
                                  required: true,
                                  onChanged: (val)
                                  {
                                    MenuEditorVariables.displayNameFlag = true;
                                    if (val!.startsWith(' ')) {
                                      MenuEditorVariables.displayNameController.text = val.trimLeft();
                                      MenuEditorVariables.displayNameController.selection = TextSelection.fromPosition(
                                        TextPosition(offset: MenuEditorVariables.displayNameController.text.length),
                                      );
                                    }
                                    ItemDetails.checking = true;
                                  },

                                  displayCount: true,),
                                CustomTextField(label: "Price range", controller: MenuEditorVariables.budgetController,width: 45*fem,isDropdown: true,dropdownItems: MenuEditorVariables.budget,
                                  selectedValue: MenuEditorVariables.budgetController.text,
                                  isChangedDropDown: true,
                                  required: true,
                                  onChangedDropdown: (val){
                                    setState(() {
                                      MenuEditorVariables.propertyFlag = true;
                                      MenuEditorVariables.budgetController.text = val!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 25,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                CustomTextField(label: "Combo type", controller: MenuEditorVariables.comboController,width: 45*fem,isDropdown: true,dropdownItems: ['SINGLE','COMBO'],
                                  selectedValue: MenuEditorVariables.comboController.text,
                                  isChangedDropDown: true,
                                  required: true,
                                  onChanged: (val){
                                    ItemDetails.enable = true;
                                    setState(() {
                                      MenuEditorVariables.comboController.text = val!;
                                    });
                                  },
                                  onChangedDropdown: (val){
                                    MenuEditorVariables.propertyFlag = true;
                                    setState(() {
                                      MenuEditorVariables.comboController.text = val!;
                                    });
                                  },
                                ),
                                CustomTextField(label: "Item type", controller: MenuEditorVariables.typeController,width: 45*fem,isDropdown: true,dropdownItems: type,
                                  required: true,
                                  onChanged: (val) {
                                    ItemDetails.enable = true;
                                    setState(() {
                                      if(MenuEditorVariables.typeController.text == "FOOD") {
                                        subType1 = ["Prepare to eat","Ready to eat"];
                                        MenuEditorVariables.subTypeController.text = 'SELECT';
                                      } else {
                                        subType1 = ["Prepare to drink","Ready to drink"];
                                        MenuEditorVariables.subTypeController.text = 'SELECT';
                                      }
                                    });
                                  },
                                  isChangedDropDown: true,
                                  onChangedDropdown: (val){
                                    MenuEditorVariables.propertyFlag = true;
                                    MenuEditorVariables.typeController.text = val!;
                                    setState(() {
                                      if(MenuEditorVariables.typeController.text == "FOOD" || MenuEditorVariables.typeController.text == "Food") {
                                        subType1 = ["SELECT ","PREPARE TO EAT","READY TO EAT",];
                                        MenuEditorVariables.subTypeController.text = subType1[0];
                                      } else {
                                        subType2 = ["SELECT","PREPARE TO DRINK","READY TO DRINK",];
                                        MenuEditorVariables.subTypeController.text = subType2[0];
                                      }
                                    });
                                  },
                                  selectedValue: MenuEditorVariables.typeController.text,
                                ),
                                CustomTextField(label: "Sub type", controller: MenuEditorVariables.subTypeController,
                                  width: 45*fem,
                                  required: true,
                                  isDropdown: true,
                                  dropdownItems: MenuEditorVariables.typeController.text == "Food" ||
                                      MenuEditorVariables.typeController.text == "FOOD" ? subType1 : subType2,
                                  selectedValue: MenuEditorVariables.subTypeController.text,
                                  isChangedDropDown: true,
                                  onChangedDropdown: (val){
                                    MenuEditorVariables.subTypeController.text = val!;
                                    MenuEditorVariables.propertyFlag = true;
                                  },
                                ),
                                CustomTextField(label: "Category", controller: MenuEditorVariables.categoryController,width: 45*fem,
                                  isDropdown: true,
                                  required: true,
                                  dropdownItems: ['VEG','NON VEG'],
                                  selectedValue: MenuEditorVariables.categoryController.text,
                                  isChangedDropDown: true,
                                  isCategory: true,
                                  onChangedDropdown: (val){
                                    setState(() {
                                      MenuEditorVariables.propertyFlag = true;
                                      MenuEditorVariables.categoryController.text = val!;
                                    });
                                  },
                                ),

                              ],
                            ),

                            SizedBox(height: 25,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BlocProvider(
                                  key: UniqueKey(),
                                  create: (BuildContext context) =>MenuBloc(
                                    MenuService(),
                                  )..add(LoadMenuConsumptionModeEvent(context)),
                                  child: BlocBuilder<MenuBloc,MenuState>(
                                    builder: (context, state) {
                                      print("Inside the menu bloc multi select file is ${MenuEditorVariables.consumptionMode}");

                                      if(state is MenuConsumptionState) {
                                        MenuEditorVariables.consumptionMode = state.consumptionMode;
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width:90*fem,
                                                margin:EdgeInsets.only(top:0,left:0*fem),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("Item default consumption mode",
                                                      style: TextStyle(
                                                        fontFamily: 'RenogareSoft',
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: GlobalVariables.textColor,
                                                      ),),
                                                  ],
                                                )),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              height: 43,
                                              child: MultiSelectDropdown.simpleList(
                                                list: ['Pick up', 'Delivery', 'Dine in',],
                                                width: 85*fem,
                                                initiallySelected:  state.consumptionMode,
                                                onChange: (newList) {
                                                  MenuEditorVariables.propertyFlag = true;
                                                  MenuEditorVariables.consumptionMode = newList.cast<String>();
                                                },
                                                includeSearch: true,
                                                includeSelectAll: true,
                                                boxDecoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  color: Colors.white,
                                                ),
                                                // checkboxFillColor: Color(0xfffbb830),
                                                textStyle:  SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 3.2*fem,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff1d1517),
                                                ),// Add your hint text or label here
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return Center(child: CircularProgressIndicator(),);
                                      // return Container(
                                      //     width: 90*fem,
                                      //     height: 80,
                                      //     child: MultiSelectDropdowns(
                                      //       dropdownItems: ['Pick up', 'Delivery', 'Dine in'],
                                      //       onChanged: (selectedItems) {
                                      //         print('Selected Items: $selectedItems');
                                      //         setState(() {
                                      //           MenuEditorVariables.propertyFlag = true;
                                      //           MenuEditorVariables.consumptionMode = selectedItems;
                                      //         });
                                      //       },
                                      //       selectedValues: MenuEditorVariables.selectItem['consumptionMode'] ?? [],
                                      //       label: 'Consumption mode',
                                      //       controller: MenuEditorVariables.consumptionModeController,
                                      //       required: true,
                                      //       height: 50,
                                      //       width: 90 * fem,
                                      //     )
                                      // );
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: MenuEditorVariables.consumptionMode.contains('Pick up') || MenuEditorVariables.consumptionMode.contains('Delivery') ,
                                  child: CustomTextFieldPrice(label: "Packaging price", controller: MenuEditorVariables.packagindController,width: 45*fem,
                                    onlyDigits: true,
                                    readOnly: true,
                                    onTap: (){

                                    },
                                    onChanged: (val) {
                                      MenuEditorVariables.priceFlag = true;
                                      if (val!.isEmpty) {
                                        MenuEditorVariables.packagindController.text = '0';
                                        val = '0';
                                      } else if (val.startsWith('.')) {
                                        MenuEditorVariables.packagindController.text = '0$val';
                                        val = '0$val';
                                      }
                                      double normalPrice;
                                      double preOrderPrice;
                                      double pacakgingPrice;
                                      double halfNormalPrice;
                                      double halfPreorderPrice;
                                      try {
                                        normalPrice = double.parse(MenuEditorVariables.normalPriceController.text);
                                        preOrderPrice = double.parse(MenuEditorVariables.preorderPriceController.text);
                                        pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                        halfNormalPrice = double.parse(MenuEditorVariables.halfNormalPriceController.text);
                                        halfPreorderPrice = double.parse(MenuEditorVariables.halfPreorderPriceController.text);
                                      } catch (e) {
                                        normalPrice = 0.0;
                                        preOrderPrice=0.0;
                                        pacakgingPrice=0.0;
                                        halfNormalPrice =0.0;
                                        halfPreorderPrice=0.0;
                                      }

                                      setState(() {
                                        if(MenuEditorVariables.gstPayment)
                                        {
                                          if(int.parse(MenuEditorVariables.normalPriceController.text) > 0)
                                          {
                                            MenuEditorVariables.normalFinalPrice = (normalPrice+pacakgingPrice) + ((5*(normalPrice+pacakgingPrice))/100);
                                            MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                                          }
                                          if(int.parse(MenuEditorVariables.preorderPriceController.text) > 0)
                                          {
                                            MenuEditorVariables.preOrderFinalPrice =  (preOrderPrice+pacakgingPrice) + ((5*(preOrderPrice+pacakgingPrice))/100);
                                            MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                                          }

                                          if(int.parse(MenuEditorVariables.halfNormalPriceController.text) > 0)
                                          {
                                            MenuEditorVariables.halfNormalFinalPrice = (halfNormalPrice+pacakgingPrice) + ((5*(halfNormalPrice+pacakgingPrice))/100);
                                            MenuEditorVariables.halfNormalFinalPrice = double.parse(MenuEditorVariables.halfNormalFinalPrice.toStringAsFixed(2));
                                          }
                                          if(int.parse(MenuEditorVariables.halfPreorderPriceController.text) > 0)
                                          {
                                            MenuEditorVariables.halfPreOrderFinalPrice =  (halfPreorderPrice+pacakgingPrice) + ((5*(halfPreorderPrice+pacakgingPrice))/100);
                                            MenuEditorVariables.halfPreOrderFinalPrice = double.parse(MenuEditorVariables.halfPreOrderFinalPrice.toStringAsFixed(2));
                                          }

                                        } else {

                                          if(int.parse(MenuEditorVariables.normalPriceController.text) > 0)
                                          {
                                            MenuEditorVariables.normalFinalPrice =    normalPrice + ((5*(normalPrice))/100) + pacakgingPrice;
                                            MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                                          }

                                          if(int.parse(MenuEditorVariables.preorderPriceController.text) > 0){
                                            MenuEditorVariables.preOrderFinalPrice =  preOrderPrice + ((5*(preOrderPrice))/100) + pacakgingPrice;
                                            MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                                          }

                                          if(int.parse(MenuEditorVariables.halfNormalPriceController.text) > 0)
                                          {
                                            MenuEditorVariables.halfNormalFinalPrice =    halfNormalPrice + ((5*(halfNormalPrice))/100) + pacakgingPrice;
                                            MenuEditorVariables.halfNormalFinalPrice = double.parse(MenuEditorVariables.halfNormalFinalPrice.toStringAsFixed(2));
                                          }

                                          if(int.parse(MenuEditorVariables.halfPreorderPriceController.text) > 0){
                                            MenuEditorVariables.halfPreOrderFinalPrice =  halfPreorderPrice + ((5*(halfPreorderPrice))/100) + pacakgingPrice;
                                            MenuEditorVariables.halfPreOrderFinalPrice = double.parse(MenuEditorVariables.halfPreOrderFinalPrice.toStringAsFixed(2));
                                          }


                                        }
                                      });
                                    },),
                                ),
                                CustomTextField(label: "Cuisine", controller: MenuEditorVariables.cuisineController,width: 45*fem,
                                  readOnly: true,
                                  onTap: (){
                                    MenuEditorFunction.showCuisineDialog(context, menuContext,widget.item['_id'],widget.item['disName']);
                                  },
                                  onChanged: (val) {
                                    ItemDetails.enable = true;
                                  },
                                  onChangedDropdown: (val){
                                    MenuEditorVariables.propertyFlag = true;
                                  },
                                ),
                              ],
                            ),

                            SizedBox(height: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                SizedBox(height: 20,),
                                TextField(
                                  maxLines: 2,
                                  controller: descriptionController,
                                  onChanged: (val) {

                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Enter Description for your item',
                                    labelStyle: TextStyle(
                                      fontFamily: 'BertSans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff1d1517),
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),


                              ],
                            ),

                            SizedBox(height: 20,),
                            Visibility(
                              visible: MenuEditorVariables.comboController.text == 'Combo',
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 25),
                                    width: 20,
                                    child: Text("1",style: TextStyle(
                                      fontFamily: 'RenogareSoft',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: GlobalVariables.textColor,
                                    ),),
                                  ),
                                  SizedBox(width: 5*fem,),
                                  CustomTextField(label: "Sections", controller: sectionController,width: 55*fem,isDropdown: true,dropdownItems:sections,
                                    onChanged: (val) {
                                      print("VAlue $val");
                                      setState(() {
                                        items = [];
                                        foodCategories.forEach((key, value) {
                                          value.forEach((element) {
                                            if(key == val)
                                            {
                                              print(element['name']);
                                              items.add(element['name']);
                                            }
                                          });
                                        });
                                      });
                                    },
                                  ),
                                  SizedBox(width: 10*fem,),
                                  CustomTextField(label: 'Search for item',
                                    width: 55*fem,
                                    controller: itemController,
                                    suffixWidget: Icon(Icons.search),
                                    dropdownItems: items,
                                    isDropdown: true,
                                    onChanged: (val) {
                                      setState(() {
                                        comboList.add(Combo(items: val!, section: sectionController.text));
                                        print("The Combo is ${comboList.toString()}");
                                        comboList.forEach((element) {
                                          print(element.items);
                                        });
                                      });
                                    },
                                    showSearchBox1: true,
                                    // dropdownAuto: true,
                                  ),
                                  SizedBox(width: 10,),

                                ],
                              ),
                            ),
                            Visibility(
                              visible: MenuEditorVariables.comboController.text == 'Combo',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int index = 0; index <= comboList.length && index  < 13; index++ )
                                    Column(
                                      children: [
                                        buildCombo(index,items),
                                        SizedBox(height: 0),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20,),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Advanced",style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.textColor,
                            ),),
                            InkWell(
                                onTap: (){
                                  enableAdvance();
                                },
                                child: Icon(advance ?  Icons.arrow_drop_up:Icons.arrow_drop_down ,color: GlobalVariables.primaryColor,size: 30,)),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(height: 1,color: GlobalVariables.primaryColor,),
                      SizedBox(height: 20,),
                      Visibility(
                        visible: advance,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextField(label: "Raw source", controller: MenuEditorVariables.rawSourceController,width: 45*fem,isDropdown: true,dropdownItems: rawSource,
                                  onChangedDropdown: (val){
                                    MenuEditorVariables.propertyFlag = true;
                                    MenuEditorVariables.rawSourceController.text = val!;
                                  },
                                  selectedValue: MenuEditorVariables.rawSourceController.text,
                                ),
                                CustomTextField(label: "Sub category", controller: MenuEditorVariables.subCategoryController,width: 45*fem,showSearchBox1: true,
                                  readOnly: true,
                                  onTap: (){
                                    MenuEditorFunction.showSubCategoriesDialogs(context, menuContext,widget.item['_id'],widget.item['disName'],MenuEditorVariables.categoryController.text);
                                    // menuContext.read<MenuBloc>().add(AddSubcategoryEvent(context, menuContext, MenuEditorVariables.categoryController.text,widget.item['_id'],widget.item['disName']));
                                  },
                                ),
                                CustomTextField(label: "Regional", controller: MenuEditorVariables.regionalController,width: 45*fem,showSearchBox1: true,
                                  readOnly: true,
                                  onTap: (){
                                    // menuContext.read<MenuBloc>().add(AddRegionalEvent(context, menuContext,widget.item['_id'],widget.item['disName']));
                                    MenuEditorFunction.showRegionalDialogs(context, menuContext,widget.item['_id'],widget.item['disName']);
                                  },

                                  // onTap: () {
                                  // print("On TAp is Working");
                                  //   MenuEditorVariables.regional = [];
                                  // },
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                SizedBox(height: 20,),
                                TextField(
                                  maxLines: 3,
                                  controller: cuisineDescriptionController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Description for your cuisine',
                                    border: OutlineInputBorder(),
                                    labelStyle:TextStyle(
                                      fontFamily: 'BertSans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff1d1517),
                                    ),
                                  ),
                                ),


                              ],
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              );
            });
      }
      return CircularProgressIndicator();
    },

    );
  }

  Widget buildCombo(int index,List<String> items)
  {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Row(
      children: [
        Container(width: 20,
          margin: EdgeInsets.only(top: 25),
          child: Text((index+2).toString(),style: TextStyle(
            fontFamily: 'RenogareSoft',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: GlobalVariables.textColor,
          ),),
        ),
        SizedBox(width: 5*fem,),
        CustomTextField(label: "", controller: sectionController,width: 55*fem,isDropdown: true,dropdownItems:sections,
          onChanged: (val) {
            setState(() {

              foodCategories.forEach((key, value) {
                value.forEach((element) {
                  if(key == val)
                  {
                    print(element['name']);
                    items.add(element['name']);
                  }
                });
              });
            });
          },
        ),
        SizedBox(width: 10*fem,),
        CustomTextField( label: '',
          width: 55*fem,
          controller: itemController,
          suffixWidget: Icon(Icons.search),
          dropdownItems: items,
          isDropdown: true,
          onChanged: (val) {
            // comboList.add(Combo(items: val!, section: sectionController.text));
            setState(() {
              print("The Combo is ${comboList.toString()}");
              comboList.forEach((element) {
                print(element.items);
              });
            });
          },
          showSearchBox1: true,
          // dropdownAuto: true,
        ),
        SizedBox(width: 10,),
        InkWell(
          onTap: (){
            setState(() {
              comboList.removeAt(index);
            });
          },
          child: Container(
            margin: EdgeInsets.only(top: 20),
            width: 25.0,
            height: 25.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: Center(
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        ),
        SizedBox(width: 10,),
        Visibility(
          visible: index<12,
          child: InkWell(
            onTap: (){
              setState(() {
                comboList.add(Combo(items: itemController.text, section: sectionController.text));
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 20),
              width: 25.0,
              height: 25.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xfffbb830),
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );

  }
}