import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'screens/about/about_screen.dart';
import 'screens/services/services_screen.dart';
import 'screens/contact/contact_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const HomeScreen(),

      routes: {
        '/about': (context) => const AboutScreen(),
        '/services': (context) => const ServicesScreen(),
        '/contact': (context) => const ContactScreen(),
      },
    );
  }
}
