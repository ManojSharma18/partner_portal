import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/widgets/item_availability.dart';
import 'package:partner_admin_portal/widgets/item_availability_mob.dart';
import 'package:partner_admin_portal/widgets/item_details.dart';
import 'package:partner_admin_portal/widgets/item_details_mobile.dart';
import 'package:partner_admin_portal/widgets/menu/menu_editor/menu_editor_item_details.dart';
import 'package:partner_admin_portal/widgets/other_item_details.dart';

import '../../custom_textfield.dart';
import '../../../constants/search_bar.dart';
import '../../../constants/utils.dart';

class MenuEditor extends StatefulWidget {
  final String searchQuery;
  const MenuEditor({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<MenuEditor> createState() => _MenuEditorState();
}

class _MenuEditorState extends State<MenuEditor> with TickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<FormState> _checkKey = GlobalKey<FormState>();

  bool switchValue = false;
  String selectedCategory = 'South indian breakfast';

  String selectedItem = 'Idli';
  String hoverItem = '';

  void updateSelectedItem(String newItem) {
    setState(() {
      selectedItem = newItem;
    });
  }



  bool isChecked = false;

  bool basicDetails = false;
  bool itemPricing = true;
  bool variants = false;
  bool addOn = false;
  bool itemImage = false;
  bool itemTimings = false;

  void onBasicDetails() {
    setState(() {
      basicDetails = !basicDetails;
    });
  }

  void onItemPricing() {
    setState(() {
      itemPricing = !itemPricing;
    });
  }

  void onVariant() {
    setState(() {
      variants = !variants;
    });
  }

  void onAddOn() {
    setState(() {
      addOn = !addOn;
    });
  }

  void onItemImage() {
    setState(() {
      itemImage = !itemImage;
    });
  }

  void onItemTimings() {
    setState(() {
      itemTimings = !itemTimings;
    });
  }


  Map<String, List<Map<String,dynamic>>> foodCategories = {
    'South indian breakfast': [
      {'name' : 'Idli', 'availability' : true,'category' : 'veg'},
      {'name' :'Poori','availability' : false,'category' : 'veg'},
      {'name' : 'Shavige bath','availability' : false,'category' : 'veg'}
    ],

    'North indian breakfast': [
      {'name' : 'Chole bature', 'availability' : true,'category' : 'veg'},
      {'name' :'Rava chilla','availability' : false,'category' : 'veg'},
      {'name' : 'Pav bhaji','availability' : true ,'category' : 'veg'}
    ],

    'South indian palya': [
      {'name' : 'Beans palya', 'availability' : true,'category' : 'veg'},
      {'name' :'Balekayi palya','availability' : false,'category' : 'veg'},
      {'name' : 'Soppin palya','availability' : false ,'category' : 'veg'}
    ],

    'North indian subzi': [
      {'name' : 'Aloo moongere ki sabzi', 'availability' : true,'category' : 'veg'},
      {'name' : 'Aloo bhindi','availability' : false,'category' : 'veg'},
      {'name' : 'Gobo mater','availability' : false,'category' : 'veg' }
    ],

    'South indian ricebath': [
      {'name' : 'lemon rice', 'availability' : true,'category' : 'veg'},
      {'name' :'puliyogare','availability' : false,'category' : 'veg'},
      {'name' : 'tomoto anna','availability' : false ,'category' : 'veg'}
    ],

    'South indian sambar': [
      {'name' : 'onion sambar', 'availability' : true,'category' : 'veg'},
      {'name' :'drumstick sambar','availability' : false,'category' : 'veg'},
      {'name' : 'mixed vegitables sambar','availability' : false ,'category' : 'veg'}
    ],

    'South indian sweets': [
      {'name' : 'Akki payasa', 'availability' : true,'category' : 'veg'},
      {'name' :'Godhi payasa','availability' : false,'category' : 'veg'},
      {'name' : 'shavide payasa','availability' : false,'category' : 'veg'}
    ],

  };

  Set<String> selectedCategories = Set();



  bool isFirstItemDeleted = false;
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    selectedCategories.add('South indian breakfast');
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    _animation = Tween<Offset>(
      begin: Offset(0,0),
      end: Offset(-1, 0), // Move leftwards
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _simulateDeleteAnimationForFirstItem();
    });
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Map<String, List<Map<String,dynamic>>> filteredFoodCategory = {};

  String query = "";

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    print("Selected $selectedItem");
    return ResponsiveBuilder(mobileBuilder: (BuildContext context,BoxConstraints constraints){
      return Container(
        margin: EdgeInsets.only(left: 5),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 10,),
          SearchBars(hintText: "Search item", width: MediaQuery.of(context).size.width,height: 45,
            onChanged: (queries){
              setState(() {
                if (queries != "")
                {
                  filteredFoodCategory = {};
                  foodCategories.forEach((cuisine, items) {
                    List<Map<String, dynamic>> matchingItems = items
                        .where((item) => item['name'].toLowerCase().contains(queries.toLowerCase()))
                        .toList();

                    if (matchingItems.isNotEmpty) {
                      selectedCategories.add(cuisine);
                      filteredFoodCategory[cuisine] = matchingItems;
                    }
                  });
                }
                else{
                  filteredFoodCategory = {};
                  selectedCategories = {};
                  selectedCategories.add('South indian breakfast');
                }
              });
            },
          ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("SECTIONS | ${foodCategories.length}",
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF363563),
                    ),),

                  SizedBox(width: 10,),
                  InkWell(
                    onTap: _showAddItemCategory1,
                    child: Text("+ ADD New", style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xfffbb830),
                    ),),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: ReorderableListView.builder(
                buildDefaultDragHandles: false,
                primary: true,
                shrinkWrap: true,
                itemCount: filteredFoodCategory.length == 0
                    ? foodCategories.length
                    : filteredFoodCategory.length,
                itemBuilder: (context, index) {
                  String category = filteredFoodCategory.length == 0
                      ? foodCategories.keys.elementAt(index)
                      : filteredFoodCategory.keys.elementAt(index);
                  List<Map<String, dynamic>> itemsList = filteredFoodCategory.length == 0
                      ? foodCategories[category]!
                      : filteredFoodCategory[category]!;
                  List<String> items = itemsList.map((item) => item['name'] as String).toList();

                  bool categoryContainsMatch = items.any((item) =>
                      item.toLowerCase().contains(widget.searchQuery.toLowerCase()));

                  return ReorderableDragStartListener(
                    enabled: true,
                    key: Key(category),
                    index: index,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (categoryContainsMatch) {
                            if (selectedCategories.contains(category)) {
                              selectedCategories.remove(category);
                            } else {
                              selectedCategories.add(category);
                            }
                          }
                        });
                      },
                      child: Column(
                        key: Key('$category'),
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            color: selectedCategories.contains(category)
                                ? Color(0xFF363563)
                                : null,
                            child: ListTile(
                              title: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: selectedCategories.contains(category)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              leading: Icon(
                                Icons.grid_view_rounded,
                                size: 10,
                                color: selectedCategories.contains(category)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _showAddItemDialog1();
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
                            visible: selectedCategories.contains(category),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: _buildItemsListMob(category, itemsList),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    List<MapEntry<String, List<Map<String, dynamic>>>> entries =
                    filteredFoodCategory.length == 0
                        ? foodCategories.entries.toList()
                        : filteredFoodCategory.entries.toList();
                    MapEntry<String, List<Map<String, dynamic>>> removedEntry =
                    entries.removeAt(oldIndex);
                    entries.insert(newIndex, removedEntry);

                    // Convert the List back to a Map
                    if (filteredFoodCategory.length == 0) {
                      foodCategories = Map.fromEntries(entries);
                    } else {
                      filteredFoodCategory = Map.fromEntries(entries);
                    }
                  });
                },
              ),

            ),

          ],
        ),
      );
    }, tabletBuilder: (BuildContext context,BoxConstraints constraints) {
      query = widget.searchQuery;
      if (query != "") {
        filteredFoodCategory = {}; // Reset filteredFoodCategory outside the loop

        foodCategories.forEach((cuisine, items) {
          List<Map<String, dynamic>> matchingItems = items
              .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
              .toList();

          if (matchingItems.isNotEmpty) {
            selectedCategories.add(cuisine);
            // selectedItem = query;

            // Add the matching items to filteredFoodCategory
            filteredFoodCategory[cuisine] = matchingItems;
          }
        });
      }
      else{
        filteredFoodCategory = {};
        selectedCategories = {};
        selectedCategories.add('South indian breakfast');
      }
      return Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade100
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(left: 5),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("SECTIONS | ${foodCategories.length}",
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF363563),
                                  ),),

                                SizedBox(width: 10,),
                                InkWell(
                                  onTap: _showAddItemCategory,
                                  child: Text("+ ADD New", style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xfffbb830),
                                  ),),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Expanded(
                            child: ReorderableListView.builder(
                              buildDefaultDragHandles: false,
                              primary: true,
                              shrinkWrap: true,
                              itemCount: filteredFoodCategory.length == 0
                                  ? foodCategories.length
                                  : filteredFoodCategory.length,
                              itemBuilder: (context, index) {
                                String category = filteredFoodCategory.length == 0
                                    ? foodCategories.keys.elementAt(index)
                                    : filteredFoodCategory.keys.elementAt(index);
                                List<Map<String, dynamic>> itemsList = filteredFoodCategory.length == 0
                                    ? foodCategories[category]!
                                    : filteredFoodCategory[category]!;
                                List<String> items = itemsList.map((item) => item['name'] as String).toList();

                                bool categoryContainsMatch = items.any((item) =>
                                    item.toLowerCase().contains(widget.searchQuery.toLowerCase()));

                                return ReorderableDragStartListener(
                                  enabled: true,
                                  key: Key(category),
                                  index: index,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (categoryContainsMatch) {
                                          if (selectedCategories.contains(category)) {
                                            selectedCategories.remove(category);
                                          } else {
                                            selectedCategories.add(category);
                                          }
                                        }
                                      });
                                    },
                                    child: Column(
                                      key: Key('$category'),
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 5, bottom: 5),
                                          color: selectedCategories.contains(category)
                                              ? Color(0xFF363563)
                                              : null,
                                          child: ListTile(
                                            title: Text(
                                              category,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: selectedCategories.contains(category)
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            leading: Icon(
                                              Icons.grid_view_rounded,
                                              size: 10,
                                              color: selectedCategories.contains(category)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    _showAddItemDialog();
                                                  },
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(width: 5),
                                                      Icon(
                                                        Icons.add,
                                                        size: 15,
                                                        color: GlobalVariables.primaryColor,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        'ADD ITEM',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: GlobalVariables.primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: selectedCategories.contains(category),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: _buildItemsList(category, itemsList),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }
                                  List<MapEntry<String, List<Map<String, dynamic>>>> entries =
                                  filteredFoodCategory.length == 0
                                      ? foodCategories.entries.toList()
                                      : filteredFoodCategory.entries.toList();
                                  MapEntry<String, List<Map<String, dynamic>>> removedEntry =
                                  entries.removeAt(oldIndex);
                                  entries.insert(newIndex, removedEntry);

                                  // Convert the List back to a Map
                                  if (filteredFoodCategory.length == 0) {
                                    foodCategories = Map.fromEntries(entries);
                                  } else {
                                    filteredFoodCategory = Map.fromEntries(entries);
                                  }
                                });
                              },
                            ),

                          ),
                        ],
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
                    child: DefaultTabController(
                      length: 5, // Number of tabs
                      child: Scaffold(
                        appBar: AppBar(
                          toolbarHeight: 0,backgroundColor:Colors.grey.shade200,
                          bottom: TabBar(
                            controller: _tabController,
                            isScrollable: false,
                            labelPadding: EdgeInsets.symmetric(horizontal: 5),
                            indicatorWeight: 5, // Adjust the indicator weight
                            indicatorColor: Color(0xfffbb830),
                            unselectedLabelColor: Colors.black54,
                            labelColor: Color(0xFF363563),
                            labelStyle: SafeGoogleFont(
                              'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF363563),
                            ),
                            tabs: [
                              Tab(text: 'Item details'),
                              Tab(text: 'Subscription'),
                              Tab(text: 'Availability'),
                              Tab(text: 'Add on'),
                              Tab(text: 'Others'),

                            ],
                          ),
                        ),
                        body: TabBarView(
                          controller: _tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [

                            ItemDetails(name: selectedItem, updateSelectedItem: updateSelectedItem, checkKey: _checkKey,),

                            Center(child: Text('Sbscriptions')),

                            ItemAvailability(checkKey: _checkKey,),

                            Center(child: Text('Tab 4 Content')),

                            Center(child: Text('Tab 5 Content')),
                          ],
                        ),
                        bottomNavigationBar: Visibility(
                          visible: selectedItem!='',
                          child: Padding(
                            padding:  EdgeInsets.only(right: 16.0,left: 50*fem),
                            child: BottomNavigationBar(
                              elevation: 0,
                              type: BottomNavigationBarType.fixed,
                              items: [
                                BottomNavigationBarItem(
                                  icon: Container(
                                    width: 100,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Delete item",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  label: '',
                                ),
                                BottomNavigationBarItem(
                                  icon: Container(
                                    width: 100,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.black54),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                  label: '',
                                ),
                                BottomNavigationBarItem(
                                  icon: Container(
                                    width: 100,
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
                                  label: '',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ],
        ),


      );
    }, desktopBuilder: (BuildContext context,BoxConstraints constraints) {
      query = widget.searchQuery;
      if (query != "") {
        filteredFoodCategory = {}; // Reset filteredFoodCategory outside the loop

        foodCategories.forEach((cuisine, items) {
          List<Map<String, dynamic>> matchingItems = items
              .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
              .toList();

          if (matchingItems.isNotEmpty) {
            selectedCategories.add(cuisine);
            // selectedItem = query;

            // Add the matching items to filteredFoodCategory
            filteredFoodCategory[cuisine] = matchingItems;
          }
        });
      }
      else{
        filteredFoodCategory = {};
        selectedCategories = {};
        selectedCategories.add('South indian breakfast');
      }
      return Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade100
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(left: 5),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("SECTIONS | ${foodCategories.length}",
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF363563),
                                  ),),

                                SizedBox(width: 10,),
                                InkWell(
                                  onTap: _showAddItemCategory,
                                  child: Text("+ ADD New", style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xfffbb830),
                                  ),),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          // Expanded(
                          //   child: ListView.builder(
                          //     itemCount: foodCategories.length,
                          //     itemBuilder: (context, index) {
                          //       String category = foodCategories.keys.elementAt(index);
                          //       List<Map<String, dynamic>> itemsList = foodCategories[category]!;
                          //       List<String> items = itemsList.map((item) => item['name'] as String).toList();
                          //       return InkWell(
                          //         onTap: () {
                          //           print('Tapped on $category');
                          //           setState(() {
                          //             if(selectedCategory == category)
                          //             {
                          //               selectedCategory = "";
                          //             }else{
                          //               selectedCategory = category;
                          //             }
                          //           });
                          //         },
                          //         child: Column(
                          //           children: [
                          //             Container(
                          //               margin: EdgeInsets.only(top: 5, bottom: 5),
                          //               color: selectedCategory == category
                          //                   ? Color(0xFF363563)
                          //                   : null,
                          //               child: ListTile(
                          //                 title: Text(
                          //                   category, style: SafeGoogleFont(
                          //                   'Poppins',
                          //                   fontSize: 12,
                          //                   fontWeight: FontWeight.bold,
                          //                   color: selectedCategory == category
                          //                       ? Colors.white
                          //                       : GlobalVariables.textColor,
                          //                 ),),
                          //                 leading: Icon(
                          //                   Icons.grid_view_rounded, size: 10,
                          //                   color: selectedCategory == category
                          //                       ? Colors.white
                          //                       : Colors.black,),
                          //                 trailing: Row(
                          //                   mainAxisSize: MainAxisSize.min,
                          //                   children: [
                          //
                          //                     Center(
                          //                       child: PopupMenuButton(
                          //                         itemBuilder: (BuildContext context) => [
                          //                           PopupMenuItem(child: Text("Edit"), onTap: () {
                          //                             _showEditDialog(context,category);
                          //                           },),
                          //                           PopupMenuItem(child: Text("Delete"),onTap: () {
                          //                             showDialog(context: context, builder: (Builder) {
                          //                               return AlertDialog(
                          //                                 content: Text(
                          //                                   "This section along with items within section will be deleted.\nAre you sure?",
                          //                                   style: SafeGoogleFont(
                          //                                     'Poppins',
                          //                                     fontSize: 12,
                          //                                     fontWeight: FontWeight.bold,
                          //                                     color: GlobalVariables.textColor,
                          //                                   ),
                          //                                 ),
                          //                                 actions: [
                          //                                   TextButton(onPressed: (){
                          //                                     Navigator.of(context).pop();
                          //                                   }, child: Container(
                          //                                     width: 100,
                          //                                     decoration: BoxDecoration(
                          //                                         color:GlobalVariables.whiteColor,
                          //                                         border:Border.all(color: Colors.black54),
                          //                                         borderRadius: BorderRadius.circular(10)),
                          //                                     padding: EdgeInsets.all(7),
                          //                                     child: Row(
                          //                                       mainAxisAlignment: MainAxisAlignment.center,
                          //                                       children: [
                          //                                         Icon(
                          //                                           Icons.cancel_rounded,
                          //                                           color: Colors.black54,
                          //                                         ),
                          //                                         SizedBox(width: 5),
                          //                                         Text(
                          //                                           'Cancel',
                          //                                           style: SafeGoogleFont(
                          //                                             'Poppins',
                          //                                             fontSize: 12,
                          //                                             fontWeight: FontWeight.bold,
                          //                                             color: Colors.black54,
                          //                                           ),
                          //                                         )
                          //                                       ],
                          //                                     ),
                          //                                   ),),
                          //                                   TextButton(
                          //                                     onPressed: () {
                          //                                      setState(() {
                          //                                        foodCategories.remove(category);
                          //                                      });
                          //                                       Navigator.of(context).pop();
                          //                                     },
                          //                                     child: Container(
                          //                                       width: 100,
                          //                                       decoration: BoxDecoration(
                          //                                           color: Colors.red,
                          //                                           borderRadius: BorderRadius.circular(10)),
                          //                                       padding: EdgeInsets.all(7),
                          //                                       child: Center(
                          //                                         child: Text(
                          //                                           'Delete',
                          //                                           style: SafeGoogleFont(
                          //                                             'Poppins',
                          //                                             fontSize: 14,
                          //                                             fontWeight: FontWeight.bold,
                          //                                             color: GlobalVariables.whiteColor,
                          //                                           ),
                          //                                         ),
                          //                                       ),
                          //                                     ),
                          //                                   ),
                          //                                 ],
                          //                               );
                          //                             });
                          //                           },)
                          //                         ],
                          //                         color: Colors.white,
                          //                        icon: Icon(Icons.more_vert_rounded,color: Colors.white,),
                          //                       ),
                          //                     ),
                          //                     InkWell(
                          //                       onTap: () {
                          //                         setState(() {
                          //                           selectedCategory = category;
                          //                         });
                          //                         _showAddItemDialog();
                          //                       },
                          //                       child: Row(
                          //                         mainAxisSize: MainAxisSize.min,
                          //                         children: [
                          //                           SizedBox(width: 5),
                          //                           Icon(
                          //                               Icons.add,
                          //                               size: 15,
                          //                               color: GlobalVariables
                          //                                   .primaryColor
                          //                           ),
                          //                           SizedBox(width: 5),
                          //                           // Adjust the spacing as needed
                          //                           Text(
                          //                               'ADD ITEM',
                          //                               style: SafeGoogleFont(
                          //                                 'Poppins',
                          //                                 fontSize: 12,
                          //                                 fontWeight: FontWeight.bold,
                          //                                 color: Color(0xfffbb830),
                          //                               )
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //             Visibility(
                          //               visible: selectedCategory == category,
                          //               child: Column(
                          //                 crossAxisAlignment: CrossAxisAlignment
                          //                     .start,
                          //                 mainAxisAlignment: MainAxisAlignment
                          //                     .start,
                          //                 children: _buildItemsList(category,items),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),

                          Expanded(
                            child: ReorderableListView.builder(
                              buildDefaultDragHandles: false,
                              primary: true,
                              shrinkWrap: true,
                              itemCount: filteredFoodCategory.length == 0
                                  ? foodCategories.length
                                  : filteredFoodCategory.length,
                              itemBuilder: (context, index) {
                                String category = filteredFoodCategory.length == 0
                                    ? foodCategories.keys.elementAt(index)
                                    : filteredFoodCategory.keys.elementAt(index);
                                List<Map<String, dynamic>> itemsList = filteredFoodCategory.length == 0
                                    ? foodCategories[category]!
                                    : filteredFoodCategory[category]!;
                                List<String> items = itemsList.map((item) => item['name'] as String).toList();

                                bool categoryContainsMatch = items.any((item) =>
                                    item.toLowerCase().contains(widget.searchQuery.toLowerCase()));

                                return ReorderableDragStartListener(
                                  enabled: true,
                                  key: Key(category),
                                  index: index,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (categoryContainsMatch) {
                                          if (selectedCategories.contains(category)) {
                                            selectedCategories.remove(category);
                                          } else {
                                            selectedCategories.add(category);
                                          }
                                        }
                                      });
                                    },
                                    child: Column(
                                      key: Key('$category'),
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 5, bottom: 5),
                                          color: selectedCategories.contains(category)
                                              ? Color(0xFF363563)
                                              : null,
                                          child: ListTile(
                                            title: Text(
                                              category,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: selectedCategories.contains(category)
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            leading: Icon(
                                              Icons.grid_view_rounded,
                                              size: 10,
                                              color: selectedCategories.contains(category)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    _showAddItemDialog();
                                                  },
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(width: 5),
                                                      Icon(
                                                        Icons.add,
                                                        size: 15,
                                                        color: GlobalVariables.primaryColor,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        'ADD ITEM',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: GlobalVariables.primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: selectedCategories.contains(category),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: _buildItemsList(category, itemsList),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }
                                  List<MapEntry<String, List<Map<String, dynamic>>>> entries =
                                  filteredFoodCategory.length == 0
                                      ? foodCategories.entries.toList()
                                      : filteredFoodCategory.entries.toList();
                                  MapEntry<String, List<Map<String, dynamic>>> removedEntry =
                                  entries.removeAt(oldIndex);
                                  entries.insert(newIndex, removedEntry);

                                  // Convert the List back to a Map
                                  if (filteredFoodCategory.length == 0) {
                                    foodCategories = Map.fromEntries(entries);
                                  } else {
                                    filteredFoodCategory = Map.fromEntries(entries);
                                  }
                                });
                              },
                            ),

                          ),
                        ],
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
                    child: DefaultTabController(
                      length: 5, // Number of tabs
                      child: Scaffold(
                        appBar: AppBar(
                          toolbarHeight: 0,
                          backgroundColor:Colors.grey.shade200,
                          bottom: TabBar(
                            controller: _tabController,
                            isScrollable: false,
                            labelPadding: EdgeInsets.symmetric(horizontal: 5),
                            indicatorWeight: 5, // Adjust the indicator weight
                            indicatorColor: Color(0xfffbb830),
                            unselectedLabelColor: Colors.black54,
                            labelColor: Color(0xFF363563),
                            labelStyle: SafeGoogleFont(
                              'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF363563),
                            ),
                            tabs: [
                              Tab(text: 'Details'),
                              Tab(text: 'Availability'),
                              Tab(text: 'Subscription'),
                              Tab(text: 'Add on'),
                              Tab(text: 'Others'),

                            ],
                          ),
                        ),
                        body: TabBarView(
                          controller: _tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [

                            ItemDetails(name: selectedItem, updateSelectedItem: updateSelectedItem, checkKey: _checkKey,),


                            ItemAvailability(checkKey: _checkKey,),

                            Center(child: Text('Sbscriptions')),

                            Center(child: Text('Tab 4 Content')),

                            OtherItemDetails(),
                          ],
                        ),
                        bottomNavigationBar: Visibility(
                          visible: selectedItem!='',
                          child: Padding(
                            padding:  EdgeInsets.only(right: 16.0,left: 50*fem),
                            child: BottomNavigationBar(
                              elevation: 0,
                              type: BottomNavigationBarType.fixed,
                              items: [
                                BottomNavigationBarItem(
                                  icon: Container(
                                    width: 100,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Delete item",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  label: '',
                                ),
                                BottomNavigationBarItem(
                                  icon: Container(
                                    width: 100,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.black54),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                  label: '',
                                ),
                                BottomNavigationBarItem(
                                  icon: InkWell(
                                    onTap: (){
                                      setState(() {
                                        ItemDetails.checking = false;
                                        if(ItemDetails.displayNameController.text != '')
                                        {
                                          editFoodName(selectedCategory, selectedItem, ItemDetails.displayNameController.text);
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: 100,
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
                                  label: '',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ],
        ),


      );
    });
  }

  void _showPopupMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          Offset.zero,
          overlay.localToGlobal(overlay.size.bottomRight(Offset.zero)),
        ),
        Offset.fromDirection(19) & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'Edit',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
          ),
        ),
      ],
    ).then((String? value) {
      if (value == 'Edit') {
        _handleEditOption('Selected Category');
      } else if (value == 'Delete') {
        _handleDeleteOption('Selected Category');
      }
    });
  }

  void _handleEditOption(String category) {
    // Implement edit logic
    print('Edit category: $category');
  }

  void _handleDeleteOption(String category) {
    // Implement delete logic
    print('Delete category: $category');
  }

  List<Widget> _buildItemsList(String category, List<Map<String, dynamic>> itemsList) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);

    bool isFirstItemAnimated = false; // Variable to track whether animation applied to the first item

    if (selectedCategories.isNotEmpty && selectedCategories.contains(category))
    {
      return itemsList.map((item) {
        Widget listItem;

        if (!isFirstItemAnimated) {
          listItem = AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return SlideTransition(
                position: _animation,
                transformHitTests: true,
                child: Stack(
                  children: [
                    _buildDismissibleItem(item['name'], color,item),
                    if (_animationController.status == AnimationStatus.forward ||
                        _animationController.status == AnimationStatus.reverse)
                        Positioned(
                        right: _animation.value.dx * MediaQuery.of(context).size.width,
                        child: Opacity(
                          opacity: (_animationController.status == AnimationStatus.forward ||
                              _animationController.status == AnimationStatus.reverse)
                              ? 1.0
                              : 0.0,
                          child: Row(
                            children: [

                            ],
                          ),
                        ),
                      ),

                  ],
                ),
              );
            },

          );

          // Mark that the animation has been applied to the first item
          isFirstItemAnimated = true;
        } else {
          // For subsequent items, no animation
          listItem = _buildDismissibleItem(item['name'], color,item);
        }

        return listItem;
      }).toList();
    } else {
      return [
        Center(
          child: Text('Select a category to view items.'),
        ),
      ];
    }
  }

  Widget _buildDismissibleItem(String item, Color color,Map<String, dynamic> item1) {
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
    return Dismissible(
      key: Key(item),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          foodCategories[selectedCategory]!.remove(item1);
        });
        _showDeleteConfirmationDialog(item1);
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
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: () {
            if(ItemDetails.checking)
              {

                showDialog(context: context, builder: (Builder) {
                  return AlertDialog(
                    title: Text("Are you sure u want to cancel?",style: TextStyle(
                      fontFamily: 'BertSans',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1d1517),
                    ),),
                    content: Container(
                      height: 50,
                      child: Center(
                        child: Text("Edit will not saved and processed",style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff1d1517),
                        ) ,),
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Container(
                            width: 80,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black),
                              color: GlobalVariables.whiteColor
                            ),
                            child: Center(child: Text("Cancel",style: TextStyle(
                              color: Colors.black
                            ),)),
                          )),
                          SizedBox(width: 20,),
                          TextButton(onPressed: (){
                            setState(() {
                              updateSelectedItem(item);
                              ItemDetails.checking = false;
                            });
                            Navigator.pop(context);
                          }, child: Container(
                            width: 80,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                border: Border.all(color: GlobalVariables.primaryColor),
                                color: GlobalVariables.primaryColor
                            ),
                            child: Center(child: Text("Confirm",style: TextStyle(color: GlobalVariables.whiteColor),)),
                          ))
                        ],
                      ),

                    ],
                  );
                });
              }
            else{
              updateSelectedItem(item);
              // editFoodName('South indian breakfast', 'Idli', 'New Idli');
              // if(ItemDetails.displayNameController.text != '')
              //   {
              //     editFoodName(selectedCategory, item, ItemDetails.displayNameController.text);
              //   }
            }

          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: selectedItem == item
                  ? Colors.grey.shade200
                  : hoverItem == item
                  ? Colors.grey.shade50
                  : Colors.white,
            ),
            padding: EdgeInsets.only(left: 13),
            child: ListTile(
              title: Text(
                item,
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: selectedItem == item
                      ? GlobalVariables.textColor
                      : color,
                ),
              ),
              trailing: Transform.scale(
                scaleY: 0.8,
                scaleX: 0.8,
                child: Switch(
                  value: item1['availability'],
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor:
                  GlobalVariables.textColor.withOpacity(0.6),
                  inactiveThumbImage: NetworkImage(
                      "https://wallpapercave.com/wp/wp7632851.jpg"),
                  onChanged: (bool value) {
                    setState(() {
                      updateSelectedItem(item);
                      item1['availability']=value;
                    });
                  },
                ),
              ),
              leading: item1['category'] == 'veg' ? Container(
                margin: EdgeInsets.fromLTRB(0, 0, 2, 1.5),
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
            ),
          ),
          onHover: (isHovered) {
            if (isHovered) {
              setState(() {
                hoverItem = item;
              });
            } else {
              setState(() {
                hoverItem = '';
              });
            }
          },
        ),
      ),
    );
  }


  List<Widget> _buildItemsListMob(String category, List<Map<String, dynamic>> itemsList) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);

    bool isFirstItemAnimated = false;

    if (selectedCategories.isNotEmpty && selectedCategories.contains(category))
    {
      return itemsList.map((item) {
        Widget listItem;

        if (!isFirstItemAnimated) {
          listItem = AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return SlideTransition(
                position: _animation,
                transformHitTests: true,
                child: Stack(
                  children: [
                    _buildDismissibleItemMob(item['name'], color,item),
                    if (_animationController.status == AnimationStatus.forward ||
                        _animationController.status == AnimationStatus.reverse)
                      Positioned(
                        right: _animation.value.dx * MediaQuery.of(context).size.width,
                        child: Opacity(
                          opacity: (_animationController.status == AnimationStatus.forward ||
                              _animationController.status == AnimationStatus.reverse)
                              ? 1.0
                              : 0.0,
                          child: Row(
                            children: [

                            ],
                          ),
                        ),
                      ),

                  ],
                ),
              );
            },

          );

          // Mark that the animation has been applied to the first item
          isFirstItemAnimated = true;
        } else {
          // For subsequent items, no animation
          listItem = _buildDismissibleItemMob(item['name'], color,item);
        }

        return listItem;
      }).toList();
    } else {
      return [
        Center(
          child: Text('Select a category to view items.'),
        ),
      ];
    }
  }

  Widget _buildDismissibleItemMob(String item, Color color,Map<String, dynamic> item1) {
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
    return Dismissible(
      key: Key(item),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          foodCategories[selectedCategory]!.remove(item1);
        });
        _showDeleteConfirmationDialog(item1);
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
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: () {
            updateSelectedItem(item);
           Navigator.push(context, MaterialPageRoute(builder: (context) => MenuEditorItemDetails(itemName: item,)));

          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: selectedItem == item
                  ? Colors.grey.shade200
                  : hoverItem == item
                  ? Colors.grey.shade50
                  : Colors.white,
            ),
            padding: EdgeInsets.only(left: 13),
            child: ListTile(
              title: Text(
                item,
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: selectedItem == item
                      ? GlobalVariables.textColor
                      : color,
                ),
              ),
              // trailing: Transform.scale(
              //   scaleY: 0.8,
              //   scaleX: 0.8,
              //   child: Switch(
              //     value: item1['availability'],
              //     inactiveThumbColor: Colors.white,
              //     inactiveTrackColor:
              //     GlobalVariables.textColor.withOpacity(0.6),
              //     inactiveThumbImage: NetworkImage(
              //         "https://wallpapercave.com/wp/wp7632851.jpg"),
              //     onChanged: (bool value) {
              //       setState(() {
              //         updateSelectedItem(item);
              //         item1['availability']=value;
              //       });
              //     },
              //   ),
              // ),
              trailing: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MenuEditorItemDetails(itemName: item,)));
                },
                  child: Icon(Icons.arrow_forward_ios,size: 20,color: GlobalVariables.textColor,)),
              leading: item1['category'] == 'veg' ? Container(
                margin: EdgeInsets.fromLTRB(0, 0, 2, 1.5),
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
          onHover: (isHovered) {
            if (isHovered) {
              setState(() {
                hoverItem = item;
              });
            } else {
              setState(() {
                hoverItem = '';
              });
            }
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Do you want to delete the item?'),
          actions: [
            TextButton(
              onPressed: () {
                // Reinsert the deleted item back into the list
                setState(() {
                  foodCategories[selectedCategory]!.add(item);
                });

                Navigator.of(context).pop(); // Close the AlertDialog
              },
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(7),
                child: Row(
                  children: [
                    Icon(
                      Icons.undo,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Undo',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: GlobalVariables.whiteColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the AlertDialog
              },
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(7),
                child: Row(
                  children: [
                    Icon(Icons.delete, color: CupertinoColors.white),
                    SizedBox(width: 5),
                    Text(
                      'Delete',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: GlobalVariables.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showMenuEditorItems(String itemName) {
    List<String> menuItemTypes = ["Details", "Subscription", "Availability", "Add on", "Other details"];
    String selectedMenuItem = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(Icons.cancel, color: GlobalVariables.primaryColor, size: 22),
              ],
            ),
          ),
          content: Container(
            height: 450,
            width: 500,
            child: ListView.builder(
              itemCount: menuItemTypes.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    selectedMenuItem = menuItemTypes[index];
                    handleMenuItemTap(selectedMenuItem, itemName);
                  },
                  child: Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: GlobalVariables.textColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          menuItemTypes[index],
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: GlobalVariables.textColor,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 20, color: GlobalVariables.textColor),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void handleMenuItemTap(String selectedMenuItem, String itemName) {
    switch (selectedMenuItem) {
      case "Details":
        Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetailsMob(name: itemName)));
        break;
      case "Availability":
        Navigator.push(context, MaterialPageRoute(builder: (context) => ItemAvailableMob()));
        break;
        
    // Add other cases for different menu items
    }
  }


  void _showDeleteAnimation(String item) {

  }

  void _showAddItemDialog() {
    TextEditingController item = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  setState(() {

                    Map<String, dynamic> newItem = {'name': item.text, 'availability': true};
                    foodCategories[selectedCategory]!.add(newItem);
                  });
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
  }
  void _showAddItemDialog1() {
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

                    Map<String, dynamic> newItem = {'name': item.text, 'availability': true};
                    foodCategories[selectedCategory]!.add(newItem);
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


  void _showAddItemCategory() {
    TextEditingController item = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            title: Text('Adding new Category'),
            content: Container(
              height: 400,
              width: 400,
              child: Column(
                children: [
                  CustomTextField(label: 'Search for Category',
                    width: 400,
                    controller: item,
                    dropdownItems: ['Combos','South Indian','North indian','Sri lankan','Afganistani','Italian'],
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
                  Map<String, List<Map<String,dynamic>>> category = { item.text: [],};
                  setState(() {
                    foodCategories.addAll(category);
                  });
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
  }


  void _showAddItemCategory1() {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    TextEditingController item = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            title: Text('Adding new Category'),
            content: Container(
              height: 450,
              child: Column(
                children: [
                  CustomTextField(label: 'Search for Category',
                    width: 300*fem,
                    height: 50,
                    controller: item,
                    dropdownItems: ['Combos','South Indian','North indian','Sri lankan','Afganistani','Italian'],
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
                  Map<String, List<Map<String,dynamic>>> category = { item.text: [],};
                  setState(() {
                    foodCategories.addAll(category);
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

  void _simulateDeleteAnimationForFirstItem() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (foodCategories.isNotEmpty) {
        String firstCategory = foodCategories.keys.first;
        List<Map<String, dynamic>> itemsList = foodCategories[firstCategory]!;
        List<String> firstItems = itemsList.map((item) => item['name'] as String).toList();

        if (firstItems.isNotEmpty) {
          setState(() {
            isFirstItemDeleted = true;
            _animationController.forward().then((_) {


              _animationController.reverse();
              _showDeleteAnimation(firstItems[0]);
            });
          });
        }
      }
    });
  }

  void editFoodName(String category, String oldName, String newName) {
    if (foodCategories.containsKey(category)) {
      var categoryList = foodCategories[category]!;
      for (int i = 0; i < categoryList.length; i++) {
        var foodItem = categoryList[i];
        if (foodItem['name'] == oldName) {
          foodCategories[category]![i]['name'] = newName;
          break;
        }
      }
    }
  }

  Future<void> _showEditDialog(BuildContext context,String category) async {
    String updatedName = category; // Default value

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Cuisine Name'),
          content: TextField(
            onChanged: (value) {
              updatedName = value;
            },
            decoration: InputDecoration(labelText: 'New Cuisine Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle edit
                _handleEditCuisineName(category, updatedName);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }



  void _handleEditCuisineName(String oldName, String newName) {
    List<Map<String, dynamic>> foods = foodCategories.remove(oldName)!;
    foodCategories[newName] = foods;
  }
}
