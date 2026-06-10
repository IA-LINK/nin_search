import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: const Color(0xFF0F0F0F),
      child: Column(
        children: [
          // HEADER
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black),
            ),
            accountName: Text(user?.email ?? "VTU User"),
            accountEmail: Text(user?.email ?? "No email"),
          ),

          _buildItem(context,
              icon: Icons.dashboard,
              title: "Dashboard",
              route: "/home"),

          _buildItem(context,
              icon: Icons.phone_android,
              title: "Buy Airtime",
              route: "/data"), // FIXED (mapped properly)

          _buildItem(context,
              icon: Icons.wifi,
              title: "Buy Data",
              route: "/data"),

          _buildItem(context,
              icon: Icons.account_balance_wallet,
              title: "Wallet",
              route: "/fund-wallet"), // FIXED

          _buildItem(context,
              icon: Icons.history,
              title: "History",
              route: "/history"),

          const Spacer(),

          const Divider(color: Colors.grey),

          // LOGOUT
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout",
                style: TextStyle(color: Colors.red)),
            onTap: () async {
              try {
                await context.read<AuthService>().signOut();

                if (!context.mounted) return;

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              } catch (e) {
                debugPrint("Logout error: $e");
              }
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
