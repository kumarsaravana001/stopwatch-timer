import 'package:flutter/material.dart';
import 'dart:async';

class TimerStopwatchScreen extends StatefulWidget {
  @override
  _TimerStopwatchScreenState createState() => _TimerStopwatchScreenState();
}

class _TimerStopwatchScreenState extends State<TimerStopwatchScreen> {
  bool isTimerScreenVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          isTimerScreenVisible ? 'Timer' : 'Stopwatch',
        )),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isTimerScreenVisible = true;
                  });
                },
                child: const Text('Timer'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isTimerScreenVisible = false;
                  });
                },
                child: const Text('Stopwatch'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isTimerScreenVisible ? TimerScreen() : StopwatchScreen(),
          ),
        ],
      ),
    );
  }
}

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  late Timer _timer;
  bool isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  double adjustedDelta = details.delta.dy * 0.3;
                  setState(() {
                    if (adjustedDelta > 0 && hours > 0) {
                      hours--;
                    } else if (adjustedDelta < 0 && hours < 24) {
                      hours++;
                    }
                  });
                },
                child: Text(
                  "${hours.toString().padLeft(2, '0')}:",
                  style: const TextStyle(fontSize: 48),
                ),
              ),
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    if (details.delta.dy > 0 && minutes > 0) {
                      minutes--;
                    } else if (details.delta.dy < 0 && minutes < 59) {
                      minutes++;
                    }
                  });
                },
                child: Text(
                  "${minutes.toString().padLeft(2, '0')}:",
                  style: const TextStyle(fontSize: 48),
                ),
              ),
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    if (details.delta.dy > 0 && seconds > 0) {
                      seconds--;
                    } else if (details.delta.dy < 0 && seconds < 59) {
                      seconds++;
                    }
                  });
                },
                child: Text(
                  "${seconds.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 48),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  if (!isRunning) {
                    startTimer();
                  } else {
                    stopTimer();
                  }
                },
                child: Text(isRunning ? 'Stop' : 'Start'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  resetTimer();
                },
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void startTimer() {
    int totalSeconds = hours * 3600 + minutes * 60 + seconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (totalSeconds > 0) {
        setState(() {
          totalSeconds--;
          hours = totalSeconds ~/ 3600;
          minutes = (totalSeconds % 3600) ~/ 60;
          seconds = totalSeconds % 60;
        });
      } else {
        _timer.cancel();
        // Show a popup when the timer reaches 00:00:00
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Timer Finished'),
              content: const Text('The timer has reached 00:00:00.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });

    setState(() {
      isRunning = true;
    });
  }

  void stopTimer() {
    _timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    _timer.cancel();
    setState(() {
      hours = 0;
      minutes = 0;
      seconds = 0;
      isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class StopwatchScreen extends StatefulWidget {
  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  int secondsElapsed = 0;
  bool isRunning = false;
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatTime(secondsElapsed),
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isRunning ? stopStopwatch : startStopwatch,
                child: Text(isRunning ? 'Stop' : 'Start'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: resetStopwatch,
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void startStopwatch() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
    setState(() {
      isRunning = true;
    });
  }

  void stopStopwatch() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetStopwatch() {
    timer.cancel();
    setState(() {
      secondsElapsed = 0;
      isRunning = false;
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
