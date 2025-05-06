import 'package:flutter/material.dart';
import 'body_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void showModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Select Interaction Mode", style: TextStyle(color: Colors.white)),
        content: const Text("Choose how you want to explore!", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const BodyScreen(mode: 'normal')));
            },
            child: const Text("Normal Mode", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const BodyScreen(mode: 'fun')));
            },
            child: const Text("Fun Mode", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/body_outline.png', height: 500, fit: BoxFit.fitHeight),
            Positioned(
              top: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => showModeDialog(context),
                child: const Text("Let's Health"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
