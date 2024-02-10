import 'package:flutter/material.dart';
import 'package:partner_admin_portal/widgets/menu_editor.dart';

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

  @override
  void initState() {
    super.initState();
    String selectedCategory = '';
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Color baseColor = Color(0xfffbb830);
    Color lighterColor = baseColor.withOpacity(0.2);
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
            SizedBox(width: 20,),
            SearchBars(hintText: "Search....", width: MediaQuery.of(context).size.width/2,height: 75,),
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
                        Tab(text: 'Item Availability'),
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
              Container(
                child: Center(
                  child: Text('Item Availability Tab Content'),
                ),
              ),

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
  }

}
