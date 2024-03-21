import 'package:flutter/material.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/count_table.dart';

import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../item_availability_mob.dart';
import '../../item_details_mobile.dart';

class MenuEditorItemDetails extends StatefulWidget {
  final String itemName;
  const MenuEditorItemDetails({Key? key, required this.itemName}) : super(key: key);

  @override
  State<MenuEditorItemDetails> createState() => _MenuEditorItemDetailsState();
}

class _MenuEditorItemDetailsState extends State<MenuEditorItemDetails> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
        title: Row(
          children: [
            Text( "${widget.itemName} detail",
              style:SafeGoogleFont(
              'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF363563),
            ),),


          ],
        ),
      ),
      body: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 0,
            backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
            bottom: PreferredSize(
              preferredSize:Size.fromHeight(50),
              child: Row(
                children: [
                  Container(
                    width: 350*fem,
                    child: TabBar(
                      indicatorColor: GlobalVariables.primaryColor,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle:SafeGoogleFont(
                        'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF363563),
                      ),
                      tabs:
                      [
                        Tab(
                          child: Row(
                            children: [
                              Text(
                                'Details',

                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Subscription',

                          ),
                        ),
                        Tab(
                          child: Text(
                            'Availability',

                          ),
                        ),
                        Tab(
                          child: Text(
                            'Add on',

                          ),
                        ),
                        Tab(
                          child: Text(
                            'Other',

                          ),
                        ),
                      ],

                    ),
                  ),
                ],
              ),

            ),

          ),
          body: TabBarView(
            children: [
              ItemDetailsMob(name: widget.itemName),
              Column(),
              ItemAvailableMob(),
              Column(),
              Column()
            ],
          ),
        ),
      ),
    );
  }
}
