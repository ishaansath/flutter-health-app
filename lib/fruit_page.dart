import 'package:flutter/material.dart';
import 'custom_button.dart';

class FruitPage extends StatelessWidget {
  final String fruit;
  final String mode;

  const FruitPage({super.key, required this.fruit, required this.mode});

  @override
  Widget build(BuildContext context) {
    final data = {
      "Blueberries": {
        "normal": "Blueberries are packed with antioxidants that boost brain health.",
        "fun": "Cardio game strong, memory built diff, and no sugar spike—straight W",
        "fruitImage": "assets/Blueberries.png", // Add image path for fruit
      },
      "Tomatoes": {
        "normal": "Tomatoes are great for your heart and help prevent heart disease.",
        "fun": "Yo! These tomatoes can keep your heart strong! Wanna check how?",
        "fruitImage": "assets/tomatoes.png", // Add image path for fruit
      },
      // Add other fruits as needed...
    }[fruit]!;

    final text = mode == 'fun' ? data['fun']! : data['normal']!;
    final imagePath = data['fruitImage']!; // Get image path

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(title: Text(fruit)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (imagePath != null)
              Image.asset(imagePath, width: 200, height: 200),
            const SizedBox(height: 20),
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
            CustomButton(
              text: "Back to Organ",
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
