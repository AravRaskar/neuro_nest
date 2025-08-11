// lib/games/arrow_game.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArrowGamePage extends StatefulWidget {
  const ArrowGamePage({Key? key}) : super(key: key);

  @override
  _ArrowGamePageState createState() => _ArrowGamePageState();
}

class _ArrowGamePageState extends State<ArrowGamePage> {
  final Random random = Random();
  List<String> arrows = [];
  bool tapOpposite = false;
  int score = 0;
  int bestScore = 0;
  int round = 1;
  int level = 1;
  int timeLeft = 6;
  Timer? timer;

  static const String _bestScoreKey = 'arrowGameBestScore'; // unique key

  @override
  void initState() {
    super.initState();
    loadBestScore();
    startTurn();
  }

  void loadBestScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bestScore = prefs.getInt(_bestScoreKey) ?? 0;
    });
  }

  void saveBestScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bestScoreKey, bestScore);
  }

  void startTurn() {
    timer?.cancel();
    generateArrows();
    timeLeft = 6;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          t.cancel();
          showRetryDialog();
        }
      });
    });
  }

  void generateArrows() {
    arrows = List.generate(5, (_) => random.nextBool() ? '⬅' : '➡');
    tapOpposite = random.nextBool();
    setState(() {});
  }

  void checkAnswer(String tapped) {
    final String middle = arrows[2];
    final String correct = tapOpposite ? (middle == '⬅' ? '➡' : '⬅') : middle;

    if (tapped == correct) {
      setState(() => score++);
      if (score > bestScore) {
        bestScore = score;
        saveBestScore();
      }
      nextTurn();
    } else {
      timer?.cancel();
      showRetryDialog();
    }
  }

  void nextTurn() {
    timer?.cancel();
    if (level < 4) {
      level++;
    } else {
      if (round < 4) {
        round++;
        level = 1;
      } else {
        showGameOverDialog();
        return;
      }
    }
    startTurn();
  }

  void showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Oops!", style: TextStyle(color: Colors.white)),
        content: const Text(
          "You missed this one. What do you want to do?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                startTurn(); // Retry same level
              });
            },
            child:
                const Text("Retry Level", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                nextTurn(); // Continue to next level
              });
            },
            child:
                const Text("Continue", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 222, 222, 222),
        title: const Text("Game Over", style: TextStyle(color: Colors.white)),
        content: Text(
          "Your score: $score",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                score = 0;
                round = 1;
                level = 1;
              });
              startTurn();
            },
            child: const Text("Restart", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).maybePop(); // close game
            },
            child: const Text("Exit", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        timer?.cancel();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 224, 224, 224),
        appBar: AppBar(title: const Text('Arrow Game')),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Round: $round  Level: $level",
                  style: const TextStyle(
                      fontSize: 22, color: Color.fromARGB(255, 0, 0, 0))),
              Text("Score: $score  Best: $bestScore",
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 255, 2, 2))),
              Text(
                tapOpposite
                    ? "Tap the OPPOSITE of the middle arrow"
                    : "Tap the SAME as the middle arrow",
                style: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(179, 0, 0, 0)),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: arrows
                    .map((arrow) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            arrow,
                            style: const TextStyle(
                                fontSize: 50,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ))
                    .toList(),
              ),
              Wrap(
                spacing: 20,
                children: [
                  ElevatedButton(
                    onPressed: () => checkAnswer('⬅'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text("⬅", style: TextStyle(fontSize: 30)),
                  ),
                  ElevatedButton(
                    onPressed: () => checkAnswer('➡'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text("➡", style: TextStyle(fontSize: 30)),
                  ),
                ],
              ),
              Text("Time Left: $timeLeft",
                  style: const TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 0, 0, 0))),
            ],
          ),
        ),
      ),
    );
  }
}
