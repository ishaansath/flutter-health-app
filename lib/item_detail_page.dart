// item_detail_page.dart
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart'; // NEW: Import provider
import 'package:ishaan/mascot_provider.dart';

import 'app_data.dart' as AppData; // NEW: Import your MascotProvider

// Define an enum for clear TTS states
enum TtsState { playing, stopped, paused, continued }

class ItemDetailPage extends StatefulWidget {
  final String name;
  final String modelPath;
  final String description; // This is the text to be read aloud
  final String additionalInfo;
  final String additionalInfoExtra;
  final String image;
  final String mode; // To determine normal/fun mode

  const ItemDetailPage({
    super.key,
    required this.name,
    required this.modelPath,
    required this.description,
    required this.additionalInfo,
    required this.image,
    required this.additionalInfoExtra,
    required this.mode,
  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  FlutterTts flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped; // Use the enum for state

  // REMOVED: _mascotIdle and _mascotTalkingGif will now come from MascotProvider


  // --- Mascot Sizes & Positions ---
  // Define IDLE state for mascot
  static const double _mascotIdleWidth = 100.0;
  static const double _mascotIdleHeight = 100.0;
  static const double _mascotIdleBottom = 20.0; // Adjusted for better default placement
  static const double _mascotIdleRight = 20.0; // Adjusted

  // Define TALKING state for mascot (now as functions to use context for responsive sizing)
  double _mascotTalkingWidth(BuildContext context) => MediaQuery.of(context).size.width * 0.6; // 60% of screen width
  double _mascotTalkingHeight(BuildContext context) => MediaQuery.of(context).size.height * 0.4; // 40% of screen height

  // Position the talking mascot: adjusted to avoid conflicts and stay within bounds
  double _mascotTalkingBottom(BuildContext context) {
    // Example: Place its bottom edge at 20% of screen height from the bottom
    // You can adjust this '0.2' (20%) to move it higher or lower when talking.
    return MediaQuery.of(context).size.height * 0.2;
  }

  double _mascotTalkingRight(BuildContext context) {
    // Center horizontally, or adjust as needed
    return (MediaQuery.of(context).size.width - _mascotTalkingWidth(context)) / 2;
  }

  // --- Button Sizes & Positions ---
  // Define IDLE state for button (relative to mascot's idle position)
  static const double _buttonIdleBottom = _mascotIdleBottom + _mascotIdleHeight + 10; // 10px above idle mascot
  static const double _buttonIdleRight = _mascotIdleRight;

  // Define TALKING state for button (relative to mascot's talking position)
  double _buttonTalkingBottom(BuildContext context) {
    // Place button below the talking mascot, with some vertical padding
    // Adjust '30.0' for spacing between mascot and button
    return _mascotTalkingBottom(context) - (20 + 50); // button height (50) + padding (20)
  }

  double _buttonTalkingRight(BuildContext context) {
    // Center the button horizontally during talking state
    // Assuming button width is roughly 150-200. Adjust this for your actual button width.
    return (MediaQuery.of(context).size.width - 200) / 2; // Roughly center a 200px wide button
  }


  // Current animated values for mascot
  double _currentMascotWidth = _mascotIdleWidth;
  double _currentMascotHeight = _mascotIdleHeight;
  double _currentMascotBottom = _mascotIdleBottom;
  double _currentMascotRight = _mascotIdleRight;

  // Current animated values for button
  double _currentButtonBottom = _buttonIdleBottom;
  double _currentButtonRight = _buttonIdleRight;

  @override
  void initState() {
    super.initState();
    _initTts(); // Initialize TTS
    // Use addPostFrameCallback to ensure context is available for initial sizing calculations
    AppData.AppData.saveLastVisitedNutritionItem(widget.name);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMascotPositionAndSize(); // Set initial state after widget is laid out
    });
  }

  // Helper to update mascot and button properties based on TTS state
  void _updateMascotPositionAndSize() {
    if (!mounted) return; // Ensure widget is mounted before updating state
    setState(() {
      if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
        _currentMascotWidth = _mascotTalkingWidth(context);
        _currentMascotHeight = _mascotTalkingHeight(context);
        _currentMascotBottom = _mascotTalkingBottom(context);
        _currentMascotRight = _mascotTalkingRight(context);

        _currentButtonBottom = _buttonTalkingBottom(context);
        _currentButtonRight = _buttonTalkingRight(context);
      } else { // TtsState.stopped or TtsState.paused
        _currentMascotWidth = _mascotIdleWidth;
        _currentMascotHeight = _mascotIdleHeight;
        _currentMascotBottom = _mascotIdleBottom;
        _currentMascotRight = _mascotIdleRight;

        _currentButtonBottom = _buttonIdleBottom;
        _currentButtonRight = _buttonIdleRight;
      }
    });
  }

  Future<void> _initTts() async { // Make it async
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1.0);
    // await flutterTts.setVoice({"name": "ja-jp-x-htm-network", "locale": "ja-JP"});

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
      debugPrint("TTS Error: $msg"); // Changed to debugPrint
    });

    flutterTts.setPauseHandler(() {
      if (mounted) {
        setState(() {
          ttsState = TtsState.paused;
          _updateMascotPositionAndSize(); // Mascot goes down when paused
        });
      }
    });

    flutterTts.setContinueHandler(() {
      if (mounted) {
        setState(() {
          ttsState = TtsState.continued;
          _updateMascotPositionAndSize(); // Mascot goes up when continuing
        });
      }
    });
  }

  String _cleanTextForTts(String text) {
    String cleanedText = text.replaceAll('\n', ' ');
    cleanedText = cleanedText.replaceAll('\r', ' ');

    // Simplified regex: removes most non-alphanumeric, non-space characters
    // If you need specific emojis removed, you can keep parts of your long regex,
    // but this is often sufficient for TTS.
    cleanedText = cleanedText.replaceAll(RegExp(r'[🍌🥷💡🧠⚡🐵🫐💓✨🍎🚀⛽💥📚🥬💚🧅💧⚔️🥒💊🚦🚓🫀🩸📶🚫🌻🛡️🕹️🧀🌾🥚🎈🤒😵😋🥗🍷💃🥑💪🟣🌳💨🍅🔥🧯🛠️🍊💉🎧🎶😎🥭🍇🪄👓🥝🕶️🥕🧡🦅👑🌶️👁️🌌☀️🌿🧴🍍🧼🫧🧄🫁🍐🧸🍠🕊️🚗🍽️💦🦿🦴🔐🧖‍♂️🦵💪🏽]'),
        '');
    return cleanedText.trim();
  }

  Future _handleMascotTap() async {
    if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
      await _pause();
    } else if (ttsState == TtsState.paused) {
      await _speak(); // Continue from paused state
    } else { // TtsState.stopped
      await _speak(); // Start speaking
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
      debugPrint('No clean text to speak for description.'); // Changed to debugPrint
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
    flutterTts.stop(); // Stop any ongoing TTS speech
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    IconData buttonIcon;
    String buttonText;
    VoidCallback onPressedAction; // Define a variable for the action

    if (ttsState == TtsState.playing || ttsState == TtsState.continued) {
      buttonIcon = Icons.pause;
      buttonText = 'Pause';
      onPressedAction = _pause;
    } else if (ttsState == TtsState.paused) {
      buttonIcon = Icons.play_arrow_outlined;
      buttonText = 'Continue';
      onPressedAction = _speak;
    } else { // TtsState.stopped
      buttonIcon = Icons.play_arrow;
      buttonText = 'Play';
      onPressedAction = _speak;
    }

    // NEW: Use Consumer to get the MascotProvider and dynamically load mascot paths
    return Consumer<MascotProvider>(
      builder: (context, mascotProvider, child) {
        // Get the current mascot's idle and talking GIF paths from the provider
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
                padding: const EdgeInsets.all(20),
                // Crucial: Add padding to the bottom of the scrollable content
                // to make space for the button and mascot.
                // Adjust the '200' based on the max height your button/mascot combo takes when animated.
                child: Padding(
                  padding: EdgeInsets.only(bottom: _mascotTalkingHeight(context) + 200), // Increased buffer
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
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  widget.description,
                                  style: theme.textTheme.bodyLarge,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                widget.additionalInfoExtra,
                                style: theme.textTheme.bodyMedium,
                                textAlign: TextAlign.left,
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
                    displayMascotGif, // Use the dynamically determined mascot path
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