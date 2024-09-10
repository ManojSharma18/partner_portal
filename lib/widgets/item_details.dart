import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_state.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_variables.dart';
import 'package:partner_admin_portal/widgets/custom_textfield.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';

import '../constants/utils.dart';

enum OrderType { preorder, normal }


class Combo{
  String section;
  String items;
  Combo({required this.items,required this.section});
}

class ItemDetails extends StatefulWidget {
  final GlobalKey<FormState> checkKey;
  final Map<String, dynamic> item;
  final String resource;
  final Function(String) updateSelectedItem;
  static bool checking = false;
  static bool enable = false;
  const ItemDetails({Key? key, required this.updateSelectedItem, required this.checkKey, required this.resource, required this.item,}) : super(key: key);

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {


  TextEditingController descriptionController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController cuisineController = TextEditingController();


  OrderType _selectedOrderType = OrderType.normal;


  List<String> rawSource = ["ORGANIC","NON ORGANIC"];
  List<String> category = ["VEG","NON VEG",];
  List<String> subCategory = ["Jain","Halal"];

  List<String> type = ["Food","Beverage"];
  List<String> subType = ["Prepare to eat","Ready to Eat"];

  bool gstPayment = true;




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
      basic = !basic;
    });
  }

  List<String> sections = [];
  List<String> items = [];
  @override
  void initState() {
    super.initState();
    gstController.text = '5%';
    sectionController.text = 'South indian breakfast';
    foodCategories.forEach((key, value) {
      sections.add(key);
      value.forEach((element) {
        if(key == sectionController.text)
        {
          print(element['name']);
          items.add(element['name']);
        }
      });
    });
  }

  double finalPrice = 0.0;

  double preOrderFinalPrice = 0.0;
  double normalFinalPrice = 0.0;


  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    // MenuEditorVariables.regionalController.text = widget.item['regional'];
    //MenuEditorVariables.nameController.text = widget.name;

    print("IN Item Details ${MenuEditorVariables.regionalController.text}");

    return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
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
                                    normalFinalPrice =  normalPrice + ((5*normalPrice)/100) + pacakgingPrice;
                                    if(_selectedOrderType ==OrderType.normal)
                                    {
                                      finalPrice = normalFinalPrice;
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
                                  Checkbox(value:gstPayment, onChanged: (val){
                                    double pacakgingPrice;
                                    try {
                                      pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                    } catch (e) {
                                      print('Invalid double: ${MenuEditorVariables.packagindController.text}');
                                      pacakgingPrice=0.0;
                                    }
                                    setState(() {
                                      gstPayment = val!;
                                      print("Val $gstPayment");

                                      if(_selectedOrderType == OrderType.normal)
                                      {
                                        if(gstPayment)
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
                                        if(gstPayment)
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
                                      preOrderFinalPrice =  preorderPrice + ((5*preorderPrice)/100) + pacakgingPrice;
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
                                  Checkbox(value:gstPayment, onChanged: (val){
                                    double pacakgingPrice;
                                    try {
                                      pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                    } catch (e) {
                                      print('Invalid double: ${MenuEditorVariables.packagindController.text}');
                                      pacakgingPrice=0.0;
                                    }
                                    setState(() {
                                      gstPayment = val!;
                                      print("Val $gstPayment");

                                      if(_selectedOrderType == OrderType.normal)
                                      {
                                        if(gstPayment)
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
                                        if(gstPayment)
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

                                CustomTextField(label: "Display name", controller: MenuEditorVariables.displayNameController,width: 150*fem,onChanged: (val) {
                                  setState(() {
                                    setState(() {
                                      ItemDetails.checking = true;
                                      // Update the selected item to immediately reflect changes in the display name
                                      MenuEditorVariables.selectedItem = val!;
                                      widget.item['disName'] = MenuEditorVariables.selectedItem;
                                      print(widget.item['disName']);
                                    });
                                  });
                                  ItemDetails.checking = true;
                                },),
                                CustomTextField(label: "Name", controller: MenuEditorVariables.nameController,width: 70*fem,onChanged: (val) {
                                  ItemDetails.checking = true;
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
                                    ItemDetails.checking = true;
                                  },),
                                CustomTextField(label: "Item type", controller: MenuEditorVariables.typeController,width: 45*fem,isDropdown: true,dropdownItems: type,onChanged: (val) {
                                  ItemDetails.checking = true;
                                },),
                                CustomTextField(label: "Item subtype", controller: MenuEditorVariables.subTypeController,width: 45*fem,isDropdown: true,dropdownItems: subType,
                                  onChanged: (val) {
                                    ItemDetails.checking = true;
                                  },),

                              ],
                            ),

                            SizedBox(height: 25,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextField(label: "Combo type", controller: MenuEditorVariables.comboController,width: 45*fem,isDropdown: true,dropdownItems: ['Single','Combo'],
                                  onChanged: (val){
                                    ItemDetails.checking = false;
                                    setState(() {
                                      MenuEditorVariables.comboController.text = val!;
                                    });
                                  },
                                ),
                                CustomTextField(label: "Raw source", controller: MenuEditorVariables.rawSourceController,width: 45*fem,isDropdown: true,dropdownItems: rawSource,),
                                CustomTextField(label: "Category", controller: MenuEditorVariables.categoryController,width: 45*fem,isDropdown: true,dropdownItems: category,
                                  onChanged: (val) {
                                    ItemDetails.checking = true;
                                  },),
                                CustomTextField(label: "Sub category", controller: MenuEditorVariables.subCategoryController,width: 45*fem,isDropdown: true,dropdownItems: subCategory,
                                  onChanged: (val) {
                                    ItemDetails.checking = true;
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
                                    ItemDetails.checking = true;
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
          return widget.item['disName'] == '' ? Container()
              : Container(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              CustomTextField(label: "Normal price", controller: MenuEditorVariables.normalPriceController,width: 40*fem,
                                onlyDigits: true,
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

                                    if(_selectedOrderType ==OrderType.normal)
                                    {
                                      normalFinalPrice =  (normalPrice + pacakgingPrice) + ((5* (normalPrice + pacakgingPrice))/100);
                                    }
                                  });
                                },),
                              SizedBox(width: 10*fem,),
                              CustomTextField(label: "Packaging price", controller: MenuEditorVariables.packagindController,width: 40*fem,
                                onlyDigits: true,
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
                            ],
                          ),
                          SizedBox(height: 20,),

                          Row(
                            children: [
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
                                    Text("\u{20B9} $normalFinalPrice", style: TextStyle(
                                      fontFamily: 'RenogareSoft',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: GlobalVariables.textColor,
                                    ),),
                                    SizedBox(height: 2,),

                                  ],
                                ),
                              ),
                              SizedBox(width: 10*fem,),
                              Row(
                                children: [
                                  Checkbox(value:gstPayment, onChanged: (val){
                                    double pacakgingPrice;
                                    try {
                                      pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                    } catch (e) {
                                      print('Invalid double: ${MenuEditorVariables.packagindController.text}');
                                      pacakgingPrice=0.0;
                                    }
                                    setState(() {
                                      gstPayment = val!;
                                      print("Val $gstPayment");

                                      if(_selectedOrderType == OrderType.normal)
                                      {
                                        if(gstPayment)
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
                                        if(gstPayment)
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
                                  SizedBox(width: 5,),
                                  Text("Including packing",style:  TextStyle(
                                    fontFamily: 'BertSans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff1d1517),
                                  ),)

                                ],
                              ),
                            ],
                          )
                        ],
                      ),

                      Container(
                        width: 2,
                        height: 130,
                        color: GlobalVariables.primaryColor,
                      ),

                      Column(
                        children: [
                          Row(
                            children: [
                              CustomTextField(label: "Preorder price", controller: MenuEditorVariables.preorderPriceController,width: 40*fem,
                                onlyDigits: true,
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
                                      preOrderFinalPrice =  preorderPrice + ((5*preorderPrice)/100) + pacakgingPrice;
                                      if(_selectedOrderType ==OrderType.preorder)
                                      {
                                        finalPrice = preorderPrice;
                                      }
                                    });
                                  });
                                },),
                              SizedBox(width: 10*fem,),
                              CustomTextField(label: "Packaging price", controller: MenuEditorVariables.packagindController,width: 40*fem,
                                onlyDigits: true,
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
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
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
                              SizedBox(width: 10*fem,),
                              Row(
                                children: [
                                  Checkbox(value:gstPayment, onChanged: (val){
                                    double pacakgingPrice;
                                    try {
                                      pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                    } catch (e) {
                                      print('Invalid double: ${MenuEditorVariables.packagindController.text}');
                                      pacakgingPrice=0.0;
                                    }
                                    setState(() {
                                      gstPayment = val!;
                                      print("Val $gstPayment");

                                      if(_selectedOrderType == OrderType.normal)
                                      {
                                        if(gstPayment)
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
                                        if(gstPayment)
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
                                  SizedBox(width: 5,),
                                  Text("Including packing",style:  TextStyle(
                                    fontFamily: 'BertSans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff1d1517),
                                  ),)

                                ],
                              ),
                            ],
                          )
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

                            CustomTextField(label: "Display name", controller: MenuEditorVariables.displayNameController,width: 150*fem,onChanged: (val) {

                              ItemDetails.checking = true;
                            },

                            displayCount: true,),
                            CustomTextField(label: "Name", controller: MenuEditorVariables.nameController,width: 90*fem,onChanged: (val) {
                              ItemDetails.checking = true;
                            },
                              readOnly: true,

                            ),
                          ],
                        ),
                        SizedBox(height: 25,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            CustomTextField(label: "Price range", controller: MenuEditorVariables.budgetController,width: 45*fem,isDropdown: true,dropdownItems: MenuEditorVariables.budget,

                              onChanged: (val) {
                              print(MenuEditorVariables.budgetController.text);
                                ItemDetails.checking = true;
                              },),
                            CustomTextField(label: "Item type", controller: MenuEditorVariables.typeController,width: 45*fem,isDropdown: true,dropdownItems: type,onChanged: (val) {
                              ItemDetails.checking = true;
                            },),
                            CustomTextField(label: "Item subtype", controller: MenuEditorVariables.subTypeController,width: 45*fem,isDropdown: true,dropdownItems: subType,
                              onChanged: (val) {
                                ItemDetails.checking = true;
                              },),

                            CustomTextField(label: "Combo type", controller: MenuEditorVariables.comboController,width: 45*fem,isDropdown: true,dropdownItems: ['Single','Combo'],
                              onChanged: (val){
                                ItemDetails.checking = false;
                                setState(() {
                                  MenuEditorVariables.comboController.text = val!;
                                });
                              },
                            ),

                          ],
                        ),

                        SizedBox(height: 25,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            CustomTextField(label: "Raw source", controller: MenuEditorVariables.rawSourceController,width: 45*fem,isDropdown: true,dropdownItems: rawSource,),
                            CustomTextField(label: "Category", controller: MenuEditorVariables.categoryController,width: 45*fem,isDropdown: true,dropdownItems: category,
                              isCategory: true,
                              onChanged: (val) {
                                ItemDetails.checking = true;
                              },),
                            CustomTextField(label: "Sub category", controller: MenuEditorVariables.subCategoryController,width: 45*fem,isDropdown: true,dropdownItems: MenuEditorVariables.subCategory,showSearchBox1: true,
                              onChanged: (val) {
                                ItemDetails.checking = true;
                              },),

                            CustomTextField(label: "Regional", controller: MenuEditorVariables.regionalController,width: 45*fem,isDropdown: true,dropdownItems: MenuEditorVariables.regional,showSearchBox1: true,
                              onChanged: (val) {
                                ItemDetails.checking = true;
                              },
                              // onTap: () {
                              // print("On TAp is Working");
                              //   MenuEditorVariables.regional = [];
                              // },
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
                                ItemDetails.checking = true;
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
            desktopBuilder: (BuildContext context,BoxConstraints constraints){
              return widget.item['disName'] == '' ? Container()
                  : Container(
                padding: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  CustomTextField(label: "Normal price", controller: MenuEditorVariables.normalPriceController,width: 40*fem,
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
                                        normalFinalPrice =  normalPrice + ((5*normalPrice)/100) + pacakgingPrice;
                                        if(_selectedOrderType ==OrderType.normal)
                                        {
                                          finalPrice = normalFinalPrice;
                                        }
                                      });
                                    },),
                                  SizedBox(width: 10*fem,),
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
                                ],
                              ),
                              SizedBox(height: 20,),

                              Row(
                                children: [
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
                                  SizedBox(width: 10*fem,),
                                  Row(
                                    children: [
                                      Checkbox(value:gstPayment, onChanged: (val){
                                        double pacakgingPrice;
                                        try {
                                          pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                        } catch (e) {
                                          print('Invalid double: ${MenuEditorVariables.packagindController.text}');
                                          pacakgingPrice=0.0;
                                        }
                                        setState(() {
                                          gstPayment = val!;
                                          print("Val $gstPayment");

                                          if(_selectedOrderType == OrderType.normal)
                                          {
                                            if(gstPayment)
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
                                            if(gstPayment)
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
                                      SizedBox(width: 5,),
                                      Text("Including packing",style:  TextStyle(
                                        fontFamily: 'BertSans',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff1d1517),
                                      ),)

                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),

                          Container(
                            width: 2,
                            height: 130,
                            color: GlobalVariables.primaryColor,
                          ),

                          Column(
                            children: [
                              Row(
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
                                          preOrderFinalPrice =  preorderPrice + ((5*preorderPrice)/100) + pacakgingPrice;
                                          if(_selectedOrderType ==OrderType.preorder)
                                          {
                                            finalPrice = preorderPrice;
                                          }
                                        });
                                      });
                                    },),
                                  SizedBox(width: 10*fem,),
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
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [
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
                                  SizedBox(width: 10*fem,),
                                  Row(
                                    children: [
                                      Checkbox(value:gstPayment, onChanged: (val){
                                        double pacakgingPrice;
                                        try {
                                          pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                        } catch (e) {
                                          print('Invalid double: ${MenuEditorVariables.packagindController.text}');
                                          pacakgingPrice=0.0;
                                        }
                                        setState(() {
                                          gstPayment = val!;
                                          print("Val $gstPayment");

                                          if(_selectedOrderType == OrderType.normal)
                                          {
                                            if(gstPayment)
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
                                            if(gstPayment)
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
                                      SizedBox(width: 5,),
                                      Text("Including packing",style:  TextStyle(
                                        fontFamily: 'BertSans',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff1d1517),
                                      ),)

                                    ],
                                  ),
                                ],
                              )
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

                                CustomTextField(label: "Display name", controller: MenuEditorVariables.displayNameController,width: 100*fem,onChanged: (val) {

                                  ItemDetails.checking = true;
                                },
                                  displayCount: true,),
                                CustomTextField(label: "Name", controller: MenuEditorVariables.nameController,width: 90*fem,onChanged: (val) {
                                  ItemDetails.checking = true;
                                },
                                  readOnly: true,
                                ),
                              ],
                            ),
                            SizedBox(height: 25,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                CustomTextField(label: "Price range", controller: MenuEditorVariables.budgetController,width: 45*fem,isDropdown: true,dropdownItems: MenuEditorVariables.budget,

                                  onChanged: (val) {
                                    print(MenuEditorVariables.budgetController.text);
                                    ItemDetails.checking = true;
                                  },),
                                CustomTextField(label: "Item type", controller: MenuEditorVariables.typeController,width: 45*fem,isDropdown: true,dropdownItems: type,onChanged: (val) {
                                  ItemDetails.checking = true;
                                },),
                                CustomTextField(label: "Item subtype", controller: MenuEditorVariables.subTypeController,width: 45*fem,isDropdown: true,dropdownItems: subType,
                                  onChanged: (val) {
                                    ItemDetails.checking = true;
                                  },),

                                CustomTextField(label: "Combo type", controller: MenuEditorVariables.comboController,width: 45*fem,isDropdown: true,dropdownItems: ['Single','Combo'],
                                  onChanged: (val){
                                    ItemDetails.checking = false;
                                    setState(() {
                                      MenuEditorVariables.comboController.text = val!;
                                    });
                                  },
                                ),

                              ],
                            ),

                            SizedBox(height: 25,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                CustomTextField(label: "Raw source", controller: MenuEditorVariables.rawSourceController,width: 45*fem,isDropdown: true,dropdownItems: rawSource,),
                                CustomTextField(label: "Category", controller: MenuEditorVariables.categoryController,width: 45*fem,isDropdown: true,dropdownItems: category,
                                  isCategory: true,
                                  onChanged: (val) {
                                    ItemDetails.checking = true;
                                  },),
                                CustomTextField(label: "Sub category", controller: MenuEditorVariables.subCategoryController,width: 45*fem,isDropdown: true,dropdownItems: MenuEditorVariables.subCategory,showSearchBox1: true,
                                  onChanged: (val) {
                                    ItemDetails.checking = true;
                                  },),

                                CustomTextField(label: "Regional", controller: MenuEditorVariables.regionalController,width: 45*fem,isDropdown: true,dropdownItems: MenuEditorVariables.regional,showSearchBox1: true,
                                  onChanged: (val) {
                                    ItemDetails.checking = true;
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
                                    ItemDetails.checking = true;
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
