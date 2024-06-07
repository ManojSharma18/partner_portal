import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_event.dart';
import 'package:partner_admin_portal/bloc/menu/menu_state.dart';
import '../../widgets/custom_textfield.dart';
import '../global_variables.dart';
import '../utils.dart';
import 'menu_editor_variables.dart';

class MenuEditorFunction {

  static void showAddItemDialog(String category,BuildContext context,BuildContext menuContext,Map<String, List<Map<String,dynamic>>> foodCategories ) {
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
                      dropdownItems: MenuEditorVariables.items == [] ? ["Fetching items..."] : MenuEditorVariables.items ,
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
                TextButton(
                  onPressed: () {

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
                    } else {
                      // Item doesn't exist, add it to the list
                      for (final categoryItems in foodCategories.values) {
                        for (final itemName in categoryItems) {
                          if (item.text == itemName['disName']) {
                            print("Item already exists");
                            itemId = itemName['_id'];
                            name = itemName['disName'];
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
                        showReplaceItemAlert(context,menuContext,itemId,category,name);
                      } else {
                        // Map<String, dynamic> newItem = {'name': item.text, 'availability': true};
                        // foodCategories[category]!.add(newItem);
                        menuContext.read<MenuBloc>().add(AddMenuItemEvent(context, item.text, category));
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
        },

        );
      },
    );
  }

  static void showAlreadyExistAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Item already exists in your menu",style: GlobalVariables.dataItemStyle,),
          actions: [
            TextButton(
              onPressed: () {
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

  static void showReplaceItemAlert(BuildContext context,BuildContext menuContext,String id,String tag,String itemName) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<MenuBloc,MenuState>(builder: ( context, state) {
          return AlertDialog(
            title: Text("Item already exists \ndo you want to replace the section of this item?",style: GlobalVariables.dataItemStyle,),
            actions: [
              TextButton(
                onPressed: () {
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
              TextButton(
                onPressed: () {

                  menuContext.read<MenuBloc>().add(UpdateItemSection(context, id, tag, itemName));
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

  static void showSectionExistAlert(BuildContext context,BuildContext menuContext,String section) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
          return AlertDialog(
            title: Text("Section already exists in your menu.\n Do you want to replace this? all the items under $section \n section will be deleted.",style: GlobalVariables.dataItemStyle,),
            actions: [
              TextButton(
                onPressed: () {
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
              TextButton(
                onPressed: () {

                  menuContext.read<MenuBloc>().add(ReplaceSectionEvent(context, section));
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

  static void showSectionExistAlertWhileUpdating(BuildContext context,BuildContext menuContext,String oldName,String newName) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
          return AlertDialog(
            title: Text("All items under this section will be moved to the $newName.",style: GlobalVariables.dataItemStyle,),
            actions: [
              TextButton(
                onPressed: () {
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
              TextButton(
                onPressed: () {

                  menuContext.read<MenuBloc>().add(UpdateTagNameEvent(context, oldName, newName));
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
}