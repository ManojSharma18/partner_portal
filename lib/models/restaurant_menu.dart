class MealSchema {
  bool breakfast;
  bool lunch;
  bool dinner;
  bool breakfastSession1;
  bool breakfastSession2;
  bool breakfastSession3;
  bool breakfastSession4;
  bool lunchSession1;
  bool lunchSession2;
  bool lunchSession3;
  bool lunchSession4;
  bool dinnerSession1;
  bool dinnerSession2;
  bool dinnerSession3;
  bool dinnerSession4;
  String? id;

  MealSchema({required this.breakfast, required this.lunch, required this.dinner, required this.breakfastSession1, required this.breakfastSession2, required this.breakfastSession3, required this.breakfastSession4, required this.lunchSession1, required this.lunchSession2, required this.lunchSession3, required this.lunchSession4, required this.dinnerSession1, required this.dinnerSession2, required this.dinnerSession3, required this.dinnerSession4, this.id});

  factory MealSchema.fromJson(Map<String, dynamic> json) {
    return MealSchema(
        breakfast: json['Breakfast'],
        lunch: json['Lunch'],
        dinner: json['Dinner'],
        breakfastSession1: json['BreakfastSession1'],
        breakfastSession2: json['BreakfastSession2'],
        breakfastSession3: json['BreakfastSession3'],
        breakfastSession4: json['BreakfastSession4'],
        lunchSession1: json['LunchSession1'],
        lunchSession2: json['LunchSession2'],
        lunchSession3: json['LunchSession3'],
        lunchSession4: json['LunchSession4'],
        dinnerSession1: json['DinnerSession1'],
        dinnerSession2: json['DinnerSession2'],
        dinnerSession3: json['DinnerSession3'],
        dinnerSession4: json['DinnerSession4'],
        id: json['_id']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Breakfast': breakfast,
      'Lunch': lunch,
      'Dinner': dinner,
      'BreakfastSession1':breakfastSession1,
      'BreakfastSession2':breakfastSession2,
      'BreakfastSession3':breakfastSession3,
      'BreakfastSession4':breakfastSession4,
      'LunchSession1' : lunchSession1,
      'LunchSession2' : lunchSession2,
      'LunchSession3' : lunchSession3,
      'LunchSession4' : lunchSession4,
      'DinnerSession1' : dinnerSession1,
      'DinnerSession2' : dinnerSession2,
      'DinnerSession3' : dinnerSession3,
      'DinnerSession4' : dinnerSession4,
      '_id':id
    };
  }

  factory MealSchema.fromMap(Map<String, dynamic> map) {
    return MealSchema(
        breakfast: map['Breakfast'],
        lunch: map['Lunch'],
        dinner: map['Dinner'],
        breakfastSession1: map['BreakfastSession1'],
        breakfastSession2: map['BreakfastSession2'],
        breakfastSession3: map['BreakfastSession3'],
        breakfastSession4: map['BreakfastSession4'],
        lunchSession1: map['LunchSession1'],
        lunchSession2: map['LunchSession2'],
        lunchSession3: map['LunchSession3'],
        lunchSession4: map['LunchSession4'],
        dinnerSession1: map['DinnerSession1'],
        dinnerSession2: map['DinnerSession2'],
        dinnerSession3: map['DinnerSession3'],
        dinnerSession4: map['DinnerSession4'],
        id: map['_id']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Breakfast': breakfast,
      'Lunch': lunch,
      'Dinner': dinner,
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
  SessionSchema defaultSession;
  SessionSchema session1;
  SessionSchema session2;
  SessionSchema session3;
  SessionSchema session4;

  TimingSchema({
    required this.defaultSession,
    required this.session1,
    required this.session2,
    required this.session3,
    required this.session4,
  });

  factory TimingSchema.fromJson(Map<String, dynamic> json) {
    return TimingSchema(
      defaultSession: SessionSchema.fromJson(json['Default']),
      session1: SessionSchema.fromJson(json['Session1']),
      session2: SessionSchema.fromJson(json['Session2']),
      session3: SessionSchema.fromJson(json['Session3']),
      session4: SessionSchema.fromJson(json['Session4']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Default': defaultSession.toJson(),
      'Session1': session1.toJson(),
      'Session2': session2.toJson(),
      'Session3': session3.toJson(),
      'Session4': session4.toJson(),
    };
  }

  factory TimingSchema.fromMap(Map<String, dynamic> map) {
    return TimingSchema(
      defaultSession: SessionSchema.fromMap(map['Default']),
      session1: SessionSchema.fromMap(map['Session1']),
      session2: SessionSchema.fromMap(map['Session2']),
      session3: SessionSchema.fromMap(map['Session3']),
      session4: SessionSchema.fromMap(map['Session4']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Default': defaultSession.toMap(),
      'Session1': session1.toMap(),
      'Session2': session2.toMap(),
      'Session3': session3.toMap(),
      'Session4': session4.toMap(),
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
      breakfast: TimingSchema.fromJson(json['Breakfast']),
      lunch: TimingSchema.fromJson(json['Lunch']),
      dinner: TimingSchema.fromJson(json['Dinner']),
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
  String name;
  String dname;
  String subTag;
  String priceRange;
  String itemType;
  bool availability;
  int totalCount;
  String itemTag;
  String itemSubType;
  String comboType;
  String rawSource;
  String category;
  String subCategory;
  double normalPrice;
  double packagePrice;
  double preorderPrice;
  Map<String, MealSchema> fpUnitAvailDaysAndMeals;
  MealTimingSchema fpUnitSessions;

  Mymenu({
    required this.name,
    required this.dname,
    required this.subTag,
    required this.priceRange,
    required this.itemType,
    required this.availability,
    required this.totalCount,
    required this.itemTag,
    required this.itemSubType,
    required this.comboType,
    required this.rawSource,
    required this.category,
    required this.subCategory,
    required this.normalPrice,
    required this.packagePrice,
    required this.preorderPrice,
    required this.fpUnitAvailDaysAndMeals,
    required this.fpUnitSessions,
    this.id
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
      name: json['std_itm_name'],
      dname: json['std_itm_dispname'],
      subTag: json['std_itm_subTag'],
      priceRange: json['std_itm_priceRange'],
      itemTag: json['std_itm_tag'],
      itemType: json['std_itm_itemType'],
      availability: json['std_itm_availability'],
      totalCount: json['totalCount'],
      itemSubType: json['std_itm_itemSubType'],
      comboType: json['std_itm_comboType'],
      rawSource: json['std_itm_rawSource'],
      category: json['std_itm_category'],
      subCategory: json['std_itm_subCategory'],
      normalPrice: json['std_itm_normalPrice'],
      packagePrice: json['std_itm_packagePrice'],
      preorderPrice: json['std_itm_preorderPrice'],
      fpUnitAvailDaysAndMeals: fpUnitAvailDaysAndMeals,
      fpUnitSessions: MealTimingSchema.fromJson(json['fp_unit_sessions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id':id,
      'std_itm_name': name,
      'std_itm_dispname': dname,
      'std_itm_subTag': subTag,
      'std_itm_priceRange': priceRange,
      'std_itm_itemType': itemType,
      'std_itm_availability': availability,
      'totalCount' : totalCount,
      'std_itm_tag' : itemTag,
      'std_itm_itemSubType': itemSubType,
      'std_itm_comboType': comboType,
      'std_itm_rawSource': rawSource,
      'std_itm_category': category,
      'std_itm_subCategory': subCategory,
      'std_itm_normalPrice': normalPrice,
      'std_itm_packagePrice': packagePrice,
      'std_itm_preorderPrice': preorderPrice,
      'fp_unit_avail_days_and_meals': fpUnitAvailDaysAndMeals.map((key, value) => MapEntry(key, value.toJson())),
      'fp_unit_sessions': fpUnitSessions.toJson(),
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
      name: map['std_itm_name'],
      dname: map['std_itm_dispname'],
      subTag: map['std_itm_subTag'],
      priceRange: map['std_itm_priceRange'],
      itemType: map['std_itm_itemType'],
      itemTag: map['std_itm_tag'],
      availability: map['std_itm_availability'],
      totalCount: map['totalCount'],
      itemSubType: map['std_itm_itemSubType'],
      comboType: map['std_itm_comboType'],
      rawSource: map['std_itm_rawSource'],
      category: map['std_itm_category'],
      subCategory: map['std_itm_subCategory'],
      normalPrice: map['std_itm_normalPrice'],
      packagePrice: map['std_itm_packagePrice'],
      preorderPrice: map['std_itm_preorderPrice'],
      fpUnitAvailDaysAndMeals: fpUnitAvailDaysAndMeals,
      fpUnitSessions: MealTimingSchema.fromMap(map['fp_unit_sessions']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id' : id,
      'std_itm_name': name,
      'std_itm_dispname': dname,
      'std_itm_subTag': subTag,
      'std_itm_priceRange': priceRange,
      'std_itm_itemType': itemType,
      'std_itm_availability': availability,
      'totalCount' : totalCount,
      'std_itm_tag' : itemTag,
      'std_itm_itemSubType': itemSubType,
      'std_itm_comboType': comboType,
      'std_itm_rawSource': rawSource,
      'std_itm_category': category,
      'std_itm_subCategory': subCategory,
      'std_itm_normalPrice': normalPrice,
      'std_itm_packagePrice': packagePrice,
      'std_itm_preorderPrice': preorderPrice,
      'fp_unit_avail_days_and_meals': fpUnitAvailDaysAndMeals.map((key, value) {
        return MapEntry(key, value.toMap());
      }),
      'fp_unit_sessions': fpUnitSessions.toMap(),
    };
  }
}
