// lib/help_page.dart (MODIFIED to act as tour page)

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ishaan/main.dart' hide lastVisitedOrganNotifier, lastVisitedNutritionNotifier;
import 'package:ishaan/shared_preferences_helper.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart'; // NEW: For tour completion tracking
import 'package:ishaan/body_screen.dart'; // NEW: Import your main app screen

// Data model for your carousel items (unchanged)
class HelpCarouselItem {
  final String title;
  final String description;
  final String? imageUrl;
  final String? videoUrl;
  final IconData? icon;

  HelpCarouselItem({
    required this.title,
    required this.description,
    this.imageUrl,
    this.videoUrl,
    this.icon,
  });
}

// Dedicated Widget for Video Player within the Carousel (unchanged)
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _controllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _controllerInitialized = true;
          });
          if (widget.autoPlay) {
            _controller.play();
            setState(() {
              _isPlaying = true;
            });
          }
        }
      }).catchError((error) {
        print("Error initializing video player: $error");
        if (mounted) {
          setState(() {
            _controllerInitialized = false;
          });
        }
      });

    _controller.addListener(() {
      if (mounted) {
        if (_controller.value.isPlaying && !_isPlaying) {
          setState(() {
            _isPlaying = true;
          });
        } else if (!_controller.value.isPlaying && _isPlaying && _controller.value.isInitialized) {
          setState(() {
            _isPlaying = false;
          });
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoUrl != oldWidget.videoUrl) {
      _controller.dispose();
      _initializeVideoPlayer();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!_controllerInitialized) {
      return Center(child: CircularProgressIndicator(color: colorScheme.secondary));
    }

    if (_controller.value.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            Text(
              'Error playing video',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        VideoProgressIndicator(_controller, allowScrubbing: true, colors: VideoProgressColors(
          playedColor: colorScheme.secondary,
          bufferedColor: colorScheme.secondary.withOpacity(0.3),
          backgroundColor: colorScheme.onSecondary.withOpacity(0.3),
        )),
        Positioned.fill(
          child: Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                  _isPlaying = _controller.value.isPlaying;
                });
              },
              child: AnimatedOpacity(
                opacity: _isPlaying ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 40.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Main HelpPage Widget - NOW ALSO SERVES AS THE TOUR PAGE
class HelpPage extends StatefulWidget {
  // NEW: Add themeModeNotifier as a required parameter
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const HelpPage({super.key, required this.themeModeNotifier});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<HelpCarouselItem> _carouselItems = [
    HelpCarouselItem(
        title: 'Welcome to the App!',
        description: 'Take a quick tour to understand its key features and get started easily.',
        icon: Icons.info_outline,
        imageUrl: 'assets/welcome page.png' // Make sure this asset exists
    ),
    HelpCarouselItem(
        title: 'Understanding the Body Tab',
        description: 'Tap on different organs to learn about their functions and importance for your health.',
        icon: Icons.accessibility_new,
        videoUrl: 'assets/videos/body_screen_help.mp4' // Make sure this asset exists
    ),
    HelpCarouselItem(
      title: 'Watch a Quick Demo',
      description: 'See how easily you can navigate the app\'s main features in this short video!',
      videoUrl: 'assets/videos/my_help_video.mp4', // <--- REPLACE with your actual video path
    ),
    HelpCarouselItem(
      title: 'Visual Guide Example',
      description: 'Here\'s a helpful image related to our features. Images can clarify complex topics!',
      imageUrl: 'assets/images/help_carousel_image.png', // <--- REPLACE with your actual image path
    ),
    HelpCarouselItem(
      title: 'Navigating Nutrition',
      description: 'Discover healthy food options and their benefits. Learn what makes a balanced diet.',
      icon: Icons.fastfood,
    ),
    HelpCarouselItem(
      title: 'Meet Our Mascot',
      description: 'Interact with our friendly mascot and learn about their role in guiding your health journey.',
      icon: Icons.pets,
    ),
    HelpCarouselItem(
      title: 'Normal vs. Fun Mode',
      description: 'Switch between modes to change the app\'s tone. Normal provides factual info, Fun mode offers an engaging experience.',
      icon: Icons.toggle_on,
    ),
    HelpCarouselItem(
      title: 'Need More Help?',
      description: 'If you have further questions, please reach out to our support team.',
      icon: Icons.support_agent,
    ),
  ];

  // NEW: Function to mark tour as completed and navigate
  Future<void> _markTourCompletedAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedTour', true); // Mark as completed
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => BodyScreen(themeModeNotifier: widget.themeModeNotifier, mode: 'mode', bodyModelNotifier: bodyModelNotifier, lastVisitedOrganNotifier: lastVisitedOrganNotifier,lastVisitedNutritionNotifier: lastVisitedNutritionNotifier),
      ),
          (Route<dynamic> route) => false, // Clear all previous routes
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary, // AppBar background color will be transparent
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent to show body background
        elevation: 0,
        title: Text(
          'App Tour', // Changed title to reflect its tour purpose
          style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onSecondary),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onPrimary), // Changed to onPrimary for contrast
        // You might want to remove the back button during the initial tour
        // automaticallyImplyLeading: false,
      ),
      body: Column( // Use Column to place Carousel above buttons
        children: [
          Expanded(
            child: CarouselSlider.builder(
              itemCount: _carouselItems.length,
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                final item = _carouselItems[itemIndex];
                return Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (item.videoUrl != null)
                          Container(
                            height: 325,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: VideoPlayerWidget(videoUrl: item.videoUrl!),
                          )
                        else if (item.imageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              item.imageUrl!,
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                          )
                        else if (item.icon != null)
                            Icon(item.icon, size: 50, color: colorScheme.secondary),
                        const SizedBox(height: 15.0),
                        Text(
                          item.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSecondary, // Changed to onSurface for better contrast on surface color
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          item.description,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.7, // Adjust height
                enlargeCenterPage: true,
                autoPlay: false,
                aspectRatio: 9/16,
                viewportFraction: 0.85,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
          // NEW: Skip Tour / Continue Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _markTourCompletedAndNavigate, // Skip also marks as completed
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onSecondary, // Text color matches AppBar's onPrimary
                  ),
                  child: Text(
                    'Skip Tour',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}