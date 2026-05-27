import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              "VTU MENU",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
          ),

          ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
          ),

          ListTile(
            leading: Icon(Icons.miscellaneous_services),
            title: Text("Services"),
          ),

          ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text("Contact"),
          ),
        ],
      ),
    );
  }
}
