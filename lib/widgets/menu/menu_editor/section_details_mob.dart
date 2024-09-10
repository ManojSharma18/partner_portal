import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';
import '../../../constants/menu_editor_constants/menu_editor_variables.dart';
import '../../../constants/utils.dart';
import '../../custom_textfield.dart';

class SectionDetailsMob extends StatefulWidget {

  const SectionDetailsMob({super.key, });

  @override
  State<SectionDetailsMob> createState() => _SectionDetailsMobState();
}

class _SectionDetailsMobState extends State<SectionDetailsMob> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        title: Text("Section details",style: SafeGoogleFont(
          'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF363563),
        ),),
        actions: [
        Transform.scale(
        scaleY: 0.8,
        scaleX: 0.8,
        child: Switch(
          value: true,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor:
          GlobalVariables.textColor.withOpacity(0.6),
          inactiveThumbImage: NetworkImage(
              "https://wallpapercave.com/wp/wp7632851.jpg"),
          onChanged: (bool value) {
            // mContext.read<MenuBloc>().add(UpdateSectionAvailability(context, MenuEditorVariables.tagController.text, value));
          },
        ),
      )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Container(
              margin: EdgeInsets.only(left: 10*fem),
              child: CustomTextField(label: "Tag", controller: MenuEditorVariables.tagController,width: 350*fem,height: 60, fontSize: 11, displayCount: true,
                onChanged: (val) {

                },)),
        ],
      ),
    );
  }
}
