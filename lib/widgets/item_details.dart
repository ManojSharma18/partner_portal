import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/custom_textfield.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/responsive_builder.dart';

import '../constants/utils.dart';

class ItemDetails extends StatefulWidget {
  final String name;
  final Function(String) updateSelectedItem;
  const ItemDetails({Key? key, required this.name, required this.updateSelectedItem,}) : super(key: key);

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  TextEditingController subTagController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController subTypeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController regionalController = TextEditingController();
  TextEditingController rawSourceController = TextEditingController();
  TextEditingController cuisineController = TextEditingController();
  TextEditingController cuisineDescriptionController = TextEditingController();

  List<String> category = ["Veg","Non veg","Egg"];
  List<String> subCategory = ["Jain","Halal"];
  List<String> budget = ["Budget","Premium","Luxury"];
  List<String> type = ["Food","Beverage"];
  List<String> subType = ["Prepare to eat","Ready to Eat"];
  List<String> regional = ["Coastal karnataka","Punjabi"];
  List<String> rawSource = ["Organic","Non organic"];
  List<String> cuisine = ["South Indian","North Indian","Chines","Japan"];



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




  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    displayNameController.text = widget.name;
    nameController.text = widget.name;
    return ResponsiveBuilder(mobileBuilder: (BuildContext context,BoxConstraints constraints){
      return widget.name == '' ? Container()
          : Container();
    }, tabletBuilder: (BuildContext context,BoxConstraints constraints){
      return widget.name == '' ? Container()
          : Container();
    }, desktopBuilder: (BuildContext context,BoxConstraints constraints){
      return widget.name == '' ? Container()
          : Container(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Basic",style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.textColor,
                    ),),
                    InkWell(
                        onTap: enableBasic,
                        child: Icon(basic ? Icons.arrow_drop_down : Icons.arrow_drop_up,size: 35,color: GlobalVariables.textColor,)),

                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(height: 1,color: GlobalVariables.primaryColor,),
              SizedBox(height: 20,),
              Visibility(
                visible: basic,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextField(label: "Name", controller: nameController,width: 50*fem,),
                        CustomTextField(label: "Display name", controller: displayNameController,width: 50*fem,),
                        CustomTextField(label: "Category", controller: categoryController,width: 50*fem,isDropdown: true,dropdownItems: category,),
                        CustomTextField(label: "Sub category", controller: subCategoryController,width: 50*fem,isDropdown: true,dropdownItems: subCategory,),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextField(label: "Sub tag", controller: subTagController,width: 50*fem,),
                        CustomTextField(label: "Budget range", controller: budgetController,width: 50*fem,isDropdown: true,dropdownItems: budget,),
                        CustomTextField(label: "Item type", controller: typeController,width: 50*fem,isDropdown: true,dropdownItems: type,),
                        CustomTextField(label: "Item subtype", controller: subTypeController,width: 50*fem,isDropdown: true,dropdownItems: subType,),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start,
                      children: [
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text("Description",
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF363563),
                              ),),
                          ],
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          maxLines: 3,
                          controller: descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Enter Description for your item',
                            border: OutlineInputBorder(),
                          ),
                        ),


                      ],
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
                        onTap: enableAdvance,
                        child: Icon( advance ? Icons.arrow_drop_down : Icons.arrow_drop_up,size: 35,color: GlobalVariables.textColor,))
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
                        CustomTextField(label: "Regional", controller: regionalController,width: 50*fem,isDropdown: true,dropdownItems: regional,),
                        CustomTextField(label: "Raw source", controller: rawSourceController,width: 50*fem,isDropdown: true,dropdownItems: rawSource,),
                        CustomTextField(label: "Cuisine", controller: cuisineController,width: 50*fem,isDropdown: true,dropdownItems: cuisine,),
                        CustomTextField(label: "Item subtype", controller: subTypeController,width: 50*fem,),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start,
                      children: [
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text("Cuisine description",
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF363563),
                              ),),
                          ],
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          maxLines: 3,
                          controller: cuisineDescriptionController,
                          decoration: InputDecoration(
                            labelText: 'Enter Description for your cuisine',
                            border: OutlineInputBorder(),
                          ),
                        ),


                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),

            ],
          ),
        ),
      );
    });
  }
}
