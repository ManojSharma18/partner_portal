import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MealRating extends StatefulWidget {
  const MealRating({Key? key}) : super(key: key);

  @override
  State<MealRating> createState() => _MealRatingState();
}

class _MealRatingState extends State<MealRating> {
  final List<DataItem> dataSet = [
    DataItem(25,"Breakfast",Colors.deepOrange),
    DataItem(25, "Lunch", Colors.lightBlueAccent),
    DataItem(50, "Dinner", Colors.red)
  ];
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DataItem {
  final double value;
  final String label;
  final Color color;
  DataItem(this.value,this.label,this.color);
}





