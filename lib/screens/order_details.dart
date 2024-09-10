import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import 'package:partner_admin_portal/bloc/orders/orders_bloc.dart';
import 'package:partner_admin_portal/bloc/orders/orders_state.dart';
import 'package:partner_admin_portal/constants/global_function.dart';
import 'package:partner_admin_portal/constants/order_constants/order_funtions.dart';
import 'package:partner_admin_portal/constants/order_constants/order_variables.dart';
import 'package:partner_admin_portal/widgets/holiday_mob.dart';
import 'package:partner_admin_portal/widgets/orders/manage/manage_subscription.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/widgets/orders/forecast/analyse_orders.dart';
import 'package:partner_admin_portal/widgets/orders/manage/manage_orderes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/orders/orders_event.dart';
import '../constants/global_variables.dart';
import '../constants/search_bar.dart';
import '../constants/utils.dart';
import '../provider/day_provider.dart';
import '../repository/order_service.dart';
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
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF363563),
              ),),
              SizedBox(width: 10,),
              InkWell(
                onTap: () {
                  showDropdownMenu(context);
                },
                child: Icon(Icons.arrow_drop_down_circle_outlined, color: GlobalVariables.textColor),
              ),


            ],
          ),
          actions: [
            Switch(
                activeThumbImage: NetworkImage(
                  'https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
                inactiveTrackColor: Colors.grey,
                inactiveThumbImage: NetworkImage(
                  'https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
                inactiveThumbColor: GlobalVariables.whiteColor,
                value: GlobalVariables.isOpend,
                onChanged: (val) {
                  setState(() {
                    GlobalVariables.isOpend = val;
                  });
                }),
            SizedBox(width: 10,),
            InkWell(
              onTap: (){
                // _showHolidayPopupMenu(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => HolidayPage()));
              },
              child: Image.asset(
                'assets/images/holidaynew.png',
                width: 25,
                height: 25,color: GlobalVariables.textColor,
              ),
            ),
            SizedBox(width: 10,),
          ],
        ),
        body:ManageOrders(query: searchedQuery,),
      );
    },  tabletBuilder: (BuildContext context,BoxConstraints constraints){
      return BlocProvider(
        create: (BuildContext context) => OrdersBloc(
            OrderService()
        )..add(LoadOrdersEvent()),
        child: BlocBuilder<OrdersBloc,OrdersState>(builder: (BuildContext context, OrdersState orderState) {
          if(orderState is OrdersLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(orderState is OrderErrorState) {
            return const Center(child: Text("Node server error"),);
          }
          if(orderState is OrdersLoadedState) {
            return Scaffold(
              appBar: AppBar(
                // toolbarHeight: 80,
                leading: Container(
                  width: 20,
                ),
                title: Row(
                  children: [
                    Text("ORDERS DETAILS", style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF363563),
                    ),),

                    SizedBox(width: 5 * fem,),
                    Container(

                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(child: Text(
                            "${dayProvider.selectedDay}", style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF363563),
                          ),)),
                        )
                    ),
                    SizedBox(width: 1 * fem,),
                    InkWell(
                      onTap: () async {
                        String? newValue = await showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(450, 50, 600, 0),
                          items: <PopupMenuItem<String>>[
                            for (String value in [
                              'Today:${DateFormat('dd MMM').format(today)}',
                              '${DateFormat('EEE').format(
                                  today.add(Duration(days: 1)))} : ${DateFormat(
                                  'dd MMM').format(today.add(Duration(days: 1)))}',
                              '${DateFormat('EEE').format(
                                  today.add(Duration(days: 2)))} : ${DateFormat(
                                  'dd MMM').format(today.add(Duration(days: 2)))}',
                              '${DateFormat('EEE').format(
                                  today.add(Duration(days: 3)))} : ${DateFormat(
                                  'dd MMM').format(today.add(Duration(days: 3)))}',
                              '${DateFormat('EEE').format(
                                  today.add(Duration(days: 4)))} : ${DateFormat(
                                  'dd MMM').format(today.add(Duration(days: 4)))}',
                              '${DateFormat('EEE').format(
                                  today.add(Duration(days: 5)))} : ${DateFormat(
                                  'dd MMM').format(today.add(Duration(days: 5)))}',
                              '${DateFormat('EEE').format(
                                  today.add(Duration(days: 6)))} : ${DateFormat(
                                  'dd MMM').format(today.add(Duration(days: 6)))}'
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
                            int.parse(DateTime.now().toString().substring(8, 10));

                        if (newValue != null) {
                          dayProvider.updateSelectedDayWithTapCount(
                              newValue, tapCount);
                        }
                      },
                      child: Icon(Icons.arrow_drop_down_circle_outlined,
                          color: GlobalVariables.textColor),
                    ),

                    InkWell(
                        onTap: () {
                          dayProvider.showNextDay();
                        },
                        child: Icon(Icons.double_arrow_sharp, size: 20,
                          color: GlobalVariables.textColor,)
                    ),

                    SizedBox(width: 5 * fem,),
                    Switch(
                        activeThumbImage: NetworkImage(
                          'https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbImage: NetworkImage(
                          'https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
                        inactiveThumbColor: GlobalVariables.whiteColor,
                        value: GlobalVariables.isOpend,
                        onChanged: (val) {
                          setState(() {
                            GlobalVariables.isOpend = val;
                          });
                        }),

                    SizedBox(width: 5 * fem,),

                    SearchBars(hintText: "Search number or OID", width: 100 *
                        fem, height: 45,
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
                    onTap: (){
                      // _showHolidayPopupMenu(context);
                      GlobalFunction.showHolidayMessage(context);
                    },
                    child: Image.asset(
                      'assets/images/holidaynew.png',
                      width: 30,
                      height: 30,color: GlobalVariables.textColor,
                    ),
                  ),
                  SizedBox(width: 30,),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BarcodeScannerWidget()),
                        );
                      },
                      child: Icon(Icons.qr_code_scanner_outlined, color: Color(
                          0xFF363563), size: 25,)),
                  SizedBox(width: 30,),
                  Icon(Icons.notifications_active_outlined, color: Color(0xFF363563),
                    size: 25,),
                  SizedBox(width: 30,),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://icon-library.com/images/profile-icon-vector/profile-icon-vector-7.jpg"),
                  ),
                  SizedBox(width: 30,)
                ],
              ),
              body: widget.index == 1
                  ? DefaultTabController(
                length: 2, // Number of tabs
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: lighterColor,
                    toolbarHeight: 1,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 400,
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
                                Tab(text: "For orders",),
                                Tab(text: "Subscription",)
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  context.read<OrdersBloc>().add(CancelAllOrderEvent(orderState.ordersList, orderState.inprogressList, orderState.closedList, OrderVariables.filteredOrders));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5)

                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Cancel All",style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: GlobalVariables.whiteColor,
                                    ),),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15,),
                              Container(
                                decoration: BoxDecoration(
                                    color: GlobalVariables.textColor,
                                    borderRadius: BorderRadius.circular(5)

                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Sort by",style: SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: GlobalVariables.whiteColor,
                                      ),),
                                      SizedBox(width: 10,),
                                      Icon(Icons.arrow_upward_rounded,color: GlobalVariables.whiteColor,size: 18,)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 20,),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      ManageOrders(query: searchedQuery,),
                      ManageSubscription(query: searchedQuery,)
                    ],
                  ),
                ),
              )
                  : AnalyseOrders(),


            );
          }
          return Container();
        },

        ),
      );

    },
        desktopBuilder: (BuildContext context,BoxConstraints constraints){
      return BlocProvider(
        create: (BuildContext context) => OrdersBloc(
            OrderService()
        )..add(LoadOrdersEvent()),
        child: BlocBuilder<OrdersBloc,OrdersState>(builder: (BuildContext context, orderState) {
          if(orderState is OrdersLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(orderState is OrderErrorState) {
            return const Center(child: Text("Node server error"),);
          }
          if(orderState is OrdersLoadedState){
            return BlocBuilder<OrderBloc,OrderState>(builder: (BuildContext orderContext, state) {
              print("I am here only");
              return Scaffold(
                appBar: AppBar(
                  // toolbarHeight: 80,
                  leadingWidth: 0,
                  leading: Container(),
                  title: Row(
                    children: [
                      Container(
                          width: 45*fem,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0,bottom: 4.0,top: 4.0),
                            child: Center(child: Text("ORDER DETAILS",style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF363563),
                            ),)),
                          )
                      ),
                      Container(
                        width: 30*fem,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0,bottom: 4.0,top: 4.0),
                            child: Center(child: Text("${dayProvider.selectedDay}",style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF363563),
                            ),)),
                          )
                      ),
                      SizedBox(width: 0*fem,),
                      InkWell(
                        onTap: () async {
                          String? newValue = await showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(200, 50, 600, 0),
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
                      SizedBox(width: 2*fem,),
                      InkWell(
                          onTap:()
                          {
                            dayProvider.showNextDay();
                          },
                          child: Icon(Icons.double_arrow_sharp,size: 20,color: GlobalVariables.textColor,)
                      ),
                      SizedBox(width: 15*fem,),
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
                      SizedBox(width: 15*fem,),
                      SearchBars(hintText: "Search number or OID", width: 100*fem,height: 45,
                        onChanged: (query) {
                          setState(() {
                            searchedQuery = query;
                          });
                        },
                        onPressed: ()
                        {
                          OrderFunctions.showFilterAlert(orderContext,context);
                        },
                      ),
                    ],
                  ),
                  backgroundColor: Color(0xfffbb830),
                  actions: [
                    InkWell(
                      onTap: (){
                        // _showHolidayPopupMenu(context);
                        GlobalFunction.showHolidayMessage(context);
                      },
                      child: Image.asset(
                        'assets/images/holidaynew.png',
                        width: 30,
                        height: 30,color: GlobalVariables.textColor,
                      ),
                    ),
                    SizedBox(width: 10*fem,),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BarcodeScannerWidget ()),
                          );
                        },
                        child: Icon(Icons.qr_code_scanner_outlined,color: Color(0xFF363563),size: 25,)),
                    SizedBox(width: 10*fem,),
                    Icon(Icons.notifications_active_outlined,color: Color(0xFF363563),size: 25,),
                    SizedBox(width: 10*fem,),
                    CircleAvatar(
                      backgroundImage: NetworkImage("https://icon-library.com/images/profile-icon-vector/profile-icon-vector-7.jpg"),
                    ),
                    SizedBox(width: 10*fem,)
                  ],
                ),
                body:  widget.index == 1
                    ? DefaultTabController(
                  length: 2, // Number of tabs
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
                      toolbarHeight: 1,
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(50.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  Tab(text: "Orders",),
                                  Tab(text: "Subscription",)
                                ],
                              ),
                            ),



                            Row(
                              children: [
                                InkWell(
                                  onTap: (){
                                    //context.read<OrdersBloc>().add(CancelAllOrderEvent(orderState.ordersList, orderState.inprogressList, orderState.closedList, OrderVariables.filteredOrders));
                                  },
                                  child: Container(
                                    width: 20*fem,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)

                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("All",style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: GlobalVariables.textColor,
                                        ),),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Container(

                                  decoration: BoxDecoration(
                                      color: GlobalVariables.textColor,
                                      borderRadius: BorderRadius.circular(5)

                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text("Sort by",style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: GlobalVariables.whiteColor,
                                        ),),
                                        SizedBox(width: 10,),
                                        Icon(Icons.arrow_upward_rounded,color: GlobalVariables.whiteColor,size: 18,)
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20,),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        ManageOrders(query: searchedQuery,),
                        ManageSubscription(query: searchedQuery,)
                      ],
                    ),
                  ),
                )
                    : AnalyseOrders(),


              );
            },
            );
          }
          return Container();
        },
        ),
      );
    });
  }
}
