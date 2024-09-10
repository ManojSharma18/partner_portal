import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_bloc.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_event.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_state.dart';
import 'package:partner_admin_portal/bloc/live_menu_1/live_menu1_event.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_functions.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_variables.dart';
import 'package:partner_admin_portal/models/restaurant_menu.dart';
import 'package:partner_admin_portal/provider/day_provider.dart';

import '../../bloc/live_menu_1/live_menu1_bloc.dart';
import '../../models/live_menu_new_model.dart';
import '../../repository/live_menu_new_service.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/menu/live_menu/count_table.dart';
import '../../widgets/menu/live_menu/live_menu.dart';
import '../../widgets/small_custom_textfield.dart';
import '../global_function.dart';
import '../global_variables.dart';
import '../manage_settings/manage_settings_functions.dart';
import '../manage_settings/manage_settings_variables.dart';
import '../utils.dart';

class LiveMenuFunctions {

  static MealTime selectedMealTime = MealTime.All;

  static Widget buildMealButton(BuildContext context,MealTime mealTime, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedMealTime == mealTime ? GlobalVariables.textColor : selectedMealTime == MealTime.All ? GlobalVariables.textColor : Colors.white;
    return BlocBuilder<LiveMenuBloc,LiveMenuState>(
      builder: (BuildContext context, state) {
        return GestureDetector(
          onTap: () {
            context.read<LiveMenuBloc>().add(MealSelectEvent(mealTime));
            print(selectedMealTime);
            print(LiveMenuFunctions.selectedMealTime);
          },
          child: Container(
            width: 70,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color:GlobalVariables.textColor),
              color: backgroundColor,
            ),
            child: Center(
              child: Text(
                label,
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1.3102272749 * ffem / fem,
                  color: GlobalVariables.primaryColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static List<Widget> buildItemsList1(BuildContext context,String category, List<Map<String, dynamic>> itemsList,Set<String> selectedCategories) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);
    if (selectedCategories.isNotEmpty && selectedCategories.contains(category)) {
      return itemsList.map((item) {
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
    return BlocBuilder<LiveMenuBloc,LiveMenuState>(builder: (BuildContext context, state) {
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
            context.read<LiveMenuBloc>().add(SelectItemEvent(item, state.foodCategories));
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
                    margin:EdgeInsets.only(left: 10*fem),

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
                        margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                        padding: EdgeInsets.only(left: 5*fem),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total ",style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color:GlobalVariables.textColor,
                                ),),
                                SizedBox(height:10),
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
                                          onChanged: (text){

                                              if(LiveMenuVariables.total.text == "")
                                              {
                                                LiveMenuVariables.total.text = "0";
                                                LiveMenuVariables.breakfastTotal.text = "0";
                                                LiveMenuVariables.lunchTotal.text = "0";
                                                LiveMenuVariables.dinnerTotal.text = "0";
                                              }
                                              if(int.parse(LiveMenuVariables.total.text) > 9999)
                                              {
                                                showExceedLimitAlertDialog(context);
                                              }
                                              LiveMenuVariables.selectedItem = item;
                                              int reminder = (int.parse(text!)) % 3;
                                              LiveMenuVariables.breakfastTotal.text = (int.parse(text)/3).toInt().toString();
                                              LiveMenuVariables.lunchTotal.text = (int.parse(text)/3).toInt().toString();
                                              LiveMenuVariables.dinnerTotal.text = ((int.parse(text)/3).toInt()+ reminder).toString();
                                              int reminderBreakfast = (int.parse(LiveMenuVariables.breakfastTotal.text)) % 4;
                                              LiveMenuVariables.bfSession1Controller.text = (int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt().toString();
                                              LiveMenuVariables.bfSession2Controller.text = (int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt().toString();
                                              LiveMenuVariables.bfSession3Controller.text = (int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt().toString();
                                              LiveMenuVariables.bfSession4Controller.text = ((int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt()+ reminderBreakfast).toString();

                                              int reminderLunch = (int.parse(LiveMenuVariables.lunchTotal.text)) % 4;
                                              LiveMenuVariables.lnSession1Controller.text = (int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt().toString();
                                              LiveMenuVariables.lnSession2Controller.text = (int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt().toString();
                                              LiveMenuVariables.lnSession3Controller.text = (int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt().toString();
                                              LiveMenuVariables.lnSession4Controller.text = ((int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt()+ reminderLunch).toString();

                                              int reminderDinner = (int.parse(LiveMenuVariables.dinnerTotal.text)) % 4;
                                              LiveMenuVariables.dnSession1Controller.text = (int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt().toString();
                                              LiveMenuVariables.dnSession2Controller.text = (int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt().toString();
                                              LiveMenuVariables.dnSession3Controller.text = (int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt().toString();
                                              LiveMenuVariables.dnSession4Controller.text = ((int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt()+ reminderDinner).toString();


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

                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text("Breakfast",style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color:GlobalVariables.primaryColor,
                                ),),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Container(
                                      width:65*fem,
                                      height:35,
                                      child: SmallCustomTextField(
                                        textEditingController: LiveMenuVariables.breakfastTotal,height: 30,fontSize: 11,
                                        min:0,max:9999,
                                        onChanged: (text){
                                          if(LiveMenuVariables.lunchTotal.text == "")
                                            {
                                              LiveMenuVariables.lunchTotal.text = "0";
                                            }
                                          if(LiveMenuVariables.dinnerTotal.text == ""){
                                            LiveMenuVariables.dinnerTotal.text = "0";
                                          }
                                            LiveMenuVariables.selectedItem = item;
                                            LiveMenuVariables.total.text = (int.parse(text!) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                            int reminderBreakfast = (int.parse(text!)) % 4;
                                            LiveMenuVariables.bfSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                            LiveMenuVariables.bfSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                            LiveMenuVariables.bfSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                            LiveMenuVariables.bfSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderBreakfast).toString();
                                            if(int.parse(LiveMenuVariables.total.text) > 9999)
                                            {
                                            showExceedLimitAlertDialog(context);
                                            }
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 5*fem,),
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
                                      width:65*fem,
                                      height:35,
                                      child: SmallCustomTextField(
                                        textEditingController: LiveMenuVariables.lunchTotal,height: 30,fontSize: 11,
                                        min:0,max:9999,
                                        onChanged: (text){
                                          if(LiveMenuVariables.breakfastTotal.text == ""){
                                            LiveMenuVariables.breakfastTotal.text = "0";
                                          }
                                          if(LiveMenuVariables.dinnerTotal.text == ""){
                                            LiveMenuVariables.dinnerTotal.text = "0";
                                          }
                                            LiveMenuVariables.selectedItem = item;
                                            LiveMenuVariables.total.text = (int.parse(text!) + int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                            int reminderLunch = (int.parse(text)) % 4;
                                            LiveMenuVariables.lnSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                            LiveMenuVariables.lnSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                            LiveMenuVariables.lnSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                            LiveMenuVariables.lnSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderLunch).toString();
                                            if(int.parse(LiveMenuVariables.total.text) > 9999)
                                            {
                                              showExceedLimitAlertDialog(context);
                                            }
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 5*fem,),
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
                                  width:65*fem,
                                  height:35,
                                  child: SmallCustomTextField(
                                    textEditingController: LiveMenuVariables.dinnerTotal,height: 30,fontSize: 11,
                                    min:0,max:9999,
                                    onChanged: (text){

                                      if(LiveMenuVariables.lunchTotal.text == "")
                                      {
                                        LiveMenuVariables.lunchTotal.text = "0";
                                      }
                                      if(LiveMenuVariables.breakfastTotal.text == ""){
                                        LiveMenuVariables.breakfastTotal.text = "0";
                                      }
                                        LiveMenuVariables.selectedItem = item;
                                        LiveMenuVariables.total.text = (int.parse(text!) + int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text)).toString();
                                        int reminderDinner = (int.parse(text)) % 4;
                                        LiveMenuVariables.dnSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                        LiveMenuVariables.dnSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                        LiveMenuVariables.dnSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                        LiveMenuVariables.dnSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderDinner).toString();
                                      if(int.parse(LiveMenuVariables.total.text) > 1000)
                                      {
                                        showExceedLimitAlertDialog(context);
                                      }

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
    },

    );
  }

  static void showAddItemDialogMob(BuildContext context,String categoryName) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    TextEditingController item = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<LiveMenuBloc,LiveMenuState>(builder: (BuildContext context, state) {
          return  Container(
            child: AlertDialog(
              title: Text('Adding new item'),
              content: Container(
                height: 450,
                child: Column(
                  children: [
                    CustomTextField(label: 'Search for item',
                      width: 300*fem,
                      height: 50,
                      controller: item,
                      dropdownItems: [
                        'Idli','Dose','Palav','Curd rice','Rava idli','Masala Dosa','Poori','Lemon rice','Puliyogare','Maggie',
                        '2 combo','3 combo','4 combo','5 combo','6 combo','7 combo','8 combo','9 combo','10 combo','11 combo',
                        '12 combo', '13 combo', '14 combo'
                      ],
                      isDropdown: true,
                      showSearchBox1: true,
                      dropdownAuto: true,
                    ),

                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the AlertDialog
                  },
                  child: Container(
                    width: 70*fem,
                    height: 35,
                    decoration: BoxDecoration(
                        color:GlobalVariables.whiteColor,
                        border:Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(7),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 11*fem,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // setState(() {
                    //
                    //   Map<String, dynamic> newItem = {'name': item.text, 'availability': true};
                    //   foodCategories[selectedCategory]!.add(newItem);
                    // });
                    context.read<LiveMenuBloc>().add(AddItemEvent(categoryName, true, item.text,state.foodCategories));
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 70*fem,
                    height: 35,
                    decoration: BoxDecoration(
                        color: GlobalVariables.primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(7),
                    child: Center(
                      child: Text(
                        'Add',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 11*fem,
                          fontWeight: FontWeight.bold,
                          color: GlobalVariables.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },

        );
      },
    );
  }

  static void showExceedLimitAlertDialog(BuildContext context) {
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

  static void initialValue(){
      LiveMenuVariables.total.text = '0';
      LiveMenuVariables.breakfastTotal.text = '0';
      LiveMenuVariables.lunchTotal.text = '0';
      LiveMenuVariables.dinnerTotal.text = '0';

      LiveMenuVariables.bfSession1Controller.text = '0';
      LiveMenuVariables.bfSession2Controller.text = '0';
      LiveMenuVariables.bfSession3Controller.text = '0';
      LiveMenuVariables.bfSession4Controller.text = '0';

      LiveMenuVariables.lnSession1Controller.text = '0';
      LiveMenuVariables.lnSession2Controller.text = '0';
      LiveMenuVariables.lnSession3Controller.text = '0';
      LiveMenuVariables.lnSession4Controller.text = '0';

      LiveMenuVariables.dnSession1Controller.text = '0';
      LiveMenuVariables.dnSession2Controller.text = '0';
      LiveMenuVariables.dnSession3Controller.text = '0';
      LiveMenuVariables.dnSession4Controller.text = '0';

  }

  static void cleanUpEmptyCategories(Map<String, List<Map<String, dynamic>>> categories,) {
    // Iterate over the map and collect keys with empty lists
    List<String> keysToRemove = [];
    categories.forEach((key, value) {
      if (value.isEmpty) {
        keysToRemove.add(key);
      }
    });

    // Remove the keys with empty lists
    for (String key in keysToRemove) {
      categories.remove(key);
    }
  }

  static void updateItem(BuildContext liveMenuContext,final Map<String, List<Map<String,dynamic>>> foodCategories, final String tagName,final Map<String, dynamic> item) {
    Map<String,dynamic> data = {
      "ritem_UId": item['ritem_UId'],
      "date": item['date'],
      "updateData" : {
        "meals_session_count": {
          "breakfast": {
            "Enabled": LiveMenuVariables.breakfastEnabled,
            "session1": {
              "Enabled": LiveMenuVariables.bfSession1Enabled,
              "availableCount": parseCount(LiveMenuVariables.bfSession1Controller),
            },
            "session2": {
              "Enabled": LiveMenuVariables.bfSession2Enabled,
              "availableCount": parseCount(LiveMenuVariables.bfSession2Controller),
            },
            "session3": {
              "Enabled": LiveMenuVariables.bfSession3Enabled,
              "availableCount": parseCount(LiveMenuVariables.bfSession3Controller),
            }
          },
          "lunch": {
            "Enabled": LiveMenuVariables.lunchEnabled,
            "session1": {
              "Enabled": LiveMenuVariables.lnSession1Enabled,
              "availableCount": parseCount(LiveMenuVariables.lnSession1Controller),
            },
            "session2": {
              "Enabled": LiveMenuVariables.lnSession2Enabled,
              "availableCount":parseCount(LiveMenuVariables.lnSession2Controller),
            },
            "session3": {
              "Enabled": LiveMenuVariables.lnSession3Enabled,
              "availableCount": parseCount(LiveMenuVariables.lnSession3Controller),
            }
          },
          "dinner": {
            "Enabled": LiveMenuVariables.dinnerEnabled,
            "session1": {
              "Enabled": LiveMenuVariables.dnSession1Enabled,
              "availableCount": parseCount(LiveMenuVariables.dnSession1Controller),
            },
            "session2": {
              "Enabled": LiveMenuVariables.dnSession2Enabled,
              "availableCount":  parseCount(LiveMenuVariables.dnSession2Controller),
            },
            "session3": {
              "Enabled": LiveMenuVariables.dnSession3Enabled,
              "availableCount":  parseCount(LiveMenuVariables.dnSession3Controller),
            }
          }
        }
      }

    };

    liveMenuContext.read<LiveMenu1Bloc>().add(UpdateItemEvent(data, foodCategories, tagName, item));
  }

  static void updateItemLunch(BuildContext liveMenuContext,final Map<String, List<Map<String,dynamic>>> foodCategories, final String tagName,final Map<String, dynamic> item) {
    print("ITem is $item");
    Map<String,dynamic> data = {
      "ritem_UId": item['ritem_UId'],
      "date": item['date'],
      "updateData" : {
        "meals_session_count": {
          "breakfast": {
            "Enabled": LiveMenuVariables.breakfastEnabled,
            "session1": {
              "Enabled": LiveMenuVariables.bfSession1Enabled,
              "availableCount": parseCount(LiveMenuVariables.bfSession1Controller),
            },
            "session2": {
              "Enabled": LiveMenuVariables.bfSession2Enabled,
              "availableCount": parseCount(LiveMenuVariables.bfSession2Controller),
            },
            "session3": {
              "Enabled": LiveMenuVariables.bfSession3Enabled,
              "availableCount": parseCount(LiveMenuVariables.bfSession3Controller),
            }
          },
          "lunch": {
            "Enabled": LiveMenuVariables.lunchEnabled,
            "session1": {
              "Enabled": LiveMenuVariables.lnSession1Enabled,
              "availableCount": parseCount(LiveMenuVariables.lnSession1Controller),
            },
            "session2": {
              "Enabled": LiveMenuVariables.lnSession2Enabled,
              "availableCount":parseCount(LiveMenuVariables.lnSession2Controller),
            },
            "session3": {
              "Enabled": LiveMenuVariables.lnSession3Enabled,
              "availableCount": parseCount(LiveMenuVariables.lnSession3Controller),
            }
          },
          "dinner": {
            "Enabled": LiveMenuVariables.dinnerEnabled,
            "session1": {
              "Enabled": LiveMenuVariables.dnSession1Enabled,
              "availableCount": parseCount(LiveMenuVariables.dnSession1Controller),
            },
            "session2": {
              "Enabled": LiveMenuVariables.dnSession2Enabled,
              "availableCount":  parseCount(LiveMenuVariables.dnSession2Controller),
            },
            "session3": {
              "Enabled": LiveMenuVariables.dnSession3Enabled,
              "availableCount":  parseCount(LiveMenuVariables.dnSession3Controller),
            }
          }
        }
      }

    };

    liveMenuContext.read<LiveMenu1Bloc>().add(UpdateItemEvent(data, foodCategories, tagName, item));
  }

  static int parseCount(TextEditingController controller) {
    try {
      return int.parse(controller.text.isNotEmpty ? controller.text : '0');
    } catch (e) {
      print("Error parsing integer: ${controller.text}");
      return 0;
    }
  }


  static void addItemInLiveMenu(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    LiveMenuVariables.onSelectionItems = [];
    LiveMenuVariables.foodCategories.values.forEach((items) {
      items.forEach((item) {
        if(item['availability'] )
          {
            LiveMenuVariables.onSelectionItems.add(item['disName']);
          }
      });
    });
    showDialog(
      context: context,
      builder: (contexts) {
        return Container(
          child: AlertDialog(
            title: Text('Adding new item'),
            content: Container(
              height: 400,
              width: 400,
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Search for item',
                    width: 400,
                    height: 50,
                    controller: textEditingController,
                    searchItem: true,
                    readOnly: true,
                    dropdownItems: LiveMenuVariables.onSelectionItems,
                    isDropdown: true,
                    showSearchBox1: true,
                    dropdownAuto: true,
                    digitsAndLetters: true,
                    displayCount: true,
                    showAddItemDropDownSearch : false,
                    onChangedDropdown: (val){

                    },
                  ),

                ],
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color:GlobalVariables.whiteColor,
                      border:Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(7),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: SafeGoogleFont(
                        'Poppins',
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

                  Navigator.pop(context);

                  Map<String,dynamic> newItem = {};

                  Map<String,dynamic> liveMenuSample = {};

                  LiveMenuVariables.foodCategories.values.forEach((items) {
                    items.forEach((item) {
                      if(item['disName'] == textEditingController.text)
                      {
                        newItem = item;
                      }
                    });
                  });


                  bool itemExist = false;
                  LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast.values.forEach((items) {
                    items.forEach((item) {
                      if(item['disName'] == textEditingController.text && item['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3)) {
                        itemExist = true;
                        print("It is also here as well");
                        return;
                      }
                    });
                  });


                  if(itemExist)
                    {
                      MenuEditorFunction.showPriceShouldNotBeNull(context, "Item already lived");
                    }
                  else {
                    LiveMenuVariables.liveMenuNewfoodCategoriesLunch.values.forEach((items) {
                      items.forEach((item) {
                        if(item['disName'] == textEditingController.text && item['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3)){
                          itemExist = true;
                          liveMenuSample = item;
                          return;
                        }
                      });
                    });

                    if(itemExist) {

                      LiveMenuFunctions.showItemAlreadyExist(context,'Lunch',liveMenuSample);

                    }
                    else{
                      LiveMenuVariables.liveMenuNewfoodCategoriesDinner.values.forEach((items) {
                        items.forEach((item) {
                          if(item['disName'] == textEditingController.text && item['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3)){
                            itemExist = true;
                            liveMenuSample = item;
                            return;
                          }
                        });
                      });
                      if(itemExist) {

                        LiveMenuFunctions.showItemAlreadyExist(context,'Dinner',liveMenuSample);

                      }
                      else {
                        List<LiveMenuNew> liveMenuDataList = [];

                        String selectedDate = GlobalVariables.selectedDay.substring(0,3);

                        Map<String, dynamic>? dateAndDay = MenuEditorFunction.getDayAndDate(selectedDate);

                        print("Date and day is $dateAndDay");

                        TimeOfDay s1EndTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']!['Session1']!['EndTime']);
                        TimeOfDay s2EndTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']!['Session2']!['EndTime']);
                        TimeOfDay s2StartTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']!['Session2']!['StartTime']);
                        TimeOfDay s3StartTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']!['Session3']!['StartTime']);

                        int overlapAllSession = ManageSettingFunction.compareTimeOfDay(s1EndTime, s3StartTime);
                        int overlapSession1AndSession2 = ManageSettingFunction.compareTimeOfDay(s1EndTime, s2StartTime);
                        int overlapSession2AndSession3 = ManageSettingFunction.compareTimeOfDay(s2EndTime, s3StartTime);
                        int overlapSession1AndSession3 = ManageSettingFunction.compareTimeOfDay(s1EndTime, s3StartTime);


                        if(overlapAllSession > 0 && overlapSession2AndSession3 > 0 ) {
                          selectSessions(context,"All 3 sessions timings are overlapped. Select the preferred session for the item",['S1','S2','S3'],[],liveMenuDataList,newItem,dateAndDay!);
                        }
                        else if(overlapSession1AndSession2 > 0) {
                          selectSessions(context,"Session 1 timings over lapped with session 2 timings. Select the preferred session for the item",['S1','S2',],['S3'],liveMenuDataList,newItem,dateAndDay!);
                        }
                        else if(overlapSession2AndSession3 > 0) {
                          selectSessions(context,"Session 2 timings over lapped with session 3 timings. Select the preferred session for the item",['S2','S3',],['S1'],liveMenuDataList,newItem,dateAndDay!);
                        }
                        else if(overlapSession1AndSession3 > 0) {
                          selectSessions(context,"Session 3 timings over lapped with session 1 timings. Select the preferred session for the item",['S1','S3',],['S2'],liveMenuDataList,newItem,dateAndDay!);
                        }


                      }
                    }
                  }

                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: GlobalVariables.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(7),
                  child: Center(
                    child: Text(
                      'Add',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: GlobalVariables.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void addItemInLiveMenuLunch(BuildContext context){
    TextEditingController textEditingController = TextEditingController();

    LiveMenuVariables.onSelectionItems = [];
    LiveMenuVariables.foodCategories.values.forEach((items) {
      items.forEach((item) {
        if(item['availability'] )
        {
          LiveMenuVariables.onSelectionItems.add(item['disName']);
        }
      });
    });
    showDialog(
      context: context,
      builder: (contexts) {
        return Container(
          child: AlertDialog(
            title: Text('Adding new item'),
            content: Container(
              height: 400,
              width: 400,
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Search for item',
                    width: 400,
                    height: 50,
                    controller: textEditingController,
                    searchItem: true,
                    readOnly: true,
                    dropdownItems: LiveMenuVariables.onSelectionItems,
                    isDropdown: true,
                    showSearchBox1: true,
                    dropdownAuto: true,
                    digitsAndLetters: true,
                    displayCount: true,
                    showAddItemDropDownSearch : false,
                    onChangedDropdown: (val){

                    },
                  ),

                ],
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color:GlobalVariables.whiteColor,
                      border:Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(7),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: SafeGoogleFont(
                        'Poppins',
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

                  Navigator.pop(context);

                  Map<String,dynamic> newItem = {};

                  Map<String,dynamic> liveMenuSample = {};

                  LiveMenuVariables.foodCategories.values.forEach((items) {
                    items.forEach((item) {
                      if(item['disName'] == textEditingController.text)
                      {
                        newItem = item;
                      }
                    });
                  });


                  bool itemExist = false;
                  LiveMenuVariables.liveMenuNewfoodCategoriesLunch.values.forEach((items) {
                    items.forEach((item) {
                      if(item['disName'] == textEditingController.text && item['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3)) {
                        itemExist = true;
                        print("It is also here as well");
                        return;
                      }
                    });
                  });

                  print("Still coming here as well");

                  if(itemExist)
                  {
                    MenuEditorFunction.showPriceShouldNotBeNull(context, "Item already lived");
                  } else {
                    LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast.values.forEach((items) {
                      items.forEach((item) {
                        if(item['disName'] == textEditingController.text && item['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3)){
                          itemExist = true;
                          liveMenuSample = item;
                          return;
                        }
                      });
                    });

                    if(itemExist) {

                      LiveMenuFunctions.showItemAlreadyExistLunch(context,'Breakfast',liveMenuSample);

                    }
                    else{
                      LiveMenuVariables.liveMenuNewfoodCategoriesDinner.values.forEach((items) {
                        items.forEach((item) {
                          if(item['disName'] == textEditingController.text && item['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3)){
                            itemExist = true;
                            liveMenuSample = item;
                            return;
                          }
                        });
                      });
                      if(itemExist) {

                        LiveMenuFunctions.showItemAlreadyExistLunch(context,'Dinner',liveMenuSample);

                      }
                      else {
                        List<LiveMenuNew> liveMenuDataList = [];

                        String selectedDate = GlobalVariables.selectedDay.substring(0,3);

                        Map<String, dynamic>? dateAndDay = MenuEditorFunction.getDayAndDate(selectedDate);

                        print("Date and day is $dateAndDay");

                        TimeOfDay s1EndTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Lunch']!['Session1']!['EndTime']);
                        TimeOfDay s2EndTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Lunch']!['Session2']!['EndTime']);
                        TimeOfDay s2StartTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Lunch']!['Session2']!['StartTime']);
                        TimeOfDay s3StartTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Lunch']!['Session3']!['StartTime']);

                        int overlapAllSession = ManageSettingFunction.compareTimeOfDay(s1EndTime, s3StartTime);
                        int overlapSession1AndSession2 = ManageSettingFunction.compareTimeOfDay(s1EndTime, s2StartTime);
                        int overlapSession2AndSession3 = ManageSettingFunction.compareTimeOfDay(s2EndTime, s3StartTime);
                        int overlapSession1AndSession3 = ManageSettingFunction.compareTimeOfDay(s1EndTime, s3StartTime);


                        if(overlapAllSession > 0 && overlapSession2AndSession3 > 0 ) {
                          selectSessionsLunch(context,"All 3 sessions timings are overlapped. Select the preferred session for the item",['S1','S2','S3'],[],liveMenuDataList,newItem,dateAndDay!);
                        }
                        else if(overlapSession1AndSession2 > 0) {
                          selectSessionsLunch(context,"Session 1 timings over lapped with session 2 timings. Select the preferred session for the item",['S1','S2',],['S3'],liveMenuDataList,newItem,dateAndDay!);
                        }
                        else if(overlapSession2AndSession3 > 0) {
                          selectSessionsLunch(context,"Session 2 timings over lapped with session 3 timings. Select the preferred session for the item",['S2','S3',],['S1'],liveMenuDataList,newItem,dateAndDay!);
                        }
                        else if(overlapSession1AndSession3 > 0) {
                          selectSessionsLunch(context,"Session 3 timings over lapped with session 1 timings. Select the preferred session for the item",['S1','S3',],['S2'],liveMenuDataList,newItem,dateAndDay!);
                        }
                      }
                    }
                  }

                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: GlobalVariables.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(7),
                  child: Center(
                    child: Text(
                      'Add',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: GlobalVariables.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void addItemInLiveMenuDinner(BuildContext context){
    TextEditingController textEditingController = TextEditingController();

    LiveMenuVariables.onSelectionItems = [];
    LiveMenuVariables.foodCategories.values.forEach((items) {
      items.forEach((item) {
        if(item['availability'] )
        {
          LiveMenuVariables.onSelectionItems.add(item['disName']);
        }
      });
    });
    showDialog(
      context: context,
      builder: (contexts) {
        return Container(
          child: AlertDialog(
            title: Text('Adding new item'),
            content: Container(
              height: 400,
              width: 400,
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Search for item',
                    width: 400,
                    height: 50,
                    controller: textEditingController,
                    searchItem: true,
                    readOnly: true,
                    dropdownItems: LiveMenuVariables.onSelectionItems,
                    isDropdown: true,
                    showSearchBox1: true,
                    dropdownAuto: true,
                    digitsAndLetters: true,
                    displayCount: true,
                    showAddItemDropDownSearch : false,
                    onChangedDropdown: (val){

                    },
                  ),

                ],
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color:GlobalVariables.whiteColor,
                      border:Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(7),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: SafeGoogleFont(
                        'Poppins',
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

                  Navigator.pop(context);

                  Map<String,dynamic> newItem = {};

                  Map<String,dynamic> liveMenuSample = {};

                  LiveMenuVariables.foodCategories.values.forEach((items) {
                    items.forEach((item) {
                      if(item['disName'] == textEditingController.text)
                      {
                        newItem = item;
                      }
                    });
                  });


                  bool itemExist = false;
                  LiveMenuVariables.liveMenuNewfoodCategoriesDinner.values.forEach((items) {
                    items.forEach((item) {
                      if(item['disName'] == textEditingController.text && item['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3)) {
                        itemExist = true;
                        print("It is also here as well");
                        return;
                      }
                    });
                  });

                  print("Still coming here as well");

                  if(itemExist)
                  {
                    MenuEditorFunction.showPriceShouldNotBeNull(context, "Item already lived");
                  } else {
                    LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast.values.forEach((items) {
                      items.forEach((item) {
                        if(item['disName'] == textEditingController.text && item['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3)){
                          itemExist = true;
                          liveMenuSample = item;
                          return;
                        }
                      });
                    });

                    if(itemExist) {

                      LiveMenuFunctions.showItemAlreadyExistDinner(context,'Breakfast',liveMenuSample);

                    }
                    else{
                      LiveMenuVariables.liveMenuNewfoodCategoriesLunch.values.forEach((items) {
                        items.forEach((item) {
                          if(item['disName'] == textEditingController.text && item['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3)){
                            itemExist = true;
                            liveMenuSample = item;
                            return;
                          }
                        });
                      });
                      if(itemExist) {

                        LiveMenuFunctions.showItemAlreadyExistDinner(context,'Lunch',liveMenuSample);

                      }
                      else {
                        List<LiveMenuNew> liveMenuDataList = [];

                        String selectedDate = GlobalVariables.selectedDay.substring(0,3);

                        Map<String, dynamic>? dateAndDay = MenuEditorFunction.getDayAndDate(selectedDate);

                        print("Date and day is $dateAndDay");

                        TimeOfDay s1EndTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Dinner']!['Session1']!['EndTime']);
                        TimeOfDay s2EndTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Dinner']!['Session2']!['EndTime']);
                        TimeOfDay s2StartTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Dinner']!['Session2']!['StartTime']);
                        TimeOfDay s3StartTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Dinner']!['Session3']!['StartTime']);

                        int overlapAllSession = ManageSettingFunction.compareTimeOfDay(s1EndTime, s3StartTime);
                        int overlapSession1AndSession2 = ManageSettingFunction.compareTimeOfDay(s1EndTime, s2StartTime);
                        int overlapSession2AndSession3 = ManageSettingFunction.compareTimeOfDay(s2EndTime, s3StartTime);
                        int overlapSession1AndSession3 = ManageSettingFunction.compareTimeOfDay(s1EndTime, s3StartTime);


                        if(overlapAllSession > 0 && overlapSession2AndSession3 > 0 ) {
                          selectSessionsDinner(context,"All 3 sessions timings are overlapped. Select the preferred session for the item",['S1','S2','S3'],[],liveMenuDataList,newItem,dateAndDay!);
                        }
                        else if(overlapSession1AndSession2 > 0) {
                          selectSessionsDinner(context,"Session 1 timings over lapped with session 2 timings. Select the preferred session for the item",['S1','S2',],['S3'],liveMenuDataList,newItem,dateAndDay!);
                        }
                        else if(overlapSession2AndSession3 > 0) {
                          selectSessionsDinner(context,"Session 2 timings over lapped with session 3 timings. Select the preferred session for the item",['S2','S3',],['S1'],liveMenuDataList,newItem,dateAndDay!);
                        }
                        else if(overlapSession1AndSession3 > 0) {
                          selectSessionsDinner(context,"Session 3 timings over lapped with session 1 timings. Select the preferred session for the item",['S1','S3',],['S2'],liveMenuDataList,newItem,dateAndDay!);
                        }
                      }
                    }
                  }

                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: GlobalVariables.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(7),
                  child: Center(
                    child: Text(
                      'Add',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: GlobalVariables.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void selectSessions(BuildContext contexts,String message,List<String> sessions,List<String> fixedSession,List<LiveMenuNew> liveMenuDataList,Map<String,dynamic> newItem,Map<String, dynamic> dateAndDay) {
    String _selectedSession = sessions[0];
    showDialog(context: contexts, builder: (context) {
      return Container(
        height: 300,
        child: AlertDialog(
          title: Text("Select sessions",style: GlobalVariables.dataItemStyle,),
          content: Container(
            height: 300,
            child: Column(
              children: [
                Container(
                    width: 300,
                    margin: EdgeInsets.all(15),
                    child: Expanded(
                        child: Text("${message}",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: GlobalVariables.textColor,
                        ),))),
                StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setState) {
                    return Column(
                      children: sessions.map((session) {
                        return RadioListTile<String>(
                          title: Text(session),
                          value: session,
                          groupValue: _selectedSession,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedSession = value!;
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                )
              ],
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // Close the AlertDialog
              },
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.whiteColor,
                    border: Border.all(color: GlobalVariables.textColor),
                    borderRadius: BorderRadius.circular(3)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'CANCEL',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: GlobalVariables.textColor,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {

                fixedSession.add(_selectedSession);

                liveMenuDataList.add(
                  LiveMenuNew(
                    ritemUId:  newItem['uId'],
                    ritemDispname: newItem['disName'],
                    ritemAvailability: true,
                    ritemCategory: newItem['category'],
                    ritemTag: newItem['tag'],
                    ritemAvailableType: 0,
                    day: dateAndDay!['day'],
                    date: dateAndDay['date'],
                    mealsSessionCount: MealSessionCount(
                      breakfast: Meal(
                          enabled: true,
                          session1: Session(enabled: true, availableCount: fixedSession.contains('S1') ? 10 : 0),
                          session2: Session(enabled: true, availableCount: fixedSession.contains('S2') ? 10 : 0),
                          session3: Session(enabled: true, availableCount: fixedSession.contains('S3') ? 10 : 0),),
                      lunch: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: 0),
                        session2: Session(enabled: true, availableCount: 0),
                        session3: Session(enabled: true, availableCount: 0),
                      ),
                      dinner: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: 0),
                        session2: Session(enabled: true, availableCount: 0),
                        session3: Session(enabled: true, availableCount: 0),
                      ),
                    ),
                  ),
                );

                Navigator.pop(context);

                contexts.read<LiveMenu1Bloc>().add(AddLiveMenuItemFromLiveMenuEvent(liveMenuDataList));

              },
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.primaryColor,
                    border: Border.all(color: GlobalVariables.primaryColor),
                    borderRadius: BorderRadius.circular(3)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'NEXT',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: GlobalVariables.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

    });

  }

  static void selectSessionsLunch(BuildContext contexts,String message,List<String> sessions,List<String> fixedSession,List<LiveMenuNew> liveMenuDataList,Map<String,dynamic> newItem,Map<String, dynamic> dateAndDay) {
    String _selectedSession = sessions[0];
    showDialog(context: contexts, builder: (context) {
      return Container(
        height: 300,
        child: AlertDialog(
          title: Text("Select sessions",style: GlobalVariables.dataItemStyle,),
          content: Container(
            height: 300,
            child: Column(
              children: [
                Container(
                    width: 300,
                    margin: EdgeInsets.all(15),
                    child: Expanded(
                        child: Text("${message}",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: GlobalVariables.textColor,
                        ),))),
                StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setState) {
                    return Column(
                      children: sessions.map((session) {
                        return RadioListTile<String>(
                          title: Text(session),
                          value: session,
                          groupValue: _selectedSession,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedSession = value!;
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                )
              ],
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // Close the AlertDialog
              },
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.whiteColor,
                    border: Border.all(color: GlobalVariables.textColor),
                    borderRadius: BorderRadius.circular(3)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'CANCEL',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: GlobalVariables.textColor,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {

                fixedSession.add(_selectedSession);

                liveMenuDataList.add(
                  LiveMenuNew(
                    ritemUId:  newItem['uId'],
                    ritemDispname: newItem['disName'],
                    ritemAvailability: true,
                    ritemCategory: newItem['category'],
                    ritemTag: newItem['tag'],
                    ritemAvailableType: 0,
                    day: dateAndDay['day'],
                    date: dateAndDay['date'],
                    mealsSessionCount: MealSessionCount(
                      breakfast: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: 0),
                        session2: Session(enabled: true, availableCount: 0),
                        session3: Session(enabled: true, availableCount: 0),
                      ),
                      lunch: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: fixedSession.contains('S1') ? 10 : 0),
                        session2: Session(enabled: true, availableCount: fixedSession.contains('S2') ? 10 : 0),
                        session3: Session(enabled: true, availableCount: fixedSession.contains('S3') ? 10 : 0),
                      ),
                      dinner: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: 0),
                        session2: Session(enabled: true, availableCount: 0),
                        session3: Session(enabled: true, availableCount: 0),
                      ),
                    ),
                  ),
                );

                Navigator.pop(context);

                contexts.read<LiveMenu1Bloc>().add(AddLiveMenuItemFromLiveMenuEvent(liveMenuDataList));

              },
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.primaryColor,
                    border: Border.all(color: GlobalVariables.primaryColor),
                    borderRadius: BorderRadius.circular(3)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'NEXT',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: GlobalVariables.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

    });

  }

  static void selectSessionsDinner(BuildContext contexts,String message,List<String> sessions,List<String> fixedSession,List<LiveMenuNew> liveMenuDataList,Map<String,dynamic> newItem,Map<String, dynamic> dateAndDay) {
    String _selectedSession = sessions[0];
    showDialog(context: contexts, builder: (context) {
      return Container(
        height: 300,
        child: AlertDialog(
          title: Text("Select sessions",style: GlobalVariables.dataItemStyle,),
          content: Container(
            height: 300,
            child: Column(
              children: [
                Container(
                    width: 300,
                    margin: EdgeInsets.all(15),
                    child: Expanded(
                        child: Text("${message}",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: GlobalVariables.textColor,
                        ),))),
                StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setState) {
                    return Column(
                      children: sessions.map((session) {
                        return RadioListTile<String>(
                          title: Text(session),
                          value: session,
                          groupValue: _selectedSession,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedSession = value!;
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                )
              ],
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // Close the AlertDialog
              },
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.whiteColor,
                    border: Border.all(color: GlobalVariables.textColor),
                    borderRadius: BorderRadius.circular(3)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'CANCEL',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: GlobalVariables.textColor,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {

                fixedSession.add(_selectedSession);

                liveMenuDataList.add(
                  LiveMenuNew(
                    ritemUId:  newItem['uId'],
                    ritemDispname: newItem['disName'],
                    ritemAvailability: true,
                    ritemCategory: newItem['category'],
                    ritemTag: newItem['tag'],
                    ritemAvailableType: 0,
                    day: dateAndDay!['day'],
                    date: dateAndDay['date'],
                    mealsSessionCount: MealSessionCount(
                      breakfast: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: 0),
                        session2: Session(enabled: true, availableCount: 0),
                        session3: Session(enabled: true, availableCount: 0),
                      ),
                      lunch: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: 0),
                        session2: Session(enabled: true, availableCount: 0),
                        session3: Session(enabled: true, availableCount: 0),
                      ),
                      dinner: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: fixedSession.contains('S1') ? 10 : 0),
                        session2: Session(enabled: true, availableCount: fixedSession.contains('S2') ? 10 : 0),
                        session3: Session(enabled: true, availableCount: fixedSession.contains('S3') ? 10 : 0),
                      ),
                    ),
                  ),
                );

                Navigator.pop(context);

                contexts.read<LiveMenu1Bloc>().add(AddLiveMenuItemFromLiveMenuEvent(liveMenuDataList));

              },
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.primaryColor,
                    border: Border.all(color: GlobalVariables.primaryColor),
                    borderRadius: BorderRadius.circular(3)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'NEXT',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: GlobalVariables.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

    });

  }



  static void addItemInLiveMulti(BuildContext context){
    TextEditingController textEditingController = TextEditingController();

    LiveMenuVariables.onSelectionItems = [];
    LiveMenuVariables.foodCategories.values.forEach((items) {
      items.forEach((item) {
        if(item['availability'] )
        {
          LiveMenuVariables.onSelectionItems.add(item['disName']);
        }
      });
    });
    showDialog(
      context: context,
      builder: (contexts) {
        return Container(
          child: AlertDialog(
            title: Text('Adding new item'),
            content: Container(
              height: 400,
              width: 400,
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Search for item',
                    width: 400,
                    height: 50,
                    controller: textEditingController,
                    searchItem: true,
                    readOnly: true,
                    dropdownItems: LiveMenuVariables.onSelectionItems,
                    isDropdown: true,
                    showSearchBox1: true,
                    dropdownAuto: true,
                    digitsAndLetters: true,
                    displayCount: true,
                    showAddItemDropDownSearch : false,
                    onChangedDropdown: (val){

                    },
                  ),

                ],
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color:GlobalVariables.whiteColor,
                      border:Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(7),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: SafeGoogleFont(
                        'Poppins',
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

                  Navigator.pop(context);

                  Map<String,dynamic> newItem = {};

                  Map<String,dynamic> liveMenuSample = {};

                  LiveMenuVariables.foodCategories.values.forEach((items) {
                    items.forEach((item) {
                      if(item['disName'] == textEditingController.text)
                      {
                        newItem = item;
                      }
                    });
                  });


                  bool itemExist = false;

                  LiveMenuVariables.liveMenuNewfoodCategoriesAll.values.forEach((items) {
                    items.forEach((item) {
                      if(item['disName'] == textEditingController.text && item['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3)) {
                        itemExist = true;
                        return;
                      }
                    });
                  });

                  if(itemExist) {
                    MenuEditorFunction.showPriceShouldNotBeNull(context, "Item already lived");
                  } else {
                    LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast.values.forEach((items) {
                      items.forEach((item) {
                        if(item['disName'] == textEditingController.text && item['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3)) {
                          itemExist = true;
                          return;
                        }
                      });
                    });

                    if(itemExist)
                    {
                      LiveMenuFunctions.showItemAlreadyExistMulti(context,'Lunch',liveMenuSample,"breakfast");
                    }
                    else {
                      LiveMenuVariables.liveMenuNewfoodCategoriesLunch.values.forEach((items) {
                        items.forEach((item) {
                          if(item['disName'] == textEditingController.text && item['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3)){
                            itemExist = true;
                            liveMenuSample = item;
                            return;
                          }
                        });
                      });

                      if(itemExist) {

                        LiveMenuFunctions.showItemAlreadyExistMulti(context,'Lunch',liveMenuSample,"lunch");

                      }
                      else{
                        LiveMenuVariables.liveMenuNewfoodCategoriesDinner.values.forEach((items) {
                          items.forEach((item) {
                            if(item['disName'] == textEditingController.text && item['day'].toString().substring(0,3) == GlobalVariables.selectedDay.substring(0,3)){
                              itemExist = true;
                              liveMenuSample = item;
                              return;
                            }
                          });
                        });
                        if(itemExist) {

                          LiveMenuFunctions.showItemAlreadyExistMulti(context,'Lunch',liveMenuSample,"dinner");

                        }
                        else {
                          List<LiveMenuNew> liveMenuDataList = [];

                          String selectedDate = GlobalVariables.selectedDay.substring(0,3);

                          Map<String, dynamic>? dateAndDay = MenuEditorFunction.getDayAndDate(selectedDate);

                          print("Date and day is $dateAndDay");

                          liveMenuDataList.add(
                            LiveMenuNew(
                              ritemUId:  newItem['uId'],
                              ritemDispname: newItem['disName'],
                              ritemAvailability: true,
                              ritemCategory: newItem['category'],
                              ritemTag: newItem['tag'],
                              ritemAvailableType: 0,
                              day: dateAndDay!['day'],
                              date: dateAndDay['date'],
                              mealsSessionCount: MealSessionCount(
                                breakfast: Meal(
                                    enabled: true,
                                    session1: Session(enabled: true, availableCount: 10),
                                    session2: Session(enabled: true, availableCount: 10),
                                    session3: Session(enabled: true, availableCount: 10)),
                                lunch: Meal(
                                  enabled: true,
                                  session1: Session(enabled: true, availableCount: 10),
                                  session2: Session(enabled: true, availableCount: 10),
                                  session3: Session(enabled: true, availableCount: 10),
                                ),
                                dinner: Meal(
                                  enabled: true,
                                  session1: Session(enabled: true, availableCount: 10),
                                  session2: Session(enabled: true, availableCount: 10),
                                  session3: Session(enabled: true, availableCount: 10),
                                ),
                              ),
                            ),
                          );

                          context.read<LiveMenu1Bloc>().add(AddLiveMenuItemFromLiveMenuEvent(liveMenuDataList));
                        }
                      }
                    }
                  }




                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: GlobalVariables.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(7),
                  child: Center(
                    child: Text(
                      'Add',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: GlobalVariables.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void calculateBreakfastTotal() {
    try {
      int session1 = int.parse(LiveMenuVariables.bfSession1Controller.text);
      int session2 = int.parse(LiveMenuVariables.bfSession2Controller.text);
      int session3 = int.parse(LiveMenuVariables.bfSession3Controller.text);

      LiveMenuVariables.breakfastTotal.text = (session1 + session2 + session3).toString();
    } catch (e) {
      // Handle the error, e.g., set a default value or show a message
      LiveMenuVariables.breakfastTotal.text = '0';
    }
  }

  static void calculateLunchTotal() {
    try {
      int session1 = int.parse(LiveMenuVariables.lnSession1Controller.text);
      int session2 = int.parse(LiveMenuVariables.lnSession2Controller.text);
      int session3 = int.parse(LiveMenuVariables.lnSession3Controller.text);

      LiveMenuVariables.lunchTotal.text = (session1 + session2 + session3).toString();
    } catch (e) {
      // Handle the error, e.g., set a default value or show a message
      LiveMenuVariables.lunchTotal.text = '0';
    }
  }

  static void calculateDinnerTotal() {
    try {
      int session1 = int.parse(LiveMenuVariables.dnSession1Controller.text);
      int session2 = int.parse(LiveMenuVariables.dnSession2Controller.text);
      int session3 = int.parse(LiveMenuVariables.dnSession3Controller.text);

      LiveMenuVariables.dinnerTotal.text = (session1 + session2 + session3).toString();
    } catch (e) {
      // Handle the error, e.g., set a default value or show a message
      LiveMenuVariables.dinnerTotal.text = '0';
    }
  }

  static void showItemAlreadyExist(BuildContext contexts,String meal,Map<String,dynamic> liveMenuSample) {
    showDialog(
      context: contexts,
      builder: (context) {
        return AlertDialog(
          title: Text("Item already lived in $meal if you add item you can check details in multi tab.\ndo you want to add the item?",style: GlobalVariables.dataItemStyle,),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // Close the AlertDialog
              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.whiteColor,
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'No',
                    style: SafeGoogleFont(
                      'Poppins',
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

                List<LiveMenuNewSample> liveMenuDataList = [];

                liveMenuDataList.add(
                  LiveMenuNewSample(
                    ritemUId:  liveMenuSample['ritem_UId'],
                    date: liveMenuSample['date'],
                    updateData : MealSessionCount(
                      breakfast: Meal(
                          enabled: true,
                          session1: Session(enabled: true, availableCount: 10),
                          session2: Session(enabled: true, availableCount: 10),
                          session3: Session(enabled: true, availableCount: 10)),
                      lunch: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: liveMenuSample['lunchSession1']),
                        session2: Session(enabled: true, availableCount: liveMenuSample['lunchSession2']),
                        session3: Session(enabled: true, availableCount: liveMenuSample['lunchSession3']),
                      ),
                      dinner: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: liveMenuSample['dinnerSession1']),
                        session2: Session(enabled: true, availableCount: liveMenuSample['dinnerSession2']),
                        session3: Session(enabled: true, availableCount: liveMenuSample['dinnerSession3']),
                      ),
                    ),
                  ),
                );

                contexts.read<LiveMenu1Bloc>().add(UpdateLiveMenuItemEvent(liveMenuDataList));
                Navigator.pop(context);

              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.whiteColor,
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'Yes',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showItemAlreadyExistMulti(BuildContext contexts,String meal,Map<String,dynamic> liveMenuSample,String multiMeal) {
    showDialog(
      context: contexts,
      builder: (context) {
        return AlertDialog(
          title: Text("Item already lived in $meal if you add item you can check details in multi tab.\ndo you want to add the item?",style: GlobalVariables.dataItemStyle,),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // Close the AlertDialog
              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.whiteColor,
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'No',
                    style: SafeGoogleFont(
                      'Poppins',
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

                List<LiveMenuNewSample> liveMenuDataList = [];

                liveMenuDataList.add(
                  LiveMenuNewSample(
                    ritemUId:  liveMenuSample['ritem_UId'],
                    date: liveMenuSample['date'],
                    updateData : multiMeal == "breakfast"
                               ? MealSessionCount(
                      breakfast: Meal(
                          enabled: true,
                          session1: Session(enabled: true, availableCount: liveMenuSample['breakfastSession1']),
                          session2: Session(enabled: true, availableCount: liveMenuSample['breakfastSession1']),
                          session3: Session(enabled: true, availableCount: liveMenuSample['breakfastSession1'])),
                      lunch: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: 10),
                        session2: Session(enabled: true, availableCount: 10),
                        session3: Session(enabled: true, availableCount: 10),
                      ),
                      dinner: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: 10),
                        session2: Session(enabled: true, availableCount: 10),
                        session3: Session(enabled: true, availableCount: 10),
                      ),
                    )
                               : multiMeal == "lunch"
                               ? MealSessionCount(
                      breakfast: Meal(
                          enabled: true,
                          session1: Session(enabled: true, availableCount: 10),
                          session2: Session(enabled: true, availableCount: 10),
                          session3: Session(enabled: true, availableCount: 10)),
                      lunch: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: liveMenuSample['lunchSession1']),
                        session2: Session(enabled: true, availableCount: liveMenuSample['lunchSession2']),
                        session3: Session(enabled: true, availableCount: liveMenuSample['lunchSession3']),
                      ),
                      dinner: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: 10),
                        session2: Session(enabled: true, availableCount: 10),
                        session3: Session(enabled: true, availableCount: 10),
                      ),
                    )
                               : MealSessionCount(
                      breakfast: Meal(
                          enabled: true,
                          session1: Session(enabled: true, availableCount: 10),
                          session2: Session(enabled: true, availableCount: 10),
                          session3: Session(enabled: true, availableCount: 10)),
                      lunch: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: 10),
                        session2: Session(enabled: true, availableCount: 10),
                        session3: Session(enabled: true, availableCount: 10),
                      ),
                      dinner: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: liveMenuSample['dinnerSession1']),
                        session2: Session(enabled: true, availableCount: liveMenuSample['dinnerSession2']),
                        session3: Session(enabled: true, availableCount: liveMenuSample['dinnerSession3']),
                      ),
                    ),
                  ),
                );

                contexts.read<LiveMenu1Bloc>().add(UpdateLiveMenuItemEvent(liveMenuDataList));
                Navigator.pop(context);

              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.whiteColor,
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'Yes',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showItemAlreadyExistLunch(BuildContext contexts,String meal,Map<String,dynamic> liveMenuSample) {
    showDialog(
      context: contexts,
      builder: (context) {
        return AlertDialog(
          title: Text("Item already lived in $meal if you add item you can check details in multi tab.\ndo you want to add the item?",style: GlobalVariables.dataItemStyle,),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // Close the AlertDialog
              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.whiteColor,
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'No',
                    style: SafeGoogleFont(
                      'Poppins',
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

                List<LiveMenuNewSample> liveMenuDataList = [];

                liveMenuDataList.add(
                  LiveMenuNewSample(
                    ritemUId:  liveMenuSample['ritem_UId'],
                    date: liveMenuSample['date'],
                    updateData : MealSessionCount(
                      breakfast: Meal(
                          enabled: true,
                          session1: Session(enabled: true, availableCount: liveMenuSample['breakfastSession1']),
                          session2: Session(enabled: true, availableCount: liveMenuSample['breakfastSession2']),
                          session3: Session(enabled: true, availableCount: liveMenuSample['breakfastSession3'])),
                      lunch: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: 10),
                        session2: Session(enabled: true, availableCount: 10),
                        session3: Session(enabled: true, availableCount: 10),
                      ),
                      dinner: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: liveMenuSample['dinnerSession1']),
                        session2: Session(enabled: true, availableCount: liveMenuSample['dinnerSession2']),
                        session3: Session(enabled: true, availableCount: liveMenuSample['dinnerSession3']),
                      ),
                    ),
                  ),
                );

                contexts.read<LiveMenu1Bloc>().add(UpdateLiveMenuItemEvent(liveMenuDataList));
                Navigator.pop(context);

              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.whiteColor,
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'Yes',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showItemAlreadyExistDinner(BuildContext contexts,String meal,Map<String,dynamic> liveMenuSample) {
    showDialog(
      context: contexts,
      builder: (context) {
        return AlertDialog(
          title: Text("Item already lived in $meal if you add item you can check details in multi tab.\ndo you want to add the item?",style: GlobalVariables.dataItemStyle,),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // Close the AlertDialog
              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.whiteColor,
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'No',
                    style: SafeGoogleFont(
                      'Poppins',
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

                List<LiveMenuNewSample> liveMenuDataList = [];

                liveMenuDataList.add(
                  LiveMenuNewSample(
                    ritemUId:  liveMenuSample['ritem_UId'],
                    date: liveMenuSample['date'],
                    updateData : MealSessionCount(
                      breakfast: Meal(
                          enabled: true,
                          session1: Session(enabled: true, availableCount: liveMenuSample['breakfastSession1']),
                          session2: Session(enabled: true, availableCount: liveMenuSample['breakfastSession2']),
                          session3: Session(enabled: true, availableCount: liveMenuSample['breakfastSession3'])),
                      lunch: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: liveMenuSample['lunchSession1']),
                        session2: Session(enabled: true, availableCount: liveMenuSample['lunchSession2']),
                        session3: Session(enabled: true, availableCount: liveMenuSample['lunchSession3']),
                      ),
                      dinner: Meal(
                        enabled: true,
                        session1: Session(enabled: true, availableCount: 10),
                        session2: Session(enabled: true, availableCount: 10),
                        session3: Session(enabled: true, availableCount: 10),
                      ),
                    ),
                  ),
                );

                contexts.read<LiveMenu1Bloc>().add(UpdateLiveMenuItemEvent(liveMenuDataList));
                Navigator.pop(context);

              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.whiteColor,
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'Yes',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


}