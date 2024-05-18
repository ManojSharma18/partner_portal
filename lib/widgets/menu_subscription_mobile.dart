import 'package:flutter/material.dart';

import 'custom_textfield.dart';
import '../constants/global_variables.dart';
import '../constants/search_bar.dart';
import '../constants/utils.dart';
import 'menu/live_menu/live_menu.dart';


enum MealTime {All,Breakfast,Lunch,Dinner}
class MenuSubscriptionMobile extends StatefulWidget {
  const MenuSubscriptionMobile({Key? key}) : super(key: key);

  @override
  State<MenuSubscriptionMobile> createState() => _MenuSubscriptionMobileState();
}

class _MenuSubscriptionMobileState extends State<MenuSubscriptionMobile> {
  MealTime selectedMealTime = MealTime.Breakfast;

  Map<String, List<Map<String,dynamic>>> filteredSubscriptionCategory = {};

  String selectedCategorySubscription = 'Pocket friendly';

  Set<String> selectedSubscription = Set();

  Map<String, List<Map<String,dynamic>>> subscriptionFoodCategories = {
    'Pocket friendly': [
      {'name' : 'Idli', 'availability' : true, 'category' : 'veg'},
      {'name' : 'Rice Bath','availability' : false,'category' : 'veg'},
      {'name' : 'Set dosa','availability' : false,'category' : 'veg' }
    ],

    'Budget': [
      {'name' : 'Bonda Soup', 'availability' : true,'category' : 'veg'},
      {'name' : 'Palav','availability' : false,'category' : 'veg'},
      {'name' : 'Curd rice','availability' : false,'category' : 'veg' }
    ],

    'Premium': [
      {'name' : 'Masala dosa', 'availability' : true,'category' : 'veg'},
      {'name' : 'Rava idli','availability' : false,'category' : 'veg'},
      {'name' : 'Idli vada','availability' : false ,'category' : 'veg'}
    ],

    'Luxury': [
      {'name' : 'Onion dosa', 'availability' : true,'category' : 'veg'},
      {'name' : 'Chocho bath','availability' : false,'category' : 'veg'},
      {'name' : 'Benne dosa','availability' : false ,'category' : 'veg'}
    ],

  };
  String selectedCategory = 'Pocket friendly';

  String selectedItem = '';

  String query = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedSubscription.add('Pocket friendly');
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Column(
      children: [
        SearchBars(hintText: "Search", width: 350*fem,height: 45, onChanged: (subQuery){
          setState(() {
            query = subQuery;
            if (query != "") {
              filteredSubscriptionCategory = {}; // Reset filteredFoodCategory outside the loop

              subscriptionFoodCategories.forEach((cuisine, items) {
                List<Map<String, dynamic>> matchingItems = items
                    .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
                    .toList();

                if (matchingItems.isNotEmpty) {
                  selectedSubscription.add(cuisine);
                  // selectedItem = query;

                  // Add the matching items to filteredFoodCategory
                  filteredSubscriptionCategory[cuisine] = matchingItems;
                }
              });
            }
            else{
              filteredSubscriptionCategory = {};
              selectedSubscription = {};
              selectedSubscription.add('Pocket friendly');
            }
          });
        }),
        SizedBox(height: 0,),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildMealTimeButton1(MealTime.Breakfast, 'Breakfast'),
              SizedBox(width: 25*fem,),
              buildMealTimeButton1(MealTime.Lunch, 'Lunch'),
              SizedBox(width: 25*fem,),
              buildMealTimeButton1(MealTime.Dinner, 'Dinner'),
            ],
          ),
        ),
        // SizedBox(height: 5,),
        // Container(
        //   margin: EdgeInsets.all(10),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       buildBudgetButton1(MealBudget.All, 'All'),
        //       buildBudgetButton1(MealBudget.Budget, 'Budget'),
        //       buildBudgetButton1(MealBudget.Premium, 'Premium'),
        //       buildBudgetButton1(MealBudget.Luxury, 'Luxury'),
        //     ],
        //   ),
        // ),
        Expanded(
          child: ReorderableListView.builder(
            buildDefaultDragHandles: false,
            primary: true,
            shrinkWrap: true,
            itemCount: filteredSubscriptionCategory.length == 0
                ? subscriptionFoodCategories.length
                : filteredSubscriptionCategory.length,
            itemBuilder: (context, index) {
              String category = filteredSubscriptionCategory.length == 0
                  ? subscriptionFoodCategories.keys.elementAt(index)
                  : filteredSubscriptionCategory.keys.elementAt(index);
              List<Map<String, dynamic>> itemsList = filteredSubscriptionCategory.length == 0
                  ? subscriptionFoodCategories[category]!
                  : filteredSubscriptionCategory[category]!;
              List<String> items = itemsList.map((item) => item['name'] as String).toList();

              bool categoryContainsMatch = items.any((item) =>
                  item.toLowerCase().contains(query.toLowerCase()));

              return ReorderableDragStartListener(
                enabled: true,
                key: Key(category),
                index: index,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (categoryContainsMatch) {
                        if (selectedSubscription.contains(category)) {
                          selectedSubscription.remove(category);
                        } else {
                          selectedSubscription.add(category);
                        }
                      }
                    });
                  },
                  child: Column(
                    key: Key('$category'),
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        color: selectedSubscription.contains(category)
                            ? Color(0xFF363563)
                            : null,
                        child: ListTile(
                          title: Text(
                            category,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: selectedSubscription.contains(category)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          leading: Icon(
                            Icons.grid_view_rounded,
                            size: 10,
                            color: selectedSubscription.contains(category)
                                ? Colors.white
                                : Colors.black,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  _showAddItemDialogSubscriptionMob();
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: GlobalVariables.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: selectedSubscription.contains(category),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _buildItemsList1(category, itemsList),
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
              filteredSubscriptionCategory.length == 0
                  ? subscriptionFoodCategories.entries.toList()
                  : filteredSubscriptionCategory.entries.toList();
              MapEntry<String, List<Map<String, dynamic>>> removedEntry =
              entries.removeAt(oldIndex);
              entries.insert(newIndex, removedEntry);

              // Convert the List back to a Map
              if (filteredSubscriptionCategory.length == 0) {
                subscriptionFoodCategories = Map.fromEntries(entries);
              } else {
                filteredSubscriptionCategory = Map.fromEntries(entries);
              }
            },
          ),
        ),
      ],
    );
  }

  void _showAddItemDialogSubscriptionMob() {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    TextEditingController item = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
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
                  setState(() {

                    Map<String, dynamic> newItem = {'name': item.text, 'availability': false};
                    subscriptionFoodCategories[selectedCategory]!.add(newItem);
                  });
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
  }

  List<Widget> _buildItemsList1(String category, List<Map<String, dynamic>> itemsList) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);
    if (selectedSubscription.isNotEmpty && selectedSubscription.contains(category)) {
      return itemsList.map((item) {
        return _buildDismissibleItem1(item['name'], color,item);
      }).toList();
    } else {
      return [
        Center(
          child: Text('Select a category to view items.'),
        ),
      ];
    }
  }

  Widget _buildDismissibleItem1(String item, Color color,Map<String, dynamic> item1) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
    return Dismissible(
      key: Key(item),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
         subscriptionFoodCategories[selectedCategory]!.remove(item);
        });

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
          setState(() {
            selectedItem = item;
          });
        },
        child: Container(
          margin: EdgeInsets.only(left:10,right: 10,bottom:10),
          decoration: BoxDecoration(
            color: selectedItem == item ? Colors.grey.shade200 : GlobalVariables.whiteColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(
              item,
              style: SafeGoogleFont(
                'Poppins',
                fontSize: 13*fem,
                fontWeight: FontWeight.bold,
                color: GlobalVariables.textColor,
              ),
            ),
            trailing: Transform.scale(
              scaleY: 0.7,
              scaleX: 0.8,
              child: Switch(
                value: item1['availability'],
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: GlobalVariables.textColor.withOpacity(0.6),
                activeThumbImage: AssetImage('assets/images/letter-d.png'),
                inactiveThumbImage: NetworkImage(
                    "https://wallpapercave.com/wp/wp7632851.jpg"),
                onChanged: (bool value) {
                  setState(() {
                    item1['availability']=value;

                    if (selectedCategory.isNotEmpty && subscriptionFoodCategories.containsKey(selectedCategory)) {
                      // Iterate through the items in the selected category
                      for (var item in subscriptionFoodCategories[selectedCategory]!) {
                        // Set the 'availability' of the current item based on whether it matches the selected item
                        item['availability'] = (item == item1) ? value : false;
                      }
                    }
                  });
                },
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
            ) : Container(
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
          )
        ),
      ),
    );
  }

  void showMealSelectionDialog(String name,BuildContext context)
  {

  }

  Widget buildMealTimeButton1(MealTime mealTime, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedMealTime == mealTime ? GlobalVariables.textColor : selectedMealTime == MealTime.All ? GlobalVariables.textColor: Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMealTime = mealTime;
        });
      },
      child: Container(
        width: 75*fem,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color:GlobalVariables.textColor),
          color: backgroundColor,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   getMealTimeImage(mealTime),
              //   width: 15.48 * fem,
              //   height: 14.09 * fem,
              // ),
              // SizedBox(width: 7 * fem),
              Text(
                label,
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1.3102272749 * ffem / fem,
                  color: GlobalVariables.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
