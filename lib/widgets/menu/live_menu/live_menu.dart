import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_event.dart';
import 'package:partner_admin_portal/bloc/menu/menu_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_event.dart';
import 'package:partner_admin_portal/bloc/menu/menu_state.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/models/live_menu_model.dart';
import 'package:partner_admin_portal/repository/menu_services.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_mobile.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/count_table.dart';
import 'package:provider/provider.dart';
import '../../../bloc/live_menu/live_menu_bloc.dart';
import '../../../bloc/live_menu/live_menu_state.dart';
import '../../../bloc/manage_orders/order_bloc.dart';
import '../../../bloc/manage_orders/order_state.dart';
import '../../../bloc/orders/orders_bloc.dart';
import '../../../bloc/orders/orders_state.dart';
import '../../../constants/global_function.dart';
import '../../../constants/live_menu_constants/live_menu_functions.dart';
import '../../custom_textfield.dart';
import '../../../constants/global_variables.dart';
import '../../orders/forecast/item_details_table.dart';
import '../../orders/manage/manage_orderes.dart';
import '../../small_custom_textfield.dart';
import '../../../constants/utils.dart';
import '../../../provider/day_provider.dart';

enum MealTime {All,Breakfast,Lunch,Dinner}

enum MealBudget {All,Budget,Premium,Luxury}

class LiveMenu extends StatefulWidget {
  final String searchQuery;
  const LiveMenu({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<LiveMenu> createState() => _LiveMenuState();
}

class _LiveMenuState extends State<LiveMenu> with TickerProviderStateMixin {
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
    _menuController = TabController(length: 2, vsync: this);
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
        builder: (context, state) {
          if(state is MenuLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(state is ErrorState) {
            return const Center(child: Text("Node server error"),);
          }
          if(state is MenuLoadedState){
            // List<LiveMenuModel> menuList = state.menus;
            foodCategories = state.menuFoodCategory;
            print("Food cateogeries in live menu ${foodCategories}");

            LiveMenuVariables.total.text = state.item['totalCount'].toString();
            LiveMenuVariables.breakfastTotal.text = state.item['breakfastCount'].toString();
            LiveMenuVariables.lunchTotal.text = state.item['lunchCount'].toString();
            LiveMenuVariables.dinnerTotal.text = state.item['dinnerCount'].toString();
            LiveMenuVariables.bfSession1Controller.text = state.item['breakfastSession1Count'].toString();
            LiveMenuVariables.bfSession2Controller.text = state.item['breakfastSession2Count'].toString();
            LiveMenuVariables.bfSession3Controller.text = state.item['breakfastSession3Count'].toString();
            LiveMenuVariables.bfSession4Controller.text = state.item['breakfastSession4Count'].toString();
            LiveMenuVariables.lnSession1Controller.text = state.item['lunchSession1Count'].toString();
            LiveMenuVariables.lnSession2Controller.text = state.item['lunchSession2Count'].toString();
            LiveMenuVariables.lnSession3Controller.text = state.item['lunchSession3Count'].toString();
            LiveMenuVariables.lnSession4Controller.text = state.item['lunchSession4Count'].toString();
            LiveMenuVariables.dnSession1Controller.text = state.item['dinnerSession1Count'].toString();
            LiveMenuVariables.dnSession2Controller.text = state.item['dinnerSession2Count'].toString();
            LiveMenuVariables.dnSession3Controller.text = state.item['dinnerSession3Count'].toString();
            LiveMenuVariables.dnSession4Controller.text = state.item['dinnerSession4Count'].toString();
            return  BlocBuilder<OrderBloc,OrderState>(builder: (BuildContext context, orderState) {
              return ResponsiveBuilder(
                  mobileBuilder: (BuildContext context,BoxConstraints constraints){
                    return  LiveMenuMobile(selectedCategories:  LiveMenuVariables.selectedCategories,);
                  },
                  tabletBuilder: (BuildContext context,BoxConstraints constraints)
                  {
                    query = widget.searchQuery;
                    if (query != "") {
                      filteredFoodCategory = {}; // Reset filteredFoodCategory outside the loop

                      foodCategories.forEach((cuisine, items) {
                        List<Map<String, dynamic>> matchingItems = items
                            .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
                            .toList();

                        if (matchingItems.isNotEmpty) {
                          LiveMenuVariables.selectedCategories.add(cuisine);
                          // selectedItem = query;

                          // Add the matching items to filteredFoodCategory
                          filteredFoodCategory[cuisine] = matchingItems;
                        }
                      });
                    }
                    else{
                      filteredFoodCategory = {};

                    }

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
                      // selectedSubscription = {};
                      // selectedSubscription.add('Pocket friendly');
                    }
                    return Container();
                  },

                  desktopBuilder: (BuildContext context,BoxConstraints constraints){
                    query = widget.searchQuery;
                    if (query != "") {
                      filteredFoodCategory = {}; // Reset filteredFoodCategory outside the loop

                      foodCategories.forEach((cuisine, items) {
                        List<Map<String, dynamic>> matchingItems = items
                            .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
                            .toList();

                        if (matchingItems.isNotEmpty) {
                          LiveMenuVariables.selectedCategories.add(cuisine);
                          // selectedItem = query;

                          // Add the matching items to filteredFoodCategory
                          filteredFoodCategory[cuisine] = matchingItems;
                        }
                      });
                    }
                    else{
                      filteredFoodCategory = {};

                    }

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

                    }

                    print("Food cateogeries in live menu ${LiveMenuFunctions.selectedMealTime}");

                    if(GlobalFunction.selectedMealTime == MealTime.Breakfast) {
                      print("Food cateogeries in live menu ${LiveMenuFunctions.selectedMealTime}");
                      foodCategories.forEach((cuisine, items) {
                        List<Map<String, dynamic>> matchingItems = items
                            .where((item) => item['friBreakfastSession1'] == true)
                            .toList();

                        if (matchingItems.isNotEmpty) {
                          LiveMenuVariables.selectedCategories.add(cuisine);
                          // selectedItem = query;

                          // Add the matching items to filteredFoodCategory
                          filteredFoodCategory[cuisine] = matchingItems;
                        }
                      });
                    } else if(GlobalFunction.selectedMealTime == MealTime.Lunch) {
                      print("Food cateogeries in live menu ${LiveMenuFunctions.selectedMealTime}");
                      foodCategories.forEach((cuisine, items) {
                        List<Map<String, dynamic>> matchingItems = items
                            .where((item) => item['friLunchSession1'] == true)
                            .toList();

                        if (matchingItems.isNotEmpty) {
                          LiveMenuVariables.selectedCategories.add(cuisine);
                          // selectedItem = query;

                          // Add the matching items to filteredFoodCategory
                          filteredFoodCategory[cuisine] = matchingItems;
                        }
                      });
                    } else  
                    return BlocBuilder<LiveMenuBloc,LiveMenuState>(builder: (BuildContext context, Lstate) {
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
                                  child: DefaultTabController(
                                    length: 2,
                                    child: Scaffold(
                                      appBar:AppBar(
                                        toolbarHeight: 0,backgroundColor:GlobalVariables.primaryColor.withOpacity(0.2),
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
                                                    Tab(text: 'Orders'),
                                                    Tab(text: 'Subscription'),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(right: 15),
                                                height: 40,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(25),
                                                  border: Border.all(color: GlobalVariables.textColor.withOpacity(0.5)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          isLiveMenuSelected = true;
                                                        });
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(

                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        width: 98,
                                                        child: Center(
                                                          child: Text(
                                                            "Live menu",
                                                            style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              color: isLiveMenuSelected
                                                                  ? GlobalVariables.textColor
                                                                  : GlobalVariables.textColor.withOpacity(0.5),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: GlobalVariables.textColor.withOpacity(0.5),
                                                      width: 2,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          isLiveMenuSelected = false;
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 98,
                                                        child: Center(
                                                          child: Text(
                                                            "Forecast",
                                                            style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              color: !isLiveMenuSelected
                                                                  ? GlobalVariables.textColor
                                                                  : GlobalVariables.textColor.withOpacity(0.5),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      body: TabBarView(
                                        controller: _menuController,
                                        children: [
                                          isLiveMenuSelected == true ? Row(
                                            children: [
                                              Container(
                                                width:450,
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 10,),
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
                                                    SizedBox(height: 15,),

                                                    SizedBox(height: 0,),
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

                                                          bool categoryContainsMatch = items.any((item) => item.toLowerCase().contains(widget.searchQuery.toLowerCase()));

                                                          return ReorderableDragStartListener(
                                                            enabled: true,
                                                            key: Key(category),
                                                            index: index,
                                                            child: InkWell(
                                                              onTap: () {
                                                                context.read<LiveMenuBloc>().add(SelectCategoryEvent(Lstate.selectedCategories, category));
                                                              },
                                                              child: Column(
                                                                key: Key('$category'),
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                                                    color:  Lstate.selectedCategories.contains(category)
                                                                        ? Color(0xFF363563)
                                                                        : null,
                                                                    child: ListTile(
                                                                      title: Text(
                                                                        category,
                                                                        style: TextStyle(
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.bold,
                                                                          color:  Lstate.selectedCategories.contains(category)
                                                                              ? Colors.white
                                                                              : Colors.black,
                                                                        ),
                                                                      ),
                                                                      leading: Icon(
                                                                        Icons.grid_view_rounded,
                                                                        size: 10,
                                                                        color:  Lstate.selectedCategories.contains(category)
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
                                                                    visible:  Lstate.selectedCategories.contains(category),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: _buildItemsList(category, itemsList,Lstate.selectedCategories),
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
                                              Expanded(
                                                flex: 5,
                                                child: TabBarView(
                                                  controller:_menuController,
                                                  children: [
                                                    DefaultTabController(
                                                      length: 1, // Number of tabs
                                                      child: selectedItem == '' ? Container()  :
                                                      Scaffold(
                                                        appBar: AppBar(
                                                          toolbarHeight: 0,backgroundColor:Colors.grey.shade200,
                                                          bottom: PreferredSize(

                                                            preferredSize: Size.fromHeight(50),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width:100,
                                                                  child: TabBar(
                                                                    controller: _tabController,
                                                                    isScrollable: false,
                                                                    labelPadding: EdgeInsets.symmetric(horizontal: 5),
                                                                    indicatorWeight: 1, // Adjust the indicator weight
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
                                                                      Tab(text: "Live menu",)

                                                                    ],
                                                                    onTap: (index) {
                                                                      dateProvider.updateSelectedDay('${DateFormat('E').format(DateTime.now().add(Duration(days: index)))} : ${DateFormat('dd MMM').format(DateTime.now().add(Duration(days: index)))}');
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        body: TabBarView(
                                                          controller: _tabController,
                                                          physics: NeverScrollableScrollPhysics(),
                                                          children: [
                                                            // Content for Tab 1
                                                            // Content for Tab 1

                                                            Row(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets.all(20),
                                                                  child: Column(
                                                                    children: [

                                                                      Visibility(
                                                                        visible: isCountBased,
                                                                        child: Column(
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Checkbox(value:allMeal('Breakfast'), onChanged: (val){
                                                                                      setMeal('Breakfast', allMeal('Breakfast'));
                                                                                    }),
                                                                                    SizedBox(width: 10,),
                                                                                    Text("Breakfast : ",style:  SafeGoogleFont(
                                                                                      'Poppins',
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color:GlobalVariables.textColor,
                                                                                    ),),
                                                                                    SizedBox(width: 10,),
                                                                                    Row(
                                                                                      children: [
                                                                                        session("S1","Breakfast",context),
                                                                                        session("S2","Breakfast",context),
                                                                                        session("S3","Breakfast",context)
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                SizedBox(width:25),
                                                                                Row(
                                                                                  children: [
                                                                                    Checkbox(value: allMeal('Lunch'), onChanged: (val){
                                                                                      setMeal("Lunch", allMeal("Lunch"));
                                                                                    }),
                                                                                    SizedBox(width: 10,),
                                                                                    Text("Lunch : ",style:  SafeGoogleFont(
                                                                                      'Poppins',
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color:GlobalVariables.textColor,
                                                                                    ),),
                                                                                    SizedBox(width: 10,),
                                                                                    Row(
                                                                                      children: [
                                                                                        session("S1","Lunch",context),
                                                                                        session("S2","Lunch",context),
                                                                                        session("S3","Lunch",context)
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                SizedBox(width:25),
                                                                                Row(
                                                                                  children: [
                                                                                    Checkbox(value: allMeal('Dinner'), onChanged: (val){
                                                                                      setMeal("Dinner", allMeal('Dinner'));
                                                                                    }),
                                                                                    SizedBox(width: 10,),
                                                                                    Text("Dinner : ",style:  SafeGoogleFont(
                                                                                      'Poppins',
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color:GlobalVariables.textColor,
                                                                                    ),),
                                                                                    SizedBox(width: 10,),
                                                                                    Row(
                                                                                      children: [
                                                                                        session("S1","Dinner",context),
                                                                                        session("S2","Dinner",context),
                                                                                        session("S3","Dinner",context)
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 20,),

                                                                            Row(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Checkbox(value: provider['Deliver'], onChanged: (val){
                                                                                      setState(() {
                                                                                        provider['Deliver'] = val!;
                                                                                      });

                                                                                    }),
                                                                                    SizedBox(width: 10,),
                                                                                    Text("Deliver",style: SafeGoogleFont(
                                                                                      'Poppins',
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color:GlobalVariables.textColor,
                                                                                    ),)
                                                                                  ],
                                                                                ),
                                                                                SizedBox(width: 30,),
                                                                                Row(
                                                                                  children: [
                                                                                    Checkbox(value: provider['Dine in'], onChanged: (val){
                                                                                      setState(() {
                                                                                        provider['Dine in'] = val!;
                                                                                      });

                                                                                    }),
                                                                                    SizedBox(width: 10,),
                                                                                    Text("Dine in",style: SafeGoogleFont(
                                                                                      'Poppins',
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color:GlobalVariables.textColor,
                                                                                    ),)
                                                                                  ],
                                                                                ),
                                                                                SizedBox(width: 30,),
                                                                                Row(
                                                                                  children: [
                                                                                    Checkbox(value: provider['Pick up'], onChanged: (val){
                                                                                      setState(() {
                                                                                        provider['Pick up'] = val!;
                                                                                      });

                                                                                    }),
                                                                                    SizedBox(width: 10,),
                                                                                    Text("Pick up",style: SafeGoogleFont(
                                                                                      'Poppins',
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color:GlobalVariables.textColor,
                                                                                    ),)
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),

                                                                            SizedBox(height: 50,),

                                                                          ],
                                                                        ),
                                                                      ),

                                                                      Visibility(
                                                                        visible: !isCountBased,
                                                                        child: Container(
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [

                                                                                      Text("Total : ",style: SafeGoogleFont(
                                                                                        'Poppins',
                                                                                        fontSize: 15,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color:GlobalVariables.textColor,
                                                                                      ),),
                                                                                      SizedBox(width:20),
                                                                                      Container(
                                                                                        width:70,
                                                                                        height: 40,
                                                                                        child: SmallCustomTextField(
                                                                                          textEditingController: LiveMenuVariables.total,height: 30,
                                                                                          onChanged: (text){

                                                                                            int reminder = (int.parse(text!)) % 3;
                                                                                            LiveMenuVariables.breakfastTotal.text = (int.parse(text)/3).toInt().toString();
                                                                                            LiveMenuVariables.lunchTotal.text = (int.parse(text)/3).toInt().toString();
                                                                                            LiveMenuVariables.dinnerTotal.text = ((int.parse(text)/3).toInt()+ reminder).toString();
                                                                                            int reminderBreakfast = (int.parse(LiveMenuVariables.breakfastTotal.text)) % 4;
                                                                                            LiveMenuVariables.bfSession1Controller.text = (int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt().toString();
                                                                                            LiveMenuVariables.bfSession2Controller.text = (int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt().toString();
                                                                                            LiveMenuVariables.bfSession3Controller.text = (int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt().toString();
                                                                                            LiveMenuVariables.bfSession4Controller.text = ((int.parse(LiveMenuVariables.breakfastTotal.text)/4).toInt()+ reminderBreakfast).toString();

                                                                                            int reminderLunch = (int.parse(LiveMenuVariables.lunchTotal.text)) % 4;
                                                                                            LiveMenuVariables.lnSession1Controller.text = (int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt().toString();
                                                                                            LiveMenuVariables.lnSession2Controller.text = (int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt().toString();
                                                                                            LiveMenuVariables.lnSession3Controller.text = (int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt().toString();
                                                                                            LiveMenuVariables.lnSession4Controller.text = ((int.parse(LiveMenuVariables.lunchTotal.text)/4).toInt()+ reminderLunch).toString();

                                                                                            int reminderDinner = (int.parse(LiveMenuVariables.dinnerTotal.text)) % 4;
                                                                                            LiveMenuVariables.dnSession1Controller.text = (int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt().toString();
                                                                                            LiveMenuVariables.dnSession2Controller.text = (int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt().toString();
                                                                                            LiveMenuVariables.dnSession3Controller.text = (int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt().toString();
                                                                                            LiveMenuVariables.dnSession4Controller.text = ((int.parse(LiveMenuVariables.dinnerTotal.text)/4).toInt()+ reminderDinner).toString();
                                                                                            if(int.parse(LiveMenuVariables.total.text) > 9999)
                                                                                            {
                                                                                              _showExceedLimitAlertDialog(context);
                                                                                            }
                                                                                          }, min: 10,max:9999
                                                                                          ,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(width:10),

                                                                                      InkWell(
                                                                                        onTap:(){
                                                                                          initialValue();
                                                                                        },
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(10.0),
                                                                                          child: Icon(Icons.refresh,size: 22,color: GlobalVariables.textColor,),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),

                                                                                  SizedBox(height:30),

                                                                                  SingleChildScrollView(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        DataTable(
                                                                                          columnSpacing: 50,
                                                                                          headingRowHeight: 80,
                                                                                          columns:<DataColumn> [
                                                                                            DataColumn(label: Row(
                                                                                              children: [
                                                                                                Text(" ",style:SafeGoogleFont(
                                                                                                  'Poppins',
                                                                                                  fontSize: 12,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color:GlobalVariables.textColor,
                                                                                                ),),
                                                                                              ],
                                                                                            )),
                                                                                            DataColumn(label: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Text("Breakfast",style: SafeGoogleFont(
                                                                                                  'Poppins',
                                                                                                  fontSize: 11,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color:GlobalVariables.textColor,
                                                                                                ),),
                                                                                                SizedBox(height: 10,),
                                                                                                Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                    textEditingController: LiveMenuVariables.breakfastTotal,height: 30,fontSize: 11,
                                                                                                    min: 0,max:9999,
                                                                                                    onChanged: (text){

                                                                                                      LiveMenuVariables.total.text = (int.parse(text!) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                                                                      int reminderBreakfast = (int.parse(text!)) % 4;
                                                                                                      LiveMenuVariables.bfSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                                                                                      LiveMenuVariables.bfSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                                                                                      LiveMenuVariables.bfSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                                                                                      LiveMenuVariables.bfSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderBreakfast).toString();
                                                                                                      if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                                                                      {
                                                                                                        _showExceedLimitAlertDialog(context);
                                                                                                      }
                                                                                                    },
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            )),
                                                                                            DataColumn(label: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Text("Lunch",style: SafeGoogleFont(
                                                                                                  'Poppins',
                                                                                                  fontSize: 11,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color:GlobalVariables.textColor,
                                                                                                ),),
                                                                                                SizedBox(height: 10,),
                                                                                                Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                    textEditingController: LiveMenuVariables.lunchTotal,height: 30,fontSize: 11,min: 0,max:9999,
                                                                                                    onChanged: (text){

                                                                                                      LiveMenuVariables.total.text = (int.parse(text!) + int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                                                                      int reminderLunch = (int.parse(text)) % 4;
                                                                                                      LiveMenuVariables.lnSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                                                                                      LiveMenuVariables.lnSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                                                                                      LiveMenuVariables.lnSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                                                                                      LiveMenuVariables.lnSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderLunch).toString();

                                                                                                      if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                                                                      {
                                                                                                        _showExceedLimitAlertDialog(context);
                                                                                                      }
                                                                                                    },
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            )),
                                                                                            DataColumn(label: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                                              children: [
                                                                                                Text("Dinner",style: SafeGoogleFont(
                                                                                                  'Poppins',
                                                                                                  fontSize: 11,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color:GlobalVariables.textColor,
                                                                                                ),),
                                                                                                SizedBox(height: 10,),
                                                                                                Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                    textEditingController: LiveMenuVariables.dinnerTotal,height: 30,fontSize: 11,min: 0,max:9999,
                                                                                                    onChanged: (text){

                                                                                                      LiveMenuVariables.total.text = (int.parse(text!) + int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text)).toString();
                                                                                                      int reminderDinner = (int.parse(text)) % 4;
                                                                                                      LiveMenuVariables.dnSession1Controller.text = (int.parse(text)/4).toInt().toString();
                                                                                                      LiveMenuVariables.dnSession2Controller.text = (int.parse(text)/4).toInt().toString();
                                                                                                      LiveMenuVariables.dnSession3Controller.text = (int.parse(text)/4).toInt().toString();
                                                                                                      LiveMenuVariables.dnSession4Controller.text = ((int.parse(text)/4).toInt()+ reminderDinner).toString();
                                                                                                      if(int.parse(LiveMenuVariables.total.text) >= 1000)
                                                                                                      {
                                                                                                        _showExceedLimitAlertDialog(context);
                                                                                                      }
                                                                                                    },
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ), )
                                                                                          ],
                                                                                          rows: <DataRow> [
                                                                                            DataRow(cells: <DataCell> [
                                                                                              DataCell(Center(
                                                                                                child: Text("S1 : ",style: SafeGoogleFont(
                                                                                                  'Poppins',
                                                                                                  fontSize: 12,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color:GlobalVariables.textColor,
                                                                                                ),),
                                                                                              ),),
                                                                                              DataCell(Center(
                                                                                                child: Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                      textEditingController: LiveMenuVariables.bfSession1Controller,height: 30,fontSize: 11,
                                                                                                      min: 0,max:9999,
                                                                                                      onChanged:(text){

                                                                                                        LiveMenuVariables.breakfastTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.bfSession2Controller.text) + int.parse(LiveMenuVariables.bfSession3Controller.text) + int.parse(LiveMenuVariables.bfSession4Controller.text) ).toString();
                                                                                                        LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                                                                        if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                                                                        {
                                                                                                          _showExceedLimitAlertDialog(context);
                                                                                                        }
                                                                                                      }
                                                                                                  ),
                                                                                                ),
                                                                                              )),
                                                                                              DataCell(Center(
                                                                                                child: Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                      textEditingController: LiveMenuVariables.lnSession1Controller,height: 30,fontSize: 11,
                                                                                                      min: 0,max:9999,
                                                                                                      onChanged:(text){

                                                                                                        LiveMenuVariables.lunchTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.lnSession2Controller.text) + int.parse(LiveMenuVariables.lnSession3Controller.text) + int.parse(LiveMenuVariables.lnSession4Controller.text) ).toString();
                                                                                                        LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                                                                        if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                                                                        {
                                                                                                          _showExceedLimitAlertDialog(context);
                                                                                                        }
                                                                                                      }
                                                                                                  ),
                                                                                                ),
                                                                                              ),),
                                                                                              DataCell(Center(
                                                                                                child: Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                      textEditingController: LiveMenuVariables.dnSession1Controller,height: 30,fontSize: 11,
                                                                                                      min: 0,max:9999,
                                                                                                      onChanged:(text){

                                                                                                        LiveMenuVariables.dinnerTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.dnSession2Controller.text) + int.parse(LiveMenuVariables.dnSession3Controller.text) + int.parse(LiveMenuVariables.dnSession4Controller.text) ).toString();
                                                                                                        LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                                                                        if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                                                                        {
                                                                                                          _showExceedLimitAlertDialog(context);
                                                                                                        }
                                                                                                      }

                                                                                                  ),
                                                                                                ),
                                                                                              ),)
                                                                                            ]),
                                                                                            DataRow(cells: <DataCell> [
                                                                                              DataCell(Center(
                                                                                                child: Text("S2 : ",style: SafeGoogleFont(
                                                                                                  'Poppins',
                                                                                                  fontSize: 12,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color:GlobalVariables.textColor,
                                                                                                ),),
                                                                                              ),),
                                                                                              DataCell(Center(
                                                                                                child: Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                      textEditingController: LiveMenuVariables.bfSession2Controller,height: 30,fontSize: 11,
                                                                                                      min: 0,max:9999,
                                                                                                      onChanged:(text){
                                                                                                        LiveMenuVariables.breakfastTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.bfSession1Controller.text) + int.parse(LiveMenuVariables.bfSession3Controller.text) + int.parse(LiveMenuVariables.bfSession4Controller.text) ).toString();
                                                                                                        LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                                                                        if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                                                                        {
                                                                                                          _showExceedLimitAlertDialog(context);
                                                                                                        }
                                                                                                      }
                                                                                                  ),
                                                                                                ),
                                                                                              )),
                                                                                              DataCell(Center(
                                                                                                child: Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                      textEditingController: LiveMenuVariables.lnSession2Controller,height: 30,fontSize: 11,
                                                                                                      min: 0,max:9999,
                                                                                                      onChanged:(text){
                                                                                                        LiveMenuVariables.lunchTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.lnSession1Controller.text) + int.parse(LiveMenuVariables.lnSession3Controller.text) + int.parse(LiveMenuVariables.lnSession4Controller.text) ).toString();
                                                                                                        LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                                                                        if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                                                                        {
                                                                                                          _showExceedLimitAlertDialog(context);
                                                                                                        }
                                                                                                      }
                                                                                                  ),
                                                                                                ),
                                                                                              ),),
                                                                                              DataCell(Center(
                                                                                                child: Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                      textEditingController: LiveMenuVariables.dnSession2Controller,height: 30,fontSize: 11,
                                                                                                      min: 0,max:9999,
                                                                                                      onChanged:(text){
                                                                                                        LiveMenuVariables.dinnerTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.dnSession4Controller.text) + int.parse(LiveMenuVariables.dnSession3Controller.text) + int.parse(LiveMenuVariables.dnSession1Controller.text) ).toString();
                                                                                                        LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                                                                        if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                                                                        {
                                                                                                          _showExceedLimitAlertDialog(context);
                                                                                                        }
                                                                                                      }
                                                                                                  ),
                                                                                                ),
                                                                                              ),)
                                                                                            ]),
                                                                                            DataRow(cells: <DataCell> [
                                                                                              DataCell(Center(
                                                                                                child: Text("S3 : ",style: SafeGoogleFont(
                                                                                                  'Poppins',
                                                                                                  fontSize: 12,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color:GlobalVariables.textColor,
                                                                                                ),),
                                                                                              ),),
                                                                                              DataCell(Center(
                                                                                                child: Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                      textEditingController: LiveMenuVariables.bfSession3Controller,height: 30,fontSize: 11,
                                                                                                      min: 0,max:9999,
                                                                                                      onChanged:(text){

                                                                                                        LiveMenuVariables.breakfastTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.bfSession2Controller.text) + int.parse(LiveMenuVariables.bfSession1Controller.text) + int.parse(LiveMenuVariables.bfSession4Controller.text) ).toString();
                                                                                                        LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                                                                        if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                                                                        {
                                                                                                          _showExceedLimitAlertDialog(context);
                                                                                                        }
                                                                                                      }
                                                                                                  ),
                                                                                                ),
                                                                                              )),
                                                                                              DataCell(Center(
                                                                                                child: Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                      textEditingController: LiveMenuVariables.lnSession3Controller,height: 30,fontSize: 11,
                                                                                                      min: 0,max:9999,
                                                                                                      onChanged:(text){
                                                                                                        LiveMenuVariables.lunchTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.lnSession2Controller.text) + int.parse(LiveMenuVariables.lnSession1Controller.text) + int.parse(LiveMenuVariables.lnSession4Controller.text) ).toString();
                                                                                                        LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                                                                        if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                                                                        {
                                                                                                          _showExceedLimitAlertDialog(context);
                                                                                                        }
                                                                                                      }
                                                                                                  ),
                                                                                                ),
                                                                                              ),),
                                                                                              DataCell(Center(
                                                                                                child: Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                      textEditingController: LiveMenuVariables.dnSession3Controller,height: 30,fontSize: 11,
                                                                                                      min: 0,max:9999,
                                                                                                      onChanged:(text){
                                                                                                        LiveMenuVariables.dinnerTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.dnSession2Controller.text) + int.parse(LiveMenuVariables.dnSession4Controller.text) + int.parse(LiveMenuVariables.dnSession1Controller.text) ).toString();
                                                                                                        LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                                                                        if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                                                                        {
                                                                                                          _showExceedLimitAlertDialog(context);
                                                                                                        }
                                                                                                      }
                                                                                                  ),
                                                                                                ),
                                                                                              ),),
                                                                                            ]),
                                                                                            DataRow(cells: <DataCell> [
                                                                                              DataCell(Center(
                                                                                                child: Text("S4 : ",style: SafeGoogleFont(
                                                                                                  'Poppins',
                                                                                                  fontSize: 12,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color:GlobalVariables.textColor,
                                                                                                ),),
                                                                                              ),),
                                                                                              DataCell(Center(
                                                                                                child: Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                      textEditingController: LiveMenuVariables.bfSession4Controller,height: 30,fontSize: 11,
                                                                                                      min: 0,max:9999,
                                                                                                      onChanged:(text){
                                                                                                        LiveMenuVariables.breakfastTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.bfSession2Controller.text) + int.parse(LiveMenuVariables.bfSession3Controller.text) + int.parse(LiveMenuVariables.bfSession1Controller.text) ).toString();
                                                                                                        LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                                                                        if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                                                                        {
                                                                                                          _showExceedLimitAlertDialog(context);
                                                                                                        }
                                                                                                      }
                                                                                                  ),
                                                                                                ),
                                                                                              )),
                                                                                              DataCell(Center(
                                                                                                child: Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                      textEditingController: LiveMenuVariables.lnSession4Controller,height: 30,fontSize: 11,
                                                                                                      min: 0,max:9999,
                                                                                                      onChanged:(text){

                                                                                                        LiveMenuVariables.lunchTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.lnSession2Controller.text) + int.parse(LiveMenuVariables.lnSession3Controller.text) + int.parse(LiveMenuVariables.lnSession1Controller.text) ).toString();
                                                                                                        LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                                                                        if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                                                                        {
                                                                                                          _showExceedLimitAlertDialog(context);
                                                                                                        }
                                                                                                      }
                                                                                                  ),
                                                                                                ),
                                                                                              ),),
                                                                                              DataCell(Center(
                                                                                                child: Container(
                                                                                                  width:70,
                                                                                                  height: 40,
                                                                                                  child: SmallCustomTextField(
                                                                                                      textEditingController: LiveMenuVariables.dnSession4Controller,height: 30,fontSize: 11,
                                                                                                      min: 0,max:9999,
                                                                                                      onChanged:(text){

                                                                                                        LiveMenuVariables.dinnerTotal.text = (int.parse(text!) + int.parse(LiveMenuVariables.dnSession2Controller.text) + int.parse(LiveMenuVariables.dnSession3Controller.text) + int.parse(LiveMenuVariables.dnSession1Controller.text) ).toString();
                                                                                                        LiveMenuVariables.total.text = (int.parse(LiveMenuVariables.breakfastTotal.text) + int.parse(LiveMenuVariables.lunchTotal.text) + int.parse(LiveMenuVariables.dinnerTotal.text)).toString();
                                                                                                        if(int.parse(LiveMenuVariables.total.text) >= 10000)
                                                                                                        {
                                                                                                          _showExceedLimitAlertDialog(context);
                                                                                                        }
                                                                                                      }
                                                                                                  ),
                                                                                                ),
                                                                                              ),)
                                                                                            ])
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),

                                                                                ],
                                                                              ),

                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            // Content for Tab 2
                                                          ],
                                                        ),
                                                        bottomNavigationBar: Padding(
                                                          padding:  EdgeInsets.only(right: 16.0,left: 50*fem),
                                                          child: BottomNavigationBar(
                                                            elevation: 0,
                                                            type: BottomNavigationBarType.fixed,
                                                            items: [

                                                              BottomNavigationBarItem(
                                                                icon: InkWell(
                                                                  onTap:(){
                                                                    initialValue();
                                                                  },
                                                                  child: Container(
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
                                                                ),
                                                                label: '',
                                                              ),

                                                              BottomNavigationBarItem(
                                                                icon: InkWell(
                                                                  onTap:(){
                                                                    print("id is ${state.item['_id']}");

                                                                    Map<String, dynamic> requestBody = {
                                                                      "totalCount":int.parse(LiveMenuVariables.total.text),
                                                                      "fp_unit_sessions": {
                                                                        "Breakfast": {
                                                                          "Default": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.breakfastTotal.text),
                                                                          },
                                                                          "Session1": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.bfSession1Controller.text),
                                                                          },
                                                                          "Session2": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.bfSession2Controller.text),
                                                                          },
                                                                          "Session3": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.bfSession3Controller.text),
                                                                          },
                                                                          "Session4": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.bfSession4Controller.text),
                                                                          },
                                                                        },
                                                                        "Lunch": {
                                                                          "Default": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.lunchTotal.text),
                                                                          },
                                                                          "Session1": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.lnSession1Controller.text),
                                                                          },
                                                                          "Session2": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.lnSession2Controller.text),
                                                                          },
                                                                          "Session3": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.lnSession3Controller.text),
                                                                          },
                                                                          "Session4": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.lnSession4Controller.text),
                                                                          },
                                                                        },
                                                                        "Dinner": {
                                                                          "Default": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.dinnerTotal.text),
                                                                          },
                                                                          "Session1": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.dnSession1Controller.text),
                                                                          },
                                                                          "Session2": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.dnSession2Controller.text),
                                                                          },
                                                                          "Session3": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.dnSession3Controller.text),
                                                                          },
                                                                          "Session4": {
                                                                            "Enabled": true,
                                                                            "availableCount": int.parse(LiveMenuVariables.dnSession4Controller.text),
                                                                          },
                                                                        },
                                                                      },
                                                                    };

                                                                    int totalCount = int.parse(LiveMenuVariables.total.text);
                                                                    if(totalCount > 9999)
                                                                    {
                                                                      _showExceedLimitAlertDialog(context);

                                                                    }
                                                                    else if(totalCount<9)
                                                                    {
                                                                      _showExceedLimitAlertDialog1(context);
                                                                    }
                                                                    else {
                                                                      MenuService menuService = MenuService();
                                                                      menuService.updateLiveMenu(state.item['_id'] , requestBody);
                                                                      _showConfirm(context);
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                    width: 100,
                                                                    padding: EdgeInsets.all(10),
                                                                    decoration: BoxDecoration(
                                                                      color: GlobalVariables.primaryColor, // Replace with your primary color
                                                                      borderRadius: BorderRadius.circular(5),
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        "Confirm",
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
                                                    Column()
                                                  ],
                                                ),

                                              ),
                                            ],
                                          ) : Column(
                                            children: [
                                              Container(
                                                height: 60,
                                                color: Colors.grey.shade100,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(width: 15,),
                                                        GlobalFunction.buildMealButton(context,MealTime.All,'All'),
                                                        SizedBox(width: 15,),
                                                        GlobalFunction.buildMealButton(context,MealTime.Breakfast,'Breakfast'),
                                                        SizedBox(width: 15,),
                                                        GlobalFunction.buildMealButton(context,MealTime.Lunch,'Lunch'),
                                                        SizedBox(width: 15,),
                                                        GlobalFunction.buildMealButton(context,MealTime.Dinner,'Dinner'),
                                                        SizedBox(width: 15,),

                                                      ],
                                                    ),

                                                    Container(
                                                      width: 2,
                                                      color: GlobalVariables.primaryColor.withOpacity(0.3),
                                                    ),

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

                                                    Container(
                                                      width: 2,
                                                      color: GlobalVariables.primaryColor.withOpacity(0.3),
                                                    ),

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
                                          ),


                                          Column(
                                            children: [
                                              SizedBox(height: 10,),
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    buildMealTimeButtonSubscription(MealTime.Breakfast, 'Breakfast'),
                                                    buildMealTimeButtonSubscription(MealTime.Lunch, 'Lunch'),
                                                    buildMealTimeButtonSubscription(MealTime.Dinner, 'Dinner'),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(height: 15,),

                                              SizedBox(height: 0,),
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
                                                        item.toLowerCase().contains(widget.searchQuery.toLowerCase()));

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
                                                                        _showAddItemDialogSubscription();
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
                                                              visible: selectedSubscription.contains(category),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: _buildItemsListSubscription(category, itemsList),
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
                                                    });
                                                  },
                                                ),

                                              ),
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

                    );
                  }
              );
            },

            );
          }
          return Container();
        },
      ),

    );
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
        String itemName = item['name'] as String;
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

  List<Widget> _buildItemsListSubscription(String category, List<Map<String, dynamic>> itemsList) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);

    if (selectedSubscription.isNotEmpty && selectedSubscription.contains(category)) {
      return itemsList.map((item) {
        String itemName = item['name'] as String;
        bool availability = item['availability'] as bool;
        Map<String, dynamic> itemDetails = item;
        return _buildDismissibleItemSubscription(
            itemName, color, availability, itemDetails);
      }).toList();
    } else {
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

  Widget _buildDismissibleItemSubscription(String item, Color color,bool itemAvail,Map<String, dynamic> item1) {
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
    return Dismissible(
      key: Key(item),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          subscriptionFoodCategories[selectedCategorySubscription]!.remove(item);
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
            setState(() {
              selectedItem = item;
            });
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
              trailing: Transform.scale(
                scaleY: 0.8,
                scaleX: 0.8,
                child: Switch(
                  value: item1['availability'],
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor:
                  GlobalVariables.textColor.withOpacity(0.6),
                  activeThumbImage: AssetImage('assets/images/letter-d.png'),
                  inactiveThumbImage: NetworkImage(
                      "https://wallpapercave.com/wp/wp7632851.jpg"),
                  onChanged: (bool value) {
                    setState(() {
                      item1['availability']=value;

                      if (selectedCategorySubscription.isNotEmpty && subscriptionFoodCategories.containsKey(selectedCategorySubscription)) {
                        // Iterate through the items in the selected category
                        for (var item in subscriptionFoodCategories[selectedCategorySubscription]!) {
                          // Set the 'availability' of the current item based on whether it matches the selected item
                          item['availability'] = (item == item1) ? value : false;
                        }
                      }
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
  

  void _showAddItemDialogSubscription() {
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
                    Map<String, dynamic> newItem = {'name': item.text, 'availability': false};
                    subscriptionFoodCategories[selectedCategorySubscription]!.add(newItem);
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

  void _showExceedLimitAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning',style: SafeGoogleFont('Poppins',fontSize: 16,fontWeight: FontWeight.bold,color: GlobalVariables.textColor),),
          content: Text('Your total count is exceeding the limit (less than 10000). Do you want to reset?'),
          actions: [
            TextButton(
              onPressed: () {
                initialValue();
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: GlobalVariables.primaryColor,
                  borderRadius: BorderRadius.circular(10)
                ),
                  child: Center(child: Text('Ok',style: SafeGoogleFont('Poppins',fontSize: 16,fontWeight: FontWeight.bold),))
              ),
            ),
          ],
        );
      },
    );
  }

  void _showExceedLimitAlertDialog1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning',style: SafeGoogleFont('Poppins',fontSize: 16,fontWeight: FontWeight.bold,color: GlobalVariables.textColor),),
          content: Text('Your total count is less than the minimum count. Do you want to reset'),
          actions: [
            TextButton(
              onPressed: () {
                initialValue();
                Navigator.of(context).pop();
              },
              child:Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: GlobalVariables.primaryColor,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text('Ok',style: SafeGoogleFont('Poppins',fontSize: 16,fontWeight: FontWeight.bold),))
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Updated',style: SafeGoogleFont('Poppins',fontSize: 16,fontWeight: FontWeight.bold,color: GlobalVariables.textColor),),
          content: Text('Count updated successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: GlobalVariables.primaryColor,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text('Ok',style: SafeGoogleFont('Poppins',fontSize: 16,fontWeight: FontWeight.bold),))
              ),
            ),
          ],
        );
      },
    );
  }
}




