import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_bloc.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_event.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_state.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';

import '../../widgets/custom_textfield.dart';
import '../../widgets/menu/live_menu/count_table.dart';
import '../../widgets/menu/live_menu/live_menu.dart';
import '../../widgets/small_custom_textfield.dart';
import '../global_function.dart';
import '../global_variables.dart';
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
}