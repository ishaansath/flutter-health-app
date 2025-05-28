// lib/settings_page.dart (UPDATED - Removed AccountSettingsPage definition)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ishaan/help_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
// NEW: Import the new AccountSettingsPage file
import 'package:ishaan/account_settings.dart';
// import 'package:ishaan/data/auth_firebase_data.dart'; // No longer needed here as logout is in AccountSettingsPage

// Placeholder for future About Page (kept simple)
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        title: Text(
          'About App',
          style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: Center(
        child: Text(
          'About Page Content (Coming Soon!)',
          style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground),
        ),
      ),
    );
  }
}


class SettingsPage extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const SettingsPage({super.key, required this.themeModeNotifier});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode _currentSelectedThemeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _currentSelectedThemeMode = widget.themeModeNotifier.value;
    widget.themeModeNotifier.addListener(_onThemeNotifierChanged);
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
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        elevation: 0,
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        children: [
          // --- Profile Picture and Name (Top Center) ---
          Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.secondary,
                      width: 3.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: colorScheme.surface,
                    backgroundImage: currentUser?.photoURL != null
                        ? NetworkImage(currentUser!.photoURL!)
                        : null,
                    child: currentUser?.photoURL == null
                        ? Icon(
                      Icons.person,
                      color: colorScheme.onSurface,
                      size: 60,
                    )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  currentUser?.displayName ?? currentUser?.email ?? 'Guest User',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  currentUser?.email ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),

          // --- Account Settings Option ---
          // --- Account Settings Option ---
          _buildSettingsOption(
            context,
            theme,
            colorScheme,
            title: 'Account Settings',
            icon: Icons.account_circle,
            onTap: () async { // <--- ADD 'async' HERE
              await Navigator.push( // <--- ADD 'await' HERE
                context,
                MaterialPageRoute(builder: (context) => const AccountSettingsPage()),
              );
              // This block will execute AFTER you pop back from AccountSettingsPage
              if (mounted) {
                setState(() {
                  // This tells Flutter to rebuild the SettingsPage,
                  // which will re-read `FirebaseAuth.instance.currentUser`
                  // and update the displayed name/email.
                  print('SettingsPage: Refreshing UI after returning from Account Settings.');
                });
              }
            },
          ),
          const SizedBox(height: 16.0),

          // --- Theme Settings (Existing) ---
          _buildThemeExpansionTile(context, theme, colorScheme),
          const SizedBox(height: 16.0),

          // --- Help Page Link (Existing) ---
          _buildSettingsOption(
            context,
            theme,
            colorScheme,
            title: 'Help',
            icon: Icons.help_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage(themeModeNotifier: ValueNotifier<ThemeMode>(ThemeMode.system),)),
              );
            },
          ),
          const SizedBox(height: 16.0),

          // --- About Page Link ---
          _buildSettingsOption(
            context,
            theme,
            colorScheme,
            title: 'About',
            icon: Icons.info_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- Helper method for common settings options (Account, Help, About) ---
  Widget _buildSettingsOption(BuildContext context, ThemeData theme, ColorScheme colorScheme, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Icon(
          icon,
          color: colorScheme.onSecondary,
          size: 24.0,
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSecondary),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: colorScheme.onSecondary.withOpacity(0.7),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildThemeExpansionTile(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Card(
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 0.0),
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
            side: const BorderSide(color: Colors.transparent),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(color: Colors.transparent),
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
}