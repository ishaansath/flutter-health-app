import 'package:flutter/material.dart';
import 'custom_button.dart';

class FruitPage extends StatelessWidget {
  final String fruit;
  final String mode;

  const FruitPage({super.key, required this.fruit, required this.mode});

  @override
  Widget build(BuildContext context) {
    final data = {}[fruit]!;

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
