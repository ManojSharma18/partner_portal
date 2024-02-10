import 'package:flutter/material.dart';
import 'package:partner_admin_portal/screens/menu_details.dart';
import 'package:partner_admin_portal/screens/order_details.dart';

import '../constants/utils.dart';

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
  double groupAlignment = -1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
          backgroundColor:Color(0xFF363563),
          unselectedIconTheme: IconThemeData(color: Color(0xfffbb830),opacity: 1),
          selectedIconTheme: IconThemeData(color: Color(0xFF363563),opacity: 1,size: 10),
              groupAlignment: groupAlignment,
          unselectedLabelTextStyle: SafeGoogleFont(
            'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xfffbb830),
          ),
          selectedLabelTextStyle:SafeGoogleFont(
            'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xfffbb830),
          ),
          onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
          },
              leading: Image(image:
              NetworkImage("https://s3-alpha-sig.figma.com/img/c9eb/5f69/046c2d70164359b7e48637d4ff300d85?Expires=1707696000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Bp~lG0w-ALibHO9eS5G1MPs1Tfo38kJwgJSNX7nhuBZ5dhCLc7GB2kngFBx6aBI5OzPRJQDfQQ1RNknPTKPDB0AsFRG0tHcaGeoAXx2dxs5suWhcnt2u2EJp1O14amQkolUO8eKgelJzz0ZzMFvk8ZzCOiCJxlw7MtsuurKKbAZjBL2Uu-u0lQLNsS6mTKDK3BSTB5wTF~YqJCkhIHvLKP-xEnTERQrwATZiPpRW7cmu2dFytunciW9D2zPOx5vQYNlsTdQ1vVZfyaOonDxFftFxBPQGBtpBFjVVdeU3JuywEgcPTHl4nMR4CbmmY~SiF3IR7bm87~Q9serWaouFew__"),
                width: 50,
                height: 50,

              ),
              indicatorColor: Color(0xfffbb830),
              indicatorShape: Border.all(color: Color(0xfffbb830),style: BorderStyle.solid ),
              useIndicator: true,
              labelType: labelType,

          destinations: [
            NavigationRailDestination(
              icon: Icon(Icons.offline_pin_outlined, size: 35,),
              label: Text("Orders"),
              padding: EdgeInsets.only(bottom: 20, top: 20),
            ),
            NavigationRailDestination(icon: Icon(Icons.wb_twilight,size: 35,), label: Text("Growth"),padding: EdgeInsets.only(bottom: 20)),
            NavigationRailDestination(icon: Icon(Icons.restaurant_menu_rounded,size: 35,), label: Text("Menu"),padding: EdgeInsets.only(bottom: 20)),
            NavigationRailDestination(icon: Icon(Icons.stars,size: 35,), label: Text("Ratings"),padding: EdgeInsets.only(bottom: 20)),
            NavigationRailDestination(icon: Icon(Icons.bar_chart,size: 35,), label: Text("Metrics"),padding: EdgeInsets.only(bottom: 20)),
            NavigationRailDestination(icon: Icon(Icons.question_mark,size: 35,), label: Text("Help"),padding: EdgeInsets.only(bottom: 20)),
            NavigationRailDestination(icon: Icon(Icons.manage_history_outlined,size: 35,), label: Text("Manage\n  outlet"),padding: EdgeInsets.only(bottom: 20)),
          ], selectedIndex: _selectedIndex),
          const VerticalDivider(thickness: 1, width: 1),

          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                OrderDetails(),
                OrderDetails(),
                MenuDetails(),
                // Add more sections as needed
              ],
            ),


          )
        ],
      ),
    );
  }

}
