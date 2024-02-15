import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/responsive_builder.dart';
import 'package:partner_admin_portal/provider/day_provider.dart';
import 'package:partner_admin_portal/widgets/live_menu.dart';
import 'package:partner_admin_portal/widgets/menu_editor.dart';
import 'package:provider/provider.dart';

import '../constants/custom_textfield.dart';
import '../constants/search_bar.dart';
import '../constants/utils.dart';

class MenuDetails extends StatefulWidget {
  const MenuDetails({Key? key}) : super(key: key);

  @override
  State<MenuDetails> createState() => _MenuDetailsState();
}

class _MenuDetailsState extends State<MenuDetails> with TickerProviderStateMixin {

  late TabController _tabController;


  String selectedDay = '';
  @override
  void initState() {
    super.initState();
    String selectedCategory = '';
    selectedDay = 'Today : ${DateFormat('dd MMM').format(today)}';
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  bool isOpend = true;
  DateTime today = DateTime.now();


  DropdownButton<String> dropDownDays()
  {
    print("I am here");
    DateTime tomorrow = today.add(Duration(days: 1));
    return DropdownButton<String>(
      value: selectedDay,
      onChanged: (String? newValue) {
        setState(() {
          selectedDay = newValue!;
        });
      },
      items: <String>['Today ${DateFormat('dd MMM').format(today)}','Option 1', 'Option 2', 'Option 3', 'Option 4']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  showDropdownMenu(BuildContext context) async {

    String? newValue = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(2, 0, 0, 0),
      items: <PopupMenuItem<String>>[
        for (String value in ['Today : ${DateFormat('dd MMM').format(today)}',
          '${DateFormat('EEE').format(today.add(Duration(days: 1)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 1)))}',
          '${DateFormat('EEE').format(today.add(Duration(days: 2)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 2)))}',
          '${DateFormat('EEE').format(today.add(Duration(days: 3)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 3)))}',
          '${DateFormat('EEE').format(today.add(Duration(days: 4)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 4)))}',
          '${DateFormat('EEE').format(today.add(Duration(days: 5)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 5)))}',
          '${DateFormat('EEE').format(today.add(Duration(days: 6)))} : ${DateFormat('dd MMM').format(today.add(Duration(days: 6)))}'])
          PopupMenuItem<String>(
            value: value,
            child: Text(value,style: SafeGoogleFont(
              'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF363563),
            ),),
          ),
      ],
    );

    if (newValue != null) {
      setState(() {
        selectedDay = newValue;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('dd MMM').format(currentDate);
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.2);
    DayProvider dayProvider = context.watch<DayProvider>();
    return ResponsiveBuilder(mobileBuilder: (BuildContext context,BoxConstraints constraints){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
          title: Row(
            children: [
              Text( selectedDay,style:SafeGoogleFont(
                'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF363563),
              ),),
              SizedBox(width: 10,),
              InkWell(
                onTap: () {
                  showDropdownMenu(context);
                },
                child: Icon(Icons.arrow_drop_down_circle_outlined, color: GlobalVariables.textColor),
              )

            ],
          ),
        ),
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
              bottom: PreferredSize(preferredSize:Size.fromHeight(50),
                child: TabBar(
                  indicatorColor: GlobalVariables.primaryColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle:SafeGoogleFont(
                    'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF363563),
                  ),
                  tabs:
                [
                  Tab(text: 'For Orders',),
                  Tab(text: 'Susbscription',)
                ],

                ),

              ),

            ),
            body: TabBarView(
              children: [
                LiveMenu(),
                Column()
              ],
            ),
          ),
        ),
      );
    }, tabletBuilder:(BuildContext context,BoxConstraints constraints){
      return Scaffold(
        appBar: AppBar(
          // toolbarHeight: 80,
          title: Row(
            children: [
              Text("MENU DETAILS",style: SafeGoogleFont(
                'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF363563),
              ),),
              SizedBox(width: 5*fem,),
              Switch(
                  activeThumbImage: NetworkImage('https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
                  inactiveTrackColor: GlobalVariables.whiteColor,
                  inactiveThumbImage: NetworkImage('https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
                  inactiveThumbColor: Colors.grey,
                  activeTrackColor: Colors.green,
                  value: isOpend, onChanged: (val){
                setState(() {
                  isOpend =val;
                });
              }),
              SizedBox(width: 5*fem,),
              Container(

                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(child: Text("${dayProvider.selectedDay}",style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF363563),
                    ),)),
                  )
              ),
              SizedBox(width: 5*fem,),
              SearchBars(hintText: "Search....", width:50*fem,height: 75,),
            ],
          ),
          backgroundColor: Color(0xfffbb830),
          // bottom:  PreferredSize(
          //   preferredSize: Size.fromHeight(0),
          //   child: Padding(
          //     padding: const EdgeInsets.only(bottom: 8.0),
          //     child: Row(
          //       children: [
          //
          //       ],
          //     ),
          //   ),
          // ),
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
        body: DefaultTabController(
          length: 3, // Number of tabs
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: lighterColor,
              toolbarHeight: 1,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: Row(
                  children: [
                    Container(
                      width: 600,
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
                          Tab(text: 'Live Menu'),
                          Tab(text: 'Menu Editor'),
                          Tab(text: 'Menu History'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                // First tab: Item Availability
                LiveMenu(),

                // Second tab: Menu Editor
                MenuEditor(),

                // Third tab: History of Menu Changes
                Container(
                  child: Center(
                    child: Text('History of Menu Changes Tab Content'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      },
        desktopBuilder: (BuildContext context,BoxConstraints constraints){
          return Scaffold(
            appBar: AppBar(
              // toolbarHeight: 80,
              title: Row(
                children: [
                  Text("MENU DETAILS",style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF363563),
                  ),),
                  SizedBox(width: 50,),
                  Switch(
                     activeThumbImage: NetworkImage('https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
                      inactiveTrackColor: Colors.grey,
                      inactiveThumbImage: NetworkImage('https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
                      inactiveThumbColor: GlobalVariables.whiteColor,
                      value: isOpend, onChanged: (val){
                    setState(() {
                      isOpend =val;
                    });
                  }),
                  SizedBox(width: 50,),
                  Container(

                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(child: Text("${dayProvider.selectedDay}",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF363563),
                        ),)),
                      )
                  ),
                  SizedBox(width: 50,),
                  SearchBars(hintText: "Search....", width: MediaQuery.of(context).size.width/3,height: 75,),
                ],
              ),
              backgroundColor: Color(0xfffbb830),
              // bottom:  PreferredSize(
              //   preferredSize: Size.fromHeight(0),
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom: 8.0),
              //     child: Row(
              //       children: [
              //
              //       ],
              //     ),
              //   ),
              // ),
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
            body: DefaultTabController(
              length: 3, // Number of tabs
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: lighterColor,
                  toolbarHeight: 1,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50.0),
                    child: Row(
                      children: [
                        Container(
                          width: 600,
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
                              Tab(text: 'Live Menu'),
                              Tab(text: 'Menu Editor'),
                              Tab(text: 'Menu History'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  children: [
                    // First tab: Item Availability
                    LiveMenu(),

                    // Second tab: Menu Editor
                    MenuEditor(),

                    // Third tab: History of Menu Changes
                    Container(
                      child: Center(
                        child: Text('History of Menu Changes Tab Content'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }, );
  }

}
