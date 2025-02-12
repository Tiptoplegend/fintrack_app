import 'package:fintrack_app/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fintrack_app/Onboarding/Splashscreen.dart';
import 'package:fintrack_app/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Load theme preference before starting the app
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? themeString = prefs.getString('themeMode');
  ThemeMode initialTheme = ThemeMode.system;

  if (themeString != null && themeString.contains('dark')) {
    initialTheme = ThemeMode.dark;
  } else if (themeString != null && themeString.contains('light')) {
    initialTheme = ThemeMode.light;
  }

  runApp(FinTrackApp(initialTheme));
}

class FinTrackApp extends StatelessWidget {
  final ThemeMode initialTheme;

  const FinTrackApp(this.initialTheme, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
  ThemeProvider themeProvider = ThemeProvider();
  themeProvider.setTheme(initialTheme);
  return themeProvider;
},

      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Fintrack App',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
