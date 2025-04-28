import 'package:flutter/material.dart';

class FunFactPage extends StatelessWidget {
  const FunFactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fun Facts")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Here are some fun facts!',
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
