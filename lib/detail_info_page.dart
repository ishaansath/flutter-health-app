import 'package:flutter/material.dart';

class DetailInfoPage extends StatelessWidget {
  final String info;
  final String image;
  final String mode;
  final String fruitName;

  // Updated constructor to accept 'image' and 'mode' parameters
  const DetailInfoPage({super.key, required this.info, required this.image, required this.mode});

  @override
  Widget build(BuildContext context) {
    final displayText = mode == 'fun' ? "Yo! Here's a fun fact: $info" : info;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(title: const Text("Detail Info")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Display the image passed
            Image.asset(image, width: 200, height: 200),
            const SizedBox(height: 20),
            Text(displayText, style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
