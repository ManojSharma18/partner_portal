import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/widgets/orders/manage/view_items_mob.dart';
import '../../../bloc/manage_orders/order_bloc.dart';
import '../../../bloc/manage_orders/order_event.dart';
import '../../../constants/global_function.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/search_bar.dart';
import '../../../constants/utils.dart';
import '../../menu/live_menu/live_menu.dart';

class ManageOrdersMob extends StatelessWidget {
  final TabController tabController;
  final List<Map<String,dynamic>> filteredOrders;
  final List<Map<String,dynamic>> inprogress;
  ManageOrdersMob({Key? key, required this.tabController, required this.filteredOrders, required this.inprogress}) : super(key: key);

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return BlocBuilder<OrderBloc,OrderState>(
        builder: (BuildContext context, state) {
            return  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      margin: EdgeInsets.only(left: 0),
                      color: GlobalVariables.primaryColor.withOpacity(0.2),
                      child: DefaultTabController(
                        length: 3,
                        child: Scaffold(
                          appBar:AppBar(
                            toolbarHeight: 0,
                            backgroundColor:GlobalVariables.primaryColor.withOpacity(0.2),
                            bottom: TabBar(
                              controller: tabController,
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
                                Tab(text: 'New'),
                                Tab(text: 'In progress'),
                                Tab(text: 'Closed',)
                              ],
                            ),
                          ),
                          body: TabBarView(
                            controller: tabController,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 5,),
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GlobalFunction.buildMealButton(context,MealTime.All,'All'),
                                              GlobalFunction.buildMealButton(context,MealTime.Breakfast,'Breakfast'),
                                              GlobalFunction.buildMealButton(context,MealTime.Lunch,'Lunch'),
                                              GlobalFunction.buildMealButton(context,MealTime.Dinner,'Dinner'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GlobalFunction.buildSessionButton(context,MealSession.All,'All'),
                                              GlobalFunction.buildSessionButton(context,MealSession.Session1,'S1'),
                                              GlobalFunction.buildSessionButton(context,MealSession.Session2,'S2'),
                                              GlobalFunction.buildSessionButton(context,MealSession.Session3,'S3'),
                                              GlobalFunction.buildSessionButton(context,MealSession.Session4,'S4'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        SearchBars(
                                          hintText: "Search name or number or OID",
                                          width: 350 * fem,
                                          height: 45,
                                          onChanged: (query) {
                                            searchQuery = query;
                                            print(searchQuery);
                                           context.read<OrderBloc>().add(SearchEvent(query));
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GlobalFunction.buildInProgressButton(context, InProgress.All, 'All'),
                                            GlobalFunction.buildInProgressButton(context, InProgress.YetToStart, 'Yet to start'),
                                            GlobalFunction.buildInProgressButton(context, InProgress.Preparing, 'Preparing'),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          child:  Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GlobalFunction.buildInProgressButton(context, InProgress.Ready, 'Ready'),
                                              GlobalFunction.buildInProgressButton(context, InProgress.DeliveyOut, 'Delivery Out'),
                                              GlobalFunction.buildInProgressButton(context, InProgress.Delayed, 'Delayed'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        SearchBars(
                                          hintText: "Search name or number or OID",
                                          width: 350 * fem,
                                          height: 45,
                                          onChanged: (query) {
                                            // setState(() {
                                            //   searchedQuery = query;
                                            //   filteredOrders = orders.where((order) {
                                            //     return order['number'].contains(searchedQuery) || order['Id'].toString().toLowerCase().contains(searchedQuery) || order['CustomerName'].toString().toLowerCase().contains(searchedQuery) || order['CustomerName'].toString().contains(searchedQuery);
                                            //   }).toList();
                                            //   print(filteredOrders);
                                            // });
                                          },
                                        )
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                              Container(
                                color: GlobalVariables.whiteColor,
                                child: Column(
                                  children: [
                                    SizedBox(height: 5,),
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GlobalFunction.buildClosedButton(context, Closed.All, "All"),
                                          GlobalFunction.buildClosedButton(context, Closed.Cancelled, "Cancelled"),
                                          GlobalFunction.buildClosedButton(context, Closed.Completed, "Completed"),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          GlobalFunction.buildClosedButton(context, Closed.inCompleted, "In completed"),
                                          GlobalFunction.buildClosedButton(context, Closed.Rejected, "Rejected"),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    SearchBars(
                                      hintText: "Search name or number or OID",
                                      width: 350 * fem,
                                      height: 45,
                                      onChanged: (query) {
                                        // setState(() {
                                        //   searchedQuery = query;
                                        //   filteredOrders = orders.where((order) {
                                        //     return order['number'].contains(searchedQuery) || order['Id'].toString().toLowerCase().contains(searchedQuery) || order['CustomerName'].toString().toLowerCase().contains(searchedQuery) || order['CustomerName'].toString().contains(searchedQuery);
                                        //   }).toList();
                                        //   print(filteredOrders);
                                        // });
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          Container(
                            color: GlobalVariables.whiteColor,
                            child: GridView.builder(
                                itemCount: searchQuery == "" ? state.orderList.length : state.filterList!.length,
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.all(20),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 20,
                                    mainAxisExtent: 440,
                                    childAspectRatio: 5,
                                    mainAxisSpacing: 30
                                ),
                                itemBuilder: (context,index) {
                                  state.orderList.sort(compareTime);
                                  final currentOrder = searchQuery == "" ? state.orderList[index] : state.filterList![index];
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: GlobalVariables.whiteColor,
                                        border: Border.all(color: GlobalVariables.primaryColor.withOpacity(0.5))
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin:EdgeInsets.only(left: 4*fem,right: 5*fem,top: 15,bottom: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${currentOrder['Id']}",style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color:GlobalVariables.textColor,
                                              ),),
                                              Row(
                                                children: [
                                                  Icon(Icons.paypal_rounded,color: Colors.blue,size: 20,),
                                                  SizedBox(width: 10,),
                                                  Text("\u20B9 ${currentOrder['Amount']}",style: TextStyle(
                                                      color: GlobalVariables.textColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15
                                                  ),),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),
                                        Container(
                                          margin:EdgeInsets.only(left: 5*fem,right: 5*fem,top: 10,bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("${currentOrder['CustomerName'] }",
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,

                                                      color: Color(0xFF363563),
                                                    ),),
                                                  SizedBox(width: 10,),

                                                ],
                                              ),
                                              Tooltip(
                                                  message: "${currentOrder['number']}",
                                                  child: Icon(Icons.call,color: Colors.green,size: 20,)
                                              )

                                            ],
                                          ),
                                        ),

                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),

                                        Container(
                                            padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width:200*fem,
                                                  child: Text(
                                                    'Item names',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      child: Text(
                                                        "QTY",
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          height: 1.5,
                                                          color: Color(0xFF363563),
                                                        ),
                                                      ),
                                                    ),

                                                    Container(
                                                      width: 40,
                                                      child: Text(
                                                        'Total',
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          height: 1.5,
                                                          color: Color(0xFF363563),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                        ),

                                        Container(
                                          height: 200,
                                          child: ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: searchQuery == "" ? state.orderList[index]['Items'].length : state.filterList![index]['Items'].length,
                                            itemBuilder: (_, itemIndex) {
                                              int serialNumber = itemIndex + 1;
                                              return Container(
                                                padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width:200*fem,
                                                      child: Text(
                                                        '${serialNumber}. ${searchQuery == "" ? state.orderList[index]['Items'][itemIndex]['itemName'] : state.filterList![index]['Items'][itemIndex]['itemName'] }  ',
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w400,
                                                          color: Color(0xFF363563),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width: 30,
                                                          child: Text(
                                                            // "${GlobalVariables.orders[index]['Items'][itemIndex]['count']} x ${GlobalVariables.orders[index]['Items'][itemIndex]['price'] ~/ GlobalVariables.orders[index]['Items'][itemIndex]['count']}",
                                                            "${searchQuery == "" ? state.orderList[index]['Items'][itemIndex]['count'] : state.filterList![index]['Items'][itemIndex]['count']}",
                                                            style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.5,
                                                              color: Color(0xFF363563),
                                                            ),
                                                          ),
                                                        ),

                                                        Container(
                                                          width: 40,
                                                          child: Text(
                                                            '\u20B9 ${searchQuery == "" ? state.orderList[index]['Items'][itemIndex]['price'] : state.filterList![index]['Items'][itemIndex]['price']}',
                                                            style: TextStyle(
                                                                fontSize: 13
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),

                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              "Deliver",
                                              style:  SafeGoogleFont (
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5*ffem/fem,
                                                color: Color(0xFF363563),
                                              ),
                                            ),
                                            Text(
                                              "Home",
                                              style:  SafeGoogleFont (
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5*ffem/fem,
                                                color: Color(0xFF363563),
                                              ),
                                            ),
                                            Text(
                                              "${currentOrder['Time']} ",
                                              style:  SafeGoogleFont (
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5*ffem/fem,
                                                color: Color(0xFF363563),
                                              ),
                                            ),
                                            InkWell(
                                                onTap: (){

                                                },
                                                child: Icon(Icons.timelapse_outlined,color: Colors.blueGrey,size: 20,)
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),


                                        Container(
                                          margin:EdgeInsets.only(left:2*fem,right: 2*fem,bottom: 15,top: 15),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap:(){
                                                     Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewItemsMobile(index: index, list: searchQuery == "" ? state.orderList : state.filterList!,serialNumber: 0,)));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text("Items | ${currentOrder['Items'].length} ",
                                                          style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,

                                                            color: Color(0xFF363563),
                                                          ),),
                                                        SizedBox(width: 0,),
                                                        Icon(Icons.double_arrow_outlined,size: 20,color: GlobalVariables.primaryColor,)
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      InkWell(
                                                        onTap:(){
                                                          context.read<OrderBloc>().add(OrderRejectEvent(state.orderList, index,state.closedList));
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: Colors.red
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                                                            child: Center(
                                                              child: Text(
                                                                "Reject",
                                                                style:SafeGoogleFont(
                                                                  'Poppins',
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: GlobalVariables.whiteColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 2*fem,),
                                                      InkWell(
                                                        onTap:(){
                                                          context.read<OrderBloc>().add(OrderAcceptEvent(searchQuery == "" ? state.orderList : state.filterList!, state.inProgressList, index, searchQuery == "" ? state.orderList[index]['Id'] : state.filterList![index]['Id']));
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: Colors.green
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                                                            child: Center(
                                                              child: Text(
                                                                "Accept",
                                                                style:SafeGoogleFont(
                                                                  'Poppins',
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: GlobalVariables.whiteColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                          Container(
                            color: GlobalVariables.whiteColor,
                            child: GridView.builder(
                                itemCount: state.inProgressList.length,
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.all(20),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 20,
                                    mainAxisExtent: 470,
                                    childAspectRatio: 5,
                                    mainAxisSpacing: 30
                                ),
                                itemBuilder: (context,index) {
                                  final status = state.inProgressList[index]['Status'];
                                  final currentOrder = state.inProgressList[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: GlobalVariables.whiteColor,
                                        border: Border.all(color: GlobalVariables.primaryColor.withOpacity(0.5))
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin:EdgeInsets.only(left: 5*fem,right: 5*fem,top: 15,bottom: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${currentOrder['Id']}",style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color:GlobalVariables.textColor,
                                              ),),
                                              Row(
                                                children: [
                                                  Icon(Icons.paypal_rounded,color: Colors.blue,size: 20,),
                                                  SizedBox(width: 10,),
                                                  Text("\u20B9 ${currentOrder['Amount']}",style: TextStyle(
                                                      color: GlobalVariables.textColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15
                                                  ),),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),
                                        Container(
                                          margin:EdgeInsets.only(left: 5*fem,right: 5*fem,top: 10,bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("${state.inProgressList.elementAt(index)['CustomerName'] } ",
                                                style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,

                                                  color: Color(0xFF363563),
                                                ),),
                                              Tooltip(
                                                  message: "${currentOrder['number']}",
                                                  child: Icon(Icons.call,color: Colors.green,size: 20,)
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width:200*fem,
                                                  child: Text(
                                                    'Item names',
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      child: Text(
                                                        "QTY",
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          height: 1.5,
                                                          color: Color(0xFF363563),
                                                        ),
                                                      ),
                                                    ),

                                                    Container(
                                                      width: 40,
                                                      child: Text(
                                                        'Total',
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          height: 1.5,
                                                          color: Color(0xFF363563),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                        ),
                                        Container(
                                          height:200,
                                          child: ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: state.inProgressList[index]['Items'].length,
                                            itemBuilder: (_, itemIndex) {
                                              return Container(
                                                padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width:200*fem,
                                                      child: Text(
                                                        '${itemIndex+1}. ${state.inProgressList[index]['Items'][itemIndex]['itemName']} ',
                                                        style: SafeGoogleFont(
                                                          'Poppins',
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w400,
                                                          color: Color(0xFF363563),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width: 30,
                                                          child: Text(
                                                            "${state.inProgressList[index]['Items'][itemIndex]['count']}",
                                                            style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500,
                                                              height: 1.5,
                                                              color: Color(0xFF363563),
                                                            ),
                                                          ),
                                                        ),

                                                        Container(
                                                          width: 40,
                                                          child: Text(
                                                            '\u20B9 ${state.inProgressList[index]['Items'][itemIndex]['price']}',
                                                            style: TextStyle(
                                                                fontSize: 13
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              "Deliver",
                                              style:  SafeGoogleFont (
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5*ffem/fem,
                                                color: Color(0xFF363563),
                                              ),
                                            ),
                                            Text(
                                              "Home",
                                              style:  SafeGoogleFont (
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5*ffem/fem,
                                                color: Color(0xFF363563),
                                              ),
                                            ),
                                            Text(
                                              "${GlobalVariables.orders.elementAt(index)['Time']} ",
                                              style:  SafeGoogleFont (
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5*ffem/fem,
                                                color: Color(0xFF363563),
                                              ),
                                            ),
                                            InkWell(
                                                onTap: (){

                                                },
                                                child: Icon(
                                                  state.inProgressList[index]['Status'] == "Start"
                                                      ? Icons.start_rounded
                                                      : state.inProgressList[index]['Status'] == "Ready"
                                                      ? Icons.done_rounded
                                                      : state.inProgressList[index]['Status'] == "Delivery out"
                                                      ? Icons.delivery_dining
                                                      : state.inProgressList[index]['Status'] == "Complete"
                                                      ? Icons.done_all_outlined
                                                      : Icons.delivery_dining
                                                  ,
                                                  color: state.inProgressList[index]['Status'] == "Start"
                                                      ? Colors.blueGrey
                                                      : state.inProgressList[index]['Status'] == "Ready"
                                                      ? Colors.grey
                                                      : state.inProgressList[index]['Status'] == "Delivery out"
                                                      ? Colors.blueGrey
                                                      : state.inProgressList[index]['Status'] == "Complete"
                                                      ? Colors.blue
                                                      : Colors.blueGrey,size: 20,)
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),
                                        Container(
                                          margin:EdgeInsets.only(left: 5*fem,right: 5*fem,top: 8,bottom: 8),
                                          child: Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.delivery_dining,color: Colors.red,size: 22,),
                                                  SizedBox(width: 10,),
                                                  Text("${currentOrder['dname'] } ",
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xFF363563),
                                                    ),),
                                                  SizedBox(width: 10,),

                                                ],
                                              ),
                                              Tooltip(
                                                  message: "${currentOrder['number']}",
                                                  child: Icon(Icons.call,color: Colors.green,size: 20,)
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: GlobalVariables.primaryColor,
                                        ),


                                        Container(
                                          margin:EdgeInsets.only(left:2*fem,right: 2*fem,bottom: 10,top: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap:(){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewItemsMobile(index: index, list: state.inProgressList,serialNumber: 1,)));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text("Items | ${state.inProgressList[index]['Items'].length} ",
                                                          style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,

                                                            color: Color(0xFF363563),
                                                          ),),
                                                        SizedBox(width: 0,),
                                                        Icon(Icons.double_arrow_outlined,size: 20,color: GlobalVariables.primaryColor,)
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      InkWell(
                                                        onTap:() {
                                                          if(state.inProgressList[index]['Status'] == "Complete") {
                                                            context.read<OrderBloc>().add(OrderCompleteEvent(index));

                                                          }else {
                                                            context.read<OrderBloc>().add(OrderStatusEvent(state.inProgressList, index,"Ready"));
                                                          }

                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: Colors.green
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                                                            child: Center(
                                                              child: Text(
                                                                "${state.inProgressList[index]['Status']}",
                                                                style:SafeGoogleFont(
                                                                  'Poppins',
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: GlobalVariables.whiteColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                          Container(
                            color: GlobalVariables.whiteColor,
                            child: BlocBuilder<OrderBloc,OrderState>(
                              builder: (BuildContext context, OrderState state) {
                                if(state is OrderState) {
                                  state.closedList.sort(compareTime);
                                  return GridView.builder(
                                      itemCount: searchQuery == "" ? state.closedList.length : filteredOrders.length,
                                      scrollDirection: Axis.vertical,
                                      padding: EdgeInsets.all(20),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          crossAxisSpacing: 20,
                                          mainAxisExtent: 430,
                                          childAspectRatio: 5,
                                          mainAxisSpacing: 30
                                      ),
                                      itemBuilder: (context,index) {
                                        final currentOrder = searchQuery == "" ? state.closedList[index] : filteredOrders[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: GlobalVariables.whiteColor,
                                              border: Border.all(color: GlobalVariables.primaryColor.withOpacity(0.5))
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                margin:EdgeInsets.only(left: 4*fem,right: 5*fem,top: 15,bottom: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${currentOrder['Id']}",style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                      color:GlobalVariables.textColor,
                                                    ),),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.paypal_rounded,color: Colors.blue,size: 20,),
                                                        SizedBox(width: 10,),
                                                        Text("\u20B9 ${currentOrder['Amount']}",style: TextStyle(
                                                            color: GlobalVariables.textColor,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 15
                                                        ),),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 0.5,
                                                color: GlobalVariables.primaryColor,
                                              ),
                                              Container(
                                                margin:EdgeInsets.only(left: 5*fem,right: 5*fem,top: 10,bottom: 10),
                                                child: Row(
                                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("${currentOrder['CustomerName'] }",
                                                          style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,

                                                            color: Color(0xFF363563),
                                                          ),),
                                                        SizedBox(width: 10,),

                                                      ],
                                                    ),
                                                    Tooltip(
                                                        message: "${currentOrder['number']}",
                                                        child: Icon(Icons.call,color: Colors.green,size: 20,)
                                                    )

                                                  ],
                                                ),
                                              ),

                                              Container(
                                                height: 0.5,
                                                color: GlobalVariables.primaryColor,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width:200*fem,
                                                        child: Text(
                                                          'Item names',
                                                          style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xFF363563),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width: 40,
                                                            child: Text(
                                                              "QTY",
                                                              style: SafeGoogleFont(
                                                                'Poppins',
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.5,
                                                                color: Color(0xFF363563),
                                                              ),
                                                            ),
                                                          ),

                                                          Container(
                                                            width: 40,
                                                            child: Text(
                                                              'Total',
                                                              style: SafeGoogleFont(
                                                                'Poppins',
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.5,
                                                                color: Color(0xFF363563),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              ),
                                              Container(
                                                height: 200,
                                                child: ListView.builder(
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: GlobalVariables.orders[index]['Items'].length,
                                                  itemBuilder: (_, itemIndex) {
                                                    int serialNumber = itemIndex + 1;
                                                    return Container(
                                                      padding: EdgeInsets.only(top:10,bottom:10,left: 5*fem,right: 5*fem),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            width:200*fem,
                                                            child: Text(
                                                              '${serialNumber}. ${state.closedList[index]['Items'][itemIndex]['itemName']} ',
                                                              style: SafeGoogleFont(
                                                                'Poppins',
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400,
                                                                color: Color(0xFF363563),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                width: 30,
                                                                child: Text(
                                                                  // "${GlobalVariables.orders[index]['Items'][itemIndex]['count']} x ${GlobalVariables.orders[index]['Items'][itemIndex]['price'] ~/ GlobalVariables.orders[index]['Items'][itemIndex]['count']}",
                                                                  "${state.closedList[index]['Items'][itemIndex]['count']}",
                                                                  style: SafeGoogleFont(
                                                                    'Poppins',
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w500,
                                                                    height: 1.5,
                                                                    color: Color(0xFF363563),
                                                                  ),
                                                                ),
                                                              ),

                                                              Container(
                                                                width: 40,
                                                                child: Text(
                                                                  '\u20B9 ${state.closedList[index]['Items'][itemIndex]['price']}',
                                                                  style: TextStyle(
                                                                      fontSize: 13
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Container(
                                                height: 0.5,
                                                color: GlobalVariables.primaryColor,
                                              ),

                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(
                                                    "Deliver",
                                                    style:  SafeGoogleFont (
                                                      'Poppins',
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      height: 1.5*ffem/fem,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Home",
                                                    style:  SafeGoogleFont (
                                                      'Poppins',
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      height: 1.5*ffem/fem,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${GlobalVariables.orders.elementAt(index)['Time']} ",
                                                    style:  SafeGoogleFont (
                                                      'Poppins',
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      height: 1.5*ffem/fem,
                                                      color: Color(0xFF363563),
                                                    ),
                                                  ),
                                                  InkWell(
                                                      onTap: (){

                                                      },
                                                      child: Icon( state.closedList[index]['Status'] == "Completed" ? Icons.done_all_outlined : Icons.cancel,color: state.closedList[index]['Status'] == "Completed" ? Colors.green : Colors.red,size: 20,)
                                                  ),

                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Container(
                                                height: 0.5,
                                                color: GlobalVariables.primaryColor,
                                              ),

                                              Container(
                                                height: 0.5,
                                                color: GlobalVariables.primaryColor,
                                              ),
                                              Container(
                                                margin:EdgeInsets.only(left:2*fem,right: 2*fem,bottom: 10,top: 10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                          onTap:(){
                                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewItemsMobile(index: index, list: state.closedList,serialNumber: 2,)));
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text("Items | ${state.closedList[index]['Items'].length} ",
                                                                style: SafeGoogleFont(
                                                                  'Poppins',
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,

                                                                  color: Color(0xFF363563),
                                                                ),),
                                                              SizedBox(width: 0,),
                                                              Icon(Icons.double_arrow_outlined,size: 20,color: GlobalVariables.primaryColor,)
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            InkWell(
                                                              onTap:(){
                                                                // context.read<OrderBloc>().add(OrderRejectEvent(state.orderList, index,state.closedList));
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: state.closedList[index]['Status'] == "Completed" ? Colors.green : Colors.red,

                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "${state.closedList[index]['Status']}",
                                                                      style:SafeGoogleFont(
                                                                        'Poppins',
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: GlobalVariables.whiteColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  );
                                } else{
                                  return CircularProgressIndicator();
                                }
                              },

                            ),
                          ),
                        ],
                      ),

                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  int compareTime(Map<String, dynamic> a, Map<String, dynamic> b) {
    DateTime timeA = DateFormat('hh:mm a').parse(a['Time']);
    DateTime timeB = DateFormat('hh:mm a').parse(b['Time']);

    print(timeB.compareTo(timeA));
    return timeB.compareTo(timeA);
  }

}
