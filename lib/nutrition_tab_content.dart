// lib/nutrition_tab_content.dart (MODIFIED - Directional Slide In/Out Animation)

import 'package:flutter/material.dart';
import 'package:ishaan/app_data.dart' as AppData;
import 'package:ishaan/item_detail_page.dart';
import 'package:ishaan/nutrition_item_model.dart';
import 'package:ishaan/searchable_nutrition_items.dart';
import 'package:string_similarity/string_similarity.dart'; // Import the package
import 'package:ionicons/ionicons.dart'; // Import Ion Icons

class NutritionTabContent extends StatefulWidget {
  final String currentMode;


  const NutritionTabContent({
    super.key,
    required this.currentMode,
  });

  @override
  State<NutritionTabContent> createState() => _NutritionTabContentState();
}

class _NutritionTabContentState extends State<NutritionTabContent> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchableNutritionItem> _allGeneralNutritionItems = [];
  List<SearchableNutritionItem> _filteredNutritionItems = [];
  String? _suggestedQuery; // Added for "Did you mean?" functionality

  // NEW: List of categories with their display names and Ion Icons
  final List<Map<String, dynamic>> _nutritionCategoriesWithIcons = [
    {'name': 'All', 'icon': Ionicons.grid_outline, 'filledIcon': Ionicons.grid},
    {'name': 'Fruits', 'icon': Ionicons.nutrition_outline, 'filledIcon': Ionicons.nutrition},
    {'name': 'Vegetables', 'icon': Ionicons.leaf_outline, 'filledIcon': Ionicons.leaf},
    {'name': 'Nutrients', 'icon': Ionicons.sparkles_outline, 'filledIcon': Ionicons.sparkles},
    {'name': 'Dairy', 'icon': Ionicons.pint_outline, 'filledIcon': Ionicons.pint},
    {'name': 'Meat', 'icon': Icons.egg_outlined, 'filledIcon': Icons.egg},
    {'name': 'Grains', 'icon': Icons.grain_outlined, 'filledIcon': Icons.grain},
    {'name': 'Protein', 'icon': Ionicons.barbell_outline, 'filledIcon': Ionicons.barbell},
  ];

  // NEW: State to hold the currently selected category filter
  String _currentCategoryFilter = 'All';
  // NEW: State to hold the previously selected category filter for animation direction
  String? _previousCategoryFilter;


  @override
  void initState() {
    super.initState();
    _loadGeneralNutritionDataAndFlatten();
    _searchController.addListener(_onSearchChanged);
    _applyFilters(); // Apply initial filter (which is 'All')
    _previousCategoryFilter = _currentCategoryFilter; // Initialize previous category
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
    // Initial filter will be applied in _applyFilters
    print("Loaded ${_allGeneralNutritionItems.length} general nutrition items.");
  }

  // New method for suggesting corrections
  String? _getCorrectionSuggestion(String query) {
    if (query.isEmpty) return null;

    final queryLower = query.toLowerCase();
    String? bestMatch;
    double highestSimilarity = 0.0;
    const double similarityThreshold = 0.1; // Adjust this threshold as needed

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

  // NEW: Centralized method to apply both search and category filters
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

    // Apply search query filter if not empty
    if (query.isNotEmpty) {
      tempFilteredList = tempFilteredList.where((item) {
        return item.searchableText.contains(query);
      }).toList();
    }

    setState(() {
      _filteredNutritionItems = tempFilteredList;
      _suggestedQuery = null; // Clear suggestion initially

      // Only suggest if search query is active and results are empty
      if (query.isNotEmpty && _filteredNutritionItems.isEmpty) {
        _suggestedQuery = _getCorrectionSuggestion(query);
      }

      // Sort results (priority to startsWith, then contains, then alphabetical)
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
    _applyFilters(); // Call the centralized filter method
  }

  void _onCategorySelected(String category) {
    if (_currentCategoryFilter == category) return; // No change, no animation

    setState(() {
      _previousCategoryFilter = _currentCategoryFilter; // Store current as previous
      _currentCategoryFilter = category; // Update current
      _searchController.clear(); // Clear search when category changes
      FocusScope.of(context).unfocus(); // Dismiss keyboard
    });
    _applyFilters(); // Apply the new category filter
  }

  // Helper to build individual list tile UI for filtered search results
  Widget _buildSearchResultItemUI(BuildContext context, SearchableNutritionItem item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector( // Wrap the Card with GestureDetector for onTap
      onTap: () {
        final String descriptionForDetailPage = widget.currentMode == 'fun'
            ? (item.funModeDescription.isNotEmpty ? item.funModeDescription : item.normalModeDescription)
            : item.normalModeDescription;

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
        child: Padding( // Add padding inside the card
          padding: const EdgeInsets.all(16.0),
          child: Column( // Use Column to stack elements vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
            children: [
              // Image/Icon at the top
              if (item.imagePath.isNotEmpty)
                Image.asset(
                  item.imagePath,
                  width: 300, // Increased size for better visibility
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 80, color: colorScheme.onSecondary),
                )
              else
                Icon(Icons.fastfood, size: 80, color: colorScheme.onSecondary), // Default icon

              const SizedBox(height: 12), // Spacing between image and text

              // Title
              Text(
                '${item.name} (${item.parentCategory})',
                style: theme.textTheme.displayLarge?.copyWith(color: colorScheme.onSecondary),
                textAlign: TextAlign.center, // Center align title
              ),
              const SizedBox(height: 4), // Spacing between title and subtitle

              // Subtitle (short description)
              if (item.shortDescription.isNotEmpty)
                Text(
                  item.shortDescription,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.displaySmall?.copyWith(color: colorScheme.onSecondary.withOpacity(0.7)),
                  textAlign: TextAlign.center, // Center align short description
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

    // Determine the starting offset for the slide animation based on category change
    Offset beginOffset;
    Offset endOffsetOldChild; // New: Offset for the old child to slide out to

    int newIndex = _nutritionCategoriesWithIcons.indexWhere((map) => map['name'] == _currentCategoryFilter);
    int oldIndex = _nutritionCategoriesWithIcons.indexWhere((map) => map['name'] == _previousCategoryFilter);

    if (oldIndex == -1 || newIndex == -1 || newIndex == oldIndex) {
      // No valid old index, or no actual change in category position, or initial load
      beginOffset = Offset.zero; // No slide, or fade in from center
      endOffsetOldChild = Offset.zero; // Old child stays in place and fades
    } else if (newIndex > oldIndex) {
      // Moving right (e.g., Fruits to Vegetables)
      beginOffset = const Offset(1.0, 0.0); // New child slides in from right
      endOffsetOldChild = const Offset(-1.0, 0.0); // Old child slides out to left
    } else {
      // Moving left (e.g., Vegetables to Fruits)
      beginOffset = const Offset(-1.0, 0.0); // New child slides in from left
      endOffsetOldChild = const Offset(1.0, 0.0); // Old child slides out to right
    }


    return Column(
      children: [
        // The Search Bar for Nutrition Tab
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
        // "Did you mean?" suggestion
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
                    _onSearchChanged(); // Re-run search with the suggested query
                    FocusScope.of(context).unfocus(); // Dismiss keyboard
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
        // NEW: Category Icons Row
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
        const Divider(height: 20, thickness: 1), // Separator

        // Main List of Nutrition Items (filtered by search or category)
        Expanded(
          child: AnimatedSwitcher( // Added AnimatedSwitcher for transition
            duration: const Duration(milliseconds: 300), // Duration of the animation
            transitionBuilder: (Widget child, Animation<double> animation) {
              return Stack( // Use a Stack to overlay the old and new child during transition
                children: [
                  // Old child (slides out)
                  if (animation.status == AnimationStatus.forward && child.key != null && child.key is ValueKey && (child.key as ValueKey).value == (_currentCategoryFilter + _searchController.text))
                  // This condition ensures oldChild is only shown when the new child is animating in
                    Positioned.fill(
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset.zero, // Start at current position
                          end: endOffsetOldChild, // Slide out to the determined direction
                        ).animate(animation),
                        child: FadeTransition(
                          opacity: Tween<double>(begin: 1.0, end: 0.0).animate(animation),
                          child: child, // This is the old child, passed implicitly
                        ),
                      ),
                    ),
                  // New child (slides in)
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
            child: _filteredNutritionItems.isEmpty && _searchController.text.isNotEmpty && _suggestedQuery == null
                ? Center(
              key: ValueKey('no_results_${_currentCategoryFilter}_${_searchController.text}'), // Unique key for AnimatedSwitcher
              child: Text(
                'No results found for "${_searchController.text}" in "$_currentCategoryFilter"',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: colorScheme.onBackground.withOpacity(0.7)),
              ),
            )
                : ListView.builder(
              key: ValueKey(_currentCategoryFilter + _searchController.text), // Unique key for AnimatedSwitcher
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
