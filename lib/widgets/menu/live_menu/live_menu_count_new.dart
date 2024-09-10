import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:collection';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/live_menu_1/live_menu1_state.dart';
import 'package:partner_admin_portal/bloc/menu_editor/menu_editor_bloc.dart';
import 'package:partner_admin_portal/bloc/menu_editor/menu_editor_event.dart';
import 'package:partner_admin_portal/bloc/menu_editor/menu_editor_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_functions.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_variables.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count2.dart';
import 'package:partner_admin_portal/widgets/menu/menu_editor/menu_editor_item_details2.dart';
import 'package:partner_admin_portal/widgets/menu/menu_editor/section_details_mob.dart';
import 'package:partner_admin_portal/widgets/menu/menu_editor/subscription_availability.dart';
import 'package:partner_admin_portal/widgets/menu/menu_editor/subscription_availability1.dart';
import 'package:partner_admin_portal/widgets/menu/menu_editor/variants_addon.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/widgets/item_availability.dart';
import 'package:partner_admin_portal/widgets/item_availability_mob.dart';
import 'package:partner_admin_portal/widgets/item_details.dart';
import 'package:partner_admin_portal/widgets/item_details_mobile.dart';
import 'package:partner_admin_portal/widgets/menu/menu_editor/menu_editor_item_details.dart';
import 'package:partner_admin_portal/widgets/other_item_details.dart';

import '../../../bloc/live_menu/live_menu_event.dart';
import '../../../bloc/live_menu_1/live_menu1_bloc.dart';
import '../../../bloc/menu/menu_bloc.dart';
import '../../../bloc/menu/menu_event.dart';
import '../../../bloc/menu/menu_state.dart';
import '../../../repository/menu_services.dart';
import '../../custom_textfield.dart';
import '../../../constants/search_bar.dart';
import '../../../constants/utils.dart';
import '../../item_availability1.dart';
import '../item_details_1.dart';
import 'meal_edit_mobile.dart';

class LiveMenuCountNew extends StatefulWidget {
  final String searchQuery;
  const LiveMenuCountNew({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<LiveMenuCountNew> createState() => _MenuEditorState();
}

class _MenuEditorState extends State<LiveMenuCountNew> with TickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<FormState> _checkKey = GlobalKey<FormState>();

  late TabController _menuController;


  bool switchValue = false;
  String selectedCategory = 'South indian breakfast';

  String selectedItem = MenuEditorVariables.selectedItem;
  String hoverItem = '';

  void updateSelectedItem(String newItem) {
    setState(() {
      selectedItem = newItem;
    });
  }

  MenuService menuService = MenuService();

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

  Map<String, List<Map<String,dynamic>>> foodCategories = {};

  Set<String> selectedCategories = Set();

  bool isFirstItemDeleted = false;
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _menuController = TabController(length: 4, vsync: this);
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
      Future.delayed(Duration(seconds: 2), () {
        _simulateDeleteAnimationForFirstItem();
      });
    });
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Map<String, List<Map<String,dynamic>>> filteredFoodCategory = {};

  String query = "";

  String oldTagName = "";



  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    // print("Selected $selectedItem");
    return BlocBuilder<LiveMenu1Bloc,LiveMenu1State>(builder: (BuildContext menuContext, liveMenuState) {
      if(liveMenuState is LiveMenu1LoadingState) {
        return MenuEditorWidget(menuContext: menuContext);
      }
      if(liveMenuState is LiveMenu1ErrorState) {
        return const Center(child: Text("Error"),);
      }
      if(liveMenuState is LiveMenu1LoadedState) {
        return MenuEditorWidget(menuState: liveMenuState,menuContext: menuContext);
      }
      return Center();
    },

    );
  }




  Widget MenuEditorWidget({LiveMenu1LoadedState? menuState, required BuildContext menuContext}) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    if(menuState != null) {
      foodCategories = LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast;

      print("Live menu new food categories $foodCategories");






      return BlocProvider(
        create: (BuildContext context) => MenuEditorBloc(
        )..add(LoadMenuEditorEvent()),
        child: BlocBuilder<MenuEditorBloc,MenuEditorState>(builder: (BuildContext menuEditorContext, menuEditorState) {
          if(menuEditorState is MenuEditorLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(menuEditorState is MenuEditorErrorState) {
            return const Center(child: Text("Error"),);
          }
          if(menuEditorState is MenuEditorLoadedState) {
            return ResponsiveBuilder(
                mobileBuilder: (BuildContext context,BoxConstraints constraints) {
              filteredFoodCategory = foodCategories;
              filterCategories(menuEditorState);
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
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
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF363563),
                                          ),),

                                        SizedBox(width: 10,),
                                        InkWell(
                                          onTap: () {
                                            MenuEditorFunction.showAddItemCategory(menuContext,context,foodCategories);
                                          },
                                          child: Text("+ ADD ITEM", style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xfffbb830),
                                          ),),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 0,),

                                  Expanded(
                                    child: ReorderableListView.builder(
                                      buildDefaultDragHandles: false,
                                      primary: true,
                                      shrinkWrap: true,

                                      itemCount: filteredFoodCategory.length,
                                      itemBuilder: (context, index) {
                                        print("object");
                                        String category = filteredFoodCategory.keys.elementAt(index);
                                        List<Map<String, dynamic>> itemsList =  filteredFoodCategory[category]!;
                                        List<String> items = itemsList.map((item) => item['disName'] as String).toList();

                                        bool categoryContainsMatch = items.any((item) =>
                                            item.toLowerCase().contains(widget.searchQuery.toLowerCase()));

                                        return ReorderableDragStartListener(
                                          enabled: false,
                                          key: Key(category),
                                          index: index,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {

                                                MenuEditorVariables.selectedItem = "";
                                                selectedItem = "";
                                                MenuEditorVariables.oldestTagName = category;
                                                // MenuEditorVariables.tagController.text = category;
                                                print("category is $category");
                                              });
                                              context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(menuEditorState.selectedCategories,menuEditorState.foodCategories, category));
                                            },
                                            child: Column(
                                              key: Key('$category'),
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                                  color: menuEditorState.selectedCategories.contains(category)
                                                      ? Color(0xFF363563)
                                                      : null,
                                                  child: ListTile(
                                                    title: Text(
                                                      category,
                                                      softWrap: false,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.bold,
                                                        color: menuEditorState.selectedCategories.contains(category)
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                    leading: Icon(
                                                      Icons.grid_view_rounded,
                                                      size: 10,
                                                      color: menuEditorState.selectedCategories.contains(category)
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),

                                                  ),
                                                ),
                                                Visibility(
                                                  visible: menuEditorState.selectedCategories.contains(category),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: _buildItemsListMob(category, itemsList,menuEditorState.selectedCategories,"Meal"),
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
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
                tabletBuilder: (BuildContext context,BoxConstraints constraints) {
                  query = widget.searchQuery;
                  filteredFoodCategory = {};
                  if (query != "") {
                    filteredFoodCategory = {}; // Reset filteredFoodCategory outside the loop
                    foodCategories.forEach((cuisine, items) {
                      List<Map<String, dynamic>> matchingItems = items
                          .where((item) => item['disName'].toLowerCase().contains(query.toLowerCase()))
                          .toList();

                      if (matchingItems.isNotEmpty) {
                        selectedCategories.add(cuisine);
                        menuEditorState.selectedCategories.add(cuisine);
                        filteredFoodCategory[cuisine] = matchingItems;
                      }
                    });


                  }
                  else {
                    filteredFoodCategory = foodCategories;
                    selectedCategories = {};
                    MenuEditorVariables.selectedCategories = {};
                    MenuEditorVariables.selectedCategories.add(MenuEditorVariables.tagController.text);

                  }
                  filterCategories(menuEditorState);

                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                              onTap: () {
                                                MenuEditorFunction.showAddItemCategory(menuContext,context,foodCategories);
                                              },
                                              child: Text("+ ADD ITEM", style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xfffbb830),
                                              ),),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 0,),

                                      Expanded(
                                        child: ReorderableListView.builder(
                                          buildDefaultDragHandles: false,
                                          primary: true,
                                          shrinkWrap: true,
                                          itemCount: filteredFoodCategory.length,
                                          itemBuilder: (context, index) {
                                            print("object");
                                            String category = filteredFoodCategory.keys.elementAt(index);
                                            List<Map<String, dynamic>> itemsList =  filteredFoodCategory[category]!;
                                            List<String> items = itemsList.map((item) => item['disName'] as String).toList();

                                            bool categoryContainsMatch = items.any((item) =>
                                                item.toLowerCase().contains(widget.searchQuery.toLowerCase()));

                                            return ReorderableDragStartListener(
                                              enabled: true,
                                              key: Key(category),
                                              index: index,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {

                                                    MenuEditorVariables.selectedItem = "";
                                                    selectedItem = "";
                                                    MenuEditorVariables.oldestTagName = category;
                                                    // MenuEditorVariables.tagController.text = category;
                                                    print("category is $category");
                                                  });
                                                  context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(menuEditorState.selectedCategories,menuEditorState.foodCategories, category));
                                                },
                                                child: Column(
                                                  key: Key('$category'),
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(top: 5, bottom: 5),
                                                      color: menuEditorState.selectedCategories.contains(category)
                                                          ? Color(0xFF363563)
                                                          : null,
                                                      child: ListTile(
                                                        title: Text(
                                                          category,
                                                          softWrap: false,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: menuEditorState.selectedCategories.contains(category)
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        leading: Icon(
                                                          Icons.grid_view_rounded,
                                                          size: 10,
                                                          color: menuEditorState.selectedCategories.contains(category)
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),

                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: menuEditorState.selectedCategories.contains(category),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: _buildItemsListTab(category, itemsList,menuEditorState.selectedCategories),
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


                              Expanded(
                                flex: 5,
                                child: Scaffold(

                                  body: selectedItem!= '' ? LiveMenuCountBreakfast() : Center(child: Text(' Click items within the section to view details',style: GlobalVariables.dataItemStyle,),),
                                  bottomNavigationBar: Container(
                                    height: 70,
                                    // color: Colors.grey.shade50,
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10*fem,),
                                        InkWell(
                                          onTap: () {

                                          },
                                          child: Container(
                                            width: 130,
                                            height: 40,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: Colors.red),
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
                                        ),
                                        SizedBox(width: 30*fem,),
                                        InkWell(
                                          onTap: (){
                                            setState(() {

                                            });
                                          },
                                          child: Container(
                                            width: 130,
                                            height: 40,
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
                                        ),
                                        SizedBox(width: 30*fem,),
                                        InkWell(
                                          onTap: () {
                                            MenuEditorVariables.displayNameController.text = MenuEditorVariables.displayNameController.text.trim();
                                            String firstCharacter = MenuEditorVariables.displayNameController.text.isNotEmpty
                                                ? MenuEditorVariables.displayNameController.text[0]
                                                : '';

                                            bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                                                (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
                                                    '0123456789'.contains(firstCharacter)));

                                            MenuEditorVariables.requestBody = {
                                              "ritem_name": MenuEditorVariables.nameController.text,
                                              "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                                              "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                                              "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                                              "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                                              "ritem_normalFinalPrice" : MenuEditorVariables.normalFinalPrice,
                                              "ritem_preorderFinalPrice" : MenuEditorVariables.preOrderFinalPrice,
                                              // "ritem_tag" : MenuEditorVariables.i
                                              "ritem_priceRange": MenuEditorVariables.budgetController.text,
                                              "ritem_itemType": MenuEditorVariables.typeController.text,
                                              "ritem_itemSubType": MenuEditorVariables.subTypeController.text,
                                              "ritem_comboType": MenuEditorVariables.comboController.text,
                                              "ritem_rawSource": MenuEditorVariables.rawSourceController.text,
                                              "ritem_category": MenuEditorVariables.categoryController.text,
                                              "ritem_subCategory": MenuEditorVariables.subCategoryController.text,
                                              "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                                              "ritem_regional": MenuEditorVariables.regionalController.text,
                                              // "ritem_tag" : MenuEditorVariables.subTagController.text,
                                              "fp_unit_avail_days_and_meals": {
                                                "Sun": {
                                                  "Breakfast": true,
                                                  "Lunch": false,
                                                  "Dinner": true,
                                                  "BreakfastSession1": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S1'],
                                                  "BreakfastSession2": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S2'],
                                                  "BreakfastSession3": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S3'],
                                                  "BreakfastSession4": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S4'],
                                                  "LunchSession1": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S1'],
                                                  "LunchSession2": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S2'],
                                                  "LunchSession3": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S3'],
                                                  "LunchSession4": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S4'],
                                                  "DinnerSession1": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S1'],
                                                  "DinnerSession2": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S2'],
                                                  "DinnerSession3": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S3'],
                                                  "DinnerSession4": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S4'],
                                                },
                                                "Mon": {
                                                  "Breakfast": true,
                                                  "Lunch": true,
                                                  "Dinner": false,
                                                  "BreakfastSession1": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S1'],
                                                  "BreakfastSession2": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S2'],
                                                  "BreakfastSession3": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S3'],
                                                  "BreakfastSession4": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S4'],
                                                  "LunchSession1": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S1'],
                                                  "LunchSession2": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S2'],
                                                  "LunchSession3": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S3'],
                                                  "LunchSession4": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S4'],
                                                  "DinnerSession1": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S1'],
                                                  "DinnerSession2": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S2'],
                                                  "DinnerSession3": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S3'],
                                                  "DinnerSession4": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S4'],
                                                },
                                                "Tue": {
                                                  "Breakfast": false,
                                                  "Lunch": true,
                                                  "Dinner": true,
                                                  "BreakfastSession1": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S1'],
                                                  "BreakfastSession2": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S2'],
                                                  "BreakfastSession3": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S3'],
                                                  "BreakfastSession4": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S4'],
                                                  "LunchSession1": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S1'],
                                                  "LunchSession2": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S2'],
                                                  "LunchSession3": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S3'],
                                                  "LunchSession4": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S4'],
                                                  "DinnerSession1": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S1'],
                                                  "DinnerSession2": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S2'],
                                                  "DinnerSession3": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S3'],
                                                  "DinnerSession4": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S4'],
                                                },
                                                "Wed": {
                                                  "Breakfast": true,
                                                  "Lunch": false,
                                                  "Dinner": false,
                                                  "BreakfastSession1": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S1'],
                                                  "BreakfastSession2": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S2'],
                                                  "BreakfastSession3": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S3'],
                                                  "BreakfastSession4": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S4'],
                                                  "LunchSession1": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S1'],
                                                  "LunchSession2": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S2'],
                                                  "LunchSession3": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S3'],
                                                  "LunchSession4": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S4'],
                                                  "DinnerSession1": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S1'],
                                                  "DinnerSession2": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S2'],
                                                  "DinnerSession3": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S3'],
                                                  "DinnerSession4": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S4'],
                                                },
                                                "Thu": {
                                                  "Breakfast": false,
                                                  "Lunch": true,
                                                  "Dinner": true,
                                                  "BreakfastSession1": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S1'],
                                                  "BreakfastSession2": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S2'],
                                                  "BreakfastSession3": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S3'],
                                                  "BreakfastSession4": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S4'],
                                                  "LunchSession1": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S1'],
                                                  "LunchSession2": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S2'],
                                                  "LunchSession3": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S3'],
                                                  "LunchSession4": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S4'],
                                                  "DinnerSession1": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S1'],
                                                  "DinnerSession2": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S2'],
                                                  "DinnerSession3": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S3'],
                                                  "DinnerSession4": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S4'],
                                                },
                                                "Fri": {
                                                  "Breakfast": true,
                                                  "Lunch": true,
                                                  "Dinner": true,
                                                  "BreakfastSession1": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S1'],
                                                  "BreakfastSession2": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S2'],
                                                  "BreakfastSession3": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S3'],
                                                  "BreakfastSession4": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S4'],
                                                  "LunchSession1": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S1'],
                                                  "LunchSession2": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S2'],
                                                  "LunchSession3": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S3'],
                                                  "LunchSession4": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S4'],
                                                  "DinnerSession1": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S1'],
                                                  "DinnerSession2": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S2'],
                                                  "DinnerSession3": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S3'],
                                                  "DinnerSession4": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S4'],
                                                },
                                                "Sat": {
                                                  "Breakfast": false,
                                                  "Lunch": false,
                                                  "Dinner": false,
                                                  "BreakfastSession1": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S1'],
                                                  "BreakfastSession2": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S2'],
                                                  "BreakfastSession3": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S3'],
                                                  "BreakfastSession4": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S4'],
                                                  "LunchSession1": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S1'],
                                                  "LunchSession2": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S2'],
                                                  "LunchSession3": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S3'],
                                                  "LunchSession4": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S4'],
                                                  "DinnerSession1": MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S1'],
                                                  "DinnerSession2": MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S2'],
                                                  "DinnerSession3": MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S3'],
                                                  "DinnerSession4": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S4'],
                                                },
                                              }
                                            };

                                            String oldTag = "";
                                            String itemId = "";
                                            String name = "";
                                            Map<String, dynamic> oneItem = {};
                                            bool itemExists = false;
                                            if(MenuEditorVariables.displayNameController.text.trim() == "") {
                                              MenuEditorFunction.showShouldNotNull(context,"Display");
                                            }
                                            else if( double.parse(MenuEditorVariables.normalPriceController.text) < 1 || double.parse(MenuEditorVariables.preorderPriceController.text) < 1){
                                              MenuEditorFunction.showPriceShouldNotBeBull(context,);
                                            }
                                            else if(MenuEditorVariables.displayNameController.text.trim().length <3){
                                              MenuEditorFunction.showStringLengthAlert(context, "Display name");
                                            } else if(!isFirstCharacterLetterOrDigit) {
                                              MenuEditorFunction.showOnlyDigitAndLettersAlert(context, "Display name");
                                            }
                                            else {
                                              for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                                                if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                                                  print("Item already exists");
                                                  name = itemName['disName'];
                                                  itemExists = true;
                                                  break; // Exit the loop as soon as we find a match
                                                }
                                              }


                                            }




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
                                  ),
                                ),
                              ),


                            ],
                          ),
                        ),
                      ],
                    ),


                  );
                },
                desktopBuilder: (BuildContext context,BoxConstraints constraints) {
                  query = widget.searchQuery;
                  filteredFoodCategory = {};
                  if (query != "") {
                    filteredFoodCategory = {}; // Reset filteredFoodCategory outside the loop
                    foodCategories.forEach((cuisine, items) {
                      List<Map<String, dynamic>> matchingItems = items
                          .where((item) => item['disName'].toLowerCase().contains(query.toLowerCase()))
                          .toList();

                      if (matchingItems.isNotEmpty) {
                        selectedCategories.add(cuisine);
                        menuEditorState.selectedCategories.add(cuisine);
                        filteredFoodCategory[cuisine] = matchingItems;
                      }
                    });


                  }
                  else {
                    filteredFoodCategory = foodCategories;
                    selectedCategories = {};
                    MenuEditorVariables.selectedCategories = {};
                    MenuEditorVariables.selectedCategories.add(MenuEditorVariables.tagController.text);

                  }
                  filterCategories(menuEditorState);

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
                                              onTap: () {
                                                MenuEditorFunction.showAddItemCategory(menuContext,context,foodCategories);
                                              },
                                              child: Text("+ ADD ITEM", style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xfffbb830),
                                              ),),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 0,),

                                      Expanded(
                                        child: ReorderableListView.builder(
                                          buildDefaultDragHandles: false,
                                          primary: true,
                                          shrinkWrap: true,
                                          itemCount: filteredFoodCategory.length,
                                          itemBuilder: (context, index) {
                                            print("object");
                                            String category = filteredFoodCategory.keys.elementAt(index);
                                            List<Map<String, dynamic>> itemsList =  filteredFoodCategory[category]!;
                                            List<String> items = itemsList.map((item) => item['disName'] as String).toList();

                                            bool categoryContainsMatch = items.any((item) =>
                                                item.toLowerCase().contains(widget.searchQuery.toLowerCase()));

                                            return ReorderableDragStartListener(
                                              enabled: true,
                                              key: Key(category),
                                              index: index,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {

                                                    MenuEditorVariables.selectedItem = "";
                                                    selectedItem = "";
                                                    oldTagName = category;
                                                    MenuEditorVariables.oldestTagName = category;
                                                    MenuEditorVariables.tagController.text = category;
                                                    print("category is $category");
                                                  });
                                                  context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(menuEditorState.selectedCategories,menuEditorState.foodCategories, category));
                                                },
                                                child: Column(
                                                  key: Key('$category'),
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(top: 5, bottom: 5),
                                                      color: menuEditorState.selectedCategories.contains(category)
                                                          ? Color(0xFF363563)
                                                          : null,
                                                      child: ListTile(
                                                        title: Text(
                                                          category,
                                                          softWrap: false,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: menuEditorState.selectedCategories.contains(category)
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        leading: Icon(
                                                          Icons.grid_view_rounded,
                                                          size: 10,
                                                          color: menuEditorState.selectedCategories.contains(category)
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),

                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: menuEditorState.selectedCategories.contains(category),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: _buildItemsList(category, itemsList,menuEditorState.selectedCategories,menuContext),
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


                              Expanded(
                                flex: 5,
                                child: Scaffold(
                                  body: selectedItem!= '' ?
                                  LiveMenuCountBreakfast() :
                                  Center(child: Text(' Click items within the section to view details',style: GlobalVariables.dataItemStyle,),),
                                  bottomNavigationBar: Visibility(
                                    visible: selectedItem!='',
                                    child: Container(
                                      height: 70,
                                      // color: Colors.grey.shade50,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 20*fem,),
                                          InkWell(
                                            onTap: () {
                                              showDeleteConfirmationDialog(menuContext);
                                            },
                                            child: Container(
                                              width: 130,
                                              height: 40,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(color: Colors.red),
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
                                          ),
                                          SizedBox(width: 40*fem,),
                                          InkWell(
                                            onTap: (){
                                              setState(() {

                                              });
                                            },
                                            child: Container(
                                              width: 130,
                                              height: 40,
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
                                          ),
                                          SizedBox(width: 40*fem,),
                                          InkWell(
                                            onTap: () {
                                              MenuEditorVariables.displayNameController.text = MenuEditorVariables.displayNameController.text.trim();
                                              String firstCharacter = MenuEditorVariables.displayNameController.text.isNotEmpty
                                                  ? MenuEditorVariables.displayNameController.text[0]
                                                  : '';

                                              bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                                                  (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
                                                      '0123456789'.contains(firstCharacter)));

                                              MenuEditorVariables.requestBody = {
                                                "ritem_name": MenuEditorVariables.nameController.text,
                                                "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                                                "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                                                "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                                                "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                                                "ritem_normalFinalPrice" : MenuEditorVariables.normalFinalPrice,
                                                "ritem_preorderFinalPrice" : MenuEditorVariables.preOrderFinalPrice,
                                                // "ritem_tag" : MenuEditorVariables.i
                                                "ritem_priceRange": MenuEditorVariables.budgetController.text,
                                                "ritem_itemType": MenuEditorVariables.typeController.text,
                                                "ritem_itemSubType": MenuEditorVariables.subTypeController.text,
                                                "ritem_comboType": MenuEditorVariables.comboController.text,
                                                "ritem_rawSource": MenuEditorVariables.rawSourceController.text,
                                                "ritem_category": MenuEditorVariables.categoryController.text,
                                                "ritem_subCategory": MenuEditorVariables.subCategoryController.text,
                                                "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                                                "ritem_regional": MenuEditorVariables.regionalController.text,
                                                // "ritem_tag" : MenuEditorVariables.subTagController.text,
                                                "fp_unit_avail_days_and_meals": {
                                                  "Sun": {
                                                    "Breakfast": true,
                                                    "Lunch": false,
                                                    "Dinner": true,
                                                    "BreakfastSession1": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S1'],
                                                    "BreakfastSession2": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S2'],
                                                    "BreakfastSession3": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S3'],
                                                    "BreakfastSession4": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S4'],
                                                    "LunchSession1": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S1'],
                                                    "LunchSession2": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S2'],
                                                    "LunchSession3": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S3'],
                                                    "LunchSession4": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S4'],
                                                    "DinnerSession1": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S1'],
                                                    "DinnerSession2": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S2'],
                                                    "DinnerSession3": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S3'],
                                                    "DinnerSession4": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S4'],
                                                  },
                                                  "Mon": {
                                                    "Breakfast": true,
                                                    "Lunch": true,
                                                    "Dinner": false,
                                                    "BreakfastSession1": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S1'],
                                                    "BreakfastSession2": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S2'],
                                                    "BreakfastSession3": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S3'],
                                                    "BreakfastSession4": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S4'],
                                                    "LunchSession1": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S1'],
                                                    "LunchSession2": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S2'],
                                                    "LunchSession3": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S3'],
                                                    "LunchSession4": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S4'],
                                                    "DinnerSession1": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S1'],
                                                    "DinnerSession2": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S2'],
                                                    "DinnerSession3": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S3'],
                                                    "DinnerSession4": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S4'],
                                                  },
                                                  "Tue": {
                                                    "Breakfast": false,
                                                    "Lunch": true,
                                                    "Dinner": true,
                                                    "BreakfastSession1": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S1'],
                                                    "BreakfastSession2": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S2'],
                                                    "BreakfastSession3": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S3'],
                                                    "BreakfastSession4": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S4'],
                                                    "LunchSession1": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S1'],
                                                    "LunchSession2": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S2'],
                                                    "LunchSession3": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S3'],
                                                    "LunchSession4": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S4'],
                                                    "DinnerSession1": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S1'],
                                                    "DinnerSession2": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S2'],
                                                    "DinnerSession3": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S3'],
                                                    "DinnerSession4": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S4'],
                                                  },
                                                  "Wed": {
                                                    "Breakfast": true,
                                                    "Lunch": false,
                                                    "Dinner": false,
                                                    "BreakfastSession1": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S1'],
                                                    "BreakfastSession2": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S2'],
                                                    "BreakfastSession3": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S3'],
                                                    "BreakfastSession4": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S4'],
                                                    "LunchSession1": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S1'],
                                                    "LunchSession2": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S2'],
                                                    "LunchSession3": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S3'],
                                                    "LunchSession4": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S4'],
                                                    "DinnerSession1": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S1'],
                                                    "DinnerSession2": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S2'],
                                                    "DinnerSession3": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S3'],
                                                    "DinnerSession4": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S4'],
                                                  },
                                                  "Thu": {
                                                    "Breakfast": false,
                                                    "Lunch": true,
                                                    "Dinner": true,
                                                    "BreakfastSession1": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S1'],
                                                    "BreakfastSession2": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S2'],
                                                    "BreakfastSession3": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S3'],
                                                    "BreakfastSession4": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S4'],
                                                    "LunchSession1": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S1'],
                                                    "LunchSession2": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S2'],
                                                    "LunchSession3": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S3'],
                                                    "LunchSession4": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S4'],
                                                    "DinnerSession1": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S1'],
                                                    "DinnerSession2": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S2'],
                                                    "DinnerSession3": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S3'],
                                                    "DinnerSession4": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S4'],
                                                  },
                                                  "Fri": {
                                                    "Breakfast": true,
                                                    "Lunch": true,
                                                    "Dinner": true,
                                                    "BreakfastSession1": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S1'],
                                                    "BreakfastSession2": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S2'],
                                                    "BreakfastSession3": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S3'],
                                                    "BreakfastSession4": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S4'],
                                                    "LunchSession1": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S1'],
                                                    "LunchSession2": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S2'],
                                                    "LunchSession3": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S3'],
                                                    "LunchSession4": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S4'],
                                                    "DinnerSession1": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S1'],
                                                    "DinnerSession2": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S2'],
                                                    "DinnerSession3": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S3'],
                                                    "DinnerSession4": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S4'],
                                                  },
                                                  "Sat": {
                                                    "Breakfast": false,
                                                    "Lunch": false,
                                                    "Dinner": false,
                                                    "BreakfastSession1": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S1'],
                                                    "BreakfastSession2": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S2'],
                                                    "BreakfastSession3": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S3'],
                                                    "BreakfastSession4": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S4'],
                                                    "LunchSession1": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S1'],
                                                    "LunchSession2": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S2'],
                                                    "LunchSession3": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S3'],
                                                    "LunchSession4": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S4'],
                                                    "DinnerSession1": MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S1'],
                                                    "DinnerSession2": MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S2'],
                                                    "DinnerSession3": MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S3'],
                                                    "DinnerSession4": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S4'],
                                                  },
                                                }
                                              };

                                              String oldTag = "";
                                              String itemId = "";
                                              String name = "";
                                              Map<String, dynamic> oneItem = {};
                                              bool itemExists = false;
                                              if(MenuEditorVariables.displayNameController.text.trim() == "") {
                                                MenuEditorFunction.showShouldNotNull(context,"Display");
                                              }
                                              else if( double.parse(MenuEditorVariables.normalPriceController.text) < 1 || double.parse(MenuEditorVariables.preorderPriceController.text) < 1){
                                                MenuEditorFunction.showPriceShouldNotBeBull(context,);
                                              }
                                              else if(MenuEditorVariables.displayNameController.text.trim().length <3){
                                                MenuEditorFunction.showStringLengthAlert(context, "Display name");
                                              } else if(!isFirstCharacterLetterOrDigit) {
                                                MenuEditorFunction.showOnlyDigitAndLettersAlert(context, "Display name");
                                              }
                                              else {
                                                for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                                                  if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                                                    print("Item already exists");
                                                    name = itemName['disName'];
                                                    itemExists = true;
                                                    break; // Exit the loop as soon as we find a match
                                                  }
                                                }

                                                if (itemExists  && ItemDetails.checking && !ItemDetails.enable) {
                                                  MenuEditorFunction.showAlreadyExistAlert(context);
                                                }
                                                else {
                                                  // Item doesn't exist, add it to the list
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

                                                  if (itemExists && ItemDetails.checking && !ItemDetails.enable) {
                                                    // Navigator.of(context).pop();
                                                    MenuEditorFunction.showReplaceItemAlert(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem);
                                                  }
                                                  else {
                                                    // Map<String, dynamic> newItem = {'name': item.text, 'availability': true};
                                                    // foodCategories[category]!.add(newItem);
                                                    menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItemBreakfast["_id"], MenuEditorVariables.requestBody, menuState.menuItemBreakfast['disName']));
                                                  }
                                                }
                                              }




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
          return CircularProgressIndicator();
        },
        ),
      );
    }
    else {
      return Center(child: CircularProgressIndicator());
    }
  }


  List<Widget> _buildItemsListTab(String category, List<Map<String, dynamic>> itemsList,Set<String> selectedCategories) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);

    print( "Selected CAtegories ${selectedCategory.length}");
    if ( selectedCategories.isNotEmpty && selectedCategories.contains(category)) {
      return itemsList.map((item) {
        String itemName = item['disName'] as String;
        bool availability = item['availability'] as bool;
        Map<String, dynamic> itemDetails = item;
        print( "Selected CAtegories ${itemName}  ${availability}");
        return _buildDismissibleItemTab(itemName, color, availability, itemDetails);
      }).toList();
    }  else {
      return [
        Center(
          child: Text('Select a category to view items.'),
        ),
      ];
    }
  }


  Widget _buildDismissibleItemTab(String item, Color color,bool itemAvail,Map<String, dynamic> item1) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
    return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
      return Dismissible(
        key: Key(item),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          setState(() {
            foodCategories[selectedCategory]!.remove(item);
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
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: InkWell(
            onTap: () {
              selectedItem = item;
              context.read<MenuBloc>().add(ItemSelectEvent(item1));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: selectedItem == item
                    ? Colors.grey.shade300
                    : hoverItem == item
                    ? Colors.grey.shade100
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
                //         item1['availability']=value;
                //       });
                //     },
                //   ),
                // ),
                trailing: Icon(Icons.arrow_forward_ios_sharp,color: GlobalVariables.textColor,size: 20,),
                leading: item1['category'] == 'Veg' ? Container(
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
              ),
            ),
            // onHover: (isHovered) {
            //   if (isHovered) {
            //     setState(() {
            //       hoverItem = item;
            //     });
            //   } else {
            //     setState(() {
            //       hoverItem = '';
            //     });
            //   }
            // },
          ),
        ),

      );
    },

    );
  }


  List<Widget> _buildItemsList(String category, List<Map<String, dynamic>> itemsList, Set<String> selectedCategories, BuildContext menuContext) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);

    bool isFirstItemAnimated = false; // Variable to track whether animation applied to the first item

    if (selectedCategories.isNotEmpty && selectedCategories.contains(category)) {
      return itemsList.asMap().map((index, item) {
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
                    _buildDismissibleItem(item['disName'], color, item, category, menuContext,index),
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
                              // Add additional widgets here if needed
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
          listItem = _buildDismissibleItem(item['disName'], color, item, category, menuContext,index);
        }

        return MapEntry(index, listItem);
      }).values.toList();
    } else {
      return [
        Center(
          child: Text('Select a category to view items.'),
        ),
      ];
    }
  }


  Widget _buildDismissibleItem(String item, Color color,Map<String, dynamic> item1,String category,BuildContext menuContext,int index) {
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
    return BlocBuilder<LiveMenu1Bloc,LiveMenu1State>(
      builder: (BuildContext context, state) {
        if(state is LiveMenu1LoadedState) {
          return Dismissible(
            key: Key(item),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              print("Swiping $category");
              _showDeleteConfirmationDialog(item1,category,menuContext);
              setState(() {
                foodCategories[category]!.remove(item1);
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
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () {
                  if(ItemDetails.checking)
                  {
                    showDialog(context: context, builder: (Builder) {
                      return AlertDialog(
                        title: Text("Edit will not saved and processed",style: TextStyle(
                          fontFamily: 'BertSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1d1517),
                        ),),

                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

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
                                child: Center(child: Text("Ok",style: TextStyle(color: GlobalVariables.whiteColor),)),
                              ))
                            ],
                          ),

                        ],
                      );
                    });
                  }
                  else{
                    // updateSelectedItem(item);
                    // selectedItem = item;
                    setState(() {
                      MenuEditorVariables.selectedItem = item;
                      selectedItem = MenuEditorVariables.selectedItem;
                      MenuEditorVariables.selectItem = item1;
                      MenuEditorVariables.itemIndex = index;

                    });
                    // context.read<MenuBloc>().add(MenuItemSelectEvent(item1));

                  }

                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: MenuEditorVariables.selectedItem == item
                        ? GlobalVariables.textColor.withOpacity(0.3)
                        : hoverItem == item1['disName']
                        ? GlobalVariables.textColor.withOpacity(0.1)
                        : Colors.white,
                  ),
                  padding: EdgeInsets.only(left: 5),
                  child: ListTile(
                    title: Text(
                      item,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 11.8,
                        fontWeight: FontWeight.bold,
                        color: MenuEditorVariables.selectedItem == item
                            ? GlobalVariables.textColor
                            : color,
                      ),
                    ),
                    // trailing: Transform.scale(
                    //   scaleY: 0.7,
                    //   scaleX: 0.7,
                    //   child: Switch(
                    //     value: item1['availability'],
                    //     inactiveThumbColor: Colors.white,
                    //     inactiveTrackColor:
                    //     GlobalVariables.textColor.withOpacity(0.6),
                    //     inactiveThumbImage: NetworkImage(
                    //         "https://wallpapercave.com/wp/wp7632851.jpg"),
                    //     onChanged: (bool value) {
                    //       setState(() {
                    //         item1['availability']=value;
                    //         updateSelectedItem(item);
                    //         print(" Heyyy ${item1['_id']}  ${category}  ${item1['disName']}");
                    //         context.read<MenuBloc>().add(UpdateItemAvailability(context,item1['_id'], category, item1['disName'],value,item1,state.menuFoodCategory));
                    //       });
                    //     },
                    //   ),
                    // ),
                    // leading: item1['category'] == 'VEG' ? Container(
                    //   margin: EdgeInsets.fromLTRB(0, 0, 2, 1.5),
                    //   padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                    //   width: 15,
                    //   height: 15,
                    //   decoration: BoxDecoration (
                    //     border: Border.all(color: Color(0xff3d9414)),
                    //     color: Color(0xffffffff),
                    //     borderRadius: BorderRadius.circular(2),
                    //   ),
                    //   child: Center(
                    //     // rectangle1088pGR (946:2202)
                    //     child: SizedBox(
                    //       height: 5,
                    //       width:5,
                    //       child: Container(
                    //         decoration: BoxDecoration (
                    //           borderRadius: BorderRadius.circular(2),
                    //           border: Border.all(color: Color(0xff3d9414)),
                    //           color: Color(0xff3d9414),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // )
                    //     : Container(
                    //   // group32g8y (946:2182)
                    //   margin: EdgeInsets.fromLTRB(0, 0, 2, 1.5),
                    //   padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                    //   width: 15,
                    //   height:15,
                    //   decoration: BoxDecoration (
                    //     border: Border.all(color: Color(0xffd60808)),
                    //     color: Color(0xffffffff),
                    //     borderRadius: BorderRadius.circular(2),
                    //   ),
                    //   child: Center(
                    //     // rectangle1088ezu (946:2184)
                    //     child: SizedBox(
                    //       width: 5,
                    //       height: 5,
                    //       child: Container(
                    //         decoration: BoxDecoration (
                    //           borderRadius: BorderRadius.circular(2),
                    //           border: Border.all(color: Color(0xffd60808)),
                    //           color: Color(0xffd60808),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
                onHover: (isHovered) {
                  if (isHovered) {
                    if(ItemDetails.checking)
                    {
                      // showDialog(context: context, builder: (Builder) {
                      //   return AlertDialog(
                      //     title: Text("Edit will not saved and processed",style: TextStyle(
                      //       fontFamily: 'BertSans',
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.w600,
                      //       color: Color(0xff1d1517),
                      //     ),),
                      //
                      //     actions: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.end,
                      //         children: [
                      //
                      //           TextButton(onPressed: (){
                      //             setState(() {
                      //               updateSelectedItem(item);
                      //               ItemDetails.checking = false;
                      //
                      //             });
                      //             Navigator.pop(context);
                      //           }, child: Container(
                      //             width: 80,
                      //             height: 35,
                      //             decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(1),
                      //                 border: Border.all(color: GlobalVariables.primaryColor),
                      //                 color: GlobalVariables.primaryColor
                      //             ),
                      //             child: Center(child: Text("Ok",style: TextStyle(color: GlobalVariables.whiteColor),)),
                      //           ))
                      //         ],
                      //       ),
                      //
                      //     ],
                      //   );
                      // });
                    }
                    else {
                      hoverItem = item1['disName'];
                    }
                  } else {
                    hoverItem = '';
                  }
                },
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  List<Widget> _buildItemsListMob(String category, List<Map<String, dynamic>> itemsList,Set<String> selectedCategories,String type) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);

    print( "Selected CAtegories ${selectedCategory.length}");
    if ( selectedCategories.isNotEmpty && selectedCategories.contains(category)) {
      return itemsList.map((item) {
        String itemName = item['disName'] as String;
        bool availability = item['availability'] as bool;
        Map<String, dynamic> itemDetails = item;
        print( "Selected CAtegories ${itemName}  ${availability}");
        return _buildDismissibleItemMob(itemName, color, availability, itemDetails,type);
      }).toList();
    }  else {
      return [
        Center(
          child: Text('Select a category to view items.'),
        ),
      ];
    }
  }


  Widget _buildDismissibleItemMob(String item, Color color,bool itemAvail,Map<String, dynamic> item1,String type) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
    return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
      return Dismissible(
        key: Key(item),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          setState(() {
            foodCategories[selectedCategory]!.remove(item);
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
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: InkWell(
            onTap: () {
              selectedItem = item;
              context.read<MenuBloc>().add(ItemSelectEvent(item1));
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderMealEdit(type: type,)));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: selectedItem == item
                    ? Colors.grey.shade300
                    : hoverItem == item
                    ? Colors.grey.shade100
                    : Colors.white,
              ),
              padding: EdgeInsets.only(left: 13),
              child: ListTile(
                title: Text(
                  item,
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 11,
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
                //         item1['availability']=value;
                //       });
                //     },
                //   ),
                // ),
                trailing: Icon(Icons.arrow_forward_ios_sharp,color: GlobalVariables.textColor,size: 20,),
                leading: item1['category'] == 'Veg' ? Container(
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
            // onHover: (isHovered) {
            //   if (isHovered) {
            //     setState(() {
            //       hoverItem = item;
            //     });
            //   } else {
            //     setState(() {
            //       hoverItem = '';
            //     });
            //   }
            // },
          ),
        ),

      );
    },

    );
  }

  void _showDeleteConfirmationDialog(Map<String, dynamic> item,String category,BuildContext menuContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print("Item name and property $item");
        return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: foodCategories[category]!.length == 0  ? Text('$category section will be deleted. \nDo you want to delete the item?',style: GlobalVariables.dataItemStyle,)  :Text('Do you want to delete the item?',style: GlobalVariables.dataItemStyle),
            actions: [
              TextButton(
                onPressed: () {
                  // Reinsert the deleted item back into the list
                  setState(() {
                    foodCategories[category]!.add(item);
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
                  menuContext.read<MenuBloc>().add(DeleteItemEvent(context, item['_id'],MenuEditorVariables.tagController.text,MenuEditorVariables.selectItem));
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
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext menuContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Do you want to delete the item?',style: GlobalVariables.dataItemStyle),
            actions: [
              InkWell(
                onTap: () {
                  // Reinsert the deleted item back into the list
                  // setState(() {
                  //   foodCategories[category]!.add(item);
                  // });

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
                        'Cancel',
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
              InkWell(
                onTap: () {

                  menuContext.read<MenuBloc>().add(DeleteItemEvent(context, MenuEditorVariables.selectItem['_id'],MenuEditorVariables.tagController.text,MenuEditorVariables.selectItem));
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
      },
    );
  }

  void showDeleteSectionItems(BuildContext menuContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Do you want to delete this section?\nAll items under this section will be deleted ?',style: GlobalVariables.dataItemStyle),
            actions: [
              TextButton(
                onPressed: () {
                  // Reinsert the deleted item back into the list
                  // setState(() {
                  //   foodCategories[category]!.add(item);
                  // });

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
                        'Cancel',
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
              InkWell(
                onTap: () {
                  menuContext.read<MenuBloc>().add(DeleteSectionEvent(context, MenuEditorVariables.tagController.text));
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
    }
  }

  void _showDeleteAnimation(String item) {
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

  bool checkAvailabilityForCategory(String category, Map<String, List<Map<String, dynamic>>> foodCategories) {
    // Retrieve the list of items for the specified category
    var items = foodCategories[category];
    if (items != null) {
      // Iterate through each item in the category
      for (var item in items) {
        // Check if 'availability' is true for any item
        if (item['availability'] == true) {
          // If 'availability' is true for any item, return true immediately
          return true;
        }
      }
    }
    // If no item with 'availability' true is found, or if the category doesn't exist, return false
    return false;
  }

  void filterCategories(MenuEditorLoadedState state) {

    bool isVegChecked = MenuEditorVariables.isVegChecked;
    bool isNonVegChecked = MenuEditorVariables.isNonVegChecked;

    // Iterate through each cuisine and its items
    foodCategories.forEach((cuisine, items) {
      List<Map<String, dynamic>> matchingItems = [];

      // Filter items based on the checked categories
      if (isVegChecked) {
        matchingItems.addAll(items.where((item) => item['category'] == 'VEG').toList());
      }

      if (isNonVegChecked) {
        matchingItems.addAll(items.where((item) => item['category'] == 'NON VEG').toList());
      }

      // If there are matching items, add them to the filtered categories
      if (matchingItems.isNotEmpty) {
        selectedCategories.add(cuisine);
        state.selectedCategories.add(cuisine);
        filteredFoodCategory[cuisine] = matchingItems;
      }
    });

    // Print statements for debugging
    filteredFoodCategory.forEach((key, value) {
      print("Cuisine: $key, Items: $value");
    });
  }


}
