import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/constants/responsive_builder.dart';
import 'package:provider/provider.dart';

import '../constants/custom_textfield.dart';
import '../constants/global_variables.dart';
import '../constants/search_bar.dart';
import '../constants/utils.dart';
import '../provider/day_provider.dart';

enum MealTime {All,Breakfast,Lunch,Dinner}
enum MealBudget {All,Budget,Premium,Luxury}

class LiveMenu extends StatefulWidget {
  const LiveMenu({Key? key}) : super(key: key);

  @override
  State<LiveMenu> createState() => _LiveMenuState();
}

class _LiveMenuState extends State<LiveMenu> with TickerProviderStateMixin {
  late TabController _tabController;
  bool isCountBased = false;
  Map<String, List<String>> foodCategories = {
    'Starters': ['Chicken Kabab', 'Chicken Fry', 'Vegetable Spring Rolls'],
    'Drinks': ['Cola', 'Orange Juice', 'Coffee', 'Tea'],
    'Rice': ['Boiled Rice', 'Biriyani Rice', 'Egg Rice',]
  };
  bool switchValue = false;
  String selectedCategory = '';

  String selectedItem = '';

  MealTime selectedMealTime = MealTime.Breakfast;
  MealBudget selectedBudget = MealBudget.Budget;

  Map<String,bool> provider = {'Deliver' : false,'Dine in' : false, 'Pick up':false};

  Map<String,Map<String,bool>> meals = {
    'Breakfast' : {'S1':false,'S2':false,'S3':false},
    'Lunch' : {'S1':false,'S2':false,'S3':false},
    'Dinner' : {'S1':true,'S2':true,'S3':true},
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    final dateProvider = context.watch<DayProvider>();
    return  ResponsiveBuilder(mobileBuilder: (BuildContext context,BoxConstraints constraints){
      return  Column(
        children: [
          SearchBars(hintText: "Search", width: 350*fem,height: 70,),
          SizedBox(height: 0,),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildMealTimeButton1(MealTime.All, 'All'),
                buildMealTimeButton1(MealTime.Breakfast, 'Breakfast'),
                buildMealTimeButton1(MealTime.Lunch, 'Lunch'),
                buildMealTimeButton1(MealTime.Dinner, 'Dinner'),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildBudgetButton1(MealBudget.All, 'All'),
                buildBudgetButton1(MealBudget.Budget, 'Budget'),
                buildBudgetButton1(MealBudget.Premium, 'Premium'),
                buildBudgetButton1(MealBudget.Luxury, 'Luxury'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: foodCategories.length,
              itemBuilder: (context, index) {
                String category = foodCategories.keys.elementAt(index);
                List<String> items = foodCategories[category] ?? [];
                return InkWell(
                  onTap: () {
                    print('Tapped on $category');
                    setState(() {
                      if(selectedCategory == category)
                        {
                          selectedCategory = "";
                        }else{
                        selectedCategory = category;
                      }

                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        height:50,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        color: selectedCategory == category ? Color(0xFF363563) : null,
                        child: ListTile(
                          title: Text(
                            category, style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: selectedCategory == category ? Colors.white : GlobalVariables.textColor,
                          ),),
                          leading: Icon(
                            Icons.grid_view_rounded, size: 10,
                            color: GlobalVariables.textColor,),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if(selectedCategory == category)
                                    {
                                      selectedCategory = "";
                                    }else{
                                      selectedCategory = category;
                                    }

                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: 5),
                                    Icon( selectedCategory== category ? Icons.arrow_drop_down : Icons.arrow_drop_up , size: 35, color: GlobalVariables.primaryColor
                                    ),
                                    SizedBox(width: 5),

                                  ],
                                ),
                              ),
                              SizedBox(width:5),
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
                                        color: GlobalVariables
                                            .primaryColor
                                    ),
                                    SizedBox(width: 5),
                                    // Adjust the spacing as needed
                                    Text(
                                        'ADD ITEM',
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xfffbb830),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: selectedCategory == category,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          mainAxisAlignment: MainAxisAlignment
                              .start,
                          children: _buildItemsList1(category,items),
                        ),
                      ),
                      //
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    }, tabletBuilder: (BuildContext context,BoxConstraints constraints){
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
                            toolbarHeight: 0,backgroundColor:Colors.white,
                            bottom: TabBar(
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
                                Tab(text: 'For orders'),
                                Tab(text: 'Subscription'),
                              ],
                            ),
                          ),
                          body: TabBarView(
                            children: [
                              Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          buildMealTimeButton(MealTime.All, 'All'),
                                          SizedBox(width:10),
                                          buildMealTimeButton(MealTime.Breakfast, 'Breakfast'),
                                          SizedBox(width:10),
                                          buildMealTimeButton(MealTime.Lunch, 'Lunch'),
                                          SizedBox(width:10),
                                          buildMealTimeButton(MealTime.Dinner, 'Dinner'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          buildBudgetButton(MealBudget.All, 'All'),
                                          SizedBox(width:10),
                                          buildBudgetButton(MealBudget.Budget, 'Budget'),
                                          SizedBox(width:10),
                                          buildBudgetButton(MealBudget.Premium, 'Premium'),
                                          SizedBox(width:10),
                                          buildBudgetButton(MealBudget.Luxury, 'Luxury'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  // Container(
                                  //   padding: EdgeInsets.all(15),
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.grey.shade200
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text("SECTIONS | ${foodCategories.length}",
                                  //         style: SafeGoogleFont(
                                  //           'Poppins',
                                  //           fontSize: 14,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Color(0xFF363563),
                                  //         ),),
                                  //
                                  //       SizedBox(width: 10,),
                                  //
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(height: 0,),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: foodCategories.length,
                                      itemBuilder: (context, index) {
                                        String category = foodCategories.keys.elementAt(index);
                                        List<String> items = foodCategories[category] ?? [];
                                        return InkWell(
                                          onTap: () {
                                            print('Tapped on $category');
                                            setState(() {
                                              selectedCategory = category; // Update selected category
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                color: selectedCategory == category
                                                    ? Color(0xFF363563)
                                                    : null,
                                                child: ListTile(
                                                  title: Text(
                                                    category, style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: selectedCategory == category
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),),
                                                  leading: Icon(
                                                    Icons.grid_view_rounded, size: 10,
                                                    color: selectedCategory == category
                                                        ? Colors.white
                                                        : Colors.black,),
                                                  trailing: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [

                                                      InkWell(
                                                        onTap: () {

                                                        },
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            SizedBox(width: 5),
                                                            Icon(
                                                                Icons.add,
                                                                size: 15,
                                                                color: GlobalVariables
                                                                    .primaryColor
                                                            ),
                                                            SizedBox(width: 5),
                                                            // Adjust the spacing as needed
                                                            Text(
                                                                'ADD ITEM',
                                                                style: SafeGoogleFont(
                                                                  'Poppins',
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Color(0xfffbb830),
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: selectedCategory == category,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  children: _buildItemsList(category,items),
                                                ),
                                              ),
                                              //
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  // Container(
                                  //   padding: EdgeInsets.all(15),
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.grey.shade200
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text("SECTIONS | ${foodCategories.length}",
                                  //         style: SafeGoogleFont(
                                  //           'Poppins',
                                  //           fontSize: 14,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Color(0xFF363563),
                                  //         ),),
                                  //
                                  //       SizedBox(width: 10,),
                                  //
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(height: 20,),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: foodCategories.length,
                                      itemBuilder: (context, index) {
                                        String category = foodCategories.keys.elementAt(index);
                                        List<String> items = foodCategories[category] ?? [];
                                        return InkWell(
                                          onTap: () {
                                            print('Tapped on $category');
                                            setState(() {
                                              selectedCategory = category; // Update selected category
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                color: selectedCategory == category
                                                    ? Color(0xFF363563)
                                                    : null,
                                                child: ListTile(
                                                  title: Text(
                                                    category, style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: selectedCategory == category
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),),
                                                  leading: Icon(
                                                    Icons.grid_view_rounded, size: 10,
                                                    color: selectedCategory == category
                                                        ? Colors.white
                                                        : Colors.black,),
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
                                                                color: GlobalVariables
                                                                    .primaryColor
                                                            ),
                                                            SizedBox(width: 5),
                                                            // Adjust the spacing as needed
                                                            Text(
                                                                'ADD ITEM',
                                                                style: SafeGoogleFont(
                                                                  'Poppins',
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Color(0xfffbb830),
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: selectedCategory == category,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  children: _buildItemsList(category,items),
                                                ),
                                              ),
                                              //
                                            ],
                                          ),
                                        );
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

                  Expanded(
                    flex: 5,
                    child: DefaultTabController(
                      length: 7, // Number of tabs
                      child: selectedItem == '' ? Container()  :
                      Scaffold(
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
                              for (int i = 0; i < 7; i++)
                                Tab(
                                  text: DateFormat('E').format(DateTime.now().add(Duration(days: i))),
                                ),

                            ],
                            onTap: (index){
                              dateProvider.updateSelectedDay('${DateFormat('E').format(DateTime.now().add(Duration(days: index)))} : ${DateFormat('dd MMM').format(DateTime.now().add(Duration(days: index)))}');
                            },
                          ),
                        ),
                        body: TabBarView(
                          controller: _tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            // Content for Tab 1
                            // Content for Tab 1
                            Container(
                              margin: EdgeInsets.all(20),
                              child: Column(
                                children: [

                                  Visibility(
                                    visible: !isCountBased,
                                    child: Column(
                                      children: [
                                        SingleChildScrollView(
                                    scrollDirection : Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    visible: isCountBased,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("Total : ",style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color:GlobalVariables.textColor,
                                            ),),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: GlobalVariables.primaryColor),
                                                  borderRadius: BorderRadius.circular(5),color: GlobalVariables.whiteColor
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Center(child: Text("100",style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color:GlobalVariables.textColor,
                                                ),)),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 30,),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  Text("Breakfast",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 10,),
                                                  buildCount(30),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text("S1",style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color:GlobalVariables.textColor,
                                                          ),),
                                                          SizedBox(height: 5,),
                                                          buildCount(7),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Column(
                                                        children: [
                                                          Text("S2",style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color:GlobalVariables.textColor,
                                                          ),),
                                                          SizedBox(height: 5,),
                                                          buildCount(7),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Column(
                                                        children: [
                                                          Text("S3",style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color:GlobalVariables.textColor,
                                                          ),),
                                                          SizedBox(height: 5,),
                                                          buildCount(7),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Column(
                                                        children: [
                                                          Text("S4",style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color:GlobalVariables.textColor,
                                                          ),),
                                                          SizedBox(height: 5,),
                                                          buildCount(7),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: 30,),
                                              Column(
                                                children: [
                                                  Text("Lunch",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 10,),
                                                  buildCount(30),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text("S1",style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color:GlobalVariables.textColor,
                                                          ),),
                                                          SizedBox(height: 5,),
                                                          buildCount(7),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Column(
                                                        children: [
                                                          Text("S2",style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color:GlobalVariables.textColor,
                                                          ),),
                                                          SizedBox(height: 5,),
                                                          buildCount(7),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Column(
                                                        children: [
                                                          Text("S3",style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color:GlobalVariables.textColor,
                                                          ),),
                                                          SizedBox(height: 5,),
                                                          buildCount(7),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Column(
                                                        children: [
                                                          Text("S4",style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color:GlobalVariables.textColor,
                                                          ),),
                                                          SizedBox(height: 5,),
                                                          buildCount(7),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: 30,),
                                              Column(
                                                children: [
                                                  Text("Dinner",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 10,),
                                                  buildCount(30),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text("S1",style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color:GlobalVariables.textColor,
                                                          ),),
                                                          SizedBox(height: 5,),
                                                          buildCount(7),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Column(
                                                        children: [
                                                          Text("S2",style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color:GlobalVariables.textColor,
                                                          ),),
                                                          SizedBox(height: 5,),
                                                          buildCount(7),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Column(
                                                        children: [
                                                          Text("S3",style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color:GlobalVariables.textColor,
                                                          ),),
                                                          SizedBox(height: 5,),
                                                          buildCount(7),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Column(
                                                        children: [
                                                          Text("S4",style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color:GlobalVariables.textColor,
                                                          ),),
                                                          SizedBox(height: 5,),
                                                          buildCount(7),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 30,),
                                        Row(
                                          mainAxisAlignment:MainAxisAlignment.start,
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

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),


                            // Content for Tab 2
                            Center(child: Text('Tab 2 Content')),

                            // Content for Tab 3
                            Center(child: Text('Tab 3 Content')),

                            // Content for Tab 4
                            Center(child: Text('Tab 4 Content')),

                            // Content for Tab 5
                            Center(child: Text('Tab 5 Content')),

                            Center(child: Text('Tab 6 Content')),

                            Center(child: Text('Tab 7 Content')),
                          ],
                        ),
                        bottomNavigationBar: Padding(
                          padding:  EdgeInsets.only(right: 16.0,left:30*fem),
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
                                      "Remove item",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: GlobalVariables.textColor,
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
                                label: '',
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
    }, desktopBuilder: (BuildContext context,BoxConstraints constraints){
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
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(left: 5),
                      color: Colors.white,
                      child: DefaultTabController(
                        length: 2,
                        child: Scaffold(
                          appBar:AppBar(
                            toolbarHeight: 0,backgroundColor:Colors.white,
                            bottom: TabBar(
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
                                Tab(text: 'For orders'),
                                Tab(text: 'Subscription'),
                              ],
                            ),
                          ),
                          body: TabBarView(
                            children: [
                              Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        buildMealTimeButton(MealTime.All, 'All'),
                                        buildMealTimeButton(MealTime.Breakfast, 'Breakfast'),
                                        buildMealTimeButton(MealTime.Lunch, 'Lunch'),
                                        buildMealTimeButton(MealTime.Dinner, 'Dinner'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        buildBudgetButton(MealBudget.All, 'All'),
                                        buildBudgetButton(MealBudget.Budget, 'Budget'),
                                        buildBudgetButton(MealBudget.Premium, 'Premium'),
                                        buildBudgetButton(MealBudget.Luxury, 'Luxury'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  // Container(
                                  //   padding: EdgeInsets.all(15),
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.grey.shade200
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text("SECTIONS | ${foodCategories.length}",
                                  //         style: SafeGoogleFont(
                                  //           'Poppins',
                                  //           fontSize: 14,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Color(0xFF363563),
                                  //         ),),
                                  //
                                  //       SizedBox(width: 10,),
                                  //
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(height: 0,),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: foodCategories.length,
                                      itemBuilder: (context, index) {
                                        String category = foodCategories.keys.elementAt(index);
                                        List<String> items = foodCategories[category] ?? [];
                                        return InkWell(
                                          onTap: () {
                                            print('Tapped on $category');
                                            setState(() {
                                              if(selectedCategory == category)
                                                {
                                                  selectedCategory = "";
                                                }else{
                                                selectedCategory = category;
                                              }
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                color: selectedCategory == category
                                                    ? Color(0xFF363563)
                                                    : null,
                                                child: ListTile(
                                                  title: Text(
                                                    category, style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: selectedCategory == category
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),),
                                                  leading: Icon(
                                                    Icons.grid_view_rounded, size: 10,
                                                    color: selectedCategory == category
                                                        ? Colors.white
                                                        : Colors.black,),
                                                  trailing: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [

                                                      InkWell(
                                                        onTap: () {

                                                        },
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            SizedBox(width: 5),
                                                            Icon(
                                                                Icons.add,
                                                                size: 15,
                                                                color: GlobalVariables
                                                                    .primaryColor
                                                            ),
                                                            SizedBox(width: 5),
                                                            // Adjust the spacing as needed
                                                            Text(
                                                                'ADD ITEM',
                                                                style: SafeGoogleFont(
                                                                  'Poppins',
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Color(0xfffbb830),
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: selectedCategory == category,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  children: _buildItemsList(category,items),
                                                ),
                                              ),
                                              //
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        buildMealTimeButton(MealTime.All, 'All'),
                                        buildMealTimeButton(MealTime.Breakfast, 'Breakfast'),
                                        buildMealTimeButton(MealTime.Lunch, 'Lunch'),
                                        buildMealTimeButton(MealTime.Dinner, 'Dinner'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        buildBudgetButton(MealBudget.All, 'All'),
                                        buildBudgetButton(MealBudget.Budget, 'Budget'),
                                        buildBudgetButton(MealBudget.Premium, 'Premium'),
                                        buildBudgetButton(MealBudget.Luxury, 'Luxury'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  // Container(
                                  //   padding: EdgeInsets.all(15),
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.grey.shade200
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text("SECTIONS | ${foodCategories.length}",
                                  //         style: SafeGoogleFont(
                                  //           'Poppins',
                                  //           fontSize: 14,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Color(0xFF363563),
                                  //         ),),
                                  //
                                  //       SizedBox(width: 10,),
                                  //
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(height: 0,),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: foodCategories.length,
                                      itemBuilder: (context, index) {
                                        String category = foodCategories.keys.elementAt(index);
                                        List<String> items = foodCategories[category] ?? [];
                                        return InkWell(
                                          onTap: () {
                                            print('Tapped on $category');
                                            setState(() {
                                              selectedCategory = category; // Update selected category
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                color: selectedCategory == category
                                                    ? Color(0xFF363563)
                                                    : null,
                                                child: ListTile(
                                                  title: Text(
                                                    category, style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: selectedCategory == category
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),),
                                                  leading: Icon(
                                                    Icons.grid_view_rounded, size: 10,
                                                    color: selectedCategory == category
                                                        ? Colors.white
                                                        : Colors.black,),
                                                  trailing: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [

                                                      InkWell(
                                                        onTap: () {

                                                        },
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            SizedBox(width: 5),
                                                            Icon(
                                                                Icons.add,
                                                                size: 15,
                                                                color: GlobalVariables
                                                                    .primaryColor
                                                            ),
                                                            SizedBox(width: 5),
                                                            // Adjust the spacing as needed
                                                            Text(
                                                                'ADD ITEM',
                                                                style: SafeGoogleFont(
                                                                  'Poppins',
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Color(0xfffbb830),
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: selectedCategory == category,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  children: _buildItemsList(category,items),
                                                ),
                                              ),
                                              //
                                            ],
                                          ),
                                        );
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
                  Expanded(
                    flex: 5,
                    child: DefaultTabController(
                      length: 7, // Number of tabs
                      child: selectedItem == '' ? Container()  :
                      Scaffold(
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
                              for (int i = 0; i < 7; i++)
                                Tab(
                                  text: DateFormat('E').format(DateTime.now().add(Duration(days: i))),
                                ),

                            ],
                            onTap: (index){
                              dateProvider.updateSelectedDay('${DateFormat('E').format(DateTime.now().add(Duration(days: index)))} : ${DateFormat('dd MMM').format(DateTime.now().add(Duration(days: index)))}');
                            },
                          ),
                        ),
                        body: TabBarView(
                          controller: _tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            // Content for Tab 1
                            // Content for Tab 1
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
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("Total : ",style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color:GlobalVariables.textColor,
                                            ),),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: GlobalVariables.primaryColor),
                                                  borderRadius: BorderRadius.circular(5),color: GlobalVariables.whiteColor
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Center(child: Text("100",style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color:GlobalVariables.textColor,
                                                ),)),
                                              ),
                                            ),
                                            SizedBox(width:50),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text("Breakfast",style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color:GlobalVariables.textColor,
                                                    ),),
                                                    SizedBox(height: 10,),
                                                    buildCount(30),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text("S1",style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color:GlobalVariables.textColor,
                                                            ),),
                                                            SizedBox(height: 5,),
                                                            buildCount(7),
                                                          ],
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Column(
                                                          children: [
                                                            Text("S2",style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color:GlobalVariables.textColor,
                                                            ),),
                                                            SizedBox(height: 5,),
                                                            buildCount(7),
                                                          ],
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Column(
                                                          children: [
                                                            Text("S3",style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color:GlobalVariables.textColor,
                                                            ),),
                                                            SizedBox(height: 5,),
                                                            buildCount(7),
                                                          ],
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Column(
                                                          children: [
                                                            Text("S4",style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color:GlobalVariables.textColor,
                                                            ),),
                                                            SizedBox(height: 5,),
                                                            buildCount(7),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 50,),
                                                Column(
                                                  children: [
                                                    Text("Lunch",style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color:GlobalVariables.textColor,
                                                    ),),
                                                    SizedBox(height: 10,),
                                                    buildCount(30),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text("S1",style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color:GlobalVariables.textColor,
                                                            ),),
                                                            SizedBox(height: 5,),
                                                            buildCount(7),
                                                          ],
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Column(
                                                          children: [
                                                            Text("S2",style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color:GlobalVariables.textColor,
                                                            ),),
                                                            SizedBox(height: 5,),
                                                            buildCount(7),
                                                          ],
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Column(
                                                          children: [
                                                            Text("S3",style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color:GlobalVariables.textColor,
                                                            ),),
                                                            SizedBox(height: 5,),
                                                            buildCount(7),
                                                          ],
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Column(
                                                          children: [
                                                            Text("S4",style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color:GlobalVariables.textColor,
                                                            ),),
                                                            SizedBox(height: 5,),
                                                            buildCount(7),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 50,),
                                                Column(
                                                  children: [
                                                    Text("Dinner",style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color:GlobalVariables.textColor,
                                                    ),),
                                                    SizedBox(height: 10,),
                                                    buildCount(30),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text("S1",style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color:GlobalVariables.textColor,
                                                            ),),
                                                            SizedBox(height: 5,),
                                                            buildCount(7),
                                                          ],
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Column(
                                                          children: [
                                                            Text("S2",style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color:GlobalVariables.textColor,
                                                            ),),
                                                            SizedBox(height: 5,),
                                                            buildCount(7),
                                                          ],
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Column(
                                                          children: [
                                                            Text("S3",style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color:GlobalVariables.textColor,
                                                            ),),
                                                            SizedBox(height: 5,),
                                                            buildCount(7),
                                                          ],
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Column(
                                                          children: [
                                                            Text("S4",style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color:GlobalVariables.textColor,
                                                            ),),
                                                            SizedBox(height: 5,),
                                                            buildCount(7),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30,),

                                        SizedBox(height: 30,),
                                        Row(
                                          mainAxisAlignment:MainAxisAlignment.start,
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

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),


                            // Content for Tab 2
                            Center(child: Text('Tab 2 Content')),

                            // Content for Tab 3
                            Center(child: Text('Tab 3 Content')),

                            // Content for Tab 4
                            Center(child: Text('Tab 4 Content')),

                            // Content for Tab 5
                            Center(child: Text('Tab 5 Content')),

                            Center(child: Text('Tab 6 Content')),

                            Center(child: Text('Tab 7 Content')),
                          ],
                        ),
                        bottomNavigationBar: Padding(
                          padding:  EdgeInsets.only(right: 16.0,left: 150*fem),
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
                                      "Remove item",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: GlobalVariables.whiteColor,
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
                                label: '',
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

  Widget buildMealTimeButton(MealTime mealTime, String label) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color backgroundColor = selectedMealTime == mealTime ? Colors.amber : selectedMealTime == MealTime.All ? Colors.amber : Colors.white;

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
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color:Color(0xfffbb830)),
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
                  color: GlobalVariables.textColor,
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
    Color backgroundColor = selectedMealTime == mealTime ? Colors.amber : selectedMealTime == MealTime.All ? Colors.amber : Colors.white;

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
          border: Border.all(color:Color(0xfffbb830)),
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
                  color: GlobalVariables.textColor,
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
    Color backgroundColor = selectedBudget == mealBudget ? Colors.amber : selectedBudget == MealBudget.All ? Colors.amber : Colors.white;

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
          border: Border.all(color:Color(0xfffbb830)),
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
                  color: GlobalVariables.textColor,
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
    Color backgroundColor = selectedBudget == mealBudget ? Colors.amber : selectedBudget == MealBudget.All ? Colors.amber : Colors.white;

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
          border: Border.all(color:Color(0xfffbb830)),
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
                  color: GlobalVariables.textColor,
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

  List<Widget> _buildItemsList(String category, List<String> items) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);
    if (selectedCategory.isNotEmpty &&
        foodCategories.containsKey(selectedCategory)) {
      return foodCategories[selectedCategory]!.map((item) {
        return _buildDismissibleItem(item, color);
      }).toList();
    } else {
      return [
        Center(
          child: Text('Select a category to view items.'),
        ),
      ];
    }
  }

  List<Widget> _buildItemsList1(String category, List<String> items) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);
    if (selectedCategory.isNotEmpty &&
        foodCategories.containsKey(selectedCategory)) {
      return foodCategories[selectedCategory]!.map((item) {
        return _buildDismissibleItem1(item, color);
      }).toList();
    } else {
      return [
        Center(
          child: Text('Select a category to view items.'),
        ),
      ];
    }
  }

  Widget _buildDismissibleItem(String item, Color color) {
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
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
      child: InkWell(
        onTap: (){
          setState(() {
            selectedItem = item;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
          ),
          margin: EdgeInsets.only(left: 20,),
          padding: EdgeInsets.only(left: 13),
          child: ListTile(
            title: Text(
              item,
              style: SafeGoogleFont(
                'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color:selectedItem == item ? GlobalVariables.textColor : color,
              ),
            ),
            trailing: Transform.scale(
              scaleY: 0.8,
              scaleX: 0.8,
              child: Switch(
                value: switchValue,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: GlobalVariables.textColor.withOpacity(0.6),
                inactiveThumbImage: NetworkImage("https://wallpapercave.com/wp/wp7632851.jpg"),
                onChanged: (bool value) {
                  setState(() {
                    value = !switchValue;
                  });
                },
              ),
            ),
            leading: Icon(Icons.grid_view_rounded, size: 10, color: selectedItem == item ? GlobalVariables.textColor : color,),
          ),
        ),
      ),
    );
  }

  Widget _buildDismissibleItem1(String item, Color color) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
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
      child: InkWell(
        onTap: (){
          setState(() {
            selectedItem = item;
          });
        },
        child: Container(
          margin: EdgeInsets.only(left:10,right: 10,bottom:10),
          decoration: BoxDecoration(
            color: GlobalVariables.whiteColor,
            borderRadius: BorderRadius.circular(10),boxShadow: [
            BoxShadow(
              color: Colors.grey, // You can set the shadow color here
              blurRadius: 5, // Adjust the blur radius as needed
              offset: Offset(0, 2), // Adjust the offset to control the shadow's position
            ),
          ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: selectedItem==item,
                child: Container(
                  width: 5,
                  height:100,
                  decoration: BoxDecoration(
                   color:  GlobalVariables.textColor,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),topRight: Radius.circular(30))
                  ),
                  margin:EdgeInsets.only(left: 20*fem),

                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      margin: EdgeInsets.only(left: 0,top: 10),
                      padding: EdgeInsets.only(left: 0),
                      child: ListTile(
                        title: Text(
                          item,
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 13*fem,
                            fontWeight: FontWeight.bold,
                            color: GlobalVariables.textColor,
                          ),
                        ),
                        trailing: Transform.scale(
                          scaleY: 0.7,
                          scaleX: 0.8,
                          child: Switch(
                            value: switchValue,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: GlobalVariables.textColor.withOpacity(0.6),

                            onChanged: (bool value) {
                              setState(() {
                                value = !switchValue;
                              });
                            },
                          ),
                        ),
                        leading: Icon(Icons.grid_view_rounded, size: 12, color: GlobalVariables.textColor.withOpacity(0.9),),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 30),
                      padding: EdgeInsets.only(left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("Breakfast.",style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 12*fem,
                                fontWeight: FontWeight.bold,
                                color:  GlobalVariables.textColor,
                              ),),
                              SizedBox(width: 3*fem,),
                              Text("Lunch.",style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 12*fem,
                                fontWeight: FontWeight.bold,
                                color:  GlobalVariables.textColor,
                              ),),
                              SizedBox(width: 3*fem,),
                              Text("Dinner.",style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 12*fem,
                                fontWeight: FontWeight.bold,
                                color:  GlobalVariables.textColor),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: (){

                              setState(() {
                                selectedItem = item;
                              });
                              showMealSelectionDialog(item,context);
                            },
                              child: Icon(Icons.more_vert,color: GlobalVariables.textColor.withOpacity(0.9),size: 25,)
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showMealSelectionDialog(String name,BuildContext context)
  {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (BuildContext context,  setState) {
            return Container(
              child: AlertDialog(
                backgroundColor:GlobalVariables.whiteColor ,
                title: Text(name),
                content:Container(
                  child: SingleChildScrollView(
                    child: Column(  
                      children: [
                        Visibility(
                          visible: isCountBased,
                          child: Container(
                            height: 250,
                            child: Column(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(value:allMeal('Breakfast'), onChanged: (val){
                                          setMeal('Breakfast', allMeal('Breakfast'));
                                        }),
                                        SizedBox(width: 10,),
                                        Container(
                                          width: 80,
                                          child: Text("Breakfast : ",style:  SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color:GlobalVariables.textColor,
                                          ),),
                                        ),
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
                                    SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Checkbox(value: allMeal('Lunch'), onChanged: (val){
                                          setState(() {
                                            meals['Lunch']?.forEach((key, _) {
                                              meals['Lunch']![key] = val!;
                                            });
                                          });
                                        }),
                                        SizedBox(width: 10,),
                                        Container(width: 80,
                                          child: Text("Lunch : ",style:  SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color:GlobalVariables.textColor,
                                          ),),
                                        ),
                                        SizedBox(width: 20,),
                                        Row(
                                          children: [
                                            session("S1","Lunch",context),
                                            session("S2","Lunch",context),
                                            session("S3","Lunch",context)
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Checkbox(value: allMeal('Dinner'), onChanged: (val){
                                          setMeal("Dinner", allMeal('Dinner'));
                                        }),
                                        SizedBox(width: 10,),
                                        Container(
                                          width: 80,
                                          child: Text("Dinner : ",style:  SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color:GlobalVariables.textColor,
                                          ),),
                                        ),
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
                                    SizedBox(width: 10,),
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
                                    SizedBox(width: 10,),
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
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !isCountBased,
                          child: Container(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(color: GlobalVariables.primaryColor),
                                            borderRadius: BorderRadius.circular(5),color: GlobalVariables.whiteColor
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(child: Text("100",style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color:GlobalVariables.textColor,
                                          ),)),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Text("Breakfast",style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color:GlobalVariables.textColor,
                                          ),),
                                          SizedBox(height: 10,),
                                          buildCount(30),
                                          SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text("S1",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 5,),
                                                  buildCount(7),
                                                ],
                                              ),
                                              SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Text("S2",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 5,),
                                                  buildCount(7),
                                                ],
                                              ),
                                              SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Text("S3",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 5,),
                                                  buildCount(7),
                                                ],
                                              ),
                                              SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Text("S4",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 5,),
                                                  buildCount(7),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      Column(
                                        children: [
                                          Text("Lunch",style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color:GlobalVariables.textColor,
                                          ),),
                                          SizedBox(height: 10,),
                                          buildCount(30),
                                          SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text("S1",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 5,),
                                                  buildCount(7),
                                                ],
                                              ),
                                              SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Text("S2",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 5,),
                                                  buildCount(7),
                                                ],
                                              ),
                                              SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Text("S3",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 5,),
                                                  buildCount(7),
                                                ],
                                              ),
                                              SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Text("S4",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 5,),
                                                  buildCount(7),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      Column(
                                        children: [
                                          Text("Dinner",style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color:GlobalVariables.textColor,
                                          ),),
                                          SizedBox(height: 10,),
                                          buildCount(30),
                                          SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text("S1",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 5,),
                                                  buildCount(7),
                                                ],
                                              ),
                                              SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Text("S2",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 5,),
                                                  buildCount(7),
                                                ],
                                              ),
                                              SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Text("S3",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 5,),
                                                  buildCount(7),
                                                ],
                                              ),
                                              SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Text("S4",style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:GlobalVariables.textColor,
                                                  ),),
                                                  SizedBox(height: 5,),
                                                  buildCount(7),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(value: provider['Deliver'], onChanged: (val){
                                            setState(() {
                                              provider['Deliver'] = val!;
                                            });

                                          }),
                                          SizedBox(width: 5,),
                                          Text("Deliver",style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color:GlobalVariables.textColor,
                                          ),)
                                        ],
                                      ),
                                      SizedBox(width: 7,),
                                      Row(
                                        children: [
                                          Checkbox(value: provider['Dine in'], onChanged: (val){
                                            setState(() {
                                              provider['Dine in'] = val!;
                                            });

                                          }),
                                          SizedBox(width: 5,),
                                          Text("Dine in",style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color:GlobalVariables.textColor,
                                          ),)
                                        ],
                                      ),
                                      SizedBox(width: 7,),
                                      Row(
                                        children: [
                                          Checkbox(value: provider['Pick up'], onChanged: (val){
                                            setState(() {
                                              provider['Pick up'] = val!;
                                            });

                                          }),
                                          SizedBox(width: 5,),
                                          Text("Pick up",style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color:GlobalVariables.textColor,
                                          ),)
                                        ],
                                      )
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the AlertDialog
                  },
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color:Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(7),
                    child: Center(
                      child: Text(
                        'Cancel',
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
                  TextButton(
                    onPressed: () {
                      setState(() {

                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                          color: GlobalVariables.primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(7),
                      child: Center(
                        child: Text(
                          'Confirm',
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: GlobalVariables.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),],
              ),
            );
          },
        );
      }
    );
  }

  Widget buildCount(int count)
  {
    return Container(
      height: 25,
      width: 35,
      decoration: BoxDecoration(
          border: Border.all(color: GlobalVariables.primaryColor),
          borderRadius: BorderRadius.circular(5),color: GlobalVariables.whiteColor
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Center(child: Text(count.toString(),style: SafeGoogleFont(
          'Poppins',
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color:GlobalVariables.textColor,
        ),)),
      ),
    );
  }

  void _showAddItemDialog() {
    TextEditingController item = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            backgroundColor: GlobalVariables.whiteColor,
            title: Text('Adding new item'),
            content: Container(
              color: GlobalVariables.whiteColor,
              height: 350,
              width: 400,
              child: Column(
                children: [
                  CustomTextField(label: 'Search for item',
                    width: 400,
                    controller: item,
                    dropdownItems: ['Idli','Dose','Palav','Curd rice','Rava idli','Masala Dosa','Poori','Lemon rice','Puliyogare','Maggie'],
                    isDropdown: true,
                    showSearchBox1: true,
                    dropdownAuto: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Couldn't find item",style:  SafeGoogleFont(
                        'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),),
                    ],
                  )
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
                  decoration: BoxDecoration(
                      color:GlobalVariables.whiteColor,
                      border:Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cancel_rounded,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Cancel',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    foodCategories[selectedCategory]!.add(item.text);
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 100,
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

