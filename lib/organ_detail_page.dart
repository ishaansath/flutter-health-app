// organ_detail_page.dart
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
      "Brain": {
        "image": "assets/models/brain.glb",
        "briefInfo": "The brain is the central command center of your body, responsible for controlling thoughts, movements, and vital functions",
        "briefInfoFun": "The control tower, sparking thoughts, moves, and genius ideas",
        "fruits": [
          {
            "name": "Blueberries",
            "normalModeDescription": "Rich in antioxidants that improve memory and slow brain aging.",
            'funModeDescription': 'Blueberries are like brain fuel, keeping you sharp and smart!',
            'additionalInfo': 'Carbs: 14g, Calories: 84, Fiber: 4g, Vitamin C: 14%',
            'image': 'assets/blueberries.png',
            'modelPath': 'assets/models/blueberries.glb'
          },
        ],
        "vegetables": [
          {
            "name": "Spinach",
            "normalModeDescription":
            "Spinach is rich in iron, folate, magnesium, and vitamins A, C, and K. These nutrients help boost brain function, improve memory, and support healthy blood flow to the brain. It's also loaded with antioxidants that protect brain cells from damage.",
            "funModeDescription": "Spinach = brain booster! Gives you superhero brain powers!",
            'additionalInfo': 'Iron: 3mg, Folate: 194mcg, Magnesium: 79mg, Vitamin K: 483mcg',
            'image': 'assets/spinach.png',
            'modelPath': 'assets/models/spinach.glb'
          }
        ],
        "vitamins": [
          {
            "name": "Vitamin K",
            "normalModeDescription":
            "Vitamin K is essential for brain health. It helps protect brain cells and supports memory and cognitive function. A steady intake keeps your mind sharp and focused.",
            "funModeDescription": "Vitamin K keeps your brain in beast mode—memory and focus on point!",
            'additionalInfo': 'Daily Value: 120mcg',
            'image': 'assets/vitamink.png',
            'modelPath': 'assets/models/vitamin_k.glb'
          }
        ],
        "nfunFact": "The human brain contains approximately 86 billion neurons. These tiny nerve cells transmit signals that control every thought, action, and feeling. They form complex networks that power everything your body does.",
        "ffunFact": "Big brain flex: 86 billion neuron homies in the squad",
        "funFactImage": "assets/gif/brain_fact.gif"
      },
      "Heart": {
        "image": "assets/models/heart.glb",
        "briefInfo": "The heart is a muscular organ that continuously pumps oxygen-rich blood through your body to sustain life.",
        "briefInfoFun": "The life engine—pumping nonstop fuel 24/7.",
        "fruits": [
          {
            "name": "Pomegranate",
            "normalModeDescription":
            "Pomegranates are loaded with polyphenols and antioxidants like punicalagins that protect the heart by reducing oxidative stress and inflammation. They help lower blood pressure, improve blood flow to the heart, and prevent artery walls from hardening—making them a powerful natural remedy against heart disease. Drinking pomegranate juice regularly can also reduce bad cholesterol (LDL) and increase good cholesterol (HDL).",
            "funModeDescription": "Pomegranates are like tiny red warriors! 💥 Packed with super shields called antioxidants, they zoom through your blood and chase away the villains (bad fats and cholesterol). They keep your heart beating strong, blood pressure chill, and arteries squeaky clean. Drink a glass of this ruby juice, and your heart will throw a party. 🍷🫀💃",
            'additionalInfo': 'Calories: 83, Carbs: 19g, Fiber: 4g, Vitamin C: 17%',
            'image': 'assets/pomegranate.png',
            'modelPath': 'assets/models/pomegranate.glb',
            'shortDescription': 'Antioxidant powerhouse.',
          },
          {
            "name": "Blueberries",
            "normalModeDescription": "Blueberries contain powerful antioxidants known as anthocyanins, which help lower LDL (bad cholesterol), support blood vessel function, and reduce inflammation in the cardiovascular system. Regular consumption improves circulation, strengthens blood vessels, and reduces risk of heart attacks. They are low in calories but high in fiber and vitamin C—great for long-term heart health.",
            'funModeDescription': "Blueberries are heart ninjas in disguise! 🥷💙 These bite-sized blue buddies sneak through your bloodstream, block the bad stuff, and give your heart a hug. They're so good, even your arteries do a happy dance when you munch on them. Eat 'em fresh, frozen, or in your smoothie—your heart will totally thank you! 🫐💓✨",
            'additionalInfo': 'Calories: 57, Carbs: 14g, Fiber: 2.4g, Vitamin C: 16%',
            'image': 'assets/Blueberries.png',
            'modelPath': 'assets/models/blueberry.glb',
            'shortDescription': 'Tiny cholesterol fighters.',
          },
        ],
        "vegetables": [
          {
            "name": "Beetroot",
            "normalModeDescription":
            "Beetroot is low-calorie, rich in nitrates, and supports heart health by improving blood flow, lowering blood pressure, and reducing inflammation.",
            "funModeDescription": "Beetroot = blood flow booster—keeps your heart on track!",
            'additionalInfo': 'Calories: 59, Fiber: 3g, Nitrates: High',
            'image': 'assets/beetroot.png',
            'modelPath': 'assets/models/beetroot.glb'
          }
        ],
        "vitamins": [
          {
            "name": "Vitamin C",
            "normalModeDescription":
            "Vitamin C plays a vital role in maintaining healthy blood vessels, supporting tissue repair, and boosting the immune system. It also helps in the absorption of iron and healing of wounds.",
            "funModeDescription": "Vitamin C is like your heart's personal repair crew!",
            'additionalInfo': 'Daily Value: 90mg',
            'image': 'assets/vitaminc.png',
            'modelPath': 'assets/models/vitamin_c.glb'
          }
        ],
        "nfunFact": "The human heart works tirelessly, pumping approximately 2,000 gallons of blood each day. This vital organ ensures that oxygen and nutrients reach every part of the body, keeping you alive and healthy.",
        "ffunFact": "The heart’s putting in major work—straight-up boss vibes, pumping 2K gallons a day like it’s nothing. ",
        "funFactImage": "assets/gif/heart_fact.gif"
      },
      "Eyes": {
        "image": "assets/models/eye.glb",
        "briefInfo": "Eyes transform light into vision, adjust to focus on fine details, and capture a spectrum of colors in stunning high definition.",
        "briefInfoFun": "Eyes turn light into vision—focus, adjust, and spot millions of colors like pros.",
        "fruits": [],
        "vegetables": [],
        "vitamins": [],
        "nfunFact": "Your eyes blink approximately 12,000 times a day, helping to keep them moist and protect them from dust and irritants.",
        "ffunFact": "Eyes can spot over 10 million colors—total visual GOATs.",
        "funFactImage": "assets/gif/eye_fact.gif"
      },
      "Lungs": {
        "image": "assets/models/lungs.glb",
        "briefInfo": "Lungs are vital organs that exchange oxygen and carbon dioxide, enabling you to breathe and support essential functions throughout your body.",
        "briefInfoFun": "Lungs = oxygen in, CO2 out—airflow GOATs keeping you alive. ",
        "fruits": [],
        "vegetables": [],
        "vitamins": [],
        "nfunFact": "Your lungs are incredible multitaskers—they take in about 11,000 liters of air every day while filtering out harmful particles to keep you breathing smoothly!",
        "ffunFact": " Lungs are on grind mode—20K breaths a day without skipping a beat.",
        "funFactImage": "assets/gif/lung_fact.gif"
      },
      "Stomach": {
        "image": "assets/models/stomach.glb",
        "briefInfo": "The stomach is responsible for breaking down food using strong acids and enzymes, aiding digestion and nutrient absorption.",
        "briefInfoFun": "Stomach melts food, fuels you, and keeps vibes chill.",
        "fruits": [],
        "vegetables": [],
        "vitamins": [],
        "nfunFact": "Your stomach produces a new layer of mucus every two weeks to protect itself from being digested by its own acid!",
        "ffunFact": " Your stomach’s acid is straight savage—powerful enough to melt metal while keeping your digestion on point.",
        "funFactImage": "assets/gif/stomach_fact.gif"
      },
      "Muscles": {
        "image": "assets/models/muscle.glb",
        "briefInfo": "Muscles are specialized tissues that enable movement, maintain posture, and support bodily functions like circulation and respiration. ",
        "briefInfoFun": "Muscles move, flex, and power your body like champs.",
        "fruits": [],
        "vegetables": [],
        "vitamins": [],
        "nfunFact": "Muscles account for approximately 40% of your body weight and can adapt to become stronger and more efficient through regular exercise!",
        "ffunFact": "Muscles are your built-in powerhouses—flexing at 40% of your weight and leveling up with every workout. Stay on the grind, and they’ll keep getting stronger and more efficient.",
        "funFactImage": "assets/gif/muscle_fact.gif"
      },
      "Legs": {
        "image": "assets/models/leg.glb",
        "briefInfo": "Legs provide essential support, enable movement, and ensure stability and strength for daily activities.",
        "briefInfoFun": "Legs are turbo-charged—speed, flex, and beast-mode strength.",
        "fruits": [],
        "vegetables": [],
        "vitamins": [],
        "nfunFact": "The femur, which is the longest bone in your leg, holds the title of being the longest bone in your entire body, providing the strength and support needed for movement and stability.",
        "ffunFact": "Leg bones are the OG speed demons and powerhouses—built for max strength and turbo vibes.",
        "funFactImage": "assets/gif/leg_fact.gif"
      },
    }[organ]!;

    final organName = organ;
    final briefInfoText = mode == 'fun' ? data['briefInfoFun']! as String : data['briefInfo']! as String;
    final modelPath = data['image']! as String;
    final String? funFactImage = data['funFactImage'] as String?;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(organ, style: const TextStyle(color: Colors.white)),
          centerTitle: true),
      body: SingleChildScrollView( // Added SingleChildScrollView here
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            spacing: 30,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              if (modelPath.isNotEmpty)
                SizedBox(
                  height: 300,
                  child: ModelView(modelPath: modelPath),
                ),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  briefInfoText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              CustomButton(
                text: mode == 'fun' ? "Froots" : "Fruits",
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailInfoPage(
                      title: mode == 'fun' ? "Froots" : "Fruits",
                      items: data['fruits'] as List<Map<String, dynamic>>? ?? [],
                      color: Colors.red,
                      organ: organName,
                      mode: mode, image: '',
                    ),
                  ),
                ),
              ),
              CustomButton(
                backgroundColor: Colors.orange,
                textColor: Colors.white,
                text: mode == 'fun' ? "Veggies" : "Vegetables",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailInfoPage(
                      title: mode == 'fun' ? "Veggies" : "Vegetables",
                      items: data['vegetables'] as List<Map<String, dynamic>>? ?? [],
                      color: Colors.orange,
                      organ: organName,
                      mode: mode, image: '',
                    ),
                  ),
                ),
              ),
              CustomButton(
                text: mode == 'fun' ? "Vits" : "Vitamins",
                backgroundColor: Colors.deepPurple,
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailInfoPage(
                      title: mode == 'fun' ? "Vits" : "Vitamins",
                      items: data['vitamins'] as List<Map<String, dynamic>>? ?? [],
                      color: Colors.deepPurple,
                      organ: organName,
                      mode: mode, image: '',
                    ),
                  ),
                ),
              ),
              CustomButton(
                text: mode == 'fun' ? "Fact Bites" : "Fun Facts",
                backgroundColor: Colors.teal,
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailInfoPage(
                      title: mode == 'fun' ? "Fact Bites" : "Fun Facts",
                      info: mode == 'fun' ? data['ffunFact']! as String : data['nfunFact']! as String,
                      image: funFactImage ?? '',
                      color: Colors.teal,
                      organ: organName,
                      mode: mode,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: double.infinity, height: 150),
            ],
          ),
        ),
      ),
    );
  }
}

class ModelView extends StatelessWidget {
  final String modelPath;

  const ModelView({super.key, required this.modelPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            border: Border.all(color: Colors.grey.shade900, width: 2),
            borderRadius: BorderRadius.circular(7),
          ),
          child: ModelViewer(
            src: modelPath,
            alt: "Organ model",
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