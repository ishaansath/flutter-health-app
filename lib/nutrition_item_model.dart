// lib/nutrition_item_model.dart

class NutritionItem {
  final String name;
  final String image;
  final String modelPath; // From app_data.dart, now pre-processed
  final String normalModeDescription; // Maps to your app_data's 'normalModeDescription'
  final String funModeDescription;    // Maps to your app_data's 'funModeDescription'
  final String shortDescription; // Also from app_data
  final String additionalInfo;      // Mapped from app_data, now explicit
  final String additionalInfoExtra; // Mapped from app_data, now explicit

  NutritionItem({
    required this.name,
    required this.image,
    this.modelPath = '', // Default to empty string
    this.normalModeDescription = '',
    this.funModeDescription = '',
    this.shortDescription = '',
    this.additionalInfo = '',
    this.additionalInfoExtra = '',
  });

  // Factory constructor to create a NutritionItem object from the pre-processed Map
  factory NutritionItem.fromMap(Map<String, dynamic> map) {
    return NutritionItem(
      name: map['name'] as String? ?? 'Unknown Item',
      image: map['image'] as String? ?? 'assets/placeholder.png',
      modelPath: map['modelPath'] as String? ?? '', // Explicitly handle null
      normalModeDescription: map['normalModeDescription'] as String? ?? '',
      funModeDescription: map['funModeDescription'] as String? ?? '',
      shortDescription: map['shortDescription'] as String? ?? '',
      additionalInfo: map['additionalInfo'] as String? ?? '',
      additionalInfoExtra: map['additionalInfoExtra'] as String? ?? '',
    );
  }
}