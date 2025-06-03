// lib/organ_detail_page.dart

import 'package:flutter/material.dart';
import 'detail_info_page.dart'; // Ensure correct import for your project
import 'custom_button.dart'; // Ensure correct import for your project
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'more_info_page.dart'; // Ensure correct import for your project
import 'app_data.dart';
import 'package:ionicons/ionicons.dart';

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


    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
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
      body: SingleChildScrollView(
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
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  briefInfoText,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize:11.5),
                ),
              ),

              CustomButton(
                text: mode == 'fun' ? "Fruits 🍎" : "Fruits",
                backgroundColor: const Color(0xFFF11B26),
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailInfoPage(
                      title: mode == 'fun' ? "Fruits" : "Fruits",
                      items: data['fruits'] as List<Map<String, dynamic>>? ?? [],
                      color: Colors.red,
                      organ: organName,
                      mode: mode,
                      image: '',
                    ),
                  ),
                ),
              ),
              CustomButton(
                backgroundColor: const Color(0xCC53FD1A),
                textColor: Colors.white,
                text: mode == 'fun' ? "Veggies 🥬" : "Vegetables",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailInfoPage(
                      title: mode == 'fun' ? "Vegetables" : "Vegetables",
                      items: data['vegetables'] as List<Map<String, dynamic>>? ?? [],
                      color: Colors.orange,
                      organ: organName,
                      mode: mode,
                      image: '', // Example placeholder
                    ),
                  ),
                ),
              ),
              CustomButton(
                text: mode == 'fun' ? "Meats 🍗" : "Meats",
                backgroundColor: const Color(0xFFFF6F00),
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailInfoPage(
                      title: mode == 'fun' ? "Meats" : "Meats",
                      items: data['meat'] as List<Map<String, dynamic>>? ?? [], // Changed 'meat' to 'meat'
                      color: Colors.deepPurple,
                      organ: organName,
                      mode: mode,
                      image: '', // Example placeholder
                    ),
                  ),
                ),
              ),
              CustomButton(
                text: mode == 'fun' ? "Nutrients 💊" : "Nutrients",
                backgroundColor: const Color(0xFF005FD5),
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailInfoPage(
                      title: mode == 'fun' ? "Nutrients" : "Nutrients",
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
                CustomButton(
                  text: mode == 'fun' ? "More ➕" : "More",
                  backgroundColor: const Color(0xFF93B6EA),
                  textColor: Colors.white,
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
        color: colorScheme.primary, // Background for the model container
        border: Border.all(color: colorScheme.primary, width: 2), // Border color from theme
        borderRadius: BorderRadius.circular(7),
      ),
      child: ModelViewer(
        src: modelPath,
        alt: "Organ model", // Alt text for accessibility
        ar: false, // Augmented Reality mode disabled
        disableTap: true,
        autoRotate: true,   // Model rotates automatically
        cameraControls: true, // Allows user to control camera (zoom, pan, rotate)
        backgroundColor: colorScheme.primary, // ModelViewer background also from theme
      ),
    );
  }
}