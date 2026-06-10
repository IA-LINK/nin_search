import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        children: [
          _card(
            context,
            Icons.people,
            "Users",
            "/admin-users",
          ),
          _card(
            context,
            Icons.receipt_long,
            "Transactions",
            "/admin-transactions",
          ),
          _card(
            context,
            Icons.analytics,
            "Analytics",
            "/admin-analytics",
          ),
        ],
      ),
    );
  }

  Widget _card(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
