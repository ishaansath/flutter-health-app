import 'package:shared_preferences/shared_preferences.dart';

final Map<String, Map<String, dynamic>> organData = {
  "Brain": {
    "image": "assets/models/brain.glb",
    "briefInfo": "The brain is the central command center of your body, responsible for controlling thoughts, movements, and vital functions",
    "briefInfoFun": "The control tower, sparking thoughts, moves, and genius ideas",
    "fruits": [
      {
        "name": "Banana",
        "normalModeDescription": " 🍌 Bananas are a top-tier brain food because they’re rich in vitamin B6. \n \n 🍌 They help in the creation of neurotransmitters :- \n ★ Serotonin, \n ★ Dopamine. \n \n 🍌 Dopamine is critical for mood regulation and clear thinking. \n \n 🍌 They also supply natural sugars and potassium. \n \n 🍌 It gives your brain steady energy and helps maintain electrical conductivity between nerve cells. \n \n 🍌 Eating a banana in the morning can: \n • Improve learning capacity, \n • Improve cognitive function, \n • Help in the regulation of your mood throughout the day.",
        'funModeDescription': ' 🍌 Bananas are basically mood boosters with WiFi for your brain.💡\n \n 🍌 They drop that vitamin B6 to: \n ★ Charge your thoughts, \n ★ Boost your vibes, \n ★ Help you stay focused, \n ★ Stop the "bruhhh" moments. \n \n 🍌 Eat one and you might just go from sleepy monkey to Einstein mode. 🧠⚡🐵',
        'additionalInfoExtra': 'ℹ️ Calories: 89 \nℹ️ Carbohydrates: 23g \nℹ️ Protein: 1.1g \nℹ️ Vitamin B6: 33% \nℹ️ Potassium: 358mg',
        'additionalInfo': 'additionalInfo test',
        'image': 'assets/bananas.png',
        'modelPath': 'assets/models/banana.glb',
        'shortDescription': "Fuel for focus and memory",
      },
      {
        "name": "Blueberries",
        "normalModeDescription": "🫐 Blueberries contain powerful antioxidants known as anthocyanins. \n \n 🫐 This helps to:\n  ★ Lower bad cholesterol, \n  ★ Support blood vessel function, \n  ★ Reduce inflammation in the cardiovascular system.  \n \n 🫐 Regular consumption improves circulation, strengthens blood vessels, and reduces risk of heart attacks.\n \n 🫐 They are low in calories but high in fiber and vitamin C—great for long-term heart health.",
        'funModeDescription': "🫐 Blueberries are heart ninjas in disguise! 🥷 \n \n 🫐 These bite-sized blue buddies: \n  1. Sneak through your bloodstream, \n  2. Block the bad stuff, \n  3. Gives your heart a hug. \n \n 🫐 They're so good, even your arteries do a happy dance when you munch on them. \n \n 🫐 Eat 'em fresh, frozen, or in your smoothie—your heart will totally thank you! 🫐💓✨",
        'additionalInfoExtra': ' ℹ️ Calories: 57, \n ℹ️ Carbs: 14g, \n ℹ️Fiber: 2.4g,  \n ℹ️ Vitamin C: 16%',
        'additionalInfo': '',
        'image': 'assets/Blueberries.png',
        'modelPath': 'assets/models/blueberry.glb',
        'shortDescription': 'Tiny cholesterol fighters',
      },
      {
        "name": "Apple",
        "normalModeDescription": "🍎 Apples are rich in antioxidants like quercetin. \n \n 🍎 Quercetin defends brain cells from oxidative damage. \n \n 🍎 Their skin holds most of this power, so eat them whole. \n \n 🍎 Apples also contain soluble fiber and natural sugars that: \n ★ Enhance concentration and focus \n ★ Provide slow and stable energy \n \n 🍎 Apples are a perfect snack for long study sessions or focused work.",
        'funModeDescription': "🍎 Apples = brain snacks that slap. ⚡ \n \n 🍎 Eat the skin and unlock quercetin XP to: \n ★ Stop your body from lagging, \n ★ Fuel up your body, 🚀⛽ \n ★ Protect your mental game. \n \n 🍎 Sweet, crunchy, and straight-up smart fuel. Core power activated! 💥📚",
        'additionalInfoExtra': ' ℹ️ Calories: 52, \n ℹ️ Carbs: 13.8g, \n ℹ️ Fiber: 2.4g, \n ℹ️ Vitamin C: 7% DV, \n ℹ️ Quercetin: 4.42 mg/100g',
        'additionalInfo': '',
        'image': 'assets/apples.png',
        'modelPath': 'assets/models/apple.glb',
        'shortDescription': 'Crunchy and juicy support',
      },
      {
        "name": "Peach",
        "normalModeDescription": " 🍑 Peaches are a solid source of: \n - Vitamin C, \n - Vitamin A, \n - Niacin (B3). \n \n 🍑 All of these help protect neurons and support healthy brain function. \n \n 🍑 The antioxidants in peaches, including chlorogenic acid, help fight oxidative stress in the brain, reducing cognitive decline over time. \n \n 🍑  They also help maintain healthy blood vessels, improving oxygen delivery to the brain. \n \n 🍑 The natural sugars provide gentle energy without blood sugar crashes, supporting mental clarity",
        'funModeDescription': " 🍑 Peaches are soft, sweet brain-huggers 🧠💛. \n \n 🍑 With vitamin C and B3 on deck, they keep your brain cells buzzing and your vibes high. \n \n 🍑 The antioxidants? They’re like your brain’s skincare routine—fighting wrinkles on your neurons, not your face. \n \n 🍑 Plus, those natural sugars give you a smooth energy boost. \n \n 🍑 Your memory gets the peach glow-up, and your brain’s like “yeah, I’m super fresh.”",
        'additionalInfoExtra': ' ℹ️ Calories: 39, \n ℹ️ Carbs: 10g, \n ℹ️ Fiber: 1.5g, \n ℹ️ Vitamin C: 11% DV, \n ℹ️ Vitamin A: 6% DV, \n ℹ️ Niacin (B3): 6% DV, \n ℹ️Antioxidants: Chlorogenic acid, polyphenols',
        'additionalInfo': '',
        'image': 'assets/peach.png',
        'modelPath': 'assets/models/peach.glb',
        'shortDescription': 'Memory-friendly fruit',
      },
      {
        "name": "Watermelon",
        "normalModeDescription": " 🍉 Watermelon is more than just a summer snack. \n \n 🍉 It’s a hydration powerhouse that plays a vital role in brain performance. \n \n 🍉 With over 91% water content, it helps prevent dehydration. \n \n 🍉 It’s rich in L-citrulline, an amino acid that enhances blood circulation, helping deliver more oxygen and nutrients to brain tissues. \n \n 🍉 Watermelon also offers vitamin B6. \n \n 🍉 Vitamin B6 assists in the production of mood-stabilizing neurotransmitters like serotonin and dopamine. \n \n 🍉 Watermelon is a refreshing way to recharge the mind while keeping the body cool.",
        'funModeDescription': " 🍉 Watermelon’s that red, juicy legend your brain’s been begging for 🧠💦. \n \n 🍉 It's like giving your mind a splash of spa-level hydration. \n \n 🍉 With 91% water, it clears out the mental fog like a power washer. \n \n 🍉 L-citrulline keeps that blood flowing like a boss, sending nutrients straight to your body. \n \n 🍉 B6 is in the party too, balancing your mood and giving you main-character focus energy. \n \n 🍉 And the lycopene? That’s your brain’s personal bodyguard against stress and burnout.\n \n 🍉 Basically, it's a fruity energy drink in nature’s packaging—no cap.",
        'additionalInfo': '',
        'additionalInfoExtra': ' ℹ️ Calories: 30, \n ℹ️ Carbohydrates: 7.6g, \n ℹ️ Protein: 0.6g, \n ℹ️ Fiber: 0.4g, \n ℹ️ Water Content: 91%, \n ℹ️ Vitamin B6: 4% DV, \n ℹ️ Vitamin C: 8% DV, \n ℹ️ Lycopene: ~4.5 mg, \n ℹ️ L-citrulline: Present in flesh and rind, \n ℹ️ Fat: 0.2g',
        'image': 'assets/watermelon.png',
        'modelPath': 'assets/models/watermelon.glb',
        'shortDescription': 'Hydrating brain refresher',
      },
    ],
    "vegetables": [
      {
        "name": "Spinach",
        "normalModeDescription":
        "🥬 Spinach is rich in brain-enhancing nutrients: \n • Folate, \n • Lutein, \n • Vitamin K. \n \n 🥬 These help in: \n ★ Supporting neurotransmitter function, \n ★ Improve brain plasticity, \n ★ Reducing mental decline with age. \n \n 🥬 The antioxidants in spinach also protect neural tissues. \n \n 🥬 The iron content helps carry oxygen to the brain for optimal function.",
        "funModeDescription": "🥬 Spinach is like rocket fuel for your thoughts. 🚀\n \n 🥬 What it does: \n • Powers your focus, \n • Shields your brain, \n • Keeps your mental batteries fully charged. \n \n 🥬 Wanna be Popeye-smart? Get those greens in. 🧠💥💚",
        'additionalInfoExtra': ' ℹ️ Calories: 23, \n ℹ️ Protein: 2.9g, \n ℹ️ Folate: 49%, \n ℹ️ Vitamin K: 460%, \n ℹ️ Iron: 15%',
        'additionalInfo': '',
        'image': 'assets/spinach.png',
        'modelPath': 'assets/models/spinach.glb',
        'shortDescription': 'Green fuel for brainpower'
      },
      {
        "name": "Red Onion",
        "normalModeDescription": "🧅 Red onions are packed with flavonoids and antioxidants. \n \n 🧅 These protect the brain from inflammation and cognitive aging. \n \n 🧅 Quercetin, a key compound in onions, improves memory by protecting neurons from damage and improving blood flow to the brain.",
        'funModeDescription': "🧅 Red onions? Brain zappers in disguise. 🧠 \n \n 🧅 They might make you cry, but they also keep your memory tight and your focus razor-sharp. \n \n 🧅 Cry now, glow up later. 💧⚔️",
        'additionalInfoExtra': 'Calories: 40, Carbs: 9g, Vitamin C: 12%, Quercetin: 19.36 mg (per 100g), Fiber: 1.7g',
        'additionalInfo': '',
        'image': 'assets/redonion.png',
        'modelPath': 'assets/models/redonion.glb',
        'shortDescription': 'Zesty brain defender',
      },
      {
        "name": "Cucumber",
        "normalModeDescription": "🥒 Cucumbers are made up of 95% water, making them an excellent choice for hydration. \n \n 🥒 They are the key for optimal brain function. \n \n 🥒 They contain a unique antioxidant called fisetin. \n \n 🥒 Fisetin has been shown to improve memory and brain health. \n \n  🥒The high water content helps maintain proper circulation to the brain. \n \n 🥒 Cucumber supports overall cognitive function. \n \n 🥒 Eating cucumbers regularly can help boost brain performance and focus.",
        'funModeDescription': "🥒 Cucumbers are the brain’s hydration secret! \n \n 🥒 Super refreshing and full of antioxidants like fisetin. \n \n 🥒 They help you stay: \n • Sharp, \n • Focused, \n • Hydrated. \n \n 🥒 It is perfect for those long study sessions!",
        'additionalInfoExtra': ' ℹ️ Calories : 16, \n ℹ️ Carbs: 3.6g, \n ℹ️ Fiber: 0.5g, \n ℹ️ Vitamin K: 16%, \n ℹ️ Antioxidants: High (fisetin)',
        'additionalInfo': '',
        'image': 'assets/cucumber.png',
        'modelPath': 'assets/models/cucumber.glb',
        'shortDescription': 'Hydrates and boosts brain function',
      },
      {
        "name": "Cauliflower",
        "normalModeDescription": " 🥦 Cauliflower is a brain-boosting powerhouse disguised as a simple white veggie. \n \n 🥦 It’s packed with choline, a nutrient crucial for: \n • Neurotransmitter production, \n • Memory retention \n • Mental sharpness. \n \n 🥦 Choline also helps in maintaining the structural integrity of brain cells and improves signal transmission between neurons. \n \n 🥦 Cauliflower is rich in vitamin C, vitamin K, and glucosinolates, which support detoxification and reduce brain inflammation. \n \n 🥦 Its antioxidants help combat oxidative stress that can otherwise damage brain cells over time.",
        'funModeDescription': " 🥦 Cauliflower is the undercover genius of the veggie squad 🧠⚡. \n \n 🥦 It is white, fluffy, and low-key brilliant. \n \n 🥦 It’s got choline, which keeps your memory smooth and signals strong. \n \n 🥦 Add in some antioxidants and anti-inflammatory power. \n \n 🥦 It’s basically mental armor in food form. \n \n 🥦 Want to avoid brain fog? Munch this veggie cloud. \n \n 🥦 Roast it, mash it like potatoes, or throw it in a stir-fry. \n \n 🥦 Cauliflower is the low-cal legend your brain’s been craving.",
        'additionalInfo': '',
        'additionalInfoExtra': ' ℹ️ Calories: 25 \n ℹ️ Carbs: 5g \n ℹ️ Protein: 1.9g \n ℹ️ Fiber: 2g \n ℹ️ Vitamin C: 77% DV \n ℹ️ Vitamin K: 20% DV \n ℹ️ Choline: 45mg \n ℹ️ Folate: 15% DV',
        'image': 'assets/cauliflower.png',
        'modelPath': 'assets/models/cauliflower.glb',
        'shortDescription': 'White florets, bright thoughts.',
      },
      {
        "name": "Yellow Bell Pepper",
        "normalModeDescription": " 🌶️ Yellow bell peppers aren’t just bright and crunchy, they’re loaded with vitamin C! \n \n 🌶️ Vitamin C supports the health of blood vessels in the brain and helps with iron absorption, vital for oxygen delivery. \n \n 🌶️ They’re rich in lutein and zeaxanthin. \n \n 🌶️ These antioxidants that protect brain cells and improve visual processing. \n \n 🌶️ Yellow bell peppers also contain vitamin B6, which aids in the creation of neurotransmitters like serotonin and dopamine, improving mood and focus. \n \n 🌶️ Their low-calorie, high-fiber nature makes them perfect for snacking or tossing into stir-fries without spiking blood sugar.",
        'funModeDescription': " 🌶️ Yellow bell peppers are like the sunshine your brain didn't know it needed ☀️. \n \n 🌶️ They’ve got that vitamin C blast to keep your neurons buzzing and iron flowing, plus lutein and zeaxanthin for superhero-level protection. \n \n 🌶️ B6 boosts your mood and focus like a vibe enhancer. \n \n 🌶️ Sweet, crunchy, and totally snackable! \n \n 🌶️ Dip them, grill them, or stuff them. \n \n 🌶️ This brain food doesn’t just slap, it crunches its way into your mental high score.",
        'additionalInfo': '',
        'additionalInfoExtra': ' ℹ️ Calories: 27 \n ℹ️ Carbs: 6.3g \n ℹ️ Protein: 1g \n ℹ️ Fiber: 0.9g \n ℹ️ Vitamin C: 200% DV \n ℹ️ Vitamin B6: 15% DV \n ℹ️ Lutein + Zeaxanthin: 120 mcg \n ℹ️ Folate: 10% DV',
        'image': 'assets/yellowbellpepper.png',
        'modelPath': '',
        'shortDescription': 'Colorful crunch for cognitive punch',
      },
    ],
    "meat": [
      {
        'name': 'Salmon',
        'normalModeDescription': ' 🐟 Salmon is a powerhouse for your brain, packed with omega-3 fatty acids that improve memory, cognition, and mood regulation. \n \n 🐟 The DHA in salmon strengthens neurons, enhancing communication between brain cells. \n \n 🐟 It is also rich in vitamin D and B vitamins, which support nerve function and reduce cognitive decline risk. \n \n 🐟 Whether grilled or baked, it is a go-to brain booster.',
        'funModeDescription': ' 🐟 Salmon is basically liquid Wi-Fi for your brain—full bars, no lag. 🧠⚡ \n \n 🐟 The omega-3s in it keep your neurons firing, upgrading memory, focus, and reaction time. \n \n 🐟 DHA? That’s the elite brain fuel keeping your mental speed locked in at 200 IQ mode. \n \n 🐟 Eat this, and you’re out here dodging brain fog like a ninja, unlocking genius-level problem-solving with every bite.',
        'image': 'assets/salmon.png',
        'modelPath': '',
        'shortDescription': 'Fishy Health!',
        'additionalInfo': '',
        'additionalInfoExtra': ' ℹ️ Calories: 208, \n ℹ️ Carbs: 0g \n ℹ️ Protein: 20g \n ℹ️ Fat: 13g \n ℹ️Omega-3: 2,260mg',
      },
      {
        "name": "Chicken Breast",
        "normalModeDescription": " 🍗 Chicken breast is a rich source of lean protein. \n \n 🍗 It is essential for creating neurotransmitters like dopamine and serotonin that regulate mood, focus, and memory. \n \n 🍗 It contains high levels of vitamin B6. \n \n 🍗 Vitamin B6 supports brain development and helps in the production of brain chemicals. \n \n 🍗 The choline found in chicken supports brain cell structure and neurotransmitter acetylcholine, which is critical for learning and memory. \n \n 🍗 Regular consumption supports long-term cognitive resilience, especially when paired with leafy greens or whole grains.",
        'funModeDescription': " 🍗 Chicken breast is the brain's gym buddy 💪🧠. \n \n 🍗 Packed with clean protein and B6 magic, it powers your mental reps and keeps your mood in beast mode. \n \n 🍗 Wanna excel the exams? This one’s your wingman. \n \n 🍗 Plus, choline in it helps your memory go full Sherlock mode 🔍. \n \n 🍗 You’re basically feeding your brain the answers to learning and slaying tasks. \n \n 🍗 Light, lean, and lit for your mental health!",
        'additionalInfo': 'Tap to learn more!',
        'additionalInfoExtra': ' ℹ️ Calories: 165, \n ℹ️ Protein: 31g, \n ℹ️ Fat: 3.6g, \n ℹ️ Carbs: 0g, \n ℹ️ Vitamin B6: 30% DV, \n ℹ️ Choline: ~72mg (13% DV)',
        'image': 'assets/chickenbreast.png',
        'modelPath': '',
        'shortDescription': 'Lean meat for memory.',
      },
      {
        "name": "Beef Liver",
        "normalModeDescription": " 🥩 Beef liver is a nutritional powerhouse for brain health. \n \n 🥩 It's incredibly rich in vitamin B12, which is vital for the formation of red blood cells and maintaining healthy brain function. \n \n 🥩 Beef liver also delivers high doses of iron which: \n • Ensures oxygen delivery to brain cells, \n • Enhances focus and mental stamina. \n \n 🥩 Folate and vitamin A from liver play critical roles in neurological development and cellular repair. \n \n 🥩 It's also packed with zinc and selenium, minerals that protect against cognitive decline. ",
        'funModeDescription': " 🥩 Beef liver’s that underdog MVP for your brain 🧠🔥. \n \n 🥩 It’s like giving your noggin a multivitamin shot: \n • B12 for brain buzz, \n • Iron for pure mental hustle, \n • Zinc for that anti-dumb shield. 🥩 Think of it like brain armor in bite-size form. \n \n 🥩 Sure, it’s got a bold taste, but it comes with big IQ perks. \n \n 🥩 Throw a couple bites on the plate and your brain’s doing cartwheels before breakfast 💃🧠. ",
        'additionalInfo': '',
        'additionalInfoExtra': ' ℹ️ Calories: 135 kcal, \n ℹ️ Protein: 20.4g, \n ℹ️ Fat: 3.6g, \n ℹ️ Carbs: 3.9g, \n ℹ️ Vitamin B12: 3,460% DV, \n ℹ️ Vitamin A: 634% DV, \n ℹ️Iron: 35% DV, \n ℹ️Folate: 65% DV, \n ℹ️ Zinc: 32% DV, \n ℹ️ Selenium: 57% DV',
        'image': 'assets/beefliver.png',
        'modelPath': '',
        'shortDescription': 'Nutrient-packed brain meat',
      },
      {
        "name": "Turkey Breast",
        "normalModeDescription": " 🦃 Turkey breast is a lean protein that’s rich in tryptophan, which helps your body produce serotonin! \n \n 🦃 Serotonin is a neurotransmitter that plays a major role in mood, memory, and focus. \n \n 🦃 It also provides: \n 1. Vitamin B6 vital for neurotransmitter synthesis, \n 2. Zinc which supports cognitive stability and neuroplasticity. \n \n 🦃 This meat contains choline which is a key nutrient in the production of acetylcholine. \n \n 🦃 It is the neurotransmitter tied to memory retention and learning ability. \n \n 🦃 Being low in saturated fats makes it ideal for brain health, reducing risks of inflammation that may affect cognition. ",
        'funModeDescription': " 🦃 Turkey breast is basically brain fuel wrapped in juicy gains 🧠💪. \n \n 🦃 It’s got tryptophan, the vibe molecule maker! \n \n 🦃 It helps in pumping out feel-good serotonin so your brain isn’t stuck in lag mode. \n \n 🦃 B6 and zinc are in there too, boosting your brain’s WiFi signal and memory cache. \n \n 🦃 And choline? That’s the MVP that makes your brain cells talk better. \n \n 🦃 It’s lean, clean, and mean at keeping brain fog away",
        'additionalInfo': '',
        'additionalInfoExtra': ' ℹ️ Calories: 135, \n ℹ️ Protein: 30g \n ℹ️ Fat: 1g \n ℹ️ Carbs: 0g \n ℹ️ Vitamin B6: 46% DV \n ℹ️ Zinc: 22% DV \n ℹ️ Choline: 16% DV \n ℹ️ Tryptophan: ~330mg',
        'image': 'assets/turkeybreast.png',
        'modelPath': '',
        'shortDescription': 'Memory-boosting lean meat',
      },
      {
        "name": "Duck Meat",
        "normalModeDescription": " 🦆 Duck meat, particularly duck breast, is rich in heme iron, zinc, and high-quality protein! \n \n 🦆 All of which support oxygen flow and neural efficiency. \n \n 🦆 It contains significant amounts of B vitamins that fuel neurotransmitter production and brain metabolism. \n \n 🦆 Unlike most lean meats, duck also contains beneficial omega-3 fatty acids! \n \n 🦆 These are essential for maintaining cognitive sharpness, emotional regulation, and neuroprotection. \n \n 🦆 The higher fat content helps in absorbing fat-soluble vitamins like vitamin A and vitamin K, supporting visual memory and neuron stability.",
        'funModeDescription': " 🦆 Duck meat is the smooth operator of brain food 🧠. \n \n 🦆 It is rich, juicy, and loaded with the good kind of fats your brain craves. \n \n 🦆 It brings omega-3s to the party, keeping your thoughts slick and your moods unbothered. \n \n 🦆 Iron and zinc make sure your neurons are sprinting like they drank espresso! \n \n 🦆 They’re the behind-the-scenes squad keeping your brain’s power grid lit. \n \n 🦆 Yeah, it’s a bit fancier than your usual meat—but your brain deserves that VIP treatment. ",
        'additionalInfo': '',
        'additionalInfoExtra': ' ℹ️ Calories: 337 \n ℹ️ Protein: 27.1g \n ℹ️ Fat: 28.4g \n ℹ️ Carbs: 0g \n ℹ️ Iron: 16% DV \n ℹ️ Zinc: 21% DV \n ℹ️ Vitamin B6: 35% DV \n ℹ️ Niacin: 42% DV \n ℹ️ Omega-3: ~170mg',
        'image': 'assets/duckmeat.png',
        'modelPath': '',
        'shortDescription': 'Fatty brainpower',
      },
    ],
    "nutrients": [
      {
        "name": "Vitamin K",
        "normalModeDescription": "💊 Vitamin K helps direct calcium to your bones instead of your arteries. \n \n 💊 This prevents hardening and plaque formation. \n \n 💊 It also supports proper blood clotting. \n \n 💊 The proper working of it prevents excessive bleeding. \n \n 💊 It even protects your heart from blockages caused by calcification.",
        'funModeDescription': "💊 Vitamin K is the traffic cop for calcium! 🚦 \n \n 💊 It tells calcium where to go (to your bones!) and keeps it out of your blood pipes. \n \n 💊That means less clogging and more smooth sailing for your heart. \n \n 💊 It also keeps your blood from leaking all over—super handy! 🧠🚓🫀",
        'additionalInfoExtra': 'Daily Value: 100mg, Found in: Kale, Spinach, Broccoli, Egg Yolk',
        'additionalInfo': '',
        'image': 'assets/vitamink.png',
        'modelPath': 'assets/models/vitamin_k.glb',
        'shortDescription': 'Calcium regulator for arteries',
      },
      {
        "name": "Vitamin B12",
        "normalModeDescription": "🩸 Vitamin B12 helps maintain nerve health. \n \n 🩸 It helps to: \n  ★ Forms red blood cells \n  ★ Aids in the production of brain chemicals \n  ★ Ultimately, affect mood and thinking. \n \n 🩸 Deficiency can lead to confusion, poor memory, and even depression. \n \n 🩸 It’s especially vital for kids and older adults.",
        'funModeDescription': "🩸 B12 = brain’s router. \n \n 🩸 No B12 = no signal. 📶🧠 \n \n 🩸 What it does: \n ★ Keep your focus sharp \n ★ Your brain online \n ★ Your chill intact. \n \n 🩸 Plug in or lag out. 🚫🧠",
        'additionalInfoExtra': 'Daily Value: 2.4 mcg, Found in: Meat, dairy, eggs, fortified cereal',
        'additionalInfo': '',
        'image': 'assets/vitaminb12.png',
        'modelPath': 'assets/models/vitamin_b.glb',
        'shortDescription': 'Essential for focus & nerves',
      },
      {
        "name": "Vitamin E",
        "normalModeDescription": "🌻 Vitamin E is a fat-soluble antioxidant. \n \n 🌻 It protects the brain from free radical damage. \n \n 🌻 It slows cognitive decline and protects the brain's fatty membranes. \n \n 🌻 People with high vitamin E levels tend to retain stronger memory and attention spans as they age. \n \n 🌻 Sunflower seeds are one of the best sources of vitamin E.",
        'funModeDescription': "🌻 Vitamin E is the shield your brain didn’t know it needed. 🧠🛡️ \n \n 🌻 It helps in: ★ Blocking the bad stuff (free radicals) \n ★ Slowing the aging glitch \n ★ Boosting memory stats. \n \n 🌻 Equip vitamin E and dominate the game. 🕹️\n \n ❔What is the sunflower emoji doing here❔ \n \n 🌻 Sunflower seeds is like a nuclear source of Vitamin E, it can get you promoted to max health-level!",
        'additionalInfoExtra': 'Daily Value: 15 mg, Sources: Nuts, seeds, spinach, avocado',
        'additionalInfo': '',
        'image': 'assets/vitamine.png',
        'modelPath': 'assets/models/vitamin_e.glb',
        'shortDescription': 'Antioxidant armor',
      },
    ],
    'moreInfoCategories': {
      'dairy': {
        'normalModeTitle': 'Dairy',
        'funModeTitle': 'Dairy 🧀',
        'items': [
          {
            'name': 'Cottage Cheese',
            'normalModeDescription': " 🧀 Cottage cheese is rich in casein protein! \n \n 🧀 It is a slow-digesting type that fuels your brain steadily over time. \n \n 🧀 Which is perfect for long study sessions or work grinds. \n \n 🧀 It also delivers a healthy dose of vitamin B12, essential for memory and mood regulation. \n \n 🧀 The presence of calcium helps with neurotransmitter function and communication between neurons. \n \n 🧀 Thanks to its low glycemic index, it won't cause blood sugar spikes that can fog your brain. \n \n 🧀 It also has tryptophan, which contributes to serotonin production—keeping your brain balanced and chill.",
            'funModeDescription': " 🧀 Cottage cheese = the brain’s low-key GOAT 🐐. \n \n 🧀 It’s like drip-feeding your noggin steady power all day—no energy crashes, just pure vibe. \n \n 🧀 It has: \n • Vitamin B12 for that memory sharpness, \n • Calcium to help your neurons talk, \n • Tryptophan so your mood ain’t flopping. \n \n 🧀 It’s slow-burn fuel, like a brain buffet that never runs out. \n \n 🧀 Whether you're grinding homework or bingeing documentaries, this is your creamy backup dancer.",
            'image': 'assets/cottage cheese.png',
            'additionalInfo': '',
            'additionalInfoExtra': ' ℹ️ Calories: 98, \n ℹ️ Carbs: 3.4g, \n ℹ️ Protein: 11.1g,\n ℹ️ Fat: 4.3g, \n ℹ️ Calcium: 8% DV,\n ℹ️ Vitamin B12: 19% DV, \n ℹ️ Tryptophan: 0.29g',
            'modelPath': '',
            'shortDescription': 'Slow-digesting brain fuel',
          },
          {
            "name": "Whole Milk",
            "normalModeDescription": " 🥛 Whole milk is a complete package of: \n 1. Brain-friendly nutrients, \n 2. Healthy fats, \n 3. Protein, \n 4. Vitamin D, \n 5. Choline. \n \n 🥛 These contribute to the growth and repair of brain cells, and help support long-term memory. \n \n 🥛 The high saturated fat content in whole milk, in moderation, can aid in myelin sheath formation around neurons. \n \n 🥛 Vitamin D is crucial for mood regulation and cognitive clarity! \n \n 🥛 Choline plays a big role in brain development and neurotransmitter synthesis.",
            'funModeDescription': " 🥛 Whole milk’s that old-school legend that never left 🧠. \n \n 🥛 Packed with fats that build brain highways and protein to keep ya running, it’s like brain fuel with OG vibes. \n \n 🥛 Choline’s the real MVP here—it boosts memory like a cheat code. \n \n 🥛 And that vitamin D is mood armor, fam. \n \n 🥛 One glass and your neurons are like “zoom zoom.” \n \n 🥛 Forget watered-down nonsense, this is the creamy key to thinking straight and vibing sharp. ",
            'additionalInfo': '',
            'additionalInfoExtra': ' ℹ️ Calories: 61, \n ℹ️ Carbs: 4.8g, \n ℹ️ Protein: 3.2g, \n ℹ️ Fat: 3.3g, \n ℹ️ Vitamin D: 12% DV, \n ℹ️ Choline: 14mg, \n ℹ️ Calcium: 12% DV',
            'image': 'assets/milk.png',
            'modelPath': '',
            'shortDescription': 'Classic brain hydrator',
          },
        ],
      },
      'grains': {
        'normalModeTitle': 'Grains',
        'funModeTitle': 'Grains 🌾',
        'items': [
          {
            'name': 'grain',
            'normalModeDescription': 'normal grain',
            'funModeDescription': 'fun grain',
            'image': 'assets/FishTestImage.png',
            'additionalInfo': '',
            'additionalInfoExtra': '',
            'modelPath': '',
            'shortDescription': '',
          }
        ],
      },
      'protein': {
        'normalModeTitle': 'Protein',
        'funModeTitle': 'Protein 🥚',
        'items': [
          {'name': 'pulses',
            'normalModeDescription': 'normal pulses',
            'funModeDescription': 'fun pulses',
            'image': 'assets/FishTestImage.png',
            'additionalInfo': '',
            'additionalInfoExtra': '',
            'modelPath': '',
            'shortDescription': '',
          },
        ],
      },
      'funFacts': {
        'normalModeTitle': 'Fun Facts',
        'funModeTitle': 'Fun Facts 🎈',
        'items'
            : [
          {'name': 'Brain Power',
            'normalModeDescription': ' 🧠 The human brain contains approximately 86 billion neurons. \n \n 🧠 These tiny nerve cells transmit signals that control every thought, action, and feeling. \n \n 🧠 They form complex networks that power everything your body does.',
            'funModeDescription': " 🧠 Your brain’s rockin’ like 86 billion neurons—yeah, billion with a B. \n \n 🧠 These tiny signal-sending MVPs are basically running the whole show: every thought, move, and vibe you catch. \n \n 🧠 They're all linked up in crazy complex networks, low-key powering everything your body’s got goin’ on!",
            'additionalInfo': '',
            'additionalInfoExtra': '',
            'image': 'assets/gif/brain_fact.gif',
            'modelPath': '',
            'shortDescription': 'How strong is our brain?'
          },
          {'name': 'Dehydrated',
            'normalModeDescription': " 🧠 When you're dehydrated, your brain actually shrinks a little. \n \n 🧠 That’s why you might feel lightheaded, get headaches, or have trouble concentrating when you haven’t had enough water. \n \n 🧠 Even a small drop in hydration can affect your mood and memory.",
            'funModeDescription': " 🧠 No cap—if you don’t drink water, your brain literally shrivels up like a raisin.  \n \n 🧠 That’s why you feel dizzy, forget stuff, or just vibe like a zombie. \n \n 🧠 Hydration = brain fuel, for real.",
            'additionalInfo': '',
            'additionalInfoExtra': '',
            'image': 'assets/gif/brain_fact2.png',
            'modelPath': '',
            'shortDescription': 'Wait! Why am I dizzy?'
          },
        ],
      },
      'firstAid': {
        'normalModeTitle': 'First Aid',
        'funModeTitle': 'First Aid 🩹',
        'items'
            : [
          {
            'name': 'firstaid',
            'normalModeDescription': 'normal',
            'funModeDescription': 'fun',
            'image': 'assets/FishTestImage.png',
            'additionalInfo': '',
            'additionalInfoExtra': '',
            'modelPath': '',
            'shortDescription': '',
          }
        ],
      },
      'diseases': {
        'normalModeTitle': 'Diseases',
        'funModeTitle': 'Diseases 😵',
        'items': [
          {
            'name': 'Alzheimer\'s Disease',
            'normalModeDescription': ' 🧠 Alzheimer’s is a progressive brain disorder that slowly destroys memory, thinking skills, and the ability to carry out simple tasks. \n \n 🧠 It happens when abnormal proteins build up in and around brain cells, disrupting communication between neurons. \n \n 🧠 As it advances, it deeply affects a person’s behavior, emotions, and independence, usually in older adults.',
            'funModeDescription': ' 🧠 Alzheimer’s is like your brain’s hard drive getting corrupted—files start vanishing, and stuff gets super glitchy. \n \n 🧠 Weird proteins show up uninvited and mess with your memory circuits, kinda like malware crashing your mental apps. \n \n 🧠 Over time, even basic stuff like remembering names or brushing your teeth turns into a boss-level challenge.',
            'additionalInfo': '',
            'additionalInfoExtra': '',
            'image': 'assets/alzheimerdisease.png',
            'modelPath': '',
            'shortDescription': 'Alzheimer? I forgot it?!'
          },
          {'name': 'Headache',
            'normalModeDescription': ' 🤕 Headaches can be triggered by dehydration, nutrient deficiencies, inflammation, or muscle tension. \n \n 🤕 Nutrients like magnesium, riboflavin (B2), and omega-3 fatty acids play a major role in preventing and easing headaches. \n \n 🤕 Magnesium helps relax blood vessels and muscles. \n \n 🤕 Vitamin B2 boosts energy production in brain cells, and omega-3s reduce inflammation that may cause migraines. \n \n 🤕 Staying well-hydrated and consuming anti-inflammatory foods regularly can significantly reduce the frequency and intensity of headaches.',
            'funModeDescription': " 🤕 Head hurting like your brain's buffering? 🌀💀 \n \n 🤕 Chill—your body’s probably just low-key screaming for magnesium, vitamin B2, or water. 💧 \n \n 🤕 Bananas, almonds, or a glass of lemon water = the squad that fixes your headache. \n \n 🤕 Omega-3s be sliding in like “yo inflammation, take a hike.” \n \n 🤕 Keep your body fueled and hydrated, and say bye to those drama queen migraines. \n \n 🤕 Your brain deserves main character energy—not background pain.",
            'additionalInfo': '',
            'additionalInfoExtra': '',
            'image': 'assets/headache.png',
            'modelPath': '',
            'shortDescription': 'OUCH! MY HEAD IS PAINING!'
          },
          {'name': 'Dizzy',
            'normalModeDescription': " 🧠 When you're dehydrated, your brain actually shrinks a little. \n \n 🧠 That’s why you might feel lightheaded, get headaches, or have trouble concentrating when you haven’t had enough water. \n \n 🧠 Even a small drop in hydration can affect your mood and memory.",
            'funModeDescription': " 🧠 No cap—if you don’t drink water, your brain literally shrivels up like a raisin.  \n \n 🧠 That’s why you feel dizzy, forget stuff, or just vibe like a zombie. \n \n 🧠 Hydration = brain fuel, for real.",
            'additionalInfo': '',
            'additionalInfoExtra': '',
            'image': 'assets/gif/brain_fact2.png',
            'modelPath': '',
            'shortDescription': 'Wait! Why am I dizzy?'
          },
        ],
      },
      'food': {
        'normalModeTitle': 'Food',
        'funModeTitle': 'Food 😋',
        'items': [
          {'name': 'food item',
            'normalModeDescription': 'normal food',
            'funModeDescription': 'fun food',
            'image': 'assets/FishTestImage.png',
            'additionalInfo': '',
            'additionalInfoExtra': '',
            'modelPath': '',
            'shortDescription': '',
          }
        ]
      },
      'weeklyDiet': {
        'normalModeTitle': 'Weekly Diet',
        'funModeTitle': 'Weekly Diet 🥗',
        'items': [
          {
            'name': 'Monday',
            'normalModeDescription': 'normal weekly diet',
            'funModeDescription': 'fun weekly diet',
            'image': 'assets/FishTestImage.png',
            'additionalInfo': '',
            'additionalInfoExtra': '',
            'modelPath': '',
            'shortDescription': '',
          }
        ]
      }
    },
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
        'additionalInfoExtra': 'Calories: 83, Carbs: 19g, Fiber: 4g, Vitamin C: 17%',
        'additionalInfo': '',
        'image': 'assets/pomegranate.png',
        'modelPath': 'assets/models/pomegranate.glb',
        'shortDescription': 'Antioxidant powerhouse',
      },
      {
        "name": "Blueberries",
        "normalModeDescription": "🫐 Blueberries contain powerful antioxidants known as anthocyanins. \n \n 🫐 This helps to:\n  ★ Lower bad cholesterol \n  ★ Support blood vessel function \n  ★ Reduce inflammation in the cardiovascular system  \n \n 🫐 Regular consumption improves circulation, strengthens blood vessels, and reduces risk of heart attacks.\n \n 🫐 They are low in calories but high in fiber and vitamin C—great for long-term heart health.",
        'funModeDescription': "🫐 Blueberries are heart ninjas in disguise! 🥷 \n \n 🫐 These bite-sized blue buddies: \n  1. Sneak through your bloodstream \n  2. Block the bad stuff \n  3. Gives your heart a hug. \n \n 🫐 They're so good, even your arteries do a happy dance when you munch on them. \n \n 🫐 Eat 'em fresh, frozen, or in your smoothie—your heart will totally thank you! 🫐💓✨",
        'additionalInfoExtra': 'Calories: 57, Carbs: 14g, Fiber: 2.4g, Vitamin C: 16%',
        'additionalInfo': '',
        'image': 'assets/Blueberries.png',
        'modelPath': 'assets/models/blueberry.glb',
        'shortDescription': 'Tiny cholesterol fighters',
      },
      {
        "name": "Avocado",
        "normalModeDescription": "🥑 Avocados are rich in monounsaturated fats. \n \n 🥑 These are healthy fats that help reduce bad cholesterol and increase good cholesterol. \n \n 🥑 They’re also full of potassium which helps in: \n ★ Controlling blood pressure \n ★ Contain antioxidants like lutein & vitamin E \n ★ Reducing heart strain and lowers the risk of heart disease. \n \n 🥑 They’re a creamy, delicious, and nutritious way to protect your heart.",
        'funModeDescription': "🥑 Avocados are like the smooth-talking bodyguards of your heart!💚\n \n 🥑 They kick out the bad cholesterol guests and roll out the red carpet for the good guys.\n \n 🥑 They’ve got potassium power—like bananas in stealth mode.\n \n 🥑 One bite of avo-toast, and your heart's like “let’s chill, we’re safe now.” 💪💓",
        'additionalInfoExtra': 'Calories: 160, Carbs: 9g, Fiber: 7g, Potassium: 14%',
        'additionalInfo': '',
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
        'additionalInfoExtra': 'Calories: 43, Carbs: 9.6g, Fiber: 2.8g, Nitrates: ~250 mg per 100g',
        'additionalInfo': '',
        'image': 'assets/beetroot.png',
        'modelPath': 'assets/models/beetroot.glb',
        'shortDescription': 'Blood flow booster',
      },
      {
        "name": "Broccoli",
        "normalModeDescription": " 🥦 Broccoli is rich in fiber, sulforaphane, and other antioxidants. \n \n 🥦 These help lower inflammation in blood vessels. \n \n 🥦 Its nutrients support smoother circulation and reduce oxidative stress. \n \n 🥦 Broccoli also provides vitamin K and folate. \n \n 🥦 It is important for preventing calcium buildup and supporting heart muscle health.",
        'funModeDescription': " 🥦 Broccoli is the superhero tree that scrubs your blood roads clean! 🦸‍♂️🌳 \n \n 🥦 With fiber fists and antioxidant lasers, it zaps inflammation and keeps your veins free of junk. \n \n 🥦 Eat your broccoli, and your heart will zoom like a sports car. 💨💓",
        'additionalInfoExtra': 'Calories: 34, Carbs: 6.6g, Fiber: 2.6g, Protein: 2.8g, Vitamin C: 89mg, Calcium: 47mg, Sulforaphane: Present in high amounts',
        'additionalInfo': 'information',
        'image': 'assets/broccoli.png',
        'modelPath': 'assets/models/broccoli.glb',
        'shortDescription': 'Fiber and antioxidant defender',
      },
      {
        "name": "Tomato",
        "normalModeDescription": " 🍅 Tomatoes are full of lycopene! \n \n 🍅 Lycopene is a powerful antioxidant that: \n  • Reduces bad cholesterol \n  • Prevents plaque buildup in arteries \n  • Lowers blood pressure. \n \n 🍅 They also contain potassium and folate. \n \n They help in relaxing blood vessels and maintaining a healthy heartbeat. \n \n 🍅 Cooked tomatoes increase lycopene levels, making them even better for heart health.",
        'funModeDescription': " 🍅 Tomatoes are like red fire extinguishers for heart drama! 🔥 \n \n 🍅 They shoot out lycopene lasers that melt away artery gunk and cool down blood pressure. \n \n 🍅 Whether you're eating ketchup, pasta sauce, or a juicy slice. 👇 \n \n 🍅 Your heart’s doing cartwheels behind the scenes. 🧯🫀",
        'additionalInfoExtra': 'Calories: 18, Carbs: 3.9g, Fiber: 1.2g, Lycopene: 2573 mcg',
        'additionalInfo': '',
        'image': 'assets/tomatoes.png',
        'modelPath': 'assets/models/tomato.glb',
        'shortDescription': 'Lycopene-rich heart helper',
      },
    ],
    "nutrients": [
      {
        "name": "Vitamin C",
        "normalModeDescription":
        " 🛡️ Vitamin C is an antioxidant! \n \n 🛡️ What it does: \n  • Prevents free radical damage to blood vessels \n  • Strengthens artery walls \n  • Helps the body produce collagen \n \n 🛡️ Collagen is a protein vital for healthy arteries. \n \n 🛡️ It also boosts the immune system and reduces overall inflammation, helping the cardiovascular system function smoothly.",
        "funModeDescription": " 🛡️ Vitamin C is like the duct tape for your blood tubes! 🛠️🍊 \n \n 🛡️ What it does: \n  • It seals cracks \n  • Blocks invaders \n  • Keeps your blood highways in tip-top shape \n \n 🛡️ Plus, it gives your immune system a big power-up, so your whole body’s ready for action. 💉🧡",
        'additionalInfoExtra': 'Water-soluble vitamin, Daily Value: 90mg, Found in: Citrus, Kiwi, Guava, Bell Peppers',
        'additionalInfo': '',
        'image': 'assets/vitaminc.png',
        'modelPath': 'assets/models/vitamin_c.glb',
        'shortDescription': 'Vessel-strengthening vitamin',
      },
      {
        "name": "Vitamin K",
        "normalModeDescription": "💊 Vitamin K helps direct calcium to your bones instead of your arteries. \n \n 💊 This prevents hardening and plaque formation. \n \n 💊 It also supports proper blood clotting. \n \n 💊 The proper working of it prevents excessive bleeding. \n \n 💊 It even protects your heart from blockages caused by calcification.",
        'funModeDescription': "💊 Vitamin K is the traffic cop for calcium! 🚦 \n \n 💊 It tells calcium where to go (to your bones!) and keeps it out of your blood pipes. \n \n 💊That means less clogging and more smooth sailing for your heart. \n \n 💊 It also keeps your blood from leaking all over—super handy! 🧠🚓🫀",
        'additionalInfoExtra': 'Daily Value: 100mg, Found in: Kale, Spinach, Broccoli, Egg Yolk',
        'additionalInfo': '',
        'image': 'assets/vitamink.png',
        'modelPath': 'assets/models/vitamin_k.glb',
        'shortDescription': 'Calcium regulator for arteries',
      },
      {
        "name": "Potassium",
        "normalModeDescription": " ⚡ Potassium balances sodium levels in your body. \n \n ⚡ They help in regulating blood pressure. \n \n ⚡ What it does: \n  • It eases tension in blood vessel walls \n  • Supports proper heart contractions \n  • Reduces the risk of stroke and hypertension. \n \n ⚡ It’s essential for maintaining electrolyte balance and steady heartbeat.",
        'funModeDescription': " ⚡ Potassium is your heart’s personal DJ! 🎧🎶 \n \n ⚡ It drops the beat at just the right pace—no stress, no mess. \n \n ⚡ What potassium bro does: \n  • It flushes out salty drama \n  • Keeps your blood pressure from spiking \n  • Gets your heart thumping in rhythm like a pro playlist.",
        'additionalInfoExtra': 'Daily Value: 4000mg, Found in: Banana, Avocado, Sweet Potato, Spinach',
        'additionalInfo': '',
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
        "additionalInfoExtra": "Calories (per 100gm): 60, Carbs: 15g, Fiber: 1.6g, Vitamin A: 21% DV",
        'additionalInfo': '',
        "image": "assets/mango.png",
        "modelPath": "assets/models/mango.glb",
        "shortDescription": "Sweet source of eye-protection"
      },
      {
        "name": "Blackberries",
        "normalModeDescription": " 🍇 Blackberries are high in anthocyanins and vitamin C. \n \n 🍇 Both of which play a role in eye health. \n \n 🍇 Anthocyanins help strengthen capillaries in the eyes and improve blood flow to the retina. \n \n 🍇 Vitamin C contributes to the repair and protection of eye tissues.",
        'funModeDescription': " 🍇 Blackberries are like little dark orbs of eye magic 🪄. \n \n 🍇They are packed with anthocyanins and vitamin C. \n \n 🍇 What blackberry homies do: \n  1. They swoop in to protect your retina \n  2. Keep your eye blood vessels chill \n  3. Slow down aging like they’re reversing time. \n \n 🍇 Pop a few and thank them later when you’re spotting typos from across the room. 👓✨",
        'additionalInfoExtra': 'Calories (per 100gm): 43, Carbs: 10g, Fiber: 5.3g, Vitamin C: 35%, Anthocyanins: High',
        'additionalInfo': '',
        'image': 'assets/blackberry.png',
        'modelPath': 'assets/models/blackberries.glb',
        'shortDescription': 'Full of antioxidants for sharp vision',
      },
      {
        "name": "Kiwi",
        "normalModeDescription": " 🥝 Kiwis are incredibly rich in vitamin C, even more than oranges! \n \n 🥝 This antioxidant helps: \n  • Protect the eyes from free radical damage \n  • Supports collagen in the cornea \n  • Reduce the risk of cataracts and macular degeneration. \n \n 🥝 Kiwis also provide small amounts of lutein and zeaxanthin, boosting their eye-friendly profile.",
        'funModeDescription': " 🥝 Kiwi is like a tiny fuzzy bodyguard for your eyeballs 🕶️.\n \n 🥝 Bursting with vitamin C, it: \n  • Builds up collagen like a boss \n  • Blocks those age-gremlins from your retina \n  • Throws in bonus lutein to keep things HD. \n \n 🥝 One bite and your eyes are flexing in 4K.",
        'additionalInfoExtra': 'Calories (per 100gm): 41, Carbs: 10g, Fiber: 2.1g, Vitamin C: 154%',
        'additionalInfo': '',
        'image': 'assets/kiwi.png',
        'modelPath': 'assets/models/kiwi.glb',
        'shortDescription': 'Powerhouse for sharp & protected vision',
      },
    ],
    "vegetables": [
      {
        "name": "Carrot",
        "normalModeDescription": " 🥕 Carrots are loaded with beta-carotene! \n \n 🥕 Beta-carotene is a precursor to vitamin A, which is essential for good vision and eye surface health. \n \n 🥕 They help prevent xerophthalmia (dry eye) and night blindness. \n \n 🥕 Carrots support the immune function of the eyes.",
        'funModeDescription': " 🥕 Carrots are the vision guardians 🧡. \n \n 🥕 They’ve been rocking the eye-care throne forever! \n \n 🥕 It's all thanks to beta-carotene turning into vitamin A! \n \n 🥕 It then starts defending your peepers from \n  1. Dryness \n  2. Blurriness \n  3. Night blindness. \n \n 🥕 Want laser eyes? Crunch a few of these and prepare to see like a hawk. 🦅💥",
        'additionalInfoExtra': 'Calories (per 100gm): 41, Carbs: 10g, Fiber: 2.8g, Vitamin A: 334%, Beta-carotene: High',
        'additionalInfo': '',
        'image': 'assets/carrots.png',
        'modelPath': 'assets/models/carrot.glb',
        'shortDescription': 'Rich in beta-carotene',
      },
      {
        "name": "Kale",
        "normalModeDescription": " 🥬 Kale is one of the best sources of lutein and zeaxanthin! \n \n 🥬 These antioxidants that protect the retina from harmful light and oxidative stress. \n \n 🥬 It also contains vitamin C and beta-carotene. \n \n 🥬 Eating it will result in healthy vision and eye tissue regeneration.",
        'funModeDescription': " 🥬 Kale's not just for health nuts—it’s retina royalty 👑.\n \n 🥬 Lutein + zeaxanthin = elite squad guarding your eyes from blue light and screen strain. \n \n 🥬 It’s like giving your eyes a daily detox and a defense shield. \n \n 🥬 Wanna slay screen time and still see 20/20? Go green.",
        'additionalInfoExtra': 'Calories (per 100gm): 35, Carbs: 4.4g, Fiber: 4g, Lutein & Zeaxanthin: High, Vitamin C: 200%',
        'additionalInfo': '',
        'image': 'assets/kale.png',
        'modelPath': 'assets/models/kale.glb',
        'shortDescription': 'Lutein-packed for retinal protection',
      },
      {
        "name": "Red Bell Pepper",
        "normalModeDescription": " 🌶️ Red bell peppers are a top source of vitamin C and beta-carotene. \n \n 🌶️ These nutrients help maintain the health of eye blood vessels and prevent cataracts. \n \n 🌶️ Their vibrant pigments also support the macula, the part of the retina responsible for central vision.",
        'funModeDescription': " 🌶️ Red bell peppers are spicy vision boosters 🔥👁️. \n \n 🌶️ Full of vitamin C and beta-carotene, they work behind the scenes: \n  • Repairing eye tissue \n  • Boosting collagen \n  • Keeping your central vision crisp. \n \n 🌶️ Basically, they’re eye glow-up fuel. Eat red, see sharp.",
        'additionalInfoExtra': 'Calories (per 100gm): 31, Carbs: 6g, Fiber: 2.1g, Vitamin C: 213%, Beta-carotene: High',
        'additionalInfo': '',
        'image': 'assets/redbellpepper.png',
        'modelPath': 'assets/models/red_bell_pepper.glb',
        'shortDescription': 'Bright color, brighter vision',
      },
    ],
    "nutrients": [
      {
        "name": "Vitamin A",
        "normalModeDescription": " 👁️ Vitamin A is critical for converting light into neural signals in the retina. \n \n 👁️ It protects the eye surface (cornea) and prevents night blindness. \n \n 👁️ Deficiency can lead to dry eyes and vision loss.",
        'funModeDescription': " 👁️ Vitamin A = boss mode for night vision🕶️🌌. \n \n 👁️ What it does: \n  • It helps your retina pick up light \n  • Keeps your eye surface slick \n  • Fights off dryness like a champ. \n \n 👁️ Think of it as auto-focus for your vision—even in low light. \n \n 👁️ Wanna see in the dark? A-level eyes only.",
        'additionalInfoExtra': 'Water-soluble vitamin, Daily Value: 75–90 mg, Found in: red pepper, kiwi, citrus, berries',
        'additionalInfo': '',
        'image': 'assets/vitamina.png',
        'modelPath': 'assets/models/vitamin_a.glb',
        'shortDescription': 'Essential for vision and retina health',
      },
      {
        "name": "Lutein",
        "normalModeDescription": " ☀️ Lutein is a carotenoid that accumulates in the retina and acts as a light filter. \n \n ☀️ What it does: \n  • Protects the eyes from harmful blue light and oxidative stress \n  • Reduces risk of macular degeneration and cataracts.",
        'funModeDescription': " ☀️ Lutein is the real MVP of eye armor 🛡️🌿. \n \n ☀️ What it does: \n  • It filters out blue light \n  • Reduces strain \n  • Protects that sweet spot in your eye which is the macula. \n \n ☀️ More lutein = less blur, less damage, and more clarity. You can literally see the difference",
        'additionalInfoExtra': 'Antioxidant carotenoid, Daily Value: ~10 mg (no official RDA), Found in: kale, spinach, corn',
        'additionalInfo': '',
        'image': 'assets/lutein.png',
        'modelPath': 'assets/models/lutein.glb',
        'shortDescription': 'Shields eyes from light damage',
      },
      {
        "name": "Vitamin C",
        "normalModeDescription": " 🛡️ Vitamin C is an antioxidant that: \n  • Supports collagen production in the eyes \n  • Protects against oxidative damage \n  • Help delay or prevent cataracts. \n \n 🛡️ It strengthens eye blood vessels and supports tear film health.",
        'funModeDescription': " 🛡️ Vitamin C is like skincare for your eyeballs 🧴👁️. \n \n 🛡️ What it does: \n  • It builds collagen \n  • Keeps your blood vessels strong \n  • Fights off cataracts like a ninja. \n \n 🛡️ Want your vision glowing and forever young? This is your go-to glow-up vitamin.",
        'additionalInfoExtra': 'Water-soluble vitamin, Daily Value: 75–90 mg, Found in: Citrus, Kiwi, Guava, Bell Peppers',
        'additionalInfo': '',
        'image': 'assets/vitaminc.png',
        'modelPath': 'assets/models/vitamin_c.glb',
        'shortDescription': 'Fights eye aging',
      },
    ],
    "nfunFact": "Your eyes blink approximately 12,000 times a day, helping to keep them moist and protect them from dust and irritants.",
    "ffunFact": "Your eyes blink around 12K times daily—keeping them fresh, hydrated, and blocking out dust like pros.",
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
        'additionalInfoExtra': 'Calories (per 100gm): 50, Carbs: 13g, Fiber: 1.4g, Vitamin C: 79%, Bromelain: Present',
        'additionalInfo': '',
        'image': 'assets/pineapple.png',
        'modelPath': 'assets/models/pineapple.glb',
        'shortDescription': 'Tropical lung-cleansing fruit',
      },
      {
        "name": "Apple",
        "normalModeDescription": " 🍎 Apples are rich in quercetin! \n \n 🍎 Quercetin is an antioxidant flavonoid that helps: \n  • Reduce asthma symptoms \n  • Lung inflammation \n \n 🍎 Long-term apple consumption is linked to improved lung capacity and lower risk of respiratory diseases.",
        'funModeDescription': " 🍎 Apples are the  clean freaks 🫧. \n \n 🍎 They’re like:- \n “Yo lungs! let’s sweep up this inflammation mess and freshen the airways real quick.” \n \n 🍎 With quercetin as their secret weapon, they block out the bad vibes from: \n  • Smoke \n  • Dust \n  • City air \n \n 🍎 Basically, every crunch is a mic-drop moment for your breathing game. Clean lungs? Say less.",
        'additionalInfoExtra': 'Calories (per 100gm): 52, Carbs: 13.8g, Fiber: 2.4g, Vitamin C: 7% DV, Quercetin: 4.42 mg/100g',
        'additionalInfo': '',
        'image': 'assets/apples.png',
        'modelPath': 'assets/models/apple.glb',
        'shortDescription': 'Antioxidant-rich lung fruit.',
      },
      {
        "name": "Blueberries",
        "normalModeDescription": " 🫐 Blueberries are loaded with anthocyanins! \n \n 🫐 These protect lung tissues from oxidative stress. \n \n 🫐 These antioxidants can help in: \n • Slowing lung function decline \n  • Reduce inflammation. \n \n 🫐 This makes them excellent for respiratory resilience.",
        'funModeDescription': " 🫐 Blueberries = your lungs' favorite squad 💙. \n \n 🫐 With anthocyanins on defense, they guard your airways like a security system! \n \n 🫐 They keep you breathing smooth, strong, and stress-free. \n \n 🫐 Small fruit, big flex.",
        'additionalInfoExtra': 'Calories (per 100gm): 57, Carbs: 14g, Fiber: 2.4g, Vitamin C: 16%',
        'additionalInfo': '',
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
        'additionalInfoExtra': 'Calories (per 100gm): 149, Carbs: 33g, Fiber: 2.1g, Allicin: High, Vitamin C: 15%',
        'additionalInfo': '',
        'image': 'assets/cauliflower.png',
        'modelPath': 'assets/models/cauliflower.glb',
        'shortDescription': 'Lung-cleansing cruciferous veggie',
      },
      {
        "name": "Garlic",
        "normalModeDescription": " 🧄 Garlic contains allicin! \n \n 🧄 Allicin is a sulfur-based compound that acts as a natural antibiotic. \n \n 🧄 It helps: \n  • Reduce lung inflammation \n  • Breaks up mucus \n  • Enhances the lungs' ability to fight infections. \n \n 🧄 Garlic is particularly beneficial for individuals exposed to air pollution or who suffer from chronic bronchial conditions. \n \n 🧄 Its anti-inflammatory and immune-boosting properties make it a powerful tool for long-term lung protection.",
        'funModeDescription': " 🧄 Garlic doesn’t play—it SLAYS 🔥. \n \n 🧄 With allicin as its weapon, it fights off lung invaders \n  1. Viruses \n  2. Bacteria \n  3. Toxic air \n like it’s in an action movie. \n \n 🧄 Got congestion? Garlic smashes through that like a battering ram. \n \n 🧄 Your lungs are basically in beast mode when this spicy legend is on the menu. \n \n 🧄 Powerful, punchy, and lowkey a breath boss.",
        'additionalInfoExtra': 'Calories (per 100gm): 149, Carbs: 33g, Fiber: 2.1g, Allicin: High, Vitamin C: 15%',
        'additionalInfo': '',
        'image': 'assets/garlic.png',
        'modelPath': 'assets/models/garlic.glb',
        'shortDescription': 'Natural lung-clearing antibiotic.',
      },
    ],
    "nutrients": [
      {
        "name": "Vitamin D",
        "normalModeDescription": " ☀️ Vitamin D plays a regulatory role in lung immunity and inflammation. \n \n ☀️ It helps modulate immune responses to infections and has been shown to reduce the risk of respiratory issues like: \n  1. Asthma \n  2. Chronic bronchitis. \n \n ☀️ Sun exposure is the best natural source! \n \n ☀️ Dietary intake is crucial for those with limited sunlight.",
        'funModeDescription': " ☀️ Vitamin D is basically sunshine bottled up for your chest ️🫁. \n \n ☀️ It’s like “Calm down, immune system”! \n \n ☀️ It keeps inflammation low-key while powering up your lung defenses. \n \n ☀️ Cold? Pollution? Smog? \nVitamin D just sun-blasts them out of the way so you can inhale peace and exhale strength.",
        'additionalInfoExtra': 'Fat-soluble, Daily Value: 600–800 IU, Found in: sunlight, mushrooms, eggs, fortified foods',
        'additionalInfo': '',
        'image': 'assets/vitamind.png',
        'modelPath': 'assets/models/vitamin_d.glb',
        'shortDescription': 'Regulates lung immunity and inflammation.',
      },
    ],
    "nfunFact": "Your lungs take around 20,000 breaths a day, working continuously to keep you supplied with oxygen!",
    "ffunFact": "Lungs are on grind mode—20K breaths a day without skipping a beat.",
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
        'additionalInfoExtra': 'Calories (per 100gm): 43, Carbs: 11g, Protein: 0.5g, Fiber: 1.7g, Vitamin C: 75%, Vitamin A: 22%, Enzyme: Papain',
        'additionalInfo': '',
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
        'additionalInfoExtra': 'Calories (per 100gm): 86, Carbs: 20g, Fiber: 3g, Protein: 1.6g, Vitamin A: 283%, Resistant Starch: Present',
        'additionalInfo': '',
        'image': 'assets/sweet potato.png',
        'modelPath': 'assets/models/sweet_potato.glb',
        'shortDescription': 'Anti-acid gut buddy',
      },
      {
        "name": "Carrot",
        "normalModeDescription": " 🥕 Carrots are high in soluble fiber and beta-carotene! \n \n 🥕 These support mucosal health and reduce inflammation in the stomach lining. \n \n 🥕 Their natural alkalinity helps balance stomach acid and improve digestion. \n \n 🥕 They also stimulate bile production, aiding fat breakdown.",
        'funModeDescription': " 🥕 Carrots are like crunchy peacekeepers for your tummy 🕊️. \n \n 🥕 What do them carrot homies do: \n • They chill your acid levels \n  • Soften your insides with fiber \n  • Keep your stomach walls smooth and comfy. \n \n 🥕 Add ‘em raw or cooked, and your gut’s like “omg yas, comfort food vibes.”",
        'additionalInfoExtra': 'Calories (per 100gm): 41, Carbs: 10g, Fiber: 2.8g, Vitamin A: 334%, Beta-carotene: High',
        'additionalInfo': '',
        'image': 'assets/carrots.png',
        'modelPath': 'assets/models/carrot.glb',
        'shortDescription': 'Fiber-rich softener',
      },
    ],
    "nutrients": [
      {
        "name": "Vitamin B1",
        "normalModeDescription": " ⚡ Vitamin B1 (thiamine) plays a crucial role in maintaining a healthy digestive system! \n \n ⚡ It stimulates the production of hydrochloric acid in the stomach. \n \n ⚡ This acid is essential for breaking down food effectively and preparing nutrients for absorption in the intestines. \n \n ⚡ Thiamine: \n  • Supports proper nerve function in the gastrointestinal tract \n  • Helps regulate muscle contractions and coordination \n  • Help in the movement of food smoothly through the digestive system.",
        'funModeDescription': " ⚡ Vitamin B1 AKA Thiamine is like the ignition key for your digestive engine 🚗💊.\n \n ⚡ What happens the moment food hits your mouth: \n  • It’s already revving things up \n  • Turns on the acid \n  • Sparking the belly into action \n  • Syncing your whole gut squad like a well-oiled machine.  \n \n ⚡ It’s the hype coach in your system, yelling “LET’S GOOOOO” every time you eat 🍽️🔥. \n \n ⚡ No B1? Your stomach’s just sitting there, confused and sluggish.",
        'additionalInfoExtra': 'Water-soluble, Daily Value: 1.3–1.7 mg, Found in: bananas, fish, potatoes, avocado',
        'additionalInfo': '',
        'image': 'assets/vitaminb.png',
        'modelPath': 'assets/models/vitamin_b.glb',
        'shortDescription': 'Anti-nausea helper',
      },
    ],
    "nfunFact": "Your stomach produces a new layer of mucus every two weeks to protect itself from being digested by its own acid!",
    "ffunFact": "Your stomach’s got that self-care routine on lock! It drops a fresh mucus layer every two weeks so it doesn’t get wrecked by its own acid.",
    "funFactImage": "assets/gif/stomach_fact.gif"
  },
  "Muscles": {
    "image": "assets/models/muscle.glb",
    "briefInfo": "Muscles are specialized tissues that enable movement, maintain posture, and support bodily functions like circulation and respiration. ",
    "briefInfoFun": "Muscles move, flex, and power your body like champs.",
    "fruits": [
      {
        "name": "Banana",
        "normalModeDescription": " 🍌 Bananas are rich in potassium! \n \n 🍌 Potassium is essential for muscle contraction and preventing cramps. \n \n 🍌 They provide natural sugars for quick energy and contain vitamin B6, which aids in protein metabolism. \n \n 🍌 Their magnesium content supports: \n  1. Muscle relaxation \n  2. Muscle Recovery \n \n 🍌 This makes them an excellent pre- or post-workout snack.",
        'funModeDescription': " 🍌 Bananas are your gym buddy's bestie💥. \n \n 🍌 Loaded with potassium to keep cramps at bay and natural sugars for that energy boost. \n \n 🍌 They're like nature's energy bar with B6 and magnesium! \n \n 🍌 Your muscles are saying 'Thanks for the gains!'",
        'additionalInfoExtra': 'Calories (per 100gm): 89, Carbs: 23g, Fiber: 2.6g, Protein: 1.1g, Potassium: 358mg, Vitamin B6: 0.4mg, Magnesium: 27mg',
        'additionalInfo': '',
        'image': 'assets/bananas.png',
        'modelPath': 'assets/models/banana.glb',
        'shortDescription': 'Potassium-packed fuel',
      },
      {
        "name": "Grapes",
        "normalModeDescription": " 🍇 Grapes are excellent for post-exercise muscle recovery thanks to their rich supply of antioxidants. \n \n 🍇 They have resveratrol which helps reduce oxidative stress in muscle cells.\n \n 🍇 Their natural sugars restore glycogen levels, aiding energy replenishment after workouts. \n \n 🍇 They help our muscles by: \n  1. Hydrating them \n  2. Supporting blood flow \n  3. Deliver oxygen to sore tissues \n  4. Delivering nutrients to sore tissues. \n \n 🍇 Regular consumption may reduce inflammation and speed up muscle healing. ",
        'funModeDescription': " 🍇 Grapes are your post-workout homies 💪. \n \n 🍇 Think of them as juicy bite-sized power-ups that: \n  1. Roll in \n  2. Hydrate you \n  3. Bounce that soreness outta your muscles. \n \n 🍇 They’ve got resveratrol! \n \n Resveratrol is a fancy antioxidant that acts like your muscle's personal bodyguard, kicking out stress and inflame vibes. \n \n 🍇 The sugar gives you natural energy which is perfect for recharging after a workout!.",
        'additionalInfoExtra': 'Calories (per 100gm): 69, Carbs: 18g, Fiber: 0.9g, Protein: 0.7g, Vitamin C: 10.8mg, Resveratrol: Present in skins',
        'additionalInfo': '',
        'image': 'assets/grape.png',
        'modelPath': 'assets/models/grape.glb',
        'shortDescription': 'Antioxidant-rich snack',
      },
    ],
    "vegetables": [
      {
        "name": "Onion",
        "normalModeDescription": " 🧅 Onions are rich in quercetin! \n \n 🧅 Quercetin is a flavonoid antioxidant that: \n  • Reduces inflammation \n  • Boosts recovery in overworked muscles. \n \n 🧅 Their sulfur compounds: \n  ★ Promote collagen production \n  ★ Help detoxify muscle tissue. \n \n 🧅 Onions can: \n  1. Improve blood circulation \n  2. Deliver oxygen more efficiently to muscles \n  3. Deliver nutrients more efficiently to muscles \n \n 🧅 Regular consumption may reduce muscle fatigue and soreness after intense activity.",
        'funModeDescription': " 🧅 Onions may make you cry, but your muscles are smiling 😢➡️💪.  \n \n 🧅 They’ve got quercetin AKA the  anti-sore hero! \n \n 🧅 They also have sulfur stuff that keeps tissues fresh and ready to bounce back. \n \n 🧅 Better blood flow = better gains! \n \n 🧅 They add flavor AND function. \n \n 🧅 Grill 'em, caramelize 'em, or toss ‘em raw—your biceps will say “thanks, bro.”🔥",
        'additionalInfoExtra': 'Calories (per 100gm): 40, Carbs: 9g, Protein: 1.1g, Fiber: 1.7g, Quercetin: High, Vitamin C: 12%, Sulfur Compounds: Present, Water Content: 89%',
        'image': 'assets/onion.png',
        'additionalInfo': '',
        'modelPath': 'assets/models/onion.glb',
        'shortDescription': 'Anti-inflammatory bulb',
      },
      {
        "name": "Mushroom",
        "normalModeDescription": " 🍄 Mushrooms are a great source of vitamin B like: \n  1. Riboflavin \n  2. Niacin \n  3. Pantothenic acid  \n \n 🍄 These support energy production in muscle cells. \n \n 🍄 They also contain selenium, an antioxidant that protects muscle tissue from oxidative damage during workouts. \n \n 🍄 They offer small but significant protein content and contribute to muscle recovery and metabolic efficiency.",
        'funModeDescription': " 🍄 Mushrooms = muscle’s secret weapon ⚡. \n \n 🍄 They’re packed with vitamin B to keep your energy on max mode! \n \n They also have some sneaky protein and selenium to fight off leg strains after workout. \n \n 🍄 They’re like the quiet gym rat: \n  • Lowkey \n  • Efficient  \n  • Always boosting performance behind the scenes. \n \n 🍄 Eat ‘em and level up that muscle hustle. 💥🍽️",
        'additionalInfoExtra': 'Calories (per 100gm): 22, Carbs: 3.3g, Protein: 3.1g, Fiber: 1g, Riboflavin (B2): 24%, Niacin (B3): 17%, Selenium: 13%, Water Content: 92%',
        'image': 'assets/mushroom.png',
        'additionalInfo': '',
        'modelPath': 'assets/models/mushroom.glb',
        'shortDescription': 'Rich in protein and vitamin B',
      },
    ],
    "nutrients": [
      {
        "name": "Vitamin D",
        "normalModeDescription": " ☀️ Vitamin D plays a pivotal role in muscle function! \n \n ☀️ It influences strength and performance. \n \n ☀️ What it helps with: \n  • Aids in calcium absorption \n  • Calcium absorption is essential for muscle contractions \n  • Help reduce the risk of muscle injuries. \n \n ☀️ Sunlight exposure and certain foods can help maintain adequate levels.",
        'funModeDescription': " ☀️ Vitamin D is your muscle's sunshine buddy 💪. \n \n What Vitamin D bro does: \n  • It boosts strength \n  • Keep contractions smooth \n  • Help prevent injuries. \n \n ☀️ Soak up some sun or munch on D-rich foods for that extra edge.",
        'additionalInfoExtra': 'Fat-soluble, Daily Value: 600–800 IU, Found in: sunlight, mushrooms, eggs, fortified foods','additionalInfo': '',
        'image': 'assets/vitamind.png',
        'modelPath': 'assets/models/vitamin_d.glb',
        'shortDescription': 'Muscle strength enhancer',
      },
      {
        "name": "Vitamin B12",
        "normalModeDescription": " 🩸 Vitamin B12 is essential for red blood cell formation! \n \n 🩸 It ensures oxygen delivery to muscles. \n \n 🩸 It supports energy metabolism, aiding in muscle endurance and reducing fatigue. \n \n 🩸 Deficiency can lead to muscle weakness and decreased performance.",
        'funModeDescription': " 🩸 Vitamin B12 is the energy spark plug ⚡🔋. \n \n 🩸 It keeps your muscles oxygenated and ready to go. \n \n It ensures you don't hit your limit mid-workout. \n \n 🩸 Stay charged and keep pushing.",
        'additionalInfoExtra': 'Daily Value: 2.4 mcg, Found in: Meat, dairy, eggs, fortified cereal',
        'additionalInfo': '',
        'image': 'assets/vitaminb12.png',
        'modelPath': 'assets/models/vitamin_b.glb',
        'shortDescription': 'Energy metabolism aid',
      },
      {
        "name": "Vitamin C",
        "normalModeDescription": " 🛡️ Vitamin C is vital for collagen production! \n \n 🛡️ Collagen maintains the integrity of muscles, tendons, and ligaments. \n \n 🛡️ It also acts as an antioxidant, protecting muscles from oxidative damage post-exercise and aiding in recovery.",
        'funModeDescription': " 🛡️ Vitamin C is your muscle's repair crew 🛠️🍊. \n \n 🛡️ It builds strong connective tissues and shields your gains from oxidative stress. \n \n 🛡️ Keep it in your toolkit for optimal recovery.",
        'additionalInfoExtra': 'Water-soluble vitamin, Daily Value: 90mg, Found in: Citrus, Kiwi, Guava, Bell Peppers',
        'additionalInfo': '',
        'image': 'assets/vitaminc.png',
        'modelPath': 'assets/models/vitamin_c.glb',
        'shortDescription': 'Collagen synthesis supporter',
      },
    ],
    "nfunFact": "Muscles account for approximately 40% of your body weight and can adapt to become stronger and more efficient through regular exercise!",
    "ffunFact": "Muscles are your built-in powerhouses—flexing at 40% of your weight and leveling up with every workout. Stay on the grind, and they’ll keep getting stronger and more efficient.",
    "funFactImage": "assets/gif/muscle_fact.gif"
  },
  "Legs": {
    "image": "assets/models/leg.glb",
    "briefInfo": "Legs provide essential support, enable movement, and ensure stability and strength for daily activities.",
    "briefInfoFun": "Legs are turbo-charged—speed, flex, and beast-mode strength.",
    "fruits": [
      {
        "name": "Watermelon",
        "normalModeDescription": " 🍉 Watermelon is rich in citrulline! \n \n 🍉 Citrulline is an amino acid that: \n  ★ Boosts nitric oxide production \n  ★ Enhances blood flow \n  ★ Reduces muscle soreness \n \n 🍉 Its high water content keeps your legs hydrated during intense activity, which helps prevent fatigue and cramps.",
        'funModeDescription': " 🍉 Watermelon’s that juicy leg juice 💦. \n \n 🍉 What our juicy friend does: \n  • It hydrates \n  • Cools you down \n  • Sneaks in citrulline to pump your blood flow! \n \n 🍉 All of this is necessary for your legs to go the extra mile. \n \n 🍉 Crunch into it, and feel your legs scream, “We’re ON FIRE!” 🦿💥",
        'additionalInfoExtra': 'Calories (per 100gm): 30, Carbs: 7.6g, Citrulline: Present, Water content: 92%, Vitamin C: 13%, Potassium: 112mg',
        'additionalInfo': '',
        'image': 'assets/watermelon.png',
        'modelPath': 'assets/models/watermelon.glb',
        'shortDescription': 'Hydrating, anti-cramp melon',
      },
      {
        "name": "Tangerine",
        "normalModeDescription": " 🍊 Tangerines are high in vitamin C! \n \n 🍊 This helps reduce inflammation and oxidative stress in leg muscles.\n \n 🍊 Their natural sugar offers quick energy. \n \n 🍊 Bioflavonoids present in tangerines: \n  1. Improve capillary strength \n  2. Improve capillary circulation \n  3. Keep our legs healthy and oxygenated.",
        'funModeDescription': " 🍊 Tangerines = mini orange rockets 🚀. \n \n 🍊 Their powers: \n  1. A citrus blast of vitamin C 💥 \n  2. Smooth blood movement vibe 🩸 \n \n 🍊 They’re like leg health wrapped in peelable sunshine. \n \n 🍊 Unleash one and let your legs dance it out, cardio-style.",
        'additionalInfoExtra': 'Calories (per 100gm): 53, Carbs: 13.3g, Fiber: 1.8g, Vitamin C: 44%, Flavonoids: High, Sugars: 10.6g',
        'additionalInfo': '',
        'image': 'assets/tangerine.png',
        'modelPath': 'assets/models/tangerine.glb',
        'shortDescription': 'Citrus leg immunity supporters',
      },
    ],
    "vegetables": [
      {
        "name": "Broccoli",
        "normalModeDescription": " 🥦 Broccoli is a leg-day legend! \n \n 🥦 Its rich in: \n  1. Vitamin C \n  2. Calcium \n  3. Fiber content. \n \n 🥦 How it helps: \n  • It promotes better circulation \n  • Supports strong bones and joints \n  • Contains sulforaphane which helps reduce inflammation in leg muscles after intense physical activity. \n \n 🥦 Its nutrient density makes it a staple for anyone looking to keep their lower body powerful and resilient.",
        'funModeDescription': " 🥦 Broccoli’s the buff green bro of leg strength 💥. \n \n 🥦 It’s got the juice: \n  - Vitamin C \n  - Calcium \n    to keep your bones stacked and blood flowing like a champ. \n \n 🥦 sulforaphane = inflammation slayer. \n \n 🥦 One bite and your legs will be like “yo, thanks fam.”",
        'additionalInfoExtra': 'Calories (per 100gm): 34, Carbs: 6.6g, Fiber: 2.6g, Protein: 2.8g, Vitamin C: 89mg, Calcium: 47mg, Sulforaphane: Present in high amounts',
        'image': 'assets/broccoli.png',
        'additionalInfo': '',
        'modelPath': 'assets/models/broccoli.glb',
        'shortDescription': 'Bone & blood flow booster',
      },
      {
        "name": "Cucumber",
        "normalModeDescription": " 🥒 Cucumbers are incredibly hydrating! \n \n 🥒 They contain silica, a mineral that: \n  • Strengthens connective tissues \n  • Strengthens ligaments \n  • Strengthens joints in the legs \n \n 🥒 They're also low-calorie and offer anti-inflammatory effects for overworked muscles.",
        'funModeDescription': " 🥒 Cucumber = chill pill for your legs 💧. \n \n 🥒 Packed with water and smooth-talking silica, it keeps those knees and ankles agile AF. \n \n 🥒 Pop some slices, hydrate, and vibe like your joints are on spa mode 🧖‍♂️🦿.",
        'additionalInfoExtra': 'Calories (per 100gm): 16, Carbs: 3.6g, Fiber: 0.5g, Vitamin K: 16%, Antioxidants: High (fisetin)',
        'additionalInfo': '',
        'image': 'assets/cucumber.png',
        'modelPath': 'assets/models/cucumber.glb',
        'shortDescription': 'Hydrating leg-friendly veggie',
      },
    ],
    "nutrients": [
      {
        "name": "Vitamin K",
        "normalModeDescription": " 💊 Vitamin K is essential for proper blood clotting and strong bone structure! \n \n 💊 Thus, making it key for leg strength and mobility. \n \n 💊 It also works alongside calcium to ensure skeletal support. \n \n 💊 It helps maintain capillary health in the lower body.",
        'funModeDescription': " 💊 Vitamin K = bone builder and blood flow boss 🦴💉.  \n \n 💊 It helps those legs stay strong and flex-ready! \n \n 💊 It keeps clots in check so you can enjoy without hiccups. \n \n 💊 One dose = leg stability unlocked 🔐.",
        'additionalInfoExtra': 'Daily Value: 100mg, Found in: Kale, Spinach, Broccoli, Egg Yolk',
        'additionalInfo': '',
        'image': 'assets/vitamink.png',
        'modelPath': 'assets/models/vitamin_k.glb',
        'shortDescription': 'Bone and blood flow fixer.',
      },
      {
        "name": "Vitamin D",
        "normalModeDescription": " ☀️ Vitamin D helps: \n  1. Regulate calcium absorption \n  2. Promotes stronger bones \n  3. Reduces muscle weakness in the legs. \n \n ☀️ It also improves balance and muscle tone! \n \n ☀️This is especially important for lower limb stability and injury prevention.",
        'funModeDescription': " ☀️ Vitamin D = sunlight swag for your legs 🦵. \n \n ☀️ What our sunny friend does: \n  1. It feeds your bones \n  2. Wakes up lazy muscles \n  3. Gets your steps smoother \n \n ☀️ If you have low vitamin D, then you will have wobbly knees. \n \n ☀️ If you have high vitamin D, then you’re a walking fortress 💪🏽.",
        'additionalInfoExtra': 'Fat-soluble, Daily Value: 600–800 IU, Found in: sunlight, mushrooms, eggs, fortified foods',
        'additionalInfo': '',
        'image': 'assets/vitamind.png',
        'modelPath': 'assets/models/vitamin_d.glb',
        'shortDescription': 'Muscle power and bone fixer',
      },
    ],
    "meat": [
      {
        "name": "z",
        "normalModeDescription": "",
        'funModeDescription': "",
        'additionalInfoExtra': '',
        'additionalInfo': '',
        'image': 'assets/.png',
        'shortDescription': '',
      },
    ],
    "nfunFact": "The femur, which is the longest bone in your leg, holds the title of being the longest bone in your entire body, providing the strength and support needed for movement and stability.",
    "ffunFact": "The femur’s one of the coolest bones—longest one in your body, built for strength and stability so you can move like a boss!",
    "funFactImage": "assets/gif/leg_fact.gif"
  },
}as Map<String, Map<String, dynamic>>;

final Map<String, Map<String, dynamic>> generalNutritionData = {
  "Fruits": {
    "normalModeTitle": "Fruits",
    "funModeTitle": "Fruits 🍎",
    "items": <Map<String, dynamic>>[],
  },
  "Vegetables": {
    "normalModeTitle": "Vegetables",
    "funModeTitle": "Vegetables 🥦",
    "items": <Map<String, dynamic>>[],
  },
  "Nutrients": {
    "normalModeTitle": "Nutrients",
    "funModeTitle": "Nutrients 💊",
    "items": <Map<String, dynamic>>[],
  },
  "Meat": {
    "normalModeTitle": "Meat",
    "funModeTitle": "Meat🍖",
    "items": <Map<String, dynamic>>[],
  },
  "Dairy": {
    "normalModeTitle": "Dairy",
    "funModeTitle": "Dairy 🥛",
    "items": <Map<String, dynamic>>[],
  },
  "Grains": {
    "normalModeTitle": "Grains",
    "funModeTitle": "Grains 🍞",
    "items": <Map<String, dynamic>>[],
  },
  "Protein": {
    "normalModeTitle": "Protein",
    "funModeTitle": "Protein 💪",
    "items": <Map<String, dynamic>>[],
  },
  "Food": {
    "normalModeTitle": "Food",
    "funModeTitle": "Food 🍽️",
    "items": <Map<String, dynamic>>[],
  },
};

// Function to populate generalNutritionData from organData
void initializeAppData() {
  // Clear previous data before re-populating to prevent duplicates on hot restart
  generalNutritionData.forEach((key, value) {
    value['items'] = <Map<String, dynamic>>[];
  });
  final Set<String> processedItemNames = {}; // To prevent duplicates

  void addItemsToCategory(List<Map<String, dynamic>> items, String categoryKey) {
    for (var item in items) {
      if (item['name'] != null && !processedItemNames.contains(item['name'])) {
        final Map<String, dynamic> completeItem = {
          'name': item['name'],
          'normalModeDescription': item['normalModeDescription'] ?? '',
          'funModeDescription': item['funModeDescription'] ?? '',
          'image': item['image'] ?? '',
          'additionalInfo': item['additionalInfo'] ?? '',
          'additionalInfoExtra': item['additionalInfoExtra'] ?? '',
          'modelPath': item['modelPath'] ?? '',
          'shortDescription': item['shortDescription'] ?? '',
        };
        generalNutritionData[categoryKey]!['items'].add(completeItem);
        processedItemNames.add(item['name']);
      }
    }
  }

  // Iterate through each organ's data
  organData.forEach((organName, organInfo) {
    if (organInfo.containsKey('fruits')) {
      addItemsToCategory(List<Map<String, dynamic>>.from(organInfo['fruits']!), "Fruits");
    }
    if (organInfo.containsKey('vegetables')) {
      addItemsToCategory(List<Map<String, dynamic>>.from(organInfo['vegetables']!), "Vegetables");
    }
    if (organInfo.containsKey('nutrients')) {
      addItemsToCategory(List<Map<String, dynamic>>.from(organInfo['nutrients']!), "Nutrients");
    }
    if (organInfo.containsKey('meat')) { // Assuming 'meat' key might exist at top level for some organs
      addItemsToCategory(List<Map<String, dynamic>>.from(organInfo['meat']!), "Meat");
    }

    // Add items from moreInfoCategories
    if (organInfo.containsKey('moreInfoCategories')) {
      Map<String, dynamic> moreInfo = organInfo['moreInfoCategories'];

      if (moreInfo.containsKey('dairy') && moreInfo['dairy']!['items'] != null) {
        addItemsToCategory(List<Map<String, dynamic>>.from(moreInfo['dairy']!['items']!), "Dairy");
      }
      if (moreInfo.containsKey('grains') && moreInfo['grains']!['items'] != null) {
        addItemsToCategory(List<Map<String, dynamic>>.from(moreInfo['grains']!['items']!), "Grains");
      }
      if (moreInfo.containsKey('protein') && moreInfo['protein']!['items'] != null) {
        addItemsToCategory(List<Map<String, dynamic>>.from(moreInfo['protein']!['items']!), "Protein");
      }
      if (moreInfo.containsKey('food') && moreInfo['food']!['items'] != null) { // Add 'food' if you want it included
        addItemsToCategory(List<Map<String, dynamic>>.from(moreInfo['food']!['items']!), "Food"); // Or a new "General Food" category
      }
      // Note: "funFacts", "symptoms", "diseases", "weeklyDiet" typically aren't nutrition items
      // so they are not added to generalNutritionData here.
    }
  });
}

class AppData {
  static Future<void> saveLastVisitedOrgan(String organName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastVisitedOrgan', organName);
  }

  static Future<String?> getLastVisitedOrgan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastVisitedOrgan');
  }

  static Future<void> saveLastVisitedNutritionItem(String itemName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastVisitedNutritionItem', itemName);
  }

  static Future<String?> getLastVisitedNutritionItem() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastVisitedNutritionItem');
  }
}
