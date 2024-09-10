class ManageSettingModel {
  String fp_unit_id;
  List<String> consumptionMode;
  Map<String, Map<String, bool>> fpUnitAvailDaysAndMeals;
  Map<String, Map<String, Map<String, dynamic>>> fpUnitSessions;

  ManageSettingModel({
    required this.fp_unit_id,
    required this.consumptionMode,
    required this.fpUnitAvailDaysAndMeals,
    required this.fpUnitSessions,
  });

  factory ManageSettingModel.fromJson(Map<String, dynamic> json) {
    // Safely parse each field to avoid type errors
    return ManageSettingModel(
      fp_unit_id: json['fp_unit_id'] ?? '',
      consumptionMode: json['consumption_mode'] != null
          ? List<String>.from(json['consumption_mode'])
          : [],
      fpUnitAvailDaysAndMeals: json['fp_unit_avail_days_and_meals'] != null
          ? Map<String, Map<String, bool>>.from(
        json['fp_unit_avail_days_and_meals'].map(
              (k, v) => MapEntry<String, Map<String, bool>>(
            k,
            Map<String, bool>.from(v),
          ),
        ),
      )
          : {},
      fpUnitSessions: json['fp_unit_sessions'] != null
          ? Map<String, Map<String, Map<String, dynamic>>>.from(
        json['fp_unit_sessions'].map(
              (k, v) => MapEntry<String, Map<String, Map<String, dynamic>>>(
            k,
            Map<String, Map<String, dynamic>>.from(v),
          ),
        ),
      )
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fp_unit_id': fp_unit_id,
      'consumption_mode': consumptionMode,
      'fp_unit_avail_days_and_meals': fpUnitAvailDaysAndMeals,
      'fp_unit_sessions': fpUnitSessions,
    };
  }
}
