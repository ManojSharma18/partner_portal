import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_event.dart';
import 'package:partner_admin_portal/bloc/live_menu_1/live_menu1_bloc.dart';
import 'package:partner_admin_portal/bloc/live_menu_1/live_menu1_state.dart';
import 'package:partner_admin_portal/bloc/menu/menu_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_event.dart';
import 'package:partner_admin_portal/bloc/menu/menu_state.dart';
import 'package:partner_admin_portal/bloc/menu_editor/menu_editor_bloc.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/search_bar.dart';
import 'package:partner_admin_portal/models/live_menu_model.dart';
import 'package:partner_admin_portal/repository/live_menu_service.dart';
import 'package:partner_admin_portal/repository/menu_services.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_breakfast_count.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count2.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count_multi.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count_multi_new.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_count_new.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_dinner_count.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_lunch_count.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_mobile.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu_multi_count.dart';
import 'package:partner_admin_portal/widgets/menu/menu_editor/menu_editor1.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/count_table.dart';
import 'package:provider/provider.dart';
import '../../../bloc/live_menu/live_menu_bloc.dart';
import '../../../bloc/live_menu/live_menu_state.dart';
import '../../../bloc/live_menu_1/live_menu1_event.dart';
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
import 'meal_edit_mobile.dart';



enum MealBudget {All,Budget,Premium,Luxury}

class LiveMenu3 extends StatefulWidget {
  final String searchQuery;
  const LiveMenu3({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<LiveMenu3> createState() => _LiveMenuState();
}

class _LiveMenuState extends State<LiveMenu3> with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _menuController;
  late TabController _liveMenuController;
  bool isCountBased = false;

  bool _isMultiTabSelected = false;

  bool enabled = false;

  Map<String, List<Map<String, dynamic>>> foodCategories = {};

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
    _menuController = TabController(length: 4, vsync: this);
    _menuController.addListener(_handleTabSelection);
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

  void _handleTabSelection() {
    setState(() {
      _isMultiTabSelected = _menuController.index == 3; // Index of 'Multi' tab
    });
  }


  String query = "";

  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    
    return  BlocProvider(
      create: (BuildContext context) => LiveMenu1Bloc(
        LiveMenuService(),
      )..add(LoadLiveMenu1Event(context)),
      child: BlocBuilder<LiveMenu1Bloc,LiveMenu1State>(
        builder: (BuildContext menuContext, liveMenuState) {
          if( liveMenuState is LiveMenu1LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if( liveMenuState is LiveMenu1ErrorState) {
            return const Center(child: Text("Node server error"),);
          }
          if(liveMenuState is LiveMenu1LoadedState){
            return LiveMenuWidget(menuState: liveMenuState,menuContext: menuContext);
          }
          return Container();
        },
      ),
    );
  }

  Widget LiveMenuWidget({LiveMenu1LoadedState? menuState, required BuildContext menuContext}) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    DayProvider dayProvider = context.watch<DayProvider>();
    if(menuState != null) {
      foodCategories = LiveMenuVariables.liveMenuNewfoodCategoriesBreakfast;




      return ResponsiveBuilder(
          mobileBuilder: (BuildContext context,BoxConstraints constraints){
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
                  // state.selectedCategories.add(cuisine);
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

            return Column(
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
                      length: 4,
                      child: Scaffold(
                        appBar:AppBar(
                          toolbarHeight: 0,
                          backgroundColor:Colors.grey.shade200,
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(50.0),
                            child: TabBar(
                              controller: _menuController,
                              isScrollable: false,
                              indicatorSize: TabBarIndicatorSize.tab,
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
                                Tab(text: 'Multi'),
                              ],
                            ),
                          ),
                        ),
                        body: TabBarView(
                          controller: _menuController,
                          children: [

                            LiveMenuCountNew(searchQuery: ''),
                            LiveMenuCountNew(searchQuery: ''),
                            LiveMenuCountNew(searchQuery: ''),
                            LiveMenuCountMultiNew(searchQuery: '')

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                  // state.selectedCategories.add(cuisine);
                  filteredFoodCategory[cuisine] = matchingItems;
                }
              });


            }
            else {
              filteredFoodCategory = foodCategories;
              selectedCategories = {};
              MenuEditorVariables.selectedCategories = {};
              MenuEditorVariables.selectedCategories.add(
                  MenuEditorVariables.tagController.text);
            }

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
                                              Tab(text: 'Multi'),

                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: !_isMultiTabSelected,
                                          child: Transform.scale(
                                            scale: 0.8,
                                            child: Switch(
                                              value: _switchValue,
                                              onChanged: (val) {
                                                setState(() {
                                                  _switchValue = val;
                                                });
                                              },
                                              // Color when the switch is off
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                body: TabBarView(
                                  controller: _menuController,
                                  children: [

                                    LiveMenuCountNew(searchQuery: ''),
                                    LiveMenuCountNew(searchQuery: ''),
                                    LiveMenuCountNew(searchQuery: ''),
                                    LiveMenuCountMultiNew(searchQuery: '')

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
                  // state.selectedCategories.add(cuisine);
                  filteredFoodCategory[cuisine] = matchingItems;
                }
              });


            }
            else {
              filteredFoodCategory = foodCategories;
            }

            return Container(
              decoration: BoxDecoration(
                  color: GlobalVariables.whiteColor
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
                                              Tab(text: 'Multi'),

                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: !_isMultiTabSelected,
                                          child: Transform.scale(
                                            scale: 0.8,
                                            child: Switch(
                                              value: _switchValue,
                                              onChanged: (val) {
                                                setState(() {
                                                  _switchValue = val;
                                                });
                                              },
                                              // Color when the switch is off
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                body: TabBarView(
                                  controller: _menuController,
                                  children: [

                                    LiveMenuBreakfastCount(),
                                    LiveMenuLunchCount(),
                                    LiveMenuDinnerCount(),
                                    LiveMenuMultiCount()

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
    else {
      return Center(child: CircularProgressIndicator());
    }
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



}




