import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cognitive_mode_selection.dart';
import 'teacher_mode_dashboard.dart';

void main() {
  
  runApp(const NeuroNestApp());
}

class NeuroNestApp extends StatelessWidget {
  const NeuroNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NeuroNest',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 420,
              maxHeight: 800,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.04),
                    const Text(
                      '🧠 NeuroNest',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Cognitive Rehab & Autism Learning Support',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.05),

                    InteractiveCard(
                      title: '🧠 Cognitive Rehab Mode',
                      subtitle: 'Memory • Focus • Flexibility (ADHD & MCI)',
                       color: Colors.blueAccent,
                       onTap: () {
                        Navigator.push(
                          context,
                           MaterialPageRoute(builder: (_) => const CognitiveModeSelectionScreen()),
                        );
                       },

                    ),
                    SizedBox(height: screenHeight * 0.06),
                    
                    InteractiveCard(
                      title: '👩‍🏫 Teacher Mode (Autism)',
                      subtitle: 'Tools for Teaching Autistic Children',
                      color: Colors.green,
                      onTap: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TeacherModeDashboard()),
                         );
                      },

                    ),
                    SizedBox(height: screenHeight * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BottomIcon(icon: Icons.bar_chart, label: 'Progress', onTap: () {}),
                        BottomIcon(icon: Icons.settings, label: 'Settings', onTap: () {}),
                        BottomIcon(icon: Icons.info, label: 'About', onTap: () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InteractiveCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const InteractiveCard({super.key, 
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const BottomIcon({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.blueGrey),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class CognitiveModeScreen extends StatelessWidget {
  const CognitiveModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cognitive Rehab Mode')),
      body: const Center(child: Text('Cognitive Mode Games Coming Soon...')),
    );
  }
}

class TeacherModeScreen extends StatelessWidget {
  const TeacherModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Mode (Autism)')),
      body: const Center(child: Text('Teacher Mode Tools Coming Soon...')),
    );
  }
}
