// lib/item_detail_page.dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:ishaan/mascot_provider.dart';

import 'app_data.dart' as AppData;
import 'frosted_glass_container.dart';

// Define an enum for clear TTS states
enum TtsState { playing, stopped, paused, continued }

class ItemDetailPage extends StatefulWidget {
  final String name;
  final String modelPath;
  final String description;
  final String additionalInfo;
  final String additionalInfoExtra;
  final String image;
  final String mode;
  final String? contentType; // NEW: Optional parameter to specify content type

  const ItemDetailPage({
    super.key,
    required this.name,
    required this.modelPath,
    required this.description,
    required this.additionalInfo,
    required this.image,
    required this.additionalInfoExtra,
    required this.mode,
    this.contentType, // NEW: Include in constructor
  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  FlutterTts flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped;

  // Define your fixed list of headings here
  // IMPORTANT: Adjust these headings and their count to match how many
  // sections your descriptions consistently split into.
  final List<String> _fixedDescriptionHeadings = [
    '🛡️ Benefits',
    '🧠 Nutrients in Focus',
    '🌱 Tips',
    '🍽️ How It Helps',
    '🔍 Key Functions',
    '⚗️ Behind the Science',
    // Add more if your descriptions consistently have more sections (e.g., 7th section)
  ];

  static const double _mascotIdleWidth = 100.0;
  static const double _mascotIdleHeight = 100.0;
  static const double _mascotIdleBottom = 20.0;
  static const double _mascotIdleRight = 20.0;

  double _mascotTalkingWidth(BuildContext context) => MediaQuery.of(context).size.width * 0.6;
  double _mascotTalkingHeight(BuildContext context) => MediaQuery.of(context).size.height * 0.4;

  double _mascotTalkingBottom(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.2;
  }

  double _mascotTalkingRight(BuildContext context) {
    return (MediaQuery.of(context).size.width - _mascotTalkingWidth(context)) / 2;
  }

  static const double _buttonIdleBottom = _mascotIdleBottom + _mascotIdleHeight + 10;
  static const double _buttonIdleRight = _mascotIdleRight;

  double _buttonTalkingBottom(BuildContext context) {
    return _mascotTalkingBottom(context) - (20 + 50);
  }

  double _buttonTalkingRight(BuildContext context) {
    return (MediaQuery.of(context).size.width - 200) / 2;
  }

  double _currentMascotWidth = _mascotIdleWidth;
  double _currentMascotHeight = _mascotIdleHeight;
  double _currentMascotBottom = _mascotIdleBottom;
  double _currentMascotRight = _mascotIdleRight;

  double _currentButtonBottom = _buttonIdleBottom;
  double _currentButtonRight = _buttonIdleRight;

  @override
  void initState() {
    super.initState();
    _initTts();
    AppData.AppData.saveLastVisitedNutritionItem(widget.name);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMascotPositionAndSize();
    });
  }

  void _updateMascotPositionAndSize() {
    if (!mounted) return;
    setState(() {
      if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
        _currentMascotWidth = _mascotTalkingWidth(context);
        _currentMascotHeight = _mascotTalkingHeight(context);
        _currentMascotBottom = _mascotTalkingBottom(context);
        _currentMascotRight = _mascotTalkingRight(context);

        _currentButtonBottom = _buttonTalkingBottom(context);
        _currentButtonRight = _buttonTalkingRight(context);
      } else {
        _currentMascotWidth = _mascotIdleWidth;
        _currentMascotHeight = _mascotIdleHeight;
        _currentMascotBottom = _mascotIdleBottom;
        _currentMascotRight = _mascotIdleRight;

        _currentButtonBottom = _buttonIdleBottom;
        _currentButtonRight = _buttonIdleRight;
      }
    });
  }

  Future<void> _initTts() async {
    await flutterTts.stop();

    final mascotProvider = Provider.of<MascotProvider>(context, listen: false);
    final Map<String, dynamic> settings = mascotProvider.currentMascotTtsVoiceSettings;

    final String language = settings['language'] ?? "en-US";
    final double pitch = (settings['pitch'] as num?)?.toDouble() ?? 1.0;
    final double rate = (settings['rate'] as num?)?.toDouble() ?? 0.5;
    final String? voiceName = settings['name'];

    await flutterTts.setLanguage(language);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(rate);

    if (voiceName != null && voiceName.isNotEmpty) {
      try {
        await flutterTts.setVoice({'name': voiceName, 'locale': language});
        print("HomePage TTS Voice Set to: $voiceName ($language)");
      } catch (e) {
        print("HomePage TTS Error setting voice $voiceName for $language: $e");
        await flutterTts.setLanguage(language);
      }
    } else {
      await flutterTts.setLanguage(language);
      print("HomePage TTS using default voice for language: $language (no specific voice name provided)");
    }

    List<dynamic> voices = await flutterTts.getVoices;
    print("Available Voices: $voices");

    flutterTts.setStartHandler(() {
      if (mounted) {
        setState(() {
          ttsState = TtsState.playing;
          _updateMascotPositionAndSize();
        });
      }
    });
    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          ttsState = TtsState.stopped;
          _updateMascotPositionAndSize();
        });
      }
    });

    flutterTts.setErrorHandler((msg) {
      if (mounted) {
        setState(() {
          ttsState = TtsState.stopped;
          _updateMascotPositionAndSize();
        });
      }
      debugPrint("TTS Error: $msg");
    });

    flutterTts.setPauseHandler(() {
      if (mounted) {
        setState(() {
          ttsState = TtsState.paused;
          _updateMascotPositionAndSize();
        });
      }
    });

    flutterTts.setContinueHandler(() {
      if (mounted) {
        setState(() {
          ttsState = TtsState.continued;
          _updateMascotPositionAndSize();
        });
      }
    });
  }

  // Uses the _fixedDescriptionHeadings list conditionally
  String _cleanTextForTts(String text) {
    List<String> sections = text.split('\n \n');
    StringBuffer cleanedBuffer = StringBuffer();

    // Only apply headings if contentType is not 'funFact' or 'disease'
    bool applyHeadings = !(widget.contentType == 'funFact' || widget.contentType == 'disease');

    for (int i = 0; i < sections.length; i++) {
      String currentContent = sections[i].trim();
      String currentHeading = '';

      if (applyHeadings && i < _fixedDescriptionHeadings.length) {
        currentHeading = _fixedDescriptionHeadings[i];
      }

      if (currentHeading.isNotEmpty) {
        cleanedBuffer.write("$currentHeading. "); // Add heading with a pause
      }
      cleanedBuffer.write(currentContent);

      if (i < sections.length - 1) {
        cleanedBuffer.write(". "); // Add a pause between sections
      }
    }

    String cleanedText = cleanedBuffer.toString();
    cleanedText = cleanedText.replaceAll('\n', ' ');
    cleanedText = cleanedText.replaceAll('\r', ' ');
    cleanedText = cleanedText.replaceAll(RegExp(r'[🍌🥷💡🧠⚡🐵🫐💓✨🍎🚀⛽💥📚🥬💚🧅💧⚔️🥒💊🚦🚓🫀🩸📶🚫🌻🛡️🕹️🧀🌾🥚🎈🤒😵😋🥗🍷💃🥑💪🟣🌳💨🍅🔥🧯🛠️🍊💉🎧🎶😎🥭🍇🪄👓🥝🕶️🥕🧡🦅👑🌶️👁️🌌☀️🌿🧴🍍🧼🫧🧄🫁🍐🧸🍠🕊️🚗🍽️💦🦿🦴🔐🧖‍♂️🦵💪🏽]'),
        '');
        return cleanedText.trim();
    }


  Future _handleMascotTap() async {
    if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
      await _pause();
    } else if (ttsState == TtsState.paused) {
      await _speak();
    } else {
      await _speak();
    }
  }

  Future _speak() async {
    String textToSpeak = _cleanTextForTts(widget.description);
    if (textToSpeak.isNotEmpty) {
      if (ttsState == TtsState.playing) {
        await _stop();
      }
      var result = await flutterTts.speak(textToSpeak);
      if (result == 1) {
        // State will be updated by setStartHandler, setContinueHandler, or setCompletionHandler
      }
    } else {
      debugPrint('No clean text to speak for description.');
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      // State will be updated by setCompletionHandler (which makes it TtsState.stopped)
    }
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) {
      // State will be updated by setPauseHandler (which makes it TtsState.paused)
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  // Helper function to build the list of nutritional info widgets
  List<Widget> _buildAdditionalInfoWidgets(String info, ThemeData theme) {
    List<Widget> widgets = [];

    List<String> infoLines = info.split('\n');

    for (int i = 0; i < infoLines.length; i++) {

      String currentLine = infoLines[i].trim();

      if (currentLine.isNotEmpty) {
        widgets.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(
                    Ionicons.information,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  currentLine,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 9, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        );
        if (i < infoLines.length - 1 && infoLines[i + 1].trim().isNotEmpty) {
          widgets.add(const SizedBox(height: 8));
        }
      }
    }
    return widgets;
  }

  // Uses the _fixedDescriptionHeadings list conditionally
  List<Widget> _buildDescriptionSections(
      String description,
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    List<Widget> descriptionWidgets = [];
    List<String> sections = description.split(RegExp(r'\n\s*\n')).map((s) => s.trim()).toList();

    debugPrint('--- Debugging Description Sections ---');
    debugPrint('Original description: "$description"');
    debugPrint('Number of sections after split: ${sections.length}');
    debugPrint('Fixed headings: $_fixedDescriptionHeadings');
    debugPrint('Number of fixed headings: ${_fixedDescriptionHeadings.length}');
    debugPrint('Content Type: ${widget.contentType}');


    // Only apply headings if contentType is not 'funFact' or 'disease'
    bool applyHeadings = !(widget.contentType == 'funFact' || widget.contentType == 'disease');
    debugPrint('Apply headings: $applyHeadings');

    for (int i = 0; i < sections.length; i++) {
      String currentSection = sections[i].trim();

      debugPrint('Section $i: "$currentSection"');

      if (currentSection.isNotEmpty) {
        bool shouldAddHeading = applyHeadings && i < _fixedDescriptionHeadings.length && _fixedDescriptionHeadings[i].isNotEmpty;
        debugPrint('Section $i should add heading: $shouldAddHeading');

        descriptionWidgets.add(
          FrostedGlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (shouldAddHeading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      _fixedDescriptionHeadings[i], // Use the fixed list here
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                Text(
                  currentSection,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        );

        if (i < sections.length - 1) {
          descriptionWidgets.add(const SizedBox(height: 20));
        }
      }
    }
    debugPrint('--- End Debugging Description Sections ---');
    return descriptionWidgets;
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    IconData buttonIcon;
    String buttonText;
    VoidCallback onPressedAction;

    if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
      buttonIcon = Icons.pause;
      buttonText = 'Pause';
      onPressedAction = _pause;
    } else if (ttsState == TtsState.paused) {
      buttonIcon = Icons.play_arrow_outlined;
      buttonText = 'Continue';
      onPressedAction = _speak;
    } else {
      buttonIcon = Icons.play_arrow;
      buttonText = 'Play';
      onPressedAction = _speak;
    }

    return Consumer<MascotProvider>(
      builder: (context, mascotProvider, child) {
        String currentMascotIdle = mascotProvider.currentMascotStaticPath;
        String currentMascotTalkingGif = mascotProvider.currentMascotSpeakingPath;

        String displayMascotGif = (ttsState == TtsState.playing || ttsState == TtsState.continued)
            ? currentMascotTalkingGif
            : currentMascotIdle;

        return Scaffold(
          backgroundColor: colorScheme.primary,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(widget.name, style: theme.textTheme.titleLarge),
            iconTheme: IconThemeData(color: colorScheme.onSecondary),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.only(bottom: _mascotTalkingHeight(context) + 200),
                  child: Center(
                    child: Column(
                      children: [
                        if (widget.modelPath.isNotEmpty)
                          SizedBox(
                            height: 300,
                            child: ModelViewer(
                              src: widget.modelPath,
                              alt: '3D model of ${widget.name}',
                              autoRotate: true,
                              cameraControls: true,
                              backgroundColor: colorScheme.primary,
                            ),
                          )
                        else if (widget.image.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Image.asset(
                              widget.image,
                              height: 300,
                              fit: BoxFit.contain,
                            ),
                          )
                        else
                          const SizedBox(height: 20),

                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ..._buildDescriptionSections(widget.description, theme, colorScheme),
                              const SizedBox(height: 20),
                              FrostedGlassContainer(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nutritional Info (Per 100g):",
                                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontFamily: "Montserrat"),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 12),
                                    ..._buildAdditionalInfoWidgets(widget.additionalInfoExtra, theme),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- ANIMATED MASCOT ---
              AnimatedPositioned(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOut,
                bottom: _currentMascotBottom,
                right: _currentMascotRight,
                height: _currentMascotHeight,
                width: _currentMascotWidth,
                child: GestureDetector(
                  onTap: _handleMascotTap,
                  child: Image.asset(
                    displayMascotGif,
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}