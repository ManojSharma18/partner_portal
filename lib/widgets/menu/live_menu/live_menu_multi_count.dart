import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/live_menu_1/live_menu1_event.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';

import '../../../bloc/live_menu_1/live_menu1_bloc.dart';
import '../../../bloc/live_menu_1/live_menu1_state.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/live_menu_constants/live_menu_functions.dart';
import '../../../constants/utils.dart';
import '../../responsive_builder.dart';
import 'live_menu_count2.dart';
import 'live_menu_count_multi.dart';

class LiveMenuMultiCount extends StatefulWidget {
  const LiveMenuMultiCount({super.key});

  @override
  State<LiveMenuMultiCount> createState() => _LiveMenuBreakfastCountState();
}

class _LiveMenuBreakfastCountState extends State<LiveMenuMultiCount> with TickerProviderStateMixin {

  Map<String, List<Map<String,dynamic>>> foodCategories = {};

  Map<String, List<Map<String,dynamic>>> filteredFoodCategory = {};

  String selectedItem = '';

  String hoverItem = '';

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
      begin: Offset(0, 0),
      end: Offset(-1, 0), // Move leftwards
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return BlocBuilder<LiveMenu1Bloc,LiveMenu1State>(builder: (BuildContext menuContext, liveMenuState) {
      if(liveMenuState is LiveMenu1LoadingState) {

        return MenuEditorWidget(liveMenuContext: menuContext);
      }
      if(liveMenuState is LiveMenu1ErrorState) {
        return const Center(child: Text("Error"),);
      }
      if(liveMenuState is LiveMenu1LoadedState) {
        return MenuEditorWidget(menuState: liveMenuState,liveMenuContext: menuContext);
      }
      return Center();
    },

    );
  }

  Widget MenuEditorWidget({LiveMenu1LoadedState? menuState, required BuildContext liveMenuContext}) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    if(menuState != null) {
      foodCategories = LiveMenuVariables.liveMenuNewfoodCategoriesAll;

      LiveMenuFunctions.cleanUpEmptyCategories(foodCategories);

      print("Live menu new food categories Multi $foodCategories");

      LiveMenuVariables.bfSession1Controller.text = menuState.menuItemAll['breakfastSession1'].toString() ?? '';
      LiveMenuVariables.bfSession2Controller.text = menuState.menuItemAll['breakfastSession2'].toString() ?? '';
      LiveMenuVariables.bfSession3Controller.text = menuState.menuItemAll['breakfastSession3'].toString() ?? '';

      LiveMenuVariables.lnSession1Controller.text = menuState.menuItemAll['lunchSession1'].toString() ?? '';
      LiveMenuVariables.lnSession2Controller.text = menuState.menuItemAll['lunchSession2'].toString() ?? '';
      LiveMenuVariables.lnSession3Controller.text = menuState.menuItemAll['lunchSession3'].toString() ?? '';

      LiveMenuVariables.dnSession1Controller.text = menuState.menuItemAll['dinnerSession1'].toString() ?? '';
      LiveMenuVariables.dnSession2Controller.text = menuState.menuItemAll['dinnerSession2'].toString() ?? '';
      LiveMenuVariables.dnSession3Controller.text = menuState.menuItemAll['dinnerSession3'].toString() ?? '';

      LiveMenuFunctions.calculateBreakfastTotal();
      LiveMenuFunctions.calculateLunchTotal();
      LiveMenuFunctions.calculateDinnerTotal();

      return ResponsiveBuilder(
          mobileBuilder: (BuildContext context,BoxConstraints constraints) {

            return Container();
          },
          tabletBuilder: (BuildContext context,BoxConstraints constraints) {
            return Container();
          },
          desktopBuilder: (BuildContext context,BoxConstraints constraints) {

            filteredFoodCategory = foodCategories;

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
                                          LiveMenuFunctions.addItemInLiveMulti(liveMenuContext);
                                        },
                                        child: Text("+ ADD ITEM", style: SafeGoogleFont(
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
                                      String category = filteredFoodCategory.keys.elementAt(index);
                                      List<Map<String, dynamic>> itemsList =  filteredFoodCategory[category]!;
                                      List<String> items = itemsList.map((item) => item['disName'] as String).toList();

                                      return ReorderableDragStartListener(
                                        enabled: true,
                                        key: Key(category),
                                        index: index,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedItem = '';
                                            });
                                            liveMenuContext.read<LiveMenu1Bloc>().add(SelectLiveMenuAllCategoryEvent(menuState.selectedCategoriesAll,menuState.foodCategoryAll, category));
                                          },
                                          child: Column(
                                            key: Key('$category'),
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                                color: menuState.selectedCategoriesAll.contains(category)
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
                                                      color: menuState.selectedCategoriesAll.contains(category)
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  leading: Icon(
                                                    Icons.grid_view_rounded,
                                                    size: 10,
                                                    color: menuState.selectedCategoriesAll.contains(category)
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),

                                                ),
                                              ),
                                              Visibility(
                                                visible: menuState.selectedCategoriesAll.contains(category),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: _buildItemsList(category, itemsList,menuState.selectedCategoriesAll,liveMenuContext),
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
                            body: selectedItem!= '' ?
                            LiveMenuCountMulti() :
                            Center(child: Text(' Click items within the section to view details',style: GlobalVariables.dataItemStyle,),),
                            bottomNavigationBar: Visibility(
                              visible: selectedItem!='',
                              child: Container(
                                height: 70,
                                // color: Colors.grey.shade50,
                                child: Row(
                                  children: [
                                    SizedBox(width: 20*fem,),
                                    InkWell(
                                      onTap: () {
                                       showDeleteConfirmationDialog(liveMenuContext);
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
                                        LiveMenuFunctions.updateItem(liveMenuContext, LiveMenuVariables.liveMenuNewfoodCategoriesAll,LiveMenuVariables.liveMenuSelectItemAll['tag'],LiveMenuVariables.liveMenuSelectItemAll);
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

  List<Widget> _buildItemsList(String category, List<Map<String, dynamic>> itemsList, Set<String> selectedCategories, BuildContext menuContext) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);

    bool isFirstItemAnimated = false; // Variable to track whether animation applied to the first item

    if (selectedCategories.isNotEmpty && selectedCategories.contains(category)) {
      return itemsList.asMap().map((index, item) {
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
                    _buildDismissibleItem(item['disName'], color, item, category, menuContext,index),
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
          listItem = _buildDismissibleItem(item['disName'], color, item, category, menuContext,index);
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

  Widget _buildDismissibleItem(String item, Color color,Map<String, dynamic> item1,String category,BuildContext menuContext,int index) {
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.7);
    return BlocBuilder<LiveMenu1Bloc,LiveMenu1State>(
      builder: (BuildContext context, state) {
        if(state is LiveMenu1LoadedState) {
          return Dismissible(
            key: Key(item),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
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
                  setState(() {
                    selectedItem = item;
                  });
                  menuContext.read<LiveMenu1Bloc>().add(LiveMenuAllItemSelectEvent(item1));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: LiveMenuVariables.liveMenuSelectItemAll == item1
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
                        color: LiveMenuVariables.selectedItem == item
                            ? GlobalVariables.textColor
                            : color,
                      ),
                    ),
                    leading: item1['category'] == 'NON VEG' ? Container(
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
                    )  :
                    Container(
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
                    ),
                  ),
                ),
                onHover: (isHovered) {

                },
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext liveMenuContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<LiveMenu1Bloc,LiveMenu1State>(builder: (BuildContext context, state) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Do you want to delete the item?',style: GlobalVariables.dataItemStyle),
            actions: [
              InkWell(
                onTap: () {

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
                  Map<String,dynamic> data =  {
                    "ritem_UId": LiveMenuVariables.liveMenuSelectItemAll['ritem_UId'],
                    "date": LiveMenuVariables.liveMenuSelectItemAll['date']
                  };

                  liveMenuContext.read<LiveMenu1Bloc>().add(DeleteItemEvent(data,LiveMenuVariables.liveMenuNewfoodCategoriesAll,LiveMenuVariables.liveMenuSelectItemAll['tag'],LiveMenuVariables.liveMenuSelectItemAll));
                  // Close the AlertDialog
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

}
