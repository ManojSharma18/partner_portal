import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/widgets/custom_textfield.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';

import '../../../constants/menu_editor_constants/menu_editor_variables.dart';
import '../../../constants/utils.dart';
import '../../custom_drop_down_textfeild.dart';

class VariantsAddon extends StatefulWidget {
  const VariantsAddon({super.key});

  @override
  State<VariantsAddon> createState() => _VariantsAddonState();
}

class _VariantsAddonState extends State<VariantsAddon> {

  bool isVariant = true;
  bool isAddon = false;

  int selectedOption = 1;

  void variants(){
    setState(() {
      isVariant = !isVariant;
    });
  }

  void addOn(){
    setState(() {
      isAddon = !isAddon;
    });
  }

  void setHalfSelectedValue(){
    setState(() {
      MenuEditorVariables.halfSelected = !MenuEditorVariables.halfSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return ResponsiveBuilder(
        mobileBuilder: (BuildContext context,BoxConstraints constraints){
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10*fem,right: 3*fem),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Variants",style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.textColor,
                    ),),

                    IconButton(onPressed: (){
                      variants();
                    }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,)),


                  ],
                ),
              ),
              Visibility(
                  visible: isVariant,
                  child: Container(

                    child: Column(
                      children: [
                        Container(
                          child: RadioListTile(
                            title: Text('Half plate',style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.textColor,
                            ),),
                            value: 1,
                            groupValue: selectedOption,
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.only(left: 15*fem,right: 15*fem),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomTextField(
                                        label: "Normal price",
                                        controller: MenuEditorVariables.halfNormalPriceController,
                                        width: 200 * fem,
                                        onlyDigits: true,
                                        onChanged: (val) {

                                        },
                                      ),
                                      Column(
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
                                          Text("\u{20B9} ${MenuEditorVariables.halfNormalFinalPrice}", style: TextStyle(
                                            fontFamily: 'RenogareSoft',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: GlobalVariables.textColor,
                                          ),),
                                          SizedBox(height: 2,),

                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomTextField(label: "Preorder price", controller: MenuEditorVariables.halfPreorderPriceController,width: 200*fem,
                                        onlyDigits: true,
                                        onChanged: (val){
                                          if (val!.isEmpty) {
                                            MenuEditorVariables.halfPreorderPriceController.text = '0';
                                            val = '0';
                                          } else if (val.startsWith('.')) {
                                            MenuEditorVariables.halfPreorderPriceController.text = '0$val';
                                            val = '0$val';
                                          }
                                          setState(() {
                                            double halfPreorderPrice;
                                            double pacakgingPrice;
                                            try {
                                              halfPreorderPrice = double.parse(MenuEditorVariables.halfPreorderPriceController.text);
                                              pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                            } catch (e) {
                                              halfPreorderPrice = 0.0;
                                              pacakgingPrice = 0.0;
                                            }

                                            setState(() {
                                              if(MenuEditorVariables.gstPayment){
                                                MenuEditorVariables.halfPreOrderFinalPrice =  (halfPreorderPrice + pacakgingPrice) + ((5*(halfPreorderPrice  + pacakgingPrice))/100);
                                                MenuEditorVariables.halfPreOrderFinalPrice = double.parse(MenuEditorVariables.halfPreOrderFinalPrice.toStringAsFixed(2));
                                              }else {
                                                MenuEditorVariables.halfPreOrderFinalPrice = (halfPreorderPrice  + pacakgingPrice) + ((halfPreorderPrice  * 5)/100);
                                                MenuEditorVariables.halfPreOrderFinalPrice = double.parse(MenuEditorVariables.halfPreOrderFinalPrice.toStringAsFixed(2));
                                              }
                                            });

                                          });
                                        },),

                                      Column(
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
                                          Text("\u{20B9} ${MenuEditorVariables.halfPreOrderFinalPrice}",
                                            style: TextStyle(
                                              fontFamily: 'RenogareSoft',
                                              fontSize: 15,
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
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [

                                      CustomTextField(label: "Packaging price", controller: MenuEditorVariables.packagindController,width: 150*fem,
                                        onlyDigits: true,
                                        onChanged: (val) {

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
                                          try {
                                            normalPrice = double.parse(MenuEditorVariables.normalPriceController.text);
                                            preOrderPrice = double.parse(MenuEditorVariables.preorderPriceController.text);
                                            pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                          } catch (e) {
                                            normalPrice = 0.0;
                                            preOrderPrice=0.0;
                                            pacakgingPrice=0.0;
                                          }

                                          setState(() {
                                            if(MenuEditorVariables.gstPayment)
                                            {
                                              MenuEditorVariables.normalFinalPrice = (normalPrice+pacakgingPrice) + ((5*(normalPrice+pacakgingPrice))/100);
                                              MenuEditorVariables.preOrderFinalPrice =  (preOrderPrice+pacakgingPrice) + ((5*(preOrderPrice+pacakgingPrice))/100);
                                              MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                                              MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                                            } else {
                                              MenuEditorVariables.normalFinalPrice =    normalPrice + ((5*(normalPrice))/100) + pacakgingPrice;
                                              MenuEditorVariables.preOrderFinalPrice =  preOrderPrice + ((5*(preOrderPrice))/100) + pacakgingPrice;
                                              MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                                              MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                                            }
                                          });

                                        },),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Checkbox(value:MenuEditorVariables.gstPayment, onChanged: (val){
                                        double pacakgingPrice;
                                        try {
                                          pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                                        } catch (e) {
                                          pacakgingPrice=0.0;
                                        }
                                        setState(() {
                                          MenuEditorVariables.gstPayment = val!;
                                          if(MenuEditorVariables.gstPayment)
                                          {

                                            MenuEditorVariables.normalFinalPrice = (int.parse(MenuEditorVariables.normalPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.normalPriceController.text)+pacakgingPrice))/100);
                                            MenuEditorVariables.preOrderFinalPrice = (int.parse(MenuEditorVariables.preorderPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.preorderPriceController.text)+pacakgingPrice))/100);
                                          }
                                          else{
                                            MenuEditorVariables.normalFinalPrice = (int.parse(MenuEditorVariables.normalPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.normalPriceController.text)))/100);
                                            MenuEditorVariables.preOrderFinalPrice = (int.parse(MenuEditorVariables.preorderPriceController.text) +  pacakgingPrice) + ((5*(int.parse(MenuEditorVariables.preorderPriceController.text)))/100) ;
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
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                      ],
                    ),
                  )),
              SizedBox(height: 15,),
              Container( margin: EdgeInsets.only(left: 3*fem,right: 3*fem),height: 1,color: GlobalVariables.primaryColor,),
              SizedBox(height: 15,),
              Container(
                margin: EdgeInsets.only(left: 10*fem,right: 3*fem),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Add on",style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.textColor,
                    ),),

                    IconButton(onPressed: (){
                      addOn();
                    }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,)),


                  ],
                ),
              ),
              SizedBox(height: 15,),
              Visibility(
                  visible: isAddon,
                  child: Column(
                    children: [
                      Center(child: Text("Upcoming feature",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: GlobalVariables.textColor,
                      ),),),
                      SizedBox(height: 15,),
                    ],
                  )),
              SizedBox(height: 15,),
              Container( margin: EdgeInsets.only(left: 3*fem,right: 3*fem),height: 1,color: GlobalVariables.primaryColor,),


            ],
          );
        },
        tabletBuilder: (BuildContext context,BoxConstraints constraints){
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 3*fem,right: 3*fem),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Variants",style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.textColor,
                    ),),

                    IconButton(onPressed: (){
                      variants();
                    }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,)),


                  ],
                ),
              ),
              Visibility(
                  visible: isVariant,
                  child: Column(
                    children: [
                      Center(child: Text("Upcoming feature 😍😎",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: GlobalVariables.textColor,
                      ),),),
                      SizedBox(height: 15,),
                    ],
                  )),
              SizedBox(height: 15,),
              Container( margin: EdgeInsets.only(left: 3*fem,right: 3*fem),height: 1,color: GlobalVariables.primaryColor,),
              SizedBox(height: 15,),
              Container(
                margin: EdgeInsets.only(left: 3*fem,right: 3*fem),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Add on",style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.textColor,
                    ),),

                    IconButton(onPressed: (){
                      addOn();
                    }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,)),


                  ],
                ),
              ),
              SizedBox(height: 15,),
              Visibility(
                  visible: isAddon,
                  child: Column(
                    children: [
                      Center(child: Text("Upcoming feature 😍😎",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: GlobalVariables.textColor,
                      ),),),
                      SizedBox(height: 15,),
                    ],
                  )),
              SizedBox(height: 15,),
              Container( margin: EdgeInsets.only(left: 3*fem,right: 3*fem),height: 1,color: GlobalVariables.primaryColor,),


            ],
          );
        },
        desktopBuilder: (BuildContext context,BoxConstraints constraints){
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 3*fem,right: 3*fem),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Variants",style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.textColor,
                    ),),

                    IconButton(onPressed: (){
                      variants();
                    }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,)),


                  ],
                ),
              ),
              Visibility(
                  visible: isVariant,
                  child: Column(
                    children: [
                      Center(child: Text("Upcoming feature 😍😎",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: GlobalVariables.textColor,
                      ),),),
                      SizedBox(height: 15,),
                    ],
                  )),
              SizedBox(height: 15,),
              Container( margin: EdgeInsets.only(left: 3*fem,right: 3*fem),height: 1,color: GlobalVariables.primaryColor,),
              SizedBox(height: 15,),
              Container(
                margin: EdgeInsets.only(left: 3*fem,right: 3*fem),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Add on",style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.textColor,
                    ),),

                    IconButton(onPressed: (){
                      addOn();
                    }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,)),


                  ],
                ),
              ),
              SizedBox(height: 15,),
              Visibility(
                  visible: isAddon,
                  child: Column(
                    children: [
                      Center(child: Text("Upcoming feature 😍😎",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: GlobalVariables.textColor,
                      ),),),
                      SizedBox(height: 15,),
                    ],
                  )),
              SizedBox(height: 15,),
              Container( margin: EdgeInsets.only(left: 3*fem,right: 3*fem),height: 1,color: GlobalVariables.primaryColor,),


            ],
          );
        });
  }
}
