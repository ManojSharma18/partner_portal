import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_variables.dart';

import 'custom_textfield.dart';
import '../constants/global_variables.dart';
import '../constants/utils.dart';

class OtherItemDetails extends StatefulWidget {
  final Map<String, dynamic> item;
  const OtherItemDetails({Key? key, required this.item}) : super(key: key);

  @override
  State<OtherItemDetails> createState() => _OtherItemDetailsState();
}

class _OtherItemDetailsState extends State<OtherItemDetails> {

  TextEditingController rawSourceController = TextEditingController();
  TextEditingController regionalController = TextEditingController();
  TextEditingController cuisineDescriptionController = TextEditingController();
  TextEditingController subTagController = TextEditingController();



  List<String> rawSource = ["Organic","Non organic"];

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;


    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(height: 1,color: GlobalVariables.primaryColor,),
          SizedBox(height: 20,),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextField(label: "Raw source", controller: MenuEditorVariables.rawSourceController,width: 45*fem,isDropdown: true,dropdownItems: rawSource,
                    selectedValue: MenuEditorVariables.rawSourceController.text,
                  ),
                  CustomTextField(label: "Regional", controller: regionalController,width: 50*fem,isDropdown: true,dropdownItems: MenuEditorVariables.regional,showSearchBox1: true,),
                  CustomTextField(label: "Cuisine", controller: MenuEditorVariables.cuisineController,width: 50*fem,isDropdown: true,dropdownItems: MenuEditorVariables.cuisine,showSearchBox1: true,),

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
          )
        ],
      ),
    );
  }
}
