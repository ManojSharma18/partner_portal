
import 'package:partner_admin_portal/models/restaurant_menu.dart';

class LiveMenuModel {
  String? id;
  String uId;
  String name;
  String dname;
  String priceRange;
  String itemType;
  bool availability;
  String regional;
  String cuisine;
  String itemTag;
  String itemSubType;
  String comboType;
  String rawSource;
  String category;
  String subCategory;
  double packagePrice;
  double normalPrice;
  double preorderPrice;
  double normalFinalPrice;
  double preorderFinalPrice;
  double? halfNormalPrice;
  double? halfPreorderPrice;
  double? halfNormalFinalPrice;
  double? halfPreorderFinalPrice;
  bool? halfPrice;
  int availableType;
  List<String>? consumptionMode;
  Map<String, MealSchema> fpUnitAvailDaysAndMeals;

  LiveMenuModel({
    required this.uId,
    required this.name,
    required this.dname,
    required this.priceRange,
    required this.itemType,
    required this.availability,
    required this.itemTag,
    required this.itemSubType,
    required this.comboType,
    required this.cuisine,
    required this.regional,
    required this.rawSource,
    required this.category,
    required this.subCategory,
    required this.normalPrice,
    required this.packagePrice,
    required this.preorderPrice,
    required this.normalFinalPrice,
    required this.preorderFinalPrice,
    required this.fpUnitAvailDaysAndMeals,
    required this.availableType,
    this.halfNormalPrice,
    this.halfPreorderPrice,
    this.halfNormalFinalPrice,
    this.halfPreorderFinalPrice,
    this.halfPrice,
    this.id,
    this.consumptionMode,
  });

  factory LiveMenuModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> daysAndMealsJson = json['fp_unit_avail_days_and_meals'];
    Map<String, MealSchema> fpUnitAvailDaysAndMeals = Map.fromIterable(
      daysAndMealsJson.keys,
      key: (k) => k,
      value: (k) => MealSchema.fromJson(daysAndMealsJson[k]),
    );

    return LiveMenuModel(
      id: json['_id'],
      uId: json['ritem_UId'],
      name: json['ritem_name'],
      dname: json['ritem_dispname'],
      priceRange: json['ritem_priceRange'] ?? 'SELECT',
      itemTag: json['ritem_tag'],
      itemType: json['ritem_itemType'] ?? 'SELECT',
      regional: json['ritem_regional'],
      cuisine: json['ritem_cuisine'],
      availability: json['ritem_availability'],
      itemSubType: json['ritem_itemSubType'] ?? 'SELECT',
      comboType: json['ritem_comboType'] ?? 'SELECT',
      rawSource: json['ritem_rawSource'],
      category: json['ritem_category'] ?? 'SELECT',
      subCategory: json['ritem_subCategory'],
      normalPrice: json['ritem_normalPrice']?? 0.0,
      halfNormalPrice: json['ritem_half_normalPrice'] ?? 0.0,
      packagePrice: json['ritem_packagePrice']?? 0.0,
      preorderPrice: json['ritem_preorderPrice']?? 0.0,
      halfPreorderPrice: json['ritem_half_preorderPrice']?? 0.0,
      normalFinalPrice: json['ritem_normalFinalPrice']?? 0.0,
      preorderFinalPrice: json['ritem_preorderFinalPrice']?? 0.0,
      halfNormalFinalPrice: json['ritem_half_normalFinalPrice']?? 0.0,
      halfPreorderFinalPrice: json['ritem_half_preorderFinalPrice']?? 0.0,
      halfPrice: json['ritem_half_price'],
      fpUnitAvailDaysAndMeals: fpUnitAvailDaysAndMeals,
      availableType: json['ritem_available_type'],
      consumptionMode: List<String>.from(json['ritem_consumption_mode']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id':id,
      'ritem_UId' : uId,
      'ritem_name': name,
      'ritem_dispname': dname,
      'ritem_priceRange': priceRange,
      'ritem_itemType': itemType,
      'ritem_availability': availability,
      'ritem_tag' : itemTag,
      'ritem_cuisine' : cuisine,
      'ritem_regional' : regional,
      'ritem_itemSubType': itemSubType,
      'ritem_comboType': comboType,
      'ritem_rawSource': rawSource,
      'ritem_category': category,
      'ritem_subCategory': subCategory,
      'ritem_normalPrice': normalPrice,
      'ritem_half_normalPrice': halfNormalPrice,
      'ritem_packagePrice': packagePrice,
      'ritem_preorderPrice': preorderPrice,
      'ritem_normalFinalPrice' : normalFinalPrice,
      'ritem_preorderFinalPrice' : preorderFinalPrice,
      'ritem_half_preorderPrice': halfPreorderPrice,
      'ritem_half_normalFinalPrice' : halfNormalFinalPrice,
      'ritem_half_preorderFinalPrice' : halfPreorderFinalPrice,
      'ritem_half_price' : halfPrice,
      'fp_unit_avail_days_and_meals': fpUnitAvailDaysAndMeals.map((key, value) => MapEntry(key, value.toJson())),
      'ritem_available_type' : availableType,
      'ritem_consumption_mode' : consumptionMode ?? []
    };
  }

  factory LiveMenuModel.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> daysAndMealsJson = map['fp_unit_avail_days_and_meals'];
    Map<String, MealSchema> fpUnitAvailDaysAndMeals = Map.fromIterable(
      daysAndMealsJson.keys,
      key: (k) => k,
      value: (k) => MealSchema.fromMap(daysAndMealsJson[k]),
    );

    return LiveMenuModel(
        id: map['_id'],
        uId: map['ritem_UId'],
        name: map['ritem_name'],
        dname: map['ritem_dispname'],
        priceRange: map['ritem_priceRange'] ?? 'SELECT',
        itemType: map['ritem_itemType'],
        itemTag: map['ritem_tag'],
        regional: map['ritem_regional'],
        cuisine: map['ritem_cuisine'],
        availability: map['ritem_availability'],
        itemSubType: map['ritem_itemSubType'],
        comboType: map['ritem_comboType'],
        rawSource: map['ritem_rawSource'],
        category: map['ritem_category'],
        subCategory: map['ritem_subCategory'],
        normalPrice: map['ritem_normalPrice'],
        halfNormalPrice: map['ritem_half_normalPrice'],
        packagePrice: map['ritem_packagePrice'],
        preorderPrice: map['ritem_preorderPrice'],
        normalFinalPrice: map['ritem_normalFinalPrice'],
        preorderFinalPrice: map['ritem_preorderFinalPrice'],
        halfPreorderPrice: map['ritem_half_preorderPrice'],
        halfNormalFinalPrice: map['ritem_half_normalFinalPrice'],
        halfPreorderFinalPrice: map['ritem_half_preorderFinalPrice'],
        halfPrice: map['ritem_half_price'],
        fpUnitAvailDaysAndMeals: fpUnitAvailDaysAndMeals,
        availableType: map['ritem_available_type'],
        consumptionMode: map['ritem_consumption_mode'] ?? []
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'ritem_UId' :uId,
      'ritem_name': name,
      'ritem_dispname': dname,
      'ritem_priceRange': priceRange,
      'ritem_itemType': itemType,
      'ritem_availability': availability,
      'ritem_tag': itemTag,
      'ritem_cuisine': cuisine,
      'ritem_regional': regional,
      'ritem_itemSubType': itemSubType,
      'ritem_comboType': comboType,
      'ritem_rawSource': rawSource,
      'ritem_category': category,
      'ritem_subCategory': subCategory,
      'ritem_normalPrice': normalPrice,
      'ritem_half_normalPrice': halfNormalPrice,
      'ritem_packagePrice': packagePrice,
      'ritem_preorderPrice': preorderPrice,
      'ritem_normalFinalPrice': normalFinalPrice,
      'ritem_preorderFinalPrice' : preorderFinalPrice,
      'ritem_half_preorderPrice': halfPreorderPrice,
      'ritem_half_normalFinalPrice': halfNormalFinalPrice,
      'ritem_half_preorderFinalPrice' : halfPreorderFinalPrice,
      'ritem_half_price' : halfPrice,
      'ritem_available_type' : availableType,
      'ritem_consumption_mode' : consumptionMode ?? [],
      'fp_unit_avail_days_and_meals': fpUnitAvailDaysAndMeals.map((key, value) {
        return MapEntry(key, value.toMap());
      }),
    };
  }

}
