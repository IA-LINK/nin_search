// TODO Implement this library.
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VTU App"),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text("Welcome to NIN Searching Button 🚀"),
      ),
    );
  }
}
