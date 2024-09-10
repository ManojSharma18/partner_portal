import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_event.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_state.dart';
import 'package:partner_admin_portal/widgets/manage_settings/menu_editor_preference.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';

import '../../constants/global_variables.dart';
import '../../constants/manage_settings/manage_settings_variables.dart';
import '../../constants/utils.dart';

class ManageSettingPreference extends StatefulWidget {

  const ManageSettingPreference({super.key});

  @override
  State<ManageSettingPreference> createState() => _ManageSettingOutletState();
}

class _ManageSettingOutletState extends State<ManageSettingPreference>  with SingleTickerProviderStateMixin {

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
                        length: 4,
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
                                Tab(text: 'Orders',),
                                Tab(text: 'Menu editor'),
                                Tab(text: 'Live menu'),
                                Tab(text: 'Forecast',),
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
                          Center(child: Text('Order preference'),),
                          Center(child: Text('Menu editor preference'),),
                          Center(child: Text('Live menu preference'),),
                          Center(child: Text('Forecast preference'),)
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
                        length: 4,
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
                                        Tab(text: 'Orders',),
                                        Tab(text: 'Menu editor'),
                                        Tab(text: 'Live menu'),
                                        Tab(text: 'Forecast',),

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
                          Center(child: Text('Order preference'),),
                          Center(child: Text('Menu editor preference'),),
                          Center(child: Text('Live menu preference'),),
                          Center(child: Text('Forecast preference'),)
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
                        length: 4,
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
                                        Tab(text: 'Orders',),
                                        Tab(text: 'Menu editor'),
                                        Tab(text: 'Live menu'),
                                        Tab(text: 'Forecast',),
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
                          Center(child: Text('Order preference'),),
                          MenuEditorPreference(),
                          Center(child: Text('Live menu preference'),),
                          Center(child: Text('Forecast preference'),)
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
