import 'package:flutter/material.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_state.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_functions.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/search_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/live_menu/live_menu_bloc.dart';
import '../../../bloc/live_menu/live_menu_event.dart';
import '../../../bloc/menu/menu_bloc.dart';
import '../../../bloc/menu/menu_state.dart';
import '../../../bloc/menu_editor/menu_editor_bloc.dart';
import '../../../bloc/menu_editor/menu_editor_event.dart';
import '../../../constants/global_function.dart';
import '../../../constants/menu_editor_constants/menu_editor_functions.dart';
import '../../../constants/menu_editor_constants/menu_editor_variables.dart';
import '../../../constants/utils.dart';
import 'live_menu.dart';

class SubscriptionMobile extends StatefulWidget {
  final Set<String> selectedCategories;
  Map<String, List<Map<String,dynamic>>> filteredFoodCategory;
  SubscriptionMobile({Key? key, required this.selectedCategories, required this.filteredFoodCategory}) : super(key: key);

  @override
  State<SubscriptionMobile> createState() => _SubscriptionMobileState();
}

class _SubscriptionMobileState extends State<SubscriptionMobile> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return BlocBuilder<LiveMenuBloc,LiveMenuState>(builder: (BuildContext context, state) {
      return  BlocBuilder<OrderBloc,OrderState>(builder: (BuildContext context, orderState)
      {
        return Column(
          children: [
            SearchBars(hintText: "Search", width: 350*fem,height: 45,onChanged: (subQuery){
              if (subQuery != "") {
                LiveMenuVariables.filteredFoodCategory = {};

                LiveMenuVariables.filteredFoodCategory.forEach((cuisine, items) {
                  List<Map<String, dynamic>> matchingItems = items
                      .where((item) => item['name'].toLowerCase().contains(subQuery.toLowerCase()))
                      .toList();

                  if (matchingItems.isNotEmpty) {
                    state.selectedCategories.add(cuisine);
                    LiveMenuVariables.filteredFoodCategory[cuisine] = matchingItems;
                  }
                });
              }
              else{
                LiveMenuVariables.filteredFoodCategory = {};
                //selectedCategories = {};
                state.selectedCategories.add('South indian breakfast');
              }
            },),
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                child: DefaultTabController(
                  length: 3,
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
                              width: 350*fem,
                              child: TabBar(
                                isScrollable: false,
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelPadding: EdgeInsets.symmetric(horizontal: 5),
                                indicatorColor: Color(0xfffbb830),
                                unselectedLabelColor: Colors.black54,
                                labelColor: Color(0xFF363563),
                                labelStyle: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 13,
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
                                          itemCount: widget.filteredFoodCategory.length,
                                          itemBuilder: (context, index) {
                                            print("object");
                                            String category = widget.filteredFoodCategory.keys.elementAt(index);
                                            List<Map<String, dynamic>> itemsList =  widget.filteredFoodCategory[category]!;
                                            List<String> items = itemsList.map((item) => item['disName'] as String).toList();


                                            return ReorderableDragStartListener(
                                              enabled: true,
                                              key: Key(category),
                                              index: index,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {

                                                    MenuEditorVariables.selectedItem = "";

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
                                                        trailing: InkWell(
                                                          onTap: () {
                                                            // MenuEditorFunction.showAddItemCategory(menuContext,context,foodCategories);
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
                                                            Row(
                                                              children: [
                                                                Text(
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
                                                              ],
                                                            ),


                                                          ],
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
                                ),
                              ),



                            ],
                          ),
                        ),
                        Column(),
                        Column(),


                      ],
                    ),
                  ),
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

  List<Widget> _buildItemsList(String category, List<Map<String, dynamic>> itemsList,Set<String> selectedCategories) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);


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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              padding: EdgeInsets.only(left: 13),
              child: ListTile(
                title: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30*fem,
                          child: Text(
                            item,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color:
                                   color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 47*fem,),
                        Container(
                          width: 50,
                          child: Text(
                            "5",
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color
                                  : color,
                            ),
                          ),
                        ),
                        SizedBox(width: 5*fem,),
                        Container(
                          width: 50,
                          child: Text(
                            "5",
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color
                                  : color,
                            ),
                          ),
                        ),
                        SizedBox(width: 5*fem,),
                        Container(
                          width: 50,
                          child: Text(
                            "5",
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
}
