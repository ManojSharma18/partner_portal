import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/global_variables.dart';

class SmallCustomTextField extends StatefulWidget {
  final String label;
  final double height;
  final double width;
  final double fontSize;
  final int min;
  final int max;
  final Function(String?)? onChanged;
  final Function()? onClicked;
  final TextEditingController textEditingController;

  SmallCustomTextField( {
    this.label = '',
    this.height = 40,
    this.width = 50,
    this.onChanged,
    this.onClicked,
    required this.textEditingController,
    this.fontSize = 10, required this.min, required this.max
  } );

  @override
  State<SmallCustomTextField> createState() => _SmallCustomTextFieldState();
}

class _SmallCustomTextFieldState extends State<SmallCustomTextField> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if (widget.onClicked != null) {
          widget.onClicked;
        }
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        child: TextFormField(
          controller: widget.textEditingController,
          cursorHeight: 20,
          textAlign: TextAlign.justify,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            // RangeTextInputFormatter(min: 10, max:9999),
          ],
          onChanged: (text) {
            setState(() {
              if (widget.onChanged != null) {
                widget.onChanged!(text);
              }
            });
                },
          // onTap: (){
          //   if (widget.onClicked != null) {
          //     widget.onClicked;
          //   }
          // },

          decoration:InputDecoration(
                fillColor: GlobalVariables.whiteColor,
                border: OutlineInputBorder(
                ),
                disabledBorder: InputBorder.none,
                filled: true
              ),
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w700
          ),
          textAlignVertical: TextAlignVertical.top,
      )
      ),
    );
  }
}

class RangeTextInputFormatter extends TextInputFormatter {
  final int? min;
  final int? max;

  RangeTextInputFormatter({this.min, this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    try {
      final value = int.parse(newValue.text);
      if (min != null && value < min!) {
        return TextEditingValue(
          text: min.toString(),
          selection: TextSelection.collapsed(offset: min.toString().length),
        );
      }
      if (max != null && value > max!) {
        return TextEditingValue(
          text: max.toString(),
          selection: TextSelection.collapsed(offset: max.toString().length),
        );
      }
      return newValue;
    } catch (e) {
      return oldValue;
    }
  }
}
