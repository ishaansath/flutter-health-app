// lib/nutrition_tab_content.dart (FIXED: _getNutritionItemsForCategory definition)

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ishaan/app_data.dart' as AppData; // Alias for clarity and to avoid conflict
import 'package:ishaan/item_detail_page.dart';
import 'package:ishaan/nutrition_item_model.dart';
import 'package:ishaan/searchable_nutrition_items.dart';

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

  final List<String> _nutritionSubcategories = [
    'Fruits',
    'Vegetables',
    'Nutrients',
    'Dairy',
    'Meat Products',
    'Cereals & Grains',
    'Protein',
  ];

  @override
  void initState() {
    super.initState();
    _loadGeneralNutritionDataAndFlatten();
    _searchController.addListener(_onSearchChanged);
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
    _filteredNutritionItems = List.from(_allGeneralNutritionItems);
    print("Loaded ${_allGeneralNutritionItems.length} general nutrition items.");
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredNutritionItems = List.from(_allGeneralNutritionItems);
      } else {
        _filteredNutritionItems = _allGeneralNutritionItems.where((item) {
          return item.searchableText.contains(query);
        }).toList();

        _filteredNutritionItems.sort((a, b) {
          final aSearchText = a.searchableText;
          final bSearchText = b.searchableText;

          if (a.name.toLowerCase().startsWith(query) && !b.name.toLowerCase().startsWith(query)) return -1;
          if (!a.name.toLowerCase().startsWith(query) && b.name.toLowerCase().startsWith(query)) return 1;

          if (a.shortDescription.toLowerCase().contains(query) && !b.shortDescription.toLowerCase().contains(query)) return -1;
          if (!a.shortDescription.toLowerCase().contains(query) && b.shortDescription.toLowerCase().contains(query)) return 1;

          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      }
    });
  }

  // --- Helper to get NutritionItems for Carousel from app_data.dart ---
  // THIS METHOD IS NOW CORRECTLY DEFINED AND USES AppData.generalNutritionData
  List<NutritionItem> _getNutritionItemsForCategory(String category) {
    // Access the 'items' list within the category map from AppData
    final List<Map<String, dynamic>>? itemsDataRaw = AppData.generalNutritionData[category]?['items']
        ?.cast<Map<String, dynamic>>();

    if (itemsDataRaw == null) {
      return []; // Return empty list if category or 'items' list not found
    }

    return itemsDataRaw
        .map((itemMap) => NutritionItem.fromMap(itemMap))
        .toList();
  }


  // Helper to build individual carousel item UI for the Nutrition tab
  Widget _buildNutritionCarouselItemUI(BuildContext context, NutritionItem item) {
    final theme = Theme.of(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (item.image.isNotEmpty)
            Image.asset(
              item.image,
              height: 100,
              width: 100,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 100);
              },
            ),
          const SizedBox(height: 10),
          Text(
            item.name,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () {
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
                    image: item.image,
                    additionalInfoExtra: item.additionalInfoExtra,
                    mode: widget.currentMode,
                  ),
                ),
              );
            },
            child: Text(
              'View Details',
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build individual list tile UI for filtered search results
  Widget _buildSearchResultItemUI(BuildContext context, SearchableNutritionItem item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: colorScheme.surface,
      child: ListTile(
        leading: item.imagePath.isNotEmpty
            ? Image.asset(
          item.imagePath,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, color: colorScheme.onSecondary),
        )
            : const Icon(Icons.fastfood, size: 60),
        title: Text(
          '${item.name} (${item.parentCategory})',
          style: theme.textTheme.displayLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.shortDescription.isNotEmpty)
              Text(
                item.shortDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.displaySmall
              ),
            Text(
              widget.currentMode == 'fun' ? item.funModeDescription : item.normalModeDescription,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineMedium),

          ],
        ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // The Search Bar for Nutrition Tab
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search nutrition items...',
              hintStyle: theme.textTheme.bodyLarge,
              prefixIcon: Icon(Icons.search, color: colorScheme.secondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear, color: colorScheme.onSecondary),
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
        Expanded(
          child: _searchController.text.isNotEmpty
              ? (_filteredNutritionItems.isEmpty
              ? Center(
            child: Text(
              'No results found for "${_searchController.text}"',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface.withOpacity(0.7)),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _filteredNutritionItems.length,
            itemBuilder: (context, index) {
              return _buildSearchResultItemUI(context, _filteredNutritionItems[index]);
            },
          ))
              : SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: _nutritionSubcategories.map((category) {
                final List<NutritionItem> items = _getNutritionItemsForCategory(category); // Line 321
                final String categoryTitle = widget.currentMode == 'fun'
                    ? (AppData.generalNutritionData[category]?['funModeTitle'] as String? ?? category)
                    : (AppData.generalNutritionData[category]?['normalModeTitle'] as String? ?? category);

                if (items.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 250.0,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          viewportFraction: 0.6,
                        ),
                        items: items.map((item) => _buildNutritionCarouselItemUI(context, item)).toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}