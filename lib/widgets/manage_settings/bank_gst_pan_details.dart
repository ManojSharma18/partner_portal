import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/widgets/responsive_builder.dart';

import '../../bloc/image/image_picker_bloc.dart';
import '../../bloc/image/image_picker_state.dart';
import '../../constants/global_variables.dart';
import '../../constants/manage_settings/manage_settings_variables.dart';
import '../../constants/utils.dart';
import '../custom_textfield.dart';

class BankGstPan extends StatefulWidget {
  const BankGstPan({super.key});

  @override
  State<BankGstPan> createState() => _BankGstPanState();
}

class _BankGstPanState extends State<BankGstPan> {

  bool isBankDetails = true;
  bool isPanDetails = false;
  bool isGstDetails = false;
  bool isFssaiDetails = false;

  void bankDetails(){
    setState(() {
      isBankDetails = !isBankDetails;
    });
  }

  void panDetails(){
    setState(() {
      isPanDetails= !isPanDetails;
    });
  }

  void gstDetails(){
    setState(() {
      isGstDetails = !isGstDetails;
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
    return
      BlocBuilder<ImagePickerBloc, ImagePickerState>(builder: (BuildContext context, state) {
        return ResponsiveBuilder(
            mobileBuilder: (BuildContext context,BoxConstraints constraints) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 10*fem),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 15,),
                      Container(
                        margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Bank details",style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.textColor,
                            ),),

                            IconButton(onPressed: (){
                              bankDetails();
                            }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                          ],
                        ),
                      ),

                      Visibility(
                        visible: isBankDetails,
                        child: Column(
                          children: [
                            SizedBox(height: 30,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 15,),
                                CustomTextField(label: "Enter account number", controller: ManageSettingsVariables.actNumController,width: 350*fem,),
                                SizedBox(height: 15,),
                                CustomTextField(label: "IFSC code", controller: ManageSettingsVariables.ifscController,width: 350*fem,),
                                SizedBox(height: 15,),
                                CustomTextField(label: "Bank UPI id", controller: ManageSettingsVariables.upiIdController,width: 350*fem,),
                              ],
                            ),


                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 15,),
                                CustomTextField(label: "Beneficiary name", controller: ManageSettingsVariables.benificiaryNameController,width: 350*fem,),
                                SizedBox(height: 15,),
                                CustomTextField(label: "Bank name", controller: ManageSettingsVariables.bankNameController,width: 350*fem,),
                                SizedBox(height: 15,),
                                // CustomTextField(label:  "Passbook first page uploaded type", controller: ManageSettingsVariables.bankDocController,
                                //   width: 100*fem,dropdownItems: ['Image','Document'],isDropdown: true,),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:300*fem,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Passbook first page document upload',
                                              style: TextStyle(
                                                fontFamily: 'RenogareSoft',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: GlobalVariables.textColor,
                                              ),),
                                            SizedBox(height: 10,),
                                            Container(
                                              margin: EdgeInsets.only(top: 0, right: 10,left:20),
                                              child: GestureDetector(
                                                onTap: (){
                                                  context.read<ImagePickerBloc>().add(PickImageEvent());
                                                },
                                                child: ManageSettingsVariables.pickedPassbookImage == null
                                                    ? DottedBorder(
                                                    borderType: BorderType.RRect,
                                                    radius: const Radius.circular(10),
                                                    dashPattern: const [10,1],
                                                    color:Color(0xffe0e8e8),
                                                    strokeCap: StrokeCap.round,
                                                    child: Container(
                                                      width: 180,
                                                      height: 110,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child:Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          const Icon(Icons.file_upload_outlined,size: 30,color: Colors.black26,),
                                                          const SizedBox(height: 5,),
                                                          Text("Browse file to update \n         [Max: 5MB] \n \n     (png,jpg,bmp only)",
                                                            style: SafeGoogleFont(
                                                              'Poppins',
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.w600,
                                                              color: Color(0xff9796a1),
                                                            ),),

                                                        ],
                                                      ) ,
                                                    ))
                                                    : DottedBorder(

                                                  borderType: BorderType.RRect,
                                                  radius: const Radius.circular(10),
                                                  dashPattern: const [10, 1],
                                                  strokeCap: StrokeCap.round,
                                                  child: Container(
                                                    width: 180,
                                                    height: 110,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Image.memory(
                                                      ManageSettingsVariables.passbookImage!, // Use _pickedImage instead of webImage
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),


                      SizedBox(height: 15,),
                      Container(margin : EdgeInsets.only(left: 5*fem,right: 5*fem),height: 1,color: GlobalVariables.primaryColor,),

                      Container(
                        margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("PAN details",style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.textColor,
                            ),),

                            IconButton(onPressed: (){
                              panDetails();
                            }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                          ],
                        ),
                      ),

                      Visibility(
                        visible: isPanDetails,
                        child: Column(
                          children: [
                            SizedBox(height: 15,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 15,),
                                CustomTextField(label: "PAN belongs to", controller: ManageSettingsVariables.panBelongController,width: 350*fem,
                                  dropdownItems: ['Company','Individual'],isDropdown: true,),
                                SizedBox(height: 15,),
                                CustomTextField(label: "Enter PAN number", controller: ManageSettingsVariables.panNumberController,width: 350*fem,),
                                SizedBox(height: 15,),
                                CustomTextField(label:  "Enter name in PAN", controller: ManageSettingsVariables.panNameController,width: 350*fem,),
                                SizedBox(height: 15,),
                                Container(
                                  width:300*fem,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('PAN card documnet upload',style: TextStyle(
                                        fontFamily: 'RenogareSoft',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: GlobalVariables.textColor,
                                      ),),
                                      SizedBox(height: 10,),
                                      Container(
                                        margin: EdgeInsets.only(top: 0, right: 10,left:20),
                                        child: GestureDetector(
                                          onTap:(){
                                            context.read<ImagePickerBloc>().add(PickPanImageEvent());
                                          },
                                          child: ManageSettingsVariables.pickedPankImage == null
                                              ? DottedBorder(
                                              borderType: BorderType.RRect,
                                              radius: const Radius.circular(10),
                                              dashPattern: const [10,1],
                                              color:Color(0xffe0e8e8),
                                              strokeCap: StrokeCap.round,
                                              child: Container(
                                                width: 180,
                                                height: 110,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child:Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.file_upload_outlined,size: 30,color: Colors.black26,),
                                                    const SizedBox(height: 5,),
                                                    Text("Browse file to update \n         [Max: 5MB] \n \n     (png,jpg,bmp only)",
                                                      style: SafeGoogleFont(
                                                        'Poppins',
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w600,
                                                        color: Color(0xff9796a1),
                                                      ),),
                                                  ],
                                                ) ,
                                              ))
                                              : DottedBorder(

                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(10),
                                            dashPattern: const [10, 1],
                                            strokeCap: StrokeCap.round,
                                            child: Container(
                                              width: 180,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Image.memory(
                                                ManageSettingsVariables.panImage!, // Use _pickedImage instead of webImage
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(height: 25,),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     SizedBox(width: 5*fem,),
                            //     CustomTextField(label: "PAN document upload type", controller: ManageSettingsVariables.panDocController,width: 100*fem,
                            //       dropdownItems: ['Image','Document'],isDropdown: true,),
                            //     SizedBox(width: 20*fem,),
                            //
                            //   ],
                            // ),
                          ],
                        ),
                      ),

                      SizedBox(height: 15,),
                      Container(margin : EdgeInsets.only(left: 5*fem,right: 5*fem),height: 1,color: GlobalVariables.primaryColor,),

                      Container(
                        margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("GST details",style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.textColor,
                            ),),

                            IconButton(onPressed: (){
                              gstDetails();
                            }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                          ],
                        ),
                      ),

                      Visibility(
                        visible: isGstDetails,
                        child: Column(
                          children: [
                            SizedBox(height: 15,),
                            Container(
                              margin: EdgeInsets.only(left: 5*fem),
                              child: Row(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: [
                                  Text("Do you have a GSTIN?",
                                    style:TextStyle(
                                      fontFamily: 'RenogareSoft',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: GlobalVariables.textColor,
                                    ),),
                                  SizedBox(width: 20,),
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
                              ),
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 15,),
                                CustomTextField(label: "Restaurant GSTIN", controller: ManageSettingsVariables.gstinController,width: 350*fem,),
                                SizedBox(height: 15,),
                                CustomTextField(label: "GST category", controller: ManageSettingsVariables.gstCategoryController,width: 350*fem,),
                                SizedBox(height: 15,),
                                // CustomTextField(label:  "GST certificate upload type", controller: ManageSettingsVariables.gstDocController,width: 100*fem,
                                //   dropdownItems: ['Image','Document'],isDropdown: true,),
                                Container(
                                  margin: EdgeInsets.only(top:20),
                                  width:300*fem,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('GSTIN certificate document upload',style: TextStyle(
                                        fontFamily: 'RenogareSoft',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: GlobalVariables.textColor,
                                      ),),
                                      SizedBox(height: 10,),
                                      Container(
                                        margin: EdgeInsets.only(top: 0, right: 10,left:30),
                                        child: GestureDetector(
                                          onTap: (){
                                            context.read<ImagePickerBloc>().add(PickGstImageEvent());
                                          },
                                          child: ManageSettingsVariables.pickedGstImage == null
                                              ? DottedBorder(
                                              borderType: BorderType.RRect,
                                              radius: const Radius.circular(10),
                                              dashPattern: const [10,1],
                                              color:Color(0xffe0e8e8),
                                              strokeCap: StrokeCap.round,
                                              child: Container(
                                                width: 180,
                                                height: 110,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child:Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.file_upload_outlined,size: 30,color: Colors.black26,),
                                                    const SizedBox(height: 5,),
                                                    Text("Browse file to update \n         [Max: 5MB] \n \n     (png,jpg,bmp only)",
                                                      style: SafeGoogleFont(
                                                        'Poppins',
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w600,
                                                        color: Color(0xff9796a1),
                                                      ),),

                                                  ],
                                                ) ,
                                              ))
                                              : DottedBorder(

                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(10),
                                            dashPattern: const [10, 1],
                                            strokeCap: StrokeCap.round,
                                            child: Container(
                                              width: 180,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Image.memory(
                                                ManageSettingsVariables.gstImage!, // Use _pickedImage instead of webImage
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25,),
                          ],
                        ),
                      ),

                      Container(margin : EdgeInsets.only(left: 5*fem,right: 5*fem),height: 1,color: GlobalVariables.primaryColor,),

                      SizedBox(height: 15,),
                      Container(
                        margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("FSSAI details",style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: GlobalVariables.textColor,
                            ),),

                            IconButton(onPressed: (){
                              changeFssaiDetails();
                            }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                          ],
                        ),
                      ),
                      Visibility(
                        visible: isFssaiDetails,
                        child: Column(
                          children: [
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
                            SizedBox(height: 25,),
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
                SizedBox(height: 15,),
                Container(
                  margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Bank details",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: GlobalVariables.textColor,
                      ),),

                      IconButton(onPressed: (){
                        bankDetails();
                      }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                    ],
                  ),
                ),

                Visibility(
                  visible: isBankDetails,
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 5*fem,),
                          CustomTextField(label: "Enter account number", controller: ManageSettingsVariables.actNumController,width: 100*fem,),
                          SizedBox(width: 15*fem,),
                          CustomTextField(label: "IFSC code", controller: ManageSettingsVariables.ifscController,width: 100*fem,),
                          SizedBox(width: 15*fem,),
                          CustomTextField(label: "Bank UPI id", controller: ManageSettingsVariables.upiIdController,width: 100*fem,),
                        ],
                      ),

                      SizedBox(height: 25,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 5*fem,),
                          CustomTextField(label: "Beneficiary name", controller: ManageSettingsVariables.benificiaryNameController,width: 100*fem,),
                          SizedBox(width: 15*fem,),
                          CustomTextField(label: "Bank name", controller: ManageSettingsVariables.bankNameController,width: 100*fem,),
                          SizedBox(width: 15*fem,),
                          // CustomTextField(label:  "Passbook first page uploaded type", controller: ManageSettingsVariables.bankDocController,
                          //   width: 100*fem,dropdownItems: ['Image','Document'],isDropdown: true,),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width:100*fem,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Passbook first page document upload',
                                        style: TextStyle(
                                          fontFamily: 'RenogareSoft',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: GlobalVariables.textColor,
                                        ),),
                                      SizedBox(height: 10,),
                                      Container(
                                        margin: EdgeInsets.only(top: 0, right: 10,left:20),
                                        child: GestureDetector(
                                          onTap: (){
                                            context.read<ImagePickerBloc>().add(PickImageEvent());
                                          },
                                          child: ManageSettingsVariables.pickedPassbookImage == null
                                              ? DottedBorder(
                                              borderType: BorderType.RRect,
                                              radius: const Radius.circular(10),
                                              dashPattern: const [10,1],
                                              color:Color(0xffe0e8e8),
                                              strokeCap: StrokeCap.round,
                                              child: Container(
                                                width: 180,
                                                height: 110,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child:Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.file_upload_outlined,size: 30,color: Colors.black26,),
                                                    const SizedBox(height: 5,),
                                                    Text("Browse file to update \n         [Max: 5MB] \n \n     (png,jpg,bmp only)",
                                                      style: SafeGoogleFont(
                                                        'Poppins',
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w600,
                                                        color: Color(0xff9796a1),
                                                      ),),

                                                  ],
                                                ) ,
                                              ))
                                              : DottedBorder(

                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(10),
                                            dashPattern: const [10, 1],
                                            strokeCap: StrokeCap.round,
                                            child: Container(
                                              width: 180,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Image.memory(
                                                ManageSettingsVariables.passbookImage!, // Use _pickedImage instead of webImage
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),


                SizedBox(height: 15,),
                Container(margin : EdgeInsets.only(left: 5*fem,right: 5*fem),height: 1,color: GlobalVariables.primaryColor,),

                Container(
                  margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("PAN details",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: GlobalVariables.textColor,
                      ),),

                      IconButton(onPressed: (){
                        panDetails();
                      }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                    ],
                  ),
                ),

                Visibility(
                  visible: isPanDetails,
                  child: Column(
                    children: [
                      SizedBox(height: 25,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 5*fem,),
                          CustomTextField(label: "PAN belongs to", controller: ManageSettingsVariables.panBelongController,width: 100*fem,
                            dropdownItems: ['Company','Individual'],isDropdown: true,),
                          SizedBox(width: 15*fem,),
                          CustomTextField(label: "Enter PAN number", controller: ManageSettingsVariables.panNumberController,width: 100*fem,),
                          SizedBox(width: 15*fem,),
                          CustomTextField(label:  "Enter name in PAN", controller: ManageSettingsVariables.panNameController,width: 100*fem,),
                        ],
                      ),
                      SizedBox(height: 25,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 5*fem,),
                          Container(
                            width:100*fem,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('PAN card documnet upload',style: TextStyle(
                                  fontFamily: 'RenogareSoft',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: GlobalVariables.textColor,
                                ),),
                                SizedBox(height: 10,),
                                Container(
                                  margin: EdgeInsets.only(top: 0, right: 10,left:20),
                                  child: GestureDetector(
                                    onTap:(){
                                      context.read<ImagePickerBloc>().add(PickPanImageEvent());
                                    },
                                    child: ManageSettingsVariables.pickedPankImage == null
                                        ? DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(10),
                                        dashPattern: const [10,1],
                                        color:Color(0xffe0e8e8),
                                        strokeCap: StrokeCap.round,
                                        child: Container(
                                          width: 180,
                                          height: 110,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child:Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.file_upload_outlined,size: 30,color: Colors.black26,),
                                              const SizedBox(height: 5,),
                                              Text("Browse file to update \n         [Max: 5MB] \n \n     (png,jpg,bmp only)",
                                                style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff9796a1),
                                                ),),
                                            ],
                                          ) ,
                                        ))
                                        : DottedBorder(

                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(10),
                                      dashPattern: const [10, 1],
                                      strokeCap: StrokeCap.round,
                                      child: Container(
                                        width: 180,
                                        height: 110,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Image.memory(
                                          ManageSettingsVariables.panImage!, // Use _pickedImage instead of webImage
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15,),
                Container(margin : EdgeInsets.only(left: 5*fem,right: 5*fem),height: 1,color: GlobalVariables.primaryColor,),

                Container(
                  margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("GST details",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: GlobalVariables.textColor,
                      ),),

                      IconButton(onPressed: (){
                        gstDetails();
                      }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                    ],
                  ),
                ),

                Visibility(
                  visible: isGstDetails,
                  child: Column(
                    children: [
                      SizedBox(height: 25,),
                      Container(
                        margin: EdgeInsets.only(left: 5*fem),
                        child: Row(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children: [
                            Text("Do you have a GSTIN?",
                              style:TextStyle(
                                fontFamily: 'RenogareSoft',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: GlobalVariables.textColor,
                              ),),
                            SizedBox(width: 20,),
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
                        ),
                      ),
                      SizedBox(height: 25,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 5*fem,),
                          CustomTextField(label: "Restaurant GSTIN", controller: ManageSettingsVariables.gstinController,width: 100*fem,),
                          SizedBox(width: 15*fem,),
                          CustomTextField(label: "GST category", controller: ManageSettingsVariables.gstCategoryController,width: 100*fem,),
                          SizedBox(width: 15*fem,),
                          Container(
                            margin: EdgeInsets.only(top:20),
                            width:100*fem,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('GSTIN certificate document upload',style: TextStyle(
                                  fontFamily: 'RenogareSoft',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: GlobalVariables.textColor,
                                ),),
                                SizedBox(height: 10,),
                                Container(
                                  margin: EdgeInsets.only(top: 0, right: 10,left:30),
                                  child: GestureDetector(
                                    onTap: (){
                                      context.read<ImagePickerBloc>().add(PickGstImageEvent());
                                    },
                                    child: ManageSettingsVariables.pickedGstImage == null
                                        ? DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(10),
                                        dashPattern: const [10,1],
                                        color:Color(0xffe0e8e8),
                                        strokeCap: StrokeCap.round,
                                        child: Container(
                                          width: 180,
                                          height: 110,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child:Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.file_upload_outlined,size: 30,color: Colors.black26,),
                                              const SizedBox(height: 5,),
                                              Text("Browse file to update \n         [Max: 5MB] \n \n     (png,jpg,bmp only)",
                                                style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff9796a1),
                                                ),),

                                            ],
                                          ) ,
                                        ))
                                        : DottedBorder(

                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(10),
                                      dashPattern: const [10, 1],
                                      strokeCap: StrokeCap.round,
                                      child: Container(
                                        width: 180,
                                        height: 110,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Image.memory(
                                          ManageSettingsVariables.gstImage!, // Use _pickedImage instead of webImage
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25,),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Container(margin : EdgeInsets.only(left: 5*fem,right: 5*fem),height: 1,color: GlobalVariables.primaryColor,),

                Container(
                  margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("FSSAI details",style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: GlobalVariables.textColor,
                      ),),

                      IconButton(onPressed: (){
                        changeFssaiDetails();
                      }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Visibility(
                  visible: isFssaiDetails,
                  child: Column(
                    children: [
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
                          Text("Bank details",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: GlobalVariables.textColor,
                          ),),

                          IconButton(onPressed: (){
                            bankDetails();
                          }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                        ],
                      ),
                    ),

                    Visibility(
                      visible: isBankDetails,
                      child: Column(
                        children: [
                          SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 5*fem,),
                              CustomTextField(label: "Enter account number", controller: ManageSettingsVariables.actNumController,width: 100*fem,),
                              SizedBox(width: 15*fem,),
                              CustomTextField(label: "IFSC code", controller: ManageSettingsVariables.ifscController,width: 100*fem,),
                              SizedBox(width: 15*fem,),
                              CustomTextField(label: "Bank UPI id", controller: ManageSettingsVariables.upiIdController,width: 100*fem,),
                            ],
                          ),

                          SizedBox(height: 25,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 5*fem,),
                              CustomTextField(label: "Beneficiary name", controller: ManageSettingsVariables.benificiaryNameController,width: 100*fem,),
                              SizedBox(width: 15*fem,),
                              CustomTextField(label: "Bank name", controller: ManageSettingsVariables.bankNameController,width: 100*fem,),
                              SizedBox(width: 15*fem,),
                              // CustomTextField(label:  "Passbook first page uploaded type", controller: ManageSettingsVariables.bankDocController,
                              //   width: 100*fem,dropdownItems: ['Image','Document'],isDropdown: true,),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:100*fem,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Passbook first page document upload',
                                            style: TextStyle(
                                              fontFamily: 'RenogareSoft',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: GlobalVariables.textColor,
                                            ),),
                                          SizedBox(height: 10,),
                                          Container(
                                            margin: EdgeInsets.only(top: 0, right: 10,left:20),
                                            child: GestureDetector(
                                              onTap: (){
                                                context.read<ImagePickerBloc>().add(PickImageEvent());
                                              },
                                              child: ManageSettingsVariables.pickedPassbookImage == null
                                                  ? DottedBorder(
                                                  borderType: BorderType.RRect,
                                                  radius: const Radius.circular(10),
                                                  dashPattern: const [10,1],
                                                  color:Color(0xffe0e8e8),
                                                  strokeCap: StrokeCap.round,
                                                  child: Container(
                                                    width: 180,
                                                    height: 110,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child:Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        const Icon(Icons.file_upload_outlined,size: 30,color: Colors.black26,),
                                                        const SizedBox(height: 5,),
                                                        Text("Browse file to update \n         [Max: 5MB] \n \n     (png,jpg,bmp only)",
                                                          style: SafeGoogleFont(
                                                            'Poppins',
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w600,
                                                            color: Color(0xff9796a1),
                                                          ),),

                                                      ],
                                                    ) ,
                                                  ))
                                                  : DottedBorder(

                                                borderType: BorderType.RRect,
                                                radius: const Radius.circular(10),
                                                dashPattern: const [10, 1],
                                                strokeCap: StrokeCap.round,
                                                child: Container(
                                                  width: 180,
                                                  height: 110,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Image.memory(
                                                    ManageSettingsVariables.passbookImage!, // Use _pickedImage instead of webImage
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),


                    SizedBox(height: 15,),
                    Container(margin : EdgeInsets.only(left: 5*fem,right: 5*fem),height: 1,color: GlobalVariables.primaryColor,),

                    Container(
                      margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("PAN details",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: GlobalVariables.textColor,
                          ),),

                          IconButton(onPressed: (){
                            panDetails();
                          }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                        ],
                      ),
                    ),

                    Visibility(
                      visible: isPanDetails,
                      child: Column(
                        children: [
                          SizedBox(height: 25,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 5*fem,),
                              CustomTextField(label: "PAN belongs to", controller: ManageSettingsVariables.panBelongController,width: 100*fem,
                                dropdownItems: ['Company','Individual'],isDropdown: true,),
                              SizedBox(width: 15*fem,),
                              CustomTextField(label: "Enter PAN number", controller: ManageSettingsVariables.panNumberController,width: 100*fem,),
                              SizedBox(width: 15*fem,),
                              CustomTextField(label:  "Enter name in PAN", controller: ManageSettingsVariables.panNameController,width: 100*fem,),
                            ],
                          ),
                          SizedBox(height: 25,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 5*fem,),
                              Container(
                                width:100*fem,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('PAN card documnet upload',style: TextStyle(
                                      fontFamily: 'RenogareSoft',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: GlobalVariables.textColor,
                                    ),),
                                    SizedBox(height: 10,),
                                    Container(
                                      margin: EdgeInsets.only(top: 0, right: 10,left:20),
                                      child: GestureDetector(
                                        onTap:(){
                                          context.read<ImagePickerBloc>().add(PickPanImageEvent());
                                        },
                                        child: ManageSettingsVariables.pickedPankImage == null
                                            ? DottedBorder(
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(10),
                                            dashPattern: const [10,1],
                                            color:Color(0xffe0e8e8),
                                            strokeCap: StrokeCap.round,
                                            child: Container(
                                              width: 180,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child:Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.file_upload_outlined,size: 30,color: Colors.black26,),
                                                  const SizedBox(height: 5,),
                                                  Text("Browse file to update \n         [Max: 5MB] \n \n     (png,jpg,bmp only)",
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xff9796a1),
                                                    ),),
                                                ],
                                              ) ,
                                            ))
                                            : DottedBorder(

                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(10),
                                          dashPattern: const [10, 1],
                                          strokeCap: StrokeCap.round,
                                          child: Container(
                                            width: 180,
                                            height: 110,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Image.memory(
                                              ManageSettingsVariables.panImage!, // Use _pickedImage instead of webImage
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15,),
                    Container(margin : EdgeInsets.only(left: 5*fem,right: 5*fem),height: 1,color: GlobalVariables.primaryColor,),

                    Container(
                      margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("GST details",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: GlobalVariables.textColor,
                          ),),

                          IconButton(onPressed: (){
                            gstDetails();
                          }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                        ],
                      ),
                    ),

                    Visibility(
                      visible: isGstDetails,
                      child: Column(
                        children: [
                          SizedBox(height: 25,),
                          Container(
                            margin: EdgeInsets.only(left: 5*fem),
                            child: Row(
                              crossAxisAlignment:CrossAxisAlignment.start,
                              children: [
                                Text("Do you have a GSTIN?",
                                  style:TextStyle(
                                    fontFamily: 'RenogareSoft',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: GlobalVariables.textColor,
                                  ),),
                                SizedBox(width: 20,),
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
                            ),
                          ),
                          SizedBox(height: 25,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 5*fem,),
                              CustomTextField(label: "Restaurant GSTIN", controller: ManageSettingsVariables.gstinController,width: 100*fem,),
                              SizedBox(width: 15*fem,),
                              CustomTextField(label: "GST category", controller: ManageSettingsVariables.gstCategoryController,width: 100*fem,),
                              SizedBox(width: 15*fem,),
                              Container(
                                margin: EdgeInsets.only(top:20),
                                width:100*fem,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('GSTIN certificate document upload',style: TextStyle(
                                      fontFamily: 'RenogareSoft',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: GlobalVariables.textColor,
                                    ),),
                                    SizedBox(height: 10,),
                                    Container(
                                      margin: EdgeInsets.only(top: 0, right: 10,left:30),
                                      child: GestureDetector(
                                        onTap: (){
                                          context.read<ImagePickerBloc>().add(PickGstImageEvent());
                                        },
                                        child: ManageSettingsVariables.pickedGstImage == null
                                            ? DottedBorder(
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(10),
                                            dashPattern: const [10,1],
                                            color:Color(0xffe0e8e8),
                                            strokeCap: StrokeCap.round,
                                            child: Container(
                                              width: 180,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child:Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.file_upload_outlined,size: 30,color: Colors.black26,),
                                                  const SizedBox(height: 5,),
                                                  Text("Browse file to update \n         [Max: 5MB] \n \n     (png,jpg,bmp only)",
                                                    style: SafeGoogleFont(
                                                      'Poppins',
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xff9796a1),
                                                    ),),

                                                ],
                                              ) ,
                                            ))
                                            : DottedBorder(

                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(10),
                                          dashPattern: const [10, 1],
                                          strokeCap: StrokeCap.round,
                                          child: Container(
                                            width: 180,
                                            height: 110,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Image.memory(
                                              ManageSettingsVariables.gstImage!, // Use _pickedImage instead of webImage
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25,),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(margin : EdgeInsets.only(left: 5*fem,right: 5*fem),height: 1,color: GlobalVariables.primaryColor,),

                    SizedBox(height: 15,),
                    Container(
                      margin: EdgeInsets.only(left: 5*fem,right: 5*fem),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("FSSAI details",style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: GlobalVariables.textColor,
                          ),),

                          IconButton(onPressed: (){
                            changeFssaiDetails();
                          }, icon: Icon(Icons.arrow_drop_down_outlined,size: 30,color: GlobalVariables.primaryColor,))

                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Visibility(
                      visible: isFssaiDetails,
                      child: Column(
                        children: [
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
                        ],
                      ),
                    ),


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
              );
            });
      },

      );
  }
}
