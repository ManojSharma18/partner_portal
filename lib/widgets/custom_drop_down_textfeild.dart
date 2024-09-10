import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../constants/global_variables.dart';
import '../constants/utils.dart';

class MultiSelectDropdowns extends StatefulWidget {
  final List<String> dropdownItems;
  final Function(List<String>) onChanged;
  final List<String> selectedValues;
  final String label;
  final bool required;
  final double height;
  final double width;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final String? hintText;
  final bool selectAll;
  final TextEditingController controller;

  MultiSelectDropdowns({
    required this.dropdownItems,
    required this.onChanged,
    this.selectedValues = const [],
    this.selectAll = false,
    required this.label,
    required this.controller,
    required this.required,
    required this.height,
    required this.width,
    this.prefixWidget,
    this.suffixWidget,
    this.hintText,
  });

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdowns> {
  List<String> selectedItems = [];
  bool selectAll = false; // Track select all state

  @override
  void initState() {
    super.initState();
    selectedItems = widget.selectedValues;
    selectAll = widget.selectAll;
  }

  @override
  Widget build(BuildContext context) {
    selectedItems = widget.selectedValues;
    return Column(
      children: [
        Row(
          children: [
            Container(
              child: Text.rich(
                TextSpan(
                  text: '${widget.label} ',
                  style: TextStyle(
                    fontFamily: 'RenogareSoft',
                    fontSize: 12,
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
            SizedBox(width: 5),
          ],
        ),
        SizedBox(height: 5),
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: DropdownSearch<String>.multiSelection(
            popupProps: PopupPropsMultiSelection.menu(
              showSearchBox: true,
              showSelectedItems: true,
              constraints: BoxConstraints(
                maxHeight: 280,
              ),
              searchFieldProps: TextFieldProps(
                autocorrect: true,
              ),
              scrollbarProps: ScrollbarProps(
                thickness: 5.0,
                radius: Radius.circular(6.0),
                thumbColor: Colors.grey,
              ),
            ),
            items: ["Select All", ...widget.dropdownItems], // Add "Select All" option
            selectedItems: selectedItems,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                hintText: widget.hintText ?? 'Select mode',
              ),
            ),
            onChanged: (List<String> selectedList) {
              setState(() {
                if (selectedList.contains("Select All")) {
                  selectedList.remove("Select All");
                  if (selectAll) {
                    selectedItems.clear();
                  } else {
                    selectedItems = List.from(widget.dropdownItems);
                  }
                  selectAll = !selectAll;
                } else {
                  selectedItems = selectedList;
                  selectAll = selectedItems.length == widget.dropdownItems.length;
                }
                widget.onChanged(selectedItems);
              });
            },
          ),
        ),
      ],
    );
  }
}
