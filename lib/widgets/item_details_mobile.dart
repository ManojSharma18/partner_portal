import 'package:flutter/material.dart';

import 'custom_textfield.dart';
import '../constants/global_variables.dart';
import '../constants/utils.dart';
import 'item_details.dart';

class ItemDetailsMob extends StatefulWidget {
  final String name;
  const ItemDetailsMob({Key? key, required this.name}) : super(key: key);

  @override
  State<ItemDetailsMob> createState() => _ItemDetailsMobState();
}

class _ItemDetailsMobState extends State<ItemDetailsMob> {
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  TextEditingController subTagController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController subTypeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController comboController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController normalPriceController = TextEditingController();
  TextEditingController preorderPriceController = TextEditingController();
  TextEditingController packagindController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController cuisineController = TextEditingController();
  TextEditingController rawSourceController = TextEditingController();

  OrderType _selectedOrderType = OrderType.normal;


  List<String> rawSource = ["Organic","Non organic"];
  List<String> category = ["Veg","Non veg","Egg"];
  List<String> subCategory = ["Jain","Halal"];
  List<String> budget = ["Budget","Premium","Luxury"];
  List<String> type = ["Food","Beverage"];
  List<String> subType = ["Prepare to eat","Ready to Eat"];

  bool gstPayment = true;


  List<String> cuisine = ["South Indian","North Indian","Chines","Japan"];


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

  List<String> sections = [];
  List<String> items = [];

  double preOrderFinalPrice = 0.0;
  double normalFinalPrice = 0.0;

  double finalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    ItemDetails.displayNameController.text = widget.name;
    nameController.text = widget.name;
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.only(left: 10*fem,right: 10*fem),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextField(
                        label: "Normal price", controller: normalPriceController,width: 150*fem,
                        onChanged: (val){
                          // ItemDetails.checking = false;
                          // double normaPrice = double.parse(val!);
                          double normalPrice;
                          double pacakgingPrice;
                          try {
                            normalPrice = double.parse(normalPriceController.text);
                          } catch (e) {
                            print('Invalid double: ${normalPriceController.text}');
                            normalPrice = 0.0;
                          }
                          try {
                            pacakgingPrice = double.parse(packagindController.text);
                          } catch (e) {
                            print('Invalid double: ${packagindController.text}');
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
                      CustomTextField(label: "Packaging price", controller: packagindController,width: 150*fem,
                        onChanged: (val){
                          double normalPrice;
                          double preOrderPrice;
                          double pacakgingPrice;
                          try {
                            normalPrice = double.parse(normalPriceController.text);
                            preOrderPrice = double.parse(preorderPriceController.text);
                          } catch (e) {
                            print('Invalid double: ${normalPriceController.text}');
                            normalPrice = 0.0;
                            preOrderPrice=0.0;
                          }
                          try {
                            pacakgingPrice = double.parse(packagindController.text);
                          } catch (e) {
                            print('Invalid double: ${packagindController.text}');
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width:150*fem,
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
                            Text("\u{20B9} $finalPrice",style: TextStyle(
                              fontFamily: 'RenogareSoft',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: GlobalVariables.textColor,
                            ),),
                            SizedBox(height: 2,),
                          ],
                        ),
                      ),

                      SizedBox(width: 50*fem,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(value:gstPayment, onChanged: (val){
                                double pacakgingPrice;
                                try {
                                  pacakgingPrice = double.parse(packagindController.text);
                                } catch (e) {
                                  print('Invalid double: ${packagindController.text}');
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
                                      finalPrice = int.parse(normalPriceController.text) + ((5*(int.parse(normalPriceController.text)+pacakgingPrice))/100) +  pacakgingPrice;
                                    }
                                    else{
                                      // finalPrice =  normalPrice + ((5*(normalPrice+pacakgingPrice))/100) + pacakgingPrice;
                                      finalPrice = int.parse(normalPriceController.text) + ((5*(int.parse(normalPriceController.text)))/100);
                                    }
                                  }
                                  else{
                                    if(gstPayment)
                                    {
                                      // finalPrice = finalPrice + pacakgingPrice;
                                      finalPrice = int.parse(preorderPriceController.text) + ((5*(int.parse(preorderPriceController.text)+pacakgingPrice))/100) +  pacakgingPrice;
                                    }
                                    else{
                                      // finalPrice =  normalPrice + ((5*(normalPrice+pacakgingPrice))/100) + pacakgingPrice;
                                      finalPrice = int.parse(preorderPriceController.text) + ((5*(int.parse(preorderPriceController.text)))/100);
                                    }
                                  }

                                });
                              }),
                              SizedBox(width: 5,),
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



                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(height: 1,color: GlobalVariables.primaryColor,),
            SizedBox(height: 10,),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.only(left: 10*fem,right: 10*fem),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextField(label: "Preorder price", controller: preorderPriceController,width: 150*fem,
                        onChanged: (val){
                          setState(() {
                            double preorderPrice;
                            double pacakgingPrice;
                            try {
                              preorderPrice = double.parse(preorderPriceController.text);
                            } catch (e) {
                              print('Invalid double: ${preorderPriceController.text}');
                              preorderPrice = 0.0;
                            }
                            try {
                              pacakgingPrice = double.parse(packagindController.text);
                            } catch (e) {
                              print('Invalid double: ${packagindController.text}');
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
                      CustomTextField(label: "Packaging price", controller: packagindController,width: 150*fem,
                        onChanged: (val){
                          double normalPrice;
                          double preOrderPrice;
                          double pacakgingPrice;
                          try {
                            normalPrice = double.parse(normalPriceController.text);
                            preOrderPrice = double.parse(preorderPriceController.text);
                          } catch (e) {
                            print('Invalid double: ${normalPriceController.text}');
                            normalPrice = 0.0;
                            preOrderPrice=0.0;
                          }
                          try {
                            pacakgingPrice = double.parse(packagindController.text);
                          } catch (e) {
                            print('Invalid double: ${packagindController.text}');
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width:150*fem,
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
                            Text("\u{20B9} $finalPrice",style: TextStyle(
                              fontFamily: 'RenogareSoft',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: GlobalVariables.textColor,
                            ),),
                            SizedBox(height: 2,),
                          ],
                        ),
                      ),

                      SizedBox(width: 50*fem,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(value:gstPayment, onChanged: (val){
                                double pacakgingPrice;
                                try {
                                  pacakgingPrice = double.parse(packagindController.text);
                                } catch (e) {
                                  print('Invalid double: ${packagindController.text}');
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
                                      finalPrice = int.parse(normalPriceController.text) + ((5*(int.parse(normalPriceController.text)+pacakgingPrice))/100) +  pacakgingPrice;
                                    }
                                    else{
                                      // finalPrice =  normalPrice + ((5*(normalPrice+pacakgingPrice))/100) + pacakgingPrice;
                                      finalPrice = int.parse(normalPriceController.text) + ((5*(int.parse(normalPriceController.text)))/100);
                                    }
                                  }
                                  else{
                                    if(gstPayment)
                                    {
                                      // finalPrice = finalPrice + pacakgingPrice;
                                      finalPrice = int.parse(preorderPriceController.text) + ((5*(int.parse(preorderPriceController.text)+pacakgingPrice))/100) +  pacakgingPrice;
                                    }
                                    else{
                                      // finalPrice =  normalPrice + ((5*(normalPrice+pacakgingPrice))/100) + pacakgingPrice;
                                      finalPrice = int.parse(preorderPriceController.text) + ((5*(int.parse(preorderPriceController.text)))/100);
                                    }
                                  }

                                });
                              }),
                              SizedBox(width: 5,),
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



                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(height: 1,color: GlobalVariables.primaryColor,),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.only(left: 10*fem,right: 10*fem),
              child: Column(
                children: [

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      CustomTextField(label: "Display name", controller: ItemDetails.displayNameController,width: 350*fem,onChanged: (val) {

                      },),
                      SizedBox(height: 20,),
                      CustomTextField(label: "Name", controller: nameController,width: 350*fem,onChanged: (val) {

                      },),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextField(label: "Sub tag", controller: subTagController,width: 350*fem,),
                      SizedBox(height: 20,),
                      CustomTextField(label: "Price range", controller: budgetController,width: 350*fem,isDropdown: true,dropdownItems: budget,
                        onChanged: (val) {
                          ItemDetails.checking = true;
                        },),
                      SizedBox(height: 20,),
                      CustomTextField(label: "Item type", controller: typeController,width: 350*fem,isDropdown: true,dropdownItems: type,onChanged: (val) {
                        ItemDetails.checking = true;
                      },),
                      SizedBox(height: 20,),
                      CustomTextField(label: "Item subtype", controller: subTypeController,width: 350*fem,isDropdown: true,dropdownItems: subType,
                        onChanged: (val) {
                          ItemDetails.checking = true;
                        },),

                    ],
                  ),

                  SizedBox(height: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextField(label: "Combo type", controller: comboController,width: 350*fem,isDropdown: true,dropdownItems: ['Single','Combo'],
                        onChanged: (val){
                          ItemDetails.checking = false;
                          setState(() {
                            comboController.text = val!;
                          });
                        },
                      ),
                      SizedBox(height: 20,),
                      CustomTextField(label: "Raw source", controller: rawSourceController,width: 350*fem,isDropdown: true,dropdownItems: rawSource,),
                      SizedBox(height: 20,),
                      CustomTextField(label: "Category", controller: categoryController,width: 350*fem,isDropdown: true,dropdownItems: category,
                        onChanged: (val) {
                          ItemDetails.checking = true;
                        },),
                      SizedBox(height: 20,),
                      CustomTextField(label: "Sub category", controller: subCategoryController,width: 150*fem,isDropdown: true,dropdownItems: subCategory,
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
                    visible: comboController.text == 'Combo',
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
                    visible: comboController.text == 'Combo',
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

            // SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
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
                InkWell(
                  onTap: (){
                    setState(() {
                      // ItemDetails.checking = false;
                      // if(ItemDetails.displayNameController.text != '')
                      // {
                      //   editFoodName(selectedCategory, selectedItem, ItemDetails.displayNameController.text);
                      // }
                    });
                  },
                  child: Container(
                    width: 130*fem,
                    margin: EdgeInsets.all(20*fem),
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
            )


          ],
        ),
      ),
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

