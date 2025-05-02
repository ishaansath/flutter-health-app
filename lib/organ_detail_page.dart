import 'package:flutter/material.dart';
import 'detail_info_page.dart';
import 'custom_button.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:gif_view/gif_view.dart';


class OrganDetailPage extends StatelessWidget {
  final String organ;
  final String mode;


  const OrganDetailPage({super.key, required this.organ, required this.mode});

  @override
  Widget build(BuildContext context) {
    final data = {
      "Brain 🧠": {
        "image": "assets/models/brain.glb",
        "fruit": "Blueberries",
        "vegetable": "Spinach",
        "vitamin": "K",
        "nfunFact": "The human brain contains approximately 86 billion neurons. These tiny nerve cells transmit signals that control every thought, action, and feeling. They form complex networks that power everything your body does.",
        "ffunFact": "Big brain flex: 86 billion neuron homies in the squad",
        "briefInfo": "The brain is the central command center of your body, responsible for controlling thoughts, movements, and vital functions",
        "briefInfoFun": "The control tower, sparking thoughts, moves, and genius ideas",
        "fruitDescriptionNormal": "Blueberries are packed with vitamins C and K, as well as powerful antioxidants. They help support heart health, enhance brain function, and aid in regulating blood sugar levels.",
        "fruitDescriptionFun": "Blueberries are like brain fuel, keeping you sharp and smart!",
        "vegetableDescriptionNormal": "Spinach is rich in iron, folate, magnesium, and vitamins A, C, and K. These nutrients help boost brain function, improve memory, and support healthy blood flow to the brain. It's also loaded with antioxidants that protect brain cells from damage.",
        "vegetableDescriptionFun": "Spinach = brain booster! Gives you superhero brain powers!",
        "vitaminDescriptionNormal": "Vitamin K is essential for brain health. It helps protect brain cells and supports memory and cognitive function. A steady intake keeps your mind sharp and focused.",
        "vitaminDescriptionFun": "Vitamin K keeps your brain in beast mode—memory and focus on point!",
        "fruitImage": "assets/Blueberries.png",
        "vegetableImage": "assets/spinach.png",
        "vitaminImage": "assets/vitamink.png",
        "funFactImage": "assets/gif/brain_fact.gif"
      },
      "Heart ❤": {
        "image": "assets/models/heart.glb",
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
        "funFactImage": "assets/gif/heart_fact.gif"
      },
      "Eyes 👁": {
        "image": "assets/models/eye.glb",
        "fruit": "Oranges",
        "vegetable": "Carrot",
        "vitamin": "A",
        "nfunFact": "Your eyes blink approximately 12,000 times a day, helping to keep them moist and protect them from dust and irritants.",
        "ffunFact": "Eyes can spot over 10 million colors—total visual GOATs.",
        "briefInfo": "Eyes transform light into vision, adjust to focus on fine details, and capture a spectrum of colors in stunning high definition.",
        "briefInfoFun": "Eyes turn light into vision—focus, adjust, and spot millions of colors like pros.",
        "fruitDescriptionNormal": "Oranges are vibrant, juicy fruits rich in vitamin C, which helps boost immunity and refreshes your taste buds with every bite.",
        "fruitDescriptionFun": "Oranges are zesty, juicy, packed with vitamin vibes, and a citrus boss.",
        "vegetableDescriptionNormal": "Carrots are crunchy, sweet vegetables packed with vitamin A, which supports healthy vision and contributes to overall wellness.",
        "vegetableDescriptionFun": "Carrots are crunchy, sweet, full of vitamin A, and your vision’s bestie. ",
        "vitaminDescriptionNormal": "Vitamin A is crucial for maintaining healthy vision, supporting immune function, and promoting glowing, healthy skin.",
        "vitaminDescriptionFun": "Vitamin A is your vision MVP—it’s like a superhero cape for your eyes! ",
        "fruitImage": "assets/oranges.png",
        "vegetableImage": "assets/carrots.png",
        "vitaminImage": "assets/vitamina.png",
        "funFactImage": "assets/gif/eye_fact.gif"
      },
      "Lungs 🫁": {
        "image": "assets/models/lungs.glb",
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
        "funFactImage": "assets/gif/lung_fact.gif"
      },
      "Stomach 🍽": {
        "image": "assets/models/stomach.glb",
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
        "funFactImage": "assets/gif/stomach_fact.gif"
      },
      "Muscles 💪": {
        "image": "assets/models/muscle.glb",
        "fruit": "Banana",
        "vegetable": "Kale",
        "vitamin": "B",
        "nfunFact": "Muscles account for approximately 40% of your body weight and can adapt to become stronger and more efficient through regular exercise!",
        "ffunFact": "Muscles are your built-in powerhouses—flexing at 40% of your weight and leveling up with every workout. Stay on the grind, and they’ll keep getting stronger and more efficient.",
        "briefInfo": "Muscles are specialized tissues that enable movement, maintain posture, and support bodily functions like circulation and respiration. ",
        "briefInfoFun": "Muscles move, flex, and power your body like champs.",
        "fruitDescriptionNormal": "Bananas are a great choice for muscle health, providing potassium to prevent cramps and energy-boosting carbs to aid muscle recovery and performance.",
        "fruitDescriptionFun": "Bananas are muscle fuel—potassium-packed for max strength and no cramp vibes.",
        "vegetableDescriptionNormal": "Kale is a nutrient-rich vegetable that supports muscle health by providing essential vitamins like A, C, and K, along with calcium and antioxidants that aid recovery and strength.",
        "vegetableDescriptionFun": " Kale’s the OG muscle leaf—stacked with iron and nutrients for gains with no flop vibes.",
        "vitaminDescriptionNormal": "Vitamin D is essential for muscle health, as it supports muscle strength and function by aiding calcium absorption and promoting healthy muscle growth and recovery.",
        "vitaminDescriptionFun": "Vitamin D is the muscle MVP—boosts strength, supports recovery, and keeps your bones solid for those gains.",
        "fruitImage": "assets/bananas.png",
        "vegetableImage": "assets/kale.png",
        "vitaminImage": "assets/vitamind.png",
        "funFactImage": "assets/gif/muscle_fact.gif"
      },
      "Legs 🦵": {
        "image": "assets/models/leg.glb",
        "fruit": "Pineapple",
        "vegetable": "Sweet Potato",
        "vitamin": "B12",
        "nfunFact": "The femur, which is the longest bone in your leg, holds the title of being the longest bone in your entire body, providing the strength and support needed for movement and stability.",
        "ffunFact": "Leg bones are the OG speed demons and powerhouses—built for max strength and turbo vibes.",
        "briefInfo": "Legs provide essential support, enable movement, and ensure stability and strength for daily activities.",
        "briefInfoFun": "Legs are turbo-charged—speed, flex, and beast-mode strength.",
        "fruitDescriptionNormal": "Pineapple supports leg health by providing anti-inflammatory compounds like bromelain, which may help reduce muscle soreness, along with vitamin C to aid tissue repair.",
        "fruitDescriptionFun": "Pineapple is the ultimate leg-day snack—loaded with bromelain to fight soreness and packed with vitamin C for muscle recovery",
        "vegetableDescriptionNormal": "Sweet potatoes are great for leg health, as they provide complex carbohydrates for energy, potassium to prevent cramps, and vitamins like A and C to support muscle recovery and overall strength.",
        "vegetableDescriptionFun": "Sweet Potato is stacked with carbs for energy, potassium to crush cramps, and vitamin A for muscle repair vibes. ",
        "vitaminDescriptionNormal": "Vitamin B12 is important for leg health, as it helps maintain nerve function, supports the production of red blood cells, and promotes proper circulation, reducing fatigue and muscle weakness.",
        "vitaminDescriptionFun": "Vitamin B12 keeps your legs in beast mode—supports energy, boosts endurance, and fires up muscle recovery.",
        "fruitImage": "assets/pineapple.png",
        "vegetableImage": "assets/sweet potato.png",
        "vitaminImage": "assets/vitaminb12.png",
        "funFactImage": "assets/gif/leg_fact.gif"
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

        child: Wrap(
          spacing: 30,
          runSpacing: 50,
          alignment: WrapAlignment.center,
          children: [
            // Display the organ's image
            if (modelPath != null)
              SizedBox(
                height: 300, // Adjust to fit your layout
                child: ModelView(modelPath: modelPath),
              ),
            // Display the organ's description based on mode
            Text(text, textAlign: TextAlign.justify, style: const TextStyle(color: Colors.white, fontSize: 15)),

            // CustomButton for fruit, vegetable, vitamin, and fun fact
            CustomButton(
              text: mode == 'fun' ? "Fruits" : "Fruit", // Button text based on mode
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailInfoPage(
                    color: Colors.red,
                    info: fruitDescription,
                    image: data['fruitImage']!,
                    mode: mode,
                  ),
                ),
              ),
            ),
            CustomButton(
              backgroundColor: Colors.orange,
              textColor: Colors.white,
              text: mode == 'fun' ? "Veggies" : "Vegetable", // Button text based on mode
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailInfoPage(
                    info: vegetableDescription,
                    color:  Colors.orange,
                    image: data['vegetableImage']!,
                    mode: mode,
                  ),
                ),
              ),
            ),
            CustomButton(
              text: mode == 'fun' ? "Vits" : "Vitamin", // Button text based on mode
              backgroundColor: Colors.deepPurple,
              textColor: Colors.white,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailInfoPage(
                    info: vitaminDescription,
                    color: Colors.deepPurple,
                    image: data['vitaminImage']!,
                    mode: mode,
                  ),
                ),
              ),
            ),
            CustomButton(
              text: mode == 'fun' ? "Fact Bites" : "Fun Fact", // Button text based on mode
              backgroundColor: Colors.teal,
              textColor: Colors.white,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailInfoPage(
                    info: mode == 'fun' ? data['ffunFact']! : data['nfunFact']!,
                    color: Colors.teal,
                    image: data['funFactImage']!,
                    mode: mode,
                  ),
                ),
              ),
            )
            ,
          ],
        ),
      ),
    );
  }

}
class ModelView extends StatelessWidget {
  final String modelPath;
  const ModelView({super.key, required this.modelPath}); // Removed 'const'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300, // Adjust size as needed
          height: 300,
          // padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ModelViewer(
            src: modelPath,
            alt: "A 3D model",
            ar: false,
            autoRotate: true,
            cameraControls: true,
            backgroundColor: Colors.grey.shade900,
          ),
        ),
      ),
    );
  }
}
