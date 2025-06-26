import 'package:fintrack_app/Onboarding/Welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack_app/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fintrack_app/providers/HelpScreen.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF005341),
                Color(0xFF00A86B),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text("Theme"),
        centerTitle: true,
      ),
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

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification Settings")),
      body: Padding(
        padding: EdgeInsets.all(2),
        child: Material(
          child: ListTile(
            title: Text("Allow All Notifications"),
            subtitle: Text(
                "Notifications concerning your budget and daily reminders will be enabled once you allow all notifications."),
            trailing: Switch(
              value: _isNotificationsEnabled,
              onChanged: (bool newValue) async {
                setState(() {
                  _isNotificationsEnabled = newValue;
                });
// <<<<<<< main
// =======
//                 await _saveNotificationPreference(newValue);
//                 if (newValue) {
//                   await _notiService.scheduleNotification(
//                     id: 1,
//                     title: "Notification",
//                     body: "You have enabled notifications",
//                     hour: 7,
//                     minute: 30,
//                   );
//                 } else {
//                   await _notiService.cancelAllNotifications();
//                 }
// >>>>>>> main
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF005341),
                  Color(0xFF00A86B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          UserProfileSection(),
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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpScreen()),
            ),
          ),
          // SettingsOption(
          //   icon: Icons.upload_file,
          //   title: "Export Data",
          //   backgroundColor: Colors.purple,
          //   onTap: () {},
          // ),
          SettingsOption(
            icon: Icons.notifications,
            title: "Notifications",
            backgroundColor: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationsPage()),
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

void _updatedialog(BuildContext context) {
  final TextEditingController usernameController = TextEditingController();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        content: SizedBox(
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Update your Username',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 300, // Force the TextField to be 300 pixels wide
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'New Username',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              TextButton(
                  onPressed: () async {
                    String newName = usernameController.text;
                    if (newName.isNotEmpty) {
                      User? user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        await user.updateDisplayName(newName);
                        await user.reload();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Username Updated")));
                      }
                    }
                  },
                  child: Text('Update')),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      );
    },
  );
}

class UserProfileSection extends StatelessWidget {
  UserProfileSection({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  final userimg = FirebaseAuth.instance.currentUser!.photoURL;

  @override
  Widget build(BuildContext context) {
    String username = user.displayName ?? "User";
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF005341),
            Color(0xFF43A047),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
            child: CircleAvatar(
              radius: 32,
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : const AssetImage("assets/images/icons8-user-48 (1).png")
                      as ImageProvider,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("Username",
                    style: TextStyle(fontSize: 16, color: Colors.white70)),
              ],
            ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade200,
          //     shape: BoxShape.circle,
          //   ),
          //   child: IconButton(
          //     icon: const Icon(Icons.edit, color: Colors.black),
          //     onPressed: () => _updatedialog(context),
          //   ),
          // ),
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
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Are you sure you want to logout?",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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
