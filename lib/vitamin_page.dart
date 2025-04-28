import 'package:flutter/material.dart';

class VitaminPage extends StatelessWidget {
  final String vitamin;

  const VitaminPage({super.key, required this.vitamin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(title: const Text("Vitamin Info")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text("This vitamin is great for: $vitamin", style: const TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    );
  }
}
