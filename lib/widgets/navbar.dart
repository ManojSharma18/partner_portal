
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';

import '../constants/utils.dart';

class NavBarItem extends StatefulWidget {
  final String icon;
  final String text;
  final Function? touched;
  final bool active;
  final Function(bool)? hover;
  const NavBarItem({Key? key, required this.icon, required this.text, required this.touched, required this.active, this.hover}) : super(key: key);

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          widget.touched!();
        },
        // splashColor: Colors.white,
        hoverColor: Colors.white12,
        onHover: widget.hover,
        child: Container(

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100.0,
                height: 80.0,
                color: widget.active ? GlobalVariables.primaryColor : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // AnimatedContainer(duration: Duration(milliseconds: 475),
                    //   height: 50,
                    //   width: 5.0,
                    //   decoration: BoxDecoration(
                    //     color: widget.active ? GlobalVariables.whiteColor : Colors.transparent,
                    //     borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
                    //
                    //   ),
                    // ),
                    // SizedBox(width: 15,),
                    Container(
                      width: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Image.asset(widget.icon,
                          width: 25,
                          height: 25,
                          color: widget.active ? GlobalVariables.textColor : Color(0xfffbb830),),
                          SizedBox(height: 5,),
                          Text(widget.text,style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.active ? GlobalVariables.textColor : GlobalVariables.textColor,
                          ),)
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showPopupMenu1(BuildContext context) {
    {
      showMenu(
        context: context,
        color: GlobalVariables.whiteColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        position: RelativeRect.fromLTRB(100, 215, 100, 0), // Adjust the position as needed
        items: [
          PopupMenuItem(
            child: ListTile(
              title: Text('Live menu'),
              onTap: () {
                setState(() {
                  // select(1);
                  // _selectedIndex = 1;
                  // menuIndex = 1;
                });

                Navigator.pop(context); // Close the popup menu

              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              title: Text('Menu editor'),
              onTap: () {
                setState(() {
                  // menuIndex = 2;
                  // select(1);
                  // _selectedIndex = 1;

                });

                Navigator.pop(context); // Close the popup menu

              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              title: Text('Menu history'),
              onTap: () {
                setState(() {
                  // menuIndex = 3;
                  // select(1);
                  // _selectedIndex = 1;

                });

                Navigator.pop(context); // Close the popup menu

              },
            ),
          ),
        ],
      );
    }
  }
}
