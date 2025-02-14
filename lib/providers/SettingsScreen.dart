import 'package:fintrack_app/Onboarding/Welcome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack_app/providers/theme_provider.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Theme")),
      body: Column(
        children: [
          ListTile(
            onTap: () => themeProvider.setTheme(ThemeMode.light),
            leading: const Icon(Icons.wb_sunny, color: Colors.orange),
            title: const Text(
              "Light",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              activeColor: const Color.fromARGB(255, 55, 53, 53),
              onChanged: (value) => themeProvider.setTheme(ThemeMode.light),
            ),
          ),
          ListTile(
            onTap: () => themeProvider.setTheme(ThemeMode.dark),
            leading: const Icon(Icons.nightlight_round, color: Colors.blueGrey),
            title: const Text(
              "Dark",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              activeColor: Colors.white,
              onChanged: (value) => themeProvider.setTheme(ThemeMode.dark),
            ),
          ),
          ListTile(
            onTap: () => themeProvider.setTheme(ThemeMode.system),
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text(
              "Device theme",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              activeColor: Colors.white,
              onChanged: (value) => themeProvider.setTheme(ThemeMode.system),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Settings"),
      ),
      body: const Center(
        child: Text("Notification settings content goes here"),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const UserProfileSection(),
          const SizedBox(height: 16),
          SettingsOption(
            icon: Icons.color_lens,
            title: "Theme",
            backgroundColor: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ThemeSettingsScreen()),
            ),
          ),
          SettingsOption(
            icon: Icons.help_outline,
            title: "Help",
            backgroundColor: Colors.orange,
            onTap: () {},
          ),
          SettingsOption(
            icon: Icons.upload_file,
            title: "Export Data",
            backgroundColor: Colors.purple,
            onTap: () {},
          ),
          SettingsOption(
            icon: Icons.notifications,
            title: "Notifications",
            backgroundColor: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationSettingsScreen()),
            ),
          ),
          SettingsOption(
            icon: Icons.logout,
            title: "Logout",
            backgroundColor: Colors.red,
            onTap: () => showLogoutBottomSheet(context),
          ),
        ],
      ),
    );
  }
}

class UserProfileSection extends StatelessWidget {
  const UserProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[500],
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.purple, width: 2),
            ),
            child: const CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage("assets/images/profile.png"),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Iriana Saliha",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("Username",
                    style: TextStyle(fontSize: 16, color: Colors.white70)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color backgroundColor;
  final VoidCallback onTap;

  const SettingsOption({
    super.key,
    required this.icon,
    required this.title,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: backgroundColor, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.black54),
        onTap: onTap,
      ),
    );
  }
}

void showLogoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Logout?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Are you sure you want to logout?",
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Cancel",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Welcomepage()),
                          (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005341),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Logout",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
