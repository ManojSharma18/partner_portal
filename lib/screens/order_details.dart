import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_event.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import 'package:partner_admin_portal/widgets/orders/manage/manage_subscription.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/widgets/orders/forecast/analyse_orders.dart';
import 'package:partner_admin_portal/widgets/orders/manage/manage_orderes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/global_variables.dart';
import '../constants/search_bar.dart';
import '../constants/utils.dart';
import '../provider/day_provider.dart';
import '../widgets/web_qr_scanner.dart';

class OrderDetails extends StatefulWidget {
  final int index;
  const OrderDetails({Key? key, required this.index}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;


  DateTime todday = DateTime.now();
  @override
  void initState() {
    super.initState();
    selectedDay = 'Today : ${DateFormat('dd MMM').format(today)}';
    _tabController = TabController(length: 5, vsync: this);
  }

  bool isGrid = true;
  bool isList = false;

  void setGrid(){
    setState(() {
      isGrid = true;
      isList = false;
    });
  }

  void setList(){
    setState(() {
      isGrid = false;
      isList = true;
    });
  }

  String searchedQuery = "";

  String selectedDay = '';

  DateTime today = DateTime.now();

  void showDropdownMenu(BuildContext context) async {
    String? newValue = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(450, 50, 600, 0),
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
    Color baseColor = Color(0xFF363563);
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    DayProvider dayProvider = context.watch<DayProvider>();
    Color lighterColor = baseColor.withOpacity(0.1);
    final dateProvider = context.watch<DayProvider>();
    return ResponsiveBuilder(mobileBuilder: (BuildContext context,BoxConstraints constraints)
    {
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
        body:ManageOrders(query: searchedQuery,),
      );
    }, tabletBuilder: (BuildContext context,BoxConstraints constraints){
      return Scaffold(
        appBar: AppBar(
          // toolbarHeight: 80,
          leading: Container(
            width: 20,
          ),
          title: Row(
            children: [
              Text("ORDERS DETAILS",style: SafeGoogleFont(
                'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF363563),
              ),),
              SizedBox(width: 5*fem,),
              Switch(
                  activeThumbImage: NetworkImage('https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
                  inactiveTrackColor: Colors.grey,
                  inactiveThumbImage: NetworkImage('https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
                  inactiveThumbColor: GlobalVariables.whiteColor,
                  value: GlobalVariables.isOpend, onChanged: (val){
                setState(() {
                  GlobalVariables.isOpend =val;
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
              SizedBox(width: 1*fem,),
              InkWell(
                onTap: () async {
                  String? newValue = await showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(450, 50, 600, 0),
                    items: <PopupMenuItem<String>>[
                      for (String value in ['Today:${DateFormat('dd MMM').format(today)}',
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

                  int tapCount = int.parse(newValue!.substring(6,8)) - int.parse(DateTime.now().toString().substring(8,10));

                  if (newValue != null) {
                    dayProvider.updateSelectedDayWithTapCount(newValue, tapCount);
                  }
                },
                child: Icon(Icons.arrow_drop_down_circle_outlined, color: GlobalVariables.textColor),
              ),

              InkWell(
                  onTap:()
                  {
                    dayProvider.showNextDay();
                  },
                  child: Icon(Icons.double_arrow_sharp,size: 20,color: GlobalVariables.textColor,)
              ),

              SizedBox(width: 5*fem,),

              SearchBars(hintText: "Search name or number or OID", width: 80*fem,height: 45,
                onChanged: (query) {
                  setState(() {
                    searchedQuery = query;
                  });
                },
              ),
            ],
          ),
          backgroundColor: Color(0xfffbb830),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BarcodeScannerWidget(
                              (result) {
                            // Handle the scanned result here
                            print('Scanned result: $result');
                            // You can navigate to another screen, update state, etc. based on the result
                          }
                      ),
                    ),
                  );
                },
                child: Icon(Icons.qr_code_scanner_outlined,color: Color(0xFF363563),size: 25,)),
            SizedBox(width: 5*fem,),
            Icon(Icons.notifications_active_outlined,color: Color(0xFF363563),size: 25,),
            SizedBox(width: 5*fem,),
            CircleAvatar(
              backgroundImage: NetworkImage("https://www.pngitem.com/pimgs/m/78-786293_1240-x-1240-0-avatar-profile-icon-png.png"),
            ),
            SizedBox(width: 5*fem,)
          ],
        ),
        body:  widget.index == 1
      ? DefaultTabController(
      length: 2, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: lighterColor,
            toolbarHeight: 1,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: Row(
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
                        Tab(text: "For orders",),
                        Tab(text: "Subscription",)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              ManageOrders(query: searchedQuery,),
              ManageSubscription()
            ],
          ),
        ),
      )
          : AnalyseOrders(),


      );

    }, desktopBuilder: (BuildContext context,BoxConstraints constraints){
      return BlocBuilder<OrderBloc,OrderState>(
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar : AppBar(
              // toolbarHeight: 80,
              leading: Container(),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.index == 1 ? "MANAGE ORDERS" : "FORECAST",style: SafeGoogleFont(
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
                      value: GlobalVariables.isOpend, onChanged: (val){
                    context.read<OrderBloc>().add(SwitchEvent(GlobalVariables.isOpend));
                  }),
                  SizedBox(width: 20,),
                  // InkWell(
                  //     onTap:()
                  //     {
                  //       dateProvider.showPreviousDay();
                  //     },
                  //     child: Icon(Icons.keyboard_double_arrow_left_rounded,size: 20,color: GlobalVariables.textColor,)
                  // ),
                  SizedBox(width: 5,),
                  Container(
                    width: 110,
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
                  SizedBox(width: 5,),
                  InkWell(
                    onTap: () async {
                      String? newValue = await showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(450, 50, 600, 0),
                        items: <PopupMenuItem<String>>[
                          for (String value in ['Today:${DateFormat('dd MMM').format(today)}',
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

                      int tapCount = int.parse(newValue!.substring(6,8)) - int.parse(DateTime.now().toString().substring(8,10));

                      if (newValue != null) {
                        dayProvider.updateSelectedDayWithTapCount(newValue, tapCount);
                      }
                    },
                    child: Icon(Icons.arrow_drop_down_circle_outlined, color: GlobalVariables.textColor),
                  ),
                  SizedBox(width: 5,),
                  InkWell(
                      onTap:()
                      {
                        dayProvider.showNextDay();
                      },
                      child: Icon(Icons.double_arrow_sharp,size: 20,color: GlobalVariables.textColor,)
                  ),
                  SizedBox(width: 50,),
                  SearchBars(hintText: "Search name or mobile or OID", width: MediaQuery.of(context).size.width/3.3,height: 45,
                    onChanged: (query){
                      setState(() {
                        searchedQuery = query;
                      });
                    },),
                ],
              ),
              backgroundColor: Color(0xfffbb830),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BarcodeScannerWidget(
                                (result) {
                              // Handle the scanned result here
                              print('Scanned result: $result');
                              // You can navigate to another screen, update state, etc. based on the result
                            }
                        ),
                      ),
                    );
                  },
                    child: Icon(Icons.qr_code_scanner_outlined,color: Color(0xFF363563),size: 25,)),
                SizedBox(width: 40,),
                Icon(Icons.notifications_active_outlined,color: Color(0xFF363563),size: 25,),
                SizedBox(width: 40,),
                CircleAvatar(
                  backgroundImage: NetworkImage("https://www.pngitem.com/pimgs/m/78-786293_1240-x-1240-0-avatar-profile-icon-png.png"),
                ),
                SizedBox(width: 20,)
              ],
            ),
            body : widget.index == 1
                ? DefaultTabController(
              length: 2, // Number of tabs
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: lighterColor,
                  toolbarHeight: 1,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50.0),
                    child: Row(
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
                              Tab(text: "For orders",),
                              Tab(text: "Subscription",)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  children: [
                    ManageOrders(query: searchedQuery,),
                    ManageSubscription()
                  ],
                ),
              ),
            )
                : AnalyseOrders(),
          );
        },
      );
    });
  }
}
