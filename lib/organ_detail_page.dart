import 'package:flutter/material.dart';
import 'detail_info_page.dart';
import 'vitamin_page.dart';
import 'custom_button.dart';

class OrganDetailPage extends StatelessWidget {
  final String organ;
  final String mode;

  const OrganDetailPage({super.key, required this.organ, required this.mode });

  @override
  Widget build(BuildContext context) {
    final data = {
      "Brain 🧠": {
        "image": "assets/brain.png",
        "fruit": "Blueberries",
        "vegetable": "Spinach",
        "vitamin": "K",
        "funFact": "The brain contains about 86 billion neurons!",
        "briefInfo": "The brain is your body's control center.",
        "briefInfoFun": "The control tower, sparking thoughts, moves, and genius ideas",
      },
      "Heart ❤": {
        "image": "assets/heart.png",
        "fruit": "Tomatoes",
        "vegetable": "Beetroot",
        "vitamin": "C",
        "funFact": "It pumps about 2,000 gallons of blood daily!",
        "briefInfo": "The heart pumps oxygen-rich blood through the body.",
        "briefInfoFun": "The life engine—pumping nonstop fuel 24/7.",
      },
      "Eyes 👁": {
        "image": "assets/eyes.png",
        "fruit": "Oranges",
        "vegetable": "Carrots",
        "vitamin": "A",
        "funFact": "Carrots don't actually give you night vision — but they do help your eyes!",
        "briefInfo": "Your eyes help you see the world around you.",
        "briefInfoFun": "Eyes = light-catchers that see, focus, and keep you in the picture.",
      },
      "Lungs 🫁": {
        "image": "assets/lungs.png",
        "fruit": "Apples",
        "vegetable": "Broccoli",
        "vitamin": "E",
        "funFact": "You breathe around 20,000 times a day!",
        "briefInfo": "Lungs help you breathe in oxygen and breathe out carbon dioxide.",
        "briefInfoFun": "Lungs = oxygen in, CO2 out—airflow GOATs keeping you alive.",
      },
      "Muscles 💪": {
        "image": "assets/muscle.png",
        "fruit": "Bananas",
        "vegetable": "Kale",
        "vitamin": "D",
        "funFact": "You have over 600 muscles in your body!",
        "briefInfo": "Muscles help you move and stay strong.",
        "briefInfoFun": "Muscles move, flex, and power your body like champs.",
      },
      "Stomach 🍽": {
        "image": "assets/stomach.png",
        "fruit": "Papaya",
        "vegetable": "Cabbage",
        "vitamin": "B",
        "funFact": "Your stomach uses acid strong enough to melt metal!",
        "briefInfo": "The stomach breaks down food to get nutrients.",
        "briefInfoFun": "Stomach melts food, fuels you, and keeps vibes chill.",
      },
      "Legs 🦵": {
        "image": "assets/legs.png",
        "fruit": "Pineapple",
        "vegetable": "Sweet Potato",
        "vitamin": "B12",
        "funFact": "Leg bones are the longest and strongest in the body!",
        "briefInfo": "Legs help you walk, run, jump, and explore.",
        "briefInfoFun": "Legs are turbo-charged—speed, flex, and beast-mode strength.",
      },
    }[organ]!;

    final text = mode == 'fun' ? data['briefInfoFun']! : data['briefInfo']!;
    final organData = data[organ]!;

    // Get fruit name for the selected organ
    final  fruitName = organData['fruit']!;
    final imagePath = data['image']! ; // Image path for the organ

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(title: Text(organ)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Display the organ's image
            if (imagePath != null)
              Image.asset(imagePath, width: 200, height: 200),
            const SizedBox(height: 20),

            // Display the organ's description based on mode
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 20),

            // CustomButton for fruit, vegetable, vitamin, and fun fact
            CustomButton(
              text: mode == 'fun' ? "Fruits" : "Fruit", // Button text based on mode
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailInfoPage(
                    fruitName: fruitName,
                    info: mode == 'fun' ? data['fruitFun']! : data['fruitNormal']!,
                    image: data['fruitImage']!, // Link to fruit image
                    mode: mode,
                  ),
                ),
              ),
            ),
            CustomButton(
              text: mode == 'fun' ? "Veggies" : "Vegetable", // Button text based on mode
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailInfoPage(
                    info: mode == 'fun' ? data['vegetableFun']! : data['vegetableNormal']!,
                    image: data['vegetableImage']!, // Link to vegetable image
                    mode: mode,
                  ),
                ),
              ),
            ),
            CustomButton(
              text: mode == 'fun' ? "Vits" : "Vitamin", // Button text based on mode
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailInfoPage(
                    info: mode == 'fun' ? data['vitaminFun']! : data['vitaminNormal']!,
                    image: data['vitaminImage']!, // Link to vitamin image
                    mode: mode,
                  ),
                ),
              ),
            ),
            CustomButton(
              text: mode == 'fun' ? "Brain Bombs" : "Fun Fact", // Button text based on mode
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailInfoPage(
                    info: mode == 'fun' ? data['funFactFun']! : data['funFactNormal']!,
                    image: data['funFactImage']!, // Link to fun fact image
                    mode: mode,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}