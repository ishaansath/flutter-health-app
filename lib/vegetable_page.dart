import 'package:flutter/material.dart';

class VegetablePage extends StatelessWidget {
  const VegetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vegetables")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Here are some vegetables!',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to home
              },
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
