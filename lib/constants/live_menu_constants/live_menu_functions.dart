import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';

import '../../widgets/menu/live_menu/count_table.dart';
import '../../widgets/small_custom_textfield.dart';
import '../global_variables.dart';
import '../utils.dart';

class LiveMenuFunctions {

  static List<Widget> buildItemsList1(BuildContext context,String category, List<Map<String, dynamic>> itemsList) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);
    if (LiveMenuVariables.selectedCategories.isNotEmpty && LiveMenuVariables.selectedCategories.contains(category)) {
      return itemsList.map((item) {
        String itemName = item['name'] as String;
        bool availability = item['availability'] as bool;
        Map<String, dynamic> itemDetails = item;
        return buildDismissibleItem1(context,item['name'], color,item);
      }).toList();
    } else {
      return [
        Center(
          child: Text('Select a category to view items.'),
        ),
      ];
    }
  }

  static Widget buildDismissibleItem1(BuildContext context,String item, Color color,Map<String, dynamic> item1)
  {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
    return Dismissible(
      key: Key(item),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // setState(() {
        //   foodCategories[selectedCategory]!.remove(item);
        // });

      },
      background: InkWell(
        onTap: () {

        },
        child: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: InkWell(
        onTap: (){
          // setState(() {
          //   selectedItem = item;
          // });
        },
        child: Container(
          margin: EdgeInsets.only(left:10,right: 10,bottom:10),
          decoration: BoxDecoration(
            color: LiveMenuVariables.selectedItem == item ? Colors.grey.shade200 : GlobalVariables.whiteColor,
            borderRadius: BorderRadius.circular(10),boxShadow: [
            BoxShadow(
              color: Colors.grey, // You can set the shadow color here
              blurRadius: 5, // Adjust the blur radius as needed
              offset: Offset(0, 2), // Adjust the offset to control the shadow's position
            ),
          ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: LiveMenuVariables.selectedItem==item,
                child: Container(
                  width: 5,
                  height:150,
                  decoration: BoxDecoration(
                      color:  GlobalVariables.textColor,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),topRight: Radius.circular(30))
                  ),
                  margin:EdgeInsets.only(left: 20*fem),

                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      // height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      margin: EdgeInsets.only(left: 0,top: 10),
                      padding: EdgeInsets.only(left: 0),
                      child: ListTile(
                        title: Container(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item,
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 13*fem,
                                  fontWeight: FontWeight.bold,
                                  color: GlobalVariables.textColor,
                                ),
                              ),
                              InkWell(
                                  onTap: (){

                                    // setState(() {
                                    //   selectedItem = item;
                                    // });
                                    // showMealSelectionDialog(item,context);

                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CountTable()));
                                  },
                                  child: Icon(Icons.arrow_forward_ios,color: GlobalVariables.textColor.withOpacity(0.9),size: 20,)
                              )

                            ],
                          ),
                        ),


                        leading: item1['category'] == 'veg' ? Container(
                          margin: EdgeInsets.fromLTRB(0, 0*fem, 2, 1.5),
                          padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration (
                            border: Border.all(color: Color(0xff3d9414)),
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            // rectangle1088pGR (946:2202)
                            child: SizedBox(
                              height: 5,
                              width:5,
                              child: Container(
                                decoration: BoxDecoration (
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(color: Color(0xff3d9414)),
                                  color: Color(0xff3d9414),
                                ),
                              ),
                            ),
                          ),
                        ) :
                        Container(
                          // group32g8y (946:2182)
                          margin: EdgeInsets.fromLTRB(0, 0, 2, 1.5),
                          padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                          width: 15,
                          height:15,
                          decoration: BoxDecoration (
                            border: Border.all(color: Color(0xffd60808)),
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            // rectangle1088ezu (946:2184)
                            child: SizedBox(
                              width: 5,
                              height: 5,
                              child: Container(
                                decoration: BoxDecoration (
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(color: Color(0xffd60808)),
                                  color: Color(0xffd60808),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      margin: EdgeInsets.only(left: 5,right: 10),
                      padding: EdgeInsets.only(left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [


                              Row(
                                children: [
                                  InkWell(
                                    onTap:(){
                                      // setState(() {
                                      //   print("Pressing");
                                      //   selectedItem = item;
                                      // });
                                    },
                                    child: Container(
                                      width:65*fem,
                                      height: 40,
                                      child: SmallCustomTextField(
                                        min:0,max:9999,
                                        textEditingController: LiveMenuVariables.total,height: 30,
                                        onClicked: (){
                                          // setState(() {
                                          //   print("Pressing");
                                          //   selectedItem = item;
                                          // });
                                        },
                                        onChanged: (text){
                                          // setState(() {
                                          //   if(int.parse(total.text) > 9999)
                                          //   {
                                          //     _showExceedLimitAlertDialog(context);
                                          //   }
                                          //   selectedItem = item;
                                          //   int reminder = (int.parse(text!)) % 3;
                                          //   breakfastTotal.text = (int.parse(text)/3).toInt().toString();
                                          //   lunchTotal.text = (int.parse(text)/3).toInt().toString();
                                          //   dinnerTotal.text = ((int.parse(text)/3).toInt()+ reminder).toString();
                                          //   int reminderBreakfast = (int.parse(breakfastTotal.text)) % 4;
                                          //   bfSession1Controller.text = (int.parse(breakfastTotal.text)/4).toInt().toString();
                                          //   bfSession2Controller.text = (int.parse(breakfastTotal.text)/4).toInt().toString();
                                          //   bfSession3Controller.text = (int.parse(breakfastTotal.text)/4).toInt().toString();
                                          //   bfSession4Controller.text = ((int.parse(breakfastTotal.text)/4).toInt()+ reminderBreakfast).toString();
                                          //
                                          //   int reminderLunch = (int.parse(lunchTotal.text)) % 4;
                                          //   lnSession1Controller.text = (int.parse(lunchTotal.text)/4).toInt().toString();
                                          //   lnSession2Controller.text = (int.parse(lunchTotal.text)/4).toInt().toString();
                                          //   lnSession3Controller.text = (int.parse(lunchTotal.text)/4).toInt().toString();
                                          //   lnSession4Controller.text = ((int.parse(lunchTotal.text)/4).toInt()+ reminderLunch).toString();
                                          //
                                          //   int reminderDinner = (int.parse(dinnerTotal.text)) % 4;
                                          //   dnSession1Controller.text = (int.parse(dinnerTotal.text)/4).toInt().toString();
                                          //   dnSession2Controller.text = (int.parse(dinnerTotal.text)/4).toInt().toString();
                                          //   dnSession3Controller.text = (int.parse(dinnerTotal.text)/4).toInt().toString();
                                          //   dnSession4Controller.text = ((int.parse(dinnerTotal.text)/4).toInt()+ reminderDinner).toString();
                                          // });
                                        },
                                      ),
                                    ),
                                  ),
                                  Text("  : ",style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color:GlobalVariables.textColor,
                                  ),),
                                ],
                              ),
                              SizedBox(height:10),
                              Text("Total ",style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color:GlobalVariables.textColor,
                              ),),


                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [


                              Row(
                                children: [
                                  Container(
                                    width:60*fem,
                                    height:35,
                                    child: SmallCustomTextField(
                                      textEditingController: LiveMenuVariables.breakfastTotal,height: 30,fontSize: 11,
                                      min:0,max:9999,
                                      onChanged: (text){
                                        // setState(() {
                                        //   if(int.parse(total.text) > 1000)
                                        //   {
                                        //     _showExceedLimitAlertDialog(context);
                                        //   }
                                        //
                                        //   selectedItem = item;
                                        //   total.text = (int.parse(text!) + int.parse(lunchTotal.text) + int.parse(dinnerTotal.text)).toString();
                                        //   int reminderBreakfast = (int.parse(text!)) % 4;
                                        //   bfSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                        //   bfSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                        //   bfSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                        //   bfSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderBreakfast).toString();
                                        // });
                                      },
                                    ),
                                  ),
                                  Text("  +  ",style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color:GlobalVariables.textColor,
                                  ),),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Text("Breakfast",style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color:GlobalVariables.primaryColor,
                              ),),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Lunch",style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color:GlobalVariables.primaryColor,
                              ),),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Container(
                                    width:55*fem,
                                    height:35,
                                    child: SmallCustomTextField(
                                      textEditingController: LiveMenuVariables.lunchTotal,height: 30,fontSize: 11,
                                      min:0,max:9999,
                                      onChanged: (text){
                                        // setState(() {
                                        //   if(int.parse(total.text) > 1000)
                                        //   {
                                        //     _showExceedLimitAlertDialog(context);
                                        //   }
                                        //   selectedItem = item;
                                        //   total.text = (int.parse(text!) + int.parse(breakfastTotal.text) + int.parse(dinnerTotal.text)).toString();
                                        //   int reminderLunch = (int.parse(text)) % 4;
                                        //   lnSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                        //   lnSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                        //   lnSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                        //   lnSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderLunch).toString();
                                        // });
                                      },
                                    ),
                                  ),
                                  Text("  +  ",style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color:GlobalVariables.textColor,
                                  ),),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Dinner",style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color:GlobalVariables.primaryColor,
                              ),),
                              SizedBox(height: 10,),
                              Container(
                                width:55*fem,
                                height:35,
                                child: SmallCustomTextField(
                                  textEditingController: LiveMenuVariables.dinnerTotal,height: 30,fontSize: 11,
                                  min:0,max:9999,
                                  onChanged: (text){
                                    // setState(() {
                                    //   if(int.parse(total.text) > 1000)
                                    //   {
                                    //     _showExceedLimitAlertDialog(context);
                                    //   }
                                    //   selectedItem = item;
                                    //   total.text = (int.parse(text!) + int.parse(breakfastTotal.text) + int.parse(lunchTotal.text)).toString();
                                    //   int reminderDinner = (int.parse(text)) % 4;
                                    //   dnSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                    //   dnSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                    //   dnSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                    //   dnSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderDinner).toString();
                                    // });
                                  },
                                ),
                              ),

                            ],
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 20,),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}