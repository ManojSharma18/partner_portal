import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/bloc/menu/menu_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_event.dart';
import 'package:partner_admin_portal/bloc/menu/menu_state.dart';
import 'package:partner_admin_portal/constants/global_function.dart';
import 'package:partner_admin_portal/constants/manage_settings/manage_settings_functions.dart';
import 'package:partner_admin_portal/constants/manage_settings/manage_settings_variables.dart';
import '../../repository/menu_services.dart';
import '../../widgets/custom_textfield.dart';
import '../global_variables.dart';
import '../utils.dart';
import 'menu_editor_variables.dart';
import 'menu_search_bar.dart';

class MenuEditorFunction {

  static void showAlertEditNotSaved(BuildContext context,BuildContext menuContext,MenuLoadedState menuState,Map<String, List<Map<String,dynamic>>> foodCategories){
    showDialog(
        context: context, builder: (Builder) {
      return AlertDialog(
        title: Text("You have edited some fields do you want to save changes?",style: TextStyle(
          fontFamily: 'BertSans',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xff1d1517),
        ),),

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              TextButton(
                  onPressed: () {
                    Navigator.pop(menuContext);
              },
                  child: Container(
                width: 80,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    border: Border.all(color: GlobalVariables.primaryColor),
                    color: GlobalVariables.primaryColor
                ),
                child: Center(child: Text("Cancel",style: TextStyle(color: GlobalVariables.whiteColor),)),
              )),
              SizedBox(width: 10,),
              InkWell(
                onTap: () {
                  Navigator.pop(menuContext);
                  MenuEditorFunction.saveChangesItem(context,menuState,menuContext,foodCategories);
                },
                child: Container(
                  width: 130,
                  height: 40,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue, // Replace with your primary color
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "Save changes",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

        ],
      );
    });
  }

  static void showAddItemCategory(BuildContext menuContext,BuildContext showContext,Map<String, List<Map<String,dynamic>>> foodCategories) {
    TextEditingController item = TextEditingController();
    Map<String,dynamic> requestBody = {};
    MenuEditorVariables.isTagDropdown = true;
    MenuEditorVariables.tagAddType = "imported";
    showDialog(
      context: showContext,
      builder: (BuildContext contexts) {
        return BlocProvider(
          create: (BuildContext context) => MenuBloc(
              MenuService()
          )..add(LoadTagsEvent(contexts)),
          child: BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
            if(state is MenuLoadingState) {
              return Container(
                child: AlertDialog(
                  title: Text('Adding new section'),
                  content: Container(
                    height: 400,
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator())
                      ],
                    ),
                  ),

                ),
              );
            }

            if(state is MenuLoadedState) {
              return Container(
                child: AlertDialog(
                  title: Text('Adding new section'),
                  content: Container(
                    height: 400,
                    width: 400,
                    child: Column(
                      children: [
                        CustomTextField(label: 'Search for Category',
                          width: 400,
                          controller: item,
                          onSubmitted: (val) {
                          Navigator.pop(context);
                          },
                          dropdownItems: MenuEditorVariables.tags,
                          // isDropdown: true,
                          // showSearchBox1: true,
                          // dropdownAuto: true,
                          digitsAndLetters: true,
                          displayCount: true,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    InkWell(
                      onTap : () {
                        MenuEditorVariables.tagAddType = "imported";
                        MenuEditorVariables.isTagDropdown = false;
                        Navigator.of(context).pop(); // Close the AlertDialog
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                            color:GlobalVariables.whiteColor,
                            border:Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),

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

                        item.text = item.text.trim();

                        String firstCharacter = item.text.isNotEmpty
                            ? item.text[0]
                            : '';

                        bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                            (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
                                '0123456789'.contains(firstCharacter)));

                        if(item.text.trim().length < 3)
                          {
                            Flushbar(
                              title: "Section name validation",
                              message: "Sction name should have minimum 3 characters",
                              backgroundGradient: LinearGradient(colors: [GlobalVariables.textColor, Colors.teal]),
                              backgroundColor: Colors.red,
                              boxShadows: [BoxShadow(color: GlobalVariables.textColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
                              duration: Duration(seconds: 2),
                            )..show(context);
                          }
                        else if(!isFirstCharacterLetterOrDigit) {
                          Flushbar(
                            title: "Section name validation",
                            message: "Section name should start with either digit or letter.",
                            backgroundGradient: LinearGradient(colors: [GlobalVariables.textColor, Colors.teal]),
                            backgroundColor: Colors.red,
                            boxShadows: [BoxShadow(color: GlobalVariables.textColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
                            duration: Duration(seconds: 2),
                          )..show(context);

                        }
                        else {
                          bool itemExists = false;
                          for (final categoryItems in foodCategories.keys) {
                            if(categoryItems == item.text)
                            {
                              itemExists = true;
                              break;
                            }
                          }
                          if(itemExists)
                          {
                            Navigator.of(context).pop();
                            MenuEditorFunction.showSectionExistAlert(context,menuContext,item.text,requestBody);

                          }
                          else{
                            menuContext.read<MenuBloc>().add(AddSectionEvent(context,item.text));
                            Map<String, List<Map<String,dynamic>>> category = { item.text: [],};
                            foodCategories.addAll(category);

                            Navigator.of(context).pop();
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
            }
            return Container(
              child: AlertDialog(
                title: Text('Adding new section'),
                content: Container(
                  height: 400,
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator()
                    ],
                  ),
                ),

              ),
            );

          },

          ),
        );
      },
    );
  }

  static void showAddItemDialogImported(String category,BuildContext context,BuildContext menuContext,Map<String, List<Map<String,dynamic>>> foodCategories ) {
    TextEditingController item = TextEditingController();
    MenuEditorVariables.isItemDropdown = true;
    MenuEditorVariables.itemAddType = "imported";
    MenuEditorVariables.findItemIndex = 0;
    Map<String,dynamic> requestBody = {};
    showDialog(
      context: context,
      builder: (contexts) {
        return BlocProvider(
          create: (BuildContext context) => MenuBloc(
              MenuService()
          )..add(AddItemsEvent(context,category,foodCategories,menuContext)),
          child: BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
            if(state is MenuLoadingState) {
              return Container(
                child: AlertDialog(
                  title: Text('Add new item'),
                  content: Container(
                    height: 400,
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator())
                      ],
                    ),
                  ),

                ),
              );
            }

            if(state is MenuLoadedState) {
              return StatefulBuilder(builder: (BuildContext newContext, void Function(void Function()) setState) {
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
                            controller: item,
                            searchItem: true,
                            dropdownItems: MenuEditorVariables.items == [] ? [] : MenuEditorVariables.items ,
                            isDropdown: true,
                            showSearchBox1: true,
                            dropdownAuto: true,
                            digitsAndLetters: true,
                            displayCount: true,
                            onChangedDropdown: (val){
                              print(val);
                              menuContext.read<MenuBloc>().add(SearchItemsEvent(context,category,foodCategories,menuContext,val!));
                            },
                          ),

                        ],
                      ),
                    ),
                    actions: [
                      InkWell(
                        onTap: () {
                          MenuEditorVariables.itemAddType = "imported";
                          MenuEditorVariables.isItemDropdown = false;
                          Navigator.of(context).pop(); // Close the AlertDialog
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

                          String oldTag = "";

                          Map<String, dynamic> oneItem = {};

                          item.text = item.text.trim();

                          String firstCharacter = item.text.isNotEmpty
                              ? item.text[0]
                              : '';

                          bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                              (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
                                  '0123456789'.contains(firstCharacter)));

                          if(item.text.trim().length < 3)
                          {
                            Flushbar(
                              title: "Display name validation",
                              message: "Display name should have minimum 3 characters",
                              backgroundGradient: LinearGradient(colors: [GlobalVariables.textColor, Colors.teal]),
                              backgroundColor: Colors.red,
                              boxShadows: [BoxShadow(color: GlobalVariables.textColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
                              duration: Duration(seconds: 2),
                            )..show(context);
                          }
                          else if(!isFirstCharacterLetterOrDigit) {
                            GlobalFunction.showSnackBar(newContext, "Display name should start with either digit or letter.");
                          }
                          else {
                            String itemId = "";
                            String name = "";
                            bool itemExists = false;
                            for (final itemName in foodCategories[category]!) {
                              print("Item name ${foodCategories[category]} ${itemName['name']}");
                              if (item.text == itemName['disName']) {

                                print("Item already exists");
                                itemExists = true;
                                break; // Exit the loop as soon as we find a match
                              }
                            }

                            if (itemExists) {
                              Navigator.of(context).pop();
                              showAlreadyExistAlert(context);
                            }
                            else {

                              // Item doesn't exist, add it to the list
                              for (final entry in foodCategories.entries) {
                                final categoryKey = entry.key;
                                final categoryItems = entry.value;
                                int index = -1;

                                for (final itemName in categoryItems) {
                                  index = index + 1;
                                  if (item.text == itemName['disName']) {
                                    MenuEditorVariables.findItemIndex = index;
                                    itemId = itemName['_id'];
                                    name = itemName['disName'];
                                    oldTag = categoryKey;
                                    oneItem = itemName;
                                    requestBody = {
                                      "ritem_UId" : itemName['_id'],
                                      "ritem_name" : itemName['name'],
                                      "ritem_dispname" : itemName['disName'],
                                      "ritem_normalPrice" : itemName['normalPrice'],
                                      "ritem_packagePrice" : itemName['packagePrice'],
                                      "ritem_preorderPrice" : itemName['preorderPrice'],
                                      "ritem_available_type" : itemName['available_type'],
                                      'ritem_half_price' : itemName['halfPrice'],
                                      "ritem_half_normalPrice" : itemName['halfNormalPrice'],
                                      "ritem_half_preorderPrice" : itemName['halfPreorderPrice'],
                                      "ritem_normalFinalPrice" : itemName['normalFinalPrice'],
                                      "ritem_half_normalFinalPrice" : itemName['halfNormalFinalPrice'],
                                      "ritem_preorderFinalPrice" : itemName['preOrderFinalPrice'],
                                      "ritem_half_preorderFinalPrice" : itemName['halfPreOrderFinalPrice'],
                                      "ritem_priceRange" : itemName['priceRange'],
                                      "ritem_itemType" : itemName['itemType'],
                                      "ritem_itemSubType" : itemName['itemSubType'],
                                      "ritem_comboType" : itemName['comboType'],
                                      "ritem_rawSource" : itemName['rawSource'],
                                      "ritem_category" : itemName['category'],
                                      "ritem_subCategory" : itemName['subCategory'],
                                      "ritem_cuisine" : itemName['cuisine'],
                                      "ritem_regional" : itemName['regional'],
                                      "ritem_availability" : itemName['availability'],
                                      "fp_unit_avail_days_and_meals": {
                                        "Sun": {
                                          "BreakfastSession1" : itemName['sunBreakfastSession1'],
                                          "BreakfastSession2" : itemName['sunBreakfastSession2'],
                                          "BreakfastSession3" : itemName['sunBreakfastSession3'],
                                          "LunchSession1" : itemName['sunLunchSession1'],
                                          "LunchSession2" : itemName['sunLunchSession2'],
                                          "LunchSession3" : itemName['sunLunchSession3'],
                                          "DinnerSession1" : itemName['sunDinnerSession1'],
                                          "DinnerSession2" : itemName['sunDinnerSession2'],
                                          "DinnerSession3" : itemName['sunDinnerSession3'],
                                        },
                                        "Mon": {
                                          "BreakfastSession1" : itemName['monBreakfastSession1'],
                                          "BreakfastSession2" : itemName['monBreakfastSession2'],
                                          "BreakfastSession3" : itemName['monBreakfastSession3'],
                                          "LunchSession1" : itemName['monLunchSession1'],
                                          "LunchSession2" : itemName['monLunchSession2'],
                                          "LunchSession3" : itemName['monLunchSession3'],
                                          "DinnerSession1" : itemName['monDinnerSession1'],
                                          "DinnerSession2" : itemName['monDinnerSession2'],
                                          "DinnerSession3" : itemName['monDinnerSession3'],
                                        },
                                        "Tue": {
                                          "BreakfastSession1" : itemName['tueBreakfastSession1'],
                                          "BreakfastSession2" : itemName['tueBreakfastSession2'],
                                          "BreakfastSession3" : itemName['tueBreakfastSession3'],
                                          "LunchSession1" : itemName['tueLunchSession1'],
                                          "LunchSession2" : itemName['tueLunchSession2'],
                                          "LunchSession3" : itemName['tueLunchSession3'],
                                          "DinnerSession1" : itemName['tueDinnerSession1'],
                                          "DinnerSession2" : itemName['tueDinnerSession2'],
                                          "DinnerSession3" : itemName['tueDinnerSession3'],
                                        },
                                        "Wed": {
                                          "BreakfastSession1" : itemName['wedBreakfastSession1'],
                                          "BreakfastSession2" : itemName['wedBreakfastSession2'],
                                          "BreakfastSession3" : itemName['wedBreakfastSession3'],
                                          "LunchSession1" : itemName['wedLunchSession1'],
                                          "LunchSession2" : itemName['wedLunchSession2'],
                                          "LunchSession3" : itemName['wedLunchSession3'],
                                          "DinnerSession1" : itemName['wedDinnerSession1'],
                                          "DinnerSession2" : itemName['wedDinnerSession2'],
                                          "DinnerSession3" : itemName['wedDinnerSession3'],
                                        },
                                        "Thu": {
                                          "BreakfastSession1" : itemName['thuBreakfastSession1'],
                                          "BreakfastSession2" : itemName['thuBreakfastSession2'],
                                          "BreakfastSession3" : itemName['thuBreakfastSession3'],
                                          "LunchSession1" : itemName['thuLunchSession1'],
                                          "LunchSession2" : itemName['thuLunchSession2'],
                                          "LunchSession3" : itemName['thuLunchSession3'],
                                          "DinnerSession1" : itemName['thuDinnerSession1'],
                                          "DinnerSession2" : itemName['thuDinnerSession2'],
                                          "DinnerSession3" : itemName['thuDinnerSession3'],
                                        },
                                        "Fri": {
                                          "BreakfastSession1" : itemName['friBreakfastSession1'],
                                          "BreakfastSession2" : itemName['friBreakfastSession2'],
                                          "BreakfastSession3" : itemName['friBreakfastSession3'],
                                          "LunchSession1" : itemName['friLunchSession1'],
                                          "LunchSession2" : itemName['friLunchSession2'],
                                          "LunchSession3" : itemName['friLunchSession3'],
                                          "DinnerSession1" : itemName['friDinnerSession1'],
                                          "DinnerSession2" : itemName['friDinnerSession2'],
                                          "DinnerSession3" : itemName['friDinnerSession3'],
                                        },
                                        "Sat": {
                                          "BreakfastSession1" : itemName['satBreakfastSession1'],
                                          "BreakfastSession2" : itemName['satBreakfastSession2'],
                                          "BreakfastSession3" : itemName['satBreakfastSession3'],
                                          "LunchSession1" : itemName['satLunchSession1'],
                                          "LunchSession2" : itemName['satLunchSession2'],
                                          "LunchSession3" : itemName['satLunchSession3'],
                                          "DinnerSession1" : itemName['satDinnerSession1'],
                                          "DinnerSession2" : itemName['satDinnerSession2'],
                                          "DinnerSession3" : itemName['satDinnerSession3'],
                                        },
                                      },
                                    };

                                    itemExists = true;
                                    break; // Exit the loop as soon as we find a match
                                  }
                                }
                                if (itemExists) {
                                  break; // Exit the outer loop if the item exists
                                }
                              }

                              if(itemExists) {
                                Navigator.of(context).pop();
                                showReplaceItemAlert(context,menuContext,itemId,category,name,requestBody,oldTag,oneItem);
                              }
                              else {
                                // Map<String, dynamic> newItem = {'name': item.text, 'availability': true};
                                // foodCategories[category]!.add(newItem);
                                menuContext.read<MenuBloc>().add(AddMenuItemEvent(context, item.text, category,MenuEditorVariables.itemAddType));
                                Navigator.of(context).pop();
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
            return Container(
              child: AlertDialog(
                title: Text('Add new item'),
                content: Container(
                  height: 400,
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator()
                    ],
                  ),
                ),

              ),
            );

          },

          ),
        );
      },
    );
  }

  static void showAddItemDialogImported1(String category,BuildContext context,BuildContext menuContext,Map<String, List<Map<String,dynamic>>> foodCategories ) {
    TextEditingController item = TextEditingController();
    MenuEditorVariables.isItemDropdown = true;
    MenuEditorVariables.itemAddType = "imported";
    MenuEditorVariables.findItemIndex = 0;
    Map<String,dynamic> requestBody = {};
    showDialog(
      context: context,
      builder: (context) {
        return ScaffoldMessenger(
          child: Builder(
            builder: (context) {
              return Scaffold(

                body: BlocProvider(
                  create: (BuildContext context) => MenuBloc(
                      MenuService()
                  )..add(AddItemsEvent(context,category,foodCategories,menuContext)),
                  child: BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
                    if(state is MenuLoadingState) {
                      return Container(
                        child: AlertDialog(
                          title: Text('Add new item'),
                          content: Container(
                            height: 400,
                            width: 400,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: CircularProgressIndicator())
                              ],
                            ),
                          ),

                        ),
                      );
                    }

                    if(state is MenuLoadedState) {
                      return StatefulBuilder(builder: (BuildContext newContext, void Function(void Function()) setState) {
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
                                    controller: item,
                                    // dropdownItems: MenuEditorVariables.items == [] ? [] : MenuEditorVariables.items ,
                                    // isDropdown: true,
                                    // showSearchBox1: true,
                                    // dropdownAuto: true,
                                    digitsAndLetters: true,
                                    displayCount: true,
                                  ),

                                ],
                              ),
                            ),
                            actions: [
                              InkWell(
                                onTap: () {
                                  MenuEditorVariables.itemAddType = "imported";
                                  MenuEditorVariables.isItemDropdown = false;
                                  Navigator.of(context).pop(); // Close the AlertDialog
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

                                  String oldTag = "";

                                  Map<String, dynamic> oneItem = {};

                                  item.text = item.text.trim();

                                  String firstCharacter = item.text.isNotEmpty
                                      ? item.text[0]
                                      : '';

                                  bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                                      (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
                                          '0123456789'.contains(firstCharacter)));

                                  if(item.text.trim().length < 3)
                                  {
                                    Flushbar(
                                      title: "Display name validation",
                                      message: "Display name should have minimum 3 characters",
                                      backgroundGradient: LinearGradient(colors: [GlobalVariables.textColor, Colors.teal]),
                                      backgroundColor: Colors.red,
                                      boxShadows: [BoxShadow(color: GlobalVariables.textColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
                                      duration: Duration(seconds: 2),
                                    )..show(context);
                                  }
                                  else if(!isFirstCharacterLetterOrDigit) {
                                    GlobalFunction.showSnackBar(newContext, "Display name should start with either digit or letter.");
                                  }
                                  else {
                                    String itemId = "";
                                    String name = "";
                                    bool itemExists = false;
                                    for (final itemName in foodCategories[category]!) {
                                      print("Item name ${foodCategories[category]} ${itemName['name']}");
                                      if (item.text == itemName['disName']) {

                                        print("Item already exists");
                                        itemExists = true;
                                        break; // Exit the loop as soon as we find a match
                                      }
                                    }

                                    if (itemExists) {
                                      Navigator.of(context).pop();
                                      showAlreadyExistAlert(context);
                                    }
                                    else {

                                      // Item doesn't exist, add it to the list
                                      for (final entry in foodCategories.entries) {
                                        final categoryKey = entry.key;
                                        final categoryItems = entry.value;
                                        int index = -1;

                                        for (final itemName in categoryItems) {
                                          index = index + 1;
                                          if (item.text == itemName['disName']) {
                                            print("Item already exists in category: $categoryKey");
                                            MenuEditorVariables.findItemIndex = index;
                                            itemId = itemName['ritem_UId'];
                                            name = itemName['disName'];
                                            oldTag = categoryKey;
                                            oneItem = itemName;
                                            requestBody = {
                                              "ritem_UId" : itemName['_id'],
                                              "ritem_name" : itemName['name'],
                                              "ritem_dispname" : itemName['disName'],
                                              "ritem_normalPrice" : itemName['normalPrice'],
                                              "ritem_packagePrice" : itemName['packagePrice'],
                                              "ritem_preorderPrice" : itemName['preorderPrice'],
                                              "ritem_available_type" : itemName['ritem_available_type'],
                                              'ritem_half_price' : itemName['ritem_half_price'],
                                              "ritem_half_normalPrice" : itemName['ritem_half_normalPrice'],
                                              "ritem_half_preorderPrice" : itemName['ritem_half_preorderPrice'],
                                              "ritem_normalFinalPrice" : itemName['ritem_normalFinalPrice'],
                                              "ritem_half_normalFinalPrice" : itemName['ritem_half_normalFinalPrice'],
                                              "ritem_preorderFinalPrice" : itemName['ritem_preorderFinalPrice'],
                                              "ritem_half_preorderFinalPrice" : itemName['ritem_half_preorderFinalPrice'],
                                              "ritem_priceRange" : itemName['priceRange'],
                                              "ritem_itemType" : itemName['itemType'],
                                              "ritem_itemSubType" : itemName['itemSubType'],
                                              "ritem_comboType" : itemName['comboType'],
                                              "ritem_rawSource" : itemName['rawSource'],
                                              "ritem_category" : itemName['category'],
                                              "ritem_subCategory" : itemName['subCategory'],
                                              "ritem_cuisine" : itemName['cuisine'],
                                              "ritem_regional" : itemName['regional'],
                                              "ritem_availability" : itemName['availability'],
                                              "fp_unit_avail_days_and_meals": {
                                                "Sun": {
                                                  "BreakfastSession1" : itemName['sunBreakfastSession1'],
                                                  "BreakfastSession2" : itemName['sunBreakfastSession2'],
                                                  "BreakfastSession3" : itemName['sunBreakfastSession3'],
                                                  "LunchSession1" : itemName['sunLunchSession1'],
                                                  "LunchSession2" : itemName['sunLunchSession2'],
                                                  "LunchSession3" : itemName['sunLunchSession3'],
                                                  "DinnerSession1" : itemName['sunDinnerSession1'],
                                                  "DinnerSession2" : itemName['sunDinnerSession2'],
                                                  "DinnerSession3" : itemName['sunDinnerSession3'],
                                                },
                                                "Mon": {
                                                  "BreakfastSession1" : itemName['monBreakfastSession1'],
                                                  "BreakfastSession2" : itemName['monBreakfastSession2'],
                                                  "BreakfastSession3" : itemName['monBreakfastSession3'],
                                                  "LunchSession1" : itemName['monLunchSession1'],
                                                  "LunchSession2" : itemName['monLunchSession2'],
                                                  "LunchSession3" : itemName['monLunchSession3'],
                                                  "DinnerSession1" : itemName['monDinnerSession1'],
                                                  "DinnerSession2" : itemName['monDinnerSession2'],
                                                  "DinnerSession3" : itemName['monDinnerSession3'],
                                                },
                                                "Tue": {
                                                  "BreakfastSession1" : itemName['tueBreakfastSession1'],
                                                  "BreakfastSession2" : itemName['tueBreakfastSession2'],
                                                  "BreakfastSession3" : itemName['tueBreakfastSession3'],
                                                  "LunchSession1" : itemName['tueLunchSession1'],
                                                  "LunchSession2" : itemName['tueLunchSession2'],
                                                  "LunchSession3" : itemName['tueLunchSession3'],
                                                  "DinnerSession1" : itemName['tueDinnerSession1'],
                                                  "DinnerSession2" : itemName['tueDinnerSession2'],
                                                  "DinnerSession3" : itemName['tueDinnerSession3'],
                                                },
                                                "Wed": {
                                                  "BreakfastSession1" : itemName['wedBreakfastSession1'],
                                                  "BreakfastSession2" : itemName['wedBreakfastSession2'],
                                                  "BreakfastSession3" : itemName['wedBreakfastSession3'],
                                                  "LunchSession1" : itemName['wedLunchSession1'],
                                                  "LunchSession2" : itemName['wedLunchSession2'],
                                                  "LunchSession3" : itemName['wedLunchSession3'],
                                                  "DinnerSession1" : itemName['wedDinnerSession1'],
                                                  "DinnerSession2" : itemName['wedDinnerSession2'],
                                                  "DinnerSession3" : itemName['wedDinnerSession3'],
                                                },
                                                "Thu": {
                                                  "BreakfastSession1" : itemName['thuBreakfastSession1'],
                                                  "BreakfastSession2" : itemName['thuBreakfastSession2'],
                                                  "BreakfastSession3" : itemName['thuBreakfastSession3'],
                                                  "LunchSession1" : itemName['thuLunchSession1'],
                                                  "LunchSession2" : itemName['thuLunchSession2'],
                                                  "LunchSession3" : itemName['thuLunchSession3'],
                                                  "DinnerSession1" : itemName['thuDinnerSession1'],
                                                  "DinnerSession2" : itemName['thuDinnerSession2'],
                                                  "DinnerSession3" : itemName['thuDinnerSession3'],
                                                },
                                                "Fri": {
                                                  "BreakfastSession1" : itemName['friBreakfastSession1'],
                                                  "BreakfastSession2" : itemName['friBreakfastSession2'],
                                                  "BreakfastSession3" : itemName['friBreakfastSession3'],
                                                  "LunchSession1" : itemName['friLunchSession1'],
                                                  "LunchSession2" : itemName['friLunchSession2'],
                                                  "LunchSession3" : itemName['friLunchSession3'],
                                                  "DinnerSession1" : itemName['friDinnerSession1'],
                                                  "DinnerSession2" : itemName['friDinnerSession2'],
                                                  "DinnerSession3" : itemName['friDinnerSession3'],
                                                },
                                                "Sat": {
                                                  "BreakfastSession1" : itemName['satBreakfastSession1'],
                                                  "BreakfastSession2" : itemName['satBreakfastSession2'],
                                                  "BreakfastSession3" : itemName['satBreakfastSession3'],
                                                  "LunchSession1" : itemName['satLunchSession1'],
                                                  "LunchSession2" : itemName['satLunchSession2'],
                                                  "LunchSession3" : itemName['satLunchSession3'],
                                                  "DinnerSession1" : itemName['satDinnerSession1'],
                                                  "DinnerSession2" : itemName['satDinnerSession2'],
                                                  "DinnerSession3" : itemName['satDinnerSession3'],
                                                },
                                              },
                                            };

                                            itemExists = true;
                                            break; // Exit the loop as soon as we find a match
                                          }
                                        }
                                        if (itemExists) {
                                          break; // Exit the outer loop if the item exists
                                        }
                                      }

                                      if(itemExists) {
                                        Navigator.of(context).pop();
                                        showReplaceItemAlert(context,menuContext,itemId,category,name,requestBody,oldTag,oneItem);
                                      }
                                      else {
                                        // Map<String, dynamic> newItem = {'name': item.text, 'availability': true};
                                        // foodCategories[category]!.add(newItem);
                                        menuContext.read<MenuBloc>().add(AddMenuItemEvent(context, item.text, category,MenuEditorVariables.itemAddType));
                                        Navigator.of(context).pop();
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
                    return Container(
                      child: AlertDialog(
                        title: Text('Add new item'),
                        content: Container(
                          height: 400,
                          width: 400,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator()
                            ],
                          ),
                        ),

                      ),
                    );

                  },

                  ),
                ),
              );
            }
          ),
        );
      },
    );
  }

  static void showAddItemDialogCreated(String category,BuildContext context,BuildContext menuContext,Map<String, List<Map<String,dynamic>>> foodCategories ) {
    TextEditingController item = TextEditingController();
    Map<String,dynamic> requestBody = {};
    MenuEditorVariables.findItemIndex = 0;
    showDialog(
      context: context,
      builder: (BuildContext contexts) {
        return Container(
          child: AlertDialog(
            title: Text('Adding new item'),
            content: Container(
              height: 400,
              width: 400,
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Type your item name',
                    width: 400,
                    height: 50,
                    controller: item,
                    // dropdownItems: [''],
                    // isDropdown: true,
                    // showSearchBox1: true,
                    // dropdownAuto: true,
                    digitsAndLetters: true,
                    displayCount: true,
                  ),

                ],
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(); // Close the AlertDialog
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

                  String oldTag ="";

                  Map<String, dynamic> oneItem = {};

                  item.text = item.text.trim();

                  String firstCharacter = item.text.isNotEmpty
                      ? item.text[0]
                      : '';

                  bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                      (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
                          '0123456789'.contains(firstCharacter)));

                  if(item.text.trim().length < 3)
                  {
                    Flushbar(
                      title: "Display name validation",
                      message: "Display name should have minimum 3 characters",
                      backgroundGradient: LinearGradient(colors: [GlobalVariables.textColor, Colors.teal]),
                      backgroundColor: Colors.red,
                      boxShadows: [BoxShadow(color: GlobalVariables.textColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
                      duration: Duration(seconds: 2),
                    )..show(context);
                  }
                  else if(!isFirstCharacterLetterOrDigit) {
                    Flushbar(
                      title: "Display name validation",
                      message: "Display name should start with either digit or letter.",
                      backgroundGradient: LinearGradient(colors: [GlobalVariables.textColor, Colors.teal]),
                      backgroundColor: Colors.red,
                      boxShadows: [BoxShadow(color: GlobalVariables.textColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
                      duration: Duration(seconds: 2),
                    )..show(context);

                  }
                  else {
                    String itemId = "";
                    String name = "";
                    bool itemExists = false;

                    for (final itemName in foodCategories[category]!) {

                      print("Item name ${foodCategories[category]} ${itemName['name']}");
                      if (item.text == itemName['disName']) {

                        print("Item already exists");
                        itemExists = true;
                        break; // Exit the loop as soon as we find a match
                      }
                    }

                    if (itemExists) {
                      Navigator.of(context).pop();
                      showAlreadyExistAlert(context);
                    }
                    else {
                      // Item doesn't exist, add it to the list
                      for (final entry in foodCategories.entries) {
                        final categoryKey = entry.key;
                        final categoryItems = entry.value;
                        int index = -1;

                        for (final itemName in categoryItems) {
                          index = index + 1;
                          if (item.text == itemName['disName']) {
                            print("Item already exists in category: $categoryKey");
                            MenuEditorVariables.findItemIndex = index;
                            itemId = itemName['_id'];
                            name = itemName['disName'];
                            oldTag = categoryKey;
                            oneItem = itemName;
                            requestBody = {
                              "ritem_UId" : itemName['ritem_UId'],
                              "ritem_name" : itemName['name'],
                              "ritem_dispname" : itemName['disName'],
                              "ritem_normalPrice" : itemName['normalPrice'],
                              "ritem_packagePrice" : itemName['packagePrice'],
                              "ritem_preorderPrice" : itemName['preorderPrice'],
                              "ritem_available_type" : itemName['ritem_available_type'],
                              'ritem_half_price' : itemName['ritem_half_price'],
                              "ritem_half_normalPrice" : itemName['ritem_half_normalPrice'],
                              "ritem_half_preorderPrice" : itemName['ritem_half_preorderPrice'],
                              "ritem_normalFinalPrice" : itemName['ritem_normalFinalPrice'],
                              "ritem_half_normalFinalPrice" : itemName['ritem_half_normalFinalPrice'],
                              "ritem_preorderFinalPrice" : itemName['ritem_preorderFinalPrice'],
                              "ritem_half_preorderFinalPrice" : itemName['ritem_half_preorderFinalPrice'],
                              "ritem_priceRange" : itemName['priceRange'],
                              "ritem_itemType" : itemName['itemType'],
                              "ritem_itemSubType" : itemName['itemSubType'],
                              "ritem_comboType" : itemName['comboType'],
                              "ritem_rawSource" : itemName['rawSource'],
                              "ritem_category" : itemName['category'],
                              "ritem_subCategory" : itemName['subCategory'],
                              "ritem_cuisine" : itemName['cuisine'],
                              "ritem_regional" : itemName['regional'],
                              "ritem_availability" : itemName['availability'],
                              "fp_unit_avail_days_and_meals": {
                                "Sun": {
                                  "BreakfastSession1" : itemName['sunBreakfastSession1'],
                                  "BreakfastSession2" : itemName['sunBreakfastSession2'],
                                  "BreakfastSession3" : itemName['sunBreakfastSession3'],
                                  "LunchSession1" : itemName['sunLunchSession1'],
                                  "LunchSession2" : itemName['sunLunchSession2'],
                                  "LunchSession3" : itemName['sunLunchSession3'],
                                  "DinnerSession1" : itemName['sunDinnerSession1'],
                                  "DinnerSession2" : itemName['sunDinnerSession2'],
                                  "DinnerSession3" : itemName['sunDinnerSession3'],
                                },
                                "Mon": {
                                  "BreakfastSession1" : itemName['monBreakfastSession1'],
                                  "BreakfastSession2" : itemName['monBreakfastSession2'],
                                  "BreakfastSession3" : itemName['monBreakfastSession3'],
                                  "LunchSession1" : itemName['monLunchSession1'],
                                  "LunchSession2" : itemName['monLunchSession2'],
                                  "LunchSession3" : itemName['monLunchSession3'],
                                  "DinnerSession1" : itemName['monDinnerSession1'],
                                  "DinnerSession2" : itemName['monDinnerSession2'],
                                  "DinnerSession3" : itemName['monDinnerSession3'],
                                },
                                "Tue": {
                                  "BreakfastSession1" : itemName['tueBreakfastSession1'],
                                  "BreakfastSession2" : itemName['tueBreakfastSession2'],
                                  "BreakfastSession3" : itemName['tueBreakfastSession3'],
                                  "LunchSession1" : itemName['tueLunchSession1'],
                                  "LunchSession2" : itemName['tueLunchSession2'],
                                  "LunchSession3" : itemName['tueLunchSession3'],
                                  "DinnerSession1" : itemName['tueDinnerSession1'],
                                  "DinnerSession2" : itemName['tueDinnerSession2'],
                                  "DinnerSession3" : itemName['tueDinnerSession3'],
                                },
                                "Wed": {
                                  "BreakfastSession1" : itemName['wedBreakfastSession1'],
                                  "BreakfastSession2" : itemName['wedBreakfastSession2'],
                                  "BreakfastSession3" : itemName['wedBreakfastSession3'],
                                  "LunchSession1" : itemName['wedLunchSession1'],
                                  "LunchSession2" : itemName['wedLunchSession2'],
                                  "LunchSession3" : itemName['wedLunchSession3'],
                                  "DinnerSession1" : itemName['wedDinnerSession1'],
                                  "DinnerSession2" : itemName['wedDinnerSession2'],
                                  "DinnerSession3" : itemName['wedDinnerSession3'],
                                },
                                "Thu": {
                                  "BreakfastSession1" : itemName['thuBreakfastSession1'],
                                  "BreakfastSession2" : itemName['thuBreakfastSession2'],
                                  "BreakfastSession3" : itemName['thuBreakfastSession3'],
                                  "LunchSession1" : itemName['thuLunchSession1'],
                                  "LunchSession2" : itemName['thuLunchSession2'],
                                  "LunchSession3" : itemName['thuLunchSession3'],
                                  "DinnerSession1" : itemName['thuDinnerSession1'],
                                  "DinnerSession2" : itemName['thuDinnerSession2'],
                                  "DinnerSession3" : itemName['thuDinnerSession3'],
                                },
                                "Fri": {
                                  "BreakfastSession1" : itemName['friBreakfastSession1'],
                                  "BreakfastSession2" : itemName['friBreakfastSession2'],
                                  "BreakfastSession3" : itemName['friBreakfastSession3'],
                                  "LunchSession1" : itemName['friLunchSession1'],
                                  "LunchSession2" : itemName['friLunchSession2'],
                                  "LunchSession3" : itemName['friLunchSession3'],
                                  "DinnerSession1" : itemName['friDinnerSession1'],
                                  "DinnerSession2" : itemName['friDinnerSession2'],
                                  "DinnerSession3" : itemName['friDinnerSession3'],
                                },
                                "Sat": {
                                  "BreakfastSession1" : itemName['satBreakfastSession1'],
                                  "BreakfastSession2" : itemName['satBreakfastSession2'],
                                  "BreakfastSession3" : itemName['satBreakfastSession3'],
                                  "LunchSession1" : itemName['satLunchSession1'],
                                  "LunchSession2" : itemName['satLunchSession2'],
                                  "LunchSession3" : itemName['satLunchSession3'],
                                  "DinnerSession1" : itemName['satDinnerSession1'],
                                  "DinnerSession2" : itemName['satDinnerSession2'],
                                  "DinnerSession3" : itemName['satDinnerSession3'],
                                },
                              },
                            };

                            itemExists = true;
                            break; // Exit the loop as soon as we find a match
                          }
                        }
                        if (itemExists) {
                          break; // Exit the outer loop if the item exists
                        }
                      }

                      if(itemExists) {
                        Navigator.of(context).pop();
                        showReplaceItemAlert(context,menuContext,itemId,category,name,requestBody,oldTag,oneItem);
                      }
                      else {
                        // Map<String, dynamic> newItem = {'name': item.text, 'availability': true};
                        // foodCategories[category]!.add(newItem);
                        menuContext.read<MenuBloc>().add(AddMenuItemEvent(context, item.text, category,MenuEditorVariables.itemAddType));
                        Navigator.of(context).pop();
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

  static void showAlreadyExistAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Item already exists in this section",style: GlobalVariables.dataItemStyle,),
          actions: [
            InkWell (
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
                    'Ok',
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

  static void showShouldNotNull(BuildContext context,String tag) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$tag name should not be null",style: GlobalVariables.dataItemStyle,),
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
                    'Ok',
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

  static void showStringLengthAlert(BuildContext context,String tag) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$tag name should have minimum 3 characters\nand maximum 50 characters.",style: GlobalVariables.dataItemStyle,),
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
                    'Ok',
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

  static void showNothingToSaveAlert(BuildContext context,) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("No changes to save.",style: GlobalVariables.dataItemStyle,),
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
                    'Ok',
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

  static void showOnlyDigitAndLettersAlert(BuildContext context,String tag) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$tag name should start with either digit or letter.",style: GlobalVariables.dataItemStyle,),
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
                    'Ok',
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

  static void showPriceShouldNotBeBull(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Price should be greater than 1.",style: GlobalVariables.dataItemStyle,),
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
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'Ok',
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

  static void showPriceShouldNotBeNull(BuildContext context,String message,) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${message}",style: GlobalVariables.dataItemStyle,),
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
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'Ok',
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

  static void showOverlappingMessage(BuildContext context,String message,) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Session Overlapped",style: GlobalVariables.dataItemStyle,),
          content: Container(
            width: 300,
              margin: EdgeInsets.all(15),
              child: Expanded(
                  child: Text("${message}",style: SafeGoogleFont(
                'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: GlobalVariables.textColor,
              ),))),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // Close the AlertDialog

              },
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.primaryColor,
                    border: Border.all(color: GlobalVariables.primaryColor),
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'Ok',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.whiteColor,
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

  static void showPriceShouldNotBeNull1(BuildContext context,String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${message}",style: GlobalVariables.dataItemStyle,),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // Close the AlertDialog
                Navigator.of(context).pop();
              },
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: GlobalVariables.whiteColor,
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(7),
                child: Center(
                  child: Text(
                    'Ok',
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

  static void showReplaceItemAlert(BuildContext context,BuildContext menuContext,String id,String tag,String itemName,Map<String,dynamic> requestBody,String oldTag,Map<String, dynamic> oneItem) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<MenuBloc,MenuState>(builder: ( context, state) {
          return AlertDialog(
            title: Text("Item already exist under different section \ndo you want to replace the section of this item?",style: GlobalVariables.dataItemStyle,),
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
                  MenuEditorVariables.availabilityFlag = false;
                  MenuEditorVariables.priceFlag = false;
                  MenuEditorVariables.displayNameFlag = false;
                  MenuEditorVariables.propertyFlag = false;

                  menuContext.read<MenuBloc>().add(UpdateItemSection(context, id, tag, itemName,requestBody,oldTag,oneItem));
                  Navigator.of(context).pop();
                   // Close the AlertDialog
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
                      'Replace',
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
      },
    );
  }

  static void showReplaceItemAlertSaveChanges(BuildContext context,BuildContext menuContext,String id,String tag,String itemName,Map<String,dynamic> requestBody,String oldTag,Map<String, dynamic> oneItem,String currentId) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<MenuBloc,MenuState>(builder: ( context, state) {
          return AlertDialog(
            title: Text("Item already exist under different section \ndo you want to replace the section of this item?",style: GlobalVariables.dataItemStyle,),
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
                  MenuEditorVariables.availabilityFlag = false;
                  MenuEditorVariables.priceFlag = false;
                  MenuEditorVariables.displayNameFlag = false;
                  MenuEditorVariables.propertyFlag = false;

                  menuContext.read<MenuBloc>().add(ReplaceItemSection(context, id, tag, itemName,requestBody,oldTag,oneItem,currentId));
                  Navigator.of(context).pop();
                  // Close the AlertDialog
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
                      'Replace',
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
      },
    );
  }

  static void showSectionExistAlert(BuildContext context,BuildContext menuContext,String section,final Map<String,dynamic> requestBody) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
          return AlertDialog(
            title: Text("Section already exists in your menu.",style: GlobalVariables.dataItemStyle,),
            actions: [

              InkWell(
                onTap: () {

                  // menuContext.read<MenuBloc>().add(ReplaceSectionEvent(context, section,requestBody));
                  Navigator.of(context).pop();
                  // Close the AlertDialog
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
                      'Ok',
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
      },
    );
  }

  static void showSectionExistAlertWhileUpdating(BuildContext context,BuildContext menuContext,String oldName,String newName) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
          return AlertDialog(
            title: Text("All items under this section will be moved to the $newName.",style: GlobalVariables.dataItemStyle,),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  MenuEditorVariables.tagFlag = false;

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

                  menuContext.read<MenuBloc>().add(UpdateTagNameEvent(context, oldName, newName));
                  MenuEditorVariables.tagFlag = false;
                  Navigator.of(context).pop();
                  // Close the AlertDialog
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
                      'Replace',
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
      },
    );
  }

  static void showBudgetDialog(BuildContext context,) {
    Map<String,dynamic> requestBody = {};
    TextEditingController item = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return MenuEditorVariables.items == [] ? CircularProgressIndicator() : BlocBuilder<MenuBloc,MenuState>(builder: (context, state) {
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
                      controller: item,
                      dropdownItems: ['BUDGET','POCKET FRIENDLY','LUXURY','PREMIUM'],
                      isDropdown: true,
                      dropdownAuto: true,
                    ),

                  ],
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the AlertDialog
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
                    item.text = item.text.trim();
                    MenuEditorVariables.budgetController.text = item.text;
                    Navigator.of(context).pop();
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
      },
    );
  }

  static void showCuisineDialog(BuildContext context,BuildContext menuContext,String id,String displayName) {
    TextEditingController item = TextEditingController();
    Map<String,dynamic> requestBody = {};
    showDialog(
      context: context,
      builder: (BuildContext contexts) {
        return BlocProvider(
          create: (BuildContext context) => MenuBloc(
              MenuService()
          )..add(AddCuisineEvent(context,menuContext,id,displayName)),
          child: BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
            if(state is MenuLoadingState) {
              return Container(
                child: AlertDialog(
                  title: Text('Add item cuisine'),
                  content: Container(
                    height: 400,
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator())
                      ],
                    ),
                  ),

                ),
              );
            }
            if(state is MenuLoadedState) {
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
                          controller: item,
                          dropdownItems: MenuEditorVariables.cuisine == [] ? ["Fetching items..."] : MenuEditorVariables.cuisine ,
                          isDropdown: true,
                          dropdownAuto: true,
                          showSearchBox1: true,
                        ),

                      ],
                    ),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the AlertDialog
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
                        item.text = item.text.trim();
                        if(item.text !=  "") {
                          MenuEditorVariables.cuisineController.text = item.text;
                          Map<String,dynamic> requestBody = {
                            "ritem_cuisine" : MenuEditorVariables.cuisineController.text
                          };

                          menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, id, requestBody, displayName));

                          Navigator.of(context).pop();
                        }else{
                          showSnackBar(context, "Cuisine name should not be empty");
                        }
                      },
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                            color: GlobalVariables.primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(7),
                        child: Center(
                          child: Text(
                            'Add & save',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 13,
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
            }
            return Container(
              child: AlertDialog(
                title: Text('Add item cuisine'),
                content: Container(
                  height: 400,
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator()
                    ],
                  ),
                ),

              ),
            );

          },

          ),
        );
      },
    );
  }

  static void showRegionalDialogs(BuildContext context,BuildContext menuContext,String id,String displayName) {
    TextEditingController item = TextEditingController();
    Map<String,dynamic> requestBody = {};
    showDialog(
      context: context,
      builder: (BuildContext contexts) {
        return BlocProvider(
          create: (BuildContext context) => MenuBloc(
              MenuService()
          )..add(AddRegionalEvent(context,menuContext,id,displayName)),
          child: BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
            if(state is MenuLoadingState) {
              return Container(
                child: AlertDialog(
                  title: Text('Add item cuisine'),
                  content: Container(
                    height: 400,
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator())
                      ],
                    ),
                  ),

                ),
              );
            }
            if(state is MenuLoadedState) {
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
                          controller: item,
                          dropdownItems: MenuEditorVariables.regional == [] ? ["Fetching items..."] : MenuEditorVariables.regional ,
                          isDropdown: true,
                          dropdownAuto: true,
                          showSearchBox1: true,
                        ),

                      ],
                    ),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the AlertDialog
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
                        item.text = item.text.trim();
                        if(item.text !=  "") {
                          MenuEditorVariables.regionalController.text = item.text;
                          Map<String,dynamic> requestBody = {
                            "ritem_regional" : MenuEditorVariables.regionalController.text
                          };

                          menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, id, requestBody, displayName));

                          Navigator.of(context).pop();
                        }else{
                          showSnackBar(context, "Regional name should not be empty");
                        }
                      },
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                            color: GlobalVariables.primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(7),
                        child: Center(
                          child: Text(
                            'Add & save',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 13,
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
            }
            return Container(
              child: AlertDialog(
                title: Text('Add item cuisine'),
                content: Container(
                  height: 400,
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator()
                    ],
                  ),
                ),

              ),
            );

          },

          ),
        );
      },
    );
  }

  static void showSubCategoriesDialogs(BuildContext context,BuildContext menuContext,String id,String displayName,String type) {
    TextEditingController item = TextEditingController();
    Map<String,dynamic> requestBody = {};
    showDialog(
      context: context,
      builder: (BuildContext contexts) {
        return BlocProvider(
          create: (BuildContext context) => MenuBloc(
              MenuService()
          )..add(AddSubcategoryEvent(context,menuContext,type,id,displayName,)),
          child: BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
            if(state is MenuLoadingState) {
              return Container(
                child: AlertDialog(
                  title: Text('Add item sub category'),
                  content: Container(
                    height: 400,
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator())
                      ],
                    ),
                  ),

                ),
              );
            }
            if(state is MenuLoadedState) {
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
                          controller: item,
                          dropdownItems: MenuEditorVariables.subCategory == [] ? ["Fetching items..."] : MenuEditorVariables.subCategory ,
                          isDropdown: true,
                          dropdownAuto: true,
                          showSearchBox1: true,
                        ),

                      ],
                    ),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the AlertDialog
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
                        item.text = item.text.trim();
                        if(item.text !=  "") {
                          MenuEditorVariables.subCategoryController.text = item.text;
                          Map<String,dynamic> requestBody = {
                            "ritem_category" : MenuEditorVariables.categoryController.text,
                            "ritem_subCategory" : MenuEditorVariables.subCategoryController.text
                          };

                          menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, id, requestBody, displayName));

                          Navigator.of(context).pop();
                        }else{
                          showSnackBar(context, "sub category name should not be empty");
                        }
                      },
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                            color: GlobalVariables.primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(7),
                        child: Center(
                          child: Text(
                            'Add & save',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 13,
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
            }
            return Container(
              child: AlertDialog(
                title: Text('Add item cuisine'),
                content: Container(
                  height: 400,
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator()
                    ],
                  ),
                ),

              ),
            );

          },

          ),
        );
      },
    );
  }

  static void showRegionalDialog(BuildContext context,BuildContext menuContext,String id,String displayName) {
    TextEditingController item = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (BuildContext context) => MenuBloc(
              MenuService()
          )..add(AddRegionalEvent(context,menuContext,id,displayName)),
          child: BlocBuilder<MenuBloc,MenuState>(builder: (mcontext, state) {
            // MenuEditorVariables.regional =  MenuEditorVariables.regional.where((item) => item.trim().isNotEmpty).toList();

            if(state is MenuLoadingState) {
              return Container(
                child: AlertDialog(
                  title: Text('Add item regional'),
                  content: Container(
                    height: 400,
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator())
                      ],
                    ),
                  ),

                ),
              );
            }
            if(state is MenuLoadedState) {
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
                          controller: item,
                          dropdownItems: MenuEditorVariables.regional == [] ? ["Fetching items..."] : MenuEditorVariables.regional ,
                          isDropdown: true,
                          dropdownAuto: true,
                          showSearchBox1: true,
                        ),

                      ],
                    ),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the AlertDialog
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
                        item.text = item.text.trim();

                        if(item.text !=  "") {
                          MenuEditorVariables.regionalController.text = item.text;
                          Map<String,dynamic> requestBody = {
                            "ritem_regional" : MenuEditorVariables.regionalController.text
                          };
                          mcontext.read<MenuBloc>().add(UpdateLiveMenuEvent(mcontext, id, requestBody, displayName));
                          Navigator.of(context).pop();
                        }else{
                          showSnackBar(context, "Cuisine name should not be empty");
                        }
                        // MenuEditorVariables.regionalController.text = item.text;
                        //
                        // Map<String,dynamic> requestBody = {
                        //   "ritem_regional" : MenuEditorVariables.regionalController.text
                        // };
                        //
                        // mcontext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, id, requestBody, displayName));
                        // Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                            color: GlobalVariables.primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(7),
                        child: Center(
                          child: Text(
                            'Add & save',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 13,
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
            }
            return Container(
              child: AlertDialog(
                title: Text('Add item regional'),
                content: Container(
                  height: 400,
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator())
                    ],
                  ),
                ),

              ),
            );
          },

          ),
        );
      },
    );
  }

  static void showSubcategoryDialog(BuildContext context,BuildContext menuContext,String id,String displayName) {
    TextEditingController item = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return MenuEditorVariables.subCategory == [] ? CircularProgressIndicator() :
        BlocBuilder<MenuBloc,MenuState>(builder: (mcontext, state) {
          MenuEditorVariables.subCategory = MenuEditorVariables.subCategory.where((item) => item.trim().isNotEmpty).toList();
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
                      controller: item,
                      dropdownItems: MenuEditorVariables.subCategory == [] ? ["Fetching items..."] : MenuEditorVariables.subCategory ,
                      isDropdown: true,
                      dropdownAuto: true,
                      showSearchBox1: true,
                    ),

                  ],
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the AlertDialog
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
                    item.text = item.text.trim();
                    MenuEditorVariables.subCategoryController.text = item.text;
                    Map<String,dynamic> requestBody = {
                      "ritem_subCategory" : MenuEditorVariables.subCategoryController.text
                    };

                    mcontext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, id, requestBody, displayName));
                    Navigator.of(context).pop();
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
      },
    );
  }



  static void handleNonVegChange(BuildContext context,bool? value) {
    context.read<MenuBloc>().add(HandleNonVegEvent(context, value!));
  }

  static void handleVegChange(BuildContext context,bool? value,) {
    context.read<MenuBloc>().add(HandleVegEvent(context, value!));
  }

  static void handleFoodChange(BuildContext context,bool? value,) {
    context.read<MenuBloc>().add(HandleFoodEvent(context, value!));
  }

  static void handleBeverageChange(BuildContext context,bool? value,) {
    context.read<MenuBloc>().add(HandleBeverageEvent(context, value!));
  }

  static void handleBreakfastChange(BuildContext context,bool? value,) {
    context.read<MenuBloc>().add(HandleBreakfastEvent(context, value!));
  }

  static void handleLunchChange(BuildContext context,bool? value,) {
    context.read<MenuBloc>().add(HandleLunchEvent(context, value!));
  }

  static void handleDinnerChange(BuildContext context,bool? value,) {
    context.read<MenuBloc>().add(HandleDinnerEvent(context, value!));
  }

  static void handleBudgetChange(BuildContext context,bool? value,) {
    context.read<MenuBloc>().add(HandleBudgetEvent(context, value!));
  }

  static void handlePocketFriendlyChange(BuildContext context,bool? value,) {
    context.read<MenuBloc>().add(HandlePocketFriendlyEvent(context, value!));
  }

  static void handlePremiumChange(BuildContext context,bool? value,) {
    context.read<MenuBloc>().add(HandlePremiumEvent(context, value!));
  }

  static void handleLuxuryChange(BuildContext context,bool? value,) {
    context.read<MenuBloc>().add(HandleLuxuryEvent(context, value!));
  }

  static void showFilterAlert(BuildContext showContext,) {
    TextEditingController item = TextEditingController();
    Map<String,dynamic> requestBody = {};
    MenuEditorVariables.isTagDropdown = true;
    MenuEditorVariables.tagAddType = "imported";
    showDialog(
      context: showContext,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 350,
            height: 500,
            child: CustomPopupMenuItem(
              isVegChecked: MenuEditorVariables.isVegChecked,
              isNonVegChecked: MenuEditorVariables.isNonVegChecked,
              onVegChanged: MenuEditorFunction.handleVegChange,
              onNonVegChanged: MenuEditorFunction.handleNonVegChange,
              onFoodChanged: MenuEditorFunction.handleFoodChange,
              onBeverageChanged: MenuEditorFunction.handleBeverageChange,
              onBreakfastChanged: MenuEditorFunction.handleBreakfastChange,
              onLunchChanged: MenuEditorFunction.handleLunchChange,
              onDinnerChanged: MenuEditorFunction.handleDinnerChange,
              onBudgetChanged: MenuEditorFunction.handleBudgetChange,
              onPocketFriendlyChanged: MenuEditorFunction.handlePocketFriendlyChange,
              onLuxuryChanged: MenuEditorFunction.handleLuxuryChange,
              onPremiumChanged: MenuEditorFunction.handlePremiumChange,
              isFoodChecked: MenuEditorVariables.isFood, isBeverageChecked: MenuEditorVariables.isBeverage, isBreakfastChecked: MenuEditorVariables.isBreakfast, isLunchChecked: MenuEditorVariables.isLunch, isDinnerChecked: MenuEditorVariables.isDinner, isBudgetChecked: MenuEditorVariables.isBudget, isPocketFriendlyChecked: MenuEditorVariables.isPocketFriendly, isLuxuryChecked: MenuEditorVariables.isLuxury, isPremiumChecked: MenuEditorVariables.isPremium,
            ),
          ),
        );
      },
    );
  }

  static Map<String, dynamic> getUnitAvailDaysAndMeals(Map<String, dynamic> daysMealSession1) {
    final meals = ['Breakfast', 'Lunch', 'Dinner'];
    final sessions = ['S1', 'S2', 'S3', 'S4'];
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    Map<String, dynamic> unitAvailDaysAndMeals = {};

    for (var day in days) {
      unitAvailDaysAndMeals[day] = {};

      for (var meal in meals) {
        for (int i = 0; i < sessions.length; i++) {
          String sessionName = '${meal}Session${i + 1}';
          unitAvailDaysAndMeals[day][sessionName] = daysMealSession1[day]![meal]![sessions[i]]!['count'];
        }
      }
    }

    return unitAvailDaysAndMeals;
  }

  static Map<String, Map<String, List<String>>> getSessionsWithCountGreaterThanZero() {
    Map<String, Map<String, List<String>>> result = {};

    // Iterate through each day in the map
    MenuEditorVariables.daysMealSession1.forEach((day, meals) {
      Map<String, List<String>> mealsWithSessions = {};

      // Iterate through each meal type (Breakfast, Lunch, Dinner)
      meals.forEach((mealType, sessions) {
        List<String> sessionsWithCountGreaterThanZero = [];

        // Iterate through each session in the current meal type
        sessions.forEach((session, details) {
          // Check if the count is greater than zero
          if (details["count"] > 0) {
            sessionsWithCountGreaterThanZero.add(session);
          }
        });

        // Only add the meal type if there are sessions with count greater than zero
        if (sessionsWithCountGreaterThanZero.isNotEmpty) {
          mealsWithSessions[mealType] = sessionsWithCountGreaterThanZero;
        }
      });

      // Only add the day if there are any meals with sessions
      if (mealsWithSessions.isNotEmpty) {
        result[day] = mealsWithSessions;
      }
    });

    return result;
  }



  static bool checkSessionsAndOverlap(BuildContext context, Map<String, Map<String, List<String>>> result, BuildContext menuContext, MenuLoadedState menuState)  {

    TimeOfDay s1EndTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']!['Session1']!['EndTime']);
    TimeOfDay s2EndTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']!['Session2']!['EndTime']);
    TimeOfDay s2StartTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']!['Session2']!['StartTime']);
    TimeOfDay s3StartTime = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']!['Session3']!['StartTime']);

    for (var entry in result.entries) {
      String day = entry.key;
      Map<String, List<String>> meals = entry.value;

      for (var mealEntry in meals.entries) {
        String meal = mealEntry.key;
        List<String> sessions = mealEntry.value;

        if (sessions.length == 2) {
          if (sessions.contains("S1") && sessions.contains("S2")) {
            print("Containing S1 and S2");
            int overlapSession1AndSession2 = ManageSettingFunction.compareTimeOfDay(s1EndTime, s2StartTime);
            if (overlapSession1AndSession2 > 0) {
              print("Session 1 and session 2 are overlapping");
               MenuEditorFunction.showOverlappingMessage(context, "Session 2 overlapping with session1 Select either S1 or S2 for $day");

              return false; // Stop further processing
            }
          }
          else if (sessions.contains("S1") && sessions.contains("S3")) {
            print("Containing S1 and S3");
            int overlapSession1AndSession3 = ManageSettingFunction.compareTimeOfDay(s1EndTime, s3StartTime);
            if (overlapSession1AndSession3 > 0) {
              print("Session 1 and session 3 are overlapping");
               MenuEditorFunction.showOverlappingMessage(context, "Session 3 overlapping with session1 Select either S1 or S3 for $day");
              return false; // Stop further processing
            }
          }
          else if (sessions.contains("S2") && sessions.contains("S3")) {
            print("Containing S2 and S3");
            int overlapSession2AndSession3 = ManageSettingFunction.compareTimeOfDay(s2EndTime, s3StartTime);
            if (overlapSession2AndSession3 > 0) {
              print("Session 2 and session 3 are overlapping");
               MenuEditorFunction.showOverlappingMessage(context, "Session 3 overlapping with session 2 Select either S2 or S3 for $day");
              return false; // Stop further processing
            }
          }
        }
        else if (sessions.length == 3) {
          int overlap3Sessions = ManageSettingFunction.compareTimeOfDay(s1EndTime, s3StartTime);
          int overlapSession1AndSession2 = ManageSettingFunction.compareTimeOfDay(s1EndTime, s2StartTime);
          int overlapSession1AndSession3 = ManageSettingFunction.compareTimeOfDay(s1EndTime, s3StartTime);
          int overlapSession2AndSession3 = ManageSettingFunction.compareTimeOfDay(s2EndTime, s3StartTime);
          if (overlap3Sessions > 0) {
            print("All 3 sessions are overlapping");
             MenuEditorFunction.showOverlappingMessage(context, "Session 2 and session 3 overlapping with session 1 Select any one session at $day");
            return false; // Stop further processing
          }
          else if (overlapSession1AndSession2 > 0) {
            MenuEditorFunction.showPriceShouldNotBeNull(context, "Session 2 timings overlapping with session 1 timings, you can not have same item in overlapping sessions");

            return false; // Stop further processing
          }
          else  if (overlapSession1AndSession3 > 0) {
            print("Session 1 and session 3 are overlapping");
            MenuEditorFunction.showOverlappingMessage(context, "Session 3 overlapping with session1 Select either S1 or S3 for $day");
            return false; // Stop further processing
          } else if (overlapSession2AndSession3 > 0) {
            print("Session 2 and session 3 are overlapping");
            MenuEditorFunction.showOverlappingMessage(context, "Session 3 overlapping with session 2 Select either S2 or S3 for $day");
            return false; // Stop further processing
          }
        }
      }
    }

    return true;
  }


  static void saveChangesItem(BuildContext context,MenuLoadedState menuState,BuildContext menuContext,Map<String, List<Map<String,dynamic>>> foodCategories) {
    MenuEditorVariables.displayNameController.text = MenuEditorVariables.displayNameController.text.trim();
    print("In menu editor function ${MenuEditorVariables.displayNameController.text}");

    int totalCount = (MenuEditorVariables.priceFlag ? 1 : 0) + (MenuEditorVariables.displayNameFlag ? 1 : 0)  + (MenuEditorVariables.propertyFlag ? 1 : 0) + (MenuEditorVariables.availabilityFlag ? 1 : 0);

    print(totalCount);

    switch(totalCount) {
      case 0:
        showNothingToSaveAlert(context);
      case 1:
        {
          if(MenuEditorVariables.priceFlag) {
            if(MenuEditorVariables.halfSelected)
              {
              halfPriceValidations(context, menuContext, menuState);
              }
            else {
              priceValidations(context, menuContext, menuState);
            }

          }
          else if(MenuEditorVariables.displayNameFlag)
            {
              if(MenuEditorVariables.selectedItem == MenuEditorVariables.displayNameController.text){
                showNothingToSaveAlert(context);
              }
              else {
                MenuEditorVariables.displayNameController.text = MenuEditorVariables.displayNameController.text.trim();

                String firstCharacter = MenuEditorVariables.displayNameController.text.isNotEmpty
                    ? MenuEditorVariables.displayNameController.text[0]
                    : '';

                bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                    (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
                        '0123456789'.contains(firstCharacter)));

                if(MenuEditorVariables.displayNameController.text.trim() == "") {
                  MenuEditorFunction.showShouldNotNull(context,"Display");
                } else if(MenuEditorVariables.displayNameController.text.trim().length <3){
                  MenuEditorFunction.showStringLengthAlert(context, "Display name");
                } else if(!isFirstCharacterLetterOrDigit) {
                  MenuEditorFunction.showOnlyDigitAndLettersAlert(context, "Display name");
                } else {
                  bool itemExists = false;
                  String name = "";
                  String oldTag = "";
                  String itemId = "";
                  Map<String, dynamic> oneItem = {};
                  String id = MenuEditorVariables.selectItem['_id'];


                  MenuEditorVariables.requestBody = {
                    "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                    "ritem_tag" : MenuEditorVariables.tagController.text,
                    "ritem_UId" : MenuEditorVariables.selectItem['uId'],
                  };

                  for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                    if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                      print("Item already exists");
                      name = itemName['disName'];
                      itemExists = true;
                      break; // Exit the loop as soon as we find a match
                    }
                  }

                  if (itemExists) {
                    MenuEditorFunction.showAlreadyExistAlert(context);
                  } else {
                    for (final categoryItems in foodCategories.values) {
                      for (final itemName in categoryItems) {
                        if (MenuEditorVariables.displayNameController.text == itemName['disName']) {
                          print("Item already exists ${itemName}");
                          itemId = itemName['_id'];
                          name = itemName['disName'];
                          oldTag = itemName['tag'];
                          oneItem = itemName;
                          itemExists = true;
                          break; // Exit the loop as soon as we find a match
                        }
                      }
                      if (itemExists) {
                        break; // Exit the outer loop if the item exists
                      }
                    }
                    if (itemExists) {
                      // Navigator.of(context).pop();
                      MenuEditorFunction.showReplaceItemAlertSaveChanges(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem,id);
                    }
                    else {
                      menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
                      MenuEditorVariables.displayNameFlag = false;
                    }
                  }

                }

              }
            }
          else if(MenuEditorVariables.propertyFlag){
            print("Property flag enabled");
            if(MenuEditorVariables.budgetController.text == 'SELECT')
            {
            MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the price range it should not be null');
            }
            else if(MenuEditorVariables.comboController.text == 'SELECT')
            {
              MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the combo type it should not be null');
            }
            else if(MenuEditorVariables.typeController.text == 'SELECT')
            {
              MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item type it should not be null');
            }
            else if(MenuEditorVariables.subTypeController.text == 'SELECT' || MenuEditorVariables.subTypeController.text == 'SELECT ' )
            {
              MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item sub type it should not be null');
            }
            else if(MenuEditorVariables.categoryController.text == 'SELECT')
            {
              MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item category it should not be null');
            } else {
              MenuEditorVariables.requestBody = {
                "ritem_priceRange": MenuEditorVariables.budgetController.text,
                "ritem_itemType": MenuEditorVariables.typeController.text,
                "ritem_itemSubType": MenuEditorVariables.subTypeController.text,
                "ritem_comboType": MenuEditorVariables.comboController.text,
                "ritem_rawSource": MenuEditorVariables.rawSourceController.text,
                "ritem_category": MenuEditorVariables.categoryController.text,
                "ritem_subCategory": MenuEditorVariables.subCategoryController.text,
                "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                "ritem_regional": MenuEditorVariables.regionalController.text,
                'ritem_consumption_mode' : MenuEditorVariables.consumptionMode
              };

              menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));

              MenuEditorVariables.propertyFlag = false;
            }

          }
          else {

            Map<String, Map<String, List<String>>> result = getSessionsWithCountGreaterThanZero();

            bool res = checkSessionsAndOverlap(context, result, menuContext, menuState);

            if(res) {

              bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);
              if (!isAllZero && MenuEditorVariables.selectedOption == 1) {
                MenuEditorFunction.showPriceShouldNotBeNull(context, 'Set count for at least one session');
              } else {
                MenuEditorVariables.requestBody = {
                  "ritem_dispname": MenuEditorVariables.selectItem['disName'],
                  "ritem_tag": MenuEditorVariables.tagController.text,
                  "ritem_UId": MenuEditorVariables.selectItem['uId'],
                  "fp_unit_avail_days_and_meals": getUnitAvailDaysAndMeals(MenuEditorVariables.daysMealSession1),
                  "ritem_available_type": MenuEditorVariables.selectedOption
                };

                menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
                MenuEditorVariables.availabilityFlag = false;
              }

            }
          }
        }
      case 2:
        {
          if(MenuEditorVariables.priceFlag && MenuEditorVariables.displayNameFlag)
          {
              if(MenuEditorVariables.halfSelected)
              {
                if(halfPriceValidation(context, menuContext, menuState)) {
                  if(MenuEditorVariables.selectedItem == MenuEditorVariables.displayNameController.text){
                    showNothingToSaveAlert(context);
                  }
                  else {
                    MenuEditorVariables.displayNameController.text = MenuEditorVariables.displayNameController.text.trim();

                    String firstCharacter = MenuEditorVariables.displayNameController.text.isNotEmpty
                        ? MenuEditorVariables.displayNameController.text[0]
                        : '';

                    bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                        (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
                            '0123456789'.contains(firstCharacter)));

                    if(MenuEditorVariables.displayNameController.text.trim() == "") {
                      MenuEditorFunction.showShouldNotNull(context,"Display");
                    } else if(MenuEditorVariables.displayNameController.text.trim().length <3){
                      MenuEditorFunction.showStringLengthAlert(context, "Display name");
                    } else if(!isFirstCharacterLetterOrDigit) {
                      MenuEditorFunction.showOnlyDigitAndLettersAlert(context, "Display name");
                    } else {
                      bool itemExists = false;
                      String name = "";
                      String oldTag = "";
                      String itemId = "";
                      String id = MenuEditorVariables.selectItem['_id'];
                      Map<String, dynamic> oneItem = {};
                      MenuEditorVariables.requestBody = {
                        "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                        "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                        "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                        "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                        "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                        "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                        "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                        "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                        "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                        "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                        'ritem_half_price' : MenuEditorVariables.halfSelected,
                      };

                      for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                        if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                          print("Item already exists");
                          name = itemName['disName'];
                          itemExists = true;
                          break; // Exit the loop as soon as we find a match
                        }
                      }

                      if (itemExists) {
                        MenuEditorFunction.showAlreadyExistAlert(context);
                      } else {
                        for (final categoryItems in foodCategories.values) {
                          for (final itemName in categoryItems) {
                            if (MenuEditorVariables.displayNameController.text == itemName['disName']) {
                              print("Item already exists");
                              itemId = itemName['_id'];
                              name = itemName['disName'];
                              oldTag = itemName['tag'];
                              oneItem = itemName;
                              itemExists = true;
                              break; // Exit the loop as soon as we find a match
                            }
                          }
                          if (itemExists) {
                            break; // Exit the outer loop if the item exists
                          }
                        }
                        if (itemExists) {
                          // Navigator.of(context).pop();
                          MenuEditorFunction.showReplaceItemAlertSaveChanges(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem,id);
                        }
                        else {
                          menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
                          MenuEditorVariables.displayNameFlag = false;
                          MenuEditorVariables.priceFlag = false;
                        }
                      }

                    }

                  }
                }
              }
              else {
                if(priceValidation(context, menuContext, menuState)) {
                  if(MenuEditorVariables.selectedItem == MenuEditorVariables.displayNameController.text){
                    showNothingToSaveAlert(context);
                  }
                  else {
                    MenuEditorVariables.displayNameController.text = MenuEditorVariables.displayNameController.text.trim();

                    String firstCharacter = MenuEditorVariables.displayNameController.text.isNotEmpty
                        ? MenuEditorVariables.displayNameController.text[0]
                        : '';

                    bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                        (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
                            '0123456789'.contains(firstCharacter)));

                    if(MenuEditorVariables.displayNameController.text.trim() == "") {
                      MenuEditorFunction.showShouldNotNull(context,"Display");
                    } else if(MenuEditorVariables.displayNameController.text.trim().length <3){
                      MenuEditorFunction.showStringLengthAlert(context, "Display name");
                    } else if(!isFirstCharacterLetterOrDigit) {
                      MenuEditorFunction.showOnlyDigitAndLettersAlert(context, "Display name");
                    } else {
                      bool itemExists = false;
                      String name = "";
                      String oldTag = "";
                      String itemId = "";
                      Map<String, dynamic> oneItem = {};
                      String id = MenuEditorVariables.selectItem['_id'];
                      MenuEditorVariables.requestBody = {
                        "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                        "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                        "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                        "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                        "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                        "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                        "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                        "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                        "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                        "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                        'ritem_half_price' : MenuEditorVariables.halfSelected,
                      };

                      for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                        if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                          print("Item already exists");
                          name = itemName['disName'];
                          itemExists = true;
                          break; // Exit the loop as soon as we find a match
                        }
                      }

                      if (itemExists) {
                        MenuEditorFunction.showAlreadyExistAlert(context);
                      } else {
                        for (final categoryItems in foodCategories.values) {
                          for (final itemName in categoryItems) {
                            if (MenuEditorVariables.displayNameController.text == itemName['disName']) {
                              print("Item already exists");
                              itemId = itemName['_id'];
                              name = itemName['disName'];
                              oldTag = itemName['tag'];
                              oneItem = itemName;
                              itemExists = true;
                              break; // Exit the loop as soon as we find a match
                            }
                          }
                          if (itemExists) {
                            break; // Exit the outer loop if the item exists
                          }
                        }
                        if (itemExists) {
                          // Navigator.of(context).pop();
                          MenuEditorFunction.showReplaceItemAlertSaveChanges(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem,id);
                        }
                        else {
                          menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
                          MenuEditorVariables.displayNameFlag = false;
                          MenuEditorVariables.priceFlag = false;
                        }
                      }

                    }

                  }
                }
              }
            }
          else if(MenuEditorVariables.priceFlag && MenuEditorVariables.propertyFlag)
          {
            if(MenuEditorVariables.halfSelected)
            {
              if(halfPriceValidation(context, menuContext, menuState)) {
                if(MenuEditorVariables.budgetController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the price range it should not be null');
                }
                else if(MenuEditorVariables.comboController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the combo type it should not be null');
                }
                else if(MenuEditorVariables.typeController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item type it should not be null');
                }
                else if(MenuEditorVariables.subTypeController.text == 'SELECT' || MenuEditorVariables.subTypeController.text == 'SELECT ' )
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item sub type it should not be null');
                }
                else if(MenuEditorVariables.categoryController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item category it should not be null');
                }
                else {
                  MenuEditorVariables.requestBody = {
                    "ritem_normalPrice": MenuEditorVariables
                        .normalPriceController.text,
                    "ritem_half_normalPrice": MenuEditorVariables
                        .halfNormalPriceController.text,
                    "ritem_packagePrice": MenuEditorVariables
                        .packagindController.text,
                    "ritem_preorderPrice": MenuEditorVariables
                        .preorderPriceController.text,
                    "ritem_half_preorderPrice": MenuEditorVariables
                        .halfPreorderPriceController.text,
                    "ritem_normalFinalPrice": MenuEditorVariables
                        .normalFinalPrice,
                    "ritem_preorderFinalPrice": MenuEditorVariables
                        .preOrderFinalPrice,
                    "ritem_half_normalFinalPrice": MenuEditorVariables
                        .halfNormalFinalPrice,
                    "ritem_half_preorderFinalPrice": MenuEditorVariables
                        .halfPreOrderFinalPrice,
                    'ritem_half_price': MenuEditorVariables.halfSelected,
                    "ritem_priceRange": MenuEditorVariables.budgetController
                        .text,
                    "ritem_itemType": MenuEditorVariables.typeController.text,
                    "ritem_itemSubType": MenuEditorVariables.subTypeController
                        .text,
                    "ritem_comboType": MenuEditorVariables.comboController.text,
                    "ritem_rawSource": MenuEditorVariables.rawSourceController
                        .text,
                    "ritem_category": MenuEditorVariables.categoryController
                        .text,
                    "ritem_subCategory": MenuEditorVariables
                        .subCategoryController.text,
                    "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                    "ritem_regional": MenuEditorVariables.regionalController
                        .text,
                    'ritem_consumption_mode': MenuEditorVariables
                        .consumptionMode
                  };

                  menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(
                      context, menuState.menuItem["_id"],
                      MenuEditorVariables.requestBody,
                      menuState.menuItem['disName']));

                  MenuEditorVariables.propertyFlag = false;
                  MenuEditorVariables.priceFlag = false;
                }
              }
            }
            else {
              if(priceValidation(context, menuContext, menuState)) {
                if(MenuEditorVariables.budgetController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the price range it should not be null');
                }
                else if(MenuEditorVariables.comboController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the combo type it should not be null');
                }
                else if(MenuEditorVariables.typeController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item type it should not be null');
                }
                else if(MenuEditorVariables.subTypeController.text == 'SELECT' || MenuEditorVariables.subTypeController.text == 'SELECT ' )
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item sub type it should not be null');
                }
                else if(MenuEditorVariables.categoryController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item category it should not be null');
                }
                else {
                  MenuEditorVariables.requestBody = {
                    "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                    "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                    "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                    "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                    "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                    "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                    "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                    "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                    "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                    'ritem_half_price' : MenuEditorVariables.halfSelected,
                    "ritem_priceRange": MenuEditorVariables.budgetController.text,
                    "ritem_itemType": MenuEditorVariables.typeController.text,
                    "ritem_itemSubType": MenuEditorVariables.subTypeController.text,
                    "ritem_comboType": MenuEditorVariables.comboController.text,
                    "ritem_rawSource": MenuEditorVariables.rawSourceController.text,
                    "ritem_category": MenuEditorVariables.categoryController.text,
                    "ritem_subCategory": MenuEditorVariables.subCategoryController.text,
                    "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                    "ritem_regional": MenuEditorVariables.regionalController.text,
                    'ritem_consumption_mode' : MenuEditorVariables.consumptionMode
                  };

                  menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));

                  MenuEditorVariables.propertyFlag = false;
                  MenuEditorVariables.priceFlag = false;
                }
              }
            }
          }
          else if(MenuEditorVariables.propertyFlag && MenuEditorVariables.displayNameFlag)
          {
            if(MenuEditorVariables.selectedItem == MenuEditorVariables.displayNameController.text){
              showNothingToSaveAlert(context);
            }
            else {
              MenuEditorVariables.displayNameController.text = MenuEditorVariables.displayNameController.text.trim();

              String firstCharacter = MenuEditorVariables.displayNameController.text.isNotEmpty
                  ? MenuEditorVariables.displayNameController.text[0]
                  : '';

              bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                  (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
                      '0123456789'.contains(firstCharacter)));

              if(MenuEditorVariables.displayNameController.text.trim() == "") {
                MenuEditorFunction.showShouldNotNull(context,"Display");
              } else if(MenuEditorVariables.displayNameController.text.trim().length <3){
                MenuEditorFunction.showStringLengthAlert(context, "Display name");
              } else if(!isFirstCharacterLetterOrDigit) {
                MenuEditorFunction.showOnlyDigitAndLettersAlert(context, "Display name");
              } if(MenuEditorVariables.budgetController.text == 'SELECT')
              {
                MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the price range it should not be null');
              }
              else if(MenuEditorVariables.comboController.text == 'SELECT')
              {
                MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the combo type it should not be null');
              }
              else if(MenuEditorVariables.typeController.text == 'SELECT')
              {
                MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item type it should not be null');
              }
              else if(MenuEditorVariables.subTypeController.text == 'SELECT' || MenuEditorVariables.subTypeController.text == 'SELECT ' )
              {
                MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item sub type it should not be null');
              }
              else if(MenuEditorVariables.categoryController.text == 'SELECT')
              {
                MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item category it should not be null');
              } else {
                bool itemExists = false;
                String name = "";
                String oldTag = "";
                String itemId = "";
                Map<String, dynamic> oneItem = {};
                String id = MenuEditorVariables.selectItem['_id'];
                MenuEditorVariables.requestBody = {
                  "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                  "ritem_priceRange": MenuEditorVariables.budgetController.text,
                  "ritem_itemType": MenuEditorVariables.typeController.text,
                  "ritem_itemSubType": MenuEditorVariables.subTypeController.text,
                  "ritem_comboType": MenuEditorVariables.comboController.text,
                  "ritem_rawSource": MenuEditorVariables.rawSourceController.text,
                  "ritem_category": MenuEditorVariables.categoryController.text,
                  "ritem_subCategory": MenuEditorVariables.subCategoryController.text,
                  "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                  "ritem_regional": MenuEditorVariables.regionalController.text,
                };

                for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                  if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                    print("Item already exists");
                    name = itemName['disName'];
                    itemExists = true;
                    break; // Exit the loop as soon as we find a match
                  }
                }

                if (itemExists) {
                  MenuEditorFunction.showAlreadyExistAlert(context);
                } else {
                  for (final categoryItems in foodCategories.values) {
                    for (final itemName in categoryItems) {
                      if (MenuEditorVariables.displayNameController.text == itemName['disName']) {
                        print("Item already exists");
                        itemId = itemName['_id'];
                        name = itemName['disName'];
                        oldTag = itemName['tag'];
                        oneItem = itemName;
                        itemExists = true;
                        break; // Exit the loop as soon as we find a match
                      }
                    }
                    if (itemExists) {
                      break; // Exit the outer loop if the item exists
                    }
                  }
                  if (itemExists) {
                    // Navigator.of(context).pop();
                    MenuEditorFunction.showReplaceItemAlertSaveChanges(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem,id);
                  }
                  else {
                    menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
                    MenuEditorVariables.displayNameFlag = false;
                    MenuEditorVariables.propertyFlag = false;
                  }
                }

              }

            }
          }
          else if(MenuEditorVariables.priceFlag && MenuEditorVariables.availabilityFlag) {
            if(MenuEditorVariables.halfSelected){
              if(halfPriceValidation(context, menuContext, menuState))
              {
                bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);

                if(!isAllZero && MenuEditorVariables.selectedOption == 1) {
                  showPriceShouldNotBeNull(context, 'Set count for at least one session');
                } else {

                  MenuEditorVariables.requestBody = {
                    "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                    "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                    "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                    "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                    "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                    "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                    "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                    "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                    "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                    'ritem_half_price' : MenuEditorVariables.halfSelected,
                    "fp_unit_avail_days_and_meals": {
                      "Sun": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S4']!['count'],
                      },
                      "Mon": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S4']!['count'],
                      },
                      "Tue": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                      },
                      "Wed": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S4']!['count'],
                      },
                      "Thu": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S4']!['count'],
                      },
                      "Fri": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S4']!['count'],
                      },
                      "Sat": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                      },
                    },
                    "ritem_available_type" : MenuEditorVariables.selectedOption
                  };

                  menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));

                  MenuEditorVariables.availabilityFlag = false;
                  MenuEditorVariables.priceFlag = false;
                  // showFlushBarAvailability(context);
                }
              }
            }
            else {
              if(priceValidation(context, menuContext, menuState))
              {
                bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);

                if(!isAllZero && MenuEditorVariables.selectedOption == 1) {
                  showPriceShouldNotBeNull(context, 'Set count for at least one session');
                }
                else {

                  MenuEditorVariables.requestBody = {
                    "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                    "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                    "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                    "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                    "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                    "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                    "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                    "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                    "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                    'ritem_half_price' : MenuEditorVariables.halfSelected,
                    "fp_unit_avail_days_and_meals": {
                      "Sun": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S4']!['count'],
                      },
                      "Mon": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S4']!['count'],
                      },
                      "Tue": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                      },
                      "Wed": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S4']!['count'],
                      },
                      "Thu": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S4']!['count'],
                      },
                      "Fri": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S4']!['count'],
                      },
                      "Sat": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                      },
                    },
                    "ritem_available_type" : MenuEditorVariables.selectedOption
                  };

                  menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));

                  MenuEditorVariables.availabilityFlag = false;
                  MenuEditorVariables.priceFlag = false;
                  // showFlushBarAvailability(context);
                }
              }
            }

          }

          else if(MenuEditorVariables.displayNameFlag && MenuEditorVariables.availabilityFlag) {
            if(displayNameVaidation(context, menuContext, menuState)) {
              bool itemExists = false;
              String name = "";
              String oldTag = "";
              String itemId = "";
              Map<String, dynamic> oneItem = {};
              String id = MenuEditorVariables.selectItem['_id'];
              MenuEditorVariables.requestBody = {
                "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
              };

              for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                  print("Item already exists");
                  name = itemName['disName'];
                  itemExists = true;
                  break; // Exit the loop as soon as we find a match
                }
              }

              if (itemExists) {
                MenuEditorFunction.showAlreadyExistAlert(context);
              } else {
                for (final categoryItems in foodCategories.values) {
                  for (final itemName in categoryItems) {
                    if (MenuEditorVariables.displayNameController.text == itemName['disName']) {
                      print("Item already exists");
                      itemId = itemName['_id'];
                      name = itemName['disName'];
                      oldTag = itemName['tag'];
                      oneItem = itemName;
                      itemExists = true;
                      break; // Exit the loop as soon as we find a match
                    }
                  }
                  if (itemExists) {
                    break; // Exit the outer loop if the item exists
                  }
                }
                if (itemExists) {
                  MenuEditorFunction.showReplaceItemAlertSaveChanges(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem,id);
                }
                else {
                  bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);
                  if(!isAllZero && MenuEditorVariables.selectedOption == 1) {
                    showPriceShouldNotBeNull(context, 'Set count for at least one session');
                  }

                  else {
                    MenuEditorVariables.requestBody = {
                      "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                      "fp_unit_avail_days_and_meals": {
                        "Sun": {
                          "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S1']!['count'],
                          "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S2']!['count'],
                          "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S3']!['count'],
                          "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S4']!['count'],
                          "LunchSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S1']!['count'],
                          "LunchSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S2']!['count'],
                          "LunchSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S3']!['count'],
                          "LunchSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S4']!['count'],
                          "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S1']!['count'],
                          "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S2']!['count'],
                          "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S3']!['count'],
                          "DinnerSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S4']!['count'],
                        },
                        "Mon": {
                          "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S1']!['count'],
                          "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S2']!['count'],
                          "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S3']!['count'],
                          "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S4']!['count'],
                          "LunchSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S1']!['count'],
                          "LunchSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S2']!['count'],
                          "LunchSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S3']!['count'],
                          "LunchSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S4']!['count'],
                          "DinnerSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S1']!['count'],
                          "DinnerSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S2']!['count'],
                          "DinnerSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S3']!['count'],
                          "DinnerSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S4']!['count'],
                        },
                        "Tue": {
                          "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S1']!['count'],
                          "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S2']!['count'],
                          "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S3']!['count'],
                          "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S4']!['count'],
                          "LunchSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S1']!['count'],
                          "LunchSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S2']!['count'],
                          "LunchSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S3']!['count'],
                          "LunchSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S4']!['count'],
                          "DinnerSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S1']!['count'],
                          "DinnerSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S2']!['count'],
                          "DinnerSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S3']!['count'],
                          "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                        },
                        "Wed": {
                          "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S1']!['count'],
                          "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S2']!['count'],
                          "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S3']!['count'],
                          "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S4']!['count'],
                          "LunchSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S1']!['count'],
                          "LunchSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S2']!['count'],
                          "LunchSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S3']!['count'],
                          "LunchSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S4']!['count'],
                          "DinnerSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S1']!['count'],
                          "DinnerSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S2']!['count'],
                          "DinnerSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S3']!['count'],
                          "DinnerSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S4']!['count'],
                        },
                        "Thu": {
                          "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S1']!['count'],
                          "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S2']!['count'],
                          "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S3']!['count'],
                          "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S4']!['count'],
                          "LunchSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S1']!['count'],
                          "LunchSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S2']!['count'],
                          "LunchSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S3']!['count'],
                          "LunchSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S4']!['count'],
                          "DinnerSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S1']!['count'],
                          "DinnerSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S2']!['count'],
                          "DinnerSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S3']!['count'],
                          "DinnerSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S4']!['count'],
                        },
                        "Fri": {
                          "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S1']!['count'],
                          "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S2']!['count'],
                          "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S3']!['count'],
                          "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S4']!['count'],
                          "LunchSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S1']!['count'],
                          "LunchSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S2']!['count'],
                          "LunchSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S3']!['count'],
                          "LunchSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S4']!['count'],
                          "DinnerSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S1']!['count'],
                          "DinnerSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S2']!['count'],
                          "DinnerSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S3']!['count'],
                          "DinnerSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S4']!['count'],
                        },
                        "Sat": {
                          "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S1']!['count'],
                          "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S2']!['count'],
                          "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S3']!['count'],
                          "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S4']!['count'],
                          "LunchSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S1']!['count'],
                          "LunchSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S2']!['count'],
                          "LunchSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S3']!['count'],
                          "LunchSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S4']!['count'],
                          "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S1']!['count'],
                          "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S2']!['count'],
                          "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S3']!['count'],
                          "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                        },
                      },
                      "ritem_available_type" : MenuEditorVariables.selectedOption
                    };

                    menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
                    MenuEditorVariables.displayNameFlag = false;
                    MenuEditorVariables.availabilityFlag = false;

                    // showFlushBarAvailability(context);
                  }

                }
              }
            }
          }
          else if(MenuEditorVariables.propertyFlag && MenuEditorVariables.availabilityFlag) {
            if(propertyValidation(context, menuContext, menuState)) {
              bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);
              if(!isAllZero && MenuEditorVariables.selectedOption == 1) {
                showPriceShouldNotBeNull(context, 'Set count for at least one session');
              } else {
                MenuEditorVariables.requestBody = {
                  "fp_unit_avail_days_and_meals": {
                    "Sun": {
                      "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S1']!['count'],
                      "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S2']!['count'],
                      "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S3']!['count'],
                      "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S4']!['count'],
                      "LunchSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S1']!['count'],
                      "LunchSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S2']!['count'],
                      "LunchSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S3']!['count'],
                      "LunchSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S4']!['count'],
                      "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S1']!['count'],
                      "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S2']!['count'],
                      "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S3']!['count'],
                      "DinnerSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S4']!['count'],
                    },
                    "Mon": {
                      "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S1']!['count'],
                      "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S2']!['count'],
                      "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S3']!['count'],
                      "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S4']!['count'],
                      "LunchSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S1']!['count'],
                      "LunchSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S2']!['count'],
                      "LunchSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S3']!['count'],
                      "LunchSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S4']!['count'],
                      "DinnerSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S1']!['count'],
                      "DinnerSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S2']!['count'],
                      "DinnerSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S3']!['count'],
                      "DinnerSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S4']!['count'],
                    },
                    "Tue": {
                      "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S1']!['count'],
                      "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S2']!['count'],
                      "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S3']!['count'],
                      "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S4']!['count'],
                      "LunchSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S1']!['count'],
                      "LunchSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S2']!['count'],
                      "LunchSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S3']!['count'],
                      "LunchSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S4']!['count'],
                      "DinnerSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S1']!['count'],
                      "DinnerSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S2']!['count'],
                      "DinnerSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S3']!['count'],
                      "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                    },
                    "Wed": {
                      "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S1']!['count'],
                      "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S2']!['count'],
                      "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S3']!['count'],
                      "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S4']!['count'],
                      "LunchSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S1']!['count'],
                      "LunchSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S2']!['count'],
                      "LunchSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S3']!['count'],
                      "LunchSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S4']!['count'],
                      "DinnerSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S1']!['count'],
                      "DinnerSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S2']!['count'],
                      "DinnerSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S3']!['count'],
                      "DinnerSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S4']!['count'],
                    },
                    "Thu": {
                      "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S1']!['count'],
                      "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S2']!['count'],
                      "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S3']!['count'],
                      "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S4']!['count'],
                      "LunchSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S1']!['count'],
                      "LunchSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S2']!['count'],
                      "LunchSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S3']!['count'],
                      "LunchSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S4']!['count'],
                      "DinnerSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S1']!['count'],
                      "DinnerSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S2']!['count'],
                      "DinnerSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S3']!['count'],
                      "DinnerSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S4']!['count'],
                    },
                    "Fri": {
                      "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S1']!['count'],
                      "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S2']!['count'],
                      "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S3']!['count'],
                      "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S4']!['count'],
                      "LunchSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S1']!['count'],
                      "LunchSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S2']!['count'],
                      "LunchSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S3']!['count'],
                      "LunchSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S4']!['count'],
                      "DinnerSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S1']!['count'],
                      "DinnerSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S2']!['count'],
                      "DinnerSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S3']!['count'],
                      "DinnerSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S4']!['count'],
                    },
                    "Sat": {
                      "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S1']!['count'],
                      "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S2']!['count'],
                      "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S3']!['count'],
                      "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S4']!['count'],
                      "LunchSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S1']!['count'],
                      "LunchSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S2']!['count'],
                      "LunchSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S3']!['count'],
                      "LunchSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S4']!['count'],
                      "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S1']!['count'],
                      "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S2']!['count'],
                      "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S3']!['count'],
                      "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                    },
                  },
                  "ritem_available_type" : MenuEditorVariables.selectedOption,
                  "ritem_priceRange": MenuEditorVariables.budgetController.text,
                  "ritem_itemType": MenuEditorVariables.typeController.text,
                  "ritem_itemSubType": MenuEditorVariables.subTypeController.text,
                  "ritem_comboType": MenuEditorVariables.comboController.text,
                  "ritem_rawSource": MenuEditorVariables.rawSourceController.text,
                  "ritem_category": MenuEditorVariables.categoryController.text,
                  "ritem_subCategory": MenuEditorVariables.subCategoryController.text,
                  "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                  "ritem_regional": MenuEditorVariables.regionalController.text,
                };

                menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));

                MenuEditorVariables.availabilityFlag = false;
                MenuEditorVariables.propertyFlag = false;

                // showFlushBarAvailability(context);
              }

            }
          }
        }
      case 3:
      {
        if(MenuEditorVariables.halfSelected)
        {
          if (MenuEditorVariables.priceFlag && MenuEditorVariables.displayNameFlag && MenuEditorVariables.propertyFlag) {
            if(halfPriceValidation(context, menuContext, menuState)) {
              if(displayNameVaidation(context, menuContext, menuState)) {
                if(MenuEditorVariables.budgetController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the price range it should not be null');
                }
                else if(MenuEditorVariables.comboController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the combo type it should not be null');
                }
                else if(MenuEditorVariables.typeController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item type it should not be null');
                }
                else if(MenuEditorVariables.subTypeController.text == 'SELECT' || MenuEditorVariables.subTypeController.text == 'SELECT ' )
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item sub type it should not be null');
                }
                else if(MenuEditorVariables.categoryController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item category it should not be null');
                }
                else {

                  MenuEditorVariables.displayNameController.text =
                      MenuEditorVariables.displayNameController.text.trim();

                  String firstCharacter = MenuEditorVariables.displayNameController
                      .text.isNotEmpty
                      ? MenuEditorVariables.displayNameController.text[0]
                      : '';

                  bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                      (firstCharacter.toUpperCase() !=
                          firstCharacter.toLowerCase() ||
                          '0123456789'.contains(firstCharacter)));

                  if (MenuEditorVariables.displayNameController.text.trim() == "") {
                    MenuEditorFunction.showShouldNotNull(context, "Display");
                  } else if (MenuEditorVariables.displayNameController.text
                      .trim()
                      .length < 3) {
                    MenuEditorFunction.showStringLengthAlert(
                        context, "Display name");
                  } else if (!isFirstCharacterLetterOrDigit) {
                    MenuEditorFunction.showOnlyDigitAndLettersAlert(
                        context, "Display name");
                  } else {
                    bool itemExists = false;
                    String name = "";
                    String oldTag = "";
                    String itemId = "";
                    Map<String, dynamic> oneItem = {};
                    String id = MenuEditorVariables.selectItem['_id'];
                    MenuEditorVariables.requestBody = {
                      "ritem_dispname": MenuEditorVariables.displayNameController
                          .text.trim(),
                      "ritem_normalPrice": MenuEditorVariables.normalPriceController
                          .text,
                      "ritem_half_normalPrice": MenuEditorVariables
                          .halfNormalPriceController.text,
                      "ritem_packagePrice": MenuEditorVariables.packagindController
                          .text,
                      "ritem_preorderPrice": MenuEditorVariables
                          .preorderPriceController.text,
                      "ritem_half_preorderPrice": MenuEditorVariables
                          .halfPreorderPriceController.text,
                      "ritem_normalFinalPrice": MenuEditorVariables
                          .normalFinalPrice,
                      "ritem_preorderFinalPrice": MenuEditorVariables
                          .preOrderFinalPrice,
                      "ritem_half_normalFinalPrice": MenuEditorVariables
                          .halfNormalFinalPrice,
                      "ritem_half_preorderFinalPrice": MenuEditorVariables
                          .halfPreOrderFinalPrice,
                      'ritem_half_price': MenuEditorVariables.halfSelected,
                      "ritem_priceRange": MenuEditorVariables.budgetController.text,
                      "ritem_itemType": MenuEditorVariables.typeController.text,
                      "ritem_itemSubType": MenuEditorVariables.subTypeController
                          .text,
                      "ritem_comboType": MenuEditorVariables.comboController.text,
                      "ritem_rawSource": MenuEditorVariables.rawSourceController
                          .text,
                      "ritem_category": MenuEditorVariables.categoryController.text,
                      "ritem_subCategory": MenuEditorVariables.subCategoryController
                          .text,
                      "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                      "ritem_regional": MenuEditorVariables.regionalController.text,
                    };

                    for (final itemName in foodCategories[MenuEditorVariables
                        .tagController.text]!) {
                      if (MenuEditorVariables.displayNameController.text.trim() ==
                          itemName['disName']) {
                        print("Item already exists");
                        name = itemName['disName'];
                        itemExists = true;
                        break; // Exit the loop as soon as we find a match
                      }
                    }

                    if (itemExists) {
                      MenuEditorFunction.showAlreadyExistAlert(context);
                    } else {
                      for (final categoryItems in foodCategories.values) {
                        for (final itemName in categoryItems) {
                          if (MenuEditorVariables.displayNameController.text ==
                              itemName['disName']) {
                            print("Item already exists");
                            itemId = itemName['_id'];
                            name = itemName['disName'];
                            oldTag = itemName['tag'];
                            oneItem = itemName;
                            itemExists = true;
                            break; // Exit the loop as soon as we find a match
                          }
                        }
                        if (itemExists) {
                          break; // Exit the outer loop if the item exists
                        }
                      }
                      if (itemExists) {
                        MenuEditorFunction.showReplaceItemAlertSaveChanges(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem,id);
                      }
                      else {
                        menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(
                            context, menuState.menuItem["_id"],
                            MenuEditorVariables.requestBody,
                            menuState.menuItem['disName']));
                        MenuEditorVariables.displayNameFlag = false;
                        MenuEditorVariables.propertyFlag = false;
                        MenuEditorVariables.priceFlag = false;
                      }
                    }
                  }
                }
              }
            }
          }
          else if(MenuEditorVariables.priceFlag && MenuEditorVariables.propertyFlag && MenuEditorVariables.availabilityFlag)
          {
            if(halfPriceValidation(context, menuContext, menuState)) {
              if(propertyValidation(context, menuContext, menuState)) {
                bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);
                if(!isAllZero && MenuEditorVariables.selectedOption == 1) {
                  showPriceShouldNotBeNull(context, 'Set count for at least one session');
                }
                else {
                  MenuEditorVariables.requestBody = {
                    "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                    "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                    "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                    "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                    "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                    "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                    "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                    "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                    "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                    'ritem_half_price' : MenuEditorVariables.halfSelected,
                    "fp_unit_avail_days_and_meals": {
                      "Sun": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S4']!['count'],
                      },
                      "Mon": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S4']!['count'],
                      },
                      "Tue": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                      },
                      "Wed": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S4']!['count'],
                      },
                      "Thu": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S4']!['count'],
                      },
                      "Fri": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S4']!['count'],
                      },
                      "Sat": {
                        "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S1']!['count'],
                        "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S2']!['count'],
                        "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S3']!['count'],
                        "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S4']!['count'],
                        "LunchSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S1']!['count'],
                        "LunchSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S2']!['count'],
                        "LunchSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S3']!['count'],
                        "LunchSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S4']!['count'],
                        "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S1']!['count'],
                        "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S2']!['count'],
                        "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S3']!['count'],
                        "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                      },
                    },
                    "ritem_available_type" : MenuEditorVariables.selectedOption,
                    "ritem_priceRange": MenuEditorVariables.budgetController.text,
                    "ritem_itemType": MenuEditorVariables.typeController.text,
                    "ritem_itemSubType": MenuEditorVariables.subTypeController.text,
                    "ritem_comboType": MenuEditorVariables.comboController.text,
                    "ritem_rawSource": MenuEditorVariables.rawSourceController.text,
                    "ritem_category": MenuEditorVariables.categoryController.text,
                    "ritem_subCategory": MenuEditorVariables.subCategoryController.text,
                    "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                    "ritem_regional": MenuEditorVariables.regionalController.text,
                  };

                  menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));

                  MenuEditorVariables.availabilityFlag = false;
                  MenuEditorVariables.propertyFlag = false;
                  MenuEditorVariables.priceFlag = false;

                  // showFlushBarAvailability(context);
                }
              }
            }
          }
          else if(MenuEditorVariables.priceFlag && MenuEditorVariables.displayNameFlag && MenuEditorVariables.availabilityFlag)
          {
            if(halfPriceValidation(context, menuContext, menuState)) {
              if(displayNameVaidation(context, menuContext, menuState))
              {
                bool itemExists = false;
                String name = "";
                String oldTag = "";
                String itemId = "";
                Map<String, dynamic> oneItem = {};
                String id = MenuEditorVariables.selectItem['_id'];
                MenuEditorVariables.requestBody = {
                  "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                };

                for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                  if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                    print("Item already exists");
                    name = itemName['disName'];
                    itemExists = true;
                    break; // Exit the loop as soon as we find a match
                  }
                }

                if (itemExists) {
                  MenuEditorFunction.showAlreadyExistAlert(context);
                }
                else {
                  for (final categoryItems in foodCategories.values) {
                    for (final itemName in categoryItems) {
                      if (MenuEditorVariables.displayNameController.text == itemName['disName']) {
                        print("Item already exists");
                        itemId = itemName['_id'];
                        name = itemName['disName'];
                        oldTag = itemName['tag'];
                        oneItem = itemName;
                        itemExists = true;
                        break; // Exit the loop as soon as we find a match
                      }
                    }
                    if (itemExists) {
                      break; // Exit the outer loop if the item exists
                    }
                  }
                  if (itemExists) {
                    MenuEditorFunction.showReplaceItemAlertSaveChanges(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem,id);
                  }
                  else {
                    bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);
                    if(!isAllZero && MenuEditorVariables.selectedOption == 1) {
                      showPriceShouldNotBeNull(context, 'Set count for at least one session');
                    }
                    else {
                      MenuEditorVariables.requestBody = {
                        "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                        "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                        "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                        "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                        "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                        "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                        "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                        "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                        "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                        'ritem_half_price' : MenuEditorVariables.halfSelected,
                        "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                        "fp_unit_avail_days_and_meals": {
                          "Sun": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S4']!['count'],
                          },
                          "Mon": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S4']!['count'],
                          },
                          "Tue": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                          },
                          "Wed": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S4']!['count'],
                          },
                          "Thu": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S4']!['count'],
                          },
                          "Fri": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S4']!['count'],
                          },
                          "Sat": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                          },
                        },
                        "ritem_available_type" : MenuEditorVariables.selectedOption,
                      };

                      menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
                      MenuEditorVariables.displayNameFlag = false;
                      MenuEditorVariables.availabilityFlag = false;
                      MenuEditorVariables.priceFlag = false;
                      MenuEditorVariables.propertyFlag = false;
                      // showFlushBarAvailability(context);

                    }

                  }
                }
              }
            }

          }
          else if(MenuEditorVariables.displayNameFlag && MenuEditorVariables.propertyFlag && MenuEditorVariables.availabilityFlag) {
            if(displayNameVaidation(context, menuContext, menuState)) {
              if(propertyValidation(context, menuContext, menuState)) {
                bool itemExists = false;
                String name = "";
                String oldTag = "";
                String itemId = "";
                Map<String, dynamic> oneItem = {};
                String id = MenuEditorVariables.selectItem['_id'];
                MenuEditorVariables.requestBody = {
                  "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                };

                for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                  if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                    print("Item already exists");
                    name = itemName['disName'];
                    itemExists = true;
                    break; // Exit the loop as soon as we find a match
                  }
                }

                if (itemExists) {
                  MenuEditorFunction.showAlreadyExistAlert(context);
                }
                else {
                  for (final categoryItems in foodCategories.values) {
                    for (final itemName in categoryItems) {
                      if (MenuEditorVariables.displayNameController.text == itemName['disName']) {
                        print("Item already exists");
                        itemId = itemName['_id'];
                        name = itemName['disName'];
                        oldTag = itemName['tag'];
                        oneItem = itemName;
                        itemExists = true;
                        break; // Exit the loop as soon as we find a match
                      }
                    }
                    if (itemExists) {
                      break; // Exit the outer loop if the item exists
                    }
                  }
                  if (itemExists) {
                    MenuEditorFunction.showReplaceItemAlertSaveChanges(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem,id);
                  }
                  else {
                    bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);
                    if(!isAllZero && MenuEditorVariables.selectedOption == 1) {
                      showPriceShouldNotBeNull(context, 'Set count for at least one session');
                    }
                    else {
                      MenuEditorVariables.requestBody = {
                        "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                        "fp_unit_avail_days_and_meals": {
                          "Sun": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S4']!['count'],
                          },
                          "Mon": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S4']!['count'],
                          },
                          "Tue": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                          },
                          "Wed": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S4']!['count'],
                          },
                          "Thu": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S4']!['count'],
                          },
                          "Fri": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S4']!['count'],
                          },
                          "Sat": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                          },
                        },
                        "ritem_available_type" : MenuEditorVariables.selectedOption,
                        "ritem_priceRange": MenuEditorVariables.budgetController.text,
                        "ritem_itemType": MenuEditorVariables.typeController.text,
                        "ritem_itemSubType": MenuEditorVariables.subTypeController.text,
                        "ritem_comboType": MenuEditorVariables.comboController.text,
                        "ritem_rawSource": MenuEditorVariables.rawSourceController.text,
                        "ritem_category": MenuEditorVariables.categoryController.text,
                        "ritem_subCategory": MenuEditorVariables.subCategoryController.text,
                        "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                        "ritem_regional": MenuEditorVariables.regionalController.text,
                      };

                      menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
                      MenuEditorVariables.displayNameFlag = false;
                      MenuEditorVariables.availabilityFlag = false;
                      MenuEditorVariables.priceFlag = false;
                      MenuEditorVariables.propertyFlag = false;
                      // showFlushBarAvailability(context);
                    }

                  }
                }
              }
            }

          }
        }
        else {
          if (MenuEditorVariables.priceFlag && MenuEditorVariables.displayNameFlag && MenuEditorVariables.propertyFlag) {
            if(priceValidation(context, menuContext, menuState)) {
              if(displayNameVaidation(context, menuContext, menuState)) {
                if(MenuEditorVariables.budgetController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the price range it should not be null');
                }
                else if(MenuEditorVariables.comboController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the combo type it should not be null');
                }
                else if(MenuEditorVariables.typeController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item type it should not be null');
                }
                else if(MenuEditorVariables.subTypeController.text == 'SELECT' || MenuEditorVariables.subTypeController.text == 'SELECT ' )
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item sub type it should not be null');
                }
                else if(MenuEditorVariables.categoryController.text == 'SELECT')
                {
                  MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item category it should not be null');
                }
                else {

                  MenuEditorVariables.displayNameController.text =
                      MenuEditorVariables.displayNameController.text.trim();

                  String firstCharacter = MenuEditorVariables.displayNameController
                      .text.isNotEmpty
                      ? MenuEditorVariables.displayNameController.text[0]
                      : '';

                  bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                      (firstCharacter.toUpperCase() !=
                          firstCharacter.toLowerCase() ||
                          '0123456789'.contains(firstCharacter)));

                  if (MenuEditorVariables.displayNameController.text.trim() == "") {
                    MenuEditorFunction.showShouldNotNull(context, "Display");
                  } else if (MenuEditorVariables.displayNameController.text
                      .trim()
                      .length < 3) {
                    MenuEditorFunction.showStringLengthAlert(
                        context, "Display name");
                  } else if (!isFirstCharacterLetterOrDigit) {
                    MenuEditorFunction.showOnlyDigitAndLettersAlert(
                        context, "Display name");
                  } else {
                    bool itemExists = false;
                    String name = "";
                    String oldTag = "";
                    String itemId = "";
                    Map<String, dynamic> oneItem = {};
                    String id = MenuEditorVariables.selectItem['_id'];
                    MenuEditorVariables.requestBody = {
                      "ritem_dispname": MenuEditorVariables.displayNameController
                          .text.trim(),
                      "ritem_normalPrice": MenuEditorVariables.normalPriceController
                          .text,
                      "ritem_half_normalPrice": MenuEditorVariables
                          .halfNormalPriceController.text,
                      "ritem_packagePrice": MenuEditorVariables.packagindController
                          .text,
                      "ritem_preorderPrice": MenuEditorVariables
                          .preorderPriceController.text,
                      "ritem_half_preorderPrice": MenuEditorVariables
                          .halfPreorderPriceController.text,
                      "ritem_normalFinalPrice": MenuEditorVariables
                          .normalFinalPrice,
                      "ritem_preorderFinalPrice": MenuEditorVariables
                          .preOrderFinalPrice,
                      "ritem_half_normalFinalPrice": MenuEditorVariables
                          .halfNormalFinalPrice,
                      "ritem_half_preorderFinalPrice": MenuEditorVariables
                          .halfPreOrderFinalPrice,
                      'ritem_half_price': MenuEditorVariables.halfSelected,
                      "ritem_priceRange": MenuEditorVariables.budgetController.text,
                      "ritem_itemType": MenuEditorVariables.typeController.text,
                      "ritem_itemSubType": MenuEditorVariables.subTypeController
                          .text,
                      "ritem_comboType": MenuEditorVariables.comboController.text,
                      "ritem_rawSource": MenuEditorVariables.rawSourceController
                          .text,
                      "ritem_category": MenuEditorVariables.categoryController.text,
                      "ritem_subCategory": MenuEditorVariables.subCategoryController
                          .text,
                      "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                      "ritem_regional": MenuEditorVariables.regionalController.text,
                    };

                    for (final itemName in foodCategories[MenuEditorVariables
                        .tagController.text]!) {
                      if (MenuEditorVariables.displayNameController.text.trim() ==
                          itemName['disName']) {
                        print("Item already exists");
                        name = itemName['disName'];
                        itemExists = true;
                        break; // Exit the loop as soon as we find a match
                      }
                    }

                    if (itemExists) {
                      MenuEditorFunction.showAlreadyExistAlert(context);
                    } else {
                      for (final categoryItems in foodCategories.values) {
                        for (final itemName in categoryItems) {
                          if (MenuEditorVariables.displayNameController.text ==
                              itemName['disName']) {
                            print("Item already exists");
                            itemId = itemName['_id'];
                            name = itemName['disName'];
                            oldTag = itemName['tag'];
                            oneItem = itemName;
                            itemExists = true;
                            break; // Exit the loop as soon as we find a match
                          }
                        }
                        if (itemExists) {
                          break; // Exit the outer loop if the item exists
                        }
                      }
                      if (itemExists) {
                        MenuEditorFunction.showReplaceItemAlertSaveChanges(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem,id);
                      }
                      else {
                        menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(
                            context, menuState.menuItem["_id"],
                            MenuEditorVariables.requestBody,
                            menuState.menuItem['disName']));
                        MenuEditorVariables.displayNameFlag = false;
                        MenuEditorVariables.propertyFlag = false;
                        MenuEditorVariables.priceFlag = false;
                      }
                    }
                  }
                }
              }
            }

        }
          else if(MenuEditorVariables.priceFlag && MenuEditorVariables.propertyFlag && MenuEditorVariables.availabilityFlag)
            {
              if(priceValidation(context, menuContext, menuState)) {
                if(propertyValidation(context, menuContext, menuState)) {
                  bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);
                  if(!isAllZero && MenuEditorVariables.selectedOption == 1) {
                    showPriceShouldNotBeNull(context, 'Set count for at least one session');
                  }
                  else {
                    MenuEditorVariables.requestBody = {
                      "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                      "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                      "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                      "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                      "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                      "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                      "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                      "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                      "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                      'ritem_half_price' : MenuEditorVariables.halfSelected,
                      "fp_unit_avail_days_and_meals": {
                        "Sun": {
                          "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S1']!['count'],
                          "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S2']!['count'],
                          "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S3']!['count'],
                          "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S4']!['count'],
                          "LunchSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S1']!['count'],
                          "LunchSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S2']!['count'],
                          "LunchSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S3']!['count'],
                          "LunchSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S4']!['count'],
                          "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S1']!['count'],
                          "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S2']!['count'],
                          "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S3']!['count'],
                          "DinnerSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S4']!['count'],
                        },
                        "Mon": {
                          "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S1']!['count'],
                          "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S2']!['count'],
                          "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S3']!['count'],
                          "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S4']!['count'],
                          "LunchSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S1']!['count'],
                          "LunchSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S2']!['count'],
                          "LunchSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S3']!['count'],
                          "LunchSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S4']!['count'],
                          "DinnerSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S1']!['count'],
                          "DinnerSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S2']!['count'],
                          "DinnerSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S3']!['count'],
                          "DinnerSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S4']!['count'],
                        },
                        "Tue": {
                          "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S1']!['count'],
                          "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S2']!['count'],
                          "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S3']!['count'],
                          "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S4']!['count'],
                          "LunchSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S1']!['count'],
                          "LunchSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S2']!['count'],
                          "LunchSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S3']!['count'],
                          "LunchSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S4']!['count'],
                          "DinnerSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S1']!['count'],
                          "DinnerSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S2']!['count'],
                          "DinnerSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S3']!['count'],
                          "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                        },
                        "Wed": {
                          "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S1']!['count'],
                          "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S2']!['count'],
                          "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S3']!['count'],
                          "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S4']!['count'],
                          "LunchSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S1']!['count'],
                          "LunchSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S2']!['count'],
                          "LunchSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S3']!['count'],
                          "LunchSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S4']!['count'],
                          "DinnerSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S1']!['count'],
                          "DinnerSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S2']!['count'],
                          "DinnerSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S3']!['count'],
                          "DinnerSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S4']!['count'],
                        },
                        "Thu": {
                          "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S1']!['count'],
                          "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S2']!['count'],
                          "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S3']!['count'],
                          "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S4']!['count'],
                          "LunchSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S1']!['count'],
                          "LunchSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S2']!['count'],
                          "LunchSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S3']!['count'],
                          "LunchSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S4']!['count'],
                          "DinnerSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S1']!['count'],
                          "DinnerSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S2']!['count'],
                          "DinnerSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S3']!['count'],
                          "DinnerSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S4']!['count'],
                        },
                        "Fri": {
                          "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S1']!['count'],
                          "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S2']!['count'],
                          "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S3']!['count'],
                          "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S4']!['count'],
                          "LunchSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S1']!['count'],
                          "LunchSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S2']!['count'],
                          "LunchSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S3']!['count'],
                          "LunchSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S4']!['count'],
                          "DinnerSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S1']!['count'],
                          "DinnerSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S2']!['count'],
                          "DinnerSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S3']!['count'],
                          "DinnerSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S4']!['count'],
                        },
                        "Sat": {
                          "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S1']!['count'],
                          "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S2']!['count'],
                          "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S3']!['count'],
                          "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S4']!['count'],
                          "LunchSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S1']!['count'],
                          "LunchSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S2']!['count'],
                          "LunchSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S3']!['count'],
                          "LunchSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S4']!['count'],
                          "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S1']!['count'],
                          "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S2']!['count'],
                          "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S3']!['count'],
                          "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                        },
                      },
                      "ritem_available_type" : MenuEditorVariables.selectedOption,
                      "ritem_priceRange": MenuEditorVariables.budgetController.text,
                      "ritem_itemType": MenuEditorVariables.typeController.text,
                      "ritem_itemSubType": MenuEditorVariables.subTypeController.text,
                      "ritem_comboType": MenuEditorVariables.comboController.text,
                      "ritem_rawSource": MenuEditorVariables.rawSourceController.text,
                      "ritem_category": MenuEditorVariables.categoryController.text,
                      "ritem_subCategory": MenuEditorVariables.subCategoryController.text,
                      "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                      "ritem_regional": MenuEditorVariables.regionalController.text,
                    };

                    menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));

                    MenuEditorVariables.availabilityFlag = false;
                    MenuEditorVariables.propertyFlag = false;
                    MenuEditorVariables.priceFlag = false;
                    // showFlushBarAvailability(context);
                  }
                }
              }
            }
          else if(MenuEditorVariables.priceFlag && MenuEditorVariables.displayNameFlag && MenuEditorVariables.availabilityFlag)
          {
            if(priceValidation(context, menuContext, menuState)) {
              if(displayNameVaidation(context, menuContext, menuState))
                {
                  bool itemExists = false;
                  String name = "";
                  String oldTag = "";
                  String itemId = "";
                  Map<String, dynamic> oneItem = {};
                  String id = MenuEditorVariables.selectItem['_id'];
                  MenuEditorVariables.requestBody = {
                    "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                  };

                  for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                    if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                      print("Item already exists");
                      name = itemName['disName'];
                      itemExists = true;
                      break; // Exit the loop as soon as we find a match
                    }
                  }

                  if (itemExists) {
                    MenuEditorFunction.showAlreadyExistAlert(context);
                  }
                  else {
                    for (final categoryItems in foodCategories.values) {
                      for (final itemName in categoryItems) {
                        if (MenuEditorVariables.displayNameController.text == itemName['disName']) {
                          print("Item already exists");
                          itemId = itemName['_id'];
                          name = itemName['disName'];
                          oldTag = itemName['tag'];
                          oneItem = itemName;
                          itemExists = true;
                          break; // Exit the loop as soon as we find a match
                        }
                      }
                      if (itemExists) {
                        break; // Exit the outer loop if the item exists
                      }
                    }
                    if (itemExists) {
                      MenuEditorFunction.showReplaceItemAlertSaveChanges(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem,id);
                    }
                    else {
                      bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);
                      if(!isAllZero && MenuEditorVariables.selectedOption == 1) {
                        showPriceShouldNotBeNull(context, 'Set count for at least one session');
                      }
                      else {
                        MenuEditorVariables.requestBody = {
                          "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                          "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                          "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                          "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                          "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                          "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                          "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                          "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                          "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                          'ritem_half_price' : MenuEditorVariables.halfSelected,
                          "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                          "fp_unit_avail_days_and_meals": getUnitAvailDaysAndMeals(MenuEditorVariables.daysMealSession1),
                          "ritem_available_type" : MenuEditorVariables.selectedOption,
                        };

                        menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
                        MenuEditorVariables.displayNameFlag = false;
                        MenuEditorVariables.availabilityFlag = false;
                        MenuEditorVariables.priceFlag = false;
                        MenuEditorVariables.propertyFlag = false;
                        // showFlushBarAvailability(context);
                      }

                    }
                  }
                }
            }

          }
          else if(MenuEditorVariables.displayNameFlag && MenuEditorVariables.propertyFlag && MenuEditorVariables.availabilityFlag) {
            if(displayNameVaidation(context, menuContext, menuState)) {
              if(propertyValidation(context, menuContext, menuState)) {
                bool itemExists = false;
                String name = "";
                String oldTag = "";
                String itemId = "";
                Map<String, dynamic> oneItem = {};
                String id = MenuEditorVariables.selectItem['_id'];
                MenuEditorVariables.requestBody = {
                  "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                };

                for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                  if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                    print("Item already exists");
                    name = itemName['disName'];
                    itemExists = true;
                    break; // Exit the loop as soon as we find a match
                  }
                }

                if (itemExists) {
                  MenuEditorFunction.showAlreadyExistAlert(context);
                }
                else {
                  for (final categoryItems in foodCategories.values) {
                    for (final itemName in categoryItems) {
                      if (MenuEditorVariables.displayNameController.text == itemName['disName']) {
                        print("Item already exists");
                        itemId = itemName['_id'];
                        name = itemName['disName'];
                        oldTag = itemName['tag'];
                        oneItem = itemName;
                        itemExists = true;
                        break; // Exit the loop as soon as we find a match
                      }
                    }
                    if (itemExists) {
                      break; // Exit the outer loop if the item exists
                    }
                  }
                  if (itemExists) {
                    MenuEditorFunction.showReplaceItemAlertSaveChanges(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem,id);
                  }
                  else {
                    bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);
                    if(!isAllZero && MenuEditorVariables.selectedOption == 1) {
                      showPriceShouldNotBeNull(context, 'Set count for at least one session');
                    }
                    else {
                      MenuEditorVariables.requestBody = {
                        "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                        "fp_unit_avail_days_and_meals": {
                          "Sun": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S4']!['count'],
                          },
                          "Mon": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S4']!['count'],
                          },
                          "Tue": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                          },
                          "Wed": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S4']!['count'],
                          },
                          "Thu": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S4']!['count'],
                          },
                          "Fri": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S4']!['count'],
                          },
                          "Sat": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                          },
                        },
                        "ritem_available_type" : MenuEditorVariables.selectedOption,
                        "ritem_priceRange": MenuEditorVariables.budgetController.text,
                        "ritem_itemType": MenuEditorVariables.typeController.text,
                        "ritem_itemSubType": MenuEditorVariables.subTypeController.text,
                        "ritem_comboType": MenuEditorVariables.comboController.text,
                        "ritem_rawSource": MenuEditorVariables.rawSourceController.text,
                        "ritem_category": MenuEditorVariables.categoryController.text,
                        "ritem_subCategory": MenuEditorVariables.subCategoryController.text,
                        "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                        "ritem_regional": MenuEditorVariables.regionalController.text,
                      };

                      menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(menuContext, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
                      MenuEditorVariables.displayNameFlag = false;
                      MenuEditorVariables.availabilityFlag = false;
                      MenuEditorVariables.priceFlag = false;
                      MenuEditorVariables.propertyFlag = false;

                    }

                  }
                }
              }
            }

          }
        }

      }

      case 4: {

        if(MenuEditorVariables.halfSelected) {
          if(halfPriceValidation(context, menuContext, menuState)) {
            if(displayNameVaidation(context, menuContext, menuState)) {
              if(propertyValidation(context, menuContext, menuState)) {
                bool itemExists = false;
                String name = "";
                String oldTag = "";
                String itemId = "";
                Map<String, dynamic> oneItem = {};
                String id = MenuEditorVariables.selectItem['_id'];
                MenuEditorVariables.requestBody = {
                  "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                };

                for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                  if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                    print("Item already exists");
                    name = itemName['disName'];
                    itemExists = true;
                    break; // Exit the loop as soon as we find a match
                  }
                }

                if (itemExists) {
                  MenuEditorFunction.showAlreadyExistAlert(context);
                }
                else {
                  for (final categoryItems in foodCategories.values) {
                    for (final itemName in categoryItems) {
                      if (MenuEditorVariables.displayNameController.text == itemName['disName']) {
                        print("Item already exists");
                        itemId = itemName['_id'];
                        name = itemName['disName'];
                        oldTag = itemName['tag'];
                        oneItem = itemName;
                        itemExists = true;
                        break; // Exit the loop as soon as we find a match
                      }
                    }
                    if (itemExists) {
                      break; // Exit the outer loop if the item exists
                    }
                  }
                  if (itemExists) {
                    MenuEditorFunction.showReplaceItemAlertSaveChanges(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem,id);
                  }
                  else {
                    bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);
                    if(!isAllZero && MenuEditorVariables.selectedOption == 1) {
                      showPriceShouldNotBeNull(context, 'Set count for at least one session');
                    }
                    else {
                      MenuEditorVariables.requestBody = {
                        "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                        "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                        "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                        "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                        "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                        "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                        "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                        "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                        "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                        'ritem_half_price' : MenuEditorVariables.halfSelected,
                        "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                        "fp_unit_avail_days_and_meals": {
                          "Sun": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S4']!['count'],
                          },
                          "Mon": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S4']!['count'],
                          },
                          "Tue": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                          },
                          "Wed": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S4']!['count'],
                          },
                          "Thu": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S4']!['count'],
                          },
                          "Fri": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S4']!['count'],
                          },
                          "Sat": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                          },
                        },
                        "ritem_available_type" : MenuEditorVariables.selectedOption,
                        "ritem_priceRange": MenuEditorVariables.budgetController.text,
                        "ritem_itemType": MenuEditorVariables.typeController.text,
                        "ritem_itemSubType": MenuEditorVariables.subTypeController.text,
                        "ritem_comboType": MenuEditorVariables.comboController.text,
                        "ritem_rawSource": MenuEditorVariables.rawSourceController.text,
                        "ritem_category": MenuEditorVariables.categoryController.text,
                        "ritem_subCategory": MenuEditorVariables.subCategoryController.text,
                        "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                        "ritem_regional": MenuEditorVariables.regionalController.text,
                      };

                      menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(menuContext, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
                      MenuEditorVariables.displayNameFlag = false;
                      MenuEditorVariables.availabilityFlag = false;
                      MenuEditorVariables.priceFlag = false;
                      MenuEditorVariables.propertyFlag = false;

                    }

                  }
                }
              }
            }
          }

        }
        else {
          if(priceValidation(context, menuContext, menuState)) {
            if(displayNameVaidation(context, menuContext, menuState)) {
              if(propertyValidation(context, menuContext, menuState)) {
                bool itemExists = false;
                String name = "";
                String oldTag = "";
                String itemId = "";
                Map<String, dynamic> oneItem = {};
                String id = MenuEditorVariables.selectItem['_id'];
                MenuEditorVariables.requestBody = {
                  "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                };

                for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                  if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                    print("Item already exists");
                    name = itemName['disName'];
                    itemExists = true;
                    break; // Exit the loop as soon as we find a match
                  }
                }

                if (itemExists) {
                  MenuEditorFunction.showAlreadyExistAlert(context);
                }
                else {
                  for (final categoryItems in foodCategories.values) {
                    for (final itemName in categoryItems) {
                      if (MenuEditorVariables.displayNameController.text == itemName['disName']) {
                        print("Item already exists");
                        itemId = itemName['_id'];
                        name = itemName['disName'];
                        oldTag = itemName['tag'];
                        oneItem = itemName;
                        itemExists = true;
                        break; // Exit the loop as soon as we find a match
                      }
                    }
                    if (itemExists) {
                      break; // Exit the outer loop if the item exists
                    }
                  }
                  if (itemExists) {
                    MenuEditorFunction.showReplaceItemAlertSaveChanges(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem,id);
                  }
                  else {
                    bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);
                    if(!isAllZero && MenuEditorVariables.selectedOption == 1) {
                      showPriceShouldNotBeNull(context, 'Set count for at least one session');
                    }
                    else {
                      MenuEditorVariables.requestBody = {
                        "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                        "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                        "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                        "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                        "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                        "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                        "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                        "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                        "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                        'ritem_half_price' : MenuEditorVariables.halfSelected,
                        "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                        "fp_unit_avail_days_and_meals": {
                          "Sun": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S4']!['count'],
                          },
                          "Mon": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S4']!['count'],
                          },
                          "Tue": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                          },
                          "Wed": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S4']!['count'],
                          },
                          "Thu": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S4']!['count'],
                          },
                          "Fri": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S4']!['count'],
                          },
                          "Sat": {
                            "BreakfastSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S1']!['count'],
                            "BreakfastSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S2']!['count'],
                            "BreakfastSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S3']!['count'],
                            "BreakfastSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S4']!['count'],
                            "LunchSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S1']!['count'],
                            "LunchSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S2']!['count'],
                            "LunchSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S3']!['count'],
                            "LunchSession4" : MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S4']!['count'],
                            "DinnerSession1" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S1']!['count'],
                            "DinnerSession2" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S2']!['count'],
                            "DinnerSession3" : MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S3']!['count'],
                            "DinnerSession4" : MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S4']!['count'],
                          },
                        },
                        "ritem_available_type" : MenuEditorVariables.selectedOption,
                        "ritem_priceRange": MenuEditorVariables.budgetController.text,
                        "ritem_itemType": MenuEditorVariables.typeController.text,
                        "ritem_itemSubType": MenuEditorVariables.subTypeController.text,
                        "ritem_comboType": MenuEditorVariables.comboController.text,
                        "ritem_rawSource": MenuEditorVariables.rawSourceController.text,
                        "ritem_category": MenuEditorVariables.categoryController.text,
                        "ritem_subCategory": MenuEditorVariables.subCategoryController.text,
                        "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                        "ritem_regional": MenuEditorVariables.regionalController.text,
                      };

                      menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(menuContext, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
                      MenuEditorVariables.displayNameFlag = false;
                      MenuEditorVariables.availabilityFlag = false;
                      MenuEditorVariables.priceFlag = false;
                      MenuEditorVariables.propertyFlag = false;
                    }

                  }
                }
              }
            }
          }
        }

      }
    }

  }

  static bool hasCountGreaterThanZero(Map<String, Map<String, Map<String, Map<String, dynamic>>>> daysMealSession) {
    for (var day in daysMealSession.keys) {
      var meals = daysMealSession[day];
      if (meals == null) continue; // Skip if meals is null

      for (var meal in meals.keys) {
        var sessions = meals[meal];
        if (sessions == null) continue; // Skip if sessions is null

        for (var session in sessions.keys) {
          var sessionDetails = sessions[session];
          if (sessionDetails == null) continue; // Skip if sessionDetails is null

          if (sessionDetails['count'] > 0) {
            return true;
          }
        }
      }
    }
    return false;
  }

  // static void availabilityVaidation(BuildContext context,BuildContext menuContext)

  static void priceValidations(BuildContext context,BuildContext menuContext,MenuLoadedState menuState)
  {
    if ((int.parse(MenuEditorVariables.normalPriceController.text.trim()) < 10 || int.parse(MenuEditorVariables.preorderPriceController.text.trim()) < 10 ) && (int.parse(MenuEditorVariables.normalPriceController.text.trim()) < int.parse(MenuEditorVariables.preorderPriceController.text.trim())))
    {
      showPriceShouldNotBeNull(context,'Normal and preorder price should be greater than 10\nPreorder price should be less than normal price');
    }
    else if(int.parse(MenuEditorVariables.normalPriceController.text.trim()) < 10 || int.parse(MenuEditorVariables.preorderPriceController.text.trim()) < 10  )
    {
      showPriceShouldNotBeNull(context,'Normal and preorder price should be greater than 10');
    }
    else if(int.parse(MenuEditorVariables.normalPriceController.text.trim()) < int.parse(MenuEditorVariables.preorderPriceController.text.trim()))
    {
      showPriceShouldNotBeNull(context,'Preorder price should be less than normal price');
    }
    else {
      MenuEditorVariables.displayNameController.text =
          MenuEditorVariables.displayNameController.text.trim();
      String firstCharacter = MenuEditorVariables.displayNameController
          .text.isNotEmpty
          ? MenuEditorVariables.displayNameController.text[0]
          : '';

      bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
          (firstCharacter.toUpperCase() !=
              firstCharacter.toLowerCase() ||
              '0123456789'.contains(firstCharacter)));

      MenuEditorVariables.requestBody = {
        "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
        "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
        "ritem_packagePrice": MenuEditorVariables.packagindController.text,
        "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
        "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
        "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
        "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
        "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
        "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
        'ritem_half_price' : MenuEditorVariables.halfSelected
      };

      menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
      MenuEditorVariables.priceFlag = false;
    }
  }


  static void halfPriceValidations(BuildContext context,BuildContext menuContext,MenuLoadedState menuState)
  {
    if ((int.parse(MenuEditorVariables.normalPriceController.text.trim()) < 10 || int.parse(MenuEditorVariables.preorderPriceController.text.trim()) < 10 ) && (int.parse(MenuEditorVariables.normalPriceController.text.trim()) < int.parse(MenuEditorVariables.preorderPriceController.text.trim())))
    {
      showPriceShouldNotBeNull(context,'Normal and preorder price should be greater than 10\nPreorder price should be less than normal price');
    } else if ((int.parse(MenuEditorVariables.halfNormalPriceController.text.trim()) < 10 || int.parse(MenuEditorVariables.halfPreorderPriceController.text.trim()) < 10 ) && (int.parse(MenuEditorVariables.halfNormalPriceController.text.trim()) < int.parse(MenuEditorVariables.halfPreorderPriceController.text.trim())))
    {
      showPriceShouldNotBeNull(context,'Half normal and preorder price should be greater than 10\n Half preorder price should be less than normal price');
    }
    else if(int.parse(MenuEditorVariables.normalPriceController.text.trim()) < 10 || int.parse(MenuEditorVariables.preorderPriceController.text.trim()) < 10  )
    {
      showPriceShouldNotBeNull(context,'Normal and preorder price should be greater than 10');
    }
    else  if(int.parse(MenuEditorVariables.halfNormalPriceController.text.trim()) < 10 || int.parse(MenuEditorVariables.halfPreorderPriceController.text.trim()) < 10  )
    {
      showPriceShouldNotBeNull(context,'Half normal and half preorder price should be greater than 10');
    }
    else if(int.parse(MenuEditorVariables.normalPriceController.text.trim()) < int.parse(MenuEditorVariables.preorderPriceController.text.trim()))
    {
      showPriceShouldNotBeNull(context,'Preorder price should be less than normal price');
    } else if(int.parse(MenuEditorVariables.halfNormalPriceController.text.trim()) < int.parse(MenuEditorVariables.halfPreorderPriceController.text.trim()))
    {
      showPriceShouldNotBeNull(context,'Half preorder price should be less than half normal price');
    }
    else if(int.parse(MenuEditorVariables.normalPriceController.text.trim()) < int.parse(MenuEditorVariables.halfNormalPriceController.text.trim()))
    {
      showPriceShouldNotBeNull(context,'Half Normal price should be less than full normal price');
    } else if(int.parse(MenuEditorVariables.preorderPriceController.text.trim()) < int.parse(MenuEditorVariables.halfPreorderPriceController.text.trim())) {
      showPriceShouldNotBeNull(context,'Half Preorder price should be less than full preorder price');
    }
    else {

      MenuEditorVariables.requestBody = {
        "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
        "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
        "ritem_packagePrice": MenuEditorVariables.packagindController.text,
        "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
        "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
        "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
        "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
        "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
        "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
        'ritem_half_price' : MenuEditorVariables.halfSelected
      };

      menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
      MenuEditorVariables.priceFlag = false;
    }
  }

  static bool priceValidation(BuildContext context,BuildContext menuContext,MenuLoadedState menuState)
  {
    if ((int.parse(MenuEditorVariables.normalPriceController.text.trim()) < 10 || int.parse(MenuEditorVariables.preorderPriceController.text.trim()) < 10 ) && (int.parse(MenuEditorVariables.normalPriceController.text.trim()) < int.parse(MenuEditorVariables.preorderPriceController.text.trim())))
    {
      showPriceShouldNotBeNull(context,'Normal and preorder price should be greater than 10\nPreorder price should be less than normal price');
      return false;
    }
    else if(int.parse(MenuEditorVariables.normalPriceController.text.trim()) < 10 || int.parse(MenuEditorVariables.preorderPriceController.text.trim()) < 10  )
    {
      showPriceShouldNotBeNull(context,'Normal and preorder price should be greater than 10');
      return false;
    }
    else if(int.parse(MenuEditorVariables.normalPriceController.text.trim()) < int.parse(MenuEditorVariables.preorderPriceController.text.trim()))
    {
      showPriceShouldNotBeNull(context,'Preorder price should be less than normal price');
      return false;
    }
    else {
      return true;
    }
  }

  static bool priceValidationAvailability(BuildContext context,BuildContext menuContext,MenuLoadedState menuState)
  {
    if (
    ((int.parse(MenuEditorVariables.normalPriceController.text.trim()) < 10 || int.parse(MenuEditorVariables.preorderPriceController.text.trim()) < 10 ) && (int.parse(MenuEditorVariables.normalPriceController.text.trim()) < int.parse(MenuEditorVariables.preorderPriceController.text.trim())))
    || (MenuEditorVariables.budgetController.text == 'SELECT' || MenuEditorVariables.comboController.text == 'SELECT' || MenuEditorVariables.typeController.text == 'SELECT' || MenuEditorVariables.subTypeController.text == 'SELECT' || MenuEditorVariables.subTypeController.text == 'SELECT ' || MenuEditorVariables.categoryController.text == 'SELECT' )
    )
    {
      showPriceShouldNotBeNull(context,'Normal and preorder price should be greater than 10\nPreorder price should be less than normal price\n Mandatory item properties should not be null or SELECT');
      return false;
    }
    else if((int.parse(MenuEditorVariables.normalPriceController.text.trim()) < 10 || int.parse(MenuEditorVariables.preorderPriceController.text.trim()) < 10 )
    || (MenuEditorVariables.budgetController.text == 'SELECT' || MenuEditorVariables.comboController.text == 'SELECT' || MenuEditorVariables.typeController.text == 'SELECT' || MenuEditorVariables.subTypeController.text == 'SELECT' || MenuEditorVariables.subTypeController.text == 'SELECT ' || MenuEditorVariables.categoryController.text == 'SELECT' )
    )
    {
      showPriceShouldNotBeNull(context,'Normal and preorder price should be greater than 10\nMandatory item properties should not be null or SELECT');
      return false;
    }
    else if((int.parse(MenuEditorVariables.normalPriceController.text.trim()) < int.parse(MenuEditorVariables.preorderPriceController.text.trim()))
        || (MenuEditorVariables.budgetController.text == 'SELECT' || MenuEditorVariables.comboController.text == 'SELECT' || MenuEditorVariables.typeController.text == 'SELECT' || MenuEditorVariables.subTypeController.text == 'SELECT' || MenuEditorVariables.subTypeController.text == 'SELECT ' || MenuEditorVariables.categoryController.text == 'SELECT' ))
    {
      showPriceShouldNotBeNull(context,'Preorder price should be less than normal price\nMandatory item properties should not be null or SELECT');
      return false;
    }
    else {
      return true;
    }
  }

  static bool halfPriceValidation(BuildContext context,BuildContext menuContext,MenuLoadedState menuState)
  {
    if ((int.parse(MenuEditorVariables.normalPriceController.text.trim()) < 10 || int.parse(MenuEditorVariables.preorderPriceController.text.trim()) < 10 ) && (int.parse(MenuEditorVariables.normalPriceController.text.trim()) < int.parse(MenuEditorVariables.preorderPriceController.text.trim())))
    {
      showPriceShouldNotBeNull(context,'Normal and preorder price should be greater than 10\nPreorder price should be less than normal price');
      return false;
    } else if ((int.parse(MenuEditorVariables.halfNormalPriceController.text.trim()) < 10 || int.parse(MenuEditorVariables.halfPreorderPriceController.text.trim()) < 10 ) && (int.parse(MenuEditorVariables.halfNormalPriceController.text.trim()) < int.parse(MenuEditorVariables.halfPreorderPriceController.text.trim())))
    {
      showPriceShouldNotBeNull(context,'Half normal and preorder price should be greater than 10\n Half preorder price should be less than normal price');
      return false;
    }
    else if(int.parse(MenuEditorVariables.normalPriceController.text.trim()) < 10 || int.parse(MenuEditorVariables.preorderPriceController.text.trim()) < 10  )
    {
      showPriceShouldNotBeNull(context,'Normal and preorder price should be greater than 10');
      return false;
    }
    else  if(int.parse(MenuEditorVariables.halfNormalPriceController.text.trim()) < 10 || int.parse(MenuEditorVariables.halfPreorderPriceController.text.trim()) < 10  )
  {
  showPriceShouldNotBeNull(context,'Half normal and half preorder price should be greater than 10');
  return false;
  }
    else if(int.parse(MenuEditorVariables.normalPriceController.text.trim()) < int.parse(MenuEditorVariables.preorderPriceController.text.trim()))
    {
      showPriceShouldNotBeNull(context,'Preorder price should be less than normal price');
      return false;
    } else if(int.parse(MenuEditorVariables.halfNormalPriceController.text.trim()) < int.parse(MenuEditorVariables.halfPreorderPriceController.text.trim()))
    {
      showPriceShouldNotBeNull(context,'Half preorder price should be less than half normal price');
      return false;
    }
    else if(int.parse(MenuEditorVariables.normalPriceController.text.trim()) < int.parse(MenuEditorVariables.halfNormalPriceController.text.trim())) {
      showPriceShouldNotBeNull(context,'Half Normal price should be less than full normal price');
      return false;
    } else if(int.parse(MenuEditorVariables.preorderPriceController.text.trim()) < int.parse(MenuEditorVariables.halfPreorderPriceController.text.trim())) {
      showPriceShouldNotBeNull(context,'Half Preorder price should be less than full preorder price');
      return false;
    }
    else {
      return true;
    }
  }


  static bool displayNameVaidation(BuildContext context,BuildContext menuContext,MenuLoadedState menuState) {

      MenuEditorVariables.displayNameController.text = MenuEditorVariables.displayNameController.text.trim();

      String firstCharacter = MenuEditorVariables.displayNameController.text.isNotEmpty
          ? MenuEditorVariables.displayNameController.text[0]
          : '';

      bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
          (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
              '0123456789'.contains(firstCharacter)));

      if(MenuEditorVariables.displayNameController.text.trim() == "") {
        MenuEditorFunction.showShouldNotNull(context,"Display");
        return false;
      } else if(MenuEditorVariables.displayNameController.text.trim().length <3){
        MenuEditorFunction.showStringLengthAlert(context, "Display name");
        return false;
      } else if(!isFirstCharacterLetterOrDigit) {
        MenuEditorFunction.showOnlyDigitAndLettersAlert(context, "Display name");
        return false;
      }

      return true;
  }

  static bool propertyValidation(BuildContext context,BuildContext menuContext,MenuLoadedState menuState) {
    if(MenuEditorVariables.budgetController.text == 'SELECT')
    {
      MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the price range it should not be null');
      return false;
    }
    else if(MenuEditorVariables.comboController.text == 'SELECT')
    {
      MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the combo type it should not be null');
      return false;
    }
    else if(MenuEditorVariables.typeController.text == 'SELECT')
    {
      MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item type it should not be null');
      return false;
    }
    else if(MenuEditorVariables.subTypeController.text == 'SELECT' || MenuEditorVariables.subTypeController.text == 'SELECT ' )
    {
      MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item sub type it should not be null');
      return false;
    }
    else if(MenuEditorVariables.categoryController.text == 'SELECT')
    {
      MenuEditorFunction.showPriceShouldNotBeNull(context, 'Select the item category it should not be null');
      return false;
    } else {
      return true;
    }

  }

  static void saveChangesTag(BuildContext context,BuildContext menuContext,String oldTagName,Map<String, List<Map<String,dynamic>>> foodCategories) {
    MenuEditorVariables.tagController.text = MenuEditorVariables.tagController.text.trim();

    String firstCharacter = MenuEditorVariables.tagController.text.isNotEmpty
        ? MenuEditorVariables.tagController.text[0]
        : '';

    bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
        (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
            '0123456789'.contains(firstCharacter)));

    if(oldTagName == MenuEditorVariables.tagController.text) {
      MenuEditorFunction.showNothingToSaveAlert(context);
    } else {
      bool itemExists = false;
      if (MenuEditorVariables.tagController.text.trim() == "") {
        MenuEditorFunction.showShouldNotNull(context, "Section");
      }
      else if (MenuEditorVariables.tagController.text.trim().length < 3) {
        MenuEditorFunction.showStringLengthAlert(context, "Section");
      }
      else if (!isFirstCharacterLetterOrDigit) {
        MenuEditorFunction.showOnlyDigitAndLettersAlert(context, "Section");
      }
      else {
        for (final categoryItems in foodCategories.keys) {
          if (categoryItems == MenuEditorVariables.tagController.text.trim()) {
            itemExists = true;
            break;
          }
        }
        if (itemExists) {
          MenuEditorFunction.showSectionExistAlertWhileUpdating(context, menuContext, MenuEditorVariables.oldestTagName, MenuEditorVariables.tagController.text.trim());
        } else {
          context.read<MenuBloc>().add(UpdateTagNameEvent(context, MenuEditorVariables.oldestTagName, MenuEditorVariables.tagController.text.trim()));
          MenuEditorVariables.tagFlag = false;
        }
      }
    }
  }

  static void showPriceDialogueNormal(BuildContext context,BuildContext menuContext,String name,MenuLoadedState menuState) {
    TextEditingController item = TextEditingController();
    item.text = MenuEditorVariables.normalPriceController.text;
    showDialog(
      context: context,
      builder: (BuildContext contexts) {
        return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
          return Container(
            child: AlertDialog(
              title: Text('Edit item $name price'),
              content: Container(
                height: 400,
                width: 400,
                child: Column(
                  children: [
                    CustomTextField(label: '$name price',
                      width: 400,
                      controller: item,
                      priceLimit: true,
                      onlyDigits: true,
                      onChanged: (val) {
                        MenuEditorVariables.priceFlag = true;
                        if (val!.isEmpty) {
                          item.text = '0';
                        }
                        else if (val.startsWith('.')) {
                          item.text = '0$val';
                        }

                        double normalPrice;
                        double packagingPrice;
                        try {
                          normalPrice = double.parse(item.text);
                          packagingPrice = double.parse(MenuEditorVariables.packagindController.text);
                        } catch (e) {
                          normalPrice = 0.0;
                          packagingPrice = 0.0;
                        }

                        if (MenuEditorVariables.gstPayment) {
                          MenuEditorVariables.normalFinalPrice = (normalPrice + packagingPrice) + ((5 * (normalPrice + packagingPrice)) / 100);
                          MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                        } else {
                          MenuEditorVariables.normalFinalPrice = (normalPrice + packagingPrice) + ((normalPrice * 5) / 100);
                          MenuEditorVariables.normalFinalPrice = double.parse(MenuEditorVariables.normalFinalPrice.toStringAsFixed(2));
                        }
                      },
                      // dropdownItems: MenuEditorVariables.tags,
                      // isDropdown: true,
                      // showSearchBox1: true,
                      // dropdownAuto: true,
                      // digitsAndLetters: true,
                      // displayCount: true,

                    ),
                  ],
                ),
              ),
              actions: [
                InkWell(
                  onTap : () {
                    Navigator.of(context).pop(); // Close the AlertDialog
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color:GlobalVariables.whiteColor,
                        border:Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(5)),

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

                    if(MenuEditorVariables.normalPriceController.text == item.text) {
                      showPriceShouldNotBeNull1(context, "Nothing to save.");
                    } else {


                      if(MenuEditorVariables.halfSelected) {

                        if(int.parse(item.text.trim()) < 10)
                        {
                          showPriceShouldNotBeNull1(context,'Normal price should be greater than 10');
                        }
                        else if(int.parse(MenuEditorVariables.preorderPriceController.text.trim()) >= int.parse(item.text.trim()))
                        {
                          showPriceShouldNotBeNull1(context,'Normal price should be greater than preorder price');
                        }

                        else if(int.parse(MenuEditorVariables.halfNormalPriceController.text.trim()) >= int.parse(item.text.trim()))
                        {
                          showPriceShouldNotBeNull1(context,'Normal price should be greater than half normal price');
                        }
                        else if(int.parse(MenuEditorVariables.halfPreorderPriceController.text.trim()) >= int.parse(item.text.trim()))
                        {
                          showPriceShouldNotBeNull1(context,'Normal price should be greater than half preorder price');
                        }
                        else  {
                          MenuEditorVariables.normalPriceController.text = item.text;
                          MenuEditorVariables.requestBody = {
                            "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                            "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                            "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                            "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                            "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                            "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                            "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                            "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                            "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                            'ritem_half_price' : MenuEditorVariables.halfSelected
                          };
                          menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, MenuEditorVariables.selectItem["_id"], MenuEditorVariables.requestBody, MenuEditorVariables.selectItem['disName']));
                          Navigator.pop(context);
                        }

                      }
                      else {
                        if (int.parse(item
                            .text.trim()) < 10) {
                          showPriceShouldNotBeNull1(
                              context, 'Normal price should be greater than 10');
                        }
                        else if (int.parse(
                            MenuEditorVariables.preorderPriceController.text
                                .trim()) >= int.parse(
                            item.text
                                .trim())) {
                          showPriceShouldNotBeNull1(context,
                              'Normal price should be greater than preorder price');
                        }

                        else {
                          MenuEditorVariables.normalPriceController.text = item.text;
                          MenuEditorVariables.requestBody = {
                            "ritem_normalPrice": MenuEditorVariables
                                .normalPriceController.text,
                            "ritem_half_normalPrice": MenuEditorVariables
                                .halfNormalPriceController.text,
                            "ritem_packagePrice": MenuEditorVariables
                                .packagindController.text,
                            "ritem_preorderPrice": MenuEditorVariables
                                .preorderPriceController.text,
                            "ritem_half_preorderPrice": MenuEditorVariables
                                .halfPreorderPriceController.text,
                            "ritem_normalFinalPrice": MenuEditorVariables
                                .normalFinalPrice,
                            "ritem_preorderFinalPrice": MenuEditorVariables
                                .preOrderFinalPrice,
                            "ritem_half_normalFinalPrice": MenuEditorVariables
                                .halfNormalFinalPrice,
                            "ritem_half_preorderFinalPrice": MenuEditorVariables
                                .halfPreOrderFinalPrice,
                            'ritem_half_price': MenuEditorVariables.halfSelected
                          };
                          menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(
                              context, MenuEditorVariables.selectItem["_id"],
                              MenuEditorVariables.requestBody,
                              MenuEditorVariables.selectItem['disName']));
                          Navigator.pop(context);
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
                        'Save',
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
      },
    );

  }

  static void showPriceDialoguePreorder(BuildContext context,BuildContext menuContext,String name,MenuLoadedState menuState) {
    TextEditingController item = TextEditingController();
    item.text = MenuEditorVariables.preorderPriceController.text;
    showDialog(
      context: context,
      builder: (BuildContext contexts) {
        return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
          return Container(
            child: AlertDialog(
              title: Text('Edit item $name price'),
              content: Container(
                height: 400,
                width: 400,
                child: Column(
                  children: [
                    CustomTextField(label: '$name price',
                      width: 400,
                      controller: item,
                      priceLimit: true,
                      onlyDigits: true,
                      onChanged: (val){
                        MenuEditorVariables.priceFlag = true;
                        if (val!.isEmpty) {
                          item.text = '0';
                          val = '0';
                        } else if (val.startsWith('.')) {
                          item.text = '0$val';
                          val = '0$val';
                        }
                        double preorderPrice;
                        double pacakgingPrice;
                        try {
                          preorderPrice = double.parse(item.text);
                          pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                        } catch (e) {
                          preorderPrice = 0.0;
                          pacakgingPrice = 0.0;
                        }

                        if(MenuEditorVariables.gstPayment){
                          MenuEditorVariables.preOrderFinalPrice =  (preorderPrice + pacakgingPrice) + ((5*(preorderPrice  + pacakgingPrice))/100);
                          MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                        }else {
                          MenuEditorVariables.preOrderFinalPrice = (preorderPrice  + pacakgingPrice) + ((preorderPrice  * 5)/100);
                          MenuEditorVariables.preOrderFinalPrice = double.parse(MenuEditorVariables.preOrderFinalPrice.toStringAsFixed(2));
                        }
                      },


                    ),
                  ],
                ),
              ),
              actions: [
                InkWell(
                  onTap : () {
                    Navigator.of(context).pop(); // Close the AlertDialog
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color:GlobalVariables.whiteColor,
                        border:Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(5)),

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

                    if(MenuEditorVariables.preorderPriceController.text == item.text){
                      showPriceShouldNotBeNull1(context, "Nothing to save.");
                    } else {

                      if(MenuEditorVariables.halfSelected) {

                        if(int.parse(item.text.trim()) < 10)
                        {
                          showPriceShouldNotBeNull1(context,'Preorder price should be greater than 10');
                        }
                        else if(int.parse(item.text.trim()) >= int.parse(MenuEditorVariables.normalPriceController.text.trim()))
                        {
                          showPriceShouldNotBeNull1(context,'Preorder price should be less than normal price');
                        }

                        else if(int.parse(MenuEditorVariables.halfPreorderPriceController.text.trim()) >= int.parse(item.text.trim()))
                        {
                          showPriceShouldNotBeNull1(context,'Preorder price should be greater than half preorder price');
                        }
                        else if(int.parse(MenuEditorVariables.halfNormalPriceController.text.trim()) >= int.parse(item.text.trim()))
                        {
                          showPriceShouldNotBeNull1(context,'Preorder price should be greater than half nornal price');
                        }
                        else  {
                          MenuEditorVariables.preorderPriceController.text = item.text;
                          MenuEditorVariables.requestBody = {
                            "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                            "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                            "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                            "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                            "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                            "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                            "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                            "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                            "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                            'ritem_half_price' : MenuEditorVariables.halfSelected
                          };
                          menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, MenuEditorVariables.selectItem["_id"], MenuEditorVariables.requestBody, MenuEditorVariables.selectItem['disName']));
                          Navigator.pop(context);
                        }

                      }
                      else {
                        if (int.parse(item.text.trim()) < 10) {
                          showPriceShouldNotBeNull1(
                              context, 'Preorder price should be greater than 10');
                        }
                        else if (int.parse(
                            item.text
                                .trim()) >= int.parse(
                            MenuEditorVariables.normalPriceController.text
                                .trim())) {
                          showPriceShouldNotBeNull1(context,
                              'Preorder price should be less than normal price');
                        }

                        else {
                          MenuEditorVariables.preorderPriceController.text = item.text;
                          MenuEditorVariables.requestBody = {
                            "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                            "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                            "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                            "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                            "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                            "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                            "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                            "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                            "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                            'ritem_half_price': MenuEditorVariables.halfSelected
                          };
                          menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(
                              context, MenuEditorVariables.selectItem["_id"],
                              MenuEditorVariables.requestBody,
                              MenuEditorVariables.selectItem['disName']));
                          Navigator.pop(context);
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
                        'Save',
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
      },
    );

  }

  static void showPriceDialogueHalfNormal(BuildContext context,BuildContext menuContext,String name,MenuLoadedState menuState) {
    TextEditingController item = TextEditingController();
    item.text = MenuEditorVariables.halfNormalPriceController.text;
    showDialog(
      context: context,
      builder: (BuildContext contexts) {
        return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
          return Container(
            child: AlertDialog(
              title: Text('Edit item half $name price'),
              content: Container(
                height: 400,
                width: 400,
                child: Column(
                  children: [
                    CustomTextField(label: 'half $name price',
                      width: 400,
                      controller: item,
                      priceLimit: true,
                      onlyDigits: true,
                      onChanged: (val) {
                        MenuEditorVariables.priceFlag = true;
                        if (val!.isEmpty) {
                          item.text = '0';
                        } else if (val.startsWith('.')) {
                          item.text = '0$val';
                        }

                        double normalPrice;
                        double packagingPrice;
                        try {
                          normalPrice = double.parse(item.text);
                          packagingPrice = double.parse(MenuEditorVariables.packagindController.text);
                        } catch (e) {
                          normalPrice = 0.0;
                          packagingPrice = 0.0;
                        }

                        if (MenuEditorVariables.gstPayment) {
                          MenuEditorVariables.halfNormalFinalPrice = (normalPrice + packagingPrice) + ((5 * (normalPrice + packagingPrice)) / 100);
                          MenuEditorVariables.halfNormalFinalPrice = double.parse(MenuEditorVariables.halfNormalFinalPrice.toStringAsFixed(2));
                        } else {
                          MenuEditorVariables.halfNormalFinalPrice = (normalPrice + packagingPrice) + ((normalPrice * 5) / 100);
                          MenuEditorVariables.halfNormalFinalPrice = double.parse(MenuEditorVariables.halfNormalFinalPrice.toStringAsFixed(2));
                        }
                      },

                    ),
                  ],
                ),
              ),
              actions: [
                InkWell(
                  onTap : () {
                    Navigator.of(context).pop(); // Close the AlertDialog
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color:GlobalVariables.whiteColor,
                        border:Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(5)),

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

                    if(MenuEditorVariables.halfNormalPriceController.text == item.text) {
                      showPriceShouldNotBeNull1(context, "Nothing to save.");
                    } else {
                      if(int.parse(item.text.trim()) < 10)
                      {
                        showPriceShouldNotBeNull1(context,'Half normal price should be greater than 10');
                      }
                      else if(int.parse(MenuEditorVariables.halfPreorderPriceController.text.trim()) >= int.parse(item.text.trim()))
                      {
                        showPriceShouldNotBeNull1(context,'Half Normal price should be greater than half preorder price');
                      }
                      else if(int.parse(item.text.trim()) >= int.parse(MenuEditorVariables.normalPriceController.text.trim()))
                      {
                        showPriceShouldNotBeNull1(context,'Half normal price should be less than  normal price');
                      }
                      else  {
                        MenuEditorVariables.halfNormalPriceController.text = item.text;
                        MenuEditorVariables.requestBody = {
                          "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                          "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                          "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                          "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                          "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                          "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                          "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                          "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                          "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                          'ritem_half_price' : MenuEditorVariables.halfSelected
                        };
                        menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, MenuEditorVariables.selectItem["_id"], MenuEditorVariables.requestBody, MenuEditorVariables.selectItem['disName']));
                        Navigator.pop(context);

                      }
                    }

                    MenuEditorVariables.halfNormalPriceController.text = item.text;




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
                        'Save',
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
      },
    );

  }

  static void showPriceDialogueHalfPreorder(BuildContext context,BuildContext menuContext,String name,MenuLoadedState menuState) {
    TextEditingController item = TextEditingController();
    item.text = MenuEditorVariables.halfPreorderPriceController.text;
    showDialog(
      context: context,
      builder: (BuildContext contexts) {
        return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
          return Container(
            child: AlertDialog(
              title: Text('Edit item half $name price'),
              content: Container(
                height: 400,
                width: 400,
                child: Column(
                  children: [
                    CustomTextField(label: 'Half $name price',
                      width: 400,
                      controller: item,
                      priceLimit: true,
                      onlyDigits: true,
                      onChanged: (val){
                        MenuEditorVariables.priceFlag = true;
                        if (val!.isEmpty) {
                          item.text = '0';
                          val = '0';
                        } else if (val.startsWith('.')) {
                          item.text = '0$val';
                          val = '0$val';
                        }
                        double halfPreorderPrice;
                        double pacakgingPrice;
                        try {
                          halfPreorderPrice = double.parse(item.text);
                          pacakgingPrice = double.parse(MenuEditorVariables.packagindController.text);
                        } catch (e) {
                          halfPreorderPrice = 0.0;
                          pacakgingPrice = 0.0;
                        }

                        if(MenuEditorVariables.gstPayment){
                          MenuEditorVariables.halfPreOrderFinalPrice =  (halfPreorderPrice + pacakgingPrice) + ((5*(halfPreorderPrice  + pacakgingPrice))/100);
                          MenuEditorVariables.halfPreOrderFinalPrice = double.parse(MenuEditorVariables.halfPreOrderFinalPrice.toStringAsFixed(2));
                        }else {
                          MenuEditorVariables.halfPreOrderFinalPrice = (halfPreorderPrice  + pacakgingPrice) + ((halfPreorderPrice  * 5)/100);
                          MenuEditorVariables.halfPreOrderFinalPrice = double.parse(MenuEditorVariables.halfPreOrderFinalPrice.toStringAsFixed(2));
                        }

                      },


                    ),
                  ],
                ),
              ),
              actions: [
                InkWell(
                  onTap : () {
                    Navigator.of(context).pop(); // Close the AlertDialog
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color:GlobalVariables.whiteColor,
                        border:Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(5)),

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

                    if(MenuEditorVariables.halfPreorderPriceController.text == item.text) {
                      showPriceShouldNotBeNull1(context, "Nothing to save.");
                    } else {


                      if(int.parse(item.text.trim()) < 10)
                      {
                        showPriceShouldNotBeNull1(context,'Half preorder price should be greater than 10');
                      }
                      else if(int.parse(item.text.trim()) >= int.parse(MenuEditorVariables.halfNormalPriceController.text.trim()))
                      {
                        showPriceShouldNotBeNull1(context,'Half preorder price should be less than half normal price');
                      }

                      else if(int.parse(item.text.trim()) >= int.parse(MenuEditorVariables.preorderPriceController.text.trim()))
                      {
                        showPriceShouldNotBeNull1(context,'Half preorder price should be less than preorder price');
                      }
                      else if(int.parse(item.text.trim()) >= int.parse(MenuEditorVariables.normalPriceController.text.trim()))
                      {
                        showPriceShouldNotBeNull1(context,'Half pfreorder price should be less than  normal price');
                      }
                      else  {

                        MenuEditorVariables.halfPreorderPriceController.text = item.text;

                        MenuEditorVariables.requestBody = {
                          "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                          "ritem_half_normalPrice": MenuEditorVariables.halfNormalPriceController.text,
                          "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                          "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                          "ritem_half_preorderPrice": MenuEditorVariables.halfPreorderPriceController.text,
                          "ritem_normalFinalPrice": MenuEditorVariables.normalFinalPrice,
                          "ritem_preorderFinalPrice": MenuEditorVariables.preOrderFinalPrice,
                          "ritem_half_normalFinalPrice": MenuEditorVariables.halfNormalFinalPrice,
                          "ritem_half_preorderFinalPrice": MenuEditorVariables.halfPreOrderFinalPrice,
                          'ritem_half_price' : MenuEditorVariables.halfSelected
                        };
                        menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, MenuEditorVariables.selectItem["_id"], MenuEditorVariables.requestBody, MenuEditorVariables.selectItem['disName']));
                        Navigator.pop(context);
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
                        'Save',
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
      },
    );

  }


  static bool itemAvailability(BuildContext context,BuildContext menuContext,MenuLoadedState menuState) {

    if(!MenuEditorVariables.halfSelected) {
      if(priceValidationAvailability(context, menuContext, menuState)){
        if(displayNameVaidation(context, menuContext, menuState)) {
          if(propertyValidation(context, menuContext, menuState)) {
            bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);

            if(!isAllZero && MenuEditorVariables.selectedOption == 1) {
              showPriceShouldNotBeNull(context, 'Set count for at least one session');
              return false;
            }
          }
          else {
            return false;
          }
        }
        else {
          return false;
        }
      }
      else {
        return false;
      }
    } else {
      if(halfPriceValidation(context, menuContext, menuState)){
        if(displayNameVaidation(context, menuContext, menuState)) {
          if(propertyValidation(context, menuContext, menuState)) {
            bool isAllZero = MenuEditorFunction.hasCountGreaterThanZero(MenuEditorVariables.daysMealSession1);

            if(!isAllZero && MenuEditorVariables.selectedOption == 1) {
              showPriceShouldNotBeNull(context, 'Set count for at least one session');
              return false;
            }
          }
          else {
            return false;
          }
        }
        else {
          return false;
        }
      }
      else {
        return false;
      }
    }


    return true;
  }

  static List<Map<String, dynamic>> getNext7Days() {
    List<Map<String, dynamic>> daysList = [];
    DateTime now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      String dayName = DateFormat('EEEE').format(date); // Get day name
      String dateString = DateFormat('yyyy-MM-dd').format(date); // Get date in desired format

      daysList.add({
        'day': dayName,
        'date': date,
        'dateString' : dateString
      });
    }

    return daysList;
  }

  static Map<String, dynamic>? getDayAndDate(String shortDay) {
    List<Map<String, dynamic>> daysList = [];
    DateTime now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      String dayName = DateFormat('EEEE').format(date); // Full day name (e.g., "Monday")
      String dateString = DateFormat('yyyy-MM-dd').format(date); // Date in desired format
      String shortDayName = DateFormat('EEE').format(date); // Short day name (e.g., "Mon")

      daysList.add({
        'day': dayName,
        'date': date,
        'dateString': dateString,
        'shortDay': shortDayName
      });
    }

    // Find and return the day and date that matches the input short day
    for (var day in daysList) {
      if (day['shortDay'] == shortDay) {
        return {
          'day': day['day'],
          'date': day['dateString'],
        };
      }
    }

    // If the input short day does not match any of the next 7 days, return null or an appropriate response
    return null;
  }

  static List<Map<String, dynamic>> getNext5Days() {
    List<Map<String, dynamic>> daysList = [];
    DateTime now = DateTime.now();

    for (int i = 2; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      String dayName = DateFormat('EEEE').format(date); // Get day name
      String dateString = DateFormat('yyyy-MM-dd').format(date); // Get date in desired format

      daysList.add({
        'day': dayName,
        'date': date,
        'dateString' : dateString,
      });
    }

    return daysList;
  }

  static void showFlushBarAvailability(BuildContext context) {
    if(MenuEditorVariables.selectItem['availability'] && MenuEditorVariables.selectedOption == 1) {
      Flushbar(
        title: "Synched data",
        message: "Saved changes for T+2 to T+6 has syncing to live menu",
        backgroundGradient: LinearGradient(colors: [GlobalVariables.textColor, Colors.teal]),
        backgroundColor: Colors.red,
        boxShadows: [BoxShadow(color: GlobalVariables.textColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
        duration: Duration(seconds: 2),
      )..show(context);
    }
    else if(!MenuEditorVariables.selectItem['availability'] && MenuEditorVariables.selectedOption == 1) {
      Flushbar(
        title: "On selection schedule",
        message: "Schedule has changing for menu edtor",
        backgroundGradient: LinearGradient(colors: [GlobalVariables.textColor, Colors.teal]),
        backgroundColor: Colors.red,
        boxShadows: [BoxShadow(color: GlobalVariables.textColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  static void showFlushBarAvailabilitySync(BuildContext context) {
    Flushbar(
      title: "Synched data",
      message: "Item has enabled for T+2 to T+6 days you have them in live menu",
      backgroundGradient: LinearGradient(colors: [GlobalVariables.textColor, Colors.teal]),
      backgroundColor: Colors.red,
      boxShadows: [BoxShadow(color: GlobalVariables.textColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
      duration: Duration(seconds: 4),
    )..show(context);
  }

  static void showFlushBarAvailabilityDisableSync(BuildContext context) {
    Flushbar(
      title: "Synched data",
      message: "Item has disabled for T+2 to T+6 days in live menu",
      backgroundGradient: LinearGradient(colors: [GlobalVariables.textColor, Colors.teal]),
      backgroundColor: Colors.red,
      boxShadows: [BoxShadow(color: GlobalVariables.textColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
      duration: Duration(seconds: 4),
    )..show(context);
  }

}