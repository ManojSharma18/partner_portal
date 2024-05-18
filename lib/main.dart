import 'package:flutter/material.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/menu/menu_bloc.dart';
import 'package:partner_admin_portal/bloc/menu_editor/menu_editor_bloc.dart';
import 'package:partner_admin_portal/bloc/order_forecast/forecast_bloc.dart';
import 'package:partner_admin_portal/bloc/orders/orders_bloc.dart';
import 'package:partner_admin_portal/bloc/subscription_order/subscription_order_bloc.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/provider/day_provider.dart';
import 'package:partner_admin_portal/repository/menu_services.dart';
import 'package:partner_admin_portal/repository/order_service.dart';
import 'package:partner_admin_portal/screens/dashboard_screen.dart';
import 'package:partner_admin_portal/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DayProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(

      providers: [
        BlocProvider(create: (context) => OrderBloc(),),
        BlocProvider(create: (context)=> ForecastBloc()),
        BlocProvider(create: (context)=> LiveMenuBloc()),
        BlocProvider(create: (context)=> MenuBloc(MenuService())),
        BlocProvider(create: (context)=> MenuEditorBloc()),
        BlocProvider(create: (context)=> SubscriptionOrdersBloc(OrderService())),
        BlocProvider(create: (context)=> OrdersBloc(OrderService())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: GlobalVariables.textColor),
          useMaterial3: true,
        ),
        home: LoginScreen(),
      ),
    );
  }
}

