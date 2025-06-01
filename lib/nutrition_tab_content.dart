// lib/nutrition_tab_content.dart (FULL CORRECTED - Lottie for No Results & Initial Animation)

import 'package:flutter/material.dart';
import 'package:ishaan/app_data.dart' as AppData;
import 'package:ishaan/item_detail_page.dart';
import 'package:ishaan/nutrition_item_model.dart';
import 'package:ishaan/searchable_nutrition_items.dart';
import 'package:ishaan/shared_preferences_helper.dart'; // Ensure this import is correct for save/load functions
import 'package:string_similarity/string_similarity.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart'; // REQUIRED for Lottie animations

class NutritionTabContent extends StatefulWidget {
  final String currentMode;
  final ValueNotifier<ThemeMode> themeModeNotifier;
  final ValueNotifier<Map<String, String>?> lastVisitedNutritionNotifier;

  const NutritionTabContent({
    super.key,
    required this.currentMode,
    required this.themeModeNotifier,
    required this.lastVisitedNutritionNotifier,
  });

  @override
  State<NutritionTabContent> createState() => _NutritionTabContentState();
}

class _NutritionTabContentState extends State<NutritionTabContent> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchableNutritionItem> _allGeneralNutritionItems = [];
  List<SearchableNutritionItem> _filteredNutritionItems = [];
  String? _suggestedQuery;

  final List<Map<String, dynamic>> _nutritionCategoriesWithIcons = [
    {'name': 'All', 'icon': Ionicons.grid_outline, 'filledIcon': Ionicons.grid},
    {'name': 'Fruits', 'icon': Ionicons.nutrition_outline, 'filledIcon': Ionicons.nutrition},
    {'name': 'Vegetables', 'icon': Ionicons.leaf_outline, 'filledIcon': Ionicons.leaf},
    {'name': 'Nutrients', 'icon': Ionicons.sparkles_outline, 'filledIcon': Ionicons.sparkles},
    {'name': 'Dairy', 'icon': Ionicons.pint_outline, 'filledIcon': Ionicons.pint},
    {'name': 'Meat', 'icon': Icons.egg_outlined, 'filledIcon': Icons.egg},
    {'name': 'Grains', 'icon': Icons.grain_outlined, 'filledIcon': Icons.grain},
    {'name': 'Protein', 'icon': Ionicons.barbell_outline, 'filledIcon': Ionicons.barbell},
    {'name': 'Food', 'icon': Ionicons.restaurant_outline, 'filledIcon': Ionicons.restaurant},
  ];

  String _currentCategoryFilter = 'All';
  String? _previousCategoryFilter;

  bool _showInitialLottieAnimation = true; // Renamed for clarity

  @override
  void initState() {
    super.initState();
    _loadGeneralNutritionDataAndFlatten();
    _searchController.addListener(_onSearchChanged);
    _applyFilters();
    _previousCategoryFilter = _currentCategoryFilter;

    // Play initial Lottie animation once
    Future.delayed(const Duration(seconds: 2), () { // Adjust duration as needed
      if (mounted) {
        setState(() {
          _showInitialLottieAnimation = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _loadGeneralNutritionDataAndFlatten() {
    _allGeneralNutritionItems = [];
    AppData.generalNutritionData.forEach((categoryKey, categoryData) {
      if (categoryData.containsKey('items') && categoryData['items'] is List) {
        for (var itemMap in categoryData['items']) {
          if (itemMap is Map<String, dynamic>) {
            _allGeneralNutritionItems.add(
              SearchableNutritionItem(
                parentCategory: categoryKey,
                name: itemMap['name']!,
                normalModeDescription: itemMap['normalModeDescription'] ?? '',
                funModeDescription: itemMap['funModeDescription'] ?? '',
                shortDescription: itemMap['shortDescription'] ?? '',
                additionalInfoExtra: itemMap['additionalInfoExtra'] ?? '',
                imagePath: itemMap['image'] ?? '',
                modelPath: itemMap['modelPath'] ?? '',
                additionalInfo: itemMap['additionalInfo'] ?? '',
              ),
            );
          }
        }
      }
    });
    print("Loaded ${_allGeneralNutritionItems.length} general nutrition items.");
  }

  String? _getCorrectionSuggestion(String query) {
    if (query.isEmpty) return null;

    final queryLower = query.toLowerCase();
    String? bestMatch;
    double highestSimilarity = 0.0;
    const double similarityThreshold = 0.1;

    for (var item in _allGeneralNutritionItems) {
      final itemNameLower = item.name.toLowerCase();
      final similarity = itemNameLower.similarityTo(queryLower);

      if (similarity > highestSimilarity && similarity >= similarityThreshold) {
        highestSimilarity = similarity;
        bestMatch = item.name;
      }
    }
    return bestMatch;
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    List<SearchableNutritionItem> tempFilteredList = [];

    if (_currentCategoryFilter == 'All') {
      tempFilteredList = List.from(_allGeneralNutritionItems);
    } else {
      tempFilteredList = _allGeneralNutritionItems.where((item) {
        return item.parentCategory == _currentCategoryFilter;
      }).toList();
    }

    if (query.isNotEmpty) {
      tempFilteredList = tempFilteredList.where((item) {
        return item.searchableText.contains(query);
      }).toList();
    }

    setState(() {
      _filteredNutritionItems = tempFilteredList;
      _suggestedQuery = null;

      if (query.isNotEmpty && _filteredNutritionItems.isEmpty) {
        _suggestedQuery = _getCorrectionSuggestion(query);
      }

      _filteredNutritionItems.sort((a, b) {
        final aSearchText = a.searchableText;
        final bSearchText = b.searchableText;

        if (a.name.toLowerCase().startsWith(query) && !b.name.toLowerCase().startsWith(query)) return -1;
        if (!a.name.toLowerCase().startsWith(query) && b.name.toLowerCase().startsWith(query)) return 1;

        if (a.shortDescription.toLowerCase().contains(query) && !b.shortDescription.toLowerCase().contains(query)) return -1;
        if (!a.shortDescription.toLowerCase().contains(query) && b.shortDescription.toLowerCase().contains(query)) return 1;

        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    });
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _onCategorySelected(String category) {
    if (_currentCategoryFilter == category) return;

    setState(() {
      _previousCategoryFilter = _currentCategoryFilter;
      _currentCategoryFilter = category;
      _searchController.clear();
      FocusScope.of(context).unfocus();
    });
    _applyFilters();
  }

  Widget _buildSearchResultItemUI(BuildContext context, SearchableNutritionItem item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        final String descriptionForDetailPage = widget.currentMode == 'fun'
            ? (item.funModeDescription.isNotEmpty ? item.funModeDescription : item.normalModeDescription)
            : item.normalModeDescription;

        // Call the top-level function directly and pass both name and imagePath
        saveLastVisitedNutritionItem(item.name, item.imagePath); // Corrected call
        // Update the ValueNotifier with both name and imagePath
        widget.lastVisitedNutritionNotifier.value = {
          'name': item.name,
          'imagePath': item.imagePath, // Ensure imagePath is passed
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailPage(
              name: item.name,
              modelPath: item.modelPath ?? '',
              description: descriptionForDetailPage,
              additionalInfo: item.additionalInfo,
              image: item.imagePath,
              additionalInfoExtra: item.additionalInfoExtra,
              mode: widget.currentMode,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        color: colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (item.imagePath.isNotEmpty)
                Image.asset(
                  item.imagePath,
                  width: 300,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 80, color: colorScheme.onSecondary),
                )
              else
                Icon(Icons.fastfood, size: 80, color: colorScheme.onSecondary),

              const SizedBox(height: 12),

              Text(
                '${item.name} (${item.parentCategory})',
                style: theme.textTheme.displayLarge?.copyWith(color: colorScheme.onSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),

              if (item.shortDescription.isNotEmpty)
                Text(
                  item.shortDescription,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.displaySmall?.copyWith(color: colorScheme.onSecondary.withOpacity(0.7)),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Offset beginOffset;
    Offset endOffsetOldChild;

    int newIndex = _nutritionCategoriesWithIcons.indexWhere((map) => map['name'] == _currentCategoryFilter);
    int oldIndex = _nutritionCategoriesWithIcons.indexWhere((map) => map['name'] == _previousCategoryFilter);

    if (oldIndex == -1 || newIndex == -1 || newIndex == oldIndex) {
      beginOffset = Offset.zero;
      endOffsetOldChild = Offset.zero;
    } else if (newIndex > oldIndex) {
      beginOffset = const Offset(1.0, 0.0);
      endOffsetOldChild = const Offset(-1.0, 0.0);
    } else {
      beginOffset = const Offset(-1.0, 0.0);
      endOffsetOldChild = const Offset(1.0, 0.0);
    }

    // Determine Lottie animation path based on theme mode
    String clickLottiePath;
    if (widget.themeModeNotifier.value == ThemeMode.dark) {
      clickLottiePath = 'assets/animations/dark/click.json';
    } else {
      clickLottiePath = 'assets/animations/light/click.json';
    }

    return Column(
      children: [
        // NEW: Initial Lottie Animation at the top, plays once
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search in $_currentCategoryFilter...',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary.withOpacity(0.6)),
              prefixIcon: Icon(Ionicons.search_outline, color: colorScheme.secondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Ionicons.close_circle_outline, color: colorScheme.onSecondary),
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged();
                  FocusScope.of(context).unfocus();
                },
              )
                  : null,
            ),
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        if (_searchController.text.isNotEmpty && _filteredNutritionItems.isEmpty && _suggestedQuery != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Did you mean ',
                  style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground),
                ),
                GestureDetector(
                  onTap: () {
                    _searchController.text = _suggestedQuery!;
                    _onSearchChanged();
                    FocusScope.of(context).unfocus();
                  },
                  child: Text(
                    '"$_suggestedQuery"',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      decoration: TextDecoration.underline,
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
                Text(
                  '?',
                  style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground),
                ),
              ],
            ),
          ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _nutritionCategoriesWithIcons.map((categoryMap) {
                final String categoryName = categoryMap['name'];
                final IconData outlineIcon = categoryMap['icon'];
                final IconData filledIcon = categoryMap['filledIcon'];
                final bool isSelected = _currentCategoryFilter == categoryName;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: GestureDetector(
                    onTap: () => _onCategorySelected(categoryName),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected ? colorScheme.secondary.withOpacity(0.2) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? colorScheme.secondary : colorScheme.onSurface.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            isSelected ? filledIcon : outlineIcon,
                            color: isSelected ? colorScheme.secondary : colorScheme.onSecondary.withOpacity(0.7),
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          categoryName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected ? colorScheme.secondary : colorScheme.onSecondary.withOpacity(0.7),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const Divider(height: 20, thickness: 1),

        if (_showInitialLottieAnimation)
          Lottie.asset(
            clickLottiePath,
            height: 150, // Adjust height as needed
            repeat: false, // Play once
            fit: BoxFit.fill,
          ),

        // Main List of Nutrition Items (filtered by search or category)
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return Stack(
                children: [
                  if (animation.status == AnimationStatus.forward && child.key != null && child.key is ValueKey && (child.key as ValueKey).value == (_currentCategoryFilter + _searchController.text))
                    Positioned.fill(
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset.zero,
                          end: endOffsetOldChild,
                        ).animate(animation),
                        child: FadeTransition(
                          opacity: Tween<double>(begin: 1.0, end: 0.0).animate(animation),
                          child: child,
                        ),
                      ),
                    ),
                  Positioned.fill(
                    child: SlideTransition(
                      position: Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(animation),
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                        child: child,
                      ),
                    ),
                  ),
                ],
              );
            },
            // --- THIS IS THE SECTION YOU ASKED TO FIX ---
            child: _filteredNutritionItems.isEmpty && _searchController.text.isNotEmpty && _suggestedQuery == null
                ? Center(
              key: ValueKey('no_results_${_currentCategoryFilter}_${_searchController.text}'),
              child: Column( // <--- Changed to Column to hold Lottie and Text
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset( // <--- Lottie animation for no results
                    'assets/animations/no-results.json', // **IMPORTANT: Replace with your actual path**
                    width: 200,
                    height: 100,
                    fit: BoxFit.contain,
                    repeat: true, // You can set this to false if you want it to play once
                  ),
                  const SizedBox(height: 16), // Spacing between Lottie and text
                  Text(
                    'No results found for "${_searchController.text}" in "$_currentCategoryFilter"',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: colorScheme.onBackground.withOpacity(0.7)),
                  ),
                ],
              ),
            )
                : ListView.builder(
              key: ValueKey(_currentCategoryFilter + _searchController.text),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filteredNutritionItems.length,
              itemBuilder: (context, index) {
                return _buildSearchResultItemUI(context, _filteredNutritionItems[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}