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
            "normalModeDescription": "🍌 Bananas are a top-tier brain food because they’re rich in vitamin B6. \n \n 🍌 They help in the creation of neurotransmitters :- \n ★ Serotonin \n ★ Dopamine \n \n 🍌 Dopamine is critical for mood regulation and clear thinking. \n \n 🍌 They also supply natural sugars and potassium. \n \n 🍌 It gives your brain steady energy and helps maintain electrical conductivity between nerve cells. \n \n 🍌 Eating a banana in the morning can: \n • Improve learning capacity \n • Improve cognitive function \n • Help in the regulation of your mood throughout the day.",
            'funModeDescription': '🍌 Bananas are basically mood boosters with WiFi for your brain.💡\n \n 🍌 They drop that vitamin B6 to: \n ★ Charge your thoughts \n ★ Boost your vibes \n ★ Help you stay focused \n ★ Stop the "bruhhh" moments. \n \n 🍌 Eat one and you might just go from sleepy monkey to Einstein mode. 🧠⚡🐵',
            'additionalInfo': 'Calories: 89, Carbs: 23g, Protein: 1.1g, Vitamin B6: 33%, Potassium: 358mg',
            'image': 'assets/bananas.png',
            'modelPath': 'assets/models/banana.glb',
            'shortDescription': "Fuel for focus and memory"
          },
          {
            "name": "Blueberries",
            "normalModeDescription": "🫐 Blueberries contain powerful antioxidants known as anthocyanins. \n \n 🫐 This helps to:\n  ★ Lower bad cholesterol \n  ★ Support blood vessel function \n  ★ Reduce inflammation in the cardiovascular system  \n \n 🫐 Regular consumption improves circulation, strengthens blood vessels, and reduces risk of heart attacks.\n \n 🫐 They are low in calories but high in fiber and vitamin C—great for long-term heart health.",
            'funModeDescription': "🫐 Blueberries are heart ninjas in disguise! 🥷 \n \n 🫐 These bite-sized blue buddies: \n  1. Sneak through your bloodstream \n  2. Block the bad stuff \n  3. Gives your heart a hug. \n \n 🫐 They're so good, even your arteries do a happy dance when you munch on them. \n \n 🫐 Eat 'em fresh, frozen, or in your smoothie—your heart will totally thank you! 🫐💓✨",
            'additionalInfo': 'Calories: 57, Carbs: 14g, Fiber: 2.4g, Vitamin C: 16%',
            'image': 'assets/Blueberries.png',
            'modelPath': 'assets/models/blueberry.glb',
            'shortDescription': 'Tiny cholesterol fighters',
          },
          {
            "name": "Apple",
            "normalModeDescription": "🍎 Apples are rich in antioxidants like quercetin. \n \n 🍎 Quercetin defends brain cells from oxidative damage. \n \n 🍎 Their skin holds most of this power, so eat them whole. \n \n 🍎 Apples also contain soluble fiber and natural sugars that: \n ★ Enhance concentration and focus \n ★ Provide slow and stable energy \n \n 🍎 Apples are a perfect snack for long study sessions or focused work.",
            'funModeDescription': "🍎 Apples = brain snacks that slap ⚡ \n \n 🍎 Eat the skin and unlock quercetin XP to: \n ★ Stop your body from lagging \n ★ Fuel up your body 🚀⛽ \n ★ Protect your mental game. \n \n 🍎 Sweet, crunchy, and straight-up smart fuel. Core power activated! 💥📚",
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
            "🥬 Spinach is rich in brain-enhancing nutrients: \n • Folate \n • Lutein \n • Vitamin K \n \n 🥬 These help in: \n ★ Supporting neurotransmitter function \n ★ Improve brain plasticity \n ★ Reducing mental decline with age. \n \n 🥬 The antioxidants in spinach also protect neural tissues. \n \n 🥬 The iron content helps carry oxygen to the brain for optimal function.",
            "funModeDescription": "🥬 Spinach is like rocket fuel for your thoughts. 🚀\n \n 🥬 What it does: \n • Powers your focus \n • Shields your brain \n • Keeps your mental batteries fully charged. \n \n 🥬 Wanna be Popeye-smart? Get those greens in. 🧠💥💚",
            'additionalInfo': 'Calories: 23, Protein: 2.9g, Folate: 49%, Vitamin K: 460%, Iron: 15%',
            'image': 'assets/spinach.png',
            'modelPath': 'assets/models/spinach.glb',
            'shortDescription': 'Green fuel for brainpower'
          },
          {
            "name": "Red Onion",
            "normalModeDescription": "🧅 Red onions are packed with flavonoids and antioxidants. \n \n 🧅 These protect the brain from inflammation and cognitive aging. \n \n 🧅 Quercetin, a key compound in onions, improves memory by protecting neurons from damage and improving blood flow to the brain.",
            'funModeDescription': "🧅 Red onions? Brain zappers in disguise. 🧠 \n \n 🧅 They might make you cry, but they also keep your memory tight and your focus razor-sharp. \n \n 🧅 Cry now, glow up later. 💧⚔️",
            'additionalInfo': 'Calories: 40, Carbs: 9g, Vitamin C: 12%, Quercetin: 19.36 mg (per 100g), Fiber: 1.7g',
            'image': 'assets/redonion.png',
            'modelPath': 'assets/models/redonion.glb',
            'shortDescription': 'Zesty brain defender',
          },
          {
            "name": "Cucumber",
            "normalModeDescription": "🥒 Cucumbers are made up of 95% water, making them an excellent choice for hydration. \n \n 🥒 They are the key for optimal brain function. \n \n 🥒 They contain a unique antioxidant called fisetin. \n \n 🥒 Fisetin has been shown to improve memory and brain health. \n \n  🥒The high water content helps maintain proper circulation to the brain. \n \n 🥒 Cucumber supports overall cognitive function. \n \n 🥒 Eating cucumbers regularly can help boost brain performance and focus.",
            'funModeDescription': "🥒 Cucumbers are the brain’s hydration secret! \n \n 🥒 Super refreshing and full of antioxidants like fisetin. \n \n 🥒 They help you stay: \n • Sharp \n • Focused \n • Hydrated \n \n 🥒 It is perfect for those long study sessions!",
            'additionalInfo': 'Calories: 16, Carbs: 3.6g, Fiber: 0.5g, Vitamin K: 16% DV, Antioxidants: High (fisetin)',
            'image': 'assets/cucumber.png',
            'modelPath': 'assets/models/cucumber.glb',
            'shortDescription': 'Hydrates and boosts brain function',
          },
        ],
        "vitamins": [
          {
            "name": "Vitamin K",
            "normalModeDescription": "💊 Vitamin K helps direct calcium to your bones instead of your arteries. \n \n 💊 This prevents hardening and plaque formation. \n \n 💊 It also supports proper blood clotting. \n \n 💊 The proper working of it prevents excessive bleeding. \n \n 💊 It even protects your heart from blockages caused by calcification.",
            'funModeDescription': "💊 Vitamin K is the traffic cop for calcium! 🚦 \n \n 💊 It tells calcium where to go (to your bones!) and keeps it out of your blood pipes. \n \n 💊That means less clogging and more smooth sailing for your heart. \n \n 💊 It also keeps your blood from leaking all over—super handy! 🧠🚓🫀",
            'additionalInfo': 'Daily Value: 100mg, Found in: Kale, Spinach, Broccoli, Egg Yolk',
            'image': 'assets/vitamink.png',
            'modelPath': 'assets/models/vitamin_k.glb',
            'shortDescription': 'Calcium regulator for arteries',
          },
          {
            "name": "Vitamin B12",
            "normalModeDescription": "🩸 Vitamin B12 helps maintain nerve health. \n \n 🩸 It helps to: \n  ★ Forms red blood cells \n  ★ Aids in the production of brain chemicals \n  ★ Ultimately, affect mood and thinking. \n \n 🩸 Deficiency can lead to confusion, poor memory, and even depression. \n \n 🩸 It’s especially vital for kids and older adults.",
            'funModeDescription': "🩸 B12 = brain’s router. \n \n 🩸 No B12 = no signal. 📶🧠 \n \n 🩸 What it does: \n ★ Keep your focus sharp \n ★ Your brain online \n ★ Your chill intact. \n \n 🩸 Plug in or lag out. 🚫🧠",
            'additionalInfo': 'Daily Value: 2.4 mcg/day, Found in: Meat, dairy, eggs, fortified cereal',
            'image': 'assets/vitaminb12.png',
            'modelPath': 'assets/models/vitamin_b.glb',
            'shortDescription': 'Essential for focus & nerves',
          },
          {
            "name": "Vitamin E",
            "normalModeDescription": "🌻 Vitamin E is a fat-soluble antioxidant. \n \n 🌻 It protects the brain from free radical damage. \n \n 🌻 It slows cognitive decline and protects the brain's fatty membranes. \n \n 🌻 People with high vitamin E levels tend to retain stronger memory and attention spans as they age. \n \n 🌻 Sunflower seeds are one of the best sources of vitamin E.",
            'funModeDescription': "🌻 Vitamin E is the shield your brain didn’t know it needed. 🧠🛡️ \n \n 🌻 It helps in: ★ Blocking the bad stuff (free radicals) \n ★ Slowing the aging glitch \n ★ Boosting memory stats. \n \n 🌻 Equip vitamin E and dominate the game. 🕹️\n \n ❔What is the sunflower emoji doing here❔ \n \n 🌻 Sunflower seeds is like a nuclear source of Vitamin E, it can get you promoted to max health-level!",
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
            "🫀 Pomegranates are loaded with polyphenols and antioxidants like punicalagins. \n \n 🫀 These protect the heart by reducing oxidative stress and inflammation. \n \n 🫀 They help in: \n ★ Lowering blood pressure \n ★ Improve blood flow to the heart \n ★ Prevent artery walls from hardening. \n \n 🫀 This makes them a powerful natural remedy against heart disease. \n \n 🫀 Drinking pomegranate juice regularly can also reduce bad cholesterol and increase good cholesterol.",
            "funModeDescription": "🫀 Pomegranates are like tiny red warriors!💥 \n \n 🫀 They are packed with super shields called antioxidants. \n \n 🫀 They zoom through your blood and chase away the villains (bad fats and cholesterol). \n \n 🫀 They help in keeping: \n ★ Your heart beating strong \n ★ Blood pressure chill \n ★ Arteries squeaky clean. \n \n 🫀 Drink a glass of this ruby juice, and your heart will throw a party. 🍷💃",
            'additionalInfo': 'Calories: 83, Carbs: 19g, Fiber: 4g, Vitamin C: 17%',
            'image': 'assets/pomegranate.png',
            'modelPath': 'assets/models/pomegranate.glb',
            'shortDescription': 'Antioxidant powerhouse',
          },
          {
            "name": "Blueberries",
            "normalModeDescription": "🫐 Blueberries contain powerful antioxidants known as anthocyanins. \n \n 🫐 This helps to:\n  ★ Lower bad cholesterol \n  ★ Support blood vessel function \n  ★ Reduce inflammation in the cardiovascular system  \n \n 🫐 Regular consumption improves circulation, strengthens blood vessels, and reduces risk of heart attacks.\n \n 🫐 They are low in calories but high in fiber and vitamin C—great for long-term heart health.",
            'funModeDescription': "🫐 Blueberries are heart ninjas in disguise! 🥷 \n \n 🫐 These bite-sized blue buddies: \n  1. Sneak through your bloodstream \n  2. Block the bad stuff \n  3. Gives your heart a hug. \n \n 🫐 They're so good, even your arteries do a happy dance when you munch on them. \n \n 🫐 Eat 'em fresh, frozen, or in your smoothie—your heart will totally thank you! 🫐💓✨",
            'additionalInfo': 'Calories: 57, Carbs: 14g, Fiber: 2.4g, Vitamin C: 16%',
            'image': 'assets/Blueberries.png',
            'modelPath': 'assets/models/blueberry.glb',
            'shortDescription': 'Tiny cholesterol fighters',
          },
          {
            "name": "Avocado",
            "normalModeDescription": "🥑 Avocados are rich in monounsaturated fats. \n \n 🥑 These are healthy fats that help reduce bad cholesterol and increase good cholesterol. \n \n 🥑 They’re also full of potassium which helps in: \n ★ Controlling blood pressure \n ★ Contain antioxidants like lutein & vitamin E \n ★ Reducing heart strain and lowers the risk of heart disease. \n \n 🥑 They’re a creamy, delicious, and nutritious way to protect your heart.",
            'funModeDescription': "🥑 Avocados are like the smooth-talking bodyguards of your heart!💚\n \n 🥑 They kick out the bad cholesterol guests and roll out the red carpet for the good guys.\n \n 🥑 They’ve got potassium power—like bananas in stealth mode.\n \n 🥑 One bite of avo-toast, and your heart's like “let’s chill, we’re safe now.” 💪💓",
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
            " 🟣 Beetroot is rich in dietary nitrates. \n \n 🟣 They get converted into nitric oxide in the body. \n \n 🟣 It is a compound that relaxes and widens blood vessels. \n \n 🟣 This helps: \n  • Improve circulation \n  • Lower blood pressure \n  • Boost oxygen delivery throughout the body. \n \n 🟣 Regular consumption of beetroot: \n  ★ Supports a healthier cardiovascular system \n  ★ Increases stamina \n  ★ Improve cognitive function due to enhanced blood flow to the brain.",
            "funModeDescription": " 🟣 Beetroot’s like rocket fuel for your veins! 🚀 \n \n 🟣 What beetroot bro does: \n  1. It drops nitrates that turn into blood-boosting gas. \n  2. Opens up your blood highways for a smooth, pressure-free ride. \n \n 🟣 Your heart chills, your brain gets extra oxygen. \n \n 🟣 Your body’s like “let’s goooo!” One beet = beast mode! 🧠💪🫀",
            'additionalInfo': 'Calories: 43, Carbs: 9.6g, Fiber: 2.8g, Nitrates: ~250 mg per 100g',
            'image': 'assets/beetroot.png',
            'modelPath': 'assets/models/beetroot.glb',
            'shortDescription': 'Blood flow booster',
          },
          {
            "name": "Broccoli",
            "normalModeDescription": " 🥦 Broccoli is rich in fiber, sulforaphane, and other antioxidants. \n \n 🥦 These help lower inflammation in blood vessels. \n \n 🥦 Its nutrients support smoother circulation and reduce oxidative stress. \n \n 🥦 Broccoli also provides vitamin K and folate. \n \n 🥦 It is important for preventing calcium buildup and supporting heart muscle health.",
            'funModeDescription': " 🥦 Broccoli is the superhero tree that scrubs your blood roads clean! 🦸‍♂️🌳 \n \n 🥦 With fiber fists and antioxidant lasers, it zaps inflammation and keeps your veins free of junk. \n \n 🥦 Eat your broccoli, and your heart will zoom like a sports car. 💨💓",
            'additionalInfo': 'Calories: 34, Carbs: 6.6g, Fiber: 2.6g, Vitamin C: 89%',
            'image': 'assets/broccoli.png',
            'modelPath': 'assets/models/broccoli.glb',
            'shortDescription': 'Fiber and antioxidant defender',
          },
          {
            "name": "Tomato",
            "normalModeDescription": " 🍅 Tomatoes are full of lycopene! \n \n 🍅 Lycopene is a powerful antioxidant that: \n  • Reduces bad cholesterol \n  • Prevents plaque buildup in arteries \n  • Lowers blood pressure. \n \n 🍅 They also contain potassium and folate. \n \n They help in relaxing blood vessels and maintaining a healthy heartbeat. \n \n 🍅 Cooked tomatoes increase lycopene levels, making them even better for heart health.",
            'funModeDescription': " 🍅 Tomatoes are like red fire extinguishers for heart drama! 🔥 \n \n 🍅 They shoot out lycopene lasers that melt away artery gunk and cool down blood pressure. \n \n 🍅 Whether you're eating ketchup, pasta sauce, or a juicy slice. 👇 \n \n 🍅 Your heart’s doing cartwheels behind the scenes. 🧯🫀",
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
            " 🛡️ Vitamin C is an antioxidant! \n \n 🛡️ What it does: \n  • Prevents free radical damage to blood vessels \n  • Strengthens artery walls \n  • Helps the body produce collagen \n \n 🛡️ Collagen is a protein vital for healthy arteries. \n \n 🛡️ It also boosts the immune system and reduces overall inflammation, helping the cardiovascular system function smoothly.",
            "funModeDescription": " 🛡️ Vitamin C is like the duct tape for your blood tubes! 🛠️🍊 \n \n 🛡️ What it does: \n  • It seals cracks \n  • Blocks invaders \n  • Keeps your blood highways in tip-top shape \n \n 🛡️ Plus, it gives your immune system a big power-up, so your whole body’s ready for action. 💉🧡",
            'additionalInfo': 'Water-soluble vitamin, Daily Value: 90mg, Found in: Citrus, Kiwi, Guava, Bell Peppers',
            'image': 'assets/vitaminc.png',
            'modelPath': 'assets/models/vitamin_c.glb',
            'shortDescription': 'Vessel-strengthening vitamin',
          },
          {
            "name": "Vitamin K",
            "normalModeDescription": "💊 Vitamin K helps direct calcium to your bones instead of your arteries. \n \n 💊 This prevents hardening and plaque formation. \n \n 💊 It also supports proper blood clotting. \n \n 💊 The proper working of it prevents excessive bleeding. \n \n 💊 It even protects your heart from blockages caused by calcification.",
            'funModeDescription': "💊 Vitamin K is the traffic cop for calcium! 🚦 \n \n 💊 It tells calcium where to go (to your bones!) and keeps it out of your blood pipes. \n \n 💊That means less clogging and more smooth sailing for your heart. \n \n 💊 It also keeps your blood from leaking all over—super handy! 🧠🚓🫀",
            'additionalInfo': 'Daily Value: 100mg, Found in: Kale, Spinach, Broccoli, Egg Yolk',
            'image': 'assets/vitamink.png',
            'modelPath': 'assets/models/vitamin_k.glb',
            'shortDescription': 'Calcium regulator for arteries',
          },
          {
            "name": "Potassium",
            "normalModeDescription": " ⚡ Potassium balances sodium levels in your body. \n \n ⚡ They help in regulating blood pressure. \n \n ⚡ What it does: \n  • It eases tension in blood vessel walls \n  • Supports proper heart contractions \n  • Reduces the risk of stroke and hypertension. \n \n ⚡ It’s essential for maintaining electrolyte balance and steady heartbeat.",
            'funModeDescription': " ⚡ Potassium is your heart’s personal DJ! 🎧🎶 \n \n ⚡ It drops the beat at just the right pace—no stress, no mess. \n \n ⚡ What potassium bro does: \n  • It flushes out salty drama \n  • Keeps your blood pressure from spiking \n  • Gets your heart thumping in rhythm like a pro playlist.",
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
        "fruits": [
          {
            "name": "Mango",
            "normalModeDescription": " 🥭 Mangoes are rich in beta-carotene.\n \n 🥭 The body converts beta-carotene into vitamin A \n \n 🥭 Vitamin A is an essential nutrient for maintaining a healthy retina and preventing night blindness.\n \n 🥭 They also contain zeaxanthin which is a powerful antioxidant. \n \n 🥭 Zeaxanthin filters harmful blue light and protects the eyes from age-related damage.",
            "funModeDescription": " 🥭 Mangoes = sunglasses for your eyeballs!😎\n \n 🥭 Packed with vitamin A and eye-protecting antioxidants. \n \n 🥭 They keep your vision crystal clear and stylishly safe.",
            "additionalInfo": "Calories: 60, Carbs: 15g, Fiber: 1.6g, Vitamin A: 21% DV",
            "image": "assets/mango.png",
            "modelPath": "assets/models/mango.glb",
            "shortDescription": "Sweet source of eye-protection"
          },
          {
            "name": "Blackberries",
            "normalModeDescription": " 🍇 Blackberries are high in anthocyanins and vitamin C. \n \n 🍇 Both of which play a role in eye health. \n \n 🍇 Anthocyanins help strengthen capillaries in the eyes and improve blood flow to the retina. \n \n 🍇 Vitamin C contributes to the repair and protection of eye tissues.",
            'funModeDescription': " 🍇 Blackberries are like little dark orbs of eye magic 🪄. \n \n 🍇They are packed with anthocyanins and vitamin C. \n \n 🍇 What blackberry homies do: \n  1. They swoop in to protect your retina \n  2. Keep your eye blood vessels chill \n  3. Slow down aging like they’re reversing time. \n \n 🍇 Pop a few and thank them later when you’re spotting typos from across the room. 👓✨",
            'additionalInfo': 'Calories: 43, Carbs: 10g, Fiber: 5.3g, Vitamin C: 35%, Anthocyanins: High',
            'image': 'assets/blackberry.png',
            'modelPath': 'assets/models/blackberries.glb',
            'shortDescription': 'Full of antioxidants for sharp vision',
          },
          {
            "name": "Kiwi",
            "normalModeDescription": " 🥝 Kiwis are incredibly rich in vitamin C, even more than oranges! \n \n 🥝 This antioxidant helps: \n  • Protect the eyes from free radical damage \n  • Supports collagen in the cornea \n  • Reduce the risk of cataracts and macular degeneration. \n \n 🥝 Kiwis also provide small amounts of lutein and zeaxanthin, boosting their eye-friendly profile.",
            'funModeDescription': " 🥝 Kiwi is like a tiny fuzzy bodyguard for your eyeballs 🕶️.\n \n 🥝 Bursting with vitamin C, it: \n  • Builds up collagen like a boss \n  • Blocks those age-gremlins from your retina \n  • Throws in bonus lutein to keep things HD. \n \n 🥝 One bite and your eyes are flexing in 4K.",
            'additionalInfo': 'Calories: 41, Carbs: 10g, Fiber: 2.1g, Vitamin C: 154%',
            'image': 'assets/kiwi.png',
            'modelPath': 'assets/models/kiwi.glb',
            'shortDescription': 'Powerhouse for sharp & protected vision',
          },
        ],
        "vegetables": [
          {
            "name": "Carrot",
            "normalModeDescription": " 🥕 Carrots are loaded with beta-carotene! \n \n 🥕 Beta-carotene is a precursor to vitamin A, which is essential for good vision and eye surface health. \n \n 🥕 They help prevent xerophthalmia (dry eye) and night blindness. \n \n 🥕 Carrots support the immune function of the eyes.",
            'funModeDescription': " 🥕 Carrots are the OG vision guardians 🧡. \n \n 🥕 They’ve been rocking the eye-care throne forever! \n \n 🥕 It's all thanks to beta-carotene turning into vitamin A! \n \n 🥕 It then starts defending your peepers from \n  1. Dryness \n  2. Blurriness \n  3. Night blindness. \n \n 🥕 Want laser eyes? Crunch a few of these and prepare to see like a hawk. 🦅💥",
            'additionalInfo': 'Calories: 41, Carbs: 10g, Fiber: 2.8g, Vitamin A: 334%, Beta-carotene: High',
            'image': 'assets/carrots.png',
            'modelPath': 'assets/models/carrot.glb',
            'shortDescription': 'Rich in beta-carotene',
          },
          {
            "name": "Kale",
            "normalModeDescription": " 🥬 Kale is one of the best sources of lutein and zeaxanthin! \n \n 🥬 These antioxidants that protect the retina from harmful light and oxidative stress. \n \n 🥬 It also contains vitamin C and beta-carotene. \n \n 🥬 Eating it will result in healthy vision and eye tissue regeneration.",
            'funModeDescription': " 🥬 Kale's not just for health nuts—it’s retina royalty 👑.\n \n 🥬 Lutein + zeaxanthin = elite squad guarding your eyes from blue light and screen strain. \n \n 🥬 It’s like giving your eyes a daily detox and a defense shield. \n \n 🥬 Wanna slay screen time and still see 20/20? Go green.",
            'additionalInfo': 'Calories: 35, Carbs: 4.4g, Fiber: 4g, Lutein & Zeaxanthin: High, Vitamin C: 200%',
            'image': 'assets/kale.png',
            'modelPath': 'assets/models/kale.glb',
            'shortDescription': 'Lutein-packed for retinal protection',
          },
          {
            "name": "Red Bell Pepper",
            "normalModeDescription": " 🌶️ Red bell peppers are a top source of vitamin C and beta-carotene. \n \n 🌶️ These nutrients help maintain the health of eye blood vessels and prevent cataracts. \n \n 🌶️ Their vibrant pigments also support the macula, the part of the retina responsible for central vision.",
            'funModeDescription': " 🌶️ Red bell peppers are spicy vision boosters 🔥👁️. \n \n 🌶️ Full of vitamin C and beta-carotene, they work behind the scenes: \n  • Repairing eye tissue \n  • Boosting collagen \n  • Keeping your central vision crisp. \n \n 🌶️ Basically, they’re eye glow-up fuel. Eat red, see sharp.",
            'additionalInfo': 'Calories: 31, Carbs: 6g, Fiber: 2.1g, Vitamin C: 213%, Beta-carotene: High',
            'image': 'assets/redbellpepper.png',
            'modelPath': 'assets/models/red_bell_pepper.glb',
            'shortDescription': 'Bright color, brighter vision',
          },
        ],
        "vitamins": [
          {
            "name": "Vitamin A",
            "normalModeDescription": " 👁️ Vitamin A is critical for converting light into neural signals in the retina. \n \n 👁️ It protects the eye surface (cornea) and prevents night blindness. \n \n 👁️ Deficiency can lead to dry eyes and vision loss.",
            'funModeDescription': " 👁️ Vitamin A = boss mode for night vision🕶️🌌. \n \n 👁️ What it does: \n  • It helps your retina pick up light \n  • Keeps your eye surface slick \n  • Fights off dryness like a champ. \n \n 👁️ Think of it as auto-focus for your vision—even in low light. \n \n 👁️ Wanna see in the dark? A-level eyes only.",
            'additionalInfo': 'Water-soluble vitamin, Daily Value: 75–90 mg, Found in: red pepper, kiwi, citrus, berries',
            'image': 'assets/vitamina.png',
            'modelPath': 'assets/models/vitamin_a.glb',
            'shortDescription': 'Essential for vision and retina health',
          },
          {
            "name": "Lutein",
            "normalModeDescription": " ☀️ Lutein is a carotenoid that accumulates in the retina and acts as a light filter. \n \n ☀️ What it does: \n  • Protects the eyes from harmful blue light and oxidative stress \n  • Reduces risk of macular degeneration and cataracts.",
            'funModeDescription': " ☀️ Lutein is the real MVP of eye armor 🛡️🌿. \n \n ☀️ What it does: \n  • It filters out blue light \n  • Reduces strain \n  • Protects that sweet spot in your eye which is the macula. \n \n ☀️ More lutein = less blur, less damage, and more clarity. You can literally see the difference",
            'additionalInfo': 'Antioxidant carotenoid, Daily Value: ~10 mg (no official RDA), Found in: kale, spinach, corn',
            'image': 'assets/lutein.png',
            'modelPath': 'assets/models/lutein.glb',
            'shortDescription': 'Shields eyes from light damage',
          },
          {
            "name": "Vitamin C",
            "normalModeDescription": " 🛡️ Vitamin C is an antioxidant that: \n  • Supports collagen production in the eyes \n  • Protects against oxidative damage \n  • Help delay or prevent cataracts. \n \n 🛡️ It strengthens eye blood vessels and supports tear film health.",
            'funModeDescription': " 🛡️ Vitamin C is like skincare for your eyeballs 🧴👁️. \n \n 🛡️ What it does: \n  • It builds collagen \n  • Keeps your blood vessels strong \n  • Fights off cataracts like a ninja. \n \n 🛡️ Want your vision glowing and forever young? This is your go-to glow-up vitamin.",
            'additionalInfo': 'Water-soluble vitamin, Daily Value: 75–90 mg, Found in: Citrus, Kiwi, Guava, Bell Peppers',
            'image': 'assets/vitaminc.png',
            'modelPath': 'assets/models/vitamin_c.glb',
            'shortDescription': 'Fights eye aging',
          },
        ],
        "nfunFact": "Your eyes blink approximately 12,000 times a day, helping to keep them moist and protect them from dust and irritants.",
        "ffunFact": "Eyes can spot over 10 million colors—total visual GOATs.",
        "funFactImage": "assets/gif/eye_fact.gif"
      },
      "Lungs": {
        "image": "assets/models/lungs.glb",
        "briefInfo": "Lungs are vital organs that exchange oxygen and carbon dioxide, enabling you to breathe and support essential functions throughout your body.",
        "briefInfoFun": "Lungs = oxygen in, CO2 out—airflow GOATs keeping you alive. ",
        "fruits": [
          {
            "name": "Pineapple",
            "normalModeDescription": " 🍍 Pineapple contains bromelain! \n \n 🍍 Bromelain is an enzyme known to: \n  • Reduce lung inflammation \n  • Break down mucus \n  • Improve breathing \n \n 🍍 It also has a good dose of vitamin C, which supports lung immunity.",
            'funModeDescription': " 🍍 Pineapple’s that juicy tropical lung-sweeper 🧼! \n \n 🍍 Bromelain’s the cleanup crew: \n  • It melts away mucus like a pro \n  • Keeps airways chill \n  • Brings a vitamin C punch for immune backup. \n \n 🍍 Take a bite, and your lungs are like “thank u next” to congestion.",
            'additionalInfo': 'Calories: 50, Carbs: 13g, Fiber: 1.4g, Vitamin C: 79%, Bromelain: Present',
            'image': 'assets/pineapple.png',
            'modelPath': 'assets/models/pineapple.glb',
            'shortDescription': 'Tropical lung-cleansing fruit',
          },
          {
            "name": "Apple",
            "normalModeDescription": " 🍎 Apples are rich in quercetin! \n \n 🍎 Quercetin is an antioxidant flavonoid that helps: \n  • Reduce asthma symptoms \n  • Lung inflammation \n \n 🍎 Long-term apple consumption is linked to improved lung capacity and lower risk of respiratory diseases.",
            'funModeDescription': " 🍎 Apples are the OG clean freaks 🫧. \n \n 🍎 They’re like:- \n “Yo lungs! let’s sweep up this inflammation mess and freshen the airways real quick.” \n \n 🍎 With quercetin as their secret weapon, they block out the bad vibes from: \n  • Smoke \n  • Dust \n  • City air \n \n 🍎 Basically, every crunch is a mic-drop moment for your breathing game. Clean lungs? Say less.",
            'additionalInfo': 'Calories: 52, Carbs: 13.8g, Fiber: 2.4g, Vitamin C: 7% DV, Quercetin: 4.42 mg/100g',
            'image': 'assets/apples.png',
            'modelPath': 'assets/models/apple.glb',
            'shortDescription': 'Antioxidant-rich lung fruit.',
          },
          {
            "name": "Blueberries",
            "normalModeDescription": " 🫐 Blueberries are loaded with anthocyanins! \n \n 🫐 These protect lung tissues from oxidative stress. \n \n 🫐 These antioxidants can help in: \n • Slowing lung function decline \n  • Reduce inflammation. \n \n 🫐 This makes them excellent for respiratory resilience.",
            'funModeDescription': " 🫐 Blueberries = your lungs' favorite squad 💙. \n \n 🫐 With anthocyanins on defense, they guard your airways like a security system! \n \n 🫐 They keep you breathing smooth, strong, and stress-free. \n \n 🫐 Small fruit, big flex.",
            'additionalInfo': 'Calories: 57, Carbs: 14g, Fiber: 2.4g, Vitamin C: 16%',
            'image': 'assets/Blueberries.png',
            'modelPath': 'assets/models/blueberry.glb',
            'shortDescription': 'Tiny berries, mighty for lungs',
          },
        ],
        "vegetables": [
          {
            "name": "Cauliflower",
            "normalModeDescription": " 🥦 Cauliflower contains isothiocyanates! \n \n 🥦 This and a few other compounds help detoxify the lungs and reduce oxidative damage. \n \n 🥦 Its anti-inflammatory nature supports clean, efficient respiration and lowers the risk of lung disease.",
            'funModeDescription': " 🥦 Cauliflower's the white ninja of lung care 🥷. \n \n 🥦 With its detox powers, it clears out junk like it’s sweeping the vents. \n \n 🥦 No drama, no buildup—just straight-up clean breathing vibes.",
            'additionalInfo': 'Calories: 149, Carbs: 33g, Fiber: 2.1g, Allicin: High, Vitamin C: 15%',
            'image': 'assets/cauliflower.png',
            'modelPath': 'assets/models/cauliflower.glb',
            'shortDescription': 'Lung-cleansing cruciferous veggie',
          },
          {
            "name": "Garlic",
            "normalModeDescription": " 🧄 Garlic contains allicin! \n \n 🧄 Allicin is a sulfur-based compound that acts as a natural antibiotic. \n \n 🧄 It helps: \n  • Reduce lung inflammation \n  • Breaks up mucus \n  • Enhances the lungs' ability to fight infections. \n \n 🧄 Garlic is particularly beneficial for individuals exposed to air pollution or who suffer from chronic bronchial conditions. \n \n 🧄 Its anti-inflammatory and immune-boosting properties make it a powerful tool for long-term lung protection.",
            'funModeDescription': " 🧄 Garlic doesn’t play—it SLAYS 🔥. \n \n 🧄 With allicin as its weapon, it fights off lung invaders \n  1. Viruses \n  2. Bacteria \n  3. Toxic air \n like it’s in an action movie. \n \n 🧄 Got congestion? Garlic smashes through that like a battering ram. \n \n 🧄 Your lungs are basically in beast mode when this spicy legend is on the menu. \n \n 🧄 Powerful, punchy, and lowkey a breath boss.",
            'additionalInfo': 'Calories: 149, Carbs: 33g, Fiber: 2.1g, Allicin: High, Vitamin C: 15%',
            'image': 'assets/garlic.png',
            'modelPath': 'assets/models/garlic.glb',
            'shortDescription': 'Natural lung-clearing antibiotic.',
          },
        ],
        "vitamins": [
          {
            "name": "Vitamin D",
            "normalModeDescription": " ☀️ Vitamin D plays a regulatory role in lung immunity and inflammation. \n \n ☀️ It helps modulate immune responses to infections and has been shown to reduce the risk of respiratory issues like: \n  1. Asthma \n  2. Chronic bronchitis. \n \n ☀️ Sun exposure is the best natural source! \n \n ☀️ Dietary intake is crucial for those with limited sunlight.",
            'funModeDescription': " ☀️ Vitamin D is basically sunshine bottled up for your chest ️🫁. \n \n ☀️ It’s like “Calm down, immune system”! \n \n ☀️ It keeps inflammation low-key while powering up your lung defenses. \n \n ☀️ Cold? Pollution? Smog? \nVitamin D just sun-blasts them out of the way so you can inhale peace and exhale strength.",
            'additionalInfo': 'Fat-soluble, Daily Need: 600–800 IU, Found in: sunlight, mushrooms, eggs, fortified foods',
            'image': 'assets/vitamind.png',
            'modelPath': 'assets/models/vitamin_d.glb',
            'shortDescription': 'Regulates lung immunity and inflammation.',
          },
        ],
        "nfunFact": "Your lungs are incredible multitaskers—they take in about 11,000 liters of air every day while filtering out harmful particles to keep you breathing smoothly!",
        "ffunFact": " Lungs are on grind mode—20K breaths a day without skipping a beat.",
        "funFactImage": "assets/gif/lung_fact.gif"
      },
      "Stomach": {
        "image": "assets/models/stomach.glb",
        "briefInfo": "The stomach is responsible for breaking down food using strong acids and enzymes, aiding digestion and nutrient absorption.",
        "briefInfoFun": "Stomach melts food, fuels you, and keeps vibes chill.",
        "fruits": [
          {
            "name": "Papaya",
            "normalModeDescription": " 🍐 Papaya contains papain! \n \n 🍐 Papain is an enzyme that helps: \n  • Break down proteins in the stomach \n  • Making digestion easier \n  • It reduces bloating \n  • Alleviate symptoms of indigestion or gas. \n \n 🍐 Papaya is also anti-inflammatory and high in water and fiber! \n \n 🍐 This promotes smooth and regular digestion, reducing strain on the stomach.",
            'funModeDescription': " 🍐 Papaya’s like the chill bouncer at your stomach’s VIP party 🕶.\n \n 🍐 Papain shows up, breaks down those protein troublemakers, and keeps bloating drama out the door. \n \n 🍐 Say goodbye to “stomach going kaboom” and hello to tropical tummy vibes. \n \n 🍐 Smooth digestion, no gas, no stress.",
            'additionalInfo': 'Calories: 43, Carbs: 11g, Protein: 0.5g, Fiber: 1.7g, Vitamin C: 75%, Vitamin A: 22%, Enzyme: Papain',
            'image': 'assets/papaya.png',
            'modelPath': 'assets/models/papaya.glb',
            'shortDescription': 'Digestive enzyme hero',
          },
        ],
        "vegetables": [
          {
            "name": "Sweet Potato",
            "normalModeDescription": " 🍠 Sweet potatoes are alkaline and help reduce stomach acidity. \n \n 🍠 They are rich in fiber, potassium, and manganese, which support the digestive process. \n \n 🍠 The resistant starch in sweet potato: \n  • Promotes beneficial bacteria growth \n  • Enhances gut function \n  • Reduces gastric inflammation.",
            'funModeDescription': " 🍠 Sweet potato’s the soft, warm hug your stomach craves 🧸. \n \n 🍠 What sweetie potato bro does: \n  1. It chills the acid \n  2. Feeds the good gut gang \n  3. Keeps everything cozy \n  4. Balances everything inside. \n \n 🍠 It’s like a cozy sweatshirt—but for your digestion.",
            'additionalInfo': 'Calories: 86, Carbs: 20g, Fiber: 3g, Protein: 1.6g, Vitamin A: 283%, Resistant Starch: Present',
            'image': 'assets/sweet potato.png',
            'modelPath': 'assets/models/sweet_potato.glb',
            'shortDescription': '',
          },
          {
            "name": "Carrot",
            "normalModeDescription": " 🥕 Carrots are high in soluble fiber and beta-carotene! \n \n 🥕 These support mucosal health and reduce inflammation in the stomach lining. \n \n 🥕 Their natural alkalinity helps balance stomach acid and improve digestion. \n \n 🥕 They also stimulate bile production, aiding fat breakdown.",
            'funModeDescription': " 🥕 Carrots are like crunchy peacekeepers for your tummy 🕊️. \n \n 🥕 What do them carrot homies do: \n • They chill your acid levels \n  • Soften your insides with fiber \n  • Keep your stomach walls smooth and comfy. \n \n 🥕 Add ‘em raw or cooked, and your gut’s like “omg yas, comfort food vibes.”",
            'additionalInfo': 'Calories: 41, Carbs: 10g, Fiber: 2.8g, Vitamin A: 334%, Beta-carotene: High',
            'image': 'assets/carrots.png',
            'modelPath': 'assets/models/carrot.glb',
            'shortDescription': '',
          },
        ],
        "vitamins": [
          {
            "name": "Vitamin B1",
            "normalModeDescription": " ⚡ Vitamin B1 (thiamine) plays a crucial role in maintaining a healthy digestive system! \n \n ⚡ It stimulates the production of hydrochloric acid in the stomach. \n \n ⚡ This acid is essential for breaking down food effectively and preparing nutrients for absorption in the intestines. \n \n ⚡ Thiamine: \n  • Supports proper nerve function in the gastrointestinal tract \n  • Helps regulate muscle contractions and coordination \n  • Help in the movement of food smoothly through the digestive system.",
            'funModeDescription': " ⚡ Vitamin B1 AKA Thiamine is like the ignition key for your digestive engine 🚗💊.\n \n ⚡ What happens the moment food hits your mouth: \n  • It’s already revving things up \n  • Turns on the acid \n  • Sparking the belly into action \n  • Syncing your whole gut squad like a well-oiled machine.  \n \n ⚡ It’s the hype coach in your system, yelling “LET’S GOOOOO” every time you eat 🍽️🔥. \n \n ⚡ No B1? Your stomach’s just sitting there, confused and sluggish.",
            'additionalInfo': 'Water-soluble, Daily Need: 1.3–1.7 mg, Found in: bananas, fish, potatoes, avocado',
            'image': 'assets/vitaminb.png',
            'modelPath': 'assets/models/vitamin_b1.png',
            'shortDescription': 'Anti-nausea helper',
          },
        ],
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