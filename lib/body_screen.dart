import 'package:flutter/material.dart';
import 'organ_detail_page.dart';

class BodyScreen extends StatelessWidget {
  final String mode;

  const BodyScreen({super.key, required this.mode});

  void showOrganDialog(BuildContext context, String organ) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            backgroundColor: Colors.black,
            title: Text(organ,
                style: const TextStyle(color: Colors.white, fontSize: 24)),
            content: const Text("Would you like to learn more?",
                style: TextStyle(color: Colors.white)),
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
                    MaterialPageRoute(builder: (_) =>
                        OrganDetailPage(organ: organ, mode: mode)),
                  );
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const emojiStyle = TextStyle(fontSize: 20);

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center( // Ensures the content is centered on the screen
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery
                .of(context)
                .size
                .height * 0.8,
            maxWidth: MediaQuery
                .of(context)
                .size
                .width * 0.8, // slight margin for centering
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final width = height / 2.2;

              return Center( // This helps double-center the Stack
                child: SizedBox(
                  height: height,
                  width: width,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                          'assets/body_outline.png', fit: BoxFit.contain),
                      // Brain
                      Positioned(
                        top: height * 0.1999,
                        left: width * 0.45,
                        child: GestureDetector(
                          onTap: () => showOrganDialog(context, "Brain"),
                          child: const Text("🧠", style: emojiStyle),
                        ),
                      ),
                      // Eyes
                      Positioned(
                        top: height * 0.23,
                        left: width * 0.45,
                        child: GestureDetector(
                          onTap: () => showOrganDialog(context, "Eyes"),
                          child: const Text("👁", style: emojiStyle),
                        ),
                      ),
                      // Heart
                      Positioned(
                        top: height * 0.31,
                        left: width * 0.5,
                        child: GestureDetector(
                          onTap: () => showOrganDialog(context, "Heart"),
                          child: const Text("❤", style: emojiStyle),
                        ),
                      ),
                      // Lungs
                      Positioned(
                        top: height * 0.35,
                        left: width * 0.45,
                        child: GestureDetector(
                          onTap: () => showOrganDialog(context, "Lungs"),
                          child: const Text("🫁", style: emojiStyle),
                        ),
                      ),
                      // Muscles
                      Positioned(
                        top: height * 0.39,
                        left: width * 0.28,
                        child: GestureDetector(
                          onTap: () => showOrganDialog(context, "Muscles"),
                          child: const Text("💪", style: emojiStyle),
                        ),
                      ),
                      // Stomach
                      Positioned(
                        top: height * 0.43,
                        left: width * 0.45,
                        child: GestureDetector(
                          onTap: () => showOrganDialog(context, "Stomach"),
                          child: const Text("🍽", style: emojiStyle),
                        ),
                      ),
                      // Legs
                      Positioned(
                        top: height * 0.62,
                        left: width * 0.37,
                        child: GestureDetector(
                          onTap: () => showOrganDialog(context, "Legs"),
                          child: const Text("🦵", style: emojiStyle),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }}