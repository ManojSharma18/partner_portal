import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/widgets/item_availability.dart';
import 'package:partner_admin_portal/widgets/item_details.dart';

import '../constants/custom_textfield.dart';
import '../constants/utils.dart';

class MenuEditor extends StatefulWidget {
  const MenuEditor({Key? key}) : super(key: key);

  @override
  State<MenuEditor> createState() => _MenuEditorState();
}

class _MenuEditorState extends State<MenuEditor> with TickerProviderStateMixin {
  late TabController _tabController;

  bool switchValue = false;
  String selectedCategory = 'Starters';

  String selectedItem = '';

  void updateSelectedItem(String newItem) {
    setState(() {
      selectedItem = newItem;
    });
  }



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


  Map<String, List<String>> foodCategories = {
    'Starters': [
      'Chicken Kabab',
      'Chicken Fry',
      'Vegetable Spring Rolls'
    ],
    'Drinks': ['Cola', 'Orange Juice', 'Coffee', 'Tea'],
    'Rice': ['Boiled Rice', 'Biriyani Rice', 'Egg Rice',]
  };

  bool isFirstItemDeleted = false;
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
      begin: Offset(0,0),
      end: Offset(-1, 0), // Move leftwards
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _simulateDeleteAnimationForFirstItem();
    });
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    print("Selected $selectedItem");
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
                                onTap: _showAddItemCategory,
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
                                              onTap:(){
                                                _showPopupMenu(context);
                                              },
                                              child: Icon(Icons.more_vert, color: selectedCategory == category
                                                  ? Colors.white
                                                  : Colors.black,
                                              ),
                                            ),
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
                                  ],
                                ),
                              );
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

                Container(
                  color: Colors.black26,
                  width: 1,
                ),
                Expanded(
                  flex: 5,
                  child: DefaultTabController(
                    length: 5, // Number of tabs
                    child: Scaffold(
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
                            Tab(text: 'Item details'),
                            Tab(text: 'Pricing'),
                            Tab(text: 'Availability'),
                            Tab(text: 'Add on'),
                            Tab(text: 'Variants'),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        controller: _tabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          // Content for Tab 1
                          // Content for Tab 1
                          ItemDetails(name: selectedItem, updateSelectedItem: updateSelectedItem),


                          // Content for Tab 2
                          Center(child: Text('Tab 2 Content')),

                          // Content for Tab 3
                          ItemAvailability(),

                          // Content for Tab 4
                          Center(child: Text('Tab 4 Content')),

                          // Content for Tab 5
                          Center(child: Text('Tab 5 Content')),
                        ],
                      ),
                      bottomNavigationBar: Visibility(
                        visible: selectedItem!='',
                        child: Padding(
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
                                      "Delete item",
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
                                label: '',
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
  }

  void _showPopupMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          Offset.zero,
          overlay.localToGlobal(overlay.size.bottomRight(Offset.zero)),
        ),
        Offset.fromDirection(19) & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'Edit',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
          ),
        ),
      ],
    ).then((String? value) {
      if (value == 'Edit') {
        _handleEditOption('Selected Category');
      } else if (value == 'Delete') {
        _handleDeleteOption('Selected Category');
      }
    });
  }

  void _handleEditOption(String category) {
    // Implement edit logic
    print('Edit category: $category');
  }

  void _handleDeleteOption(String category) {
    // Implement delete logic
    print('Delete category: $category');
  }

  List<Widget> _buildItemsList(String category, List<String> items) {
    Color color = GlobalVariables.textColor.withOpacity(0.7);

    bool isFirstItemAnimated = false; // Variable to track whether animation applied to the first item

    if (selectedCategory.isNotEmpty &&
        foodCategories.containsKey(selectedCategory)) {
      return foodCategories[selectedCategory]!
          .map((item) {
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
                    _buildDismissibleItem(item, color),
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
          listItem = _buildDismissibleItem(item, color);
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
        _showDeleteConfirmationDialog(item);
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
          updateSelectedItem(item);
        },
        child: Container(
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(5)
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
                color: color,
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
            leading: Icon(Icons.grid_view_rounded, size: 10, color: color),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Do you want to delete the item?'),
          actions: [
            TextButton(
              onPressed: () {
                // Reinsert the deleted item back into the list
                setState(() {
                  foodCategories[selectedCategory]!.add(item);
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
  }

  void _showDeleteAnimation(String item) {

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

  void _showAddItemCategory() {
    TextEditingController item = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            title: Text('Adding new Category'),
            content: Container(
              height: 350,
              width: 400,
              child: Column(
                children: [
                  CustomTextField(label: 'Search for Category',
                    width: 400,
                    controller: item,
                    dropdownItems: ['South Indian','North indian','Sri lankan','Afganistani'],
                    isDropdown: true,
                    showSearchBox1: true,
                    dropdownAuto: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Couldn't find category",style:  SafeGoogleFont(
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
                  Map<String, List<String>> category = {
                    item.text: [],
                  };
                  setState(() {
                    foodCategories.addAll(category);
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

  void _simulateDeleteAnimationForFirstItem() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (foodCategories.isNotEmpty) {
        String firstCategory = foodCategories.keys.first;
        List<String> firstItems = foodCategories[firstCategory] ?? [];

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
}
