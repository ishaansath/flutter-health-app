import 'package:flutter/material.dart';
import 'detail_info_page.dart';
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
        "nfunFact": "The brain contains about 86 billion neurons!",
        "ffunFact": "Big brain flex: 86 billion neuron homies in the squad",
        "briefInfo": "The brain is your body's control center.",
        "briefInfoFun": "The control tower, sparking thoughts, moves, and genius ideas",
        "fruitDescriptionNormal": "Blueberries are rich in antioxidants, great for brain health.",
        "fruitDescriptionFun": "Blueberries are like brain fuel, keeping you sharp and smart!",
        "vegetableDescriptionNormal": "Spinach is packed with nutrients that promote brain function.",
        "vegetableDescriptionFun": "Spinach = brain booster! Gives you superhero brain powers!",
        "vitaminDescriptionNormal": "Vitamin K helps protect the brain and supports memory.",
        "vitaminDescriptionFun": "Vitamin K keeps your brain in beast mode—memory and focus on point!",
        "fruitImage": "assets/Blueberries.png",
        "vegetableImage": "assets/spinach.png",
        "vitaminImage": "assets/vitamink.png",
        "funFactImage": "assets/brain_fact.png"
      },
      "Heart ❤": {
        "image": "assets/heart.png",
        "fruit": "Tomatoes",
        "vegetable": "Beetroot",
        "vitamin": "C",
        "nfunFact": "It pumps about 2,000 gallons of blood daily!",
        "ffunFact": "The heart’s putting in major work—straight-up boss vibes, pumping 2K gallons a day like it’s nothing. ",
        "briefInfo": "The heart pumps oxygen-rich blood through the body.",
        "briefInfoFun": "The life engine—pumping nonstop fuel 24/7.",
        "fruitDescriptionNormal": "Tomatoes are packed with antioxidants that support heart health.",
        "fruitDescriptionFun": "Tomatoes = heart protectors, keeping your ticker in tip-top shape!",
        "vegetableDescriptionNormal": "Beetroot helps improve blood flow and reduce blood pressure.",
        "vegetableDescriptionFun": "Beetroot = blood flow booster—keeps your heart on track!",
        "vitaminDescriptionNormal": "Vitamin C is essential for blood vessel health and repairing tissues.",
        "vitaminDescriptionFun": "Vitamin C is like your heart's personal repair crew!",
        "fruitImage": "assets/tomatoes.png",
        "vegetableImage": "assets/beetroot.png",
        "vitaminImage": "assets/vitamin_c.png",
        "funFactImage": "assets/heart_fact.png"
      },
    }[organ]!;

    final text = mode == 'fun' ? data['briefInfoFun']! : data['briefInfo']!;
    final fruitDescription = mode == 'fun' ? data['fruitDescriptionFun']! : data['fruitDescriptionNormal']!;
    final vegetableDescription = mode == 'fun' ? data['vegetableDescriptionFun']! : data['vegetableDescriptionNormal']!;
    final vitaminDescription = mode == 'fun' ? data['vitaminDescriptionFun']! : data['vitaminDescriptionNormal']!;
    final imagePath = data['image']!; // Image path for the organ

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
                    info: fruitDescription,
                    image: data['fruitImage']!,
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
                    info: vegetableDescription,
                    image: data['vegetableImage']!,
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
                    info: vitaminDescription,
                    image: data['vitaminImage']!,
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
                    info: mode == 'fun' ? data['ffunFact']! : data['nfunFact']!,
                    image: data['funFactImage']!,
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
