import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/menu_editor_constants/menu_editor_variables.dart';

import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';

class SubscriptionAvailability extends StatelessWidget {
  const SubscriptionAvailability({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 30, right: 30,),
        child: DataTable(
          columnSpacing: 50,
          headingRowHeight: 100,
          border: TableBorder.all(color: Colors.black12,
              width: 0.3,
              style: BorderStyle.solid,
              borderRadius: BorderRadius.circular(10)),
          columns: <DataColumn>[
            DataColumn(
              label: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Days', style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: GlobalVariables.textColor,
                  ),),
                  SizedBox(height: 5,),
                  Checkbox(
                    value: false,
                    activeColor: GlobalVariables.textColor,
                    checkColor: GlobalVariables.primaryColor,
                    onChanged: (bool? value) {

                    },
                    materialTapTargetSize: MaterialTapTargetSize
                        .shrinkWrap,
                    // to remove extra padding
                    visualDensity: VisualDensity.compact,
                    // to reduce spacing
                    tristate: false,
                    fillColor: MaterialStateProperty
                        .resolveWith<Color?>((
                        Set<MaterialState> states) {
                      // Set the color to white when the checkbox is not selected
                      if (states.contains(
                          MaterialState.selected)) {
                        return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                      }
                      return Colors
                          .white; // Use white color when the checkbox is not selected
                    }),
                  ),
                ],
              ),
            ),
            DataColumn(
              label: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Breakfast', style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: GlobalVariables.textColor,
                  ),),
                  SizedBox(height: 5,),
                  Checkbox(
                    activeColor: GlobalVariables.textColor,
                    checkColor: GlobalVariables.primaryColor,
                    value: false,
                    onChanged: (bool? value) {

                    },
                    materialTapTargetSize: MaterialTapTargetSize
                        .shrinkWrap,
                    // to remove extra padding
                    visualDensity: VisualDensity.compact,
                    // to reduce spacing
                    tristate: false,
                    fillColor: MaterialStateProperty
                        .resolveWith<Color?>((
                        Set<MaterialState> states) {
                      // Set the color to white when the checkbox is not selected
                      if (states.contains(
                          MaterialState.selected)) {
                        return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                      }
                      return Colors
                          .white; // Use white color when the checkbox is not selected
                    }),
                  )

                ],
              ),
            ),
            DataColumn(
              label: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lunch', style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: GlobalVariables.textColor,
                  ),),
                  SizedBox(height: 5,),
                  Checkbox(
                    value: false,
                    activeColor: GlobalVariables.textColor,
                    checkColor: GlobalVariables.primaryColor,
                    onChanged: (bool? value) {

                    },
                    materialTapTargetSize: MaterialTapTargetSize
                        .shrinkWrap,
                    // to remove extra padding
                    visualDensity: VisualDensity.compact,
                    // to reduce spacing
                    tristate: false,
                    fillColor: MaterialStateProperty
                        .resolveWith<Color?>((
                        Set<MaterialState> states) {
                      // Set the color to white when the checkbox is not selected
                      if (states.contains(
                          MaterialState.selected)) {
                        return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                      }
                      return Colors.white; // Use white color when the checkbox is not selected
                    }),
                  ),
                ],
              ),
            ),
            DataColumn(
              label: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Dinner', style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: GlobalVariables.textColor,
                  ),),
                  SizedBox(height: 5,),
                  Checkbox(
                    value: false,
                    activeColor: GlobalVariables.textColor,
                    checkColor:GlobalVariables.primaryColor,
                    onChanged: (bool? value) {

                    },
                    materialTapTargetSize: MaterialTapTargetSize
                        .shrinkWrap,
                    // to remove extra padding
                    visualDensity: VisualDensity.compact,
                    // to reduce spacing
                    tristate: false,
                    fillColor: MaterialStateProperty
                        .resolveWith<Color?>((
                        Set<MaterialState> states) {
                      // Set the color to white when the checkbox is not selected
                      if (states.contains(
                          MaterialState.selected)) {
                        return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                      }
                      return Colors
                          .white; // Use white color when the checkbox is not selected
                    }),
                  ),
                ],
              ),
            ),

          ],
          rows: MenuEditorVariables.mealData.keys.map((String day) {
            var meals =MenuEditorVariables.mealData[day] ??
                const {}; // Handling nullable map
            return DataRow(cells: <DataCell>[
              DataCell(
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Text(day, style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.textColor,
                    ),),
                    Checkbox(
                      value: false,
                      activeColor: GlobalVariables.textColor,
                      checkColor: GlobalVariables.primaryColor,
                      onChanged: (bool? value) {

                      },
                      materialTapTargetSize: MaterialTapTargetSize
                          .shrinkWrap,
                      // to remove extra padding
                      visualDensity: VisualDensity.compact,
                      // to reduce spacing
                      tristate: false,
                      fillColor: MaterialStateProperty
                          .resolveWith<Color?>((
                          Set<MaterialState> states) {
                        // Set the color to white when the checkbox is not selected
                        if (states.contains(
                            MaterialState.selected)) {
                          return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                        }
                        return Colors
                            .white; // Use white color when the checkbox is not selected
                      }),
                    )


                  ],
                ),
              ),
              DataCell(
                  Center(
                    child: Checkbox(
                      value: meals['Breakfast'] ?? false,
                      activeColor: GlobalVariables.textColor,
                      checkColor: GlobalVariables.primaryColor,
                      onChanged: (bool? value) {

                      },
                      materialTapTargetSize: MaterialTapTargetSize
                          .shrinkWrap,
                      // to remove extra padding
                      visualDensity: VisualDensity.compact,
                      // to reduce spacing
                      tristate: false,
                      fillColor: MaterialStateProperty
                          .resolveWith<Color?>((
                          Set<MaterialState> states) {
                        // Set the color to white when the checkbox is not selected
                        if (states.contains(
                            MaterialState.selected)) {
                          return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                        }
                        return Colors
                            .white; // Use white color when the checkbox is not selected
                      }),
                    ),
                  )

              ),
              DataCell(
                  Center(
                    child: Checkbox(
                      value: meals['Lunch'] ?? false,
                      activeColor: GlobalVariables.textColor,
                      checkColor: GlobalVariables.primaryColor,
                      onChanged: (bool? value) {

                      },
                      materialTapTargetSize: MaterialTapTargetSize
                          .shrinkWrap,
                      // to remove extra padding
                      visualDensity: VisualDensity.compact,
                      // to reduce spacing
                      tristate: false,
                      fillColor: MaterialStateProperty
                          .resolveWith<Color?>((
                          Set<MaterialState> states) {
                        // Set the color to white when the checkbox is not selected
                        if (states.contains(
                            MaterialState.selected)) {
                          return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                        }
                        return Colors
                            .white; // Use white color when the checkbox is not selected
                      }),
                    ),
                  )

              ),
              DataCell(
                  Center(
                    child: Checkbox(
                      value: meals['Dinner'] ?? false,
                      activeColor:GlobalVariables.textColor,
                      checkColor: GlobalVariables.primaryColor,
                      onChanged: (bool? value) {

                      },
                      materialTapTargetSize: MaterialTapTargetSize
                          .shrinkWrap,
                      // to remove extra padding
                      visualDensity: VisualDensity.compact,
                      // to reduce spacing
                      tristate: false,
                      fillColor: MaterialStateProperty
                          .resolveWith<Color?>((
                          Set<MaterialState> states) {
                        // Set the color to white when the checkbox is not selected
                        if (states.contains(
                            MaterialState.selected)) {
                          return GlobalVariables.textColor; // Use the activeColor when the checkbox is selected
                        }
                        return Colors
                            .white; // Use white color when the checkbox is not selected
                      }),
                    ),
                  )

              ),
            ]);
          }).toList(),
        ),
      )
    );
  }
}
