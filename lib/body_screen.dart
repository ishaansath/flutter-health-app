import 'package:flutter/material.dart';
import 'organ_detail_page.dart';

class BodyScreen extends StatelessWidget {
  final String mode;

  const BodyScreen({super.key, required this.mode});

  void showOrganDialog(BuildContext context, String organ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(organ, style: const TextStyle(color: Colors.white, fontSize: 24)),
        content: const Text("Would you like to learn more?", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            child: const Text("No", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Yes", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OrganDetailPage(organ: organ, mode: mode)),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const emojiStyle = TextStyle(fontSize: 30);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SizedBox(
          width: 2000,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Image.asset('assets/body_outline.png', fit: BoxFit.contain),
              Positioned(top: 18, right: 187, child: GestureDetector(onTap: () => showOrganDialog(context, "Brain 🧠"), child: const Text("🧠", style: emojiStyle))),
              Positioned(top: 50, right: 187, child: GestureDetector(onTap: () => showOrganDialog(context, "Eyes 👁"), child: const Text("👁", style: emojiStyle))),
              Positioned(top: 145, right: 160, child: GestureDetector(onTap: () => showOrganDialog(context, "Heart ❤"), child: const Text("❤", style: emojiStyle))),
              Positioned(top: 180, right: 187, child: GestureDetector(onTap: () => showOrganDialog(context, "Lungs 🫁"), child: const Text("🫁", style: emojiStyle))),
              Positioned(top: 200, left: 120, child: GestureDetector(onTap: () => showOrganDialog(context, "Muscles 💪"), child: const Text("💪", style: emojiStyle))),
              Positioned(top: 240, right: 187, child: GestureDetector(onTap: () => showOrganDialog(context, "Stomach 🍽"), child: const Text("🍽", style: emojiStyle))),
              Positioned(bottom: 150, left: 150, child: GestureDetector(onTap: () => showOrganDialog(context, "Legs 🦵"), child: const Text("🦵", style: emojiStyle))),
            ],
          ),
        ),
      ),
    );
  }
}
