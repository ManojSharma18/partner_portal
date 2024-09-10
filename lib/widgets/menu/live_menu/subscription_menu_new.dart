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
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count_multi.dart';
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
import '../../../bloc/menu/menu_bloc.dart';
import '../../../bloc/menu/menu_event.dart';
import '../../../bloc/menu/menu_state.dart';
import '../../../bloc/subscription_menu/subscription_menu_bloc.dart';
import '../../../bloc/subscription_menu/subscription_menu_state.dart';
import '../../../repository/menu_services.dart';
import '../../custom_button.dart';
import '../../custom_textfield.dart';
import '../../../constants/search_bar.dart';
import '../../../constants/utils.dart';
import '../../item_availability1.dart';
import '../../small_custom_textfield.dart';
import '../item_details_1.dart';

class SubscriptionMenuNew extends StatefulWidget {
  final String searchQuery;
  const SubscriptionMenuNew({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<SubscriptionMenuNew> createState() => _MenuEditorState();
}

class _MenuEditorState extends State<SubscriptionMenuNew> with TickerProviderStateMixin {
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


  String defaultItem = "";

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
    return BlocBuilder<SubscriptionMenuBloc,SubscriptionMenuState>(builder: (BuildContext menuContext, menuState) {
      if(menuState is SubscriptionMenuLoadingState) {

        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if(menuState is ErrorState) {
        return const Center(child: Text("Error"),);
      }
      if( menuState is SubscriptionMenuLoadedState){
        return MenuEditorWidget(menuState: menuState,menuContext: menuContext);
      }
      return Center();
    },

    );
  }




  Widget MenuEditorWidget({SubscriptionMenuLoadedState? menuState, required BuildContext menuContext}) {
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


                          return ReorderableDragStartListener(
                            enabled: false,
                            key: Key(category),
                            index: index,
                            child: InkWell(
                              onTap: () {
                                // setState(() {
                                //
                                //   MenuEditorVariables.selectedItem = "";
                                //   selectedItem = "";
                                //   MenuEditorVariables.oldestTagName = category;
                                //   // MenuEditorVariables.tagController.text = category;
                                //   print("category is $category");
                                // });
                                // context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(state.selectedCategories,state.foodCategories, category));
                              },
                              child: Column(
                                key: Key('$category'),
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    color: MenuEditorVariables.selectedSubscriptionCategories.contains(category)
                                        ? Color(0xFF363563)
                                        : null,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          trailing: InkWell(
                                            onTap: () {
                                              MenuEditorFunction.showAddItemCategory(menuContext,context,foodCategories);
                                            },
                                            child: Text("+ ADD ITEM", style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xfffbb830),
                                            ),),
                                          ),
                                          title: Text(
                                            category,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: MenuEditorVariables.selectedSubscriptionCategories.contains(category)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          leading: Icon(
                                            Icons.grid_view_rounded,
                                            size: 10,
                                            color: MenuEditorVariables.selectedSubscriptionCategories.contains(category)
                                                ? Colors.white
                                                : Colors.black,
                                          ),

                                        ),

                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: MenuEditorVariables.selectedSubscriptionCategories.contains(category),
                                    child: Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(width: 180*fem,),
                                                Container(
                                                  width: 58*fem,
                                                  child: Text(
                                                    "S1",
                                                    softWrap: false,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style:  TextStyle(
                                                      fontFamily: 'RenogareSoft',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: GlobalVariables.textColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5*fem,),
                                                Container(
                                                  width: 58*fem,
                                                  child: Text(
                                                    "S2",
                                                    softWrap: false,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style:  TextStyle(
                                                      fontFamily: 'RenogareSoft',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: GlobalVariables.textColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 0*fem,),
                                                Container(
                                                  margin: EdgeInsets.only(left: 0*fem),
                                                  width: 58*fem,
                                                  child: Text(
                                                    "Total",
                                                    softWrap: false,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: 'RenogareSoft',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: GlobalVariables.textColor,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                            SizedBox(height: 3,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(width: 180*fem,),
                                                Container(
                                                  width: 58*fem,
                                                  child: Text(
                                                    "40",
                                                    softWrap: false,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style:  TextStyle(
                                                      fontFamily: 'RenogareSoft',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: GlobalVariables.textColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5*fem,),
                                                Container(
                                                  width: 58*fem,
                                                  margin: EdgeInsets.only(left: 5*fem),
                                                  child: Text(
                                                    "35",
                                                    softWrap: false,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style:  TextStyle(
                                                      fontFamily: 'RenogareSoft',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: GlobalVariables.textColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 0*fem,),
                                                Container(
                                                  width: 58*fem,
                                                  margin: EdgeInsets.only(left: 0*fem),
                                                  child: Text(
                                                    "75",
                                                    softWrap: false,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style:  TextStyle(
                                                      fontFamily: 'RenogareSoft',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: GlobalVariables.textColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 3,),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: _buildItemsListMob(category, itemsList,MenuEditorVariables.selectedSubscriptionCategories),
                                        ),
                                      ],
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
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 0),
                                        color: Colors.white,
                                        child: Column(
                                          children: [
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



                                                  return ReorderableDragStartListener(
                                                    enabled: true,
                                                    key: Key(category),
                                                    index: index,
                                                    child: InkWell(
                                                      onTap: () {
                                                        // setState(() {
                                                        //
                                                        //   MenuEditorVariables.selectedItem = "";
                                                        //   selectedItem = "";
                                                        //   MenuEditorVariables.oldestTagName = category;
                                                        //   // MenuEditorVariables.tagController.text = category;
                                                        //   print("category is $category");
                                                        // });
                                                        // context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(state.selectedCategories,state.foodCategories, category));
                                                      },
                                                      child: Column(
                                                        key: Key('$category'),
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.only(top: 5, bottom: 5),
                                                            color: MenuEditorVariables.selectedSubscriptionCategories.contains(category)
                                                                ? Color(0xFF363563)
                                                                : null,
                                                            child: ListTile(
                                                              trailing: InkWell(
                                                                onTap: () {
                                                                  MenuEditorFunction.showAddItemCategory(menuContext,context,foodCategories);
                                                                },
                                                                child: Text("+ ADD ITEM", style: SafeGoogleFont(
                                                                  'Poppins',
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Color(0xfffbb830),
                                                                ),),
                                                              ),
                                                              title: Row(
                                                                children: [
                                                                  Container(
                                                                    width:40*fem,
                                                                    child: Text(
                                                                      category,
                                                                      softWrap: false,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 1,
                                                                      style: TextStyle(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: MenuEditorVariables.selectedSubscriptionCategories.contains(category)
                                                                            ? Colors.white
                                                                            : Colors.black,
                                                                      ),
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),

                                                              leading: Icon(
                                                                Icons.grid_view_rounded,
                                                                size: 10,
                                                                color: MenuEditorVariables.selectedSubscriptionCategories.contains(category)
                                                                    ? Colors.white
                                                                    : Colors.black,
                                                              ),

                                                            ),
                                                          ),
                                                          Visibility(
                                                            visible: MenuEditorVariables.selectedSubscriptionCategories.contains(category),
                                                            child: Column(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        SizedBox(width: 40*fem,),
                                                                        Container(
                                                                          width: 20*fem,
                                                                          child: Text(
                                                                            "S1",
                                                                            softWrap: false,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 1,
                                                                            style:  TextStyle(
                                                                              fontFamily: 'RenogareSoft',
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: GlobalVariables.textColor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 5*fem,),
                                                                        Container(
                                                                          width: 20*fem,
                                                                          child: Text(
                                                                            "S2",
                                                                            softWrap: false,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 1,
                                                                            style:  TextStyle(
                                                                              fontFamily: 'RenogareSoft',
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: GlobalVariables.textColor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 5*fem,),
                                                                        Container(
                                                                          margin: EdgeInsets.only(left: 0*fem),
                                                                          width: 20*fem,
                                                                          child: Text(
                                                                            "Total",
                                                                            softWrap: false,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 1,
                                                                            style: TextStyle(
                                                                              fontFamily: 'RenogareSoft',
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: GlobalVariables.textColor,
                                                                            ),
                                                                          ),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 3,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        SizedBox(width: 40*fem,),
                                                                        Container(
                                                                          width: 20*fem,
                                                                          child: Text(
                                                                            "40",
                                                                            softWrap: false,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 1,
                                                                            style:  TextStyle(
                                                                              fontFamily: 'RenogareSoft',
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: GlobalVariables.textColor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 5*fem,),
                                                                        Container(
                                                                          width: 20*fem,
                                                                          child: Text(
                                                                            "35",
                                                                            softWrap: false,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 1,
                                                                            style:  TextStyle(
                                                                              fontFamily: 'RenogareSoft',
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: GlobalVariables.textColor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 5*fem,),
                                                                        Container(
                                                                          margin: EdgeInsets.only(left: 0*fem),
                                                                          width: 20*fem,
                                                                          child: Text(
                                                                            "75",
                                                                            softWrap: false,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 1,
                                                                            style: TextStyle(
                                                                              fontFamily: 'RenogareSoft',
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: GlobalVariables.textColor,
                                                                            ),
                                                                          ),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 3,)
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10,),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: _buildItemsListTab(category, itemsList,MenuEditorVariables.selectedSubscriptionCategories),
                                                                ),
                                                              ],
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
                                    // Expanded(
                                    //   child: SingleChildScrollView(
                                    //     child: Container(
                                    //       width: 1200,
                                    //       child: LayoutBuilder(
                                    //         builder: (context, constraints) {
                                    //           int columns = 1;
                                    //           if (foodCategories.length > 3) {
                                    //             columns = 2;
                                    //           }
                                    //
                                    //           double columnWidth = (constraints.maxWidth - (columns - 1) * 5) / columns;
                                    //
                                    //           return Column(
                                    //             mainAxisSize: MainAxisSize.min,
                                    //             children: [
                                    //               Wrap(
                                    //                 spacing: 5, // spacing between columns
                                    //                 runSpacing: 5, // spacing between rows
                                    //                 children: List.generate(
                                    //                   filteredFoodCategory.length == 0 ? foodCategories.length: filteredFoodCategory.length,
                                    //                       (index)
                                    //                   { String category = filteredFoodCategory.length == 0 ? foodCategories.keys.elementAt(index) : filteredFoodCategory.keys.elementAt(index);
                                    //                   List<Map<String, dynamic>> itemsList = filteredFoodCategory.length == 0
                                    //                       ? foodCategories[category]!
                                    //                       : filteredFoodCategory[category]!;
                                    //                   List<String> items = itemsList.map((item) => item['disName'] as String).toList();
                                    //
                                    //                   bool categoryContainsMatch = items.any((item) => item.toLowerCase().contains(widget.searchQuery.toLowerCase()));
                                    //
                                    //                   return Container(
                                    //                     width: columnWidth,
                                    //                     child: InkWell(
                                    //                       onTap: () {
                                    //                         setState(() {
                                    //
                                    //                           MenuEditorVariables.selectedItem = "";
                                    //                           selectedItem = "";
                                    //                           MenuEditorVariables.oldestTagName = category;
                                    //                           // MenuEditorVariables.tagController.text = category;
                                    //                           print("category is $category");
                                    //                         });
                                    //                         context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(state.selectedCategories,state.foodCategories, category));
                                    //                       },
                                    //                       child: Column(
                                    //                         key: Key('$category'),
                                    //                         children: [
                                    //                           Container(
                                    //                             margin: EdgeInsets.only(top: 5, bottom: 5),
                                    //                             color: state.selectedCategories.contains(category)
                                    //                                 ? Color(0xFF363563)
                                    //                                 : null,
                                    //                             child: ListTile(
                                    //                               title: Text(
                                    //                                 category,
                                    //                                 style: TextStyle(
                                    //                                   fontSize: 12,
                                    //                                   fontWeight: FontWeight.bold,
                                    //                                   color: state.selectedCategories.contains(category)
                                    //                                       ? Colors.white
                                    //                                       : Colors.black,
                                    //                                 ),
                                    //                               ),
                                    //                               leading: Icon(
                                    //                                 Icons.grid_view_rounded,
                                    //                                 size: 10,
                                    //                                 color: state.selectedCategories.contains(category) ? Colors.white : Colors.black,
                                    //                               ),
                                    //                               trailing: Row(
                                    //                                 mainAxisSize: MainAxisSize.min,
                                    //                                 children: [],
                                    //                               ),
                                    //                             ),
                                    //                           ),
                                    //                           Visibility(
                                    //                             visible: state.selectedCategories.contains(category),
                                    //                             child: Column(
                                    //                               children: [
                                    //                                 Column(
                                    //                                   crossAxisAlignment: CrossAxisAlignment.center,
                                    //                                   children: [
                                    //                                     Row(
                                    //                                       mainAxisAlignment: MainAxisAlignment.center,
                                    //                                       children: [
                                    //                                         SizedBox(width: 40*fem,),
                                    //                                         Container(
                                    //                                           width: 20*fem,
                                    //                                           child: Text(
                                    //                                             "S1",
                                    //                                             softWrap: false,
                                    //                                             overflow: TextOverflow.ellipsis,
                                    //                                             maxLines: 1,
                                    //                                             style:  TextStyle(
                                    //                                               fontFamily: 'RenogareSoft',
                                    //                                               fontSize: 13,
                                    //                                               fontWeight: FontWeight.w600,
                                    //                                               color: GlobalVariables.textColor,
                                    //                                             ),
                                    //                                           ),
                                    //                                         ),
                                    //                                         SizedBox(width: 5*fem,),
                                    //                                         Container(
                                    //                                           width: 20*fem,
                                    //                                           child: Text(
                                    //                                             "S2",
                                    //                                             softWrap: false,
                                    //                                             overflow: TextOverflow.ellipsis,
                                    //                                             maxLines: 1,
                                    //                                             style:  TextStyle(
                                    //                                               fontFamily: 'RenogareSoft',
                                    //                                               fontSize: 13,
                                    //                                               fontWeight: FontWeight.w600,
                                    //                                               color: GlobalVariables.textColor,
                                    //                                             ),
                                    //                                           ),
                                    //                                         ),
                                    //                                         SizedBox(width: 5*fem,),
                                    //                                         Container(
                                    //                                           margin: EdgeInsets.only(left: 0*fem),
                                    //                                           width: 20*fem,
                                    //                                           child: Text(
                                    //                                             "Total",
                                    //                                             softWrap: false,
                                    //                                             overflow: TextOverflow.ellipsis,
                                    //                                             maxLines: 1,
                                    //                                             style: TextStyle(
                                    //                                               fontFamily: 'RenogareSoft',
                                    //                                               fontSize: 13,
                                    //                                               fontWeight: FontWeight.w600,
                                    //                                               color: GlobalVariables.textColor,
                                    //                                             ),
                                    //                                           ),
                                    //                                         ),
                                    //
                                    //                                       ],
                                    //                                     ),
                                    //                                     SizedBox(height: 3,),
                                    //                                     Row(
                                    //                                       mainAxisAlignment: MainAxisAlignment.center,
                                    //                                       children: [
                                    //                                         SizedBox(width: 40*fem,),
                                    //                                         Container(
                                    //                                           width: 20*fem,
                                    //                                           child: Text(
                                    //                                             "40",
                                    //                                             softWrap: false,
                                    //                                             overflow: TextOverflow.ellipsis,
                                    //                                             maxLines: 1,
                                    //                                             style:  TextStyle(
                                    //                                               fontFamily: 'RenogareSoft',
                                    //                                               fontSize: 13,
                                    //                                               fontWeight: FontWeight.w600,
                                    //                                               color: GlobalVariables.textColor,
                                    //                                             ),
                                    //                                           ),
                                    //                                         ),
                                    //                                         SizedBox(width: 5*fem,),
                                    //                                         Container(
                                    //                                           width: 20*fem,
                                    //                                           child: Text(
                                    //                                             "35",
                                    //                                             softWrap: false,
                                    //                                             overflow: TextOverflow.ellipsis,
                                    //                                             maxLines: 1,
                                    //                                             style:  TextStyle(
                                    //                                               fontFamily: 'RenogareSoft',
                                    //                                               fontSize: 13,
                                    //                                               fontWeight: FontWeight.w600,
                                    //                                               color: GlobalVariables.textColor,
                                    //                                             ),
                                    //                                           ),
                                    //                                         ),
                                    //                                         SizedBox(width: 5*fem,),
                                    //                                         Container(
                                    //                                           margin: EdgeInsets.only(left: 0*fem),
                                    //                                           width: 20*fem,
                                    //                                           child: Text(
                                    //                                             "75",
                                    //                                             softWrap: false,
                                    //                                             overflow: TextOverflow.ellipsis,
                                    //                                             maxLines: 1,
                                    //                                             style: TextStyle(
                                    //                                               fontFamily: 'RenogareSoft',
                                    //                                               fontSize: 13,
                                    //                                               fontWeight: FontWeight.w600,
                                    //                                               color: GlobalVariables.textColor,
                                    //                                             ),
                                    //                                           ),
                                    //                                         ),
                                    //
                                    //                                       ],
                                    //                                     ),
                                    //                                     SizedBox(height: 3,),
                                    //                                   ],
                                    //                                 ),
                                    //                                 SizedBox(height: 10,),
                                    //                                 Column(
                                    //                                   crossAxisAlignment: CrossAxisAlignment.start,
                                    //                                   mainAxisAlignment: MainAxisAlignment.start,
                                    //                                   children: _buildItemsList(category, itemsList,state.selectedCategories),
                                    //                                 ),
                                    //                               ],
                                    //                             ),
                                    //                           ),
                                    //                         ],
                                    //                       ),
                                    //                     ),
                                    //                   );
                                    //                   },
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           );
                                    //         },
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
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
                              // Expanded(
                              //   flex: 3,
                              //   child: Container(
                              //     margin: EdgeInsets.only(left: 0),
                              //     color: Colors.white,
                              //     child: Column(
                              //       children: [
                              //         Expanded(
                              //           child: ReorderableListView.builder(
                              //             buildDefaultDragHandles: false,
                              //             primary: true,
                              //             shrinkWrap: true,
                              //             itemCount: 2,
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
                              //                           trailing: InkWell(
                              //                             onTap: () {
                              //                               MenuEditorFunction.showAddItemCategory(menuContext,context,foodCategories);
                              //                             },
                              //                             child: Text("+ ADD ITEM", style: SafeGoogleFont(
                              //                               'Poppins',
                              //                               fontSize: 12,
                              //                               fontWeight: FontWeight.bold,
                              //                               color: Color(0xfffbb830),
                              //                             ),),
                              //                           ),
                              //                           title: Row(
                              //                             children: [
                              //                               Container(
                              //                                 width:30*fem,
                              //                                 child: Text(
                              //                                   category,
                              //                                   softWrap: false,
                              //                                   overflow: TextOverflow.ellipsis,
                              //                                   maxLines: 1,
                              //                                   style: TextStyle(
                              //                                     fontSize: 12,
                              //                                     fontWeight: FontWeight.bold,
                              //                                     color: state.selectedCategories.contains(category)
                              //                                         ? Colors.white
                              //                                         : Colors.black,
                              //                                   ),
                              //                                 ),
                              //                               ),
                              //
                              //                             ],
                              //                           ),
                              //
                              //                           leading: Icon(
                              //                             Icons.grid_view_rounded,
                              //                             size: 10,
                              //                             color: state.selectedCategories.contains(category)
                              //                                 ? Colors.white
                              //                                 : Colors.black,
                              //                           ),
                              //
                              //                         ),
                              //                       ),
                              //                       Visibility(
                              //                         visible: state.selectedCategories.contains(category),
                              //                         child: Column(
                              //                           children: [
                              //                             Column(
                              //                               crossAxisAlignment: CrossAxisAlignment.center,
                              //                               children: [
                              //                                 Row(
                              //                                   mainAxisAlignment: MainAxisAlignment.center,
                              //                                   children: [
                              //                                     SizedBox(width: 30*fem,),
                              //                                     Container(
                              //                                       width: 20*fem,
                              //                                       child: Text(
                              //                                         "S1",
                              //                                         softWrap: false,
                              //                                         overflow: TextOverflow.ellipsis,
                              //                                         maxLines: 1,
                              //                                         style:  TextStyle(
                              //                                           fontFamily: 'RenogareSoft',
                              //                                           fontSize: 13,
                              //                                           fontWeight: FontWeight.w600,
                              //                                           color: GlobalVariables.textColor,
                              //                                         ),
                              //                                       ),
                              //                                     ),
                              //                                     SizedBox(width: 5*fem,),
                              //                                     Container(
                              //                                       width: 20*fem,
                              //                                       child: Text(
                              //                                         "S2",
                              //                                         softWrap: false,
                              //                                         overflow: TextOverflow.ellipsis,
                              //                                         maxLines: 1,
                              //                                         style:  TextStyle(
                              //                                           fontFamily: 'RenogareSoft',
                              //                                           fontSize: 13,
                              //                                           fontWeight: FontWeight.w600,
                              //                                           color: GlobalVariables.textColor,
                              //                                         ),
                              //                                       ),
                              //                                     ),
                              //                                     SizedBox(width: 5*fem,),
                              //                                     Container(
                              //                                       margin: EdgeInsets.only(left: 0*fem),
                              //                                       width: 20*fem,
                              //                                       child: Text(
                              //                                         "Total",
                              //                                         softWrap: false,
                              //                                         overflow: TextOverflow.ellipsis,
                              //                                         maxLines: 1,
                              //                                         style: TextStyle(
                              //                                           fontFamily: 'RenogareSoft',
                              //                                           fontSize: 13,
                              //                                           fontWeight: FontWeight.w600,
                              //                                           color: GlobalVariables.textColor,
                              //                                         ),
                              //                                       ),
                              //                                     ),
                              //
                              //                                   ],
                              //                                 ),
                              //                                 SizedBox(height: 3,),
                              //                                 Row(
                              //                                   mainAxisAlignment: MainAxisAlignment.center,
                              //                                   children: [
                              //                                     SizedBox(width: 30*fem,),
                              //                                     Container(
                              //                                       width: 20*fem,
                              //                                       child: Text(
                              //                                         "40",
                              //                                         softWrap: false,
                              //                                         overflow: TextOverflow.ellipsis,
                              //                                         maxLines: 1,
                              //                                         style:  TextStyle(
                              //                                           fontFamily: 'RenogareSoft',
                              //                                           fontSize: 13,
                              //                                           fontWeight: FontWeight.w600,
                              //                                           color: GlobalVariables.textColor,
                              //                                         ),
                              //                                       ),
                              //                                     ),
                              //                                     SizedBox(width: 5*fem,),
                              //                                     Container(
                              //                                       width: 20*fem,
                              //                                       child: Text(
                              //                                         "35",
                              //                                         softWrap: false,
                              //                                         overflow: TextOverflow.ellipsis,
                              //                                         maxLines: 1,
                              //                                         style:  TextStyle(
                              //                                           fontFamily: 'RenogareSoft',
                              //                                           fontSize: 13,
                              //                                           fontWeight: FontWeight.w600,
                              //                                           color: GlobalVariables.textColor,
                              //                                         ),
                              //                                       ),
                              //                                     ),
                              //                                     SizedBox(width: 5*fem,),
                              //                                     Container(
                              //                                       margin: EdgeInsets.only(left: 0*fem),
                              //                                       width: 20*fem,
                              //                                       child: Text(
                              //                                         "75",
                              //                                         softWrap: false,
                              //                                         overflow: TextOverflow.ellipsis,
                              //                                         maxLines: 1,
                              //                                         style: TextStyle(
                              //                                           fontFamily: 'RenogareSoft',
                              //                                           fontSize: 13,
                              //                                           fontWeight: FontWeight.w600,
                              //                                           color: GlobalVariables.textColor,
                              //                                         ),
                              //                                       ),
                              //                                     ),
                              //
                              //                                   ],
                              //                                 ),
                              //                                 SizedBox(height: 3,),
                              //                               ],
                              //                             ),
                              //                             SizedBox(height: 10,),
                              //                             Column(
                              //                               crossAxisAlignment: CrossAxisAlignment.start,
                              //                               mainAxisAlignment: MainAxisAlignment.start,
                              //                               children: _buildItemsList(category, itemsList,state.selectedCategories),
                              //                             ),
                              //                           ],
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
                                child: SingleChildScrollView(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        int columns = 1;
                                        if (foodCategories.length > 3) {
                                          columns = 2;
                                        }

                                        double columnWidth = (constraints.maxWidth - (columns - 1) * 5) / columns;

                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Wrap(
                                              spacing: 5, // spacing between columns
                                              runSpacing: 5, // spacing between rows
                                              children: List.generate(
                                                filteredFoodCategory.length == 0 ? foodCategories.length: filteredFoodCategory.length,
                                                    (index)
                                                { String category = filteredFoodCategory.length == 0 ? foodCategories.keys.elementAt(index) : filteredFoodCategory.keys.elementAt(index);
                                                List<Map<String, dynamic>> itemsList = filteredFoodCategory.length == 0
                                                    ? foodCategories[category]!
                                                    : filteredFoodCategory[category]!;
                                                List<String> items = itemsList.map((item) => item['disName'] as String).toList();



                                                return Container(
                                                  width: columnWidth,
                                                  child: InkWell(
                                                    onTap: () {
                                                      // setState(() {

                                                      //   MenuEditorVariables.selectedItem = "";
                                                      //   selectedItem = "";
                                                      //   MenuEditorVariables.oldestTagName = category;
                                                      //   // MenuEditorVariables.tagController.text = category;
                                                      //   print("category is $category");
                                                      // });
                                                      // context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(state.selectedCategories,state.foodCategories, category));
                                                    },
                                                    child: Column(
                                                      key: Key('$category'),
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(top: 5, bottom: 5),
                                                          color: MenuEditorVariables.selectedSubscriptionCategories.contains(category)
                                                              ? Color(0xFF363563)
                                                              : null,
                                                          child: ListTile(
                                                            title: Text(
                                                              category,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.bold,
                                                                color: MenuEditorVariables.selectedSubscriptionCategories.contains(category)
                                                                    ? Colors.white
                                                                    : Colors.black,
                                                              ),
                                                            ),
                                                            leading: Icon(
                                                              Icons.grid_view_rounded,
                                                              size: 10,
                                                              color: MenuEditorVariables.selectedSubscriptionCategories.contains(category) ? Colors.white : Colors.black,
                                                            ),
                                                            trailing: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [],
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: MenuEditorVariables.selectedSubscriptionCategories.contains(category),
                                                          child: Column(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      SizedBox(width: 55*fem,),
                                                                      Container(
                                                                        width: 70,
                                                                        child: Text(
                                                                          "S1",
                                                                          softWrap: false,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 1,
                                                                          style:  TextStyle(
                                                                            fontFamily: 'RenogareSoft',
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                            color: GlobalVariables.textColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 5*fem,),
                                                                      Container(
                                                                        width: 70,
                                                                        child: Text(
                                                                          "S2",
                                                                          softWrap: false,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 1,
                                                                          style:  TextStyle(
                                                                            fontFamily: 'RenogareSoft',
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                            color: GlobalVariables.textColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 5*fem,),
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 0*fem),
                                                                        width: 70,
                                                                        child: Text(
                                                                          "Total",
                                                                          softWrap: false,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 1,
                                                                          style: TextStyle(
                                                                            fontFamily: 'RenogareSoft',
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                            color: GlobalVariables.textColor,
                                                                          ),
                                                                        ),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 3,),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      SizedBox(width: 55*fem,),
                                                                      Container(
                                                                        width: 70,
                                                                        child: Text(
                                                                          "40",
                                                                          softWrap: false,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 1,
                                                                          style:  TextStyle(
                                                                            fontFamily: 'RenogareSoft',
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                            color: GlobalVariables.textColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 5*fem,),
                                                                      Container(
                                                                        width: 70,
                                                                        child: Text(
                                                                          "35",
                                                                          softWrap: false,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 1,
                                                                          style:  TextStyle(
                                                                            fontFamily: 'RenogareSoft',
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                            color: GlobalVariables.textColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 5*fem,),
                                                                      Container(
                                                                        width: 70,
                                                                        child: Text(
                                                                          "75",
                                                                          softWrap: false,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 1,
                                                                          style: TextStyle(
                                                                            fontFamily: 'RenogareSoft',
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                            color: GlobalVariables.textColor,
                                                                          ),
                                                                        ),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 3,),
                                                                ],
                                                              ),
                                                              SizedBox(height: 10,),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: _buildItemsList(category, itemsList,MenuEditorVariables.selectedSubscriptionCategories),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
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

            },
            child: Container(
              margin: EdgeInsets.only(bottom:10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: selectedItem == item
                    ? Colors.grey.shade300
                    : hoverItem == item
                    ? Colors.grey.shade100
                    : Colors.white,
              ),

              child: Row(
                children: [
                  SizedBox(width: 5*fem,),
                  Container(
                    width: 40*fem,
                    child: Text(
                      item,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: selectedItem == item
                            ? GlobalVariables.textColor
                            : color,
                      ),
                    ),
                  ),
                  SizedBox(width: 5*fem,),
                  Container(
                    width:70,
                    height: 40,
                    child: SmallCustomTextField(
                      min:0,max:9999,
                      textEditingController: TextEditingController(text: "5"),height: 30,fontSize: 12,
                      onChanged: (text){


                      },
                    ),
                  ),
                  SizedBox(width: 5*fem,),
                  Container(
                    width:70,
                    height: 40,
                    child: SmallCustomTextField(
                      min:0,max:9999,
                      textEditingController: TextEditingController(text: "5"),height: 30,fontSize: 12,
                      onChanged: (text){


                      },
                    ),
                  ),
                  SizedBox(width: 5*fem,),
                  Container(
                    width:20*fem,
                    height: 40,
                    child: Center(
                      child: Text("10000",style: TextStyle(
                        fontFamily: 'RenogareSoft',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: GlobalVariables.textColor,
                      ),),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min, // Ensure Row takes only as much space as needed
                    children: [
                      Icon(Icons.cancel,color: GlobalVariables.primaryColor,),
                      SizedBox(width: 3*fem,),
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 3*fem,),
                      Icon(Icons.save, color: Colors.blue),
                      // InkWell(
                      //   onTap: () {
                      //
                      //
                      //   },
                      //   child: Container(
                      //     width: 70,
                      //     height: 30,
                      //     padding: EdgeInsets.all(5),
                      //     decoration: BoxDecoration(
                      //       color: Colors.blue, // Replace with your primary color
                      //       borderRadius: BorderRadius.circular(5),
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         "Save",
                      //         style: TextStyle(
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(width: 3*fem,),
                      Transform.scale(
                        scaleY: 0.8,
                        scaleX: 0.8,
                        child: Switch(
                          value: item1['availability'],
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: GlobalVariables.textColor.withOpacity(0.6),
                          inactiveThumbImage: NetworkImage(
                              "https://wallpapercave.com/wp/wp7632851.jpg"
                          ),
                          onChanged: (bool value) {
                            setState(() {
                              item1['availability'] = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
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

  List<Widget> _buildItemsListMob(String category, List<Map<String, dynamic>> itemsList,Set<String> selectedCategories) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);

    print( "Selected CAtegories ${selectedCategory.length}");
    if ( selectedCategories.isNotEmpty && selectedCategories.contains(category)) {
      return itemsList.map((item) {
        String itemName = item['disName'] as String;
        bool availability = item['availability'] as bool;
        Map<String, dynamic> itemDetails = item;
        print( "Selected CAtegories ${itemName}  ${availability}");
        return _buildDismissibleItemMob(itemName, color, availability, itemDetails);
      }).toList();
    }  else {
      return [
        Center(
          child: Text('Select a category to view items.'),
        ),
      ];
    }
  }

  Widget _buildDismissibleItemMob(String item, Color color,bool itemAvail,Map<String, dynamic> item1) {
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
            // padding: EdgeInsets.only(right: 20),
            // margin: EdgeInsets.only(right: 10),
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
              setState(() {
                selectedItem = item;
              });
              // context.read<MenuBloc>().add(ItemSelectEvent(item1));
            },
            onLongPress: () {

              showDialog(context: context, builder: (contexts) {
                return AlertDialog(
                  title: Text("Default item",style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GlobalVariables.primaryColor,
                  ),),
                  content: Text("Do you want to set this item as default?",style: GlobalVariables.dataItemStyle,),
                  actions: [
                    CustomButton(text: "No", onTap: (){Navigator.pop(context);}, color:Colors.red,textColor: GlobalVariables.whiteColor,),
                    CustomButton(text: "Yes", onTap: () {
                      setState(() {
                        defaultItem = item;
                      });
                      Navigator.pop(context);
                    }, color:Colors.green,
                      textColor: GlobalVariables.whiteColor,),
                  ],
                );
              });

            },
            child: Container(
              margin: EdgeInsets.only(bottom:10),
              padding: EdgeInsets.only(top: 5,bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: selectedItem == item
                    ? Colors.grey.shade300
                    : hoverItem == item
                    ? Colors.grey.shade100
                    : Colors.white,
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible:  defaultItem == item,
                    child: Container(
                      width: 5,
                      height: 50,
                      decoration: BoxDecoration(
                          color: GlobalVariables.primaryColor,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),topRight:Radius.circular(10))
                      ),
                    ),
                  ),
                  Visibility(
                    visible:  defaultItem != item,
                    child: Container(
                      width: 5,
                    ),
                  ),
                  SizedBox(width: 10*fem,),
                  Container(
                    width: 145*fem,
                    child: Text(
                      item,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: selectedItem == item
                            ? GlobalVariables.textColor
                            : color,
                      ),
                    ),
                  ),
                  SizedBox(width: 20*fem,),
                  Container(
                    width:58*fem,
                    height: 40,
                    child: SmallCustomTextField(
                      min:0,max:9999,
                      textEditingController: TextEditingController(text: "5",),height: 30,fontSize: 12,
                      onChanged: (text){

                      },
                    ),
                  ),
                  SizedBox(width: 5*fem,),
                  Container(
                    width:58*fem,
                    height: 40,
                    child: SmallCustomTextField(
                      min:0,max:9999,
                      textEditingController: TextEditingController(text: "5"),height: 30,fontSize: 12,
                      onChanged: (text){


                      },
                    ),
                  ),
                  SizedBox(width: 5*fem,),
                  Container(
                    width:58*fem,
                    height: 40,
                    child: Center(
                      child: Text("1000",style: TextStyle(
                        fontFamily: 'RenogareSoft',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: GlobalVariables.textColor,
                      ),),
                    ),
                  ),

                ],
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


  List<Widget> _buildItemsListTab(String category, List<Map<String, dynamic>> itemsList,Set<String> selectedCategories) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);

    print( "Selected CAtegories ${selectedCategory.length}");
    if ( selectedCategories.isNotEmpty && selectedCategories.contains(category)) {
      return itemsList.map((item) {
        String itemName = item['disName'] as String;
        bool availability = item['availability'] as bool;
        Map<String, dynamic> itemDetails = item;
        print( "Selected CAtegories ${itemName}  ${availability}");
        return _buildDismissibleTab(itemName, color, availability, itemDetails);
      }).toList();
    }  else {
      return [
        Center(
          child: Text('Select a category to view items.'),
        ),
      ];
    }
  }

  Widget _buildDismissibleTab(String item, Color color,bool itemAvail,Map<String, dynamic> item1) {
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

            },

            child: Container(
              margin: EdgeInsets.only(bottom:10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: selectedItem == item
                    ? Colors.grey.shade300
                    : hoverItem == item
                    ? Colors.grey.shade100
                    : Colors.white,
              ),

              child: Row(
                children: [
                  Visibility(
                    visible:  defaultItem == item,
                    child: Container(
                      width: 5,
                      height: 40,
                      decoration: BoxDecoration(
                          color: GlobalVariables.textColor,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),topRight:Radius.circular(10))
                      ),
                    ),
                  ),
                  Visibility(
                    visible:  defaultItem != item,
                    child: Container(
                      width: 5,
                    ),
                  ),
                  SizedBox(width: 5*fem,),
                  Container(
                    width: 120*fem,
                    child: Text(
                      item,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: selectedItem == item
                            ? GlobalVariables.textColor
                            : color,
                      ),
                    ),
                  ),
                  SizedBox(width: 25*fem,),
                  Container(
                    width:60,
                    height: 40,
                    child: SmallCustomTextField(
                      min:0,max:9999,
                      textEditingController: TextEditingController(text: "5"),height: 30,fontSize: 12,
                      onChanged: (text){


                      },
                    ),
                  ),
                  SizedBox(width: 5*fem,),
                  Container(
                    width:60,
                    height: 40,
                    child: SmallCustomTextField(
                      min:0,max:9999,
                      textEditingController: TextEditingController(text: "5"),height: 30,fontSize: 12,
                      onChanged: (text){


                      },
                    ),
                  ),
                  SizedBox(width: 5*fem,),
                  Container(
                    width:60,
                    height: 40,
                    child: Center(
                      child: Text("10000",style: TextStyle(
                        fontFamily: 'RenogareSoft',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: GlobalVariables.textColor,
                      ),),
                    ),
                  ),
                  SizedBox(width: 30*fem,),
                  Row(
                    mainAxisSize: MainAxisSize.min, // Ensure Row takes only as much space as needed
                    children: [
                      Icon(Icons.cancel,color: GlobalVariables.primaryColor,),
                      SizedBox(width: 10*fem,),
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 10*fem,),
                      Icon(Icons.save, color: Colors.blue),
                      // InkWell(
                      //   onTap: () {
                      //
                      //
                      //   },
                      //   child: Container(
                      //     width: 70,
                      //     height: 30,
                      //     padding: EdgeInsets.all(5),
                      //     decoration: BoxDecoration(
                      //       color: Colors.blue, // Replace with your primary color
                      //       borderRadius: BorderRadius.circular(5),
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         "Save",
                      //         style: TextStyle(
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(width: 10*fem,),
                      Transform.scale(
                        scaleY: 0.8,
                        scaleX: 0.8,
                        child: Switch(
                          value: item1['availability'],
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: GlobalVariables.textColor.withOpacity(0.6),
                          inactiveThumbImage: NetworkImage(
                              "https://wallpapercave.com/wp/wp7632851.jpg"
                          ),
                          onChanged: (bool value) {
                            setState(() {
                              item1['availability'] = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
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

}
