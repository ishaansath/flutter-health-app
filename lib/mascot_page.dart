// lib/mascot_page.dart
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_event.dart'; // Keep this import for SpeechRecognitionStatus definition, even if not directly compared

// IMPORTANT: Replace with your actual Gemini API Key.
// For security, you should NOT hardcode this in a production app.
// Consider using environment variables or a secure configuration method.
const String apikey = 'AIzaSyB4q1yRNvlg0MRSImTbbzYddO6jpLTCMds'; // <<< REPLACE THIS!

class MascotPage extends StatefulWidget {
  const MascotPage({super.key});

  @override
  State<MascotPage> createState() => _MascotPageState();
}

class _MascotPageState extends State<MascotPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false; // For Gemini API calls (thinking/processing)
  bool _isListening = false; // For Speech-to-Text (microphone active)
  bool _isSpeaking = false; // For Text-to-Speech (mascot talking)

  // Gemini API setup
  late GenerativeModel _model;
  late ChatSession _chat;

  // TTS setup
  late FlutterTts flutterTts;
  String? _selectedVoiceName;
  String? _selectedVoiceLocale;

  // Speech-to-Text setup
  late SpeechToText _speechToText;
  String _lastWords = ''; // Stores the recognized speech (for internal tracking and display below mic)

  @override
  void initState() {
    super.initState();
    // Initialize Gemini model
    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apikey);

    // Initialize chat with a system instruction for Coco's persona and health focus
    _chat = _model.startChat(history: [
      Content.text(
          "You are Coco, a friendly health and nutrition assistant. You are a blue and amber colored bunny-sort of creature who wears space boots and a space suit. Your goal is to help users learn about health, their body, and nutrition. Please keep your responses focused on these topics and always refer to yourself as Coco. Never speak about anything other than health and nutrition! You can also speak about the history of health, nutrition and food items. Be fun and playful!  You can tell fun facts if they ask you about it! Even if they talk to you about nutrition or health within games, cinemas or anything other than what this app contains, try to avert the topic. This app is called Flutter Health App, don't mention it when you are introducing yourself. If they ask about this app, say the name and this app has information about your body and healthy fruits, vegetables, vitamins, nutrients, dairy, meat products, cereals and grains, fun facts, diseases, symptoms and so many more. It even features you, coco. It has a nutrition and a body tab. You can see all the food items in the nutrition tab and see about the body and it's organs in the body tab. It has a normal and a fun mode, light and dark theme. Fun mode is basically a Gen Z version of normal mode, suited to the younger kids of this generation. If they ask something in Gen Z/ Alpha slang, try to decipher the meaning and answer them. Also don't tell fun facts all the time, if there is no proper topic about food and nutrition don't tell it. If they specifically ask for fun facts or they talk about something unrelated to food and nutrition and health, then say fun facts. If they ask how sports is good for your body, elaborate. If they ask how to learn about organs, tell them to click on body tab on your top left and then they will see ton of organs displayed, if they click on it, it will take them to details of the specific organ. If they ask about how any food item is good for health, elaborate a lot and the last step is ask them to check the nutrition tab which is in the top center and then search for it to learn a lot more. If they ask, how do I learn about symptoms, diseases, fun facts, weekly diet, diary, pulses, cereals and grains about a specific organ, tell them to navigate to the body tab on the top left and click on the organ that they want to know and then under More button, all of these information will be present. If they ask about fruits, vegetables, meats and nutrients, tell them to navigate to the body tab on the top left and click on the organ that they want to know and then under whatever fruits, vegetables, meat products, nutrients are good for that specific organ will be displayed."
      )
    ]);

    // Initialize TTS
    flutterTts = FlutterTts();
    _initializeTts(); // This now also sets up TTS handlers

    // Initialize Speech-to-Text
    _speechToText = SpeechToText();
    _initSpeechToText();

    // MODIFIED: _speechToText.statusListener
    // This is the key change to reliably trigger send after speech.
    _speechToText.statusListener = (status) {
      if (mounted) {
        // Update the listening state first
        bool wasListening = _isListening; // Capture current state before update
        setState(() {
          _isListening = _speechToText.isListening; // This correctly reflects the current mic status
        });

        // Now, if we were listening and just stopped, AND we have words, then send them.
        if (wasListening && !_isListening && _lastWords.isNotEmpty) {
          _sendMessage(_lastWords); // Automatic send
          // Clear after sending to prevent re-sending on subsequent taps
        }
      }
    };
  }

  // TTS Initialization and Handlers
  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    // Set up TTS status handlers
    flutterTts.setStartHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = true;
          _isLoading = false; // Turn off Gemini loading state when speaking starts
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
          _isLoading = false; // Turn off loading/speaking state on error
        });
      }
    });

    // Attempt to set a specific voice
    final voices = await flutterTts.getVoices;
    const String desiredVoiceName = "Google US English"; // Example: Adjust if needed
    const String desiredVoiceLocale = "en-US"; // Example: Adjust if needed

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

  // Speech-to-Text Initialization
  Future<void> _initSpeechToText() async {
    bool available = await _speechToText.initialize(
      onError: (val) => print('STT Error: $val'),
    );
    if (available) {
      print("Speech-to-Text initialized and available.");
    } else {
      print("Speech-to-Text not available on this device.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition is not available on this device.')),
        );
      }
    }
    if (mounted) {
      setState(() {}); // Rebuild to show microphone status on UI
    }
  }

  // Start listening for speech
  void _startListening() async {
    if (!_speechToText.isAvailable) {
      print("Speech-to-Text is not available.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available.')),
      );
      return;
    }

    if (!_isListening) { // Only start if not already listening
      await flutterTts.stop(); // Stop TTS before starting STT to avoid conflicts
      _textController.clear(); // Clear any previous text in the input field
      _lastWords = ''; // Clear previous recognized speech

      if (mounted) {
        setState(() {
          _isListening = true; // Set state to true immediately for UI update
        });
      }


      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 20), // Max duration to listen (as per your current code)
        pauseFor: const Duration(seconds: 10), // Pause and stop if no speech for this duration (as per your current code)
        localeId: 'en_US', // Specify locale for better accuracy
        // Get updates as speech is recognized
      );
      print("Started listening...");
    }
  }

  // Stop listening for speech
  void _stopListening() async {
    if (_isListening) { // Only stop if currently listening
      await _speechToText.stop();
      print("Stopped listening.");
      // _isListening will be updated by the statusListener, which will then trigger _sendMessage
    }
  }

  // Callback when speech recognition results are available
  void _onSpeechResult(SpeechRecognitionResult result) {
    if (mounted) {
      setState(() {
        _lastWords = result.recognizedWords;
        // IMPORTANT: We do NOT update _textController.text here.
        // The text input field is kept separate for manual typing.
      });

      // If it's the final result, trigger stop. The statusListener will then send it.
      if (result.finalResult && _isListening) {
        _stopListening();
      }
    }
  }

  // --- NEW FUNCTION: Stop TTS immediately ---
  Future<void> _stopSpeaking() async {
    if (_isSpeaking) {
      await flutterTts.stop();
      if (mounted) {
        setState(() {
          _isSpeaking = false; // Manually update state as completion handler might not fire instantly
          _isLoading = false; // Also ensure loading is off
        });
      }
      print("TTS stopped by user.");
    }
  }

  // Send message to Gemini (called by automatic STT or manual text bar)
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) {
      _textController.clear(); // Clear empty input
      return;
    }

    // Stop listening if user types and sends, or if a previous STT was active
    if (_isListening) {
      _stopListening();
    }
    // Stop TTS if currently speaking
    if (_isSpeaking) {
      await flutterTts.stop();
    }

    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _isLoading = true; // Set loading true when sending to Gemini
    });
    _textController.clear(); // Clear the text field after sending


    try {
      final response = await _chat.sendMessage(Content.text(text));
      String? geminiResponse = response.text;

      // Remove markdown bolding (**) and other special characters
      if (geminiResponse != null) {
        geminiResponse = geminiResponse.replaceAll('**', ''); // Remove bolding
        geminiResponse = geminiResponse.replaceAll('*', '');   // Remove single asterisks (for italics/lists)
        geminiResponse = geminiResponse.replaceAll('```', ''); // Remove code block indicators
        geminiResponse = geminiResponse.replaceAll('`', '');   // Remove inline code indicators
        geminiResponse = geminiResponse.replaceAll('#', '');   // Remove hash for headings
      }

      if (mounted) {
        setState(() {
          _messages.add(Message(text: geminiResponse ?? 'No response from Coco.', isUser: false));
          // _isLoading will be set to false by TTS setStartHandler or if no text to speak
        });
      }


      if (geminiResponse != null && geminiResponse.isNotEmpty) {
        _speakResponse(geminiResponse);
      } else {
        // If there's no response from Gemini, turn off loading directly here.
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
          _isLoading = false; // Ensure loading is off even on error
          _isSpeaking = false; // Ensure speaking is off on error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Coco couldn\'t be contacted')),
        );
      }
      // Re-enable STT if it was the cause of the error or speech has stopped
      if (!_isSpeaking && !_isListening && _speechToText.isAvailable) {
        // Consider whether to re-enable listening automatically here.
        // For now, let's assume the user will tap mic again.
      }
    }
  }

  // Initiates Text-to-Speech
  Future<void> _speakResponse(String text) async {
    await flutterTts.stop(); // Stop any current speech
    await flutterTts.speak(text); // This will trigger setStartHandler and setCompletionHandler
  }

  // Scrolls the chat messages to the bottom

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    flutterTts.stop(); // Stop TTS playback
    _speechToText.stop(); // Stop STT listening
    _speechToText.cancel(); // Cancel any pending STT operations
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            // Increased bottom padding to prevent overlap with controls below
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Align(
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
              );
            },
          ),
        ),
        // Mascot Image, Voice Button, and Input Section - positioned at the bottom
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(16.0), // Padding around the whole input/mascot area
            color: Colors.transparent, // Background color for this area to cover content below
            child: Column(
              mainAxisSize: MainAxisSize.min, // Make column wrap its content tightly
              children: [
                // Mascot Image: Plays GIF when speaking, static when idle
                _isSpeaking
                    ? Image.asset(
                  'assets/gif/mascot_talking.gif', // <--- CORRECTED GIF PATH HERE
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                )
                    : Image.asset(
                  'assets/mascot.png', // Path to your static mascot image
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10), // Spacing below mascot image
                // Voice Button: Toggles listening, disabled if loading or speaking
                ElevatedButton.icon(
                  onPressed: (_isLoading || _isSpeaking || !_speechToText.isAvailable)
                      ? null // Disable button if loading, speaking, or STT not available
                      : (_isListening ? _stopListening : _startListening), // Toggle listening
                  icon: Icon(
                    _isListening ? Icons.mic_off : Icons.mic, // Mic icon based on listening state
                    color: _speechToText.isAvailable ? colorScheme.onSecondary : colorScheme.onSecondary.withOpacity(0.5),
                  ),
                  label: Text(
                    _isListening
                        ? 'Listening... Tap to Stop'
                        : (_speechToText.isAvailable ? 'Speak' : 'Speech Not Available'),
                    style: TextStyle(
                      color: _speechToText.isAvailable ? colorScheme.onSecondary : colorScheme.onSecondary.withOpacity(0.5),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _speechToText.isAvailable ? colorScheme.secondary : colorScheme.secondary.withOpacity(0.5),
                    foregroundColor: colorScheme.onSecondary,
                  ),
                ),
                // Display recognized text feedback
                if (_isListening) // Show "Recognizing" text only when listening
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Recognizing: "$_lastWords"',
                      style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                const SizedBox(height: 10), // Spacing before the text input
                // Text Input and Send/Stop Button (MODIFIED BLOCK)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Type your question...',
                          hintStyle: theme.textTheme.bodyMedium,// Hint text simplified
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                        onSubmitted: _sendMessage, // Send message on pressing enter
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // Conditional Button for Send/Stop
                    // If speaking, show a stop button. Otherwise, show send/loading.
                    _isSpeaking
                        ? IconButton( // Stop button
                      icon: Icon(Icons.stop_circle, color: colorScheme.secondary), // Use error color for stop
                      onPressed: _stopSpeaking, // Call the new _stopSpeaking function
                    )
                        : (_isLoading // If not speaking, check if loading
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: CircularProgressIndicator(color: colorScheme.secondary),
                    )
                        : IconButton( // Send button
                      icon: Icon(Icons.send, color: colorScheme.secondary),
                      onPressed: () => _sendMessage(_textController.text),
                    )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Helper class for chat messages
class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}