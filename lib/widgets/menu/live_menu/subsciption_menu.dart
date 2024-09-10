import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_event.dart';
import 'package:partner_admin_portal/bloc/menu/menu_bloc.dart';
import 'package:partner_admin_portal/bloc/menu_editor/menu_editor_bloc.dart';
import 'package:partner_admin_portal/bloc/subscription_menu/subscription_menu_state.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/search_bar.dart';
import 'package:partner_admin_portal/models/live_menu_model.dart';
import 'package:partner_admin_portal/repository/menu_services.dart';
import 'package:partner_admin_portal/widgets/custom_button.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/SubscriptionMobile.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count2.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count_multi.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_mobile.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/subscription_menu_new.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/count_table.dart';
import 'package:provider/provider.dart';
import '../../../bloc/live_menu/live_menu_bloc.dart';
import '../../../bloc/live_menu/live_menu_state.dart';
import '../../../bloc/manage_orders/order_bloc.dart';
import '../../../bloc/manage_orders/order_state.dart';
import '../../../bloc/menu/menu_state.dart';
import '../../../bloc/menu_editor/menu_editor_event.dart';
import '../../../bloc/menu_editor/menu_editor_state.dart';
import '../../../bloc/orders/orders_bloc.dart';
import '../../../bloc/orders/orders_state.dart';
import '../../../bloc/subscription_menu/subscription_menu_bloc.dart';
import '../../../bloc/subscription_menu/subscription_menu_event.dart';
import '../../../constants/global_function.dart';
import '../../../constants/live_menu_constants/live_menu_functions.dart';
import '../../../constants/menu_editor_constants/menu_editor_functions.dart';
import '../../../constants/menu_editor_constants/menu_editor_variables.dart';
import '../../custom_textfield.dart';
import '../../../constants/global_variables.dart';
import '../../orders/forecast/item_details_table.dart';
import '../../orders/manage/manage_orderes.dart';
import '../../small_custom_textfield.dart';
import '../../../constants/utils.dart';
import '../../../provider/day_provider.dart';
import 'live_menu.dart';



enum MealBudget {All,Budget,Premium,Luxury}

class SubscriptionMenu extends StatefulWidget {
  const SubscriptionMenu({Key? key,}) : super(key: key);

  @override
  State<SubscriptionMenu> createState() => _LiveMenuState();
}

class _LiveMenuState extends State<SubscriptionMenu> with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _menuController;
  late TabController _liveMenuController;
  bool isCountBased = false;

  bool enabled = false;

  Map<String, List<Map<String,dynamic>>> foodCategories = { };

  Map<String, List<Map<String,dynamic>>> subscriptionFoodCategories = {
  };

  bool isLiveMenuSelected = true;

  Map<String, List<Map<String,dynamic>>> filteredFoodCategory = {};

  Set<String> selectedCategories = Set();

  Map<String, List<Map<String,dynamic>>> filteredSubscriptionCategory = {};

  bool switchValue = false;

  String selectedCategory = 'South indian breakfast';

  String selectedCategorySubscription = 'Pocket friendly';

  String selectedItem = 'Idli';

  String defaultItem = "";

  String hoverItem = '';

  MealTime selectedMealTime = MealTime.All;
  MealTime selectedMealTimeSubscription = MealTime.Breakfast;
  MealBudget selectedBudget = MealBudget.All;

  Map<String,bool> provider = {'Deliver' : false,'Dine in' : false, 'Pick up':false};

  Map<String,Map<String,bool>> meals = {
    'Breakfast' : {'S1':false,'S2':false,'S3':false},
    'Lunch' : {'S1':false,'S2':false,'S3':false},
    'Dinner' : {'S1':true,'S2':true,'S3':true},
  };


  Set<String> selectedSubscription = Set();

  MenuService menuService = MenuService();

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    initialValue();
    selectedSubscription.add('Pocket friendly');
    _tabController = TabController(length: 1, vsync: this);
    _menuController = TabController(length: 3, vsync: this);
    _liveMenuController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_menuController.index == 0) {
        setState(() {
          selectedCategory = 'South indian breakfast';
        });
      } else {
        setState(() {
          selectedCategorySubscription = 'Pocket friendly';
        });
      }
    });

    LiveMenuVariables.total.text = "0";
  }


  String query = "";

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    final dateProvider = context.watch<DayProvider>();
    return  BlocProvider(
      create: (BuildContext context) => SubscriptionMenuBloc(
          MenuService()
      )..add(LoadSubscriptionEvent(context)),
      child: BlocBuilder<SubscriptionMenuBloc,SubscriptionMenuState>(
        builder: (BuildContext menuContext, menuState) {
          if( menuState is SubscriptionMenuLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if( menuState is SubscriptionMenuErrorState) {
            return const Center(child: Text("Node server error"),);
          }
          if( menuState is SubscriptionMenuLoadedState){
            return LiveMenuWidget(menuState: menuState,menuContext: menuContext);
          }
          return Container();
        },
      ),

    );
  }

  Widget LiveMenuWidget({SubscriptionMenuLoadedState? menuState, required BuildContext menuContext}) {
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
                margin: EdgeInsets.only(left: 5),
                color: Colors.white,
                child: Column(
                  children: [
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
                    SizedBox(height: 5,),
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.white,
                        child: DefaultTabController(
                          length: 3,
                          child: Scaffold(
                            appBar:AppBar(
                              toolbarHeight: 0,
                              backgroundColor:Colors.grey.shade200,
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(50.0),
                                child: TabBar(
                                  isScrollable: false,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  labelPadding: EdgeInsets.symmetric(horizontal: 5),
                                  indicatorColor: Color(0xfffbb830),
                                  unselectedLabelColor: Colors.black54,
                                  labelColor: Color(0xFF363563),
                                  labelStyle: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF363563),
                                  ),
                                  tabs: [
                                    Tab(text: 'Breakfast'),
                                    Tab(text: 'Lunch'),
                                    Tab(text: 'Dinner'),
                                  ],
                                ),
                              ),
                            ),
                            body: TabBarView(
                              children: [
                                SubscriptionMenuNew(searchQuery: ''),
                                SubscriptionMenuNew(searchQuery: ''),
                                SubscriptionMenuNew(searchQuery: ''),
                              ],
                            ),
                            bottomNavigationBar: Container(
                              height: 70,
                              margin: EdgeInsets.only(left: 15*fem,right: 15*fem),
                              color: Colors.grey.shade50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [


                                  InkWell(
                                    onTap: (){
                                      setState(() {

                                      });
                                    },
                                    child: Container(
                                      width: 150*fem,
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

                                  InkWell(
                                    onTap: () {


                                    },
                                    child: Container(
                                      width: 150*fem,
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
              );
            },
                tabletBuilder: (BuildContext context,BoxConstraints constraints) {
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

                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: Colors.white,
                                  child: DefaultTabController(
                                    length: 3,
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
                                                  controller: _menuController,
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
                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                      body: TabBarView(
                                        controller: _menuController,
                                        children: [
                                          SubscriptionMenuNew(searchQuery: ''),
                                          SubscriptionMenuNew(searchQuery: ''),
                                          SubscriptionMenuNew(searchQuery: ''),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Container(
                              //   color: Colors.black26,
                              //   width: 1,
                              // ),
                              // Container(
                              //   color: Colors.black26,
                              //   width: 1,
                              // ),

                            ],
                          ),
                        ),


                      ],
                    ),


                  );
                },
                desktopBuilder: (BuildContext context,BoxConstraints constraints) {

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

                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: Colors.white,
                                  child: DefaultTabController(
                                    length: 3,
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
                                                  controller: _menuController,
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
                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                      body: TabBarView(
                                        controller: _menuController,
                                        children: [

                                          SubscriptionMenuNew(searchQuery: ''),
                                          SubscriptionMenuNew(searchQuery: ''),
                                          SubscriptionMenuNew(searchQuery: ''),


                                        ],
                                      ),
                                    ),
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

  Widget buildMealTimeButton(MealTime mealTime, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedMealTime == mealTime ? GlobalVariables.textColor : selectedMealTime == MealTime.All ? GlobalVariables.textColor : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMealTime = mealTime;
        });
      },
      child: Container(
        width: 70,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
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

  Widget buildMealTimeButtonSubscription(MealTime mealTime, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedMealTimeSubscription == mealTime ? GlobalVariables.textColor : selectedMealTimeSubscription == MealTime.All ? GlobalVariables.textColor : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMealTimeSubscription = mealTime;
        });
      },
      child: Container(
        width: 70,
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

  Widget buildMealTimeButton1(MealTime mealTime, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedMealTime == mealTime ? GlobalVariables.textColor : selectedMealTime == MealTime.All ? GlobalVariables.textColor : Colors.white;

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

  Widget buildBudgetButton(MealBudget mealBudget, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedBudget == mealBudget ? GlobalVariables.textColor : selectedBudget == MealBudget.All ? GlobalVariables.textColor : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBudget = mealBudget;
        });
      },
      child: Container(
        width: 70,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
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

  Widget buildBudgetButton1(MealBudget mealBudget, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedBudget == mealBudget ? GlobalVariables.textColor : selectedBudget == MealBudget.All ? GlobalVariables.textColor : Colors.white;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBudget = mealBudget;
        });
      },
      child: Container(
        width: 75*fem,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color:GlobalVariables.textColor),
          color: backgroundColor,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

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

  Widget session(String s,String meal,BuildContext context)
  {
    return InkWell(
      onTap: () {
        setState(() {
          meals[meal]![s] = !(meals[meal]?[s] ?? false);
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 5,right: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: GlobalVariables.primaryColor),
            color: meals[meal]?[s] == true ? Colors.amber : Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(s,style: SafeGoogleFont(
              'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color:GlobalVariables.textColor,
            ),),
          ),
        ),
      ),
    );
  }

  bool allMeal(String meal)
  {
    return meals[meal]?.values.every((value) => value == true) ?? false;
  }

  void setMeal(String meal,bool val,)
  {
    setState(() {
      meals[meal]?.forEach((key, _) {
        meals[meal]![key] = !val;
      });
    });
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
                    width: 50*fem,
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
                  SizedBox(width: 10*fem,),
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

  void initialValue(){
    setState(() {
      LiveMenuVariables.total.text = '0';
      LiveMenuVariables.breakfastTotal.text = '0';
      LiveMenuVariables.lunchTotal.text = '0';
      LiveMenuVariables.dinnerTotal.text = '0';

      LiveMenuVariables.bfSession1Controller.text = '0';
      LiveMenuVariables.bfSession2Controller.text = '0';
      LiveMenuVariables.bfSession3Controller.text = '0';
      LiveMenuVariables.bfSession4Controller.text = '0';

      LiveMenuVariables.lnSession1Controller.text = '0';
      LiveMenuVariables.lnSession2Controller.text = '0';
      LiveMenuVariables.lnSession3Controller.text = '0';
      LiveMenuVariables.lnSession4Controller.text = '0';

      LiveMenuVariables.dnSession1Controller.text = '0';
      LiveMenuVariables.dnSession2Controller.text = '0';
      LiveMenuVariables.dnSession3Controller.text = '0';
      LiveMenuVariables.dnSession4Controller.text = '0';
    });
  }

}




