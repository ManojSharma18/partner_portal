import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBars extends StatelessWidget {
  final String hintText;
  final double width;
  final double height;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  const SearchBars({Key? key, required this.hintText,this.onChanged,  this.controller, required this.width, this.height = 65}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),

        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.search, color: Color(0xfffbb830)), // Search icon
                SizedBox(width: 10), // Add spacing between icon and text field
                Expanded(
                  child: TextField(
                    controller:controller,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none, // Hide the border
                    ),
                  ),
                ),
              ],
            ),
          ),
        )

    );
  }
}
