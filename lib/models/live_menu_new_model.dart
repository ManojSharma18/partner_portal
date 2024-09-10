class LiveMenuNew {
  final String ritemUId;
  final String ritemDispname;
  final bool ritemAvailability;
  final String ritemCategory;
  final String ritemTag;
  final int ritemAvailableType;
  final String day;
  final String date;
  final MealSessionCount mealsSessionCount;

  LiveMenuNew({
    required this.ritemUId,
    required this.ritemDispname,
    required this.ritemAvailability,
    required this.ritemCategory,
    required this.ritemTag,
    required this.ritemAvailableType,
    required this.day,
    required this.date,
    required this.mealsSessionCount,
  });

  factory LiveMenuNew.fromJson(Map<String, dynamic> json) {
    return LiveMenuNew(
      ritemUId: json['ritem_UId'],
      ritemDispname: json['ritem_dispname'],
      ritemAvailability: json['ritem_availability'],
      ritemCategory: json['ritem_category'],
      ritemTag: json['ritem_tag'],
      ritemAvailableType: json['ritem_available_type'],
      day: json['day'],
      date: json['date'],
      mealsSessionCount: MealSessionCount.fromJson(json['meals_session_count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ritem_UId': ritemUId,
      'ritem_dispname': ritemDispname,
      'ritem_availability': ritemAvailability,
      'ritem_category': ritemCategory,
      'ritem_tag': ritemTag,
      'ritem_available_type': ritemAvailableType,
      'day': day,
      'date': date,
      'meals_session_count': mealsSessionCount.toJson(),
    };
  }
}

class MealSessionCount {
  final Meal breakfast;
  final Meal lunch;
  final Meal dinner;

  MealSessionCount({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  factory MealSessionCount.fromJson(Map<String, dynamic> json) {
    return MealSessionCount(
      breakfast: Meal.fromJson(json['breakfast']),
      lunch: Meal.fromJson(json['lunch']),
      dinner: Meal.fromJson(json['dinner']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast.toJson(),
      'lunch': lunch.toJson(),
      'dinner': dinner.toJson(),
    };
  }
}

class Meal {
  final bool enabled;
  final Session session1;
  final Session session2;
  final Session session3;

  Meal({
    required this.enabled,
    required this.session1,
    required this.session2,
    required this.session3,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      enabled: json['Enabled'],
      session1: Session.fromJson(json['session1']),
      session2: Session.fromJson(json['session2']),
      session3: Session.fromJson(json['session3']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Enabled': enabled,
      'session1': session1.toJson(),
      'session2': session2.toJson(),
      'session3': session3.toJson(),
    };
  }
}

class Session {
  final bool enabled;
  final int availableCount;

  Session({
    required this.enabled,
    required this.availableCount,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      enabled: json['Enabled'],
      availableCount: json['availableCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Enabled': enabled,
      'availableCount': availableCount,
    };
  }
}
