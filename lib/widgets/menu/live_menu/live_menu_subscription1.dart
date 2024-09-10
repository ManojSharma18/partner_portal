import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:collection';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/menu_editor/menu_editor_bloc.dart';
import 'package:partner_admin_portal/bloc/menu_editor/menu_editor_event.dart';
import 'package:partner_admin_portal/bloc/menu_editor/menu_editor_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_functions.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_variables.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/subsciption_menu.dart';
import 'package:partner_admin_portal/widgets/menu/menu_editor/section_details_mob.dart';
import 'package:partner_admin_portal/widgets/menu/menu_editor/subscription_availability.dart';
import 'package:partner_admin_portal/widgets/menu/menu_editor/variants_addon.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/widgets/item_availability.dart';
import 'package:partner_admin_portal/widgets/item_availability_mob.dart';
import 'package:partner_admin_portal/widgets/item_details.dart';
import 'package:partner_admin_portal/widgets/item_details_mobile.dart';
import 'package:partner_admin_portal/widgets/menu/menu_editor/menu_editor_item_details.dart';
import 'package:partner_admin_portal/widgets/other_item_details.dart';

import '../../../bloc/live_menu/live_menu_event.dart';
import '../../../bloc/menu/menu_bloc.dart';
import '../../../bloc/menu/menu_event.dart';
import '../../../bloc/menu/menu_state.dart';
import '../../../repository/menu_services.dart';
import '../../custom_textfield.dart';
import '../../../constants/search_bar.dart';
import '../../../constants/utils.dart';
import '../../item_availability1.dart';
import '../item_details_1.dart';
import 'live_menu_3.dart';
import 'live_menu_count2.dart';
import 'live_menu_count_multi.dart';

class LiveMenuSubscription1 extends StatefulWidget {
  final String searchQuery;
  const LiveMenuSubscription1({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<LiveMenuSubscription1> createState() => _MenuEditorState();
}

class _MenuEditorState extends State<LiveMenuSubscription1> with TickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<FormState> _checkKey = GlobalKey<FormState>();


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

  Map<String, List<Map<String,dynamic>>> foodCategories = {



  };

  Set<String> selectedCategories = Set();

  bool isFirstItemDeleted = false;
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
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

  // void _updateCategoryName() {
  //   if (oldTagName.isNotEmpty) {
  //     setState(() {
  //       // Update the category name in the data structure
  //       if (filteredFoodCategory.isEmpty) {
  //         if (foodCategories.containsKey(oldTagName)) {
  //           final items = foodCategories.remove(oldTagName);
  //           foodCategories[MenuEditorVariables.tagController.text] = items!;
  //         }
  //       } else {
  //         if (filteredFoodCategory.containsKey(oldTagName)) {
  //           final items = filteredFoodCategory.remove(oldTagName);
  //           filteredFoodCategory[MenuEditorVariables.tagController.text] = items!;
  //         }
  //       }
  //       oldTagName = MenuEditorVariables.tagController.text;
  //     });
  //   }
  // }

  Map<String, List<Map<String,dynamic>>> filteredFoodCategory = {};

  String query = "";

  String oldTagName = "";



  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    // print("Selected $selectedItem");
    return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext menuContext, menuState) {
      if(menuState is MenuLoadingState) {

        return MenuEditorWidget(menuContext: menuContext);
      }
      if(menuState is ErrorState) {
        return const Center(child: Text("Error"),);
      }
      if(menuState is MenuLoadedState) {
        return MenuEditorWidget(menuState: menuState,menuContext: menuContext);
      }
      return Center();
    },

    );
  }




  Widget MenuEditorWidget({MenuLoadedState? menuState, required BuildContext menuContext}) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    if(menuState != null) {
      foodCategories = menuState.foodCategory;
      MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S1'] = menuState.menuItem['sunBreakfastSession1'];
      MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S2'] = menuState.menuItem['sunBreakfastSession2'];
      MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S3'] = menuState.menuItem['sunBreakfastSession3'];
      MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S4'] = menuState.menuItem['sunBreakfastSession4'];
      MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S1'] = menuState.menuItem['sunLunchSession1'];
      MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S2'] = menuState.menuItem['sunLunchSession2'];
      MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S3'] = menuState.menuItem['sunLunchSession3'];
      MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S4'] = menuState.menuItem['sunLunchSession4'];
      MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S1'] = menuState.menuItem['sunDinnerSession1'];
      MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S2'] = menuState.menuItem['sunDinnerSession2'];
      MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S3'] = menuState.menuItem['sunDinnerSession3'];
      MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S4'] = menuState.menuItem['sunDinnerSession4'];
      MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S1'] = menuState.menuItem['monBreakfastSession1'];
      MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S2'] = menuState.menuItem['monBreakfastSession2'];
      MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S3'] = menuState.menuItem['monBreakfastSession3'];
      MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S4'] = menuState.menuItem['monBreakfastSession4'];
      MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S1'] = menuState.menuItem['monLunchSession1'];
      MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S2'] = menuState.menuItem['monLunchSession2'];
      MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S3'] = menuState.menuItem['monLunchSession3'];
      MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S4'] = menuState.menuItem['monLunchSession4'];
      MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S1'] = menuState.menuItem['monDinnerSession1'];
      MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S2'] = menuState.menuItem['monDinnerSession2'];
      MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S3'] = menuState.menuItem['monDinnerSession3'];
      MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S4'] = menuState.menuItem['monDinnerSession4'];
      MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S1'] = menuState.menuItem['tueBreakfastSession1'];
      MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S2'] = menuState.menuItem['tueBreakfastSession2'];
      MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S3'] = menuState.menuItem['tueBreakfastSession3'];
      MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S4'] = menuState.menuItem['tueBreakfastSession4'];
      MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S1'] = menuState.menuItem['tueLunchSession1'];
      MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S2'] = menuState.menuItem['tueLunchSession2'];
      MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S3'] = menuState.menuItem['tueLunchSession3'];
      MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S4'] = menuState.menuItem['tueLunchSession4'];
      MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S1'] = menuState.menuItem['tueDinnerSession1'];
      MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S2'] = menuState.menuItem['tueDinnerSession2'];
      MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S3'] = menuState.menuItem['tueDinnerSession3'];
      MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S4'] = menuState.menuItem['tueDinnerSession4'];
      MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S1'] = menuState.menuItem['wedBreakfastSession1'];
      MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S2'] = menuState.menuItem['wedBreakfastSession2'];
      MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S3'] = menuState.menuItem['wedBreakfastSession3'];
      MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S4'] = menuState.menuItem['wedBreakfastSession4'];
      MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S1'] = menuState.menuItem['wedLunchSession1'];
      MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S2'] = menuState.menuItem['wedLunchSession2'];
      MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S3'] = menuState.menuItem['wedLunchSession3'];
      MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S4'] = menuState.menuItem['wedLunchSession4'];
      MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S1'] = menuState.menuItem['wedDinnerSession1'];
      MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S2'] = menuState.menuItem['wedDinnerSession2'];
      MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S3'] = menuState.menuItem['wedDinnerSession3'];
      MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S4'] = menuState.menuItem['wedDinnerSession4'];
      MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S1'] = menuState.menuItem['thuBreakfastSession1'];
      MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S2'] = menuState.menuItem['thuBreakfastSession2'];
      MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S3'] = menuState.menuItem['thuBreakfastSession3'];
      MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S4'] = menuState.menuItem['thuBreakfastSession4'];
      MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S1'] = menuState.menuItem['thuLunchSession1'];
      MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S2'] = menuState.menuItem['thuLunchSession2'];
      MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S3'] = menuState.menuItem['thuLunchSession3'];
      MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S4'] = menuState.menuItem['thuLunchSession4'];
      MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S1'] = menuState.menuItem['thuDinnerSession1'];
      MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S2'] = menuState.menuItem['thuDinnerSession2'];
      MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S3'] = menuState.menuItem['thuDinnerSession3'];
      MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S4'] = menuState.menuItem['thuDinnerSession4'];
      MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S1'] = menuState.menuItem['friBreakfastSession1'];
      MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S2'] = menuState.menuItem['friBreakfastSession2'];
      MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S3'] = menuState.menuItem['friBreakfastSession3'];
      MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S4'] = menuState.menuItem['friBreakfastSession4'];
      MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S1'] = menuState.menuItem['friLunchSession1'];
      MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S2'] = menuState.menuItem['friLunchSession2'];
      MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S3'] = menuState.menuItem['friLunchSession3'];
      MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S4'] = menuState.menuItem['friLunchSession4'];
      MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S1'] = menuState.menuItem['friDinnerSession1'];
      MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S2'] = menuState.menuItem['friDinnerSession2'];
      MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S3'] = menuState.menuItem['friDinnerSession3'];
      MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S4'] = menuState.menuItem['friDinnerSession4'];
      MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S1'] = menuState.menuItem['satBreakfastSession1'];
      MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S2'] = menuState.menuItem['satBreakfastSession2'];
      MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S3'] = menuState.menuItem['satBreakfastSession3'];
      MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S4'] = menuState.menuItem['satBreakfastSession4'];
      MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S1'] = menuState.menuItem['satLunchSession1'];
      MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S2'] = menuState.menuItem['satLunchSession2'];
      MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S3'] = menuState.menuItem['satLunchSession3'];
      MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S4'] = menuState.menuItem['satLunchSession4'];
      MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S1'] = menuState.menuItem['satDinnerSession1'];
      MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S2'] = menuState.menuItem['satDinnerSession2'];
      MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S3'] = menuState.menuItem['satDinnerSession3'];
      MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S4'] = menuState.menuItem['satDinnerSession4'];

      MenuEditorVariables.nameController.text = menuState.menuItem['name'].toString();
      MenuEditorVariables.displayNameController.text = menuState.menuItem['disName'].toString();
      MenuEditorVariables.subTagController.text = menuState.menuItem['tag'].toString();
      MenuEditorVariables.budgetController.text = menuState.menuItem['priceRange'].toString();
      MenuEditorVariables.typeController.text = menuState.menuItem['itemType'].toString();
      MenuEditorVariables.subTypeController.text = menuState.menuItem['itemSubType'].toString();
      MenuEditorVariables.comboController.text = menuState.menuItem['comboType'].toString();
      MenuEditorVariables.regionalController.text = menuState.menuItem['regional'].toString();
      MenuEditorVariables.rawSourceController.text = menuState.menuItem['rawSource'].toString();
      MenuEditorVariables.categoryController.text = menuState.menuItem['category'].toString();
      MenuEditorVariables.subCategoryController.text = menuState.menuItem['subCategory'].toString();
      MenuEditorVariables.normalPriceController.text = menuState.menuItem['normalPrice'].toString();
      MenuEditorVariables.packagindController.text= menuState.menuItem['packagePrice'].toString();
      MenuEditorVariables.preorderPriceController.text = menuState.menuItem['preorderPrice'].toString();
      MenuEditorVariables.cuisineController.text = menuState.menuItem['cuisine'].toString();
      MenuEditorVariables.normalFinalPrice = menuState.menuItem['normalFinalPrice'] ?? 0;
      MenuEditorVariables.preOrderFinalPrice = menuState.menuItem['preOrderFinalPrice'] ?? 0;


      return BlocProvider(
        create: (BuildContext context) => MenuEditorBloc(
        )..add(LoadMenuEditorEvent()),
        child: BlocBuilder<MenuEditorBloc,MenuEditorState>(builder: (BuildContext menuEditorContext, state) {
          if(state is MenuEditorLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(state is MenuEditorErrorState) {
            return const Center(child: Text("Error"),);
          }
          if(state is MenuEditorLoadedState) {
            return ResponsiveBuilder(
                mobileBuilder: (BuildContext context,BoxConstraints constraints){
                  filteredFoodCategory = foodCategories;
                  filterCategories(state);
                  return Container(
                    margin: EdgeInsets.only(left: 5),
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        SearchBars(hintText: "Search item or section name", width: MediaQuery.of(context).size.width,height: 45,
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
                                onTap: (){
                                  MenuEditorFunction.showAddItemCategory(menuContext,context,foodCategories);
                                },
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
                                      oldTagName = category;
                                      MenuEditorVariables.oldestTagName = category;
                                      // MenuEditorVariables.tagController.text = category;
                                      print("category is $category");
                                    });
                                    context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(state.selectedCategories,state.foodCategories, category));
                                  },
                                  child: Column(
                                    key: Key('$category'),
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 5, bottom: 5),
                                        color: state.selectedCategories.contains(category)
                                            ? Color(0xFF363563)
                                            : null,
                                        child: ListTile(
                                          title: Text(
                                            category,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: state.selectedCategories.contains(category)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          leading: Icon(
                                            Icons.grid_view_rounded,
                                            size: 10,
                                            color: state.selectedCategories.contains(category)
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  bool tagFound = false;

                                                  MenuEditorVariables.tags.forEach((tag) {
                                                    if(category == tag)
                                                    {
                                                      tagFound = true;
                                                    }
                                                  });
                                                  if(tagFound){
                                                    MenuEditorFunction.showAddItemDialogImported(category, context, menuContext, foodCategories);
                                                  }else{
                                                    MenuEditorFunction.showAddItemDialogCreated(category, context, menuContext, foodCategories);
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    SizedBox(width: 5),
                                                    Icon(
                                                      Icons.add,
                                                      size: 18,
                                                      color: GlobalVariables.primaryColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 5,),
                                              InkWell(
                                                onTap: () {
                                                  MenuEditorVariables.tagController.text = category;
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SectionDetailsMob()));
                                                },
                                                child: Icon(
                                                  Icons.arrow_forward_ios_outlined,
                                                  size: 18,
                                                  color: state.selectedCategories.contains(category)
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],

                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: state.selectedCategories.contains(category),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: _buildItemsListMob(category, itemsList,state.selectedCategories,menuContext),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            onReorder: (oldIndex, newIndex) {
                              // setState(() {
                              //   if (oldIndex < newIndex) {
                              //     newIndex -= 1;
                              //   }
                              //   List<MapEntry<String, List<Map<String, dynamic>>>> entries =
                              //   filteredFoodCategory.length == 0
                              //       ? foodCategories.entries.toList()
                              //       : filteredFoodCategory.entries.toList();
                              //   MapEntry<String, List<Map<String, dynamic>>> removedEntry =
                              //   entries.removeAt(oldIndex);
                              //   entries.insert(newIndex, removedEntry);
                              //
                              //   // Convert the List back to a Map
                              //   if (filteredFoodCategory.length == 0) {
                              //     foodCategories = Map.fromEntries(entries);
                              //   } else {
                              //     filteredFoodCategory = Map.fromEntries(entries);
                              //   }
                              // });
                            },
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
                        state.selectedCategories.add(cuisine);
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
                  filterCategories(state);

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
                                                    // MenuEditorVariables.tagController.text = category;
                                                    print("category is $category");
                                                  });
                                                  context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(state.selectedCategories,state.foodCategories, category));
                                                },
                                                child: Column(
                                                  key: Key('$category'),
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(top: 5, bottom: 5),
                                                      color: state.selectedCategories.contains(category)
                                                          ? Color(0xFF363563)
                                                          : null,
                                                      child: ListTile(
                                                        title: Text(
                                                          category,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          softWrap: false,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: state.selectedCategories.contains(category)
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        leading: Icon(
                                                          Icons.grid_view_rounded,
                                                          size: 10,
                                                          color: state.selectedCategories.contains(category)
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                        trailing: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                bool tagFound = false;

                                                                MenuEditorVariables.tags.forEach((tag) {
                                                                  if(category == tag)
                                                                  {
                                                                    tagFound = true;
                                                                  }
                                                                });
                                                                if(tagFound){
                                                                  MenuEditorFunction.showAddItemDialogImported(category, context, menuContext, foodCategories);
                                                                }else{
                                                                  MenuEditorFunction.showAddItemDialogCreated(category, context, menuContext, foodCategories);
                                                                }
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
                                                      visible: state.selectedCategories.contains(category),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: _buildItemsList(category, itemsList,state.selectedCategories),
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


                              Visibility(
                                visible: MenuEditorVariables.selectedItem != "",
                                child: Expanded(
                                  flex: 5,
                                  child: DefaultTabController(
                                    length: 4, // Number of tabs
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

                                            Tab(text: 'Availability'),
                                            Tab(text: 'Subscription'),
                                            Tab(text: 'Details'),
                                            Tab(text: 'Add on'),
                                          ],
                                        ),
                                      ),
                                      body: TabBarView(
                                        controller: _tabController,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [

                                          ItemAvailability(checkKey: _checkKey,menuLoadedState: menuState,),

                                          SubscriptionAvailability(),

                                          // ItemDetails1(resource: MenuEditorVariables.rawSourceController.text, item: MenuEditorVariables.selectItem,),

                                          VariantsAddon(),


                                        ],
                                      ),
                                      bottomNavigationBar: Visibility(
                                        visible: selectedItem!='',
                                        child: Container(
                                          height: 70,
                                          // color: Colors.grey.shade50,
                                          child: Row(
                                            children: [
                                              SizedBox(width: 10*fem,),
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
                                                        menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
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
                                ),

                              ),

                              Visibility(
                                visible: MenuEditorVariables.selectedItem == "",
                                child: Expanded(
                                  flex: 5,
                                  child: DefaultTabController(
                                    length: 1, // Number of tabs
                                    child: Scaffold(
                                      appBar: AppBar(
                                        toolbarHeight: 0,
                                        backgroundColor:Colors.grey.shade200,
                                        bottom: PreferredSize(
                                          preferredSize: Size.fromHeight(52.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 130,
                                                child: TabBar(
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
                                                    Tab(text: 'Section Details'),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 20,),

                                              BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext mContext, mState) {
                                                if(mState is MenuLoadingState) {
                                                  return CircularProgressIndicator();
                                                }
                                                if(mState is MenuLoadedState) {
                                                  return Transform.scale(
                                                    scaleY: 0.8,
                                                    scaleX: 0.8,
                                                    child: Switch(
                                                      value: checkAvailabilityForCategory(MenuEditorVariables.tagController.text, foodCategories),
                                                      inactiveThumbColor: Colors.white,
                                                      inactiveTrackColor:
                                                      GlobalVariables.textColor.withOpacity(0.6),
                                                      inactiveThumbImage: NetworkImage(
                                                          "https://wallpapercave.com/wp/wp7632851.jpg"),
                                                      onChanged: (bool value) {
                                                        mContext.read<MenuBloc>().add(UpdateSectionAvailability(context, MenuEditorVariables.tagController.text, value));
                                                      },
                                                    ),
                                                  );
                                                }
                                                return CircularProgressIndicator();
                                              },

                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      body: TabBarView(
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 20,),
                                              Container(
                                                  margin: EdgeInsets.only(left: 3*fem),
                                                  child: CustomTextField(label: "Tag", controller: MenuEditorVariables.tagController,width: 100*fem,height: 60, displayCount: true,
                                                    onChanged: (val) {
                                                      ItemDetails.checking = true;
                                                    },)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      bottomNavigationBar: Visibility(
                                        visible: selectedItem == '',
                                        child: Container(
                                          height: 70,
                                          color: Colors.grey.shade50,
                                          child: Row(
                                            children: [
                                              SizedBox(width: 10*fem,),
                                              InkWell(
                                                onTap: () {
                                                  showDeleteSectionItems(menuContext);
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
                                                      "Delete section",
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
                                                  MenuEditorVariables.tagController.text = MenuEditorVariables.tagController.text.trim();
                                                  String firstCharacter = MenuEditorVariables.tagController.text.isNotEmpty
                                                      ? MenuEditorVariables.tagController.text[0]
                                                      : '';

                                                  bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                                                      (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
                                                          '0123456789'.contains(firstCharacter)));

                                                  bool itemExists = false;
                                                  if (MenuEditorVariables.tagController.text.trim() == "") {
                                                    MenuEditorFunction.showShouldNotNull(context, "Section");
                                                  } else if (MenuEditorVariables.tagController.text.trim().length < 3) {
                                                    MenuEditorFunction.showStringLengthAlert(context, "Section");
                                                  } else if (!isFirstCharacterLetterOrDigit) {
                                                    MenuEditorFunction.showOnlyDigitAndLettersAlert(context, "Section");
                                                  } else {
                                                    for (final categoryItems in foodCategories.keys) {
                                                      if (categoryItems == MenuEditorVariables.tagController.text.trim()) {
                                                        itemExists = true;
                                                        break;
                                                      }
                                                    }
                                                    if (itemExists && ItemDetails.checking) {
                                                      MenuEditorFunction.showSectionExistAlertWhileUpdating(context, menuContext, MenuEditorVariables.oldestTagName, MenuEditorVariables.tagController.text.trim());
                                                    } else {
                                                      context.read<MenuBloc>().add(UpdateTagNameEvent(context, MenuEditorVariables.oldestTagName, MenuEditorVariables.tagController.text.trim()));
                                                    }
                                                  }

                                                  // ItemDetails.checking = false;

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
                        state.selectedCategories.add(cuisine);
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
                  filterCategories(state);

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
                                  color: Colors.white,
                                  child: DefaultTabController(
                                    length: 4,
                                    child: Scaffold(
                                      appBar:AppBar(
                                        toolbarHeight: 0,
                                        backgroundColor:Colors.grey.shade200,
                                        bottom: PreferredSize(
                                          preferredSize: Size.fromHeight(50.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 600,
                                                child: TabBar(
                                                  // controller: _menuController,
                                                  isScrollable: false,
                                                  indicatorSize: TabBarIndicatorSize.tab,
                                                  labelPadding: EdgeInsets.symmetric(horizontal: 5),
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
                                                    Tab(text: 'Breakfast'),
                                                    Tab(text: 'Lunch'),
                                                    Tab(text: 'Dinner'),
                                                    Tab(text: 'Multi'),

                                                  ],
                                                ),
                                              ),
                                              // Visibility(
                                              //   child: Transform.scale(
                                              //     scale: 0.8,
                                              //     child: Switch(
                                              //       value: _switchValue,
                                              //       onChanged: (val) {
                                              //         setState(() {
                                              //           _switchValue = val;
                                              //         });
                                              //       },
                                              //       // Color when the switch is off
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      body: TabBarView(
                                        // controller: _menuController,
                                        children: [

                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Expanded(
                                                //   flex: 3,
                                                //   child: Container(
                                                //     margin: EdgeInsets.only(left: 5),
                                                //     color: GlobalVariables.whiteColor,
                                                //     child: Column(
                                                //       children: [
                                                //         Container(
                                                //           padding: EdgeInsets.all(15),
                                                //           decoration: BoxDecoration(color: Colors.grey.shade200
                                                //           ),
                                                //           child: Row(
                                                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                //             children: [
                                                //               Text("SECTIONS | ${foodCategories.length}",
                                                //                 style: SafeGoogleFont(
                                                //                   'Poppins',
                                                //                   fontSize: 14,
                                                //                   fontWeight: FontWeight.bold,
                                                //                   color: Color(0xFF363563),
                                                //                 ),),
                                                //
                                                //               SizedBox(width: 10,),
                                                //               InkWell(
                                                //                 onTap: () {
                                                //                   MenuEditorFunction.showAddItemCategory(menuContext,context,foodCategories);
                                                //                 },
                                                //                 child: Text("+ ADD ITEM", style: SafeGoogleFont(
                                                //                   'Poppins',
                                                //                   fontSize: 12,
                                                //                   fontWeight: FontWeight.bold,
                                                //                   color: Color(0xfffbb830),
                                                //                 ),),
                                                //               )
                                                //             ],
                                                //           ),
                                                //         ),
                                                //         SizedBox(height: 0,),
                                                //
                                                //         Expanded(
                                                //           child: ReorderableListView.builder(
                                                //             buildDefaultDragHandles: false,
                                                //             primary: true,
                                                //             shrinkWrap: true,
                                                //             itemCount: filteredFoodCategory.length,
                                                //             itemBuilder: (context, index) {
                                                //               print("object");
                                                //               String category = filteredFoodCategory.keys.elementAt(index);
                                                //               List<Map<String, dynamic>> itemsList =  filteredFoodCategory[category]!;
                                                //               List<String> items = itemsList.map((item) => item['disName'] as String).toList();
                                                //
                                                //               bool categoryContainsMatch = items.any((item) =>
                                                //                   item.toLowerCase().contains(widget.searchQuery.toLowerCase()));
                                                //
                                                //               return ReorderableDragStartListener(
                                                //                 enabled: true,
                                                //                 key: Key(category),
                                                //                 index: index,
                                                //                 child: InkWell(
                                                //                   onTap: () {
                                                //                     setState(() {
                                                //
                                                //                       MenuEditorVariables.selectedItem = "";
                                                //                       selectedItem = "";
                                                //                       MenuEditorVariables.oldestTagName = category;
                                                //                       // MenuEditorVariables.tagController.text = category;
                                                //                       print("category is $category");
                                                //                     });
                                                //                     context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(state.selectedCategories,state.foodCategories, category));
                                                //                   },
                                                //                   child: Column(
                                                //                     key: Key('$category'),
                                                //                     children: [
                                                //                       Container(
                                                //                         margin: EdgeInsets.only(top: 5, bottom: 5),
                                                //                         color: state.selectedCategories.contains(category)
                                                //                             ? Color(0xFF363563)
                                                //                             : null,
                                                //                         child: ListTile(
                                                //                           title: Text(
                                                //                             category,
                                                //                             softWrap: false,
                                                //                             overflow: TextOverflow.ellipsis,
                                                //                             maxLines: 1,
                                                //                             style: TextStyle(
                                                //                               fontSize: 12,
                                                //                               fontWeight: FontWeight.bold,
                                                //                               color: state.selectedCategories.contains(category)
                                                //                                   ? GlobalVariables.whiteColor
                                                //                                   : Colors.black,
                                                //                             ),
                                                //                           ),
                                                //                           leading: Icon(
                                                //                             Icons.grid_view_rounded,
                                                //                             size: 10,
                                                //                             color: state.selectedCategories.contains(category)
                                                //                                 ? GlobalVariables.whiteColor
                                                //                                 : Colors.black,
                                                //                           ),
                                                //
                                                //                         ),
                                                //                       ),
                                                //                       Visibility(
                                                //                         visible: state.selectedCategories.contains(category),
                                                //                         child: Column(
                                                //                           crossAxisAlignment: CrossAxisAlignment.start,
                                                //                           mainAxisAlignment: MainAxisAlignment.start,
                                                //                           children: _buildItemsList(category, itemsList,state.selectedCategories),
                                                //                         ),
                                                //                       ),
                                                //                     ],
                                                //                   ),
                                                //                 ),
                                                //               );
                                                //             },
                                                //             onReorder: (oldIndex, newIndex) {
                                                //               setState(() {
                                                //                 if (oldIndex < newIndex) {
                                                //                   newIndex -= 1;
                                                //                 }
                                                //                 List<MapEntry<String, List<Map<String, dynamic>>>> entries =
                                                //                 filteredFoodCategory.length == 0
                                                //                     ? foodCategories.entries.toList()
                                                //                     : filteredFoodCategory.entries.toList();
                                                //                 MapEntry<String, List<Map<String, dynamic>>> removedEntry =
                                                //                 entries.removeAt(oldIndex);
                                                //                 entries.insert(newIndex, removedEntry);
                                                //
                                                //                 // Convert the List back to a Map
                                                //                 if (filteredFoodCategory.length == 0) {
                                                //                   foodCategories = Map.fromEntries(entries);
                                                //                 } else {
                                                //                   filteredFoodCategory = Map.fromEntries(entries);
                                                //                 }
                                                //               });
                                                //             },
                                                //           ),
                                                //
                                                //         ),
                                                //       ],
                                                //     ),
                                                //   ),
                                                // ),
                                                // Container(
                                                //   color: Colors.black26,
                                                //   width: 1,
                                                // ),
                                                Expanded(
                                                  flex: 5,
                                                  child: Scaffold(
                                                    body: LiveMenuCountBreakfast(),
                                                    bottomNavigationBar: Container(
                                                      height: 70,
                                                      // color: Colors.grey.shade50,
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: 20*fem,),
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
                                          Column(
                                            children: [

                                            ],
                                          ),
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 5),
                                                    color: GlobalVariables.whiteColor,
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
                                                                    context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(state.selectedCategories,state.foodCategories, category));
                                                                  },
                                                                  child: Column(
                                                                    key: Key('$category'),
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.only(top: 5, bottom: 5),
                                                                        color: state.selectedCategories.contains(category)
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
                                                                              color: state.selectedCategories.contains(category)
                                                                                  ? Colors.white
                                                                                  : Colors.black,
                                                                            ),
                                                                          ),
                                                                          leading: Icon(
                                                                            Icons.grid_view_rounded,
                                                                            size: 10,
                                                                            color: state.selectedCategories.contains(category)
                                                                                ? Colors.white
                                                                                : Colors.black,
                                                                          ),

                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible: state.selectedCategories.contains(category),
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: _buildItemsList(category, itemsList,state.selectedCategories),
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

                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 5),
                                                    color: GlobalVariables.whiteColor,
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
                                                                    context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(state.selectedCategories,state.foodCategories, category));
                                                                  },
                                                                  child: Column(
                                                                    key: Key('$category'),
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.only(top: 5, bottom: 5),
                                                                        color: state.selectedCategories.contains(category)
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
                                                                              color: state.selectedCategories.contains(category)
                                                                                  ? Colors.white
                                                                                  : Colors.black,
                                                                            ),
                                                                          ),
                                                                          leading: Icon(
                                                                            Icons.grid_view_rounded,
                                                                            size: 10,
                                                                            color: state.selectedCategories.contains(category)
                                                                                ? Colors.white
                                                                                : Colors.black,
                                                                          ),

                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible: state.selectedCategories.contains(category),
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: _buildItemsList(category, itemsList,state.selectedCategories),
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
                                                    // appBar: AppBar(
                                                    //   leading: Container(),
                                                    //   backgroundColor:Colors.grey.shade200,
                                                    // ),
                                                    body: LiveMenuCountMulti(),
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


  List<Widget> _buildItemsList(String category, List<Map<String, dynamic>> itemsList,Set<String> selectedCategories) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);

    print( "Selected CAtegories ${selectedCategory.length}");
    if ( selectedCategories.isNotEmpty && selectedCategories.contains(category)) {
      return itemsList.map((item) {
        String itemName = item['disName'] as String;
        bool availability = item['availability'] as bool;
        Map<String, dynamic> itemDetails = item;
        print( "Selected CAtegories ${itemName}  ${availability}");
        return _buildDismissibleItem(itemName, color, availability, itemDetails);
      }).toList();
    }  else {
      return [
        Center(
          child: Text('Select a category to view items.'),
        ),
      ];
    }
  }

  Widget _buildDismissibleItem(String item, Color color,bool itemAvail,Map<String, dynamic> item1) {
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

  List<Widget> _buildItemsListMob(String category, List<Map<String, dynamic>> itemsList, Set<String> selectedCategories, BuildContext menuContext) {
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
                    _buildDismissibleItemMob(item['name'], color,item,category,menuContext),
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
          listItem = _buildDismissibleItemMob(item['name'], color,item,category,menuContext);
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

  Widget _buildDismissibleItemMob(String item, Color color,Map<String, dynamic> item1,String category,BuildContext menuContext) {
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
    return Dismissible(
      key: Key(item),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          foodCategories[selectedCategory]!.remove(item1);
        });
        _showDeleteConfirmationDialog(item1,category,menuContext);
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

  void _showAddItemDialog(String category) {
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
                    dropdownItems: MenuEditorVariables.items,
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
                    foodCategories[category]!.add(newItem);
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

  void _showAddItemCategory(BuildContext menuContext) {
    bool visit = false;
    TextEditingController item = TextEditingController();
    Map<String,dynamic> requestBody = {};
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
          if(state is MenuLoadingState) {
            if(visit) {
              Navigator.of(context).pop();
            }

            // return CircularProgressIndicator();
          }
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
                      dropdownItems: MenuEditorVariables.tags,
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

                    item.text = item.text.trim();

                    visit = true;

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
                      setState(() {
                        foodCategories.addAll(category);
                      });

                      Navigator.of(context).pop();
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
