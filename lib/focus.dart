import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArrowGamePage extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
    loadBestScore();
    startTurn();
  }

  void loadBestScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bestScore = prefs.getInt('bestScore') ?? 0;
    });
  }

  void saveBestScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('bestScore', bestScore);
  }

  void startTurn() {
    timer?.cancel();
    generateArrows();
    timeLeft = 6;
    timer = Timer.periodic(Duration(seconds: 1), (t) {
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
    String middle = arrows[2];
    String correct = tapOpposite ? (middle == '⬅' ? '➡' : '⬅') : middle;

    if (tapped == correct) {
      score++;
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
        title: Text("Oops!", style: TextStyle(color: Colors.white)),
        content: Text(
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
            child: Text("Retry Level", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                nextTurn(); // Continue to next level
              });
            },
            child: Text("Continue", style: TextStyle(color: Colors.green)),
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
        backgroundColor: Colors.grey[900],
        title: Text("Game Over", style: TextStyle(color: Colors.white)),
        content: Text(
          "Your score: $score",
          style: TextStyle(color: Colors.white70),
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
            child: Text("Restart", style: TextStyle(color: Colors.blue)),
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
    return Scaffold(
      backgroundColor: Colors.black, // black background
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Round: $round  Level: $level",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            Text(
              "Score: $score  Best: $bestScore",
              style: TextStyle(fontSize: 20, color: Colors.yellow),
            ),
            Text(
              tapOpposite
                  ? "Tap the OPPOSITE of the middle arrow"
                  : "Tap the SAME as the middle arrow",
              style: TextStyle(fontSize: 18, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: arrows
                  .map((arrow) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          arrow,
                          style: TextStyle(fontSize: 50, color: Colors.white),
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
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text("⬅", style: TextStyle(fontSize: 30)),
                ),
                ElevatedButton(
                  onPressed: () => checkAnswer('➡'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text("➡", style: TextStyle(fontSize: 30)),
                ),
              ],
            ),
            Text(
              "Time Left: $timeLeft",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
