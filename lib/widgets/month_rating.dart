import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';

import '../constants/utils.dart';

class MonthRating extends StatefulWidget {
  const MonthRating({Key? key}) : super(key: key);

  @override
  State<MonthRating> createState() => _MonthRatingState();
}

class _MonthRatingState extends State<MonthRating> {
  final List<double> positiveReviews = [10, 20, 15, 25, 30, 40, 35, 45, 50, 60, 55, 70];
  final List<double> negativeReviews = [5, 10, 8, 12, 15, 18, 20, 25, 30, 28, 35, 40];

  String selectedType = "This year";

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.only(left: 10,top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ratingFilter("This year"),
                SizedBox(width: 10,),
                ratingFilter("This Month"),
                SizedBox(width: 10,),
                ratingFilter("This week"),
                SizedBox(width: 10,),
                ratingFilter("Last Month"),
                SizedBox(width: 10,),
                ratingFilter("Last week"),

              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: GlobalVariables.whiteColor,
              borderRadius: BorderRadius.circular(15),

            ),
            child: Row(
              children: [
                Container(
                  width: 170*fem,
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return Text('Jan',style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF363563),
                                    ),);
                                  case 1:
                                    return Text('Feb',style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF363563),
                                    ));
                                  case 2:
                                    return Text('Mar',style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF363563),
                                    ));
                                  case 3:
                                    return Text('Apr',style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF363563),
                                    ));
                                  case 4:
                                    return Text('May',style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF363563),
                                    ));
                                  case 5:
                                    return Text('Jun',style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF363563),
                                    ));
                                  case 6:
                                    return Text('Jul',style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF363563),
                                    ));
                                  case 7:
                                    return Text('Aug',style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF363563),
                                    ));
                                  case 8:
                                    return Text('Sep',style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF363563),
                                    ));
                                  case 9:
                                    return Text('Oct',style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF363563),
                                    ));
                                  case 10:
                                    return Text('Nov',style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF363563),
                                    ));
                                  case 11:
                                    return Text('Dec',style: SafeGoogleFont(
                                      'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF363563),
                                    ));
                                  default:
                                    return Text('');
                                }
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 10,
                              reservedSize: 30,

                            ),
                            drawBelowEverything: true
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false,interval: 1)
                          ),
                            topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)
                        )
                        ),
                        borderData: FlBorderData(show: true,border: Border(
                          left: BorderSide(color: Colors.black, width: 1),
                          bottom: BorderSide(color: Colors.black, width: 1),
                        ),),

                        minX: 0,
                        maxX: 11,
                        minY: 0,
                        maxY: 80,
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              12,
                                  (index) => FlSpot(index.toDouble(), positiveReviews[index]),
                            ),
                            isCurved: true,
                            color: Colors.green,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                          LineChartBarData(
                            spots: List.generate(
                              12,
                                  (index) => FlSpot(index.toDouble(), negativeReviews[index]),
                            ),
                            isCurved: true,
                            color: Colors.red,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  )
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          color: Colors.green,
                        ),
                        SizedBox(width: 10,),
                        Text("Positive",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF363563),
                        ),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10,),
                        Text("Negative",style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF363563),
                        ),)
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget ratingFilter(String label){
    return InkWell(
      onTap: (){
        setState(() {
          selectedType = label;
        });
      },
      child: Container(
        width: 100,
        height: 35,
        decoration: BoxDecoration(
          color: selectedType == label ? GlobalVariables.textColor : GlobalVariables.whiteColor,
              border: Border.all(color: GlobalVariables.textColor),
              borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: Text(label,style: SafeGoogleFont('Poppins',fontSize: 12,color: GlobalVariables.primaryColor,fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
