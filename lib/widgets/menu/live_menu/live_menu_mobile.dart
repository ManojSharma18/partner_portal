import 'package:flutter/material.dart';
import 'package:partner_admin_portal/bloc/live_menu/live_menu_state.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_bloc.dart';
import 'package:partner_admin_portal/bloc/manage_orders/order_state.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_functions.dart';
import 'package:partner_admin_portal/constants/live_menu_constants/live_menu_variables.dart';
import 'package:partner_admin_portal/constants/search_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/live_menu/live_menu_bloc.dart';
import '../../../bloc/live_menu/live_menu_event.dart';
import '../../../constants/global_function.dart';
import 'live_menu.dart';

class LiveMenuMobile extends StatelessWidget {
  final Set<String> selectedCategories;
  const LiveMenuMobile({Key? key, required this.selectedCategories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return BlocBuilder<LiveMenuBloc,LiveMenuState>(builder: (BuildContext context, state) {
       return  BlocBuilder<OrderBloc,OrderState>(builder: (BuildContext context, orderState)
       {
         return Column(
           children: [
             SearchBars(hintText: "Search", width: 350*fem,height: 45,onChanged: (subQuery){
               if (subQuery != "") {
                 LiveMenuVariables.filteredFoodCategory = {};

                 LiveMenuVariables.filteredFoodCategory.forEach((cuisine, items) {
                   List<Map<String, dynamic>> matchingItems = items
                       .where((item) => item['name'].toLowerCase().contains(subQuery.toLowerCase()))
                       .toList();

                   if (matchingItems.isNotEmpty) {
                     state.selectedCategories.add(cuisine);
                     LiveMenuVariables.filteredFoodCategory[cuisine] = matchingItems;
                   }
                 });
               }
               else{
                 LiveMenuVariables.filteredFoodCategory = {};
                 //selectedCategories = {};
                 state.selectedCategories.add('South indian breakfast');
               }
             },),
             Expanded(
               child: ReorderableListView.builder(
                 buildDefaultDragHandles:false,
                 primary: true,
                 shrinkWrap: true,
                 itemCount: LiveMenuVariables.filteredFoodCategory.length == 0 ? LiveMenuVariables.foodCategories.length : LiveMenuVariables.filteredFoodCategory.length,
                 itemBuilder: (context, index) {
                   String category = LiveMenuVariables.filteredFoodCategory.length == 0
                       ? LiveMenuVariables.foodCategories.keys.elementAt(index)
                       : LiveMenuVariables.filteredFoodCategory.keys.elementAt(index);
                   List<Map<String, dynamic>> itemsList = LiveMenuVariables.filteredFoodCategory.length == 0
                       ? state.foodCategories[category]!
                       : LiveMenuVariables.filteredFoodCategory[category]!;
                   List<String> items = itemsList.map((item) => item['name'] as String).toList();

                   bool categoryContainsMatch = items.any((item) =>
                       item.toLowerCase().contains(" ".toLowerCase()));

                   return ReorderableDragStartListener(
                     enabled: true,
                     key: Key(category),
                     index: index,
                     child: InkWell(
                       onTap: () {

                         context.read<LiveMenuBloc>().add(SelectCategoryEvent(state.selectedCategories, category));

                       },
                       child: Column(
                         key: Key('$category'),
                         children: [
                           Container(
                             margin: EdgeInsets.only(top: 5, bottom: 5),
                             color: state.selectedCategories.contains(category)
                                 ? Color(0xFF363563)
                                 : null,
                             child: ListTile(
                               title: Text(
                                 category,
                                 style: TextStyle(
                                   fontSize: 12,
                                   fontWeight: FontWeight.bold,
                                   color: state.selectedCategories.contains(category)
                                       ? Colors.white
                                       : Colors.black,
                                 ),
                               ),
                               leading: Icon(
                                 Icons.grid_view_rounded,
                                 size: 10,
                                 color: state.selectedCategories.contains(category)
                                     ? Colors.white
                                     : Colors.black,
                               ),
                               trailing: Row(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   InkWell(
                                     onTap: () {
                                      LiveMenuFunctions.showAddItemDialogMob(context,category);
                                     },
                                     child: Center(
                                       child: Icon(
                                         Icons.add,
                                         size: 18,
                                         color: GlobalVariables.primaryColor,
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                           Visibility(
                             visible: state.selectedCategories.contains(category),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: LiveMenuFunctions.buildItemsList1(context,category, itemsList,state.selectedCategories),
                             ),
                           ),
                         ],
                       ),
                     ),
                   );
                 },
                 onReorder: (oldIndex, newIndex) {

                   if (oldIndex < newIndex) {
                     newIndex -= 1;
                   }
                   List<MapEntry<String, List<Map<String, dynamic>>>> entries =
                   LiveMenuVariables.filteredFoodCategory.length == 0
                       ? LiveMenuVariables.foodCategories.entries.toList()
                       : LiveMenuVariables.filteredFoodCategory.entries.toList();
                   MapEntry<String, List<Map<String, dynamic>>> removedEntry =
                   entries.removeAt(oldIndex);
                   entries.insert(newIndex, removedEntry);

                   // Convert the List back to a Map
                   if (LiveMenuVariables.filteredFoodCategory.length == 0) {
                     LiveMenuVariables.foodCategories = Map.fromEntries(entries);
                   } else {
                     LiveMenuVariables.filteredFoodCategory = Map.fromEntries(entries);
                   }

                 },
               ),
             ),
           ],
         );
       },
       );
    },
    );
  }
}
