import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';

class SearchBars extends StatefulWidget {
  final String hintText;
  final double width;
  final double height;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function()? onPressed;
  const SearchBars({Key? key, required this.hintText,this.onChanged,  this.controller, required this.width, this.height = 40, this.onPressed}) : super(key: key);

  @override
  State<SearchBars> createState() => _SearchBarsState();
}

class _SearchBarsState extends State<SearchBars> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
          width: widget.width,
          height: widget.height,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: TextFormField(
              controller:widget.controller,
              inputFormatters: [CustomInputFormatter(), FilteringTextInputFormatter.deny(RegExp(r'[\t ]'))],
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: widget.hintText,
                fillColor:GlobalVariables.whiteColor ,
                focusColor: GlobalVariables.whiteColor,
                suffixIcon: GestureDetector(
                    onTap:widget.onPressed,
                    child: Icon(Icons.filter_list,color: GlobalVariables.textColor,)),
                prefixIcon: Icon(Icons.search, color: Color(0xfffbb830)) ,
                border: InputBorder.none, // Hide the border
              ),
            ),
          )

      ),
    );
  }
}


class CustomInputFormatter extends TextInputFormatter {
  // Updated regular expression to allow the specified characters
  final RegExp _allowedCharacters = RegExp(r'^[a-zA-Z0-9\-\&\~\!\,\@\#\*\(\)\./ ]*$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Ensure input does not start with a space or tab
    if (newValue.text.startsWith(' ') || newValue.text.startsWith('\t')) {
      return oldValue;
    }
    // Check if all characters are allowed
    if (_allowedCharacters.hasMatch(newValue.text)) {
      return newValue;
    }
    // If not, return old value
    return oldValue;
  }
}
