import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/widgets/orders/manage/manage_subscription_mob.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:partner_admin_portal/screens/help_screen.dart';
import 'package:partner_admin_portal/screens/manage_setting.dart';
import 'package:partner_admin_portal/screens/menu_details.dart';
import 'package:partner_admin_portal/screens/order_details.dart';
import 'package:partner_admin_portal/screens/payout_screen.dart';
import 'package:partner_admin_portal/screens/rating_screen.dart';
import 'package:partner_admin_portal/screens/report.dart';
import '../bloc/menu/menu_bloc.dart';
import '../bloc/menu/menu_event.dart';
import '../constants/utils.dart';
import '../widgets/navbar.dart';
import '../widgets/orders/forecast/analyse_orders_mob.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>  {

  int _selectedIndex = 0;
  bool isExnded = false;
  bool showLeading = false;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  double groupAlignment = -1;

  int orderIndex = 1;

  int menuIndex = 1;

  bool isHovered = false;

  List<bool> selected = [true,false,false,false,false,false,false];

  bool expandMeanu = false;

  bool expandOrder = false;

  void select(int n){
    for(int i=0;i<7;i++)
    {
      if(i!=n)
      {
        selected[i] = false;
      }
      else{
        selected[i] = true;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final menuBloc = BlocProvider.of<MenuBloc>(context);
    return ResponsiveBuilder(mobileBuilder: (BuildContext context,BoxConstraints constraint)
        {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
              title: Text("Slys partner",style: SafeGoogleFont(
                'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: GlobalVariables.textColor,
              ),),
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  DrawerHeader(child: Row(
                    children: [
                      Icon(Icons.person),

                    ],
                  )),
                 ListTile(
                   title: Column(
                     children: [
                       Row(
                         children: [
                           Image(image: AssetImage("assets/images/list_819860.png"),width: 20,height: 20,color: GlobalVariables.primaryColor,),
                           SizedBox(width: 10,),
                           Text("Orders",style: SafeGoogleFont(
                             'Poppins',
                             fontSize: 14,
                             fontWeight: FontWeight.bold,
                             color:GlobalVariables.textColor,
                           ),),
                         ],
                       ),
                       SizedBox(height: 10,),
                       Visibility(
                         visible: expandOrder,
                         child: Column(
                           children: [
                             Container(
                               margin: EdgeInsets.only(left: 30),
                               child: ListTile(
                                 title: Text("For orders",style: SafeGoogleFont(
                                   'Poppins',
                                   fontSize: 12,
                                   fontWeight: FontWeight.bold,
                                   color:GlobalVariables.textColor,
                                 ),),
                                 onTap: (){
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(index: orderIndex,)));
                                 },
                               ),
                             ),
                             Container(
                               margin: EdgeInsets.only(left: 30),
                               child: ListTile(
                                 title: Text("Subscription",style: SafeGoogleFont(
                                   'Poppins',
                                   fontSize: 12,
                                   fontWeight: FontWeight.bold,
                                   color:GlobalVariables.textColor,
                                 ),),
                                 onTap: (){
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => ManageSubscriptionMobile()));
                                 },
                               ),
                             ),
                             Container(
                               margin: EdgeInsets.only(left: 30),
                               child: ListTile(
                                 title: Text("Forecast",style: SafeGoogleFont(
                                   'Poppins',
                                   fontSize: 12,
                                   fontWeight: FontWeight.bold,
                                   color:GlobalVariables.textColor,
                                 ),),
                                 onTap: (){
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => AnalyseOrdersMobile()));
                                 },
                               ),
                             )
                           ],
                         ),
                       )
                     ],
                   ),

                   onTap: (){
                     setState(() {
                       expandOrder =!expandOrder;
                     });
                   },

                 ),
                  ListTile(
                    title: Column(
                      children: [
                        Row(
                          children: [
                            Image(image: AssetImage("assets/images/restaurant_685352.png"),width: 20,height: 20,color: GlobalVariables.primaryColor,),
                            SizedBox(width: 10,),
                            Text("Menu",style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:GlobalVariables.textColor,
                            ),),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Visibility(
                          visible: expandMeanu,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 30),
                                child: ListTile(
                                  title: Text("Live menu",style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:GlobalVariables.textColor,
                                  ),),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  MenuDetails(index: menuIndex,),));
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 30),
                                child: ListTile(
                                  title: Text("Menu editor",style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:GlobalVariables.textColor,
                                  ),),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  MenuDetails(index: 2,),));
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    onTap: (){
                      setState(() {
                        expandMeanu =!expandMeanu;
                      });
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Image(image: AssetImage("assets/images/ratings-removebg-preview.png"),width: 20,height: 20,color: GlobalVariables.primaryColor,),
                        SizedBox(width: 10,),
                        Text("Ratings",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:GlobalVariables.textColor,
                        ),),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Image(image: AssetImage("assets/images/high-wifi-signal_63686.png"),width: 20,height: 20,color: GlobalVariables.primaryColor,),
                        SizedBox(width: 10,),
                        Text("Reports",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:GlobalVariables.textColor,
                        ),),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Image(image: AssetImage("assets/images/boost-removebg-preview.png"),width: 20,height: 20,color: GlobalVariables.primaryColor,),
                        SizedBox(width: 10,),
                        Text("Boost",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:GlobalVariables.textColor,
                        ),),
                      ],
                    ),
                  ),

                  ListTile(
                    title: Row(
                      children: [
                        Image(image: AssetImage("assets/images/settings.png"),width: 20,height: 20,color: GlobalVariables.primaryColor,),
                        SizedBox(width: 10,),
                        Text("Manage settings",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:GlobalVariables.textColor,
                        ),),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Image(image: AssetImage("assets/images/help.jpg"),width: 20,height: 20,color: GlobalVariables.primaryColor,),
                        SizedBox(width: 10,),
                        Text("Help",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:GlobalVariables.textColor,
                        ),),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }, tabletBuilder: (BuildContext context,BoxConstraints constraints){
          return Scaffold(
            body: Row(
              children: [

                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: 100.0,
                    color:GlobalVariables.whiteColor ,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          left: 15,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: GlobalVariables.whiteColor, // Set the background color of the circle
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                "assets/images/logo1-removebg-preview.png",
                                width: 60,
                                height: 60,

                                // fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Positioned(
                          top: 80,
                          left: 10,
                          child: Image.asset(
                            "assets/images/slys-removebg-preview.png",
                            width: 80,
                            height: 40,
                            color: GlobalVariables.primaryColor,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                            top: 140,
                            child: Container(
                              height: 600,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    NavBarItem(icon: "assets/images/list_819860.png",
                                        text: "Orders",
                                        hover: (val){
                                          if(val)
                                          {
                                            showPopupMenu(context);
                                          }
                                          else{
                                            Container();
                                          }
                                        },
                                        touched: () {
                                          showPopupMenu(context);
                                          setState(() {
                                            // select(0);
                                            // _selectedIndex = 0;
                                          });
                                        },
                                        active: selected[0]),
                                    NavBarItem(icon: "assets/images/restaurant_685352.png",
                                        text: "Manage",
                                        hover: (val){
                                          if(val)
                                          {
                                            showPopupMenu1(context);
                                          }
                                          else {
                                            Container();
                                          }
                                        },
                                        touched: () {
                                          showPopupMenu1(context);
                                          setState(() {
                                            // select(0);
                                            // _selectedIndex = 0;
                                          });
                                        },
                                        active: selected[1]),
                                    NavBarItem(icon: "assets/images/ratings-removebg-preview.png",
                                        text: "Ratings",
                                        touched: (){
                                          setState(() {
                                            select(2);
                                            _selectedIndex = 2;
                                          });
                                        },
                                        active: selected[2]),
                                    NavBarItem(icon: "assets/images/high-wifi-signal_63686.png",
                                        text: "Reports",
                                        touched: (){
                                          setState(() {
                                            select(3);
                                            _selectedIndex = 3;
                                          });
                                        },
                                        active: selected[3]),
                                    NavBarItem(icon: "assets/images/rupee-indian.png",
                                        text: "Payout",
                                        touched: (){
                                          setState(() {
                                            select(4);
                                            _selectedIndex = 4;
                                          });
                                        },
                                        active: selected[4]),
                                    NavBarItem(icon: "assets/images/settings.png",
                                        text: "Manage\nSettings",
                                        touched: (){
                                          setState(() {
                                            select(5);
                                            _selectedIndex = 5;
                                          });
                                        },
                                        active: selected[5]),
                                    NavBarItem(icon: "assets/images/help.jpg",
                                        text: "Help",
                                        touched: (){
                                          setState(() {
                                            select(6);
                                            _selectedIndex = 6;
                                          });
                                        },
                                        active: selected[6])
                                  ],
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),

                const VerticalDivider(thickness: 1, width: 1),

                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      OrderDetails(index: orderIndex,),
                      MenuDetails(index: menuIndex,),
                      Rating(),
                      Report(),
                      // Boost(),
                      Payout(),
                      ManageSetting(),
                      Help()
                      // Add more sections as needed
                    ],
                  ),


                )
              ],
            ),
          );
        },
        desktopBuilder: (BuildContext context,BoxConstraints constraints){
          return Scaffold(
        body: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: 100.0,
                color:GlobalVariables.whiteColor ,
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 15,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: GlobalVariables.whiteColor, // Set the background color of the circle
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/logo1-removebg-preview.png",
                            width: 60,
                            height: 60,

                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Positioned(
                      top: 80,
                      left: 10,
                      child: Image.asset(
                        "assets/images/slys-removebg-preview.png",
                        width: 80,
                        height: 40,
                        color: GlobalVariables.primaryColor,
                        // fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        top: 140,
                        child: Container(
                          height: 600,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [ NavBarItem(icon: "assets/images/list_819860.png",
                                  text: "Manage",
                                  touched: (){
                                    setState(() {
                                      select(0);
                                      _selectedIndex = 0;
                                    });
                                  },
                                  active: selected[0]),

                                // MouseRegion(
                                //   onEnter: (_){
                                //     setState(() {
                                //       isHovered = true;
                                //     });
                                //     if(isHovered)
                                //     {
                                //       select(0);
                                //       // _selectedIndex = 1;
                                //       // menuIndex = 1;
                                //       showPopupMenu(context);
                                //     }
                                //   },
                                //   onExit: (_){
                                //     setState(() {
                                //       isHovered = false;
                                //     });
                                //     print("Hovered $isHovered");
                                //     if(!isHovered)
                                //     {
                                //       Container();
                                //     }
                                //   },
                                //   child: NavBarItem(icon: "assets/images/list_819860.png",
                                //       text: "Manage",
                                //       hover: (val){
                                //
                                //       },
                                //       touched: () {
                                //         // showPopupMenu(context);
                                //         setState(() {
                                //
                                //           // _selectedIndex = 0;
                                //         });
                                //       },
                                //       active: selected[0]),
                                // ),
                                MouseRegion(
                                  onEnter: (_){
                                    setState(() {
                                      isHovered = true;
                                    });
                                    if(isHovered)
                                      {
                                        select(1);
                                        // _selectedIndex = 1;
                                        // menuIndex = 1;
                                        showPopupMenu1(context);
                                      }
                                  },
                                  onExit: (_){
                                    setState(() {
                                      isHovered = false;
                                    });
                                    print("Hovered $isHovered");
                                    if(!isHovered)
                                      {
                                        Container();
                                      }
                                  },
                                  child: NavBarItem(icon: "assets/images/restaurant_685352.png",
                                      text: "Menu",

                                      touched: () {
                                        showPopupMenu1(context);

                                      },
                                      active: selected[1]),
                                ),
                                NavBarItem(icon: "assets/images/ratings-removebg-preview.png",
                                    text: "Ratings",
                                    touched: (){
                                      setState(() {
                                        select(2);
                                        _selectedIndex = 2;
                                      });
                                    },
                                    active: selected[2]),
                                NavBarItem(icon: "assets/images/high-wifi-signal_63686.png",
                                    text: "Reports",
                                    touched: (){
                                      setState(() {
                                        select(3);
                                        _selectedIndex = 3;
                                      });
                                    },
                                    active: selected[3]),
                                NavBarItem(icon: "assets/images/rupee-indian.png",
                                    text: "Payout",
                                    touched: (){
                                      setState(() {
                                        select(4);
                                        _selectedIndex = 4;
                                      });
                                    },
                                    active: selected[4]),
                                NavBarItem(icon: "assets/images/settings.png",
                                    text: "Manage\nSettings",
                                    touched: (){
                                      setState(() {
                                        select(5);
                                        _selectedIndex = 5;
                                      });
                                    },
                                    active: selected[5]),
                                NavBarItem(icon: "assets/images/help.jpg",
                                    text: "Help",
                                    touched: (){
                                      setState(() {
                                        select(6);
                                        _selectedIndex = 6;
                                      });
                                    },
                                    active: selected[6])
                              ],
                            ),
                          ),
                        )
                    )
                  ],
                ),
              ),
            ),

            const VerticalDivider(thickness: 1, width: 1),

            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  OrderDetails(index: orderIndex,),
                  MenuDetails(index: menuIndex,),
                  Rating(),
                  Report(),
                  // Boost(),
                  Payout(),
                  ManageSetting(),
                  Help()
                ],
              ),


            )
          ],
        ),
      );
        });
  }

  void showPopupMenu1(BuildContext context) {
    {
      showMenu(
        context: context,
        color: GlobalVariables.whiteColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        position: RelativeRect.fromLTRB(100, 215, 100, 0), // Adjust the position as needed
        items: [
          PopupMenuItem(
            child: ListTile(
              title: Text('Live menu'),
              onTap: () {
                setState(() {
                  select(1);
                  _selectedIndex = 1;
                  menuIndex = 1;
                });

                Navigator.pop(context); // Close the popup menu

              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              title: Text('Menu editor'),
              onTap: () {
                setState(() {
                  menuIndex = 2;
                  select(1);
                  _selectedIndex = 1;

                });

                Navigator.pop(context); // Close the popup menu

              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              title: Text('Menu history'),
              onTap: () {
                setState(() {
                  menuIndex = 3;
                  select(1);
                  _selectedIndex = 1;

                });

                Navigator.pop(context); // Close the popup menu

              },
            ),
          ),
        ],
      );
    }
  }

  void showPopupMenu(BuildContext context) {
    final menuBloc = BlocProvider.of<MenuBloc>(context);
    showMenu(
      context: context,
      color: GlobalVariables.whiteColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      position: RelativeRect.fromLTRB(100, 140, 100, 0), // Adjust the position as needed
      items: [
        PopupMenuItem(
          child: ListTile(
            title: Text('Manage'),
            onTap: () {
              setState(() {
                select(0);
                _selectedIndex = 0;
                orderIndex = 1;
              });

              Navigator.pop(context); // Close the popup menu

            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Forecast'),
            onTap: () {
              setState(() {
                menuBloc.add(LoadMenuEvent(context));
                orderIndex = 2;
                select(0);
                _selectedIndex = 0;

              });


              Navigator.pop(context); // Close the popup menu

            },
          ),
        ),
      ],
    );
  }

}
