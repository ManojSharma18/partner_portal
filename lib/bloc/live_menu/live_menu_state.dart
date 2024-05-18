import 'package:equatable/equatable.dart';
import 'package:partner_admin_portal/widgets/menu/live_menu/live_menu.dart';


class LiveMenuState extends Equatable {
  final Set<String> selectedCategories;
  final MealTime? mealTime;
  final String? category;
  final String categoryName;
  final Map<String, dynamic> item;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String itemName;

  const LiveMenuState({
    required this.selectedCategories,
    this.category,
    this.mealTime,
    this.categoryName = '',
    this.item = const {},
    required this.foodCategories,
    required this.itemName
  });

  @override
  List<Object?> get props => [selectedCategories, categoryName,foodCategories,item,itemName,mealTime,category];

  LiveMenuState copyWith({
    Set<String>? selectedCategories,
    String? category,
    MealTime? mealTime,
    String? categoryName,
    Map<String, List<Map<String,dynamic>>>? foodCategories,
    Map<String, dynamic>? item,
    String? itemName,
  }) {
    return LiveMenuState(
      selectedCategories: selectedCategories ?? this.selectedCategories,
        mealTime: mealTime ?? this.mealTime,
      category: category ?? this.category,
      categoryName: categoryName ?? this.categoryName,
      foodCategories: foodCategories ?? this.foodCategories,
      item: item ?? this.item,
      itemName: itemName ?? this.itemName
    );
  }
}

