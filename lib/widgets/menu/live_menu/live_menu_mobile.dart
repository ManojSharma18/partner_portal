import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_functions.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/search_bar.dart';

import '../../../constants/global_function.dart';
import 'live_menu.dart';

class LiveMenuMobile extends StatelessWidget {
  const LiveMenuMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Column(
      children: [
        SearchBars(hintText: "Search", width: 350*fem,height: 45,onChanged: (subQuery){
          if (subQuery != "") {
            LiveMenuVariables.filteredFoodCategory = {}; // Reset filteredFoodCategory outside the loop

            LiveMenuVariables.filteredFoodCategory.forEach((cuisine, items) {
              List<Map<String, dynamic>> matchingItems = items
                  .where((item) => item['name'].toLowerCase().contains(subQuery.toLowerCase()))
                  .toList();

              if (matchingItems.isNotEmpty) {
                LiveMenuVariables.selectedCategories.add(cuisine);
                LiveMenuVariables.filteredFoodCategory[cuisine] = matchingItems;
              }
            });
          }
          else{
            LiveMenuVariables.filteredFoodCategory = {};
            LiveMenuVariables.selectedCategories = {};
            LiveMenuVariables.selectedCategories.add('South indian breakfast');
          }
        },),
        SizedBox(height: 0,),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlobalFunction.buildMealButton(context,MealTime.All,'All'),
              GlobalFunction.buildMealButton(context,MealTime.Breakfast,'Breakfast'),
              GlobalFunction.buildMealButton(context,MealTime.Lunch,'Lunch'),
              GlobalFunction.buildMealButton(context,MealTime.Dinner,'Dinner'),
            ],
          ),
        ),
        Expanded(
          child: ReorderableListView.builder(
            buildDefaultDragHandles:false,
            primary: true,
            shrinkWrap: true,
            itemCount: LiveMenuVariables.filteredFoodCategory.length == 0 ? LiveMenuVariables.foodCategories.length : LiveMenuVariables.filteredFoodCategory.length,
            itemBuilder: (context, index) {
              String category = LiveMenuVariables.filteredFoodCategory.length == 0
                  ? LiveMenuVariables.foodCategories.keys.elementAt(index)
                  : LiveMenuVariables.filteredFoodCategory.keys.elementAt(index);
              List<Map<String, dynamic>> itemsList = LiveMenuVariables.filteredFoodCategory.length == 0
                  ? LiveMenuVariables.foodCategories[category]!
                  : LiveMenuVariables.filteredFoodCategory[category]!;
              List<String> items = itemsList.map((item) => item['name'] as String).toList();

              bool categoryContainsMatch = items.any((item) =>
                  item.toLowerCase().contains(" ".toLowerCase()));

              return ReorderableDragStartListener(
                enabled: LiveMenuVariables.enabled,
                key: Key(category),
                index: index,
                child: InkWell(
                  onTap: () {

                      if (categoryContainsMatch) {
                        if (LiveMenuVariables.selectedCategories.contains(category)) {
                          LiveMenuVariables.selectedCategories.remove(category);
                        } else {
                          LiveMenuVariables.selectedCategories.add(category);
                        }
                      }

                  },
                  child: Column(
                    key: Key('$category'),
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        color: LiveMenuVariables.selectedCategories.contains(category)
                            ? Color(0xFF363563)
                            : null,
                        child: ListTile(
                          title: Text(
                            category,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: LiveMenuVariables.selectedCategories.contains(category)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          leading: Icon(
                            Icons.grid_view_rounded,
                            size: 10,
                            color: LiveMenuVariables.selectedCategories.contains(category)
                                ? Colors.white
                                : Colors.black,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  //_showAddItemDialogMob();
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    size: 18,
                                    color: GlobalVariables.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: LiveMenuVariables.selectedCategories.contains(category),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: LiveMenuFunctions.buildItemsList1(context,category, itemsList),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {

                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                List<MapEntry<String, List<Map<String, dynamic>>>> entries =
                LiveMenuVariables.filteredFoodCategory.length == 0
                    ? LiveMenuVariables.foodCategories.entries.toList()
                    : LiveMenuVariables.filteredFoodCategory.entries.toList();
                MapEntry<String, List<Map<String, dynamic>>> removedEntry =
                entries.removeAt(oldIndex);
                entries.insert(newIndex, removedEntry);

                // Convert the List back to a Map
                if (LiveMenuVariables.filteredFoodCategory.length == 0) {
                  LiveMenuVariables.foodCategories = Map.fromEntries(entries);
                } else {
                  LiveMenuVariables.filteredFoodCategory = Map.fromEntries(entries);
                }

            },
          ),
        ),
      ],
    );
  }
}
