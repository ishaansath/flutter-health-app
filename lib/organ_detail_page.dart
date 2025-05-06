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
            "name": "Banana",
            "normalModeDescription": "Bananas are a top-tier brain food because they’re rich in vitamin B6, which helps in the creation of neurotransmitters like serotonin and dopamine—critical for mood regulation and clear thinking. They also supply natural sugars and potassium, giving your brain steady energy and helping maintain electrical conductivity between nerve cells. Eating a banana in the morning can improve learning capacity, cognitive function, and help regulate your mood throughout the day.",
            'funModeDescription': 'Bananas are basically mood boosters with WiFi for your brain. 🍌💡 They drop that B6 to charge your thoughts, boost your vibes, and help you stay focused without going "bruhhh" mid-task. Eat one and you might just go from sleepy monkey to Einstein mode. 🧠⚡🐵',
            'additionalInfo': 'Calories: 89, Carbs: 23g, Protein: 1.1g, Vitamin B6: 33%, Potassium: 358mg',
            'image': 'assets/bananas.png',
            'modelPath': 'assets/models/banana.glb',
            'shortDescription': "Fuel for focus and memory"
          },
          {
            "name": "Blueberries",
            "normalModeDescription": "Blueberries contain powerful antioxidants known as anthocyanins, which help lower bad cholesterol, support blood vessel function, and reduce inflammation in the cardiovascular system. Regular consumption improves circulation, strengthens blood vessels, and reduces risk of heart attacks. They are low in calories but high in fiber and vitamin C—great for long-term heart health.",
            'funModeDescription': "Blueberries are heart ninjas in disguise! 🥷💙 These bite-sized blue buddies sneak through your bloodstream, block the bad stuff, and give your heart a hug. They're so good, even your arteries do a happy dance when you munch on them. Eat 'em fresh, frozen, or in your smoothie—your heart will totally thank you! 🫐💓✨",
            'additionalInfo': 'Calories: 57, Carbs: 14g, Fiber: 2.4g, Vitamin C: 16%',
            'image': 'assets/Blueberries.png',
            'modelPath': 'assets/models/blueberry.glb',
            'shortDescription': 'Tiny cholesterol fighters',
          },
          {
            "name": "Apple",
            "normalModeDescription": "Apples are rich in antioxidants like quercetin, which defend brain cells from oxidative damage. Their skin holds most of this power, so eat them whole. Apples also contain soluble fiber and natural sugars that provide slow, stable energy—perfect for long study sessions or focused work.",
            'funModeDescription': "Apples = brain snacks that slap. 🍏⚡ Eat the skin and unlock quercetin XP to protect your mental game. Sweet, crunchy, and straight-up smart fuel. Core power activated! 💥📚",
            'additionalInfo': 'Calories: 52, Carbs: 13.8g, Fiber: 2.4g, Vitamin C: 7% DV, Quercetin: 4.42 mg/100g',
            'image': 'assets/apples.png',
            'modelPath': 'assets/models/apple.glb',
            'shortDescription': 'Crunchy and juicy support',
          },
        ],
        "vegetables": [
          {
            "name": "Spinach",
            "normalModeDescription":
            "Spinach is rich in brain-enhancing nutrients like folate, lutein, and vitamin K. These support neurotransmitter function, improve brain plasticity, and reduce mental decline with age. The antioxidants in spinach also protect neural tissue, and the iron content helps carry oxygen to the brain for optimal function.",
            "funModeDescription": "Spinach is like rocket fuel for your thoughts. 🚀🥬 It powers your focus, shields your brain, and keeps your mental batteries fully charged. Wanna be Popeye-smart? Get those greens in. 🧠💥💚",
            'additionalInfo': 'Calories: 23g (per 100g), Protein: 2.9g, Folate: 49%, Vitamin K: 460%, Iron: 15%',
            'image': 'assets/spinach.png',
            'modelPath': 'assets/models/spinach.glb',
            'shortDescription': 'Green fuel for brainpower'
          },
          {
            "name": "Red Onion",
            "normalModeDescription": "Red onions are packed with flavonoids and antioxidants that protect the brain from inflammation and cognitive aging. Quercetin, a key compound in onions, improves memory by protecting neurons from damage and improving blood flow to the brain.",
            'funModeDescription': "Red onions? Brain zappers in disguise. 🧅🧠 They might make you cry, but they also keep your memory tight and your focus razor-sharp. Cry now, glow up later. 💧⚔️",
            'additionalInfo': 'Calories: 40, Carbs: 9g, Vitamin C: 12%, Quercetin: 19.36 mg (per 100g), Fiber: 1.7g',
            'image': 'assets/redonion.png',
            'modelPath': 'assets/models/redonion.glb',
            'shortDescription': 'Zesty brain defender',
          },
          {
            "name": "Cucumber",
            "normalModeDescription": "Cucumbers are made up of 95% water, making them an excellent choice for hydration, which is key for optimal brain function. They contain a unique antioxidant called fisetin, which has been shown to improve memory and brain health. The high water content helps maintain proper circulation to the brain and supports overall cognitive function. Eating cucumbers regularly can help boost brain performance and focus.",
            'funModeDescription': "Cucumbers are the brain’s hydration secret! 💧🥒 Super refreshing and full of antioxidants like fisetin, they help you stay sharp, focused, and hydrated—perfect for those long study sessions! 🧠💪",
            'additionalInfo': 'Calories: 16g (per 100g), Carbs: 3.6g, Fiber: 0.5g, Vitamin K: 16% DV, Antioxidants: High (fisetin)',
            'image': 'assets/cucumber.png',
            'modelPath': 'assets/models/cucumber.glb',
            'shortDescription': 'Hydrates and boosts brain function',
          },
        ],
        "vitamins": [
          {
            "name": "Vitamin K",
            "normalModeDescription": "Vitamin K helps direct calcium to your bones instead of your arteries, preventing hardening and plaque formation. It also supports proper blood clotting, which prevents excessive bleeding while also protecting your heart from blockages caused by calcification.",
            'funModeDescription': "Vitamin K is the traffic cop for calcium! 🚦🦴 It tells calcium where to go (to your bones!) and keeps it out of your blood pipes. That means less clogging and more smooth sailing for your heart. It also keeps your blood from leaking all over—super handy! 🧠🚓🫀",
            'additionalInfo': 'Daily Value: 100mg, Found in: Kale, Spinach, Broccoli, Egg Yolk',
            'image': 'assets/vitamink.png',
            'modelPath': 'assets/models/vitamin_k.glb',
            'shortDescription': 'Calcium regulator for arteries',
          },
          {
            "name": "Vitamin B12",
            "normalModeDescription": "Vitamin B12 helps maintain nerve health, forms red blood cells, and aids in the production of brain chemicals that affect mood and thinking. Deficiency can lead to confusion, poor memory, and even depression. It’s especially vital for kids and older adults.",
            'funModeDescription': "B12 = brain’s router. No B12 = no signal. 📶🧠 It keeps your focus sharp, your brain online, and your chill intact. Plug in or lag out. 🚫🧠",
            'additionalInfo': 'Daily Value: 2.4 mcg/day, Found in: Meat, dairy, eggs, fortified cereal',
            'image': 'assets/vitaminb12.png',
            'modelPath': 'assets/models/vitamin_b.glb',
            'shortDescription': 'Essential for focus & nerves',
          },
          {
            "name": "Vitamin E",
            "normalModeDescription": "Vitamin E is a fat-soluble antioxidant that protects the brain from free radical damage. It slows cognitive decline and protects the brain's fatty membranes. People with high vitamin E levels tend to retain stronger memory and attention spans as they age.",
            'funModeDescription': "Vitamin E = the shield your brain didn’t know it needed. 🧠🛡️ It blocks the baddies (free radicals), slows the aging glitch, and boosts memory stats. Equip and dominate. 🕹️✨",
            'additionalInfo': 'Daily Value: 15 mg, Sources: Nuts, seeds, spinach, avocado',
            'image': 'assets/vitamine.png',
            'modelPath': 'assets/models/vitamin_e.glb',
            'shortDescription': 'Antioxidant armor',
          },
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
            "Pomegranates are loaded with polyphenols and antioxidants like punicalagins that protect the heart by reducing oxidative stress and inflammation. They help lower blood pressure, improve blood flow to the heart, and prevent artery walls from hardening—making them a powerful natural remedy against heart disease. Drinking pomegranate juice regularly can also reduce bad cholesterol and increase good cholesterol.",
            "funModeDescription": "Pomegranates are like tiny red warriors! 💥 Packed with super shields called antioxidants, they zoom through your blood and chase away the villains (bad fats and cholesterol). They keep your heart beating strong, blood pressure chill, and arteries squeaky clean. Drink a glass of this ruby juice, and your heart will throw a party. 🍷🫀💃",
            'additionalInfo': 'Calories: 83, Carbs: 19g, Fiber: 4g, Vitamin C: 17%',
            'image': 'assets/pomegranate.png',
            'modelPath': 'assets/models/pomegranate.glb',
            'shortDescription': 'Antioxidant powerhouse',
          },
          {
            "name": "Blueberries",
            "normalModeDescription": "Blueberries contain powerful antioxidants known as anthocyanins, which help lower bad cholesterol, support blood vessel function, and reduce inflammation in the cardiovascular system. Regular consumption improves circulation, strengthens blood vessels, and reduces risk of heart attacks. They are low in calories but high in fiber and vitamin C—great for long-term heart health.",
            'funModeDescription': "Blueberries are heart ninjas in disguise! 🥷💙 These bite-sized blue buddies sneak through your bloodstream, block the bad stuff, and give your heart a hug. They're so good, even your arteries do a happy dance when you munch on them. Eat 'em fresh, frozen, or in your smoothie—your heart will totally thank you! 🫐💓✨",
            'additionalInfo': 'Calories: 57, Carbs: 14g, Fiber: 2.4g, Vitamin C: 16%',
            'image': 'assets/Blueberries.png',
            'modelPath': 'assets/models/blueberry.glb',
            'shortDescription': 'Tiny cholesterol fighters',
          },
          {
            "name": "Avocado",
            "normalModeDescription": "Avocados are rich in monounsaturated fats—healthy fats that help reduce bad cholesterol and increase good cholesterol. They’re also full of potassium, which helps control blood pressure, and contain antioxidants like lutein and vitamin E. All of this reduces heart strain and lowers the risk of heart disease. They’re a creamy, delicious, and nutritious way to protect your heart.",
            'funModeDescription': "Avocados are like the smooth-talking bodyguards of your heart! 🥑💚 They kick out the bad cholesterol guests and roll out the red carpet for the good guys. Plus, they’ve got potassium power—like bananas in stealth mode. One bite of avo-toast, and your heart's like “let’s chill, we’re safe now.” 💪🥑💓",
            'additionalInfo': 'Calories: 160, Carbs: 9g, Fiber: 7g, Potassium: 14%',
            'image': 'assets/avocado.png',
            'modelPath': 'assets/models/avocado.glb',
            'shortDescription': 'Heart-friendly fat boost',
          },
        ],
        "vegetables": [
          {
            "name": "Beetroot",
            "normalModeDescription":
            "Beetroot is rich in dietary nitrates, which convert into nitric oxide in the body—a compound that relaxes and widens blood vessels. This helps improve circulation, lower blood pressure, and boost oxygen delivery throughout the body. Regular consumption of beetroot supports a healthier cardiovascular system, increases stamina, and may even improve cognitive function due to enhanced blood flow to the brain.",
            "funModeDescription": "Beetroot’s like rocket fuel for your veins! 🚀🩸 It drops nitrates that turn into blood-boosting gas, opening up your blood highways for a smooth, pressure-free ride. Your heart chills, your brain gets extra oxygen, and your body’s like “let’s goooo!” One beet = beast mode! 🧠💪🫀",
            'additionalInfo': 'Calories: 43, Carbs: 9.6g, Fiber: 2.8g, Nitrates: ~250 mg per 100g',
            'image': 'assets/beetroot.png',
            'modelPath': 'assets/models/beetroot.glb',
            'shortDescription': 'Blood flow booster',
          },
          {
            "name": "Broccoli",
            "normalModeDescription": "Broccoli is rich in fiber, sulforaphane, and other antioxidants that help lower inflammation in blood vessels. Its nutrients support smoother circulation and reduce oxidative stress, which can lead to clogged arteries. Broccoli also provides vitamin K and folate—important for preventing calcium buildup and supporting heart muscle health.",
            'funModeDescription': "Broccoli is the superhero tree that scrubs your blood roads clean! 🦸‍♂️🌳 With fiber fists and antioxidant lasers, it zaps inflammation and keeps your veins free of junk. Eat your trees, and your heart will zoom like a sports car. 🥦💨💓",
            'additionalInfo': 'Calories: 34, Carbs: 6.6g, Fiber: 2.6g, Vitamin C: 89%',
            'image': 'assets/broccoli.png',
            'modelPath': 'assets/models/broccoli.glb',
            'shortDescription': 'Fiber and antioxidant defender',
          },
          {
            "name": "Tomato",
            "normalModeDescription": "Tomatoes are full of lycopene, a powerful antioxidant that reduces bad cholesterol, prevents plaque buildup in arteries, and lowers blood pressure. They also contain potassium and folate, which help in relaxing blood vessels and maintaining a healthy heartbeat. Cooked tomatoes increase lycopene levels, making them even better for heart health.",
            'funModeDescription': "Tomatoes are like red fire extinguishers for heart drama! 🔥🍅 They shoot out lycopene lasers that melt away artery gunk and cool down blood pressure. Whether it’s ketchup, pasta sauce, or a juicy slice—your heart’s doing cartwheels behind the scenes. 🍅🧯🫀",
            'additionalInfo': 'Calories: 18, Carbs: 3.9g, Fiber: 1.2g, Lycopene: 2573 mcg',
            'image': 'assets/tomatoes.png',
            'modelPath': 'assets/models/tomato.glb',
            'shortDescription': 'Lycopene-rich heart helper',
          },
        ],
        "vitamins": [
          {
            "name": "Vitamin C",
            "normalModeDescription":
            "Vitamin C is an antioxidant that prevents free radical damage to blood vessels, strengthens artery walls, and helps the body produce collagen—a protein vital for healthy arteries. It also boosts the immune system and reduces overall inflammation, helping the cardiovascular system function smoothly.",
            "funModeDescription": "Vitamin C is like the duct tape for your blood tubes! 🛠️🍊 It seals cracks, blocks invaders, and keeps your blood highways in tip-top shape. Plus, it gives your immune system a big power-up, so your whole body’s ready for action. 🛡️💉🧡",
            'additionalInfo': 'Daily Value: 90mg, Found in: Citrus, Kiwi, Guava, Bell Peppers',
            'image': 'assets/vitaminc.png',
            'modelPath': 'assets/models/vitamin_c.glb',
            'shortDescription': 'Vessel-strengthening vitamin',
          },
          {
            "name": "Vitamin K",
            "normalModeDescription": "Vitamin K helps direct calcium to your bones instead of your arteries, preventing hardening and plaque formation. It also supports proper blood clotting, which prevents excessive bleeding while also protecting your heart from blockages caused by calcification.",
            'funModeDescription': "Vitamin K is the traffic cop for calcium! 🚦🦴 It tells calcium where to go (to your bones!) and keeps it out of your blood pipes. That means less clogging and more smooth sailing for your heart. It also keeps your blood from leaking all over—super handy! 🧠🚓🫀",
            'additionalInfo': 'Daily Value: 100mg, Found in: Kale, Spinach, Broccoli, Egg Yolk',
            'image': 'assets/vitamink.png',
            'modelPath': 'assets/models/vitamin_k.glb',
            'shortDescription': 'Calcium regulator for arteries',
          },
          {
            "name": "Potassium",
            "normalModeDescription": "Potassium balances sodium levels in your body, which helps regulate blood pressure. It eases tension in blood vessel walls, supports proper heart contractions, and reduces the risk of stroke and hypertension. It’s essential for maintaining electrolyte balance and steady heartbeat.",
            'funModeDescription': "Potassium is your heart’s personal DJ! 🎧🎶 It drops the beat at just the right pace—no stress, no mess. It flushes out salty drama, keeps your blood pressure from spiking, and gets your heart thumping in rhythm like a pro playlist. 🍌🫀💃",
            'additionalInfo': 'Daily Value: 4000mg, Found in: Banana, Avocado, Sweet Potato, Spinach',
            'image': 'assets/potassium.png',
            'modelPath': 'assets/models/potassium.glb',
            'shortDescription': 'Balances blood pressure',
          },
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