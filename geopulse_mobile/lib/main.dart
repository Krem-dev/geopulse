import 'package:flutter/material.dart';
import 'core/theme/appTheme.dart';
import 'ui/screens/onboardingScreen.dart';
import 'ui/screens/loginScreen.dart';
import 'ui/screens/signupScreen.dart';
import 'ui/screens/homeScreen.dart';
import 'ui/screens/mapScreen.dart';
import 'ui/screens/profileScreen.dart';
import 'ui/screens/savedNewsScreen.dart';
import 'ui/screens/notificationsScreen.dart';

void main() {
  runApp(const GeoPulseApp());
}

class GeoPulseApp extends StatelessWidget {
  const GeoPulseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoPulse',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/map': (context) => const MapScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/saved': (context) => const SavedNewsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
