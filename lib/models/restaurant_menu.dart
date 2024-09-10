class MealSchema {
  int breakfastSession1;
  int breakfastSession2;
  int breakfastSession3;
  int lunchSession1;
  int lunchSession2;
  int lunchSession3;
  int dinnerSession1;
  int dinnerSession2;
  int dinnerSession3;
  String? id;

  MealSchema({
    this.breakfastSession1 = 0,
    this.breakfastSession2 = 0,
    this.breakfastSession3 = 0,
    this.lunchSession1 = 0,
    this.lunchSession2 = 0,
    this.lunchSession3 = 0,
    this.dinnerSession1 = 0,
    this.dinnerSession2 = 0,
    this.dinnerSession3 = 0,
    this.id,
  });

  factory MealSchema.fromJson(Map<String, dynamic> json) {
    return MealSchema(
        breakfastSession1: json['BreakfastSession1'] ?? 0,
        breakfastSession2: json['BreakfastSession2'] ?? 0,
        breakfastSession3: json['BreakfastSession3'] ?? 0,
        lunchSession1: json['LunchSession1'] ?? 0,
        lunchSession2: json['LunchSession2'] ?? 0,
        lunchSession3: json['LunchSession3'] ?? 0,
        dinnerSession1: json['DinnerSession1'] ?? 0,
        dinnerSession2: json['DinnerSession2'] ?? 0,
        dinnerSession3: json['DinnerSession3'] ?? 0,
        id: json['_id']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BreakfastSession1':breakfastSession1,
      'BreakfastSession2':breakfastSession2,
      'BreakfastSession3':breakfastSession3,
      'LunchSession1' : lunchSession1,
      'LunchSession2' : lunchSession2,
      'LunchSession3' : lunchSession3,
      'DinnerSession1' : dinnerSession1,
      'DinnerSession2' : dinnerSession2,
      'DinnerSession3' : dinnerSession3,
      '_id':id
    };
  }

  factory MealSchema.fromMap(Map<String, dynamic> map) {
    return MealSchema(

      breakfastSession1: map['BreakfastSession1'] ?? 0,
      breakfastSession2: map['BreakfastSession2'] ?? 0,
      breakfastSession3: map['BreakfastSession3'] ?? 0,
      lunchSession1: map['LunchSession1'] ?? 0,
      lunchSession2: map['LunchSession2'] ?? 0,
      lunchSession3: map['LunchSession3'] ?? 0,
      dinnerSession1: map['DinnerSession1'] ?? 0,
      dinnerSession2: map['DinnerSession2'] ?? 0,
      dinnerSession3: map['DinnerSession3'] ?? 0,
      id: map['_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {

      '_id':id
    };
  }
}

class SessionSchema {
  int availableCount;
  bool enabled;

  SessionSchema({required this.availableCount, required this.enabled});

  factory SessionSchema.fromJson(Map<String, dynamic> json) {
    return SessionSchema(
      availableCount: json['availableCount'] ?? 0,
      enabled: json['Enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availableCount': availableCount,
      'Enabled': enabled ?? false,
    };
  }

  factory SessionSchema.fromMap(Map<String, dynamic> map) {
    return SessionSchema(
      availableCount: map['availableCount'] ?? 0,
      enabled: map['Enabled'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'availableCount': availableCount ?? 0,
      'Enabled': enabled ?? false,
    };
  }


}

class TimingSchema {
  SessionSchema session1;
  SessionSchema session2;
  SessionSchema session3;

  TimingSchema({
    required this.session1,
    required this.session2,
    required this.session3,
  });

  factory TimingSchema.fromJson(Map<String, dynamic> json) {
    return TimingSchema(
      session1: SessionSchema.fromJson(json['Session1']),
      session2: SessionSchema.fromJson(json['Session2']),
      session3: SessionSchema.fromJson(json['Session3']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Session1': session1.toJson(),
      'Session2': session2.toJson(),
      'Session3': session3.toJson(),
    };
  }

  factory TimingSchema.fromMap(Map<String, dynamic> map) {
    return TimingSchema(
      session1: SessionSchema.fromMap(map['Session1']),
      session2: SessionSchema.fromMap(map['Session2']),
      session3: SessionSchema.fromMap(map['Session3']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Session1': session1.toMap(),
      'Session2': session2.toMap(),
      'Session3': session3.toMap(),
    };
  }

}

class MealTimingSchema {
  TimingSchema breakfast;
  TimingSchema lunch;
  TimingSchema dinner;

  MealTimingSchema({required this.breakfast, required this.lunch, required this.dinner});

  factory MealTimingSchema.fromJson(Map<String, dynamic> json) {
    return MealTimingSchema(
      breakfast: TimingSchema.fromJson(json['Breakfast'] ?? {}),
      lunch: TimingSchema.fromJson(json['Lunch']?? {}),
      dinner: TimingSchema.fromJson(json['Dinner'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Breakfast': breakfast.toJson(),
      'Lunch': lunch.toJson(),
      'Dinner': dinner.toJson(),
    };
  }

  factory MealTimingSchema.fromMap(Map<String, dynamic> map) {
    return MealTimingSchema(
      breakfast: TimingSchema.fromMap(map['Breakfast']),
      lunch: TimingSchema.fromMap(map['Lunch']),
      dinner: TimingSchema.fromMap(map['Dinner']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Breakfast': breakfast.toMap(),
      'Lunch': lunch.toMap(),
      'Dinner': dinner.toMap(),
    };
  }
}

class Mymenu {
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


  Mymenu({
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

  factory Mymenu.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> daysAndMealsJson = json['fp_unit_avail_days_and_meals'];
    Map<String, MealSchema> fpUnitAvailDaysAndMeals = Map.fromIterable(
      daysAndMealsJson.keys,
      key: (k) => k,
      value: (k) => MealSchema.fromJson(daysAndMealsJson[k]),
    );

    return Mymenu(
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
        normalPrice: json['ritem_normalPrice'],
        halfNormalPrice: json['ritem_half_normalPrice'],
        packagePrice: json['ritem_packagePrice'],
        preorderPrice: json['ritem_preorderPrice'],
        halfPreorderPrice: json['ritem_half_preorderPrice'],
        normalFinalPrice: json['ritem_normalFinalPrice'],
        preorderFinalPrice: json['ritem_preorderFinalPrice'],
        halfNormalFinalPrice: json['ritem_half_normalFinalPrice'],
        halfPreorderFinalPrice: json['ritem_half_preorderFinalPrice'],
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

  factory Mymenu.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> daysAndMealsJson = map['fp_unit_avail_days_and_meals'];
    Map<String, MealSchema> fpUnitAvailDaysAndMeals = Map.fromIterable(
      daysAndMealsJson.keys,
      key: (k) => k,
      value: (k) => MealSchema.fromMap(daysAndMealsJson[k]),
    );

    return Mymenu(
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
