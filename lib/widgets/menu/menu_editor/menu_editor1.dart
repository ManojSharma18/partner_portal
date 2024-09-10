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
import '../../../repository/menu_services.dart';
import '../../custom_textfield.dart';
import '../../../constants/search_bar.dart';
import '../../../constants/utils.dart';
import '../../item_availability1.dart';
import '../item_details_1.dart';

class MenuEditor1 extends StatefulWidget {
  final String searchQuery;
  const MenuEditor1({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<MenuEditor1> createState() => _MenuEditorState();
}

class _MenuEditorState extends State<MenuEditor1> with TickerProviderStateMixin {
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
      {'name' : 'Godhi payasa','availability' : false,'category' : 'veg'},
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

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),

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
  Widget build(BuildContext contexts) {
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

      MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S1']!['count'] = menuState.menuItem['sunBreakfastSession1'];
      MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S2']!['count'] = menuState.menuItem['sunBreakfastSession2'];
      MenuEditorVariables.daysMealSession1['Sun']!['Breakfast']!['S3']!['count'] = menuState.menuItem['sunBreakfastSession3'];

      MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S1']!['count'] = menuState.menuItem['sunLunchSession1'];
      MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S2']!['count'] = menuState.menuItem['sunLunchSession2'];
      MenuEditorVariables.daysMealSession1['Sun']!['Lunch']!['S3']!['count'] = menuState.menuItem['sunLunchSession3'];

      MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S1']!['count'] = menuState.menuItem['sunDinnerSession1'];
      MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S2']!['count'] = menuState.menuItem['sunDinnerSession2'];
      MenuEditorVariables.daysMealSession1['Sun']!['Dinner']!['S3']!['count'] = menuState.menuItem['sunDinnerSession3'];

      MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S1']!['count'] = menuState.menuItem['monBreakfastSession1'];
      MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S2']!['count'] = menuState.menuItem['monBreakfastSession2'];
      MenuEditorVariables.daysMealSession1['Mon']!['Breakfast']!['S3']!['count'] = menuState.menuItem['monBreakfastSession3'];

      MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S1']!['count'] = menuState.menuItem['monLunchSession1'];
      MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S2']!['count'] = menuState.menuItem['monLunchSession2'];
      MenuEditorVariables.daysMealSession1['Mon']!['Lunch']!['S3']!['count'] = menuState.menuItem['monLunchSession3'];

      MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S1']!['count'] = menuState.menuItem['monDinnerSession1'];
      MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S2']!['count'] = menuState.menuItem['monDinnerSession2'];
      MenuEditorVariables.daysMealSession1['Mon']!['Dinner']!['S3']!['count'] = menuState.menuItem['monDinnerSession3'];

      MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S1']!['count'] = menuState.menuItem['tueBreakfastSession1'];
      MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S2']!['count'] = menuState.menuItem['tueBreakfastSession2'];
      MenuEditorVariables.daysMealSession1['Tue']!['Breakfast']!['S3']!['count'] = menuState.menuItem['tueBreakfastSession3'];

      MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S1']!['count'] = menuState.menuItem['tueLunchSession1'];
      MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S2']!['count'] = menuState.menuItem['tueLunchSession2'];
      MenuEditorVariables.daysMealSession1['Tue']!['Lunch']!['S3']!['count'] = menuState.menuItem['tueLunchSession3'];

      MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S1']!['count'] = menuState.menuItem['tueDinnerSession1'];
      MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S2']!['count'] = menuState.menuItem['tueDinnerSession2'];
      MenuEditorVariables.daysMealSession1['Tue']!['Dinner']!['S3']!['count'] = menuState.menuItem['tueDinnerSession3'];

      MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S1']!['count'] = menuState.menuItem['wedBreakfastSession1'];
      MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S2']!['count'] = menuState.menuItem['wedBreakfastSession2'];
      MenuEditorVariables.daysMealSession1['Wed']!['Breakfast']!['S3']!['count'] = menuState.menuItem['wedBreakfastSession3'];

      MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S1']!['count'] = menuState.menuItem['wedLunchSession1'];
      MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S2']!['count'] = menuState.menuItem['wedLunchSession2'];
      MenuEditorVariables.daysMealSession1['Wed']!['Lunch']!['S3']!['count'] = menuState.menuItem['wedLunchSession3'];

      MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S1']!['count'] = menuState.menuItem['wedDinnerSession1'];
      MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S2']!['count'] = menuState.menuItem['wedDinnerSession2'];
      MenuEditorVariables.daysMealSession1['Wed']!['Dinner']!['S3']!['count'] = menuState.menuItem['wedDinnerSession3'];

      MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S1']!['count'] = menuState.menuItem['thuBreakfastSession1'];
      MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S2']!['count'] = menuState.menuItem['thuBreakfastSession2'];
      MenuEditorVariables.daysMealSession1['Thu']!['Breakfast']!['S3']!['count'] = menuState.menuItem['thuBreakfastSession3'];

      MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S1']!['count'] = menuState.menuItem['thuLunchSession1'];
      MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S2']!['count'] = menuState.menuItem['thuLunchSession2'];
      MenuEditorVariables.daysMealSession1['Thu']!['Lunch']!['S3']!['count'] = menuState.menuItem['thuLunchSession3'];

      MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S1']!['count'] = menuState.menuItem['thuDinnerSession1'];
      MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S2']!['count']= menuState.menuItem['thuDinnerSession2'];
      MenuEditorVariables.daysMealSession1['Thu']!['Dinner']!['S3']!['count'] = menuState.menuItem['thuDinnerSession3'];

      MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S1']!['count'] = menuState.menuItem['friBreakfastSession1'];
      MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S2']!['count'] = menuState.menuItem['friBreakfastSession2'];
      MenuEditorVariables.daysMealSession1['Fri']!['Breakfast']!['S3']!['count'] = menuState.menuItem['friBreakfastSession3'];

      MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S1']!['count'] = menuState.menuItem['friLunchSession1'];
      MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S2']!['count'] = menuState.menuItem['friLunchSession2'];
      MenuEditorVariables.daysMealSession1['Fri']!['Lunch']!['S3']!['count'] = menuState.menuItem['friLunchSession3'];

      MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S1']!['count'] = menuState.menuItem['friDinnerSession1'];
      MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S2']!['count'] = menuState.menuItem['friDinnerSession2'];
      MenuEditorVariables.daysMealSession1['Fri']!['Dinner']!['S3']!['count'] = menuState.menuItem['friDinnerSession3'];

      MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S1']!['count'] = menuState.menuItem['satBreakfastSession1'];
      MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S2']!['count'] = menuState.menuItem['satBreakfastSession2'];
      MenuEditorVariables.daysMealSession1['Sat']!['Breakfast']!['S3']!['count'] = menuState.menuItem['satBreakfastSession3'];

      MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S1']!['count'] = menuState.menuItem['satLunchSession1'];
      MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S2']!['count'] = menuState.menuItem['satLunchSession2'];
      MenuEditorVariables.daysMealSession1['Sat']!['Lunch']!['S3']!['count'] = menuState.menuItem['satLunchSession3'];

      MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S1']!['count'] = menuState.menuItem['satDinnerSession1'];
      MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S2']!['count'] = menuState.menuItem['satDinnerSession2'];
      MenuEditorVariables.daysMealSession1['Sat']!['Dinner']!['S3']!['count'] = menuState.menuItem['satDinnerSession3'];


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
      MenuEditorVariables.halfNormalPriceController.text = menuState.menuItem['halfNormalPrice'].toString() ?? '0';
      MenuEditorVariables.packagindController.text= menuState.menuItem['packagePrice'].toString();
      MenuEditorVariables.preorderPriceController.text = menuState.menuItem['preorderPrice'].toString();
      MenuEditorVariables.halfPreorderPriceController.text = menuState.menuItem['halfPreorderPrice'].toString() ?? '0';
      MenuEditorVariables.cuisineController.text = menuState.menuItem['cuisine'].toString();
      MenuEditorVariables.normalFinalPrice = menuState.menuItem['normalFinalPrice'] ?? 0;
      MenuEditorVariables.preOrderFinalPrice = menuState.menuItem['preOrderFinalPrice'] ?? 0;
      MenuEditorVariables.halfNormalFinalPrice = menuState.menuItem['halfNormalFinalPrice'] ?? 0;
      MenuEditorVariables.halfPreOrderFinalPrice = menuState.menuItem['halfPreOrderFinalPrice'] ?? 0;
      MenuEditorVariables.halfSelected = menuState.menuItem['halfPrice'] ?? false;
      MenuEditorVariables.selectedOption = menuState.menuItem['available_type'];
      MenuEditorVariables.consumptionMode = menuState.menuItem['consumptionMode'] ?? [];


      oldTagName = MenuEditorVariables.tagController.text;

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
                mobileBuilder: (BuildContext contexts,BoxConstraints constraints){
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
                                                  size: 15,
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
                tabletBuilder: (BuildContext contexts,BoxConstraints constraints) {
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
                                                                    'ADD',
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
                                                        children: _buildItemsList(category, itemsList,state.selectedCategories,menuContext,menuState),
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
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF363563),
                                          ),
                                          tabs: [
                                            Tab(text: 'Order schedule'),
                                            Tab(text: 'Subscription schedule'),
                                            Tab(text: 'Details'),
                                            Tab(text: 'Add on'),
                                          ],
                                        ),
                                      ),
                                      body: TabBarView(
                                        controller: _tabController,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [

                                          ItemAvailability1(checkKey: _checkKey,menuLoadedState: menuState,),

                                          SubscriptionAvailability(),

                                          ItemDetails1(resource: MenuEditorVariables.rawSourceController.text,  item: MenuEditorVariables.selectItem, type: 'Tab',),

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
                                                  MenuEditorFunction.saveChangesItem(context,menuState,menuContext,foodCategories);
                                                  // MenuEditorVariables.displayNameController.text = MenuEditorVariables.displayNameController.text.trim();
                                                  // String firstCharacter = MenuEditorVariables.displayNameController.text.isNotEmpty
                                                  //     ? MenuEditorVariables.displayNameController.text[0]
                                                  //     : '';
                                                  //
                                                  // bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                                                  //     (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
                                                  //         '0123456789'.contains(firstCharacter)));
                                                  //
                                                  // MenuEditorVariables.requestBody = {
                                                  //   "ritem_name": MenuEditorVariables.nameController.text,
                                                  //   "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                                                  //   "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                                                  //   "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                                                  //   "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                                                  //   "ritem_normalFinalPrice" : MenuEditorVariables.normalFinalPrice,
                                                  //   "ritem_preorderFinalPrice" : MenuEditorVariables.preOrderFinalPrice,
                                                  //   // "ritem_tag" : MenuEditorVariables.i
                                                  //   "ritem_priceRange": MenuEditorVariables.budgetController.text,
                                                  //   "ritem_itemType": MenuEditorVariables.typeController.text,
                                                  //   "ritem_itemSubType": MenuEditorVariables.subTypeController.text,
                                                  //   "ritem_comboType": MenuEditorVariables.comboController.text,
                                                  //   "ritem_rawSource": MenuEditorVariables.rawSourceController.text,
                                                  //   "ritem_category": MenuEditorVariables.categoryController.text,
                                                  //   "ritem_subCategory": MenuEditorVariables.subCategoryController.text,
                                                  //   "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                                                  //   "ritem_regional": MenuEditorVariables.regionalController.text,
                                                  //   // "ritem_tag" : MenuEditorVariables.subTagController.text,
                                                  //   "fp_unit_avail_days_and_meals": {
                                                  //     "Sun": {
                                                  //       "Breakfast": true,
                                                  //       "Lunch": false,
                                                  //       "Dinner": true,
                                                  //       "BreakfastSession1": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S1'],
                                                  //       "BreakfastSession2": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S2'],
                                                  //       "BreakfastSession3": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S3'],
                                                  //       "BreakfastSession4": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S4'],
                                                  //       "LunchSession1": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S1'],
                                                  //       "LunchSession2": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S2'],
                                                  //       "LunchSession3": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S3'],
                                                  //       "LunchSession4": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S4'],
                                                  //       "DinnerSession1": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S1'],
                                                  //       "DinnerSession2": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S2'],
                                                  //       "DinnerSession3": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S3'],
                                                  //       "DinnerSession4": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S4'],
                                                  //     },
                                                  //     "Mon": {
                                                  //       "Breakfast": true,
                                                  //       "Lunch": true,
                                                  //       "Dinner": false,
                                                  //       "BreakfastSession1": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S1'],
                                                  //       "BreakfastSession2": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S2'],
                                                  //       "BreakfastSession3": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S3'],
                                                  //       "BreakfastSession4": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S4'],
                                                  //       "LunchSession1": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S1'],
                                                  //       "LunchSession2": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S2'],
                                                  //       "LunchSession3": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S3'],
                                                  //       "LunchSession4": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S4'],
                                                  //       "DinnerSession1": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S1'],
                                                  //       "DinnerSession2": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S2'],
                                                  //       "DinnerSession3": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S3'],
                                                  //       "DinnerSession4": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S4'],
                                                  //     },
                                                  //     "Tue": {
                                                  //       "Breakfast": false,
                                                  //       "Lunch": true,
                                                  //       "Dinner": true,
                                                  //       "BreakfastSession1": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S1'],
                                                  //       "BreakfastSession2": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S2'],
                                                  //       "BreakfastSession3": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S3'],
                                                  //       "BreakfastSession4": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S4'],
                                                  //       "LunchSession1": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S1'],
                                                  //       "LunchSession2": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S2'],
                                                  //       "LunchSession3": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S3'],
                                                  //       "LunchSession4": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S4'],
                                                  //       "DinnerSession1": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S1'],
                                                  //       "DinnerSession2": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S2'],
                                                  //       "DinnerSession3": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S3'],
                                                  //       "DinnerSession4": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S4'],
                                                  //     },
                                                  //     "Wed": {
                                                  //       "Breakfast": true,
                                                  //       "Lunch": false,
                                                  //       "Dinner": false,
                                                  //       "BreakfastSession1": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S1'],
                                                  //       "BreakfastSession2": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S2'],
                                                  //       "BreakfastSession3": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S3'],
                                                  //       "BreakfastSession4": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S4'],
                                                  //       "LunchSession1": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S1'],
                                                  //       "LunchSession2": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S2'],
                                                  //       "LunchSession3": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S3'],
                                                  //       "LunchSession4": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S4'],
                                                  //       "DinnerSession1": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S1'],
                                                  //       "DinnerSession2": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S2'],
                                                  //       "DinnerSession3": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S3'],
                                                  //       "DinnerSession4": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S4'],
                                                  //     },
                                                  //     "Thu": {
                                                  //       "Breakfast": false,
                                                  //       "Lunch": true,
                                                  //       "Dinner": true,
                                                  //       "BreakfastSession1": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S1'],
                                                  //       "BreakfastSession2": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S2'],
                                                  //       "BreakfastSession3": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S3'],
                                                  //       "BreakfastSession4": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S4'],
                                                  //       "LunchSession1": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S1'],
                                                  //       "LunchSession2": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S2'],
                                                  //       "LunchSession3": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S3'],
                                                  //       "LunchSession4": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S4'],
                                                  //       "DinnerSession1": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S1'],
                                                  //       "DinnerSession2": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S2'],
                                                  //       "DinnerSession3": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S3'],
                                                  //       "DinnerSession4": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S4'],
                                                  //     },
                                                  //     "Fri": {
                                                  //       "Breakfast": true,
                                                  //       "Lunch": true,
                                                  //       "Dinner": true,
                                                  //       "BreakfastSession1": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S1'],
                                                  //       "BreakfastSession2": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S2'],
                                                  //       "BreakfastSession3": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S3'],
                                                  //       "BreakfastSession4": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S4'],
                                                  //       "LunchSession1": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S1'],
                                                  //       "LunchSession2": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S2'],
                                                  //       "LunchSession3": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S3'],
                                                  //       "LunchSession4": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S4'],
                                                  //       "DinnerSession1": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S1'],
                                                  //       "DinnerSession2": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S2'],
                                                  //       "DinnerSession3": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S3'],
                                                  //       "DinnerSession4": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S4'],
                                                  //     },
                                                  //     "Sat": {
                                                  //       "Breakfast": false,
                                                  //       "Lunch": false,
                                                  //       "Dinner": false,
                                                  //       "BreakfastSession1": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S1'],
                                                  //       "BreakfastSession2": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S2'],
                                                  //       "BreakfastSession3": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S3'],
                                                  //       "BreakfastSession4": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S4'],
                                                  //       "LunchSession1": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S1'],
                                                  //       "LunchSession2": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S2'],
                                                  //       "LunchSession3": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S3'],
                                                  //       "LunchSession4": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S4'],
                                                  //       "DinnerSession1": MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S1'],
                                                  //       "DinnerSession2": MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S2'],
                                                  //       "DinnerSession3": MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S3'],
                                                  //       "DinnerSession4": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S4'],
                                                  //     },
                                                  //   }
                                                  // };
                                                  //
                                                  // String oldTag = "";
                                                  // String itemId = "";
                                                  // String name = "";
                                                  // Map<String, dynamic> oneItem = {};
                                                  // bool itemExists = false;
                                                  // if(MenuEditorVariables.displayNameController.text.trim() == "") {
                                                  //   MenuEditorFunction.showShouldNotNull(context,"Display");
                                                  // }
                                                  // else if( double.parse(MenuEditorVariables.normalPriceController.text) < 1 || double.parse(MenuEditorVariables.preorderPriceController.text) < 1){
                                                  //   MenuEditorFunction.showPriceShouldNotBeBull(context,);
                                                  // }
                                                  // else if(MenuEditorVariables.displayNameController.text.trim().length <3){
                                                  //   MenuEditorFunction.showStringLengthAlert(context, "Display name");
                                                  // }
                                                  // else if(!isFirstCharacterLetterOrDigit) {
                                                  //   MenuEditorFunction.showOnlyDigitAndLettersAlert(context, "Display name");
                                                  // }
                                                  // else {
                                                  //   for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                                                  //     if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                                                  //       print("Item already exists");
                                                  //       name = itemName['disName'];
                                                  //       itemExists = true;
                                                  //       break; // Exit the loop as soon as we find a match
                                                  //     }
                                                  //   }
                                                  //
                                                  //   if (itemExists  && ItemDetails.checking && !ItemDetails.enable) {
                                                  //     MenuEditorFunction.showAlreadyExistAlert(context);
                                                  //   }
                                                  //   else {
                                                  //     // Item doesn't exist, add it to the list
                                                  //     for (final categoryItems in foodCategories.values) {
                                                  //       for (final itemName in categoryItems) {
                                                  //         if (MenuEditorVariables.displayNameController.text == itemName['disName']) {
                                                  //           print("Item already exists");
                                                  //           itemId = itemName['_id'];
                                                  //           name = itemName['disName'];
                                                  //           oldTag = itemName['tag'];
                                                  //           oneItem = itemName;
                                                  //           itemExists = true;
                                                  //           break; // Exit the loop as soon as we find a match
                                                  //         }
                                                  //       }
                                                  //       if (itemExists) {
                                                  //         break; // Exit the outer loop if the item exists
                                                  //       }
                                                  //     }
                                                  //
                                                  //     if (itemExists && ItemDetails.checking && !ItemDetails.enable) {
                                                  //       // Navigator.of(context).pop();
                                                  //       MenuEditorFunction.showReplaceItemAlert(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem);
                                                  //     }
                                                  //     else {
                                                  //       // Map<String, dynamic> newItem = {'name': item.text, 'availability': true};
                                                  //       // foodCategories[category]!.add(newItem);
                                                  //       menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
                                                  //     }
                                                  //   }
                                                  // }


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
                                                  child: CustomTextField(label: "Tag", controller: MenuEditorVariables.tagController,width: 130*fem,height: 60, displayCount: true,
                                                    onChanged: (val) {
                                                    MenuEditorVariables.tagFlag = true;
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
                                                    MenuEditorVariables.tagController.text = oldTagName;
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
                                                      if (itemExists && ItemDetails.checking) {
                                                        MenuEditorFunction.showSectionExistAlertWhileUpdating(context, menuContext, MenuEditorVariables.oldestTagName, MenuEditorVariables.tagController.text.trim());
                                                      } else {
                                                        context.read<MenuBloc>().add(UpdateTagNameEvent(context, MenuEditorVariables.oldestTagName, MenuEditorVariables.tagController.text.trim()));
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
                            ],
                          ),
                        ),
                      ],
                    ),


                  );
                },
                desktopBuilder: (BuildContext contexts,BoxConstraints constraints) {
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
                                                  if(MenuEditorVariables.tagFlag)
                                                    {
                                                      showDialog(
                                                          context: context, builder: (Builder) {
                                                        return AlertDialog(
                                                          title: Text("You have edited Tag name do you want to save changes?",style: TextStyle(
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
                                                                      MenuEditorVariables.tagFlag = false;
                                                                      setState(() {
                                                                        MenuEditorVariables.selectedItem = "";
                                                                        selectedItem = "";
                                                                        oldTagName = category;
                                                                        MenuEditorVariables.oldestTagName = category;
                                                                        MenuEditorVariables.tagController.text = category;
                                                                      });
                                                                      context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(state.selectedCategories,state.foodCategories, category));
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
                                                                    MenuEditorFunction.saveChangesTag(context,menuContext,oldTagName,foodCategories);
                                                                    setState(() {
                                                                      MenuEditorVariables.selectedItem = "";
                                                                      selectedItem = "";
                                                                      oldTagName = category;
                                                                      MenuEditorVariables.oldestTagName = category;
                                                                      MenuEditorVariables.tagController.text = category;
                                                                    });
                                                                    context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(state.selectedCategories,state.foodCategories, category));

                                                                  },
                                                                  child: Container(
                                                                    width: 100,
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
                                                  else if(MenuEditorVariables.displayNameFlag || MenuEditorVariables.propertyFlag || MenuEditorVariables.priceFlag || MenuEditorVariables.availabilityFlag)
                                                  {
                                                    showDialog(
                                                        context: context, builder: (Builder) {
                                                      return AlertDialog(
                                                        title: Text(MenuEditorVariables.availabilityFlag ? "You have changed the order schedule do you want to save changes" :"You have edited some fields do you want to save changes?",style: TextStyle(
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
                                                                    MenuEditorVariables.priceFlag = false;
                                                                    MenuEditorVariables.propertyFlag = false;
                                                                    MenuEditorVariables.displayNameFlag = false;
                                                                    MenuEditorVariables.availabilityFlag = false;
                                                                    setState(() {
                                                                      MenuEditorVariables.selectedItem = "";
                                                                      selectedItem = "";
                                                                      oldTagName = category;
                                                                      MenuEditorVariables.oldestTagName = category;
                                                                      MenuEditorVariables.tagController.text = category;
                                                                    });
                                                                    context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(state.selectedCategories,state.foodCategories, category));
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
                                                                  setState(() {
                                                                    MenuEditorVariables.selectedItem = "";
                                                                    selectedItem = "";
                                                                    oldTagName = category;
                                                                    MenuEditorVariables.oldestTagName = category;
                                                                    MenuEditorVariables.tagController.text = category;
                                                                  });
                                                                  context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(state.selectedCategories,state.foodCategories, category));

                                                                },
                                                                child: Container(
                                                                  width: 100,
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
                                                  else {
                                                    setState(() {
                                                      MenuEditorVariables.selectedItem = "";
                                                      selectedItem = "";
                                                      oldTagName = category;
                                                      MenuEditorVariables.oldestTagName = category;
                                                      MenuEditorVariables.tagController.text = category;
                                                    });
                                                    context.read<MenuEditorBloc>().add(SelectMenuCategoryEvent(state.selectedCategories,state.foodCategories, category));
                                                  }
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
                                                        trailing: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {

                                                                MenuEditorFunction.showAddItemDialogImported(category, context, menuContext, foodCategories);
                                                                // bool tagFound = false;
                                                                //
                                                                // MenuEditorVariables.tags.forEach((tag) {
                                                                //   if(category == tag)
                                                                //   {
                                                                //     tagFound = true;
                                                                //   }
                                                                // });
                                                                // if(tagFound){
                                                                //   MenuEditorFunction.showAddItemDialogImported(category, context, menuContext, foodCategories);
                                                                // }else{
                                                                //   MenuEditorFunction.showAddItemDialogCreated(category, context, menuContext, foodCategories);
                                                                // }
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
                                                                    'ADD',
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
                                                        children: _buildItemsList(category, itemsList,state.selectedCategories,menuContext,menuState),
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
                                  child: BlocBuilder<MenuBloc,MenuState>(
                                    builder: (menuContext, state) {

                                      if(state is MenuLoadedState) {
                                        print("In menu loading time and loading context coming over ffhere");
                                        return DefaultTabController(
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
                                                  Tab(text: 'Order schedule'),
                                                  Tab(text: 'Subscription schedule'),
                                                  Tab(text: 'Details'),
                                                  Tab(text: 'Add on'),
                                                ],
                                                onTap: (index) {
                                                  switch(index) {
                                                    case 0: {
                                                      if(MenuEditorVariables.priceFlag || MenuEditorVariables.displayNameFlag || MenuEditorVariables.propertyFlag) {

                                                        showDialog(
                                                            context: context, builder: (Builder) {
                                                          return AlertDialog(
                                                            title: Text("You have edited some fields in details page do you want to save changes?",style: TextStyle(
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
                                                                        setState(() {
                                                                          MenuEditorVariables.priceFlag = false;
                                                                          MenuEditorVariables.propertyFlag = false;
                                                                          MenuEditorVariables.displayNameFlag = false;
                                                                          _tabController.index = index;
                                                                          Navigator.pop(menuContext);
                                                                        });
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
                                                                      _tabController.index = index;
                                                                    },
                                                                    child: Container(
                                                                      width: 100,
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

                                                        _tabController.index = _tabController.previousIndex;

                                                      }
                                                      else {
                                                        _tabController.index = index;
                                                      }
                                                    }
                                                    case 2:{
                                                      if(MenuEditorVariables.availabilityFlag) {

                                                        showDialog(
                                                            context: context, builder: (Builder) {
                                                          return AlertDialog(
                                                            title: Text("You have edited some fields in order schedule page do you want to save changes?",style: TextStyle(
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
                                                                        setState(() {
                                                                          MenuEditorVariables.availabilityFlag = false;
                                                                          _tabController.index = index;
                                                                          Navigator.pop(menuContext);
                                                                        });
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
                                                                      _tabController.index = index;
                                                                    },
                                                                    child: Container(
                                                                      width: 100,
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

                                                        _tabController.index = _tabController.previousIndex;

                                                      }
                                                      else {
                                                        _tabController.index = index;
                                                      }
                                                    }
                                                  }
                                                },

                                              ),
                                            ),
                                            body: TabBarView(
                                              controller: _tabController,
                                              physics: NeverScrollableScrollPhysics(),
                                              children: [

                                                ItemAvailability1(checkKey: _checkKey,menuLoadedState: menuState,),

                                                SubscriptionAvailability(),

                                                ItemDetails1(resource: MenuEditorVariables.rawSourceController.text,  item: MenuEditorVariables.selectItem, type: 'Desktop',menuContext : menuContext,),

                                                VariantsAddon(),


                                              ],
                                            ),

                                            bottomNavigationBar: Container(
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
                                                        MenuEditorVariables.priceFlag = false;
                                                        MenuEditorVariables.propertyFlag = false;
                                                        MenuEditorVariables.displayNameFlag = false;
                                                        MenuEditorVariables.availabilityFlag = false;
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
                                                      MenuEditorFunction.saveChangesItem(context,menuState,menuContext,foodCategories);
                                                      // MenuEditorVariables.displayNameController.text = MenuEditorVariables.displayNameController.text.trim();
                                                      // String firstCharacter = MenuEditorVariables.displayNameController.text.isNotEmpty
                                                      //     ? MenuEditorVariables.displayNameController.text[0]
                                                      //     : '';
                                                      //
                                                      // bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                                                      //     (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
                                                      //         '0123456789'.contains(firstCharacter)));
                                                      //
                                                      // MenuEditorVariables.requestBody = {
                                                      //   "ritem_name": MenuEditorVariables.nameController.text,
                                                      //   "ritem_dispname": MenuEditorVariables.displayNameController.text.trim(),
                                                      //   "ritem_normalPrice": MenuEditorVariables.normalPriceController.text,
                                                      //   "ritem_packagePrice": MenuEditorVariables.packagindController.text,
                                                      //   "ritem_preorderPrice": MenuEditorVariables.preorderPriceController.text,
                                                      //   "ritem_normalFinalPrice" : MenuEditorVariables.normalFinalPrice,
                                                      //   "ritem_preorderFinalPrice" : MenuEditorVariables.preOrderFinalPrice,
                                                      //   // "ritem_tag" : MenuEditorVariables.i
                                                      //   "ritem_priceRange": MenuEditorVariables.budgetController.text,
                                                      //   "ritem_itemType": MenuEditorVariables.typeController.text,
                                                      //   "ritem_itemSubType": MenuEditorVariables.subTypeController.text,
                                                      //   "ritem_comboType": MenuEditorVariables.comboController.text,
                                                      //   "ritem_rawSource": MenuEditorVariables.rawSourceController.text,
                                                      //   "ritem_category": MenuEditorVariables.categoryController.text,
                                                      //   "ritem_subCategory": MenuEditorVariables.subCategoryController.text,
                                                      //   "ritem_cuisine": MenuEditorVariables.cuisineController.text,
                                                      //   "ritem_regional": MenuEditorVariables.regionalController.text,
                                                      //   // "ritem_tag" : MenuEditorVariables.subTagController.text,
                                                      //   "fp_unit_avail_days_and_meals": {
                                                      //     "Sun": {
                                                      //       "Breakfast": true,
                                                      //       "Lunch": false,
                                                      //       "Dinner": true,
                                                      //       "BreakfastSession1": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S1'],
                                                      //       "BreakfastSession2": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S2'],
                                                      //       "BreakfastSession3": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S3'],
                                                      //       "BreakfastSession4": MenuEditorVariables.daysMealSession['Sun']!['Breakfast']!['S4'],
                                                      //       "LunchSession1": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S1'],
                                                      //       "LunchSession2": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S2'],
                                                      //       "LunchSession3": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S3'],
                                                      //       "LunchSession4": MenuEditorVariables.daysMealSession['Sun']!['Lunch']!['S4'],
                                                      //       "DinnerSession1": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S1'],
                                                      //       "DinnerSession2": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S2'],
                                                      //       "DinnerSession3": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S3'],
                                                      //       "DinnerSession4": MenuEditorVariables.daysMealSession['Sun']!['Dinner']!['S4'],
                                                      //     },
                                                      //     "Mon": {
                                                      //       "Breakfast": true,
                                                      //       "Lunch": true,
                                                      //       "Dinner": false,
                                                      //       "BreakfastSession1": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S1'],
                                                      //       "BreakfastSession2": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S2'],
                                                      //       "BreakfastSession3": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S3'],
                                                      //       "BreakfastSession4": MenuEditorVariables.daysMealSession['Mon']!['Breakfast']!['S4'],
                                                      //       "LunchSession1": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S1'],
                                                      //       "LunchSession2": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S2'],
                                                      //       "LunchSession3": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S3'],
                                                      //       "LunchSession4": MenuEditorVariables.daysMealSession['Mon']!['Lunch']!['S4'],
                                                      //       "DinnerSession1": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S1'],
                                                      //       "DinnerSession2": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S2'],
                                                      //       "DinnerSession3": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S3'],
                                                      //       "DinnerSession4": MenuEditorVariables.daysMealSession['Mon']!['Dinner']!['S4'],
                                                      //     },
                                                      //     "Tue": {
                                                      //       "Breakfast": false,
                                                      //       "Lunch": true,
                                                      //       "Dinner": true,
                                                      //       "BreakfastSession1": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S1'],
                                                      //       "BreakfastSession2": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S2'],
                                                      //       "BreakfastSession3": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S3'],
                                                      //       "BreakfastSession4": MenuEditorVariables.daysMealSession['Tue']!['Breakfast']!['S4'],
                                                      //       "LunchSession1": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S1'],
                                                      //       "LunchSession2": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S2'],
                                                      //       "LunchSession3": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S3'],
                                                      //       "LunchSession4": MenuEditorVariables.daysMealSession['Tue']!['Lunch']!['S4'],
                                                      //       "DinnerSession1": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S1'],
                                                      //       "DinnerSession2": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S2'],
                                                      //       "DinnerSession3": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S3'],
                                                      //       "DinnerSession4": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S4'],
                                                      //     },
                                                      //     "Wed": {
                                                      //       "Breakfast": true,
                                                      //       "Lunch": false,
                                                      //       "Dinner": false,
                                                      //       "BreakfastSession1": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S1'],
                                                      //       "BreakfastSession2": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S2'],
                                                      //       "BreakfastSession3": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S3'],
                                                      //       "BreakfastSession4": MenuEditorVariables.daysMealSession['Wed']!['Breakfast']!['S4'],
                                                      //       "LunchSession1": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S1'],
                                                      //       "LunchSession2": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S2'],
                                                      //       "LunchSession3": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S3'],
                                                      //       "LunchSession4": MenuEditorVariables.daysMealSession['Wed']!['Lunch']!['S4'],
                                                      //       "DinnerSession1": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S1'],
                                                      //       "DinnerSession2": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S2'],
                                                      //       "DinnerSession3": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S3'],
                                                      //       "DinnerSession4": MenuEditorVariables.daysMealSession['Wed']!['Dinner']!['S4'],
                                                      //     },
                                                      //     "Thu": {
                                                      //       "Breakfast": false,
                                                      //       "Lunch": true,
                                                      //       "Dinner": true,
                                                      //       "BreakfastSession1": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S1'],
                                                      //       "BreakfastSession2": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S2'],
                                                      //       "BreakfastSession3": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S3'],
                                                      //       "BreakfastSession4": MenuEditorVariables.daysMealSession['Thu']!['Breakfast']!['S4'],
                                                      //       "LunchSession1": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S1'],
                                                      //       "LunchSession2": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S2'],
                                                      //       "LunchSession3": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S3'],
                                                      //       "LunchSession4": MenuEditorVariables.daysMealSession['Thu']!['Lunch']!['S4'],
                                                      //       "DinnerSession1": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S1'],
                                                      //       "DinnerSession2": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S2'],
                                                      //       "DinnerSession3": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S3'],
                                                      //       "DinnerSession4": MenuEditorVariables.daysMealSession['Thu']!['Dinner']!['S4'],
                                                      //     },
                                                      //     "Fri": {
                                                      //       "Breakfast": true,
                                                      //       "Lunch": true,
                                                      //       "Dinner": true,
                                                      //       "BreakfastSession1": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S1'],
                                                      //       "BreakfastSession2": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S2'],
                                                      //       "BreakfastSession3": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S3'],
                                                      //       "BreakfastSession4": MenuEditorVariables.daysMealSession['Fri']!['Breakfast']!['S4'],
                                                      //       "LunchSession1": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S1'],
                                                      //       "LunchSession2": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S2'],
                                                      //       "LunchSession3": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S3'],
                                                      //       "LunchSession4": MenuEditorVariables.daysMealSession['Fri']!['Lunch']!['S4'],
                                                      //       "DinnerSession1": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S1'],
                                                      //       "DinnerSession2": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S2'],
                                                      //       "DinnerSession3": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S3'],
                                                      //       "DinnerSession4": MenuEditorVariables.daysMealSession['Fri']!['Dinner']!['S4'],
                                                      //     },
                                                      //     "Sat": {
                                                      //       "Breakfast": false,
                                                      //       "Lunch": false,
                                                      //       "Dinner": false,
                                                      //       "BreakfastSession1": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S1'],
                                                      //       "BreakfastSession2": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S2'],
                                                      //       "BreakfastSession3": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S3'],
                                                      //       "BreakfastSession4": MenuEditorVariables.daysMealSession['Sat']!['Breakfast']!['S4'],
                                                      //       "LunchSession1": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S1'],
                                                      //       "LunchSession2": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S2'],
                                                      //       "LunchSession3": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S3'],
                                                      //       "LunchSession4": MenuEditorVariables.daysMealSession['Sat']!['Lunch']!['S4'],
                                                      //       "DinnerSession1": MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S1'],
                                                      //       "DinnerSession2": MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S2'],
                                                      //       "DinnerSession3": MenuEditorVariables.daysMealSession['Sat']!['Dinner']!['S3'],
                                                      //       "DinnerSession4": MenuEditorVariables.daysMealSession['Tue']!['Dinner']!['S4'],
                                                      //     },
                                                      //   }
                                                      // };
                                                      //
                                                      // String oldTag = "";
                                                      // String itemId = "";
                                                      // String name = "";
                                                      // Map<String, dynamic> oneItem = {};
                                                      // bool itemExists = false;
                                                      // if(MenuEditorVariables.displayNameController.text.trim() == "") {
                                                      //   MenuEditorFunction.showShouldNotNull(context,"Display");
                                                      // }
                                                      // else if( double.parse(MenuEditorVariables.normalPriceController.text) < 1 || double.parse(MenuEditorVariables.preorderPriceController.text) < 1){
                                                      //   MenuEditorFunction.showPriceShouldNotBeBull(context,);
                                                      // }
                                                      // else if(MenuEditorVariables.displayNameController.text.trim().length <3){
                                                      //   MenuEditorFunction.showStringLengthAlert(context, "Display name");
                                                      // } else if(!isFirstCharacterLetterOrDigit) {
                                                      //   MenuEditorFunction.showOnlyDigitAndLettersAlert(context, "Display name");
                                                      // }
                                                      // else {
                                                      //   for (final itemName in foodCategories[MenuEditorVariables.tagController.text]!) {
                                                      //     if (MenuEditorVariables.displayNameController.text.trim() == itemName['disName']) {
                                                      //       print("Item already exists");
                                                      //       name = itemName['disName'];
                                                      //       itemExists = true;
                                                      //       break; // Exit the loop as soon as we find a match
                                                      //     }
                                                      //   }
                                                      //
                                                      //   if (itemExists  && ItemDetails.checking && !ItemDetails.enable) {
                                                      //     MenuEditorFunction.showAlreadyExistAlert(context);
                                                      //   }
                                                      //   else {
                                                      //     // Item doesn't exist, add it to the list
                                                      //     for (final categoryItems in foodCategories.values) {
                                                      //       for (final itemName in categoryItems) {
                                                      //         if (MenuEditorVariables.displayNameController.text == itemName['disName']) {
                                                      //           print("Item already exists");
                                                      //           itemId = itemName['_id'];
                                                      //           name = itemName['disName'];
                                                      //           oldTag = itemName['tag'];
                                                      //           oneItem = itemName;
                                                      //           itemExists = true;
                                                      //           break; // Exit the loop as soon as we find a match
                                                      //         }
                                                      //       }
                                                      //       if (itemExists) {
                                                      //         break; // Exit the outer loop if the item exists
                                                      //       }
                                                      //     }
                                                      //
                                                      //     if (itemExists && ItemDetails.checking && !ItemDetails.enable) {
                                                      //       // Navigator.of(context).pop();
                                                      //       MenuEditorFunction.showReplaceItemAlert(context, menuContext, itemId, MenuEditorVariables.tagController.text, name, MenuEditorVariables.requestBody,oldTag,oneItem);
                                                      //     }
                                                      //     else {
                                                      //       // Map<String, dynamic> newItem = {'name': item.text, 'availability': true};
                                                      //       // foodCategories[category]!.add(newItem);
                                                      //       menuContext.read<MenuBloc>().add(UpdateLiveMenuEvent(context, menuState.menuItem["_id"], MenuEditorVariables.requestBody, menuState.menuItem['disName']));
                                                      //     }
                                                      //   }
                                                      // }

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

                                        );
                                      }
                                      return CircularProgressIndicator();
                                    },
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

                                              // BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext mContext, mState) {
                                              //   if(mState is MenuLoadingState) {
                                              //     return CircularProgressIndicator();
                                              //   }
                                              //   if(mState is MenuLoadedState) {
                                              //     return Transform.scale(
                                              //       scaleY: 0.8,
                                              //       scaleX: 0.8,
                                              //       child: Switch(
                                              //         value: checkAvailabilityForCategory(MenuEditorVariables.tagController.text, foodCategories),
                                              //         inactiveThumbColor: Colors.white,
                                              //         inactiveTrackColor:
                                              //         GlobalVariables.textColor.withOpacity(0.6),
                                              //         inactiveThumbImage: NetworkImage(
                                              //             "https://wallpapercave.com/wp/wp7632851.jpg"),
                                              //         onChanged: (bool value) {
                                              //           mContext.read<MenuBloc>().add(UpdateSectionAvailability(context, MenuEditorVariables.tagController.text, value));
                                              //         },
                                              //       ),
                                              //     );
                                              //   }
                                              //   return CircularProgressIndicator();
                                              // },
                                              //
                                              // ),
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
                                                  child: CustomTextField(label: "Tag", controller: MenuEditorVariables.tagController,width: 130*fem,height: 60, displayCount: true,
                                                    onChanged: (val) {
                                                    MenuEditorVariables.tagFlag = true;
                                                    },)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      bottomNavigationBar: Container(
                                        height: 70,
                                        color: Colors.grey.shade50,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 20*fem,),
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
                                            SizedBox(width: 40*fem,),
                                            InkWell(
                                              onTap: (){
                                                setState(() {
                                                  MenuEditorVariables.tagController.text = oldTagName;
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

                                                MenuEditorFunction.saveChangesTag(context, menuContext, oldTagName, foodCategories);
                                                // MenuEditorVariables.tagController.text = MenuEditorVariables.tagController.text.trim();
                                                //
                                                // String firstCharacter = MenuEditorVariables.tagController.text.isNotEmpty
                                                //     ? MenuEditorVariables.tagController.text[0]
                                                //     : '';
                                                //
                                                // bool isFirstCharacterLetterOrDigit = (firstCharacter.isNotEmpty &&
                                                //     (firstCharacter.toUpperCase() != firstCharacter.toLowerCase() ||
                                                //         '0123456789'.contains(firstCharacter)));
                                                //
                                                // if(oldTagName == MenuEditorVariables.tagController.text) {
                                                //   MenuEditorFunction.showNothingToSaveAlert(context);
                                                // } else {
                                                //   bool itemExists = false;
                                                //   if (MenuEditorVariables.tagController.text.trim() == "") {
                                                //     MenuEditorFunction.showShouldNotNull(context, "Section");
                                                //   }
                                                //   else if (MenuEditorVariables.tagController.text.trim().length < 3) {
                                                //     MenuEditorFunction.showStringLengthAlert(context, "Section");
                                                //   }
                                                //   else if (!isFirstCharacterLetterOrDigit) {
                                                //     MenuEditorFunction.showOnlyDigitAndLettersAlert(context, "Section");
                                                //   }
                                                //   else {
                                                //     for (final categoryItems in foodCategories.keys) {
                                                //       if (categoryItems == MenuEditorVariables.tagController.text.trim()) {
                                                //         itemExists = true;
                                                //         break;
                                                //       }
                                                //     }
                                                //     if (itemExists && ItemDetails.checking) {
                                                //       MenuEditorFunction.showSectionExistAlertWhileUpdating(context, menuContext, MenuEditorVariables.oldestTagName, MenuEditorVariables.tagController.text.trim());
                                                //     } else {
                                                //       context.read<MenuBloc>().add(UpdateTagNameEvent(context, MenuEditorVariables.oldestTagName, MenuEditorVariables.tagController.text.trim()));
                                                //     }
                                                //   }
                                                // }
                                                //

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


  List<Widget> _buildItemsList(String category, List<Map<String, dynamic>> itemsList, Set<String> selectedCategories, BuildContext menuContext,MenuLoadedState menuState) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);

    bool isFirstItemAnimated = false; // Variable to track whether animation applied to the first item

    if (selectedCategories.isNotEmpty && selectedCategories.contains(category)) {
      return itemsList.asMap().map((index, item) {
        Widget listItem;

        if (!isFirstItemAnimated && category == foodCategories.keys.first) {
          listItem = AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return SlideTransition(
                position: _animation,
                transformHitTests: true,
                child: Stack(
                  children: [
                    _buildDismissibleItem(item['disName'], color, item, category, menuContext,index,menuState),
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
          listItem = _buildDismissibleItem(item['disName'], color, item, category, menuContext,index,menuState);
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


  Widget _buildDismissibleItem(String item, Color color,Map<String, dynamic> item1,String category,BuildContext menuContext,int index,MenuLoadedState menuState) {
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
    return BlocBuilder<MenuBloc,MenuState>(
      builder: (BuildContext newMenucontext, state) {
        print("New Menu context for bloc");

        if(state is MenuLoadingState) {
          return Center(child: CircularProgressIndicator(),);
        }

        if(state is MenuLoadedState) {
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
                  if(MenuEditorVariables.tagFlag)
                  {
                    showDialog(
                        context: context, builder: (Builder) {
                      return AlertDialog(
                        title: Text("You have edited tag name do you want to save changes?",style: TextStyle(
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
                                    MenuEditorVariables.tagFlag = false;

                                    setState(() {
                                      MenuEditorVariables.selectedItem = item;
                                      selectedItem = MenuEditorVariables.selectedItem;
                                      MenuEditorVariables.selectItem = item1;
                                      MenuEditorVariables.itemIndex = index;

                                    });
                                    context.read<MenuBloc>().add(MenuItemSelectEvent(item1));

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
                                  MenuEditorFunction.saveChangesTag(context,menuContext,oldTagName,foodCategories);
                                },
                                child: Container(
                                  width: 100,
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
                  else if(MenuEditorVariables.displayNameFlag || MenuEditorVariables.propertyFlag || MenuEditorVariables.priceFlag || MenuEditorVariables.availabilityFlag)
                  {
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
                                    MenuEditorVariables.priceFlag = false;
                                    MenuEditorVariables.propertyFlag = false;
                                    MenuEditorVariables.displayNameFlag = false;
                                    MenuEditorVariables.availabilityFlag = false;

                                    setState(() {
                                      MenuEditorVariables.selectedItem = item;
                                      selectedItem = MenuEditorVariables.selectedItem;
                                      MenuEditorVariables.selectItem = item1;
                                      MenuEditorVariables.itemIndex = index;

                                    });
                                    context.read<MenuBloc>().add(MenuItemSelectEvent(item1));

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
                                  width: 100,
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
                  else{

                    setState(() {
                      MenuEditorVariables.selectedItem = item;
                      selectedItem = MenuEditorVariables.selectedItem;
                      MenuEditorVariables.selectItem = item1;
                      MenuEditorVariables.itemIndex = index;

                    });
                    menuContext.read<MenuBloc>().add(MenuItemSelectEvent(item1));
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
                    trailing: Transform.scale(
                      scaleY: 0.7,
                      scaleX: 0.7,
                      child: Switch(
                        value: item1['availability'],
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor:
                        GlobalVariables.textColor.withOpacity(0.6),
                        inactiveThumbImage: NetworkImage(
                            "https://wallpapercave.com/wp/wp7632851.jpg"),
                        onChanged: (bool value) {

                          if(MenuEditorVariables.tagFlag)
                          {
                            showDialog(
                                context: context, builder: (Builder) {
                              return AlertDialog(
                                title: Text("You have edited tag name do you want to save changes?",style: TextStyle(
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
                                            MenuEditorVariables.tagFlag = false;

                                            setState(() {
                                              MenuEditorVariables.selectedItem = item;
                                              selectedItem = MenuEditorVariables.selectedItem;
                                              MenuEditorVariables.selectItem = item1;
                                              MenuEditorVariables.itemIndex = index;

                                            });
                                            context.read<MenuBloc>().add(MenuItemSelectEvent(item1));

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
                                          MenuEditorFunction.saveChangesTag(context,menuContext,oldTagName,foodCategories);
                                        },
                                        child: Container(
                                          width: 100,
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
                          else if(MenuEditorVariables.displayNameFlag || MenuEditorVariables.propertyFlag || MenuEditorVariables.priceFlag || MenuEditorVariables.availabilityFlag)
                          {
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
                                            MenuEditorVariables.priceFlag = false;
                                            MenuEditorVariables.propertyFlag = false;
                                            MenuEditorVariables.displayNameFlag = false;
                                            MenuEditorVariables.availabilityFlag = false;

                                            setState(() {
                                              MenuEditorVariables.selectedItem = item;
                                              selectedItem = MenuEditorVariables.selectedItem;
                                              MenuEditorVariables.selectItem = item1;
                                              MenuEditorVariables.itemIndex = index;

                                            });
                                            context.read<MenuBloc>().add(MenuItemSelectEvent(item1));



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
                                          width: 100,
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
                          } else {
                            MenuEditorVariables.selectedItem = item;
                            selectedItem = MenuEditorVariables.selectedItem;
                            MenuEditorVariables.selectItem = item1;
                            MenuEditorVariables.itemIndex = index;
                            if(MenuEditorFunction.itemAvailability(context, menuContext, menuState)) {
                              setState(() {
                                item1['availability']=value;
                                updateSelectedItem(item);
                                newMenucontext.read<MenuBloc>().add(UpdateItemAvailability(context,item1['_id'], category, item1['disName'],value,item1,state.menuFoodCategory));
                              });
                              // if(state.menuItem['availability']) {
                              //   MenuEditorFunction.showFlushBarAvailabilitySync(context);
                              // } else {
                              //   MenuEditorFunction.showFlushBarAvailabilityDisableSync(context);
                              // }
                            }
                          }

                        },
                      ),
                    ),
                    leading: item1['category'] == 'VEG' ? Container(
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
                    )
                        : Container(
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => MenuEditorItemDetails2(itemName: item,)));

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
            content: Text(MenuEditorVariables.selectItem['availability'] ? 'Item will be deleted after 2 days from live menu \nDo you want to delete the item?' : 'Do you want to delete the item?',style: GlobalVariables.dataItemStyle),
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
