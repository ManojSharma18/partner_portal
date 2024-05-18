import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';

import '../constants/utils.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final Color color;
  const CustomButton({Key? key, required this.text, required this.onTap, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(text,style: SafeGoogleFont(
        'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: GlobalVariables.primaryColor,
      ),),
      style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(color),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      EdgeInsets.all(13.0), // Change the padding
    ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Change the border radius
          ),
        ),
    ),);
  }
}
