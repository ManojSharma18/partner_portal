import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';

class SearchBars extends StatelessWidget {
  final String hintText;
  final double width;
  final double height;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  const SearchBars({Key? key, required this.hintText,this.onChanged,  this.controller, required this.width, this.height = 40}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
          width: width,
          height: height,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: TextFormField(
              controller:controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                fillColor:GlobalVariables.whiteColor ,
                focusColor: GlobalVariables.whiteColor,
                suffixIcon: Icon(Icons.filter_list,color: GlobalVariables.textColor,),
                prefixIcon: Icon(Icons.search, color: Color(0xfffbb830)) ,
                border: InputBorder.none, // Hide the border
              ),
            ),
          )

      ),
    );
  }
}
