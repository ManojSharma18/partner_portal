import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:partner_admin_portal/widgets/manage_settings/manage_settings_preference.dart';
import 'package:partner_admin_portal/widgets/manage_settings/manage_settings_staffs.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';

import '../constants/manage_settings/manage_settings_variables.dart';
import '../widgets/custom_textfield.dart';
import '../constants/global_variables.dart';
import '../constants/search_bar.dart';
import '../constants/utils.dart';
import '../widgets/manage_settings/manage_settings_outlet.dart';

class ManageSetting extends StatefulWidget {
  final int index;
  const ManageSetting({Key? key, required this.index}) : super(key: key);

  @override
  State<ManageSetting> createState() => _ManageSettingState();
}

class _ManageSettingState extends State<ManageSetting> with SingleTickerProviderStateMixin {

  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0;
  }




  @override
  Widget build(BuildContext context) {
    Color baseColor = Color(0xFF363563);
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    Color lighterColor = baseColor.withOpacity(0.1);
    ManageSettingsVariables.nameController.text = ManageSettingsVariables.selectedStaff['name'] ?? '';
    ManageSettingsVariables.numberController.text = ManageSettingsVariables.selectedStaff['number'] ?? '';
    ManageSettingsVariables.emailController.text = ManageSettingsVariables.selectedStaff['email'] ?? '';
    ManageSettingsVariables.roleController.text = ManageSettingsVariables.selectedStaff['role'] ?? '';
    return ResponsiveBuilder(
        mobileBuilder: (BuildContext context,BoxConstraints constraints){
      return Scaffold(
        appBar: AppBar(
          // toolbarHeight: 80,
          title: Row(
            children: [
              Text("MANAGE OUTLET",style: SafeGoogleFont(
                'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF363563),
              ),),

            ],
          ),
          backgroundColor: Color(0xfffbb830),

        ),
        body:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar:AppBar(
                    toolbarHeight: 0,
                    backgroundColor:GlobalVariables.primaryColor.withOpacity(0.2),
                    bottom: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      physics: NeverScrollableScrollPhysics(),
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
                        Tab(text: 'ABCD'),
                        Tab(text: 'Preference'),
                        Tab(text: 'Outlets'),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: TabBarView(
                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ManageSettingOutlet(),
                        ManageSettingPreference(),
                        ManageSettingsVariables.selectedType == "View all" ?
                        Scaffold(
                          appBar: AppBar(

                            title: Text(
                              "${ManageSettingsVariables.selectedStaff['name']}'s Profile" ?? '',
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF363563),
                              ),
                            ),
                            elevation: 3,
                            backgroundColor: GlobalVariables.whiteColor,
                          ),
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Container(
                                margin: EdgeInsets.only(left: 20,top: 20),
                                child: Text(
                                  "Contact information",
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF363563),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                margin: EdgeInsets.only(left: 20,right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomTextField(label: "Name", controller: ManageSettingsVariables.nameController,width: 55*fem,
                                      onChanged: (val){

                                      },
                                    ),
                                    CustomTextField(label: "Number", controller: ManageSettingsVariables.numberController,width: 55*fem,),

                                    CustomTextField(label: "Role", controller: ManageSettingsVariables.roleController,width: 55*fem,isDropdown: true,dropdownItems: ManageSettingsVariables.roleType,
                                      onChanged: (val) {
                                        // ItemDetails.checking = true;
                                      },),

                                  ],
                                ),
                              ),
                              SizedBox(height: 30,),
                              Container(
                                margin: EdgeInsets.only(left: 20,right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextField(label: "Email", controller: ManageSettingsVariables.emailController,width: 70*fem,onChanged: (val) {

                                    },),
                                    SizedBox(width: 20*fem,),
                                    Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Text("Whatsapp communication",
                                          style:TextStyle(
                                            fontFamily: 'RenogareSoft',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: GlobalVariables.textColor,
                                          ),),
                                        SizedBox(height: 15,),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              ManageSettingsVariables.number = !ManageSettingsVariables.number ;
                                            });
                                          },
                                          child: Container(
                                            width: 140,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                color: Colors.grey.shade200),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    width: 65,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(20),
                                                        color: ManageSettingsVariables.number
                                                            ? Colors.white
                                                            : Colors.grey.shade200),
                                                    child: Center(
                                                        child: Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Open Sans',
                                                              color: ManageSettingsVariables.number
                                                                  ? Color(0xfffbb830)
                                                                  : Colors.black),
                                                        )),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    width: 65,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(20),
                                                        color: ManageSettingsVariables.number
                                                            ? Colors.grey.shade200
                                                            : Colors.white),
                                                    child: Center(
                                                        child: Text(
                                                          'No',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Open Sans',
                                                              color: ManageSettingsVariables.number
                                                                  ? Colors.black
                                                                  : Color(0xfffbb830)),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          bottomNavigationBar: Padding(
                            padding:  EdgeInsets.only(right: 0,left: 0*fem),
                            child: BottomNavigationBar(
                              elevation: 3,
                              type: BottomNavigationBarType.fixed,
                              items: [
                                BottomNavigationBarItem(
                                  icon: Container(
                                    margin: EdgeInsets.only(left: 50*fem,right: 10),
                                    width: 200,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: GlobalVariables.textColor),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: GlobalVariables.textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  label: '',
                                ),
                                BottomNavigationBarItem(
                                  icon: Container(
                                    margin: EdgeInsets.only(left: 1*fem,right: 10),
                                    width: 200,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Save user",
                                        style: TextStyle(
                                          fontSize: 13,
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
                        ) : Column(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
        tabletBuilder: (BuildContext context,BoxConstraints constraints){
      return Scaffold(
        appBar: AppBar(
          // toolbarHeight: 80,
          title: Row(
            children: [
              Text("MANAGE OUTLET",style: SafeGoogleFont(
                'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF363563),
              ),),
              SizedBox(width: 50,),
              // Switch(
              //     activeThumbImage: NetworkImage('https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
              //     inactiveTrackColor: Colors.grey,
              //     inactiveThumbImage: NetworkImage('https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
              //     inactiveThumbColor: GlobalVariables.whiteColor,
              //     value: isOpend, onChanged: (val){
              //   setState(() {
              //     isOpend =val;
              //   });
              // }),
              SizedBox(width: 50,),
              // Container(
              //
              //     child: Padding(
              //       padding: const EdgeInsets.all(4.0),
              //       child: Center(child: Text("${DateFormat('dd MMM').format(todday)}",style: SafeGoogleFont(
              //         'Poppins',
              //         fontSize: 14,
              //         fontWeight: FontWeight.bold,
              //         color: Color(0xFF363563),
              //       ),)),
              //     )
              // ),

            ],
          ),
          backgroundColor: Color(0xfffbb830),
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
        body:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar:AppBar(
                    toolbarHeight: 0,
                    backgroundColor:GlobalVariables.primaryColor.withOpacity(0.2),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(width: 400,
                            child: TabBar(
                              controller: _tabController,
                              physics: NeverScrollableScrollPhysics(),
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
                                Tab(text: 'ABCD'),
                                Tab(text: 'Preference',),
                                Tab(text: 'Outlets'),

                              ],
                            ),
                          ),
                          Container(
                            color: Colors.black45,
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    flex: 5,
                    child: TabBarView(
                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ManageSettingOutlet(),
                        ManageSettingPreference(),
                        ManageSettingsVariables.selectedType == "View all" ?
                        Scaffold(
                          appBar: AppBar(

                            title: Text(
                              "${ManageSettingsVariables.selectedStaff['name']}'s Profile" ?? '',
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF363563),
                              ),
                            ),
                            elevation: 3,
                            backgroundColor: GlobalVariables.whiteColor,
                          ),
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Container(
                                margin: EdgeInsets.only(left: 20,top: 20),
                                child: Text(
                                  "Contact information",
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF363563),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                margin: EdgeInsets.only(left: 20,right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomTextField(label: "Name", controller: ManageSettingsVariables.nameController,width: 55*fem,
                                      onChanged: (val){

                                      },
                                    ),
                                    CustomTextField(label: "Number", controller: ManageSettingsVariables.numberController,width: 55*fem,),

                                    CustomTextField(label: "Role", controller: ManageSettingsVariables.roleController,width: 55*fem,isDropdown: true,dropdownItems: ManageSettingsVariables.roleType,
                                      onChanged: (val) {
                                        // ItemDetails.checking = true;
                                      },),

                                  ],
                                ),
                              ),
                              SizedBox(height: 30,),
                              Container(
                                margin: EdgeInsets.only(left: 20,right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextField(label: "Email", controller: ManageSettingsVariables.emailController,width: 70*fem,onChanged: (val) {

                                    },),
                                    SizedBox(width: 20*fem,),
                                    Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Text("Whatsapp communication",
                                          style:TextStyle(
                                            fontFamily: 'RenogareSoft',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: GlobalVariables.textColor,
                                          ),),
                                        SizedBox(height: 15,),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              ManageSettingsVariables.number = !ManageSettingsVariables.number ;
                                            });
                                          },
                                          child: Container(
                                            width: 140,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                color: Colors.grey.shade200),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    width: 65,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(20),
                                                        color: ManageSettingsVariables.number
                                                            ? Colors.white
                                                            : Colors.grey.shade200),
                                                    child: Center(
                                                        child: Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Open Sans',
                                                              color: ManageSettingsVariables.number
                                                                  ? Color(0xfffbb830)
                                                                  : Colors.black),
                                                        )),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    width: 65,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(20),
                                                        color: ManageSettingsVariables.number
                                                            ? Colors.grey.shade200
                                                            : Colors.white),
                                                    child: Center(
                                                        child: Text(
                                                          'No',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Open Sans',
                                                              color: ManageSettingsVariables.number
                                                                  ? Colors.black
                                                                  : Color(0xfffbb830)),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          bottomNavigationBar: Padding(
                            padding:  EdgeInsets.only(right: 0,left: 0*fem),
                            child: BottomNavigationBar(
                              elevation: 3,
                              type: BottomNavigationBarType.fixed,
                              items: [
                                BottomNavigationBarItem(
                                  icon: Container(
                                    margin: EdgeInsets.only(left: 50*fem,right: 10),
                                    width: 200,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: GlobalVariables.textColor),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: GlobalVariables.textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  label: '',
                                ),
                                BottomNavigationBarItem(
                                  icon: Container(
                                    margin: EdgeInsets.only(left: 1*fem,right: 10),
                                    width: 200,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Save user",
                                        style: TextStyle(
                                          fontSize: 13,
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
                        ) : Column(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
        desktopBuilder: (BuildContext context,BoxConstraints constraints){
      return Scaffold(
        appBar: AppBar(
          // toolbarHeight: 80,
          leading: Container(),
          leadingWidth: 0,
          title: Row(
            children: [
              Text("MANAGE OUTLET",style: SafeGoogleFont(
                'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF363563),
              ),),
              SizedBox(width: 50,),
              // Switch(
              //     activeThumbImage: NetworkImage('https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
              //     inactiveTrackColor: Colors.grey,
              //     inactiveThumbImage: NetworkImage('https://cdn2.iconfinder.com/data/icons/picons-essentials/71/power-512.png',),
              //     inactiveThumbColor: GlobalVariables.whiteColor,
              //     value: isOpend, onChanged: (val){
              //   setState(() {
              //     isOpend =val;
              //   });
              // }),
              SizedBox(width: 50,),
              // Container(
              //
              //     child: Padding(
              //       padding: const EdgeInsets.all(4.0),
              //       child: Center(child: Text("${DateFormat('dd MMM').format(todday)}",style: SafeGoogleFont(
              //         'Poppins',
              //         fontSize: 14,
              //         fontWeight: FontWeight.bold,
              //         color: Color(0xFF363563),
              //       ),)),
              //     )
              // ),

            ],
          ),
          backgroundColor: Color(0xfffbb830),
          actions: [
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
            SizedBox(width: 10*fem,),
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
        body:
        widget.index == 1
            ? ManageSettingOutlet()
            : widget.index == 2
            ? ManageSettingPreference()
            : ManageSettingStaff()
      );
    });
  }

}
