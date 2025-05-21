// more_info_page.dart
import 'package:flutter/material.dart';
import 'detail_info_page.dart';
import 'custom_button_large.dart';
import 'main.dart'; // Import main.dart to access the CustomButtonColors extension

class MoreInfoPage extends StatelessWidget {
  final String organ;
  final String mode; // <--- This is the mode passed from OrganDetailPage
  // This type is now Map<String, Map<String, dynamic>> because the values are now maps
  final Map<String, dynamic> moreInfoData; // Kept as dynamic for flexibility

  const MoreInfoPage({
    super.key,
    required this.organ,
    required this.mode,
    required this.moreInfoData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Color> cycleColors = [
      colorScheme.buttonColor1,
      colorScheme.buttonColor2,
      colorScheme.buttonColor3,
      colorScheme.buttonColor4,
    ];
    int colorIndex = 0;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text('${mode == 'fun' ? 'More ${organ} Info ✨' : 'More ${organ} Info'}'), // Optional: Add emoji to AppBar title
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column( // Column to hold Wrap and SizedBox
          children: [
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: moreInfoData.keys.map((categoryKey) {
                // <--- NEW: Get the category data map (e.g., 'funFacts' map) ---
                final Map<String, dynamic> categoryConfig = moreInfoData[categoryKey] as Map<String, dynamic>;

                // <--- NEW: Determine the button title based on the current mode ---
                final String buttonTitle = mode == 'fun'
                    ? categoryConfig['funModeTitle'] as String? ?? categoryKey // Fallback to key if funModeTitle is missing
                    : categoryConfig['normalModeTitle'] as String? ?? categoryKey; // Fallback to key if normalModeTitle is missing

                // <--- NEW: Get the actual list of items from the 'items' key ---
                final List<Map<String, dynamic>> categoryItems =
                    categoryConfig['items'] as List<Map<String, dynamic>>? ?? [];

                final Color buttonColor = cycleColors[colorIndex % cycleColors.length];
                colorIndex++;

                return CustomButtonLarge(
                  text: buttonTitle, // Use the mode-specific title
                  backgroundColor: buttonColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailInfoPage(
                          title: buttonTitle, // Pass the mode-specific title to DetailInfoPage
                          mode: mode, // Pass the mode along
                          image: '', // Still not used here
                          color: buttonColor,
                          organ: organ,
                          items: categoryItems, // Pass the nested items list
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 150), // Added SizedBox for extra scrolling
          ],
        ),
      ),
    );
  }
}