// more_info_page.dart
import 'package:flutter/material.dart';
import 'package:ishaan/main.dart';
import 'detail_info_page.dart';
import 'custom_button_large.dart'; // Ensure you're importing CustomButtonLarge

class MoreInfoPage extends StatelessWidget {
  final String organ;
  final String mode;
  // This now expects a Map where values are also Maps (containing 'buttonColor' and 'items')
  final Map<String, Map<String, dynamic>> moreInfoData;

  const MoreInfoPage({
    super.key,
    required this.organ,
    required this.mode,
    required this.moreInfoData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme; // Access the color scheme

    // --- NEW: Define the list of colors to cycle through ---
    final List<Color> cycleColors = [
      colorScheme.buttonColor1, // Access your custom colors via the extension
      colorScheme.buttonColor2,
      colorScheme.buttonColor3,
      colorScheme.buttonColor4,
    ];
    int colorIndex = 0; // Initialize an index to cycle through the colors

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        title: Text('${mode == 'fun' ? 'More ${organ} Info' : 'More ${organ} Info'}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: moreInfoData.keys.map((categoryKey) {
            // Get the specific category's data map (e.g., {'buttonColor': ..., 'items': [...]})
            final Map<String, dynamic> categoryDetails = moreInfoData[categoryKey]!;
            final Color buttonColor = cycleColors[colorIndex % cycleColors.length];
            colorIndex++; // Increment for the next button


            // Extract the buttonColor. Default to a fallback if not found.

            // Extract the list of items for this category
            final List<Map<String, dynamic>> categoryItems =
                categoryDetails['items'] as List<Map<String, dynamic>>? ?? [];

            // Format the category key into a readable title
            String categoryTitle = categoryKey.replaceAllMapped(
              RegExp(r'([A-Z])'),
                  (match) => ' ${match.group(0)}',
            ).trim();
            categoryTitle =
                categoryTitle[0].toUpperCase() + categoryTitle.substring(1);

            return CustomButtonLarge(
              text: categoryTitle,
              backgroundColor: buttonColor, // --- USES THE DYNAMIC COLOR ---
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailInfoPage(
                      title: categoryTitle,
                      mode: mode,
                      image: '',
                      color: buttonColor, // Pass the dynamic color to DetailInfoPage
                      organ: organ,
                      items: categoryItems, // Pass the extracted items
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
    const SizedBox(height: 100, width: double.infinity),
  ]),
    ),
    );
  }
}