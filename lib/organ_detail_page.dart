import 'package:flutter/material.dart';
import 'detail_info_page.dart';
import 'custom_button.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

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
        "fruitDescriptionNormal": "Blueberries are rich in vitamin C, K, and antioxidants, Supports heart health, brain function, and blood sugar regulation.",
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
        "vegetableDescriptionNormal": "Beetroot is low-calorie, rich in nitrates, and supports heart health by improving blood flow, lowering blood pressure, and reducing inflammation.",
        "vegetableDescriptionFun": "Beetroot = blood flow booster—keeps your heart on track!",
        "vitaminDescriptionNormal": "Vitamin C is essential for blood vessel health and repairing tissues.",
        "vitaminDescriptionFun": "Vitamin C is like your heart's personal repair crew!",
        "fruitImage": "assets/tomatoes.png",
        "vegetableImage": "assets/beetroot.png",
        "vitaminImage": "assets/vitaminc.png",
        "funFactImage": "assets/heart_fact.png"
      },
      "Eyes 👁": {
        "image": "assets/eyes.png",
        "fruit": "Oranges",
        "vegetable": "Carrot",
        "vitamin": "A",
        "nfunFact": "Your eyes blink around 12,000 times a day!",
        "ffunFact": "Eyes can spot over 10 million colors—total visual GOATs.",
        "briefInfo": "Eyes convert light into sight, adapt to focus on details, and capture colors in high-definition.",
        "briefInfoFun": "Eyes turn light into vision—focus, adjust, and spot millions of colors like pros.",
        "fruitDescriptionNormal": "Oranges are vibrant, juicy fruits packed with vitamin C, boosting immunity and refreshing your taste buds.",
        "fruitDescriptionFun": "Oranges are zesty, juicy, packed with vitamin vibes, and a citrus boss.",
        "vegetableDescriptionNormal": "Carrots are crunchy, sweet vegetables rich in vitamin A, promoting healthy vision and overall wellness.",
        "vegetableDescriptionFun": "Carrots are crunchy, sweet, full of vitamin A, and your vision’s bestie. ",
        "vitaminDescriptionNormal": "Vitamin A is essential for maintaining good vision, supporting immune function, and promoting healthy skin. ",
        "vitaminDescriptionFun": "Vitamin A is your vision MVP—it’s like a superhero cape for your eyes! ",
        "fruitImage": "assets/oranges.png",
        "vegetableImage": "assets/carrots.png",
        "vitaminImage": "assets/vitamina.png",
        "funFactImage": "assets/eyes_fact.png"
      },
      "Lungs 🫁": {
        "image": "assets/lungs.png",
        "fruit": "Apples",
        "vegetable": "Broccoli",
        "vitamin": "E",
        "nfunFact": "Your lungs are incredible multitaskers—they take in about 11,000 liters of air every day while filtering out harmful particles to keep you breathing smoothly!",
        "ffunFact": " Lungs are on grind mode—20K breaths a day without skipping a beat.",
        "briefInfo": "Lungs are vital organs that exchange oxygen and carbon dioxide, enabling you to breathe and support essential functions throughout your body.",
        "briefInfoFun": "Lungs = oxygen in, CO2 out—airflow GOATs keeping you alive. ",
        "fruitDescriptionNormal": "Apples are crisp, sweet fruits rich in fiber, vitamin C, and antioxidants, making them a wholesome snack for a healthy lifestyle.",
        "fruitDescriptionFun": "Apples = lung legends—packed with antioxidants and flavonoids that support lung health, boost capacity, and fight oxidative damage. ",
        "vegetableDescriptionNormal": "Broccoli is a nutrient-packed vegetable, rich in vitamins C and K, fiber, and antioxidants, supporting strong immunity and overall health. ",
        "vegetableDescriptionFun": "Broccoli AKA lung protectors—stacked with antioxidants and sulforaphane to fight toxins and keep your breathing game strong.",
        "vitaminDescriptionNormal": "Vitamin E is a powerful antioxidant that helps protect cells from damage, supports skin health, and boosts immune function.",
        "vitaminDescriptionFun": "Vitamin E is like a lung boss-packed with antioxidants that combat oxidative damage, boost capacity, and keep your breathing game strong.",
        "fruitImage": "assets/apples.png",
        "vegetableImage": "assets/broccoli.png",
        "vitaminImage": "assets/vitamine.png",
        "funFactImage": "assets/lung_fact.png"
      },
      "Stomach 🍽": {
        "image": "assets/stomach.png",
        "fruit": "Papaya",
        "vegetable": "Cabbage",
        "vitamin": "B",
        "nfunFact": "Your stomach produces a new layer of mucus every two weeks to protect itself from being digested by its own acid!",
        "ffunFact": " Your stomach’s acid is straight savage—powerful enough to melt metal while keeping your digestion on point.",
        "briefInfo": "The stomach is responsible for breaking down food using strong acids and enzymes, aiding digestion and nutrient absorption.",
        "briefInfoFun": "Stomach melts food, fuels you, and keeps vibes chill.",
        "fruitDescriptionNormal": "Papaya supports stomach health by aiding digestion through its enzyme papain, promoting nutrient absorption, and preventing constipation with its high fiber content.",
        "fruitDescriptionFun": "Papaya is the stomach's hero, loaded with papain to aid digestion, reduce bloating, and keep your gut running smooth.",
        "vegetableDescriptionNormal": "Cabbage is excellent for stomach health, as it's rich in fiber, promotes digestion, and contains compounds like glucosinolates that support gut health.",
        "vegetableDescriptionFun": " Cabbage AKA gut guardian, packed with fiber, vitamins, and antioxidants to keep digestion smooth and your stomach vibes strong.",
        "vitaminDescriptionNormal": "Vitamin B plays a key role in stomach health, supporting energy production, digestion, and helping maintain a healthy gut lining.",
        "vitaminDescriptionFun": "Vitamin B is the stomach's energy ally - boosts digestion, helps break down food into fuel, and supports gut health for smooth vibes.",
        "fruitImage": "assets/papaya.png",
        "vegetableImage": "assets/cabbage.png",
        "vitaminImage": "assets/vitaminb.png",
        "funFactImage": "assets/stomach_fact.png"
      },
      "Muscles 💪": {
        "image": "assets/muscle.png",
        "fruit": "Banana",
        "vegetable": "Kale",
        "vitamin": "B",
        "nfunFact": "Your stomach produces a new layer of mucus every two weeks to protect itself from being digested by its own acid!",
        "ffunFact": "Your body’s flex game is strong—600+ muscles ready to slay every move.",
        "briefInfo": "The stomach is responsible for breaking down food using strong acids and enzymes, aiding digestion and nutrient absorption.",
        "briefInfoFun": "Muscles move, flex, and power your body like champs.",
        "fruitDescriptionNormal": "Bananas are a great choice for muscle health, providing potassium to prevent cramps and energy-boosting carbs to aid muscle recovery and performance.",
        "fruitDescriptionFun": "Bananas are muscle fuel—potassium-packed for max strength and no cramp vibes.",
        "vegetableDescriptionNormal": "Cabbage is excellent for stomach health, as it's rich in fiber, promotes digestion, and contains compounds like glucosinolates that support gut health.",
        "vegetableDescriptionFun": " Kale’s the OG muscle leaf—stacked with iron and nutrients for gains with no flop vibes.",
        "vitaminDescriptionNormal": "Vitamin B plays a key role in stomach health, supporting energy production, digestion, and helping maintain a healthy gut lining.",
        "vitaminDescriptionFun": "Vitamin D is the muscle MVP—boosts strength, supports recovery, and keeps your bones solid for those gains.",
        "fruitImage": "assets/bananas.png",
        "vegetableImage": "assets/kale.png",
        "vitaminImage": "assets/vitamind.png",
        "funFactImage": "assets/muscle_fact.png"
      },
    }[organ]!;

    final text = mode == 'fun' ? data['briefInfoFun']! : data['briefInfo']!;
    final fruitDescription = mode == 'fun' ? data['fruitDescriptionFun']! : data['fruitDescriptionNormal']!;
    final vegetableDescription = mode == 'fun' ? data['vegetableDescriptionFun']! : data['vegetableDescriptionNormal']!;
    final vitaminDescription = mode == 'fun' ? data['vitaminDescriptionFun']! : data['vitaminDescriptionNormal']!;
    final modelPath = data['image']!; // Image path for the organ

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(title: Text(organ)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Display the organ's image
            if (modelPath != null)
              ModelView(modelPath: modelPath),
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
              text: mode == 'fun' ? "Brain Teasers" : "Fun Fact", // Button text based on mode
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
class ModelView extends StatelessWidget {
  final String modelPath;
  ModelView({super.key, required this.modelPath}); // Removed 'const'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300, // Adjust size as needed
          height: 300,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ModelViewer(
            src: modelPath,
            alt: "A 3D model",
            ar: true,
            autoRotate: true,
            cameraControls: true,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
