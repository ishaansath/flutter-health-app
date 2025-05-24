// lib/models/searchable_nutrition_item.dart

class SearchableNutritionItem {
  final String parentCategory; // e.g., "Fruits", "Vegetables", "Nutrients"
  final String name;
  final String normalModeDescription;
  final String funModeDescription;
  final String shortDescription;
  final String additionalInfoExtra;
  final String imagePath;
  final String modelPath;
  final String additionalInfo; // From your generalNutritionData items

  SearchableNutritionItem({
    required this.parentCategory,
    required this.name,
    this.normalModeDescription = '',
    this.funModeDescription = '',
    this.shortDescription = '',
    this.additionalInfoExtra = '',
    this.imagePath = '',
    this.modelPath = '',
    this.additionalInfo = '',
  });

  // A helper method to get all searchable text from the item
  String get searchableText {
    return '$name $normalModeDescription $funModeDescription $shortDescription $additionalInfoExtra $additionalInfo'
        .toLowerCase();
  }
}