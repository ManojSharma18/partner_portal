import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_variables.dart';
import 'package:partner_admin_portal/constants/utils.dart';

import '../../bloc/menu/menu_event.dart';
import '../../repository/menu_services.dart';

class MenuSearchBars extends StatefulWidget {
  final String hintText;
  final double width;
  final double height;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function()? onPressed;
  const MenuSearchBars({Key? key, required this.hintText,this.onChanged, this.onPressed,  this.controller, required this.width, this.height = 40}) : super(key: key);

  @override
  State<MenuSearchBars> createState() => _MenuSearchBarsState();
}

class _MenuSearchBarsState extends State<MenuSearchBars> {


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
          width: widget.width,
          height: widget.height,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: TextFormField(
              controller:widget.controller,
              inputFormatters: [CustomInputFormatter(),],
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: widget.hintText,
                fillColor:GlobalVariables.whiteColor ,
                focusColor: GlobalVariables.whiteColor,
                suffixIcon: GestureDetector(
                  onTap:widget.onPressed,
                    child: Icon(Icons.filter_list,color: GlobalVariables.textColor,)
                ),
                prefixIcon: Icon(Icons.search, color: Color(0xfffbb830)) ,
                border: InputBorder.none, // Hide the border
              ),
            ),
          )

      ),
    );
  }


}


class CustomInputFormatter extends TextInputFormatter {
  // Updated regular expression to allow the specified characters
  final RegExp _allowedCharacters = RegExp(r'^[a-zA-Z0-9\-\&\~\!\,\@\#\*\(\)\./ ]*$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Ensure input does not start with a space or tab
    if (newValue.text.startsWith(' ') || newValue.text.startsWith('\t')) {
      return oldValue;
    }
    // Check if all characters are allowed
    if (_allowedCharacters.hasMatch(newValue.text)) {
      return newValue;
    }
    // If not, return old value
    return oldValue;
  }
}

class CustomPopupMenuItem extends StatefulWidget {
  final bool isVegChecked;
  final bool isNonVegChecked;
  final bool isFoodChecked;
  final bool isBeverageChecked;
  final bool isBreakfastChecked;
  final bool isLunchChecked;
  final bool isDinnerChecked;
  final bool isBudgetChecked;
  final bool isPocketFriendlyChecked;
  final bool isLuxuryChecked;
  final bool isPremiumChecked;
  final Function(BuildContext, bool?) onVegChanged;
  final Function(BuildContext, bool?) onNonVegChanged;
  final Function(BuildContext, bool?) onFoodChanged;
  final Function(BuildContext, bool?) onBeverageChanged;
  final Function(BuildContext, bool?) onBreakfastChanged;
  final Function(BuildContext, bool?) onLunchChanged;
  final Function(BuildContext, bool?) onDinnerChanged;
  final Function(BuildContext, bool?) onBudgetChanged;
  final Function(BuildContext, bool?) onPocketFriendlyChanged;
  final Function(BuildContext, bool?) onPremiumChanged;
  final Function(BuildContext, bool?) onLuxuryChanged;



  CustomPopupMenuItem({
    required this.isVegChecked,
    required this.isNonVegChecked,
    required this.onVegChanged,
    required this.onNonVegChanged, required this.onFoodChanged, required this.onBeverageChanged, required this.onBreakfastChanged, required this.onLunchChanged, required this.onDinnerChanged, required this.onBudgetChanged, required this.onPocketFriendlyChanged, required this.onPremiumChanged, required this.onLuxuryChanged, required this.isFoodChecked, required this.isBeverageChecked, required this.isBreakfastChecked, required this.isLunchChecked, required this.isDinnerChecked, required this.isBudgetChecked, required this.isPocketFriendlyChecked, required this.isLuxuryChecked, required this.isPremiumChecked,
  });

  @override
  State<CustomPopupMenuItem> createState() => _CustomPopupMenuItemState();
}

class _CustomPopupMenuItemState extends State<CustomPopupMenuItem> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MenuBloc(
          MenuService()
      )..add(LoadMenuEvent(context)),
      child: BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext menuContext, state) {
        if(state is MenuLoadedState)  {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Category',
                      style: GlobalVariables.headingStyle,
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: MenuEditorVariables.isVegChecked,
                        onChanged: (bool? value) => widget.onVegChanged(menuContext, value),
                      ),
                      Text('Veg',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: MenuEditorVariables.isNonVegChecked,
                        onChanged: (bool? value) => widget.onNonVegChanged(menuContext, value),
                      ),
                      Text('Non-Veg',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),

                  SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Item type',
                      style: GlobalVariables.headingStyle,
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: MenuEditorVariables.isFood,
                        onChanged: (bool? value) => widget.onFoodChanged(menuContext, value),
                      ),
                      Text('Food',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: MenuEditorVariables.isBeverage,
                        onChanged: (bool? value) => widget.onBeverageChanged(menuContext, value),
                      ),
                      Text('Beverage',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Meal',
                      style: GlobalVariables.headingStyle,
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: MenuEditorVariables.isBreakfast,
                        onChanged: (bool? value) => widget.onBreakfastChanged(menuContext, value),
                      ),
                      Text('Breakfast',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: MenuEditorVariables.isLunch,
                        onChanged: (bool? value) => widget.onLunchChanged(menuContext, value),
                      ),
                      Text('Lunch',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: MenuEditorVariables.isDinner,
                        onChanged: (bool? value) => widget.onDinnerChanged(menuContext, value),
                      ),
                      Text('Dinner',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 30,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Budget type',
                      style: GlobalVariables.headingStyle,
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: MenuEditorVariables.isBudget,
                        onChanged: (bool? value) => widget.onBudgetChanged(menuContext, value),
                      ),
                      Text('Budget',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: MenuEditorVariables.isPocketFriendly,
                        onChanged: (bool? value) => widget.onPocketFriendlyChanged(menuContext, value),
                      ),
                      Text('Pocket friendly',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: MenuEditorVariables.isPremium,
                        onChanged: (bool? value) => widget.onPremiumChanged(menuContext, value),
                      ),
                      Text('Premium',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: MenuEditorVariables.isLuxury,
                        onChanged: (bool? value) => widget.onLuxuryChanged(menuContext, value),
                      ),
                      Text('Luxury',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Cuisine',
                      style: GlobalVariables.headingStyle,
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: widget.isVegChecked,
                        onChanged: (bool? value) => widget.onVegChanged(menuContext, value),
                      ),
                      Text('South indian',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: widget.isNonVegChecked,
                        onChanged: (bool? value) => widget.onVegChanged(menuContext, value),
                      ),
                      Text('North indian',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: widget.isNonVegChecked,
                        onChanged: (bool? value) => widget.onVegChanged(menuContext, value),
                      ),
                      Text('Chinese',style: GlobalVariables.dataItemStyle,),
                    ],
                  ),

                ],
              ),

            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Category',
                    style: GlobalVariables.headingStyle,
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: MenuEditorVariables.isVegChecked,
                      onChanged: (bool? value) => widget.onVegChanged(menuContext, value),
                    ),
                    Text('Veg',style: GlobalVariables.dataItemStyle,),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: MenuEditorVariables.isNonVegChecked,
                      onChanged: (bool? value) => widget.onNonVegChanged(menuContext, value),
                    ),
                    Text('Non-Veg',style: GlobalVariables.dataItemStyle,),
                  ],
                ),

                SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Item type',
                    style: GlobalVariables.headingStyle,
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: MenuEditorVariables.isFood,
                      onChanged: (bool? value) => widget.onFoodChanged(menuContext, value),
                    ),
                    Text('Food',style: GlobalVariables.dataItemStyle,),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: MenuEditorVariables.isBeverage,
                      onChanged: (bool? value) => widget.onBeverageChanged(menuContext, value),
                    ),
                    Text('Beverage',style: GlobalVariables.dataItemStyle,),
                  ],
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Meal',
                    style: GlobalVariables.headingStyle,
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: MenuEditorVariables.isBreakfast,
                      onChanged: (bool? value) => widget.onBreakfastChanged(menuContext, value),
                    ),
                    Text('Breakfast',style: GlobalVariables.dataItemStyle,),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: MenuEditorVariables.isLunch,
                      onChanged: (bool? value) => widget.onLunchChanged(menuContext, value),
                    ),
                    Text('Lunch',style: GlobalVariables.dataItemStyle,),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: MenuEditorVariables.isDinner,
                      onChanged: (bool? value) => widget.onDinnerChanged(menuContext, value),
                    ),
                    Text('Dinner',style: GlobalVariables.dataItemStyle,),
                  ],
                ),
              ],
            ),
            SizedBox(width: 30,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Budget type',
                    style: GlobalVariables.headingStyle,
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: MenuEditorVariables.isBudget,
                      onChanged: (bool? value) => widget.onBudgetChanged(menuContext, value),
                    ),
                    Text('Budget',style: GlobalVariables.dataItemStyle,),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: MenuEditorVariables.isPocketFriendly,
                      onChanged: (bool? value) => widget.onPocketFriendlyChanged(menuContext, value),
                    ),
                    Text('Pocket friendly',style: GlobalVariables.dataItemStyle,),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: MenuEditorVariables.isPremium,
                      onChanged: (bool? value) => widget.onPremiumChanged(menuContext, value),
                    ),
                    Text('Premium',style: GlobalVariables.dataItemStyle,),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: MenuEditorVariables.isLuxury,
                      onChanged: (bool? value) => widget.onLuxuryChanged(menuContext, value),
                    ),
                    Text('Luxury',style: GlobalVariables.dataItemStyle,),
                  ],
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Cuisine',
                    style: GlobalVariables.headingStyle,
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: widget.isVegChecked,
                      onChanged: (bool? value) => widget.onVegChanged(menuContext, value),
                    ),
                    Text('South indian',style: GlobalVariables.dataItemStyle,),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: widget.isNonVegChecked,
                      onChanged: (bool? value) => widget.onVegChanged(menuContext, value),
                    ),
                    Text('North indian',style: GlobalVariables.dataItemStyle,),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: widget.isNonVegChecked,
                      onChanged: (bool? value) => widget.onVegChanged(menuContext, value),
                    ),
                    Text('Chinese',style: GlobalVariables.dataItemStyle,),
                  ],
                ),

              ],
            ),

          ],
        );
      },

      ),
    );
  }
}


