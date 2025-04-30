import 'package:flutter/material.dart';

class DetailInfoPage extends StatelessWidget {
  final String info;
  final String mode;
  final String image;

  const DetailInfoPage({super.key, required this.info, required this.mode, required this.image});

  @override
  Widget build(BuildContext context) {
    final displayText = mode == 'fun' ? "$info" : info;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(title: const Text("Detail Info")),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Optional: custom close/back button if no AppBar
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Image.asset(image, width: 200, height: 200),
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
