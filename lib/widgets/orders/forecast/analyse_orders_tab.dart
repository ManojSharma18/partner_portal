import 'package:flutter/material.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu.dart';
import 'package:partner_admin_portal/widgets/orders/manage/manage_orderes.dart';
import '../../../constants/global_function.dart';
import '../../../constants/global_variables.dart';

class AnalyseOrderTab extends StatelessWidget {
  const AnalyseOrderTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Column(
      children: [
        Container(
          height: 60,
          color: Colors.grey.shade100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 15,),
                  GlobalFunction.buildMealButton(context,MealTime.All,'All'),
                  SizedBox(width: 15,),
                  GlobalFunction.buildMealButton(context,MealTime.Breakfast,'Breakfast'),
                  SizedBox(width: 15,),
                  GlobalFunction.buildMealButton(context,MealTime.Lunch,'Lunch'),
                  SizedBox(width: 15,),
                  GlobalFunction.buildMealButton(context,MealTime.Dinner,'Dinner'),
                  SizedBox(width: 15,),

                ],
              ),

              Container(
                width: 2,
                color: GlobalVariables.primaryColor.withOpacity(0.3),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlobalFunction.buildOrderButton(context,Orders.All, 'All'),
                  SizedBox(width: 15,),
                  GlobalFunction.buildOrderButton(context,Orders.Pickup, 'Pick up'),
                  SizedBox(width: 15,),
                  GlobalFunction.buildOrderButton(context,Orders.All, 'Dine'),
                  SizedBox(width: 15,),
                  GlobalFunction.buildOrderButton(context,Orders.All, 'Deliver'),
                  SizedBox(width: 15,),
                ],
              ),

            ],
          ),
        ),
        SizedBox(height: 5,),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: GlobalVariables.itemDetails.length,
                    itemBuilder: (context, index) {

                      return InkWell(
                        onTap: () {
                          // setState(() {
                          //   selectedItem = foods[index];
                          // });
                        },
                        child: Column(
                          children: [


                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.black26,
                width: 1,
              ),
              Container(
                color: Colors.black26,
                width: 1,
              ),
              Expanded(
                flex: 5,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                    ],
                  ),
                ),

              ),
            ],
          ),
        ),
      ],
    );
  }

}
