import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ishaan/organ_detail_page.dart';
import 'package:ishaan/item_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:ishaan/mascot_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ishaan/auth_firebase_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ishaan/shared_preferences_helper.dart';

import 'app_data.dart' as AppData; // Ensure this imports your app_data.dart

class HomePage extends StatefulWidget {
  final String mode;
  final ValueNotifier<ThemeMode> themeModeNotifier;
  final ValueNotifier<Map<String, String>?> lastVisitedNutritionNotifier;
  final ValueNotifier<Map<String, String>?> lastVisitedOrganNotifier;

  const HomePage({
    super.key,
    required this.mode,
    required this.themeModeNotifier,
    required this.lastVisitedNutritionNotifier,
    required this.lastVisitedOrganNotifier,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Changed to store organ ID/key, not the full image path
  String? _lastVisitedOrganId;
  List<Map<String, String>> _lastVisitedNutritionItems = [];
  late FlutterTts _flutterTts;
  String _greetingMessage = ''; // This variable is not currently used
  String? _userName;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _initializeTts();
    _loadLastVisited(); // This will now load the organ ID
    _fetchUserName();

    widget.lastVisitedOrganNotifier.addListener(_updateLastVisitedOrgan);
    widget.lastVisitedNutritionNotifier.addListener(_updateLastVisitedNutritionItem);
  }

  @override
  void dispose() {
    widget.lastVisitedOrganNotifier.removeListener(_updateLastVisitedOrgan);
    widget.lastVisitedNutritionNotifier.removeListener(_updateLastVisitedNutritionItem);
    _flutterTts.stop();
    super.dispose();
  }

  void _updateLastVisitedOrgan() {
    if (mounted) {
      setState(() {
        // Now storing the organ 'name' (which acts as its ID/key)
        _lastVisitedOrganId = widget.lastVisitedOrganNotifier.value?['name'];
        // The image path will be derived in build method based on theme
      });
    }
  }

  void _updateLastVisitedNutritionItem() {
    _loadLastVisitedNutritionItems();
  }

  Future<void> _loadLastVisited() async {
    // This now returns {'name': 'Heart'} if you updated saveLastVisitedOrgan to only save the ID
    final Map<String, String>? organData = await loadLastVisitedOrgan();
    if (mounted) {
      setState(() {
        _lastVisitedOrganId = organData?['name']; // Store the organ's ID/key
      });
    }
    _loadLastVisitedNutritionItems();
  }

  Future<void> _loadLastVisitedNutritionItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> loadedItems = [];

    String? name1 = prefs.getString('lastVisitedNutritionItemName1');
    String? path1 = prefs.getString('lastVisitedNutritionItemPath1');
    if (name1 != null && path1 != null) {
      loadedItems.add({'name': name1, 'imagePath': path1});
    }

    String? name2 = prefs.getString('lastVisitedNutritionItemName2');
    String? path2 = prefs.getString('lastVisitedNutritionItemPath2');
    if (name2 != null && path2 != null) {
      loadedItems.add({'name': name2, 'imagePath': path2});
    }

    if (mounted) {
      setState(() {
        _lastVisitedNutritionItems = loadedItems;
      });
    }
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final authService = AuthFirebaseDataSourceImpl();
      final userProfile = await authService.getUserProfile(user.uid);
      if (mounted) {
        if (userProfile != null) {
          String fullName = '';
          if (userProfile.firstName.isNotEmpty) {
            fullName = userProfile.firstName;
            if (userProfile.lastName.isNotEmpty) {
              fullName += ' ${userProfile.lastName}';
            }
          } else if (user.displayName != null && user.displayName!.isNotEmpty) {
            fullName = user.displayName!;
          }

          setState(() {
            _userName = fullName.isNotEmpty ? fullName : null;
          });
        } else {
          setState(() {
            _userName = user.displayName;
          });
        }
      }
    }
  }

  Future<void> _initializeTts() async {
    _flutterTts.setStartHandler(() {
      print("TTS speaking started on HomePage.");
    });
    _flutterTts.setCompletionHandler(() {
      print("TTS speaking completed on HomePage.");
    });
    _flutterTts.setErrorHandler((msg) {
      print("TTS Error on HomePage: $msg");
    });
  }

  Future<void> _speak(String text) async {
    await _flutterTts.stop();

    final mascotProvider = Provider.of<MascotProvider>(context, listen: false);
    final Map<String, dynamic> settings = mascotProvider.currentMascotTtsVoiceSettings;

    final String language = settings['language'] ?? "en-US";
    final double pitch = (settings['pitch'] as num?)?.toDouble() ?? 1.0;
    final double rate = (settings['rate'] as num?)?.toDouble() ?? 0.5;
    final String? voiceName = settings['name'];

    await _flutterTts.setLanguage(language);
    await _flutterTts.setPitch(pitch);
    await _flutterTts.setSpeechRate(rate);

    if (voiceName != null && voiceName.isNotEmpty) {
      try {
        await _flutterTts.setVoice({'name': voiceName, 'locale': language});
        print("HomePage TTS Voice Set to: $voiceName ($language)");
      } catch (e) {
        print("HomePage TTS Error setting voice $voiceName for $language: $e");
        await _flutterTts.setLanguage(language);
      }
    } else {
      await _flutterTts.setLanguage(language);
      print("HomePage TTS using default voice for language: $language (no specific voice name provided)");
    }

    if (text.isNotEmpty) {
      String cleanedText = _cleanTextForTts(text);
      if (cleanedText.isNotEmpty) {
        await _flutterTts.speak(cleanedText);
      } else {
        debugPrint("HomePage: Cleaned text is empty, nothing to speak.");
      }
    }
  }

  String _cleanTextForTts(String text) {
    String cleanedText = text.replaceAll('\n', ' ');
    cleanedText = cleanedText.replaceAll('\r', ' ');
    cleanedText = cleanedText.replaceAll(RegExp(r'[^\w\s.,!?;:]'), '');
    cleanedText = cleanedText.replaceAll(RegExp(r'\s+'), ' ');

    return cleanedText.trim();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mascotProvider = Provider.of<MascotProvider>(context);

    // --- CRITICAL CHANGE: Correctly determine isDarkMode for Lottie asset paths ---
    final bool isDarkMode = widget.themeModeNotifier.value == ThemeMode.dark ||
        (widget.themeModeNotifier.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    String welcomeLottiePath;
    if (isDarkMode) {
      welcomeLottiePath = 'assets/animations/dark/welcome.json';
    } else {
      welcomeLottiePath = 'assets/animations/light/welcome.json';
    }

    String mascotBackgroundLottiePath;
    if (isDarkMode) {
      mascotBackgroundLottiePath = 'assets/animations/dark/mascotwidgetbg.json';
    } else {
      mascotBackgroundLottiePath = 'assets/animations/light/mascotwidgetbg.json';
    }

    // Define the gradient using colors from colorScheme
    final LinearGradient dynamicGradient = LinearGradient(
      colors: [
        colorScheme.onPrimaryContainer,
        colorScheme.onSecondaryContainer,
        colorScheme.onTertiaryContainer,
        colorScheme.onPrimaryContainer
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // Define the text style. The color property here is just a mask.
    final TextStyle dynamicTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 25,
      fontFamily: 'DeliusSwashCaps',
      color: Colors.white,
      shadows: [],
    );

    // --- UPDATED: Determine the correct image path for the last visited organ (no light/dark specific) ---
    String? currentOrganImagePath;
    if (_lastVisitedOrganId != null) {
      final organData = AppData.organData[_lastVisitedOrganId];
      if (organData != null) {
        currentOrganImagePath = organData['picture']; // Directly use the 'image' key
      }
    }
    // Fallback if no specific image path found or organData is null
    currentOrganImagePath ??= 'assets/default/organ_placeholder.png';


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Lottie.asset(
              welcomeLottiePath,
              repeat: true,
              height: 100,
              width: 300,
              fit: BoxFit.contain,
            ),
            if (_userName != null)
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return dynamicGradient.createShader(bounds);
                },
                child: Text(
                  '$_userName',
                  style: dynamicTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            // Last Visited Organ Card
            // Use _lastVisitedOrganId to check if an organ was visited
            // Random Fact Card
            Card(
              color: colorScheme.surface,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: isDarkMode // Use isDarkMode here
                          ? ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.45),
                          BlendMode.multiply,
                        ),
                        child: Lottie.asset(
                          mascotBackgroundLottiePath,
                          fit: BoxFit.cover,
                          repeat: true,
                          animate: true,
                        ),
                      )
                          : Lottie.asset(
                        mascotBackgroundLottiePath,
                        fit: BoxFit.cover,
                        repeat: true,
                        animate: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  mascotProvider.currentMascotName,
                                  style: TextStyle(fontFamily: 'Griffy', color: colorScheme.onSecondary, fontSize: 24, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Image.asset(
                                mascotProvider.currentMascotSpeakingPath,
                                height: 100,
                                width: 75,
                                fit: BoxFit.contain,
                              )
                            ],
                          ),
                          Text(
                              mascotProvider.currentMascotDesc,
                              style: TextStyle(fontFamily: 'DynaPuff', color: colorScheme.onSecondary, fontSize: 8,)
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: Icon(Icons.play_circle, color: colorScheme.onSecondary),
                              onPressed: () {
                                _speak(mascotProvider.currentMascotDesc);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    if (_lastVisitedOrganId != null)
    Card(
    color: colorScheme.surface,
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    elevation: 2,
    child: InkWell(
    onTap: () {
    // Use _lastVisitedOrganId to get the full organ data
    final organData = AppData.organData[_lastVisitedOrganId!];
    if (organData != null) {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => OrganDetailPage(
    organName: _lastVisitedOrganId!,
    mode: widget.mode,
    organData: organData,
    organ: _lastVisitedOrganId!,
    ),
    ),
    );
    }
    },
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
    children: [
    ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: Image.asset(
    currentOrganImagePath!, // Use the single image path
    width: 40,
    height: 40,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) {
    print('Error loading last visited organ image: $error');
    return Container(
    width: 40,
    height: 40,
    color: Colors.grey[300],
    child: const Icon(
    Icons.broken_image,
    size: 24,
    color: Colors.red,
    ),
    );
    },
    ),
    ),
    const SizedBox(width: 16),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Recently Visited',
    style: theme.textTheme.titleSmall,
    ),
    Text(
    _lastVisitedOrganId!, // Display the organ name/ID
    style: theme.textTheme.titleMedium,
    ),
    const SizedBox(height: 4),
    ],
    ),
    ),
    IconButton(
    icon: Icon(Icons.volume_up, color: colorScheme.onSecondary),
    onPressed: () {
    _speak(AppData.organData[_lastVisitedOrganId]?['briefInfo'] ?? 'No information available.');
    },
    ),
    ],
    ),
    ),
    ),
    ),
    const SizedBox(height: 16),

    // Last Visited Nutrition Items (Side-by-Side)
    if (_lastVisitedNutritionItems.isNotEmpty) ...[
    Align(
    alignment: Alignment.centerLeft,
    child: Text(
    'Recently Visited Nutrition',
    style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onBackground),
    ),
    ),
    const SizedBox(height: 8),
    SizedBox(
    height: 180, // Adjust height as needed for the cards
    child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: _lastVisitedNutritionItems.length,
    itemBuilder: (context, index) {
    final item = _lastVisitedNutritionItems[index];
    final itemName = item['name']!;
    // Use itemData['image'] directly from AppData.generalNutritionData
    final itemData = AppData.generalNutritionData['All']!
        .firstWhere((data) => data['name'] == itemName, orElse: () => {});
    final itemImagePath = itemData['image']!; // Get image from itemData from app_data.dart


    return Card(
    color: colorScheme.surface,
    margin: const EdgeInsets.only(right: 12.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    elevation: 2,
    child: InkWell(
    onTap: () {
    if (itemData.isNotEmpty) {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => ItemDetailPage(
    name: itemData['name']!,
    modelPath: itemData['modelPath'] ?? '',
    description: widget.mode == 'fun' ? itemData['funModeDescription']! : itemData['normalModeDescription']!,
    additionalInfo: itemData['additionalInfo'] ?? '',
    additionalInfoExtra: itemData['additionalInfoExtra'] ?? '',
    image: itemData['image']!,
    mode: widget.mode,
    ),
    ),
    );
    }
    },
    child: Container(
    width: 160,
    padding: const EdgeInsets.all(12.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Container(
    width: 70,
    height: 70,
    decoration: BoxDecoration(
    color: colorScheme.tertiaryContainer,
    borderRadius: BorderRadius.circular(8.0),
    image: DecorationImage(
    image: AssetImage(itemImagePath), // This image path is static
    fit: BoxFit.cover,
    ),
    ),
    ),
    const SizedBox(height: 8),
    Text(
    itemName,
    style: theme.textTheme.titleSmall,
    textAlign: TextAlign.center,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    ),
    const SizedBox(height: 4),
    Text(
    itemData['shortDescription'] ?? '',
    style: theme.textTheme.bodySmall,
    textAlign: TextAlign.center,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    ),
    ],
    ),
    ),
    ),
    );
    },
    ),
    ),
            ],
            Card(
              color: colorScheme.surface,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Daily Goal',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Remember to stay hydrated! Aim for 8 glasses of water today.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on Map<String, dynamic> {
  firstWhere(bool Function(dynamic data) param0, {required Map Function() orElse}) {}
}

// Ensure these extensions are outside the class if they are not instance methods
extension IterableMapExtension<T> on Iterable<T> {
  T firstWhere(bool Function(T element) test, {required T Function() orElse}) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return orElse();
  }
}

// Remove the incorrect extension for Map<String, dynamic>
// extension on Map<String, dynamic> {
//   firstWhere(bool Function(dynamic data) param0, {required Map Function() orElse}) {}
// }