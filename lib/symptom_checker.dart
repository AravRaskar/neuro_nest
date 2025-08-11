import 'package:flutter/material.dart';

class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({Key? key}) : super(key: key);

  @override
  State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
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

    // Determine the most likely condition
    String result;
    if (conditionCount.values.every((count) => count == 0)) {
      result = "No symptoms selected. Please choose at least one.";
    } else {
      var sortedConditions = conditionCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      int topScore = sortedConditions.first.value;
      var likelyConditions =
          sortedConditions.where((e) => e.value == topScore).map((e) => e.key);

      result =
          "Possible condition(s) based on selected symptoms: ${likelyConditions.join(', ')}.\n\nNote: This is just a primary medical diagnosis. Please consult a ealthcare professional.";
    }

    // Show result
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Assessment Result"),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            "Select all symptoms that apply:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
