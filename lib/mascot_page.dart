// lib/mascot_page.dart
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ishaan/auth_firebase_data.dart';
import 'package:provider/provider.dart'; // <--- NEW: Import Provider
import 'package:ishaan/mascot_provider.dart'; // <--- NEW: Import MascotProvider

// IMPORTANT: Replace with your actual Gemini API Key.
const String apikey = 'AIzaSyB4q1yRNvlg0MRSImTbbzYddO6jpLTCMds'; // <<< REPLACE THIS!

class MascotPage extends StatefulWidget {
  // Removed unused 'mode' parameter for cleaner code
  const MascotPage({super.key, required String mode});

  @override
  State<MascotPage> createState() => _MascotPageState();
}

class _MascotPageState extends State<MascotPage> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false; // For Gemini API calls (thinking/processing)
  bool _isListening = false; // For Speech-to-Text (microphone active)
  bool _isSpeaking = false; // For Text-to-Speech (mascot talking)
  bool _hasUserSentMessage = false; // Tracks if user has sent a message

  // New: Button press animation states
  bool _isMicButtonPressed = false;
  bool _isSendButtonPressed = false;

  // Declare AuthFirebaseDataSource instance
  final AuthFirebaseDataSource _authService = AuthFirebaseDataSourceImpl();
  // Member variable to store the fetched user profile
  UserProfile? _currentUserProfile;

  // Gemini API setup
  late GenerativeModel _model;
  late ChatSession _chat; // Initialized later, after user data

  // TTS setup
  late FlutterTts flutterTts;
  String? _selectedVoiceName;
  String? _selectedVoiceLocale;

  // Speech-to-Text setup
  late SpeechToText _speechToText;
  String _lastWords = ''; // Stores the recognized speech

  // Mascot Idle Animation
  late AnimationController _mascotIdleController;
  late Animation<double> _mascotIdleAnimation;

  // Initial prompt will be built dynamically
  String _initialPromptText = "";

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apikey);

    flutterTts = FlutterTts();
    _initializeTts();

    _speechToText = SpeechToText();
    _initSpeechToText();

    _speechToText.statusListener = (status) {
      if (mounted) {
        bool wasListening = _isListening;
        setState(() {
          _isListening = _speechToText.isListening;
        });

        if (wasListening && !_isListening && _lastWords.isNotEmpty) {
          _sendMessage(_lastWords);
        }
      }
    };

    // Initialize Mascot Idle Animation
    _mascotIdleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration for one full cycle (breathe in/out)
    )..repeat(reverse: true); // Makes the animation loop back and forth (scale up then down)

    _mascotIdleAnimation = Tween<double>(begin: 0.98, end: 1.02).animate( // Subtle scale from 98% to 102%
      CurvedAnimation(
        parent: _mascotIdleController,
        curve: Curves.easeInOutSine, // A smooth curve for a natural breathing effect
      ),
    );

    // Call _loadAndSetupMascot using addPostFrameCallback to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAndSetupMascot();
    });
  }

  Future<void> _loadAndSetupMascot() async {
    // Get the current mascot name from the provider
    final mascotProvider = Provider.of<MascotProvider>(context, listen: false);
    final String currentMascotName = mascotProvider.currentMascotName;

    final user = FirebaseAuth.instance.currentUser;
    String firstName = 'friend';

    if (user != null) {
      try {
        _currentUserProfile = await _authService.getUserProfile(user.uid);
        if (_currentUserProfile != null && _currentUserProfile!.firstName.isNotEmpty) {
          firstName = _currentUserProfile!.firstName;
        }
      } catch (e) {
        print('Error loading user profile for mascot: $e');
      }
    }

    // Dynamically set the initial prompt based on the current mascot name
    _initialPromptText =
        "You are $currentMascotName, a friendly health and nutrition assistant. "
        "Address the user by $firstName! If your name is Coco, you are a blue and amber colored bunny-sort of creature who wears space boots and a space suit. If your name is Melonzo, you are a watermelon who ate a magical potion to come to life and get hands and legs."
        "Your goal is to help users learn about health, their body, and nutrition. "
        "Please keep your responses focused on these topics and always refer to yourself as $currentMascotName. " // <--- DYNAMIC MASCOT NAME HERE
        "Never speak about anything other than health and nutrition! You can also speak about the history of health, nutrition and food items. "
        "Be fun and playful! You can tell fun facts if they ask you about it! "
        "Even if they talk to you about nutrition or health within games, cinemas or anything other than what this app contains, try to avert the topic. ";
        "This app is called Kokoro, a japanese word which means Heart, Mind, Spirit, Soul, Emotions, Inner self. The Japanese word kokoro  is a deeply meaningful and culturally rich term. Also just say the meaning of the name Kokoro, not everything about the word has something to do with in this app. You don't have to mention it in every sentence. Only if they ask about this app, say the name and this app has information about your body and healthy fruits, vegetables, vitamins, nutrients, dairy, meat products, cereals and grains, fun facts, diseases, symptoms and so many more. "
        "It even features you, $currentMascotName. " // <--- DYNAMIC MASCOT NAME HERE
        "It has a nutrition and a body tab. You can see all the food items in the nutrition tab and see about the body and it's organs in the body tab. "
        "It has a normal and a fun mode, light and dark theme. Fun mode is basically a Gen Z version of normal mode, suited to the younger kids of this generation. "
        "If they ask something in Gen Z/ Alpha slang, try to decipher the meaning and answer them. Also don't tell fun facts all the time, if there is no proper topic about food and nutrition don't tell it. "
        "If they specifically ask for fun facts or they talk about something unrelated to food and nutrition and health, then say fun facts. "
        "If they ask how sports is good for your body, elaborate. If they ask how to learn about organs, tell them to click on body tab on your top left and then they will see ton of organs displayed, if they click on it, it will take them to details of the specific organ. "
        "If they ask how any food item is good for health, elaborate a lot and the last step is ask them to check the nutrition tab which is in the top center and then search for it to learn a lot more. "
        "If they ask, how do I learn about symptoms, diseases, fun facts, weekly diet, diary, pulses, cereals and grains about a specific organ, tell them to navigate to the body tab on the top left and click on the organ that they want to know and then under More button, all of these information will be present. "
        "If they ask about fruits, vegetables, meats and nutrients, tell them to navigate to the body tab on the top left and click on the organ that they want to know and then under whatever fruits, vegetables, meat products, nutrients are good for that specific organ will be displayed. "
        "Use a lot of emojis and make it like a formatted paragraph, leaving enough space and lines. Use linebreaks...";


    _chat = _model.startChat(history: [
      Content.text(_initialPromptText)
    ]);

    // Dynamically set the initial TTS greeting based on the current mascot name
    _speakText("Hello ${firstName}! I'm $currentMascotName, your friendly health and nutrition assistant. How can I help you today?"); // <--- DYNAMIC MASCOT NAME HERE

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    flutterTts.setStartHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = true;
        });
      }
    });

    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });

    flutterTts.setErrorHandler((msg) {
      print("TTS Error: $msg");
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });

    final voices = await flutterTts.getVoices;
    const String desiredVoiceName = "Google US English";
    const String desiredVoiceLocale = "en-US";

    final specificVoice = voices.firstWhere(
          (voice) => voice['name'] == desiredVoiceName && voice['locale'] == desiredVoiceLocale,
      orElse: () => null,
    );

    if (specificVoice != null) {
      await flutterTts.setVoice({"name": specificVoice['name']!, "locale": specificVoice['locale']!});
      print("TTS Voice Set to: ${specificVoice['name']} (${specificVoice['locale']})");
      if (mounted) {
        setState(() {
          _selectedVoiceName = specificVoice['name'];
          _selectedVoiceLocale = specificVoice['locale'];
        });
      }
    } else {
      print("Desired voice '$desiredVoiceName' not found. Using default for 'en-US'.");
    }
  }

  Future<void> _initSpeechToText() async {
    bool available = await _speechToText.initialize(
      onError: (val) => print('STT Error: $val'),
    );
    if (available) {
      print("Speech-to-Text initialized and available.");
    } else {
      print("Speech-to-Text not available on this device.");
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _startListening() async {
    if (!_speechToText.isAvailable) {
      print("Speech-to-Text is not available.");
      return;
    }

    if (!_isListening) {
      await flutterTts.stop();
      _textController.clear();
      _lastWords = '';

      if (mounted) {
        setState(() {
          _isListening = true;
        });
      }

      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 20),
        pauseFor: const Duration(seconds: 10),
        localeId: 'en_US',
      );
      print("Started listening...");
    }
  }

  void _stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      print("Stopped listening.");
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (mounted) {
      setState(() {
        _lastWords = result.recognizedWords;
      });

      if (result.finalResult && _isListening) {
        _stopListening();
      }
    }
  }

  Future<void> _stopSpeaking() async {
    if (_isSpeaking) {
      await flutterTts.stop();
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _isLoading = false;
        });
      }
      print("TTS stopped by user.");
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) {
      _textController.clear();
      return;
    }

    if (_isListening) {
      _stopListening();
    }
    if (_isSpeaking) {
      await flutterTts.stop();
    }

    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _isLoading = true;
      _hasUserSentMessage = true;
    });
    _textController.clear();

    try {
      final response = await _chat.sendMessage(Content.text(text));
      String? geminiResponse = response.text;

      if (geminiResponse != null) {
        geminiResponse = geminiResponse.replaceAll('**', '');
        geminiResponse = geminiResponse.replaceAll('*', '');
        geminiResponse = geminiResponse.replaceAll('```', '');
        geminiResponse = geminiResponse.replaceAll('`', '');
        geminiResponse = geminiResponse.replaceAll('#', '');
      }

      if (mounted) {
        setState(() {
          _messages.add(Message(text: geminiResponse ?? 'No response from Coco.', isUser: false));
        });
      }

      if (geminiResponse != null && geminiResponse.isNotEmpty) {
        _speakText(geminiResponse);
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Gemini API Error: $e');
      if (mounted) {
        setState(() {
          _messages.add(Message(text: 'Error contacting Coco!', isUser: false));
          _isLoading = false;
          _isSpeaking = false;
        });
      }
    }
  }

  String _cleanTextForTts(String text) {
    String cleanedText = text.replaceAll('\n', ' ');
    cleanedText = cleanedText.replaceAll('\r', ' ');
    cleanedText = cleanedText.replaceAll(RegExp(r'[🍌🥷💡🧠⚡🐵🫐💓✨🍎🚀⛽💥📚🥬💚🧅💧⚔️🥒💊🚦🚓🫀🩸📶🚫🌻🛡️🕹️🧀🌾🥚🎈🤒😵😋🥗🍷💃🥑💪🟣🌳💨🍅🔥🧯🛠️🍊💉🎧🎶😎🥭🍇🪄👓🥝🕶️🥕🧡🦅👑🌶️👁️🌌☀️🌿🧴🍍🧼🫧🧄🫁🍐🧸🍠🕊️🚗🍽️💦🦿🦴🔐🧖‍♂️🦵💪🏽]'),
        '');
    cleanedText = cleanedText.replaceAll(RegExp(r'\s+'), ' ');

    return cleanedText.trim();
  }

  Future<void> _speakText(String text) async {
    if (text.isNotEmpty) {
      String cleanedText = _cleanTextForTts(text);
      if (cleanedText.isNotEmpty) {
        await flutterTts.stop();
        await flutterTts.speak(cleanedText);
      } else {
        debugPrint("Cleaned text is empty, nothing to speak.");
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    flutterTts.stop();
    _speechToText.stop();
    _speechToText.cancel();
    _mascotIdleController.dispose(); // Dispose the AnimationController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final String displayFirstName = _currentUserProfile?.firstName ?? '';

    // NEW: Use Consumer to get the MascotProvider
    return Consumer<MascotProvider>(
      builder: (context, mascotProvider, child) {
        return Scaffold(
          backgroundColor: colorScheme.primary,
          appBar:
          _hasUserSentMessage
              ? null
              : AppBar(
            title: Text(
              'Hello $displayFirstName',
              style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.tertiary),
            ),
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: colorScheme.onPrimary),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];

                    // Message Bubble Entrance Animation
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(
                              (message.isUser ? 50 : -50) * (1 - value),
                              0,
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: Align(
                        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          decoration: BoxDecoration(
                            color: message.isUser ? colorScheme.secondary : colorScheme.surface,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: message.isUser ? colorScheme.onSecondary : colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        // If currently speaking, tapping stops TTS. Otherwise, makes mascot greet.
                        onTap: _isSpeaking ? _stopSpeaking : () => _speakText("Hello ${displayFirstName}! I'm ${mascotProvider.currentMascotName}, your friendly health and nutrition assistant. How can I help you today?"),
                        child: _isSpeaking
                            ? Image.asset(
                          mascotProvider.currentMascotSpeakingPath, // <--- NEW: GIF when speaking
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain,
                        )
                            : ScaleTransition( // Mascot Idle Animation
                          scale: _mascotIdleAnimation,
                          child: Image.asset(
                            mascotProvider.currentMascotStaticPath, // <--- NEW: Static image when idle
                            height: 150,
                            width: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Microphone Button with Press Feedback
                      GestureDetector(
                        onTapDown: (_) {
                          if (!(_isLoading || _isSpeaking || !_speechToText.isAvailable)) {
                            setState(() { _isMicButtonPressed = true; });
                          }
                        },
                        onTapUp: (_) {
                          if (!(_isLoading || _isSpeaking || !_speechToText.isAvailable)) {
                            setState(() { _isMicButtonPressed = false; });
                            (_isListening ? _stopListening : _startListening)(); // Execute original logic
                          }
                        },
                        onTapCancel: () {
                          setState(() { _isMicButtonPressed = false; });
                        },
                        child: AnimatedScale( // Button Press Feedback
                          scale: _isMicButtonPressed ? 0.95 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeOutCubic,
                          child: ElevatedButton.icon(
                            onPressed: (_isLoading || _isSpeaking || !_speechToText.isAvailable)
                                ? null // Disable button if conditions met
                                : null, // Logic handled by GestureDetector
                            icon: Icon(
                              _isListening ? Icons.mic_off : Icons.mic,
                              color: _speechToText.isAvailable ? colorScheme.onSecondary : colorScheme.onSecondary.withOpacity(0.5),
                            ),
                            label: Text(
                              _isListening
                                  ? 'Listening...'
                                  : (_speechToText.isAvailable ? 'Speak' : 'Speech Not Available'),
                              style: TextStyle(
                                color: _speechToText.isAvailable? colorScheme.onSecondary : colorScheme.onSecondary,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _speechToText.isAvailable? colorScheme.secondary : colorScheme.secondary,
                              foregroundColor: colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ),
                      // Speech-to-Text Recognition Text with Fade Animation
                      AnimatedOpacity( // STT Recognition Text Fade-in
                        opacity: _isListening && _lastWords.isNotEmpty ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Recognizing: "$_lastWords"',
                            style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              decoration: InputDecoration(
                                hintText: 'Type your question...',
                                hintStyle: theme.textTheme.bodyMedium,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                filled: true,
                                fillColor: colorScheme.surface,
                              ),
                              onSubmitted: _sendMessage,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          _isSpeaking
                              ? IconButton(
                            icon: Icon(Icons.stop_circle, color: colorScheme.secondary),
                            onPressed: _stopSpeaking,
                          )
                              : (_isLoading
                              ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: CircularProgressIndicator(color: colorScheme.secondary),
                          )
                              : GestureDetector( // Send Button with Press Feedback
                            onTapDown: (_) {
                              setState(() { _isSendButtonPressed = true; });
                            },
                            onTapUp: (_) {
                              setState(() { _isSendButtonPressed = false; });
                              _sendMessage(_textController.text); // Execute original logic
                            },
                            onTapCancel: () {
                              setState(() { _isSendButtonPressed = false; });
                            },
                            child: AnimatedScale( // Button Press Feedback
                              scale: _isSendButtonPressed ? 0.95 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeOutCubic,
                              child: IconButton(
                                icon: Icon(Icons.send, color: colorScheme.secondary),
                                onPressed: null, // Logic handled by GestureDetector
                              ),
                            ),
                          )),
                        ],
                      ),
                    ],
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

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}