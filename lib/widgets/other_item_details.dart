import 'package:flutter/material.dart';

import 'custom_textfield.dart';
import '../constants/global_variables.dart';
import '../constants/utils.dart';

class OtherItemDetails extends StatefulWidget {
  const OtherItemDetails({Key? key}) : super(key: key);

  @override
  State<OtherItemDetails> createState() => _OtherItemDetailsState();
}

class _OtherItemDetailsState extends State<OtherItemDetails> {
  TextEditingController regionalController = TextEditingController();
  TextEditingController rawSourceController = TextEditingController();
  TextEditingController cuisineDescriptionController = TextEditingController();
  TextEditingController subTagController = TextEditingController();

  List<String> regional = ["Coastal karnataka","Punjabi"];

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
                  CustomTextField(label: "Sub tag", controller: subTagController,width: 50*fem,),
                  CustomTextField(label: "Regional", controller: regionalController,width: 50*fem,isDropdown: true,dropdownItems: regional,),
                  CustomTextField(label: "Raw source", controller: rawSourceController,width: 50*fem,isDropdown: true,dropdownItems: rawSource,),

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
