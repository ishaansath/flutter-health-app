// lib/settings_page.dart (MODIFIED - Lottie animation based on theme)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ishaan/help_page.dart';
import 'package:ishaan/auth_firebase_data.dart'; // Ensure this is imported correctly
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ishaan/account_settings.dart'; // Ensure this import is correct
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ishaan/mascot_provider.dart';
import 'package:ionicons/ionicons.dart';

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
          style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onSecondary),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onSecondary),
      ),
      body: Center(
        child: Text(
          'About Page Content (Coming Soon!)',
          style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary),
        ),
      ),
    );
  }
}


class SettingsPage extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;
  final ValueNotifier<String> bodyModelNotifier;

  const SettingsPage({
    super.key,
    required this.themeModeNotifier,
    required this.bodyModelNotifier,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode _currentSelectedThemeMode = ThemeMode.system;
  String _currentSelectedBodyModel = 'male_body'; // Default to male body
  UserProfile? _userProfile; // NEW: Holds user profile data from Firestore
  bool _isLoadingProfile = true; // NEW: State to manage profile loading

  // Instantiate your AuthFirebaseDataSource
  final AuthFirebaseDataSource _authService = AuthFirebaseDataSourceImpl();

  @override
  void initState() {
    super.initState();
    _currentSelectedThemeMode = widget.themeModeNotifier.value;
    widget.themeModeNotifier.addListener(_onThemeNotifierChanged);

    _currentSelectedBodyModel = widget.bodyModelNotifier.value;
    widget.bodyModelNotifier.addListener(_onBodyModelNotifierChanged);
    print('SettingsPage: Initial bodyModelNotifier value: ${widget.bodyModelNotifier.value}');

    _loadUserProfile(); // NEW: Load user profile on init
  }

  @override
  void dispose() {
    widget.themeModeNotifier.removeListener(_onThemeNotifierChanged);
    widget.bodyModelNotifier.removeListener(_onBodyModelNotifierChanged);
    super.dispose();
  }

  void _onThemeNotifierChanged() {
    if (mounted) {
      setState(() {
        _currentSelectedThemeMode = widget.themeModeNotifier.value;
      });
    }
  }

  void _onBodyModelNotifierChanged() {
    if (mounted) {
      setState(() {
        _currentSelectedBodyModel = widget.bodyModelNotifier.value;
      });
      print('SettingsPage: _onBodyModelNotifierChanged triggered. New local value: $_currentSelectedBodyModel');
    }
  }

  // NEW: Method to load user profile from Firestore
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoadingProfile = true;
    });
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final profile = await _authService.getUserProfile(currentUser.uid);
        setState(() {
          _userProfile = profile;
        });
        print('SettingsPage: User profile loaded: ${_userProfile?.firstName} ${_userProfile?.lastName}');
      } catch (e) {
        print('SettingsPage: Error loading user profile: $e');
        setState(() {
          _userProfile = null; // Clear profile on error
        });
      }
    } else {
      print('SettingsPage: No current user to load profile for.');
      setState(() {
        _userProfile = null;
      });
    }
    setState(() {
      _isLoadingProfile = false;
    });
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

  Future<void> _saveBodyModel(String modelKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedBodyModel', modelKey);
    widget.bodyModelNotifier.value = modelKey;
    print('SettingsPage: bodyModelNotifier updated to "${widget.bodyModelNotifier.value}" and saved to SharedPreferences.');
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light Theme';
      case ThemeMode.dark:
        return 'Dark Theme';
      default:
        return 'Unknown';
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

  String _getBodyModelDisplayName(String modelKey) {
    switch (modelKey) {
      case 'male_body':
        return 'Male Body';
      case 'female_body':
        return 'Female Body';
      default:
        return 'Male Body'; // Default to Male Body
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final User? currentUser = FirebaseAuth.instance.currentUser; // Still need currentUser for photoURL/email

    // Determine the Lottie animation path based on the current theme mode
    String lottieAssetPath;
    if (_currentSelectedThemeMode == ThemeMode.dark) {
      lottieAssetPath = 'assets/animations/dark/loading.json';
    } else {
      // Default to light theme animation if it's light mode or system mode (which will resolve to light if system is light)
      lottieAssetPath = 'assets/animations/light/loading.json';
    }

    return Consumer<MascotProvider>(
      builder: (context, mascotProvider, child) {
        return Scaffold(
          backgroundColor: colorScheme.primary,
          appBar: AppBar(
            backgroundColor: colorScheme.primary,
            elevation: 0,
            title: Text(
              'Settings',
              style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onSecondary),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: colorScheme.onSecondary),
          ),
          body: _isLoadingProfile
              ? Center(
            child: Lottie.asset(
              lottieAssetPath, // Use the dynamically determined path
              height: 100,
              width: 100,
            ),
          )
              : ListView(
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
                    // NEW: Display first and last name from _userProfile
                    Text(
                      (_userProfile?.firstName?.isNotEmpty == true && _userProfile?.lastName?.isNotEmpty == true)
                          ? '${_userProfile!.firstName} ${_userProfile!.lastName}'
                          : currentUser?.email ?? 'Guest User', // Fallback to email or Guest
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      currentUser?.email ?? '', // Still display email below
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
              _buildSettingsOption(
                context,
                theme,
                colorScheme,
                title: 'Account Settings',
                icon: Icons.account_circle,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountSettingsPage(themeModeNotifier: widget.themeModeNotifier)),
                  );
                  // NEW: Reload user profile after returning from AccountSettingsPage
                  if (mounted) {
                    print('SettingsPage: Returned from Account Settings. Reloading user profile...');
                    await _loadUserProfile();
                    // No need for setState directly here, _loadUserProfile does it
                  }
                },
              ),
              const SizedBox(height: 16.0),

              // --- NEW: Mascot Selection Option ---
              _buildMascotSelectionTile(context, theme, colorScheme, mascotProvider),
              const SizedBox(height: 16.0),

              // --- Theme Settings (Existing) ---
              _buildThemeExpansionTile(context, theme, colorScheme),
              const SizedBox(height: 16.0),

              // --- NEW: Body Model Selection ---
              _buildBodyModelExpansionTile(context, theme, colorScheme),
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
                    MaterialPageRoute(builder: (context) => HelpPage(themeModeNotifier: widget.themeModeNotifier)),
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
      },
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

  // --- NEW: Body Model Selection Expansion Tile ---
  Widget _buildBodyModelExpansionTile(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
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
                Icons.accessibility_new, // Icon for body model
                color: colorScheme.onSecondary,
                size: 24.0,
              ),
              const SizedBox(width: 12.0),
              Text(
                'Body Model',
                style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSecondary),
              ),
            ],
          ),
          subtitle: Text(
            _getBodyModelDisplayName(_currentSelectedBodyModel),
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSecondary.withOpacity(0.7)),
          ),
          iconColor: colorScheme.onSecondary,
          collapsedIconColor: colorScheme.onSecondary.withOpacity(0.7),
          children: <Widget>[
            Column(
              children: [
                RadioListTile<String>(
                  title: Text(
                    'Male Body',
                    style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary),
                  ),
                  value: 'male_body', // Corresponds to 'assets/models/male_body.glb'
                  groupValue: _currentSelectedBodyModel,
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _currentSelectedBodyModel = value;
                      });
                      widget.bodyModelNotifier.value = value; // Update the notifier
                      _saveBodyModel(value); // Save to SharedPreferences
                    }
                  },
                  activeColor: colorScheme.secondary,
                ),
                RadioListTile<String>(
                  title: Text(
                    'Female Body',
                    style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary),
                  ),
                  value: 'female_body', // Corresponds to 'assets/models/female_body.glb'
                  groupValue: _currentSelectedBodyModel,
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _currentSelectedBodyModel = value;
                      });
                      widget.bodyModelNotifier.value = value; // Update the notifier
                      _saveBodyModel(value); // Save to SharedPreferences
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

  // --- NEW: Helper method for Selection ---
  Widget _buildMascotSelectionTile(BuildContext context, ThemeData theme, ColorScheme colorScheme, MascotProvider mascotProvider) {
    return Card(
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Icon(
          Icons.sentiment_satisfied_alt, // Icon for mascot
          color: colorScheme.onSecondary,
          size: 24.0,
        ),
        title: Text(
          'Hero',
          style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSecondary),
        ),
        subtitle: Text(
          'Current: ${mascotProvider.currentMascotName}', // Show current mascot
          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSecondary.withOpacity(0.7)),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: colorScheme.onSecondary.withOpacity(0.7),
        ),
        onTap: () => _showMascotSelectionDialog(context, mascotProvider, theme, colorScheme),
      ),
    );
  }

  // --- NEW: Mascot Selection Dialog ---
  void _showMascotSelectionDialog(BuildContext context, MascotProvider mascotProvider, ThemeData theme, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (dialogContext) { // Use dialogContext to avoid conflicts
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(
            'Choose your Mascot',
            style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onBackground),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: mascotProvider.allMascotStaticPaths.length,
              itemBuilder: (context, index) {
                final mascotName = mascotProvider.allMascotStaticPaths.keys.elementAt(index);
                final mascotImagePath = mascotProvider.allMascotStaticPaths[mascotName];

                return ListTile(
                  leading: Image.asset(
                    mascotImagePath!, // Use static image for preview
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    mascotName,
                    style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground),
                  ),
                  trailing: mascotProvider.currentMascotName == mascotName
                      ? Icon(Icons.check, color: colorScheme.secondary)
                      : null,
                  onTap: () {
                    mascotProvider.setMascot(mascotName);
                    Navigator.pop(dialogContext); // Pop the dialog
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.secondary),
              ),
            ),
          ],
        );
      },
    );
  }
}