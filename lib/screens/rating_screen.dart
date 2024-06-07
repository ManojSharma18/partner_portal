import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/widgets/meal_rating.dart';
import 'package:partner_admin_portal/widgets/month_rating.dart';

import '../constants/utils.dart';
import '../widgets/menu/live_menu/live_menu.dart';

class Rating extends StatefulWidget {
  const Rating({Key? key}) : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  Map<String, List<Map<String,dynamic>>> foodCategories =
  {
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
      {'name' :'Godhi payasa','availability' : false,'category' : 'veg'},
      {'name' : 'shavide payasa','availability' : false,'category' : 'veg'}
    ],

  };

  Map<String, List<Map<String,dynamic>>> subscriptionFoodCategories = {
    'Pocket friendly': [
      {'name' : 'Idli', 'availability' : true, 'category' : 'veg'},
      {'name' : 'Rice Bath','availability' : false,'category' : 'veg'},
      {'name' : 'Set dosa','availability' : false,'category' : 'veg' }
    ],

    'Budget': [
      {'name' : 'Bonda Soup', 'availability' : true,'category' : 'veg'},
      {'name' : 'Palav','availability' : false,'category' : 'veg'},
      {'name' : 'Curd rice','availability' : true,'category' : 'veg' }
    ],

    'Premium': [
      {'name' : 'Masala dosa', 'availability' : true,'category' : 'veg'},
      {'name' : 'Rava idli','availability' : false,'category' : 'veg'},
      {'name' : 'Idli vada','availability' : false ,'category' : 'veg'}
    ],

    'Luxury': [
      {'name' : 'Onion dosa', 'availability' : true,'category' : 'veg'},
      {'name' : 'Chocho bath','availability' : false,'category' : 'veg'},
      {'name' : 'Benne dosa','availability' : false ,'category' : 'veg'}
    ],

  };

  String selectedCategory = 'South indian breakfast';

  String selectedCategorySubscription = 'Pocket friendly';

  String selectedItem = 'Idli';

  MealTime selectedMealTime = MealTime.All;
  MealTime selectedMealTimeSubscription = MealTime.Breakfast;
  MealBudget selectedBudget = MealBudget.All;

  List<String> getFoodNames() {
    Map<String, List<Map<String, dynamic>>> foodCategories = {
      'South indian breakfast': [
        {'name': 'Idli', 'availability': true, 'category': 'veg'},
        {'name': 'Poori', 'availability': false, 'category': 'veg'},
        {'name': 'Shavige bath', 'availability': false, 'category': 'veg'}
      ],
      'North indian breakfast': [
        {'name': 'Chole bature', 'availability': true, 'category': 'veg'},
        {'name': 'Rava chilla', 'availability': false, 'category': 'veg'},
        {'name': 'Pav bhaji', 'availability': true, 'category': 'veg'}
      ],
      'South indian palya': [
        {'name': 'Beans palya', 'availability': true, 'category': 'veg'},
        {'name': 'Balekayi palya', 'availability': false, 'category': 'veg'},
        {'name': 'Soppin palya', 'availability': false, 'category': 'veg'}
      ],
      'North indian subzi': [
        {'name': 'Aloo moongere ki sabzi', 'availability': true, 'category': 'veg'},
        {'name': 'Aloo bhindi', 'availability': false, 'category': 'veg'},
        {'name': 'Gobo mater', 'availability': false, 'category': 'veg'}
      ],
      'South indian ricebath': [
        {'name': 'lemon rice', 'availability': true, 'category': 'veg'},
        {'name': 'puliyogare', 'availability': false, 'category': 'veg'},
        {'name': 'tomoto anna', 'availability': false, 'category': 'veg'}
      ],
      'South indian sambar': [
        {'name': 'onion sambar', 'availability': true, 'category': 'veg'},
        {'name': 'drumstick sambar', 'availability': false, 'category': 'veg'},
        {'name': 'mixed vegetables sambar', 'availability': false, 'category': 'veg'}
      ],
      'South indian sweets': [
        {'name': 'Akki payasa', 'availability': true, 'category': 'veg'},
        {'name': 'Godhi payasa', 'availability': false, 'category': 'veg'},
        {'name': 'shavide payasa', 'availability': false, 'category': 'veg'}
      ],
    };

    List<String> foodNames = [];

    foodCategories.values.forEach((foodList) {
      foodList.forEach((foodItem) {
        foodNames.add(foodItem['name']);
      });
    });

    return foodNames;
  }
  List<String> foods = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foods = getFoodNames();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color lighterColor = GlobalVariables.primaryColor.withOpacity(0.2);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Ratings",style: SafeGoogleFont(
              'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF363563),
            ),),
            SizedBox(width: 50,),
          ],
        ),
        backgroundColor: Color(0xfffbb830),
        actions: [
          Icon(Icons.settings,color: Color(0xFF363563),size: 25,),
          SizedBox(width: 40,),
          Icon(Icons.notifications_active_outlined,color: Color(0xFF363563),size: 25,),
          SizedBox(width: 40,),
          CircleAvatar(
            backgroundImage: NetworkImage("https://www.pngitem.com/pimgs/m/78-786293_1240-x-1240-0-avatar-profile-icon-png.png"),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 51,
            child: DefaultTabController(
              length: 2, // Number of tabs
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: lighterColor,
                  toolbarHeight: 1,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 400,
                          child: TabBar(
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
                              Tab(text: 'For orders'),
                              Tab(text: 'Subscriptions'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                    color: Colors.white,
                    child: DefaultTabController(
                      length: 2, // Number of tabs
                      child: Scaffold(
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
                                SizedBox(height: 15,),
            
                                SizedBox(height: 0,),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: foods.length,
                                    itemBuilder: (context, index) {
            
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedItem = foods[index];
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 5, bottom: 5),
                                              child: ListTile(
                                                title: Text(
                                                  foods[index], style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: selectedItem == foods[index] ? GlobalVariables.textColor :  GlobalVariables.textColor.withOpacity(0.5),
                                                ),),
                                                leading:  Container(
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
                                                ),
                                                // leading: Icon(Icons.grid_view_rounded, size: 10, color: selectedCategory == category
                                                //     ? Colors.white
                                                //     : GlobalVariables.textColor,),
            
                                              ),
                                            ),
                                            // Visibility(
                                            //   visible: selectedCategory == category,
                                            //   child: Column(
                                            //     crossAxisAlignment: CrossAxisAlignment
                                            //         .start,
                                            //     mainAxisAlignment: MainAxisAlignment
                                            //         .start,
                                            //     children: _buildItemsList(category,items),
                                            //   ),
                                            // ),
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
                                SizedBox(height: 15,),
            
                                SizedBox(height: 0,),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: foods.length,
                                    itemBuilder: (context, index) {
            
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedItem = foods[index];
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 5, bottom: 5),
                                              child: ListTile(
                                                title: Text(
                                                  foods[index], style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: selectedItem == foods[index] ? GlobalVariables.textColor :  GlobalVariables.textColor.withOpacity(0.5),
                                                ),),
                                                leading:  Container(
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
                                                ),
                                                // leading: Icon(Icons.grid_view_rounded, size: 10, color: selectedCategory == category
                                                //     ? Colors.white
                                                //     : GlobalVariables.textColor,),
            
                                              ),
                                            ),
                                            // Visibility(
                                            //   visible: selectedCategory == category,
                                            //   child: Column(
                                            //     crossAxisAlignment: CrossAxisAlignment
                                            //         .start,
                                            //     mainAxisAlignment: MainAxisAlignment
                                            //         .start,
                                            //     children: _buildItemsList(category,items),
                                            //   ),
                                            // ),
                                            //
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
            
                            // MealRating(),
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
                  flex: 6,
                  child:  MonthRating(),
                ),
              ],
            ),
          )

        ],
      ),
    );
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
}
