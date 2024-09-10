import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_event.dart';
import 'package:partner_admin_portal/bloc/manage_settings/manage_settings_state.dart';
import 'package:partner_admin_portal/widgets/custom_textfield.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';

import '../../constants/global_variables.dart';
import '../../constants/manage_settings/manage_settings_variables.dart';
import '../../constants/utils.dart';
import 'fssai_details.dart';

class RestaurantDetails extends StatefulWidget {
  final BuildContext manageSettingsContext;
  const RestaurantDetails({super.key, required this.manageSettingsContext});

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {

  bool isUnitDetails = true;
  bool isFssaiDetails = false;

  void changeUnitDetails(){
    setState(() {
      isUnitDetails = !isUnitDetails;
    });
  }

  void changeFssaiDetails(){
    setState(() {
      isFssaiDetails = !isFssaiDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return BlocBuilder<ManageSettingsBloc,ManageSettingState>(builder: (BuildContext context, state) {
      return ResponsiveBuilder(
          mobileBuilder: (BuildContext context,BoxConstraints constraints){
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 10*fem),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 15,),
                    Container(
                      margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Unit details",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: GlobalVariables.textColor,
                          ),),

                          IconButton(onPressed: (){
                            changeUnitDetails();
                          }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                        ],
                      ),
                    ),
                    Visibility(
                      visible: isUnitDetails,
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              CustomTextField(label: "Unit display name", controller: ManageSettingsVariables.restaurantDisplayNameController,width: 350*fem,),
                              SizedBox(height: 15),
                              CustomTextField(label: "Unit Mobile number", controller: ManageSettingsVariables.unitMobController,width: 350*fem,),
                              SizedBox(height: 15),
                              CustomTextField(label: "Unit invoicing email ID ", controller: ManageSettingsVariables.unitEmailController,width: 350*fem,),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              CustomTextField(label:  "Unit business model", controller: ManageSettingsVariables.restaurantModelController,width: 350*fem,
                                onChangedDropdown: (val) {
                                  print("restaurant model ${ManageSettingsVariables.restaurantModelController.text}");
                                  ManageSettingsVariables.restaurantModelController.text = val!;
                                  widget.manageSettingsContext.read<ManageSettingsBloc>().add(ChangeRestaurantModelEvent(widget.manageSettingsContext, val));

                                },
                                isChangedDropDown: true,
                                dropdownItems: ["Preorder", "Subscription" ,'Both'],isDropdown: true,),
                              SizedBox(height: 15),
                              CustomTextField(label: "Unit items availability", controller: ManageSettingsVariables.itemsAvailabilityController,width: 350*fem,
                                dropdownItems: ["Count based", 'Non count based'],isDropdown: true,),
                              SizedBox(height: 15),
                              CustomTextField(label: "Unit size",
                                controller: ManageSettingsVariables.unitTypeController,
                                dropdownItems: ['Home chef', 'QSR', 'Restaurant - small','Restaurant - medium', 'Restaurant - fine dine' ],isDropdown: true,
                                width: 350*fem,
                              ),

                            ],
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              CustomTextField(label:  "Pincode", controller: ManageSettingsVariables.pincodeController,width: 350*fem,),
                              SizedBox(height: 15),
                              CustomTextField(label: "City", controller: ManageSettingsVariables.cityController,width: 350*fem,),
                              SizedBox(height: 15),
                              CustomTextField(label: "State", controller: ManageSettingsVariables.stateController,width: 350*fem,),
                            ],
                          ),
                          SizedBox(height: 25,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 5*fem,),
                              CustomTextField(label: "Address", controller: ManageSettingsVariables.addressController,width: 350*fem,),

                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15,),
                    Container(margin : EdgeInsets.only(left: 5*fem,right: 5*fem),height: 1,color: GlobalVariables.primaryColor,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              right: 50, top: 30, bottom: 30),
                          width: 250,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {

                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black, backgroundColor: Color(0xfffbb830),
                              // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Circular border radius
                              ),
                            ),
                            child: Text(
                              'Change',
                              style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Open Sans',
                                fontSize: 18,
                              ),
                              // Text color
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          tabletBuilder: (BuildContext context,BoxConstraints constraints){
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),

                  Container(
                    margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Unit details",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: GlobalVariables.textColor,
                        ),),

                        IconButton(onPressed: (){
                          changeUnitDetails();
                        }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Visibility(
                    visible: isUnitDetails,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 5*fem,),
                            CustomTextField(label: "Unit display name", controller: ManageSettingsVariables.restaurantDisplayNameController,width: 100*fem,),
                            SizedBox(width: 15*fem,),
                            CustomTextField(label: "Unit Mobile number", controller: ManageSettingsVariables.unitMobController,width: 100*fem,),
                            SizedBox(width: 15*fem,),

                            CustomTextField(label: "Unit invoicing email ID ", controller: ManageSettingsVariables.unitEmailController,width: 100*fem,),
                          ],
                        ),
                        SizedBox(height: 25,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 5*fem,),
                            CustomTextField(label:  "Unit business model", controller: ManageSettingsVariables.restaurantModelController,width: 100*fem,
                              isChangedDropDown: true,
                              onChangedDropdown: (val) {
                                print("restaurant model ${ManageSettingsVariables.restaurantModelController.text}");
                                ManageSettingsVariables.restaurantModelController.text = val!;
                                widget.manageSettingsContext.read<ManageSettingsBloc>().add(ChangeRestaurantModelEvent(widget.manageSettingsContext, val));

                              },
                              dropdownItems: ["Preorder", "Subscription" ,'Both'],isDropdown: true,),
                            SizedBox(width: 15*fem,),
                            CustomTextField(label: "Unit items availability", controller: ManageSettingsVariables.itemsAvailabilityController,width: 100*fem,
                              dropdownItems: ["Count based", 'Non count based'],isDropdown: true,),
                            SizedBox(width: 15*fem,),
                            CustomTextField(label: "Unit size",
                              controller: ManageSettingsVariables.unitTypeController,
                              dropdownItems: ['Home chef', 'QSR', 'Restaurant - small','Restaurant - medium', 'Restaurant - fine dine' ],isDropdown: true,
                              width: 100*fem,
                            ),

                          ],
                        ),
                        SizedBox(height: 25,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 5*fem,),
                            CustomTextField(label:  "Pincode", controller: ManageSettingsVariables.pincodeController,width: 100*fem,),
                            SizedBox(width: 15*fem,),
                            CustomTextField(label: "City", controller: ManageSettingsVariables.cityController,width: 100*fem,),
                            SizedBox(width: 15*fem,),
                            CustomTextField(label: "State", controller: ManageSettingsVariables.stateController,width: 100*fem,),
                          ],
                        ),
                        SizedBox(height: 25,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 5*fem,),
                            CustomTextField(label: "Address", controller: ManageSettingsVariables.addressController,width: 330*fem,),

                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 15,),
                  Container(margin : EdgeInsets.only(left: 5*fem,right: 5*fem),height: 1,color: GlobalVariables.primaryColor,),
                  SizedBox(height: 30,),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            right: 50, top: 30, bottom: 30),
                        width: 250,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Color(0xfffbb830),
                            // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5), // Circular border radius
                            ),
                          ),
                          child: Text(
                            'Change',
                            style: TextStyle(color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Open Sans',
                              fontSize: 18,
                            ),
                            // Text color
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          desktopBuilder: (BuildContext context,BoxConstraints constraints){
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  Container(
                    margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Unit details",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: GlobalVariables.textColor,
                        ),),

                        IconButton(onPressed: (){
                          changeUnitDetails();
                        }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Visibility(
                    visible: isUnitDetails,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 5*fem,),
                            CustomTextField(label: "Unit display name", controller: ManageSettingsVariables.restaurantDisplayNameController,width: 100*fem,),
                            SizedBox(width: 15*fem,),
                            CustomTextField(label: "Unit Mobile number", controller: ManageSettingsVariables.unitMobController,width: 100*fem,),
                            SizedBox(width: 15*fem,),

                            CustomTextField(label: "Unit invoicing email ID ", controller: ManageSettingsVariables.unitEmailController,width: 100*fem,),
                          ],
                        ),
                        SizedBox(height: 25,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 5*fem,),
                            CustomTextField(label:  "Unit business model", controller: ManageSettingsVariables.restaurantModelController,width: 100*fem,
                              isChangedDropDown: true,
                              onChangedDropdown: (val) {
                                print("restaurant model ${ManageSettingsVariables.restaurantModelController.text}");
                                ManageSettingsVariables.restaurantModelController.text = val!;
                                widget.manageSettingsContext.read<ManageSettingsBloc>().add(ChangeRestaurantModelEvent(widget.manageSettingsContext, val));

                              },
                              dropdownItems: ["Preorder", "Subscription" ,'Both'],isDropdown: true,),
                            SizedBox(width: 15*fem,),
                            CustomTextField(label: "Unit items availability", controller: ManageSettingsVariables.itemsAvailabilityController,width: 100*fem,
                              dropdownItems: ["Count based", 'Non count based'],isDropdown: true,),
                            SizedBox(width: 15*fem,),
                            CustomTextField(label: "Unit size",
                              controller: ManageSettingsVariables.unitTypeController,
                              dropdownItems: ['Home chef', 'QSR', 'Restaurant - small','Restaurant - medium', 'Restaurant - fine dine' ],isDropdown: true,
                              width: 100*fem,
                            ),

                          ],
                        ),
                        SizedBox(height: 25,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 5*fem,),
                            CustomTextField(label:  "Pincode", controller: ManageSettingsVariables.pincodeController,width: 100*fem,),
                            SizedBox(width: 15*fem,),
                            CustomTextField(label: "City", controller: ManageSettingsVariables.cityController,width: 100*fem,),
                            SizedBox(width: 15*fem,),
                            CustomTextField(label: "State", controller: ManageSettingsVariables.stateController,width: 100*fem,),
                          ],
                        ),
                        SizedBox(height: 25,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 5*fem,),
                            CustomTextField(label: "Address", controller: ManageSettingsVariables.addressController,width: 330*fem,),

                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 15,),
                  Container(margin : EdgeInsets.only(left: 5*fem,right: 5*fem),height: 1,color: GlobalVariables.primaryColor,),

                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            right: 50, top: 30, bottom: 30),
                        width: 250,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Color(0xfffbb830),
                            // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5), // Circular border radius
                            ),
                          ),
                          child: Text(
                            'Change',
                            style: TextStyle(color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Open Sans',
                              fontSize: 18,
                            ),
                            // Text color
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            );
          });
    },

    );
  }
}
