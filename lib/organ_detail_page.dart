// lib/organ_detail_page.dart

import 'package:flutter/material.dart';
import 'package:ishaan/frosted_glass_button.dart';
import 'detail_info_page.dart'; // Ensure correct import for your project
import 'custom_button.dart'; // Ensure correct import for your project
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'more_info_page.dart'; // Ensure correct import for your project
import 'app_data.dart';
import 'package:ionicons/ionicons.dart';
import 'glassmorphic_button.dart';
import 'frosted_glass_container.dart';

class OrganDetailPage extends StatelessWidget {
  final String organ;
  final String mode;

  const OrganDetailPage({super.key, required this.organ, required this.mode, required String organName, required Map<String, dynamic> organData});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = organData[organ]!;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final GlobalKey _tooltipKey = GlobalKey();

    final organName = organ;
    final briefInfoText = mode == 'fun' ? data['briefInfoFun']! as String : data['briefInfo']! as String;
    final modelPath = data['image']! as String; // Assuming 'image' holds the .glb path
    final Map<String, Map<String, dynamic>>? moreInfoCategories =
    data['moreInfoCategories'] as Map<String, Map<String, dynamic>>?;
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final String backgroundImagePath = isDarkMode
        ? "assets/organdarkbg.png"
        : "assets/organlightbg.png";


    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(organ),
        centerTitle: true,
          actions: [
          Tooltip(
          key: _tooltipKey,
          message: 'Explore the 3D brain model by dragging or zooming in! Tap on the buttons below—Fruits, Veggies, Meat, Nutrients & More—to discover foods that boost brain health, fun facts, and extra info!',
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
          textAlign: TextAlign.left,
          child: IconButton(
            icon: Icon(Ionicons.help_circle_outline),
            color: colorScheme.onSecondary,
            onPressed: () {
              final dynamic tooltip = _tooltipKey.currentState;
              tooltip?.ensureTooltipVisible();
            },
          )
      )
        ]
      ),
      body: Stack( // Use Stack to layer background and content
    children: [
    // Background Image
    Positioned.fill(
    child: Image.asset(
      backgroundImagePath,
      fit: BoxFit.cover,
    ),
    ),SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            spacing: 30,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              if (modelPath.isNotEmpty && modelPath.endsWith('.glb'))
                SizedBox(
                  height: 300,
                  child: ModelView(modelPath: modelPath),
                ),
              FrostedGlassContainer(
                child: Text(
                  briefInfoText,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize:11.5),
                ),
              ),

              FrostedGlassButton(
                text: "Fruits",
              icon: Ionicons.nutrition,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailInfoPage(
                      title: "Fruits",
                      items: data['fruits'] as List<Map<String, dynamic>>? ?? [],
                      color: Colors.red,
                      organ: organName,
                      mode: mode,
                      image: '',
                    ),
                  ),
                ),
              ),
             FrostedGlassButton(
               icon: Ionicons.leaf,
                text: "Vegetables",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailInfoPage(
                      title: "Vegetables",
                      items: data['vegetables'] as List<Map<String, dynamic>>? ?? [],
                      color: Colors.orange,
                      organ: organName,
                      mode: mode,
                      image: '', // Example placeholder
                    ),
                  ),
                ),
              ),
              FrostedGlassButton(
                text: "Meat",
                icon: Icons.egg,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailInfoPage(
                      title: "Meat",
                      items: data['meat'] as List<Map<String, dynamic>>? ?? [], // Changed 'meat' to 'meat'
                      color: Colors.deepPurple,
                      organ: organName,
                      mode: mode,
                      image: '', // Example placeholder
                    ),
                  ),
                ),
              ),
              FrostedGlassButton(
                text: "Nutrients",
                icon: Ionicons.sparkles,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailInfoPage(
                      title: "Nutrients",
                      items: data['nutrients'] as List<Map<String, dynamic>>? ?? [],
                      color: Colors.deepPurple,
                      organ: organName,
                      mode: mode,
                      image: '', // Example placeholder
                    ),
                  ),
                ),
              ),
              if (moreInfoCategories != null && moreInfoCategories.isNotEmpty)
                FrostedGlassButton(
                  text: "More",
                  icon: Ionicons.add,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MoreInfoPage(
                        organ: organName,
                        mode: mode,
                        // Pass the moreInfoCategories map directly to MoreInfoPage
                        moreInfoData: moreInfoCategories,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: double.infinity, height: 150), // Spacer at the bottom
            ],
          ),
        ),
      ),
    ]));
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
        color: Colors.transparent, // Background for the model container
      ),
      child: ModelViewer(
        src: modelPath,
        alt: "Organ model", // Alt text for accessibility
        ar: false, // Augmented Reality mode disabled
        disableTap: true,
        autoRotate: true,   // Model rotates automatically
        cameraControls: true, // Allows user to control camera (zoom, pan, rotate)
        backgroundColor: Colors.transparent, // ModelViewer background also from theme
      ),
    );
  }
}