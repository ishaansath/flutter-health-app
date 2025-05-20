import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ItemDetailPage extends StatelessWidget {
  final String name;
  final String modelPath;
  final String description;
  final String additionalInfo;
  final String additionalInfoExtra;
  final String image; // Added image path

  const ItemDetailPage({
    super.key,
    required this.name,
    required this.modelPath,
    required this.description,
    required this.additionalInfo,
    required this.image,
    required this.additionalInfoExtra, // Added to the constructor
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text(name, style: theme.textTheme.titleLarge),
        iconTheme: IconThemeData(color: colorScheme.onSecondary),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Wrap the Column with a Center widget
        child: Center( // <--- ADDED THIS CENTER WIDGET
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center, // This is less effective here
            children: [
              // Check if modelPath is available and not empty
              if (modelPath.isNotEmpty)
                SizedBox(
                  height: 300,
                  child: ModelViewer(
                    src: modelPath,
                    alt: '3D model of $name',
                    autoRotate: true,
                    cameraControls: true,
                    backgroundColor: colorScheme.primary,
                  ),
                )
              // If modelPath is not available or empty, display the image
              else if (image.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Image.asset(
                    image,
                    height: 300, // You can adjust the height as needed
                    // and the width
                    fit: BoxFit.contain, // Or any other fit you prefer
                  ),
                )
              else
              //if there is no model and no image.
                const SizedBox(height: 20), // Add some spacing if neither is available

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  // You might still want crossAxisAlignment.center here if you want
                  // the text within this *inner* column to be centered.
                  // For example, if description and additionalInfo are short.
                  crossAxisAlignment: CrossAxisAlignment.center, // Keep this for inner text centering
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // This might pull text left
                        children: [
                          Text(
                            description,
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.left, // This also pulls text left
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      additionalInfoExtra,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

