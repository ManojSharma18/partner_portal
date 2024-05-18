import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/bloc/menu/menu_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/provider/day_provider.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu.dart';
import 'package:partner_admin_portal/widgets/menu/menu_editor/menu_editor.dart';
import 'package:partner_admin_portal/widgets/menu_subscription_mobile.dart';
import 'package:provider/provider.dart';

import '../bloc/menu/menu_bloc.dart';
import '../bloc/menu/menu_event.dart';
import '../repository/menu_services.dart';
import '../widgets/custom_textfield.dart';
import '../constants/search_bar.dart';
import '../constants/utils.dart';

class MenuDetails extends StatefulWidget {
  final int index;
  const MenuDetails({Key? key, required this.index}) : super(key: key);

  @override
  State<MenuDetails> createState() => _MenuDetailsState();
}

class _MenuDetailsState extends State<MenuDetails> with TickerProviderStateMixin {

  late TabController _tabController;


  String selectedDay = '';

  String searchQuery = '';

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

  bool subscribed = false;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    final dateProvider = context.watch<DayProvider>();
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('dd MMM').format(currentDate);
    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.2);
    DayProvider dayProvider = context.watch<DayProvider>();
    return BlocProvider(
      create: (BuildContext context) => MenuBloc(
          MenuService()
      )..add(LoadMenuEvent(context)),
      child: BlocBuilder<MenuBloc,MenuState>(builder: (BuildContext context, state) {
      if(state is MenuLoadingState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if(state is ErrorState) {
        return const Center(child: Text("Node server error"),);
      }
      if(state is MenuLoadedState) {
        return ResponsiveBuilder(
          mobileBuilder: (BuildContext context, BoxConstraints constraints) {
            return widget.index == 1 ? Scaffold(
              appBar: AppBar(
                backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
                title: Row(
                  children: [
                    Text(selectedDay, style: SafeGoogleFont(
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
                      child: Icon(Icons.arrow_drop_down_circle_outlined,
                          color: GlobalVariables.textColor),
                    ),
                    SizedBox(width: 25,),
                    Switch(value: subscribed, onChanged: (val) {
                      setState(() {
                        subscribed = !subscribed;
                      });
                    },
                      activeThumbImage: AssetImage(
                          "assets/images/icons8-s-50.png"),

                    )
                  ],
                ),
              ),
              body: subscribed
                  ? DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 0,
                    backgroundColor: GlobalVariables.primaryColor.withOpacity(
                        0.2),
                    bottom: PreferredSize(preferredSize: Size.fromHeight(50),
                      child: TabBar(
                        indicatorColor: GlobalVariables.primaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF363563),
                        ),
                        tabs:
                        [
                          Tab(text: 'Subscription',),
                          Tab(text: 'For Orders',),
                        ],

                      ),

                    ),

                  ),
                  body: TabBarView(
                    children: [
                      MenuSubscriptionMobile(),
                      LiveMenu(searchQuery: '',),
                    ],
                  ),
                ),
              )
                  : DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 0,
                    backgroundColor: GlobalVariables.primaryColor.withOpacity(
                        0.2),
                    bottom: PreferredSize(preferredSize: Size.fromHeight(50),
                      child: TabBar(
                        indicatorColor: GlobalVariables.primaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF363563),
                        ),
                        tabs:
                        [
                          Tab(text: 'For Orders',),
                          Tab(text: 'Subscription',)
                        ],

                      ),

                    ),

                  ),
                  body: TabBarView(
                    children: [
                      LiveMenu(searchQuery: '',),
                      MenuSubscriptionMobile()
                    ],
                  ),
                ),
              ),

            ) : Scaffold(
              appBar: AppBar(
                backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
                title: Row(
                  children: [
                    Text(selectedDay, style: SafeGoogleFont(
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
                      child: Icon(Icons.arrow_drop_down_circle_outlined,
                          color: GlobalVariables.textColor),
                    )

                  ],
                ),
              ),
              body: MenuEditor(searchQuery: searchQuery,),

            );
          }, tabletBuilder: (BuildContext context, BoxConstraints constraints) {
          return Scaffold(
            appBar: AppBar(
              // toolbarHeight: 80,
              leading: Container(),
              title: Row(
                children: [
                  Text("MENU DETAILS", style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF363563),
                  ),),
                  SizedBox(width: 5 * fem,),
                  Switch(
                      activeThumbImage: NetworkImage(
                        'https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
                      inactiveTrackColor: Colors.grey,
                      inactiveThumbImage: NetworkImage(
                        'https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
                      inactiveThumbColor: GlobalVariables.whiteColor,
                      value: isOpend,
                      onChanged: (val) {
                        setState(() {
                          isOpend = val;
                        });
                      }),
                  SizedBox(width: 5 * fem,),
                  Container(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(child: Text(
                          "${dayProvider.selectedDay}", style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF363563),
                        ),)),
                      )
                  ),
                  SizedBox(width: 5 * fem,),
                  SearchBars(hintText: "Search item",
                    width: 100 * fem,
                    height: 45,
                    onChanged: (val) {
                      setState(() {
                        searchQuery = val;
                      });
                    },),
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
                Icon(Icons.settings, color: Color(0xFF363563), size: 25,),
                SizedBox(width: 40,),
                Icon(
                  Icons.notifications_active_outlined, color: Color(0xFF363563),
                  size: 25,),
                SizedBox(width: 40,),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://www.pngitem.com/pimgs/m/78-786293_1240-x-1240-0-avatar-profile-icon-png.png"),
                ),
                SizedBox(width: 20,)
              ],
            ),
            body: widget.index == 1 ? DefaultTabController(
              length: 7, // Number of tabs
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: lighterColor,
                  toolbarHeight: 1,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50.0),
                    child: Row(
                      children: [
                        Container(
                          width: 300 * fem,
                          child: TabBar(
                            labelPadding: EdgeInsets.symmetric(horizontal: 5),
                            indicatorWeight: 5,
                            // Adjust the indicator weight
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
                              // Tab(text: 'Live Menu'),
                              // Tab(text: 'Menu Editor'),
                              // Tab(text: 'Menu History'),

                              for (int i = 0; i < 7; i++)
                                i == 0
                                    ? Tab(
                                  text: "Today : ${DateFormat('dd MMM').format(
                                      DateTime.now().add(Duration(days: i)))} ",
                                )
                                    : Tab(
                                  text: "${DateFormat('E').format(
                                      DateTime.now().add(
                                          Duration(days: i)))} : ${DateFormat(
                                      'dd MMM').format(
                                      DateTime.now().add(Duration(days: i)))} ",
                                ),

                            ],
                            onTap: (index) {
                              dateProvider.updateSelectedDay(
                                  '${DateFormat('E').format(DateTime.now().add(
                                      Duration(days: index)))} : ${DateFormat(
                                      'dd MMM').format(DateTime.now().add(
                                      Duration(days: index)))}');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  children: [
                    // First tab: Item Availability
                    LiveMenu(searchQuery: searchQuery,),
                    LiveMenu(searchQuery: searchQuery,),
                    LiveMenu(searchQuery: searchQuery,),
                    LiveMenu(searchQuery: searchQuery,),
                    LiveMenu(searchQuery: searchQuery,),
                    LiveMenu(searchQuery: searchQuery,),
                    LiveMenu(searchQuery: searchQuery,),
                    // Second tab: Menu Editor

                  ],
                ),
              ),
            )
                : DefaultTabController(
              length: 1, // Number of tabs
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: lighterColor,
                  toolbarHeight: 1,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(0.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          child: TabBar(
                            labelPadding: EdgeInsets.symmetric(horizontal: 5),
                            indicatorWeight: 5,
                            // Adjust the indicator weight
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
                              Tab(text: ''),

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
                    MenuEditor(searchQuery: searchQuery,)
                    // Second tab: Menu Editor

                  ],
                ),
              ),
            ),
          );
        },
          desktopBuilder: (BuildContext context, BoxConstraints constraints) {
            return Scaffold(
              appBar: AppBar(
                // toolbarHeight: 80,
                leading: Container(),
                title: Row(
                  children: [
                    SizedBox(width: 5 * fem,),
                    Container(
                        width: 30 * fem,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(child: Text(
                            "${dayProvider.selectedDay}", style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF363563),
                          ),)),
                        )
                    ),
                    SizedBox(width: 0 * fem,),
                    InkWell(
                      onTap: () async {
                        String? newValue = await showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(200, 50, 600, 0),
                          items: <PopupMenuItem<String>>[
                            for (String value in [
                              '${DateFormat('EEE').format(today.add(Duration(days: 0)))} :${DateFormat('dd MMM').format(today)}',
                              '${DateFormat('EEE').format(today.add(Duration(days: 1)))} : ${DateFormat(
                                  'dd MMM').format(
                                  today.add(Duration(days: 1)))}',
                              '${DateFormat('EEE').format(
                                  today.add(Duration(days: 2)))} : ${DateFormat(
                                  'dd MMM').format(
                                  today.add(Duration(days: 2)))}',
                              '${DateFormat('EEE').format(
                                  today.add(Duration(days: 3)))} : ${DateFormat(
                                  'dd MMM').format(
                                  today.add(Duration(days: 3)))}',
                              '${DateFormat('EEE').format(
                                  today.add(Duration(days: 4)))} : ${DateFormat(
                                  'dd MMM').format(
                                  today.add(Duration(days: 4)))}',
                              '${DateFormat('EEE').format(
                                  today.add(Duration(days: 5)))} : ${DateFormat(
                                  'dd MMM').format(
                                  today.add(Duration(days: 5)))}',
                              '${DateFormat('EEE').format(
                                  today.add(Duration(days: 6)))} : ${DateFormat(
                                  'dd MMM').format(
                                  today.add(Duration(days: 6)))}'
                            ])
                              PopupMenuItem<String>(
                                value: value,
                                child: Text(value, style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF363563),
                                ),),
                              ),
                          ],
                        );

                        int tapCount = int.parse(newValue!.substring(6, 8)) -
                            int.parse(
                                DateTime.now().toString().substring(8, 10));

                        if (newValue != null) {
                          dayProvider.updateSelectedDayWithTapCount(newValue, tapCount);
                          context.read<MenuBloc>().add(MenuDateSelectEvent(dayProvider.selectedDay));
                        }
                      },
                      child: Icon(Icons.arrow_drop_down_circle_outlined,
                          color: GlobalVariables.textColor),
                    ),
                    SizedBox(width: 2 * fem,),
                    InkWell(
                        onTap: () {
                          dayProvider.showNextDay();
                          context.read<MenuBloc>().add(MenuDateSelectEvent(dayProvider.selectedDay));
                        },
                        child: Icon(Icons.double_arrow_sharp, size: 20,
                          color: GlobalVariables.textColor,)
                    ),
                    SizedBox(width: 15 * fem,),

                    Switch(
                        activeThumbImage: NetworkImage(
                          'https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbImage: NetworkImage(
                          'https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
                        inactiveThumbColor: GlobalVariables.whiteColor,
                        value: isOpend,
                        onChanged: (val) {
                          setState(() {
                            isOpend = val;
                          });
                        }),
                    SizedBox(width: 15 * fem,),

                    SearchBars(hintText: "Search item",
                      width: 100 * fem,
                      height: 45,
                      onChanged: (val) {
                        setState(() {
                          searchQuery = val;
                        });
                      },

                    ),
                  ],
                ),
                backgroundColor: Color(0xfffbb830),
                actions: [
                  Icon(Icons.settings, color: Color(0xFF363563), size: 25,),
                  SizedBox(width: 40,),
                  Icon(Icons.notifications_active_outlined,
                    color: Color(0xFF363563), size: 25,),
                  SizedBox(width: 40,),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://www.pngitem.com/pimgs/m/78-786293_1240-x-1240-0-avatar-profile-icon-png.png"),
                  ),
                  SizedBox(width: 20,)
                ],
              ),
              body: widget.index == 1 ? DefaultTabController(
                length: 7, // Number of tabs
                child: LiveMenu(searchQuery: searchQuery,),
              )
                  : DefaultTabController(
                length: 1, // Number of tabs
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: lighterColor,
                    toolbarHeight: 1,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(0.0),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            child: TabBar(
                              labelPadding: EdgeInsets.symmetric(horizontal: 5),
                              indicatorWeight: 5,
                              // Adjust the indicator weight
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
                                Tab(text: ''),

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
                      MenuEditor(searchQuery: searchQuery,)
                      // Second tab: Menu Editor

                    ],
                  ),
                ),
              ),
            );
          },);
      }
      return Container();
      },

      ),
    );
  }

}
