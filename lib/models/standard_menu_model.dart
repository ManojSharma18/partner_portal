class StandardItem {
  final String id;
  final int stdItemId;
  final String? stdItemImage;
  final String stdItemName;
  final String stdItemDisplayName;
  final String stdItemDisplayNameKannada;
  final String stdItemDisplayNameHindi;
  final String stdItemDisplayNameTelugu;
  final String stdItemDisplayNameTamil;
  final String stdItemDescription;
  final String stdItemCategory;
  final String stdItemType;
  final String stdItemSubType;
  final String stdItemComboType;
  final String stdItemCategorySmall;
  final String stdItemSubcategory;
  final String stdItemSubcategorySmall;
  final String stdItemCuisine;
  final String stdItemCuisineSmall;
  final String stdItemCuisineDescription;
  final String stdItemCuisineDescriptionSmall;
  final String stdItemRegional;
  final String stdItemRegionalSmall;
  final String stdItemRawSource;
  final String stdItemRawSourceSmall;
  final String stdItemBrandRange;
  final String stdItemBrandRangeSmall;

  StandardItem({
    required this.id,
    required this.stdItemId,
    required this.stdItemComboType,
    required this.stdItemSubType,
    required this.stdItemType,
    this.stdItemImage,
    required this.stdItemName,
    required this.stdItemDisplayName,
    required this.stdItemDisplayNameKannada,
    required this.stdItemDisplayNameHindi,
    required this.stdItemDisplayNameTelugu,
    required this.stdItemDisplayNameTamil,
    required this.stdItemDescription,
    required this.stdItemCategory,
    required this.stdItemCategorySmall,
    required this.stdItemSubcategory,
    required this.stdItemSubcategorySmall,
    required this.stdItemCuisine,
    required this.stdItemCuisineSmall,
    required this.stdItemCuisineDescription,
    required this.stdItemCuisineDescriptionSmall,
    required this.stdItemRegional,
    required this.stdItemRegionalSmall,
    required this.stdItemRawSource,
    required this.stdItemRawSourceSmall,
    required this.stdItemBrandRange,
    required this.stdItemBrandRangeSmall,
  });

  // Factory method to create an Item from JSON
  factory StandardItem.fromJson(Map<String, dynamic> json) {
    return StandardItem(
      id: json['_id'] as String,
      stdItemId: json['std_itm_id'] as int,
      stdItemImage: json['std_itm_dimg'] ?? '' as String ,
      stdItemName: json['std_itm_name'] as String,
      stdItemDisplayName: json['std_itm_dispname'] as String,
      stdItemType: json['std_itm_type'] as String,
      stdItemSubType: json['std_item_sub_type'] as String,
      stdItemComboType: json['std_itm_combo_type'] as String,
      stdItemDisplayNameKannada: json['std_itm_dispname_kannada'] as String,
      stdItemDisplayNameHindi: json['std_itm_dispname_Hindi'] as String,
      stdItemDisplayNameTelugu: json['std_itm_dispname_Telugu'] as String,
      stdItemDisplayNameTamil: json['std_itm_dispname_Tamil'] as String,
      stdItemDescription: json['std_itm_desc'] as String,
      stdItemCategory: json['std_itm_cat'] as String,
      stdItemCategorySmall: json['std_itm_cat_small'] as String,
      stdItemSubcategory: json['std_itm_subcat'] as String,
      stdItemSubcategorySmall: json['std_itm_subcat_small'] as String,
      stdItemCuisine: json['std_itm_cuisine'] as String,
      stdItemCuisineSmall: json['std_itm_cuisine_small'] as String,
      stdItemCuisineDescription: json['std_itm_cuisine_description'] as String,
      stdItemCuisineDescriptionSmall: json['std_itm_cuisine_description_small'] as String,
      stdItemRegional: json['std_itm_regional'] as String,
      stdItemRegionalSmall: json['std_itm_regional_smaall'] as String,
      stdItemRawSource: json['std_itm_raw_source'] as String,
      stdItemRawSourceSmall: json['std_itm_raw_source_small'] as String,
      stdItemBrandRange: json['std_itm_brange'] as String,
      stdItemBrandRangeSmall: json['std_itm_brange_small'] as String,
    );
  }

  // Method to convert an Item to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'std_itm_id': stdItemId,
      'std_itm_dimg': stdItemImage,
      'std_itm_name': stdItemName,
      'std_itm_dispname': stdItemDisplayName,
      'std_itm_combo_type' : stdItemComboType,
      'std_item_sub_type' : stdItemSubType,
      'std_itm_type' : stdItemType,
      'std_itm_dispname_kannada': stdItemDisplayNameKannada,
      'std_itm_dispname_Hindi': stdItemDisplayNameHindi,
      'std_itm_dispname_Telugu': stdItemDisplayNameTelugu,
      'std_itm_dispname_Tamil': stdItemDisplayNameTamil,
      'std_itm_desc': stdItemDescription,
      'std_itm_cat': stdItemCategory,
      'std_itm_cat_small': stdItemCategorySmall,
      'std_itm_subcat': stdItemSubcategory,
      'std_itm_subcat_small': stdItemSubcategorySmall,
      'std_itm_cuisine': stdItemCuisine,
      'std_itm_cuisine_small': stdItemCuisineSmall,
      'std_itm_cuisine_description': stdItemCuisineDescription,
      'std_itm_cuisine_description_small': stdItemCuisineDescriptionSmall,
      'std_itm_regional': stdItemRegional,
      'std_itm_regional_smaall': stdItemRegionalSmall,
      'std_itm_raw_source': stdItemRawSource,
      'std_itm_raw_source_small': stdItemRawSourceSmall,
      'std_itm_brange': stdItemBrandRange,
      'std_itm_brange_small': stdItemBrandRangeSmall,
    };
  }
}