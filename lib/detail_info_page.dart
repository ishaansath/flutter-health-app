// detail_info_page.dart
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'item_detail_page.dart';

class DetailInfoPage extends StatelessWidget {
  final String title;
  final String mode;
  final String image;
  final Color color;
  final String organ;
  final String? info;
  final List<Map<String, dynamic>>? items;

  const DetailInfoPage({
    super.key,
    this.info,
    required this.mode,
    required this.image,
    required this.color,
    required this.organ,
    required this.title,
    this.items,
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
              if (info != null && info!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface, // Use theme's surface color
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
                      height: 500.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      enableInfiniteScroll: false,
                      autoPlayInterval: const Duration(seconds: 10),
                      viewportFraction: 0.8,
                    ),
                    items: items!.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          // Check for modelPath before displaying ModelView
                          final String? modelPath = item['modelPath'];
                          return GestureDetector(
                            onTap: () {
                              // Extract all necessary individual pieces of data from the current item
                              final String itemName = item['name'] as String? ?? item['title'] as String? ?? 'Item Name';
                              final String itemModelPath = item['modelPath'] as String? ?? '';
                              final String itemImagePath = item['image'] as String? ?? '';

                              // Pass BOTH normal and fun descriptions, and let ItemDetailPage handle the display
                              final String normalDescription = item['normalModeDescription'] as String? ?? item['description'] as String? ?? 'No description available.';
                              final String funDescription = item['funModeDescription'] as String? ?? normalDescription;

                              // Get the audio paths (can be null if not defined for an item)
                              final String? normalAudioPath = item['normalModeAudioPath'] as String?;
                              final String? funAudioPath = item['funModeAudioPath'] as String?;


                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItemDetailPage(
                                    name: itemName,
                                    modelPath: itemModelPath,
                                    image: itemImagePath,
                                    // Pass all required parameters, ensuring they match ItemDetailPage's constructor
                                    description: mode == 'fun' ? funDescription : normalDescription, // Pass the already chosen description
                                    additionalInfo: item['additionalInfo'] as String? ?? '',
                                    additionalInfoExtra: item['additionalInfoExtra'] as String? ?? '', // Pass the already chosen extra info
                                    normalModeAudioPath: normalAudioPath, // <--- Pass the normal audio path
                                    funModeAudioPath: funAudioPath,       // <--- Pass the fun audio path
                                    mode: mode, // <--- Pass the current mode string ('normal' or 'fun')
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 8.0),
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
                                  if (modelPath != null &&
                                      modelPath.isNotEmpty) // Conditionally show model
                                    SizedBox(
                                      height: 250,
                                      child: ModelView(
                                        modelPath: modelPath,
                                      ),
                                    )
                                  else if (item['image'] !=
                                      null) // Show image if no model
                                    Container(
                                      height: 225,
                                      width: 225,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: colorScheme.onSurface,
                                          width: 2,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(12),
                                        child: Image.asset(item['image']!,
                                            fit: BoxFit.contain),
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  Text(
                                    item['name']!,
                                    style: theme.textTheme.titleLarge, // Adjusted font size
                                    textAlign: TextAlign.center,
                                  ),
                                  if (item['shortDescription'] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        item['shortDescription']!,
                                        style: theme.textTheme.bodyMedium,
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
                    }).toList(), // Added .toList() here
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

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
      child: ModelViewer(
        src: modelPath,
        alt: "",
        ar: false,
        autoRotate: true,
        cameraControls: true,
        backgroundColor: colorScheme.surface,
      ),
    );
  }
}