import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart'; // Import the gif_view package

class DetailInfoPage extends StatelessWidget {
  final String info;
  final String mode;
  final String image;
  final MaterialColor color; // Keep the color parameter

  const DetailInfoPage({
    super.key,
    required this.info,
    required this.mode,
    required this.image,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = mode == 'fun' ? "$info" : info;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(title: const Text("Detail Info"), backgroundColor: color), // Use the passed color
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Conditional rendering for GIF or static image
                image.toLowerCase().endsWith('.gif')
                    ? SizedBox(
                  width: 200,
                  height: 200,
                  child: GifView.asset(
                    image,
                    loop: true, // You can adjust the loop property
                  ),
                )
                    : Image.asset(image, width: 200, height: 200),
                const SizedBox(height: 20),
                Text(
                  displayText,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}