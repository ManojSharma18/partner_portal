import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/utils.dart';
import 'package:partner_admin_portal/repository/menu_services.dart';

import '../constants/menu_editor_constants/menu_editor_variables.dart';


class CustomTextFieldPrice extends StatefulWidget {
  final FocusNode focusNode = FocusNode();
  final String label;
  final bool required;
  final bool isCategory;
  final TextEditingController controller;
  final double height;
  final double width;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final bool showSearchBox1;
  final String itemName;
  final Function(String?)? onChanged;
  final Function(String?)? onChangedDropdown;
  final bool isChangedDropDown;
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
  final bool displayCount;
  final bool onlyDigits;
  String selectedValue;
  final bool digitsAndLetters;
  final bool itemNotFound;
  final bool searchItem;

  CustomTextFieldPrice({
    required this.label,
    this.required = false,
    required this.controller,
    this.height = 60,
    this.isCategory = false,
    this.width = 150,
    this.isDropdown = false,
    this.dropdownItems,
    this.showSearchBox1 = false,
    this.onChanged,
    this.onChangedDropdown,
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
    this.dropdownAuto = false,
    this.displayCount = false,this.onlyDigits = false,
    this.selectedValue = "",
    this.digitsAndLetters = false,
    this.itemNotFound = true,
    this.searchItem = false,
    this.isChangedDropDown = false
  });

  @override
  State<CustomTextFieldPrice> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextFieldPrice> {
  GlobalKey<DropdownSearchState<String>> dropdownKey = GlobalKey();
  bool _isNumberEntered = false;
  String? selectedValue;
  bool _isValidNumber = true;
  DateTime? _selectedDate;

  bool dropAddItem = false;


  MenuService _menuService = MenuService();



  TextEditingController searchController = TextEditingController();

  late bool isReadOnly;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_convertToUpperCase);
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

    if (widget.controller.text.isNotEmpty) {
      selectedValue = widget.controller.text;
    }

    print(selectedValue);

    isReadOnly = widget.readOnly;

  }

  void _convertToUpperCase() {
    final text = widget.controller.text;
    if (text != text.toUpperCase()) {
      widget.controller.value = widget.controller.value.copyWith(
        text: text.toUpperCase(),
        selection: TextSelection(
          baseOffset: text.length,
          extentOffset: text.length,
        ),
      );
    }
  }


  TextInputFormatter getInputFormatter() {
    if (widget.onlyDigits) {
      return NumberInputFormatter();
    } else if (widget.digitsAndLetters) {
      return CustomInputFormatter();
    } else {
      return UpperCaseTextFormatter();
    }
  }

  void toggleReadOnly() {
    setState(() {
      isReadOnly = !isReadOnly;
    });
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
                        fontSize: 15,
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
            child: Container(
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                onTap: () {
                  widget.onTap?.call();
                },
                inputFormatters: [
                  getInputFormatter(),
                  LengthLimitingTextInputFormatter(50),
                ],
                readOnly: isReadOnly,

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
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: GlobalVariables.whiteColor)
                  ),
                  hintStyle: SafeGoogleFont(
                    'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: GlobalVariables.textColor,
                  ),
                  prefixIcon:
                      Container(
                        margin: EdgeInsets.only(left: 10,top: 10),
                        child: Text("\u{20B9}",
                          style: TextStyle(
                          fontFamily: 'RenogareSoft',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: GlobalVariables.textColor,
                        ),),
                      ),
                  hintText: widget.hintText,
                  suffixIcon: (
                      widget.onTap != null
                      ? IconButton(
                    icon: Icon(Icons.edit, size: 18),
                    onPressed: widget.onTap,
                    color: Colors.black,
                  )
                      : null  ),
                ),
              ),
            )
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
        Visibility(
          visible: widget.displayCount,
          child: Container(
            width: widget.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1.0,),
                      child: Text(
                        '${widget.controller.text.length}/50', // Warning message
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Open Sans',
                          fontSize: 12, // Adjust the font size as needed
                          color: GlobalVariables.textColor.withOpacity(0.7), // Change the color as needed
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
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
          ),
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


class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
    );
  }
}

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newText = newValue.text;

    if(newValue.text.startsWith(' ')){
      return oldValue;
    }

    if (newText.isEmpty) {
      return newValue;
    }

    // Allow only digits and one decimal point
    final regExp = RegExp(r'^\d*\.?\d*$');
    if (regExp.hasMatch(newText)) {
      return newValue;
    }

    // If not matching, return the old value
    return oldValue;
  }
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newText = newValue.text;

    if(newValue.text.startsWith(' ')){
      return oldValue;
    }

    if (newText.isEmpty) {
      return newValue;
    }


    // Allow digits, letters, comma, and hyphen
    final RegExp  regExp = RegExp(r'^[a-zA-Z0-9\-\,\&\~\!\@\#\*\(\)\./ ]*$');
    if (regExp.hasMatch(newText)) {
      return newValue;
    }

    // If not matching, return the old value
    return oldValue;
  }
}

