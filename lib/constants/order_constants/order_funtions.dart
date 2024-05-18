import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/constants/order_constants/order_variables.dart';
import 'package:partner_admin_portal/constants/utils.dart';
import 'package:partner_admin_portal/widgets/Forecast_table.dart';
import 'package:partner_admin_portal/widgets/small_custom_textfield.dart';

import '../global_variables.dart';
import '../live_menu_constants/live_menu_variables.dart';

class OrderFunctions {

  static List<Widget> buildItemList(BuildContext context) {
    List<Widget> itemList = [];

    for (var itemDetail in OrderVariables.itemDetails) {
      String itemName = itemDetail["name"];
      itemList.add(buildDismissibleItem1(context, itemName,itemDetail["total"],itemDetail["breakfast"],itemDetail["lunch"],itemDetail["Dinner"]));
    }

    return itemList;
  }

  static Widget buildDismissibleItem1(BuildContext context,String item,int total,int breakfast,int lunch, int dinner)
  {
    TextEditingController totalController = TextEditingController(text: total.toString());
    TextEditingController breakfastController = TextEditingController(text: breakfast.toString());
    TextEditingController lunchController = TextEditingController(text: lunch.toString());
    TextEditingController dinnerController = TextEditingController(text: dinner.toString());
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
    return InkWell(
      onTap: (){

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
                            Expanded(
                              child: Container(
                                width: 250*fem,
                                child: Text(
                                  item,
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 13*fem,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.textColor,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Material(child: ForeCastTable())));
                                },
                                child: Icon(Icons.arrow_forward_ios,color: GlobalVariables.textColor.withOpacity(0.9),size: 20,)
                            )
                          ],
                        ),
                      ),


                      leading: Container(
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
                      )

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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(total.toString(),style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color:GlobalVariables.textColor,
                            ),),
                            SizedBox(height:5),
                            Container(
                              width:65*fem,
                              height: 40,
                              child: SmallCustomTextField(
                                min:0,max:9999,
                                textEditingController: totalController,height: 30,fontSize: 12,
                                onChanged: (text){


                                },
                              ),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(breakfast.toString(),style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color:GlobalVariables.textColor,
                            ),),
                            SizedBox(height:5),
                            Container(
                              width:65*fem,
                              height:35,
                              child: SmallCustomTextField(
                                textEditingController: breakfastController,height: 30,fontSize: 12,
                                min:0,max:9999,
                                onChanged: (text){

                                },
                              ),
                            ),
                            SizedBox(height:10),
                            Text("Breakfast",style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color:GlobalVariables.textColor,
                            ),),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(lunch.toString(),style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color:GlobalVariables.textColor,
                            ),),
                            SizedBox(height: 5,),
                            Container(
                              width:65*fem,
                              height:35,
                              child: SmallCustomTextField(
                                textEditingController: lunchController,height: 30,fontSize: 12,
                                min:0,max:9999,
                                onChanged: (text){

                                },
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: Text("Lunch",style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color:GlobalVariables.textColor,
                              ),),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(dinner.toString(),style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color:GlobalVariables.textColor,
                            ),),
                            SizedBox(height: 5,),
                            Container(
                              width:65*fem,
                              height:35,
                              child: SmallCustomTextField(
                                textEditingController: dinnerController,height: 30,fontSize: 12,
                                min:0,max:9999,
                                onChanged: (text){

                                },
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text("Dinner",style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color:GlobalVariables.textColor,
                            ),),
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
    );
  }

  static int compareTime(Map<String, dynamic> a, Map<String, dynamic> b) {
    DateTime timeA = DateFormat('hh:mm a').parse(a['Time']);
    DateTime timeB = DateFormat('hh:mm a').parse(b['Time']);
    return OrderVariables.ascending ? timeA.compareTo(timeB) : timeB.compareTo(timeA);
  }
}