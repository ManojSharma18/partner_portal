import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/manage_settings/manage_settings_variables.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
import '../../constants/global_variables.dart';
import '../../constants/utils.dart';
// import '../custom_drop_down_textfeild.dart';

class MenuEditorPreference extends StatefulWidget {
  const MenuEditorPreference({super.key});

  @override
  State<MenuEditorPreference> createState() => _MenuEditorPreferenceState();
}

class _MenuEditorPreferenceState extends State<MenuEditorPreference> {

  final List<String> availableDays = const["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday",];

  List<String> selectedAvailableDays = [];

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return ResponsiveBuilder(mobileBuilder: (BuildContext context,BoxConstraints constraint) {
      return Column();
    }, tabletBuilder: (BuildContext context,BoxConstraints constraint) {
      return Column();
    }, desktopBuilder: (BuildContext context,BoxConstraints constraint) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   margin: EdgeInsets.only(left: 5*fem,top: 20),
          //   width: 90*fem,
          //   height: 80,
          //   child: MultiSelectDropdown(
          //     dropdownItems: ['All','Pick up', 'Delivery', 'Dine in',],
          //     onChanged: (selectedItems) {
          //       print('Selected Items: $selectedItems');
          //       setState(() {
          //         ManageSettingsVariables.consumptionMode = selectedItems;
          //       });
          //     },
          //     selectedValues: ManageSettingsVariables.consumptionMode,
          //     label: 'Item default consumption mode',
          //     controller: TextEditingController(),
          //     required: true, height: 50, width: 90*fem,// Initially selected values
          //   ),
          // ),

          Column(
            children: [
              Container(
                  width:90*fem,
                  margin:EdgeInsets.only(top:20,left:5*fem),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Item default consumption mode",
                        style: TextStyle(
                          fontFamily: 'RenogareSoft',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: GlobalVariables.textColor,
                        ),),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(top: 5),
                height: 43,
                child: MultiSelectDropdown.simpleList(
                  list: ['Pick up', 'Delivery', 'Dine in',],
                  width: 85*fem,
                  initiallySelected:  ManageSettingsVariables.consumptionMode,
                  onChange: (newList) {
                    setState(() {
                      ManageSettingsVariables.consumptionMode = newList.cast<String>();
                    });
                  },
                  includeSearch: true,

                  includeSelectAll: true,
                  boxDecoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  // checkboxFillColor: Color(0xfffbb830),
                  textStyle:  SafeGoogleFont(
                    'Poppins',
                    fontSize: 3.2*fem,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1d1517),
                  ),// Add your hint text or label here
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
