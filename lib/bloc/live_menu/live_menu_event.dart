import 'package:equatable/equatable.dart';

import '../../widgets/menu/live_menu/live_menu.dart';

abstract class LiveMenuEvent extends Equatable {
  const LiveMenuEvent();

  @override
  List<Object?> get props => [];
}

class SelectCategoryEvent extends LiveMenuEvent {
  final Set<String> selectedCategories;
  final String categoryName;
  const SelectCategoryEvent(this.selectedCategories,this.categoryName);
}

class AddItemEvent extends LiveMenuEvent{
  final String categoryName;
  final Map<String, List<Map<String,dynamic>>> foodCategory;
  final String itemName;
  final bool availability;
  const AddItemEvent(this.categoryName,this.availability,this.itemName, this.foodCategory);
}

class SelectItemEvent extends LiveMenuEvent{
  final String item;
  final Map<String, List<Map<String,dynamic>>> foodCategory;
  const SelectItemEvent(this.item,this.foodCategory);
}

class MealSelectEvent extends LiveMenuEvent{
  final MealTime mealTime;
  const MealSelectEvent(this.mealTime);
}

class CategoryEvent extends LiveMenuEvent{
  final String category;
  final bool categoryContainsMatch;
  const CategoryEvent(this.category,this.categoryContainsMatch);
}
