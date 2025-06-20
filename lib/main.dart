import 'package:fintrack_app/Api/firebase_api.dart';
import 'package:fintrack_app/Data/expense_data.dart';
import 'package:fintrack_app/Main%20Screens/Homepage.dart';
import 'package:fintrack_app/Navigation.dart';
import 'package:fintrack_app/notifications.dart';
import 'package:fintrack_app/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fintrack_app/Onboarding/Splashscreen.dart';
import 'package:fintrack_app/providers/theme_provider.dart';

final navigatorkey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  final prefs = await SharedPreferences.getInstance();

  // Load theme preference
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ThemeProvider()..setTheme(initialTheme)),
        ChangeNotifierProvider(create: (context) => ExpenseData()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Fintrack App',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
            navigatorKey: navigatorkey,
            routes: {
              '/notification_screen': (context) => const Notifications(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
