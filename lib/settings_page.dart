// lib/settings_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ishaan/help_page.dart'; // NEW: Import your HelpPage

class SettingsPage extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const SettingsPage({super.key, required this.themeModeNotifier});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode _currentSelectedThemeMode = ThemeMode.system;
  bool _isHelpPanelExpanded = false; // NEW: State for Help panel expansion

  @override
  void initState() {
    super.initState();
    _currentSelectedThemeMode = widget.themeModeNotifier.value;
    widget.themeModeNotifier.addListener(_onThemeNotifierChanged);
    _isHelpPanelExpanded = false; // Initialize to collapsed
  }

  @override
  void dispose() {
    widget.themeModeNotifier.removeListener(_onThemeNotifierChanged);
    super.dispose();
  }

  void _onThemeNotifierChanged() {
    if (mounted) {
      setState(() {
        _currentSelectedThemeMode = widget.themeModeNotifier.value;
      });
    }
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String themeModeString;
    switch (mode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      case ThemeMode.system:
        themeModeString = 'system';
        break;
    }
    await prefs.setString('appThemeMode', themeModeString);
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light Theme';
      case ThemeMode.dark:
        return 'Dark Theme';
    }
  }

  IconData _getThemeModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return Icons.settings_brightness;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      default:
        return Icons.brightness_auto;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSecondary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildThemeExpansionTile(context, theme, colorScheme),
          const SizedBox(height: 16.0), // Space between panels
          _buildHelpExpansionTile(context, theme, colorScheme), // NEW: Add the Help section
          // Add more settings sections here if needed
        ],
      ),
    );
  }

  Widget _buildThemeExpansionTile(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    // Re-using the logic from the previous response for Theme expansion panel
    // It is important to keep the isExpanded state for this panel if it exists
    // in the previous version, or introduce it if not (like I did with _isThemePanelExpanded
    // in previous responses that was then removed).
    // For this specific code, the theme panel doesn't have an expanded state variable
    // controlled by the SettingsPage itself, as it's an ExpansionTile.
    // If you had it before, ensure it's still managed.
    // For now, I'll assume it behaves like a standard ExpansionTile.

    return Card(
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Theme(
        data: theme.copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          unselectedWidgetColor: colorScheme.onSecondary,
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          backgroundColor: colorScheme.surface,
          collapsedBackgroundColor: colorScheme.surface,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.transparent),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.transparent),
          ),
          clipBehavior: Clip.antiAlias,
          title: Row(
            children: [
              Icon(
                _getThemeModeIcon(_currentSelectedThemeMode),
                color: colorScheme.onSecondary,
                size: 24.0,
              ),
              const SizedBox(width: 12.0),
              Text(
                'Theme',
                style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSecondary),
              ),
            ],
          ),
          subtitle: Text(
            _getThemeModeName(_currentSelectedThemeMode),
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSecondary.withOpacity(0.7)),
          ),
          iconColor: colorScheme.onSecondary,
          collapsedIconColor: colorScheme.onSecondary.withOpacity(0.7),
          children: <Widget>[
            Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(
                    'System Default',
                    style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary),
                  ),
                  value: ThemeMode.system,
                  groupValue: _currentSelectedThemeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      setState(() {
                        _currentSelectedThemeMode = value;
                      });
                      widget.themeModeNotifier.value = value;
                      _saveThemeMode(value);
                    }
                  },
                  activeColor: colorScheme.secondary,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(
                    'Light Theme',
                    style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary),
                  ),
                  value: ThemeMode.light,
                  groupValue: _currentSelectedThemeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      setState(() {
                        _currentSelectedThemeMode = value;
                      });
                      widget.themeModeNotifier.value = value;
                      _saveThemeMode(value);
                    }
                  },
                  activeColor: colorScheme.secondary,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(
                    'Dark Theme',
                    style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary),
                  ),
                  value: ThemeMode.dark,
                  groupValue: _currentSelectedThemeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      setState(() {
                        _currentSelectedThemeMode = value;
                      });
                      widget.themeModeNotifier.value = value;
                      _saveThemeMode(value);
                    }
                  },
                  activeColor: colorScheme.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // NEW: Method to build the Help Expansion Tile
  Widget _buildHelpExpansionTile(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Card(
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Theme(
        data: theme.copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          unselectedWidgetColor: colorScheme.onSecondary,
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          backgroundColor: colorScheme.surface,
          collapsedBackgroundColor: colorScheme.surface,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.transparent),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.transparent),
          ),
          clipBehavior: Clip.antiAlias,
          title: Row( // Add icon to the title
            children: [
              Icon(
                Icons.help_outline, // Help icon
                color: colorScheme.onSecondary,
                size: 24.0,
              ),
              const SizedBox(width: 12.0),
              Text(
                'Help',
                style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSecondary),
              ),
            ],
          ),
          subtitle: Text(
            'Find answers to your questions',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSecondary.withOpacity(0.7)),
          ),
          iconColor: colorScheme.onSecondary,
          collapsedIconColor: colorScheme.onSecondary.withOpacity(0.7),
          children: <Widget>[
            Padding( // Add padding around the button for better spacing
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SizedBox( // Make the button full width
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpPage()), // Navigate to HelpPage
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary, // Button background color
                    foregroundColor: colorScheme.onSecondary, // Text/icon color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: Text(
                    'Learn More',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}