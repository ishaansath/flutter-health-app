// detail_info_page.dart
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'item_detail_page.dart';
import 'package:ionicons/ionicons.dart';

class DetailInfoPage extends StatelessWidget {
  final String title;
  final String mode;
  final String image;
  final Color color;
  final String organ;
  final String? info;
  final String? tooltip;
  final List<Map<String, dynamic>>? items;
  final GlobalKey _tooltipKey = GlobalKey();

  DetailInfoPage({
    super.key,
    this.info,
    required this.mode,
    required this.image,
    required this.color,
    required this.organ,
    required this.title,
    this.items, this.tooltip,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary, // Set Scaffold background color from theme
      appBar: AppBar(
        title: Text(title), // AppBar title, automatically styled by AppBarTheme in main.dart
        centerTitle: true,
        actions: [
        Tooltip(
          key: _tooltipKey,
        message: 'Swipe left or right to explore the cards. Tap on any card to see detailed info about that food item!',
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
        textAlign: TextAlign.justify,
        child: IconButton(
          icon: Icon(Ionicons.help_circle_outline),
          color: colorScheme.onSecondary,
          onPressed: () {
            final dynamic tooltip = _tooltipKey.currentState;
          tooltip?.ensureTooltipVisible();
          },
        )
        )
        ],
        // AppBar's transparency, font, and icon colors are governed by main.dart's AppBarTheme
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (image.isNotEmpty)
                image.toLowerCase().endsWith('.gif')
                    ? SizedBox(
                  width: 200,
                  height: 200,
                  child: GifView.asset(
                    image,
                    loop: true,
                  ),
                )
                    : Image.asset(image, width: 200, height: 200),
              if (info != null && info!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surface, // Use theme's surface color for container background
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      info!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface, // Text color on this surface
                      ),
                    ),
                  ),
                ),
              if (items != null && items!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      height: 500.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      enableInfiniteScroll: false,
                      autoPlayInterval: const Duration(seconds: 10),
                      viewportFraction: 0.775
                    ),
                    items: items!.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          final String? modelPath = item['modelPath']; // Still extract, but not for display here.
                          return GestureDetector(
                            onTap: () {
                              final String itemName = item['name'] as String? ?? item['title'] as String? ?? 'Item Name';
                              final String itemModelPath = item['modelPath'] as String? ?? '';
                              final String itemImagePath = item['image'] as String? ?? '';

                              final String normalDescription = item['normalModeDescription'] as String? ?? item['description'] as String? ?? 'No description available.';
                              final String funDescription = item['funModeDescription'] as String? ?? normalDescription;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItemDetailPage(
                                    name: itemName,
                                    modelPath: itemModelPath,
                                    image: itemImagePath,
                                    description: mode == 'fun' ? funDescription : normalDescription,
                                    additionalInfo: item['additionalInfo'] as String? ?? '',
                                    additionalInfoExtra: item['additionalInfoExtra'] as String? ?? '',
                                    mode: mode,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8.0),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: colorScheme.onSurface, width: 3),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // --- SIMPLIFIED IMAGE DISPLAY ---
                                  // Just show the image, no extra decorations, ClipRRect, or errorBuilder.
                                  // It's assumed item['image'] will always be valid for simplicity as requested.
                                  if (item['image'] != null && item['image']!.isNotEmpty)
                                    Image.asset(
                                      item['image']!,
                                      height: 250, // Height for the image
                                      width: 250,
                                      fit: BoxFit.contain,
                                    ),
                                  // --- END OF SIMPLIFIED IMAGE DISPLAY ---
                                  const SizedBox(height: 10),
                                  Text(
                                    item['name']!,
                                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (item['shortDescription'] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        item['shortDescription']!,
                                        style: theme.textTheme.bodyMedium?.copyWith(fontSize:10),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  if (item['additionalInfo'] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        item['additionalInfo']!,
                                        style: theme.textTheme.bodySmall,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Keep ModelView class here if it's used elsewhere, otherwise remove it too.
// If it's *only* used for ModelViewerPlus, and you've removed all calls to it,
// you can delete this class definition entirely.
class ModelView extends StatelessWidget {
  final String modelPath;

  const ModelView({super.key, required this.modelPath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.onSurface, width: 2),
        borderRadius: BorderRadius.circular(7),
      ),
      // This ModelViewer here will only be rendered if ModelView is explicitly called.
      // Since we removed its call from the carousel, it won't be used for the carousel items.
      // If you're not using ModelView anywhere else, you can remove this class.
      // The `ModelViewerPlus` import at the top can also be removed if not used.
      // child: ModelViewer(
      //   src: modelPath,
      //   alt: "",
      //   ar: false,
      //   autoRotate: true,
      //   cameraControls: true,
      //   backgroundColor: colorScheme.surface,
      // ),
      child: Center(child: Text("Model view disabled for performance.")), // Placeholder if ModelView is somehow called
    );
  }
}