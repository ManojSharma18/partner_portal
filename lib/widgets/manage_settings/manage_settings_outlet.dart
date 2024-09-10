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

class ManageSettingOutlet extends StatefulWidget {

  const ManageSettingOutlet({super.key});

  @override
  State<ManageSettingOutlet> createState() => _ManageSettingOutletState();
}

class _ManageSettingOutletState extends State<ManageSettingOutlet>  with SingleTickerProviderStateMixin {

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                        length: 3,
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
                                Tab(text: 'Operations'),
                                Tab(text: 'Unit details'),
                                Tab(text: 'Bank, GST, PAN and License',),

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
                          ManageSettingsVariables.restaurantModelController.text == "PREORDER"
                              ? DaysTimings(mealData: ManageSettingsVariables.mealData, mealTiming: ManageSettingsVariables.mealTiming,)
                              : ManageSettingsVariables.restaurantModelController.text == "SUBSCRIPTION"
                              ? DaysTimingsSubscription( mealDataSub: ManageSettingsVariables.mealDataSub, mealTimingSub: ManageSettingsVariables.mealTimingSub)
                              : DaysTimingsPreorderSubscription( mealData: ManageSettingsVariables.mealData, mealTiming: ManageSettingsVariables.mealTiming, mealDataSub: ManageSettingsVariables.mealDataSub, mealTimingSub: ManageSettingsVariables.mealTimingSub),
                          RestaurantDetails(manageSettingsContext: manageSettingsContext,),
                          BankGstPan(),

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
                        length: 3,
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
                                        Tab(text: 'Operations'),
                                        Tab(text: 'Unit details'),
                                        Tab(text: 'Bank, GST, PAN and License',),

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
                          ManageSettingsVariables.restaurantModelController.text == "PREORDER"
                              ? DaysTimings(mealData: ManageSettingsVariables.mealData, mealTiming: ManageSettingsVariables.mealTiming,)
                              : ManageSettingsVariables.restaurantModelController.text == "SUBSCRIPTION"
                              ? DaysTimingsSubscription( mealDataSub: ManageSettingsVariables.mealDataSub, mealTimingSub: ManageSettingsVariables.mealTimingSub)
                              : DaysTimingsPreorderSubscription( mealData: ManageSettingsVariables.mealData, mealTiming: ManageSettingsVariables.mealTiming, mealDataSub: ManageSettingsVariables.mealDataSub, mealTimingSub: ManageSettingsVariables.mealTimingSub),
                          RestaurantDetails(manageSettingsContext: manageSettingsContext,),
                          BankGstPan(),

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
                        length: 3,
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
                                        Tab(text: 'Operations'),
                                        Tab(text: 'Unit details'),
                                        Tab(text: 'Bank, GST, PAN and License',),

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
                          ManageSettingsVariables.restaurantModelController.text == "PREORDER"
                              ? DaysTimings(mealData: ManageSettingsVariables.mealData, mealTiming: ManageSettingsVariables.mealTiming,)
                              : ManageSettingsVariables.restaurantModelController.text == "SUBSCRIPTION"
                              ? DaysTimingsSubscription( mealDataSub: ManageSettingsVariables.mealDataSub, mealTimingSub: ManageSettingsVariables.mealTimingSub)
                              : DaysTimingsPreorderSubscription( mealData: ManageSettingsVariables.mealData, mealTiming: ManageSettingsVariables.mealTiming, mealDataSub: ManageSettingsVariables.mealDataSub, mealTimingSub: ManageSettingsVariables.mealTimingSub),
                          RestaurantDetails(manageSettingsContext: manageSettingsContext,),
                          BankGstPan(),

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
