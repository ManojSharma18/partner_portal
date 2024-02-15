import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.mobileBuilder,
    required this.tabletBuilder,
    required this.desktopBuilder,
    Key? key,
  }) : super(key: key);

  final Widget Function(
      BuildContext context,
      BoxConstraints constraints,
      ) mobileBuilder;

  final Widget Function(
      BuildContext context,
      BoxConstraints constraints,
      ) tabletBuilder;

  final Widget Function(
      BuildContext context,
      BoxConstraints constraints,
      ) desktopBuilder;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1250 &&
          MediaQuery.of(context).size.width >= 650;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1250;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        print("Max Width: $maxWidth"); // Debugging statement

        if (maxWidth >= 1000 && screenWidth >=1250) {
          // Use desktop layout
          return desktopBuilder(context, constraints);
        } else if (maxWidth >= 650) {
          // Use tablet layout
          return tabletBuilder(context, constraints);
        } else {
          // Use mobile layout
          return mobileBuilder(context, constraints);
        }
      },
    );
  }

}