import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import 'ai_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile
          Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.secondaryColor,
                child: Text(
                  (authProvider.user?.displayName ?? 'U')[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              title: Text(authProvider.user?.displayName ?? 'User'),
              subtitle: Text(authProvider.user?.email ?? ''),
              trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
            ),
          ),
          const SizedBox(height: 16),

          // AI Settings
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.smart_toy, color: AppTheme.secondaryColor),
                  title: const Text('AI Settings'),
                  subtitle: const Text('Configure AI replies and templates'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const AISettingsScreen(),
                  )),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.auto_reply),
                  title: const Text('Auto Reply'),
                  subtitle: const Text('Automatically reply to messages'),
                  value: settingsProvider.autoReplyEnabled,
                  onChanged: (_) {},
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.language),
                  title: const Text('Urdu Support'),
                  subtitle: const Text('Enable Urdu/Roman Urdu replies'),
                  value: settingsProvider.urduSupportEnabled,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // General Settings
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode),
                  title: const Text('Dark Mode'),
                  value: settingsProvider.isDarkMode,
                  onChanged: (v) => settingsProvider.toggleTheme(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Notifications'),
                  subtitle: const Text('Manage notification preferences'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.storage_outlined),
                  title: const Text('Storage & Cache'),
                  subtitle: const Text('Clear cache, manage data'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Account
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
              onTap: () => authProvider.signOut(),
            ),
          ),
        ],
      ),
    );
  }
}
