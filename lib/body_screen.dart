// lib/body_screen.dart (UPDATED)

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'organ_detail_page.dart';
import 'package:ishaan/app_data.dart'; // Keep this as is
import 'package:ishaan/item_detail_page.dart'; // Keep this as is for ItemDetailPage
import 'package:ishaan/nutrition_item_model.dart'; // Import your custom NutritionItem class

class BodyScreen extends StatefulWidget {
  final String mode; // Initial mode received from main.dart
  final ValueNotifier<ThemeMode> themeModeNotifier; // Theme notifier received from main.dart

  const BodyScreen({
    super.key,
    required this.mode,
    required this.themeModeNotifier,
  });

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> with SingleTickerProviderStateMixin {
  late String _currentMode; // Internal state for the current interaction mode ('normal'/'fun')
  late TabController _tabController; // Declare TabController

  // Define your top-level tabs
  final List<String> _topTabs = ['Body', 'Nutrition'];

  // Define your nutrition subcategories, make sure these keys match those in generalNutritionData
  // These should match the top-level keys in generalNutritionData map
  final List<String> _nutritionSubcategories = [
    'Fruits',
    'Vegetables',
    'Nutrients',
    'Dairy',
    'Meat Products', // Corrected from 'Meat'
    'Cereals & Grains', // Corrected from 'Grains & Cereals'
    'Protein', // Corrected from 'Protein Foods'
  ];

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode; // Initialize internal mode from the widget's constructor parameter
    widget.themeModeNotifier.addListener(_updateThemeIcon); // Listen for theme changes

    // Initialize TabController
    _tabController = TabController(length: _topTabs.length, vsync: this);
  }

  @override
  void dispose() {
    widget.themeModeNotifier.removeListener(_updateThemeIcon); // Stop listening
    _tabController.dispose(); // Dispose TabController
    super.dispose();
  }

  void _updateThemeIcon() {
    if (mounted) {
      setState(() {
        // Force a rebuild for the theme icon when theme changes.
      });
    }
  }

  void _toggleTheme() {
    // Toggle the theme via the ValueNotifier provided by main.dart
    widget.themeModeNotifier.value =
    widget.themeModeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  void _toggleMode() {
    // Toggle the internal interaction mode
    setState(() {
      _currentMode = _currentMode == 'normal' ? 'fun' : 'normal';
    });
  }

  // --- Helper to get NutritionItems for Carousel from app_data.dart ---
  // This now expects the new generalNutritionData structure
  List<NutritionItem> _getNutritionItemsForCategory(String category) {
    // Access the 'items' list within the category map
    final List<Map<String, dynamic>>? itemsDataRaw = generalNutritionData[category]?['items']
        ?.cast<Map<String, dynamic>>();

    if (itemsDataRaw == null) {
      return []; // Return empty list if category or 'items' list not found
    }

    return itemsDataRaw
        .map((itemMap) => NutritionItem.fromMap(itemMap))
        .toList();
  }

  // --- Helper to build individual carousel item UI for the Nutrition tab ---
  // This now takes your custom 'NutritionItem' object
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
              height: 100, // Adjust image size as needed
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
              // Now, extract data from the 'NutritionItem' object and map to ItemDetailPage's parameters
              final String descriptionForDetailPage = _currentMode == 'fun'
                  ? (item.funModeDescription.isNotEmpty ? item.funModeDescription : item.normalModeDescription)
                  : item.normalModeDescription;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailPage(
                    name: item.name,
                    modelPath: item.modelPath, // Will be empty string if not provided in app_data
                    description: descriptionForDetailPage,
                    additionalInfo: item.additionalInfo, // Will be empty string if not provided in app_data
                    image: item.image,
                    additionalInfoExtra: item.additionalInfoExtra, // Will be empty string if not provided in app_data
                    mode: _currentMode, // Pass current mode
                  ),
                ),
              );
            },
            child: Text('View Details', style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const TextStyle emojiStyle = TextStyle(fontSize: 20);

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Consistent transparent app bar
        elevation: 0, // No shadow
        automaticallyImplyLeading: false,
        // --- TabBar in the AppBar's bottom property ---
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.onPrimary, // Color of selected tab label
          unselectedLabelColor: colorScheme.onPrimary.withOpacity(0.7), // Color of unselected tab labels
          indicatorColor: colorScheme.secondary, // Color of the underline indicator
          tabs: _topTabs.map((tabName) => Tab(text: tabName)).toList(),
        ),
      ),
      body: TabBarView( // TabBarView now takes up the entire body
        controller: _tabController,
        children: [
          // --- Tab 1: Body Outline Content (Your existing Stack) ---
          Stack( // This is the original Stack for the body outline, emojis, and buttons
            children: [
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final height = constraints.maxHeight;
                      // Adjusted width calculation for better proportion
                      final width = height * 0.55; // Roughly 1:1.8 ratio for typical body outline

                      return Center(
                        child: SizedBox(
                          height: height,
                          width: width,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset('assets/body_outline.png', fit: BoxFit.contain),
                              // Brain
                              Positioned(
                                top: height * 0.19,
                                left: width * 0.3655,
                                child: GestureDetector(
                                  onTap: () => showOrganDialog(context, "Brain"),
                                  child: const Text("🧠", style: emojiStyle),
                                ),
                              ),
                              // Eyes
                              Positioned(
                                top: height * 0.22,
                                left: width * 0.3655,
                                child: GestureDetector(
                                  onTap: () => showOrganDialog(context, "Eyes"),
                                  child: const Text("👁️", style: emojiStyle),
                                ),
                              ),
                              // Heart
                              Positioned(
                                top: height * 0.32,
                                left: width * 0.42,
                                child: GestureDetector(
                                  onTap: () => showOrganDialog(context, "Heart"),
                                  child: const Text("❤️", style: emojiStyle),
                                ),
                              ),
                              // Lungs
                              Positioned(
                                top: height * 0.35,
                                left: width * 0.3655,
                                child: GestureDetector(
                                  onTap: () => showOrganDialog(context, "Lungs"),
                                  child: const Text("🫁", style: emojiStyle),
                                ),
                              ),
                              // Muscles
                              Positioned(
                                top: height * 0.39,
                                left: width * 0.23,
                                child: GestureDetector(
                                  onTap: () => showOrganDialog(context, "Muscles"),
                                  child: const Text("💪", style: emojiStyle),
                                ),
                              ),
                              // Stomach
                              Positioned(
                                top: height * 0.43,
                                left: width * 0.3655,
                                child: GestureDetector(
                                  onTap: () => showOrganDialog(context, "Stomach"),
                                  child: const Text("🍽️", style: emojiStyle),
                                ),
                              ),
                              // Legs
                              Positioned(
                                top: height * 0.62,
                                left: width * 0.30,
                                child: GestureDetector(
                                  onTap: () => showOrganDialog(context, "Legs"),
                                  child: const Text("🦵", style: emojiStyle),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // --- Theme Toggle Button (Bottom Left) ---
              Positioned(
                bottom: 20,
                left: 20,
                child: FloatingActionButton(
                  heroTag: 'theme_toggle', // Unique tag for multiple FABs
                  onPressed: _toggleTheme, // Calls BodyScreen's own toggle
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  child: Icon(widget.themeModeNotifier.value == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
                ),
              ),

              // --- Mode Toggle Switch (Bottom Right) ---
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: _toggleMode, // Calls BodyScreen's own toggle
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentMode == 'normal' ? 'Normal' : 'Fun',
                          style: theme.textTheme.labelLarge,
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: _currentMode == 'fun',
                          onChanged: (newValue) => _toggleMode(), // Calls BodyScreen's own toggle
                          activeColor: colorScheme.secondary,
                          inactiveThumbColor: colorScheme.secondary,
                          inactiveTrackColor: colorScheme.onSurface.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // --- Tab 2: Nutrition Content ---
          SingleChildScrollView( // Make the nutrition content scrollable
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: _nutritionSubcategories.map((category) {
                // Fetch the list of NutritionItem objects for the current category
                final List<NutritionItem> items = _getNutritionItemsForCategory(category);

                // Get category titles based on mode
                final String categoryTitle = _currentMode == 'fun'
                    ? (generalNutritionData[category]?['funModeTitle'] as String? ?? category)
                    : (generalNutritionData[category]?['normalModeTitle'] as String? ?? category);


                // Only build the category section if there are items
                if (items.isEmpty) {
                  return const SizedBox.shrink(); // Hide if no items
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryTitle, // Use the mode-dependent title
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 250.0, // Height of the carousel
                          enlargeCenterPage: false,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          viewportFraction: 0.6, // How much of the item is visible
                        ),
                        items: items.map((item) => _buildNutritionCarouselItemUI(context, item)).toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void showOrganDialog(BuildContext context, String organ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String dialogContent;
    // Get organ info from app_data.dart
    final Map<String, dynamic>? organInfo = organData[organ]?.cast<String, dynamic>();

    if (organInfo != null) {
      if (_currentMode == 'fun') {
        dialogContent =  "Wanna learn more about $organ?";
      } else {
        dialogContent =  "Would you like to learn more about the $organ?";
      }
    } else {
      // Fallback if organ data is not found
      dialogContent = "No information available for $organ yet.";
    }


    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text(
          organ,
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          dialogContent,
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "No",
              style: TextStyle(color: colorScheme.error),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrganDetailPage(
                    organ: organ,
                    mode: _currentMode, // Pass the current mode to OrganDetailPage
                  ),
                ),
              );
            },
            child: Text(
              "Yes",
              style: TextStyle(color: colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
}