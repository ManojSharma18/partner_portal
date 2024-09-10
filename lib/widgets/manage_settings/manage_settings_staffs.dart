import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_event.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_state.dart';
import 'package:partner_admin_portal/constants/manage_settings/manage_settings_functions.dart';
import 'package:partner_admin_portal/widgets/manage_settings/bank_gst_pan_details.dart';
import 'package:partner_admin_portal/widgets/manage_settings/days_timings.dart';
import 'package:partner_admin_portal/widgets/manage_settings/days_timings_preorder_and_subscription.dart';
import 'package:partner_admin_portal/widgets/manage_settings/days_timings_subcription.dart';
import 'package:partner_admin_portal/widgets/manage_settings/fssai_details.dart';
import 'package:partner_admin_portal/widgets/manage_settings/owner_details.dart';
import 'package:partner_admin_portal/widgets/manage_settings/restaurant_details.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';

import '../../constants/global_variables.dart';
import '../../constants/manage_settings/manage_settings_variables.dart';
import '../../constants/utils.dart';
import '../custom_textfield.dart';

class ManageSettingStaff extends StatefulWidget {

  const ManageSettingStaff({super.key});

  @override
  State<ManageSettingStaff> createState() => _ManageSettingOutletState();
}

class _ManageSettingOutletState extends State<ManageSettingStaff>  with SingleTickerProviderStateMixin {

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 0;
  }
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return BlocProvider(
      create: (BuildContext context) => ManageSettingsBloc(
      )..add(LoadManageSettingEvent()),
      child: BlocBuilder<ManageSettingsBloc,ManageSettingState>(builder: (BuildContext manageSettingsContext, state) {
        print("restaurant model in manage settings ${ManageSettingsVariables.restaurantModelController.text}");
        if(state is ManageSettingsLoadingState){
          return Center(child: CircularProgressIndicator(),);
        }
        if(state is ManageSettingsErrorState){
          return Text("Error");
        }
        if(state is ManageSettingsLoadedState) {
          print("restaurant model in manage settings ${ManageSettingsVariables.restaurantModelController.text}");
          return ResponsiveBuilder(
              mobileBuilder: (BuildContext context,BoxConstraints constraints){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height:50,
                      child: DefaultTabController(
                        length: 2,
                        child: Scaffold(
                          appBar:AppBar(
                            toolbarHeight: 0,
                            backgroundColor:GlobalVariables.lightColor,
                            bottom: TabBar(
                              controller: _tabController,
                              isScrollable: true,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelPadding: EdgeInsets.symmetric(horizontal: 5),
                              indicatorColor: Color(0xfffbb830),
                              unselectedLabelColor: Colors.black54,
                              labelColor: Color(0xFF363563),
                              labelStyle: SafeGoogleFont(
                                'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF363563),
                              ),
                              physics: NeverScrollableScrollPhysics(),
                              tabs: [
                                Tab(text: 'Ownership',),
                                Tab(text: 'Operations'),
                              ],
                            ),
                          ),

                        ),
                      ),
                    ),
                    SizedBox(height: 0,),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          OwnerDetails(),
                          Center(child: Text('Operations'),),
                        ],
                      ),
                    )

                  ],
                );
              },
              tabletBuilder: (BuildContext context,BoxConstraints constraints){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height:50,
                      child: DefaultTabController(
                        length: 2,
                        child: Scaffold(
                          appBar:AppBar(
                            toolbarHeight: 0,
                            backgroundColor:GlobalVariables.lightColor,
                            bottom: PreferredSize(
                              preferredSize: Size.fromHeight(50.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 800,
                                    height: 50,
                                    child: TabBar(
                                      controller: _tabController,
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
                                      physics: NeverScrollableScrollPhysics(),
                                      tabs: [
                                        Tab(text: 'Ownership',),
                                        Tab(text: 'Operations'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ),
                      ),
                    ),
                    SizedBox(height: 0,),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          OwnerDetails(),
                          Center(child: Text('Operations'),),
                        ],
                      ),
                    )

                  ],
                );
              },
              desktopBuilder: (BuildContext context,BoxConstraints constraints){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height:50,
                      child: DefaultTabController(
                        length: 2,
                        child: Scaffold(
                          appBar:AppBar(
                            toolbarHeight: 0,
                            backgroundColor:GlobalVariables.lightColor,
                            bottom: PreferredSize(
                              preferredSize: Size.fromHeight(50.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 800,
                                    height: 50,
                                    child: TabBar(
                                      controller: _tabController,
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
                                      physics: NeverScrollableScrollPhysics(),
                                      tabs: [
                                        Tab(text: 'Ownership',),
                                        Tab(text: 'Operations'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ),
                      ),
                    ),
                    SizedBox(height: 0,),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          OwnerDetails(),
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
                    )

                  ],
                );
              });
        }

        return Center(child: CircularProgressIndicator(),);
      },
      ),
    );
  }
}
