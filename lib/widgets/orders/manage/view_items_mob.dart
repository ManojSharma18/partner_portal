import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import '../../../bloc/manage_orders/order_event.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';

class ViewItemsMobile extends StatelessWidget {
  final int index;
  final List<Map<String,dynamic>>  list;
  final int serialNumber;
  const ViewItemsMobile({Key? key, required this.index, required this.list, required this.serialNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(list);
    print(index);
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return BlocBuilder<OrderBloc,OrderState>(
      builder: (BuildContext context, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalVariables.primaryColor.withOpacity(0.2),
          title: Text("Items | ${list[index]['Items'].length}",
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF363563),
            ),),
          actions: [
            Text("QTY",
              style: SafeGoogleFont(
                'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF363563),
              ),),
            SizedBox(width: 20*fem,),
            Text("Amount",
              style: SafeGoogleFont(
                'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF363563),
              ),),
            SizedBox(width: 10*fem,),
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 500,
              width: 400,
              child: ListView.builder(
                itemCount: list[index]['Items'].length,
                itemBuilder: (_, itemIndex) {
                  return Container(
                    padding: EdgeInsets.only(top:10,bottom:10,left: 20*fem,right: 5*fem),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width:245*fem,
                          child: Text(
                            '${itemIndex+1}. ${list[index]['Items'][itemIndex]['itemName']} ',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF363563),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              child: Text(
                                "${list[index]['Items'][itemIndex]['count']} ",
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  color: Color(0xFF363563),
                                ),
                              ),
                            ),
                            SizedBox(width: 10*fem,),

                            Container(
                              width: 60,
                              child: Text(
                                '\u20B9 ${list[index]['Items'][itemIndex]['price']}',
                                style: TextStyle(
                                    fontSize: 13
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: serialNumber ==0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap:(){
                      context.read<OrderBloc>().add(OrderRejectEvent(state.orderList, index,state.closedList,''));
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                        child: Center(
                          child: Text(
                            "Reject",
                            style:SafeGoogleFont(
                              'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: GlobalVariables.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10*fem,),
                  InkWell(
                    onTap:(){
                      context.read<OrderBloc>().add(OrderAcceptEvent(state.orderList, state.inProgressList, index,state.orderList[index]['Id']));
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                        child: Center(
                          child: Text(
                            "Accept",
                            style:SafeGoogleFont(
                              'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: GlobalVariables.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10*fem,),
                ],
              ),
            ),
            Visibility(
              visible: serialNumber !=0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap:(){
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: GlobalVariables.primaryColor
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                        child: Center(
                          child: Text(
                            "Ok",
                            style:SafeGoogleFont(
                              'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: GlobalVariables.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10*fem,),
                ],
              ),
            ),
          ],
        ),
      );
    },

    );
  }
}
