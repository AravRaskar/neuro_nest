import 'package:flutter/material.dart';
import 'emotion_game.dart';
import 'memory_maze_game.dart';
import 'dual_task_game.dart'; // ✅ Import your MCI game

class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({Key? key}) : super(key: key);

  @override
  State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  // Student name
  final TextEditingController _nameController = TextEditingController();
  bool _nameEntered = false;

  // Symptoms mapped to possible conditions
  final Map<String, List<String>> symptomMap = {
    "Difficulty focusing": ["ADHD", "MCI"],
    "Forgetfulness": ["MCI", "ADHD"],
    "Repetitive behaviors": ["Autism"],
    "Trouble following instructions": ["ADHD", "Autism", "MCI"],
    "Poor social interaction": ["Autism"],
    "Hyperactivity": ["ADHD"],
    "Sensory sensitivities": ["Autism"],
    "Disorientation": ["MCI"],
    "Trouble organizing tasks": ["ADHD", "MCI"],
    "Language delay": ["Autism", "MCI"],
  };

  // State for checkboxes
  final Map<String, bool> selectedSymptoms = {};

  @override
  void initState() {
    super.initState();
    // Initialize all symptoms as unselected
    for (var symptom in symptomMap.keys) {
      selectedSymptoms[symptom] = false;
    }
  }

  void _checkConditions() {
    // Count how many selected symptoms match each condition
    Map<String, int> conditionCount = {
      "Autism": 0,
      "ADHD": 0,
      "MCI": 0,
    };

    selectedSymptoms.forEach((symptom, isSelected) {
      if (isSelected) {
        for (var condition in symptomMap[symptom]!) {
          conditionCount[condition] = conditionCount[condition]! + 1;
        }
      }
    });

    // If no symptoms selected
    if (conditionCount.values.every((count) => count == 0)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Assessment Result"),
          content:
              const Text("No symptoms selected. Please choose at least one."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
      return;
    }

    // Sort conditions by match count
    var sortedConditions = conditionCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    int topScore = sortedConditions.first.value;
    var likelyConditions = sortedConditions
        .where((e) => e.value == topScore)
        .map((e) => e.key)
        .toList();

    // Show result dialog with clickable condition buttons
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Assessment Result for ${_nameController.text}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Possible condition(s) based on selected symptoms:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: likelyConditions.map((condition) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    if (condition == "ADHD") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MemoryMazeGame(), // ✅ ADHD game
                        ),
                      );
                    } else if (condition == "MCI") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DualTaskGame(), // ✅ MCI game
                        ),
                      );
                    } else if (condition == "Autism") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmotionGame(),
                        ),
                      );
                    }
                  },
                  child: Text(condition),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const Text(
              "Note: This is just a primary medical diagnosis. Please consult a healthcare professional.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Symptom Checker"),
        backgroundColor: Colors.teal,
      ),
      body: !_nameEntered ? _buildNameInput() : _buildSymptomChecker(),
    );
  }

  // Step 1: Name input screen
  Widget _buildNameInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Enter Student's Name",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Name",
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter the student's name"),
                  ),
                );
                return;
              }
              setState(() {
                _nameEntered = true;
              });
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  // Step 2: Symptom checker screen
  Widget _buildSymptomChecker() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          "Hello, ${_nameController.text}! Select all symptoms that apply:",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...selectedSymptoms.keys.map((symptom) {
          return CheckboxListTile(
            title: Text(symptom),
            value: selectedSymptoms[symptom],
            onChanged: (bool? value) {
              setState(() {
                selectedSymptoms[symptom] = value ?? false;
              });
            },
          );
        }).toList(),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _checkConditions,
          child: const Text("Check Results"),
        ),
      ],
    );
  }
}
