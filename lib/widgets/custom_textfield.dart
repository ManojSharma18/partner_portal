import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/utils.dart';


class CustomTextField extends StatefulWidget {
  final String label;
  final bool required;
  final TextEditingController controller;
  final double height;
  final double width;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final bool showSearchBox1;
  final String itemName;
  final Function(String?)? onChanged;
  final VoidCallback? onTap;
  final bool showGenerateOTP;
  final bool showVerifyOTP;
  final bool showVerifyFassi;
  final bool showVerifyPan;
  final bool showCalendar;
  final Function(DateTime)? onDateSelected;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final String? suffixTooltip;
  final String? hintText;
  final bool readOnly;
  final double fontSize;
  final double dropdownSize;
  final bool dropdownAuto;

  CustomTextField({
    required this.label,
    this.required = false,
    required this.controller,
    this.height = 40,
    this.width = 150,
    this.isDropdown = false,
    this.dropdownItems,
    this.showSearchBox1 = false,
    this.onChanged,
    this.onTap,
    this.itemName = "",
    this.showGenerateOTP = false,
    this.showVerifyOTP = false,
    this.showCalendar = false,
    this.showVerifyFassi = false,
    this.onDateSelected,
    this.showVerifyPan = false,
    this.prefixWidget,
    this.suffixWidget,
    this.suffixTooltip,
    this.hintText,
    this.readOnly = false,
    this.fontSize =12,
    this.dropdownSize=14,
    this.dropdownAuto = false
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  GlobalKey<DropdownSearchState<String>> dropdownKey = GlobalKey();
  bool _isNumberEntered = false;
  String? selectedValue;
  bool _isValidNumber = true;
  DateTime? _selectedDate;

  bool dropAddItem = false;

  @override
  void initState() {
    super.initState();
    if (widget.isDropdown && widget.dropdownItems!.isNotEmpty && widget.controller.text.isEmpty) {
      widget.controller.text = widget.dropdownItems!.first;
    }
    selectedValue = widget.dropdownItems?.isNotEmpty == true
        ? '' // Set default as the first item in the list
        : null;
    selectedValue = widget.dropdownItems?.isNotEmpty == true ? '' : null;
    // _selectedDate = widget.controller.text.isNotEmpty
    //     ? DateTime.parse(widget.controller.text) // Parse the saved date from the controller
    //     : null;
    if(widget.dropdownAuto)
      {
        Future.delayed(Duration.zero, () {
          dropdownKey.currentState?.openDropDownSearch();
        });
      }

  }

  Future<Map<String, String>> fetchOwnerAndRestaurantName(String fssaiRegisterNumber) async {
    try {
      final response = await http.get(Uri.parse('https://api.fssai.gov.in/api/food-license/basic?licenseNumber=$fssaiRegisterNumber'));

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        String ownerName = responseData['result']['data'][0]['ownerName'];
        String restaurantName = responseData['result']['data'][0]['name'];

        return {
          'ownerName': ownerName,
          'restaurantName': restaurantName,
        };
      } else {
        throw Exception('Failed to load data from FSSAI API');
      }
    } catch (e) {
      // Handle timeouts or other errors
      throw Exception('Failed to load data from FSSAI API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Row(
          children: [
            Container(
              child: Text.rich(
                TextSpan(
                  text: '${widget.label} ',
                  style: TextStyle(
                    fontFamily: 'RenogareSoft',
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.w600,
                    color: GlobalVariables.textColor,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: widget.required ? '*' : '',
                      style: TextStyle(
                        color: widget.required ? Colors.red : Colors.transparent, // Set red color for '*'
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(width: 5,),
            Visibility(
              visible: widget.suffixTooltip != null,
              child: Tooltip(
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(5)
                ),
                textStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Open Sans',
                  fontSize: 8,
                  color: Colors.white,
                  wordSpacing: 0.23,
                  letterSpacing: 0.23,
                ),
                message: widget.suffixTooltip ?? '', // Provide a default value if widget.suffixTooltip is null
                child: Icon(Icons.info, color: Colors.blueGrey, size: 20,),
              ),
            ),

          ],
        ),



        SizedBox(height: 5,),
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: TextField(
            controller: widget.controller,
            readOnly: widget.readOnly,
            style: TextStyle(
              fontFamily: 'BertSans',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xff1d1517),
            ),
            onChanged: (text) {
              setState(() {
                _isNumberEntered = text.contains(new RegExp(r'[0-9]'));
                _isValidNumber = text.length == 10 && _isNumberEntered;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(text);
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintStyle: SafeGoogleFont(
                       'Poppins',
                          fontSize: 12,
                    fontWeight: FontWeight.w400,
                     color: GlobalVariables.textColor,
    ),
              prefixIcon: widget.prefixWidget,
              hintText: widget.hintText,
              suffixIcon: widget.isDropdown
                  ? Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: DropdownSearch<String>(
                  key: dropdownKey,
                  enabled: true,
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                    constraints: BoxConstraints(
                       maxHeight: 250
                ),
                    showSearchBox: widget.showSearchBox1,
                    fit: FlexFit.loose,
                    emptyBuilder: (context, searchEntry) =>
                        Container(
                          height: 250,
                          child: Center(
                              child:
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('${widget.itemName} not found',
                                    style:SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),),
                                  Container(
                                    margin: EdgeInsets.all(30),
                                    child: Text('Do you want to create this ${widget.itemName}',
                                      style:SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: GlobalVariables.textColor,
                                      ),),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color:GlobalVariables.whiteColor,
                                              border:Border.all(color: Colors.black54),
                                              borderRadius: BorderRadius.circular(10)),
                                          padding: EdgeInsets.all(7),
                                          child: Center(
                                            child: Text(
                                              'No',
                                              style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                         setState(() {
                                           dropAddItem = true;
                                           print(widget.dropdownItems!);
                                           selectedValue = searchEntry;
                                           widget.dropdownItems!.add(searchEntry);
                                           widget.dropdownItems!.last;
                                           widget.controller.text = searchEntry;
                                           print(widget.dropdownItems!);
                                         });
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: GlobalVariables.primaryColor,
                                              borderRadius: BorderRadius.circular(10)),
                                          padding: EdgeInsets.all(7),
                                          child: Center(
                                            child: Text(
                                              'Yes',
                                              style: SafeGoogleFont(
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: GlobalVariables.whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                  ),
                  items: widget.dropdownItems ?? [],
                  onChanged: (selectedItem) {
                    if (widget.onChanged != null){
                      widget.onChanged!(selectedItem);
                    }
                    setState(() {
                      selectedValue = selectedItem;
                      widget.controller.text = selectedItem ?? '';
                    });
                  },
                  selectedItem:
                       dropAddItem
                      ? widget.dropdownItems!.last
                      :  widget.dropdownItems != null && widget.dropdownItems!.isNotEmpty ? widget.dropdownItems!.first
                      : null,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                  itemAsString: (item) {
                    return item;
                  },
                  dropdownBuilder: _style,
                  compareFn: (item, selectedItem) => item == selectedItem,
                ),
              )
                  : widget.showCalendar
                  ? GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (selectedDate != null) {
                    widget.onDateSelected?.call(selectedDate);
                    setState(() {
                      _selectedDate = selectedDate;
                      widget.controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                    });
                  }
                },
                child: Icon(Icons.calendar_today, color: Colors.black),
              )
                  : (widget.onTap != null
                  ? IconButton(
                icon: Icon(Icons.access_time, size: 18),
                onPressed: widget.onTap,
                color: Colors.black,
              )

                  : null  ),
            ),
          ),
        ),
        Visibility(
          visible: widget.showVerifyOTP && _isNumberEntered,
          child: InkWell(
            onTap: () {

            },
            child: Text(
              'Verify OTP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Open Sans',
                fontSize: 18, // Adjust the font size as needed
                color: Color(0xfffbb830), // Change the color as needed
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.showVerifyFassi && _isNumberEntered,
          child: InkWell(
            onTap: ()
            async {
              try {
                Map<String, String> details = await fetchOwnerAndRestaurantName("21223052000251");
                print(details);
              } catch (e) {
                print('Error: $e');
              }
            },
            child: Text(
              'Validate Fssai',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Open Sans',
                fontSize: 18, // Adjust the font size as needed
                color: Color(0xfffbb830), // Change the color as needed
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: !_isValidNumber &&  widget.showGenerateOTP ,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0,left: 8.0),
                    child: Text(
                      'Enter Valid Phone Number *', // Warning message
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Open Sans',
                        fontSize: 14, // Adjust the font size as needed
                        color: Colors.red, // Change the color as needed
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _isNumberEntered && widget.showGenerateOTP && _isValidNumber ,
              child: InkWell(
                onTap: () {
                  showDialog(context: context, builder: (context) =>
                      AlertDialog(
                        title: Text("Enter your OTP",style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Open Sans',
                          fontSize: 18,
                          color: Colors.black,
                          wordSpacing: 0.23,
                          letterSpacing: 0.23,
                        ),),
                        content: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Text("Close")),
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Text("Verify"))
                        ],
                      )
                  );
                },
                child: Text(
                  'Generate\nOTP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Open Sans',
                    fontSize: 18, // Adjust the font size as needed
                    color: Color(0xfffbb830), // Change the color as needed
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }


  Widget _style(BuildContext context, String? selectedItem) {
    double baseWidth = 395;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.93;
    return Container(
      margin: EdgeInsets.only(left: 10, top: 0),
      child: Padding(
        padding: const EdgeInsets.only(left: 5,right: 10,bottom: 5), // Add the desired padding here
        child: Text(
          selectedItem!,
          style: TextStyle(
            fontFamily: 'BertSans',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xff1d1517),
          ),
        ),
      ),
    );
  }
}

