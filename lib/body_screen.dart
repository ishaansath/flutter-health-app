// body_screen.dart
import 'package:flutter/material.dart';
import 'organ_detail_page.dart'; // Ensure correct import

class BodyScreen extends StatefulWidget {
  final String mode;
  final ValueNotifier<ThemeMode> themeModeNotifier;
  // Removed final Function(String) setMode; as BodyScreen will manage its own mode internally.

  const BodyScreen({
    super.key,
    required this.mode,
    required this.themeModeNotifier, required Null Function(String mode) setMode,
    // Removed setMode from constructor
  });

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  late String _currentMode;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode; // Initialize with the mode passed from HomePage
    widget.themeModeNotifier.addListener(_updateThemeIcon);
  }

  @override
  void dispose() {
    widget.themeModeNotifier.removeListener(_updateThemeIcon);
    super.dispose();
  }

  void _updateThemeIcon() {
    if (mounted) {
      setState(() {
        // Force a rebuild for the theme icon when theme changes.
      });
    }
  }

  void _toggleTheme() {
    widget.themeModeNotifier.value =
    widget.themeModeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  void _toggleMode() {
    setState(() {
      _currentMode = _currentMode == 'normal' ? 'fun' : 'normal';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    const TextStyle emojiStyle = TextStyle(fontSize: 20);

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        title: Text(
          _currentMode == 'fun' ? '' : '',
        ),
        automaticallyImplyLeading: false, // Keep this if you don't want a back button by default
        // AppBar actions are now removed as toggles are moved to body
      ),
      body: Stack( // Use a Stack to position elements freely
        children: [
          Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final height = constraints.maxHeight;
                  final width = height / 2.2;

                  return Center(
                    child: SizedBox(
                      height: height,
                      width: width,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/body_outline.png', fit: BoxFit.contain),
                          // Brain
                          Positioned(
                            top: height * 0.1999,
                            left: width * 0.45,
                            child: GestureDetector(
                              onTap: () => showOrganDialog(context, "Brain"),
                              child: Text("🧠", style: emojiStyle),
                            ),
                          ),
                          // Eyes
                          Positioned(
                            top: height * 0.23,
                            left: width * 0.45,
                            child: GestureDetector(
                              onTap: () => showOrganDialog(context, "Eyes"),
                              child: Text("👁", style: emojiStyle),
                            ),
                          ),
                          // Heart
                          Positioned(
                            top: height * 0.31,
                            left: width * 0.5,
                            child: GestureDetector(
                              onTap: () => showOrganDialog(context, "Heart"),
                              child: Text("❤", style: emojiStyle),
                            ),
                          ),
                          // Lungs
                          Positioned(
                            top: height * 0.35,
                            left: width * 0.45,
                            child: GestureDetector(
                              onTap: () => showOrganDialog(context, "Lungs"),
                              child: Text("🫁", style: emojiStyle),
                            ),
                          ),
                          // Muscles
                          Positioned(
                            top: height * 0.39,
                            left: width * 0.28,
                            child: GestureDetector(
                              onTap: () => showOrganDialog(context, "Muscles"),
                              child: Text("💪", style: emojiStyle),
                            ),
                          ),
                          // Stomach
                          Positioned(
                            top: height * 0.43,
                            left: width * 0.45,
                            child: GestureDetector(
                              onTap: () => showOrganDialog(context, "Stomach"),
                              child: Text("🍽", style: emojiStyle),
                            ),
                          ),
                          // Legs
                          Positioned(
                            top: height * 0.62,
                            left: width * 0.37,
                            child: GestureDetector(
                              onTap: () => showOrganDialog(context, "Legs"),
                              child: Text("🦵", style: emojiStyle),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // --- Theme Toggle Button (Bottom Left) ---
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              heroTag: 'theme_toggle', // Unique tag for multiple FABs
              onPressed: _toggleTheme,
              backgroundColor: colorScheme.secondary, // Or primary, based on preference
              foregroundColor: colorScheme.onSecondary, // Or onPrimary
              child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            ),
          ),

          // --- Mode Toggle Switch (Bottom Right) ---
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surface, // Background for the toggle button
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: _toggleMode,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _currentMode == 'normal' ? 'Normal' : 'Fun',
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _currentMode == 'fun', // True if 'fun' mode
                      onChanged: (newValue) => _toggleMode(), // Toggles mode on change
                      activeColor: colorScheme.secondary, // Color when switch is ON (fun mode)
                      inactiveThumbColor: colorScheme.secondary, // Color when switch is OFF (normal mode)
                      inactiveTrackColor: colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showOrganDialog(BuildContext context, String organ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text(
          organ,
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          _currentMode == 'fun' ? "Would you like to learn more?" : "Would you like to learn more?",
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "No",
              style: TextStyle(color: colorScheme.error),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrganDetailPage(
                    organ: organ,
                    mode: _currentMode,
                  ),
                ),
              );
            },
            child: Text(
              "Yes",
              style: TextStyle(color: colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
}