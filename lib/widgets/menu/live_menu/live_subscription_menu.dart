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
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_3.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count2.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count_multi.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_mobile.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/subsciption_menu.dart';
import 'package:partner_admin_portal/widgets/menu/menu_editor/menu_editor1.dart';
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

class LiveSubscriptionMenu extends StatefulWidget {
  final String searchQuery;
  const LiveSubscriptionMenu({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<LiveSubscriptionMenu> createState() => _LiveMenuState();
}

class _LiveMenuState extends State<LiveSubscriptionMenu> with TickerProviderStateMixin {
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
      foodCategories = LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast;

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
                                    length: 4,
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
                                                    Tab(text: 'Orders'),
                                                    Tab(text: 'Subscription'),

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
                                          LiveMenu3(searchQuery: widget.searchQuery),
                                          SubscriptionMenu(),

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
                        color: Colors.red
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
                                                    Tab(text: 'Orders'),
                                                    Tab(text: 'Subscription'),

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
                                          LiveMenu3(searchQuery: widget.searchQuery),
                                          SubscriptionMenu(),

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




