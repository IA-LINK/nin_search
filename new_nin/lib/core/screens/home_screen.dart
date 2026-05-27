import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/hero_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("VTU Platform"),
      ),

      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          HeroSlider(),

          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Utility Payment Solution",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Start Paying"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
