import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false; // For theme toggle

  final user = FirebaseAuth.instance.currentUser;

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Your login route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          // Profile Section
          ListTile(
            leading: const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(user?.displayName ?? "User Name"),
            subtitle: Text(user?.email ?? "No Email"),
          ),
          const Divider(),

          // Theme Switch
          SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
            value: isDarkMode,
            onChanged: (bool value) {
              setState(() {
                isDarkMode = value;
              });
              // TODO: Add theme change logic
            },
          ),
          const Divider(),

          // About App
          ListTile(
            leading: const Icon(Icons.info, color: Colors.deepPurple),
            title: const Text("About NeuroNest"),
            subtitle: const Text(
                "NeuroNest is a cognitive and communication support app for ADHD, MCI, and Autism."),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "NeuroNest",
                applicationVersion: "1.0.0",
                children: [
                  const Text(
                    "NeuroNest combines games, communication tools, and progress tracking "
                    "to support children and teachers.",
                  )
                ],
              );
            },
          ),
          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
