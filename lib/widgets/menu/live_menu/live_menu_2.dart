import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_event.dart';
import 'package:partner_admin_portal/bloc/menu/menu_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_event.dart';
import 'package:partner_admin_portal/bloc/menu/menu_state.dart';
import 'package:partner_admin_portal/bloc/menu_editor/menu_editor_bloc.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/search_bar.dart';
import 'package:partner_admin_portal/models/live_menu_model.dart';
import 'package:partner_admin_portal/repository/menu_services.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_mobile.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/count_table.dart';
import 'package:provider/provider.dart';
import '../../../bloc/live_menu/live_menu_bloc.dart';
import '../../../bloc/live_menu/live_menu_state.dart';
import '../../../bloc/manage_orders/order_bloc.dart';
import '../../../bloc/manage_orders/order_state.dart';
import '../../../bloc/menu_editor/menu_editor_event.dart';
import '../../../bloc/menu_editor/menu_editor_state.dart';
import '../../../bloc/orders/orders_bloc.dart';
import '../../../bloc/orders/orders_state.dart';
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

class LiveMenu2 extends StatefulWidget {
  final String searchQuery;
  const LiveMenu2({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<LiveMenu2> createState() => _LiveMenuState();
}

class _LiveMenuState extends State<LiveMenu2> with TickerProviderStateMixin {
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
    _menuController = TabController(length: 1, vsync: this);
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
    foodCategories.containsKey(widget.searchQuery.toLowerCase());
    final dateProvider = context.watch<DayProvider>();
    return  BlocProvider(
      create: (BuildContext context) => MenuBloc(
          MenuService()
      )..add(LoadMenuEvent(context)),
      child: BlocBuilder<MenuBloc,MenuState>(
        builder: (BuildContext menuContext, menuState) {
          if( menuState is MenuLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if( menuState is ErrorState) {
            return const Center(child: Text("Node server error"),);
          }
          if( menuState is MenuLoadedState){
            return LiveMenuWidget(menuState: menuState,menuContext: menuContext);
          }
          return Container();
        },
      ),

    );
  }

  Widget LiveMenuWidget({MenuLoadedState? menuState, required BuildContext menuContext}) {
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
            return ResponsiveBuilder(mobileBuilder: (BuildContext context,BoxConstraints constraints){
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
              return Container();
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

                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: Colors.white,
                                  child: DefaultTabController(
                                    length: 2,
                                    child: Scaffold(
                                      appBar:AppBar(
                                        toolbarHeight: 0,
                                        backgroundColor:GlobalVariables.primaryColor.withOpacity(0.2),
                                        bottom: PreferredSize(
                                          preferredSize: Size.fromHeight(50.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 400,
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
                                                    Tab(text: 'Live menu'),
                                                    Tab(text: 'Forecast'),
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
                                                    appBar: AppBar(
                                                      leading: Container(),
                                                      backgroundColor:Colors.grey.shade200,
                                                      title: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          GlobalFunction.buildSubscriptionForOrders(context,Subsciption.All, 'All'),
                                                          SizedBox(width: 15,),
                                                          GlobalFunction.buildSubscriptionForOrders(context,Subsciption.ForOrders, 'For Orders'),
                                                          SizedBox(width: 15,),
                                                          GlobalFunction.buildSubscriptionForOrders(context,Subsciption.Sub, 'Subscriptions'),
                                                          SizedBox(width: 15,),
                                                        ],
                                                      ),
                                                    ),
                                                    body: LiveMenuCount(),
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

                                          Column(
                                            children: [
                                              Container(
                                                height: 60,
                                                color: Colors.grey.shade100,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [




                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        GlobalFunction.buildSubscriptionForOrders(context,Subsciption.All, 'All'),
                                                        SizedBox(width: 15,),
                                                        GlobalFunction.buildSubscriptionForOrders(context,Subsciption.ForOrders, 'For Orders'),
                                                        SizedBox(width: 15,),
                                                        GlobalFunction.buildSubscriptionForOrders(context,Subsciption.Sub, 'Subscriptions'),
                                                        SizedBox(width: 15,),
                                                      ],
                                                    ),
                                                    SizedBox(width: 30,),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        GlobalFunction.buildOrderButton(context,Orders.All, 'All'),
                                                        SizedBox(width: 15,),
                                                        GlobalFunction.buildOrderButton(context,Orders.Pickup, 'Pick up'),
                                                        SizedBox(width: 15,),
                                                        GlobalFunction.buildOrderButton(context,Orders.All, 'Dine'),
                                                        SizedBox(width: 15,),
                                                        GlobalFunction.buildOrderButton(context,Orders.All, 'Deliver'),
                                                        SizedBox(width: 15,),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),
                                              Expanded(child: ItemDetailsTable(loaded: true,)),
                                            ],
                                          )

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

                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: Colors.white,
                                  child: DefaultTabController(
                                    length: 1,
                                    child: Scaffold(
                                      appBar:AppBar(
                                        toolbarHeight: 0,
                                        backgroundColor:GlobalVariables.primaryColor.withOpacity(0.2),
                                        bottom: PreferredSize(
                                          preferredSize: Size.fromHeight(50.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 200,
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
                                                    Tab(text: 'Live menu'),
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
                                              appBar: AppBar(
                                                leading: Container(),
                                                backgroundColor:Colors.grey.shade200,
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    GlobalFunction.buildSubscriptionForOrders(context,Subsciption.All, 'All'),
                                                    SizedBox(width: 15,),
                                                    GlobalFunction.buildSubscriptionForOrders(context,Subsciption.ForOrders, 'For Orders'),
                                                    SizedBox(width: 15,),
                                                    GlobalFunction.buildSubscriptionForOrders(context,Subsciption.Sub, 'Subscriptions'),
                                                    SizedBox(width: 15,),
                                                  ],
                                                ),
                                              ),
                                              body: LiveMenuCount(),
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
                              Container(
                                color: Colors.black26,
                                width: 1,
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

}




