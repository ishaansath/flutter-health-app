// item_detail_page.dart
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audio player package

class ItemDetailPage extends StatefulWidget { // Changed to StatefulWidget
  final String name;
  final String modelPath;
  final String description;
  final String additionalInfo;
  final String additionalInfoExtra;
  final String image;
  final String? normalModeAudioPath; // Make these nullable
  final String? funModeAudioPath;
  final String mode; // To determine normal/fun mode

  const ItemDetailPage({
    super.key, // Added Key? key
    required this.name,
    required this.modelPath,
    required this.description,
    required this.additionalInfo,
    required this.image,
    required this.additionalInfoExtra,
    this.normalModeAudioPath, // Made optional
    this.funModeAudioPath,    // Made optional
    required this.mode,       // Required mode
  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  late AudioPlayer _audioPlayer; // Audio player instance
  bool _isPlaying = false;      // State to track if audio is playing

  //  Replace with your actual GIF asset paths
  final String _mascotIdle = 'assets/mascot.png';
  final String _mascotTalkingGif = 'assets/gif/mascot_talking.gif';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Initialize the audio player

    // Listen for changes in player state to update UI (mascot GIF, button icon)
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    // Listen when audio completes to reset state
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of the player when the widget is disposed
    super.dispose();
  }

  // Function to toggle audio playback
  Future<void> _toggleAudioPlayback() async {
    final audioPath = widget.mode == 'fun' ? widget.funModeAudioPath : widget.normalModeAudioPath;

    if (audioPath == null || audioPath.isEmpty) {
      print('DEBUG: No audio path found for this item in ${widget.mode} mode. Audio will not play.');
      return;
    }

    print('DEBUG: Attempting to play audio from path: $audioPath');

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        print('DEBUG: Audio paused.');
      } else {
        await _audioPlayer.stop(); // Stop any existing playback
        await _audioPlayer.play(AssetSource(audioPath));
        print('DEBUG: Audio started playing.');
      }
    } catch (e) {
      print('DEBUG ERROR: Error playing audio: $e');
    }
    // <--- ADD THIS CLOSING BRACE HERE IF IT'S MISSING. This should be the end of _toggleAudioPlayback method.
  } // Ensure this is the correct closing brace for the method.


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary, // Use background for better consistency
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar color
        title: Text(widget.name, style: theme.textTheme.titleLarge), // White title
        iconTheme: IconThemeData(color: colorScheme.onSecondary), // White back arrow
        centerTitle: true,
      ),
      body: Stack( // Use a Stack for layering the mascot and button
        children: [
          SingleChildScrollView( // The main content
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  // Conditionally display the 3D model or image
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
                    const SizedBox(height: 20), // Spacing if no model or image

                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
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
                            textAlign: TextAlign.left, // Keep text alignment left
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.additionalInfoExtra,
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 100), // Add some space at the bottom
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Mascot GIF and Audio Button (Bottom Right) ---
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end, // Align button and GIF to the right
              children: [
                ElevatedButton.icon( // The audio button
                  onPressed: _toggleAudioPlayback,
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                    color: colorScheme.onPrimary,
                  ),
                  label: Text(
                    _isPlaying ? 'Pause' : 'Play',
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset( // The mascot GIF
                  _isPlaying ? _mascotTalkingGif : _mascotIdle,
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}