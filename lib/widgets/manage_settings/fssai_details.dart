import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:partner_admin_portal/constants/manage_settings/manage_settings_variables.dart';
import 'package:partner_admin_portal/widgets/custom_textfield.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';

import '../../constants/global_variables.dart';

class FssaiDetails extends StatelessWidget {
  const FssaiDetails({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return ResponsiveBuilder(mobileBuilder: (BuildContext context,BoxConstraints constraints){
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10*fem),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  CustomTextField(label: "FSSAI expiration date", controller: ManageSettingsVariables.fassiDateController,width: 350*fem,),
                  SizedBox(height: 15,),
                  CustomTextField(label: "Enter FSSAI registration number", controller: ManageSettingsVariables.fssaiValidateController,width: 350*fem,),
                  SizedBox(height: 15,),
                  CustomTextField(label: "FSSAI license type", controller: ManageSettingsVariables.fssaiLicsenceTypeController,width: 350*fem,),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  CustomTextField(label: "FSSAI firm name", controller: ManageSettingsVariables.fssaiFirstNameController,width: 350*fem,),
                  SizedBox(height: 15,),
                  CustomTextField(label: "FSSAI address", controller: ManageSettingsVariables.fssaiAddressController,width: 350*fem,),
                  SizedBox(height: 15,),
                  Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Text("Does restaurant function as same place\nin fssai registration certificate?",
                        style:TextStyle(
                          fontFamily: 'RenogareSoft',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: GlobalVariables.textColor,
                        ),),
                      SizedBox(height: 15,),
                      GestureDetector(
                        onTap: () {
                          ManageSettingsVariables.number = !ManageSettingsVariables.number ;
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
              SizedBox(height: 15,),
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
    }, tabletBuilder: (BuildContext context,BoxConstraints constraints){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 5*fem,),
              CustomTextField(label: "FSSAI expiration date", controller: ManageSettingsVariables.fassiDateController,width: 100*fem,),
              SizedBox(width: 15*fem,),
              CustomTextField(label: "Enter FSSAI registration number", controller: ManageSettingsVariables.fssaiValidateController,width: 100*fem,),
              SizedBox(width: 15*fem,),
              CustomTextField(label: "FSSAI license type", controller: ManageSettingsVariables.fssaiLicsenceTypeController,width: 100*fem,),
            ],
          ),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 5*fem,),
              CustomTextField(label: "FSSAI firm name", controller: ManageSettingsVariables.fssaiFirstNameController,width: 100*fem,),
              SizedBox(width: 15*fem,),
              CustomTextField(label: "FSSAI address", controller: ManageSettingsVariables.fssaiAddressController,width: 100*fem,),
              SizedBox(width: 15*fem,),
              Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  Text("Does restaurant function as same place\nin fssai registration certificate?",
                    style:TextStyle(
                      fontFamily: 'RenogareSoft',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: GlobalVariables.textColor,
                    ),),
                  SizedBox(height: 15,),
                  GestureDetector(
                    onTap: () {
                      ManageSettingsVariables.number = !ManageSettingsVariables.number ;
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
      );
    },
        desktopBuilder: (BuildContext context,BoxConstraints constraints){
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 5*fem,),
                  CustomTextField(label: "FSSAI expiration date", controller: ManageSettingsVariables.fassiDateController,width: 100*fem,),
                  SizedBox(width: 15*fem,),
                  CustomTextField(label: "Enter FSSAI registration number", controller: ManageSettingsVariables.fssaiValidateController,width: 100*fem,),
                  SizedBox(width: 15*fem,),
                  CustomTextField(label: "FSSAI license type", controller: ManageSettingsVariables.fssaiLicsenceTypeController,width: 100*fem,),
                ],
              ),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 5*fem,),
                  CustomTextField(label: "FSSAI firm name", controller: ManageSettingsVariables.fssaiFirstNameController,width: 100*fem,),
                  SizedBox(width: 15*fem,),
                  CustomTextField(label: "FSSAI address", controller: ManageSettingsVariables.fssaiAddressController,width: 100*fem,),
                  SizedBox(width: 15*fem,),
                  Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Text("Does restaurant function as same place\nin fssai registration certificate?",
                        style:TextStyle(
                          fontFamily: 'RenogareSoft',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: GlobalVariables.textColor,
                        ),),
                      SizedBox(height: 15,),
                      GestureDetector(
                        onTap: () {
                          ManageSettingsVariables.number = !ManageSettingsVariables.number ;
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
          );
        });
  }
}
