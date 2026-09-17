import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // The reference app is portrait-only.
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Match the dark-blue status bar used in the screenshot.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF064A86),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MiniCricketApp());
}

class MiniCricketApp extends StatelessWidget {
  const MiniCricketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Cricket',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Roboto',
      ),
      home: const CricketGamePage(),
    );
  }
}

class CricketGamePage extends StatefulWidget {
  const CricketGamePage({super.key});

  @override
  State<CricketGamePage> createState() => _CricketGamePageState();
}

class _CricketGamePageState extends State<CricketGamePage> {
  static const int _startingBalls = 6;
  static const List<int> _possibleRuns = <int>[1, 2, 3, 4, 6];

  final Random _random = Random();

  int _runs = 0;
  int _balls = _startingBalls;
  int? _lastRuns;

  bool get _inningsFinished => _balls == 0;

  void _bat() {
    if (_inningsFinished) {
      _restart();
      return;
    }

    final int scored = _possibleRuns[_random.nextInt(_possibleRuns.length)];

    setState(() {
      _runs += scored;
      _balls -= 1;
      _lastRuns = scored;
    });
  }

  void _restart() {
    setState(() {
      _runs = 0;
      _balls = _startingBalls;
      _lastRuns = null;
    });
  }

  String get _lastRunText {
    final int? score = _lastRuns;
    if (score == null) return '';
    return score == 1 ? '1 Run' : '$score Runs';
  }

  @override
  Widget build(BuildContext context) {
    const Color bodyBlue = Color(0xFF0B82D6);
    const Color appBarBlue = Color(0xFF07559B);
    const Color batButtonBlue = Color(0xFF0756A5);
    const Color restartRed = Color(0xFFE1080A);

    return Scaffold(
      backgroundColor: bodyBlue,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: appBarBlue,
        centerTitle: true,
        title: const Text(
          'Mini Cricket',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Scales gently so the UI stays close to the reference on phones
          // while still fitting smaller emulator sizes.
          final double tileSize = (constraints.maxWidth * 0.29).clamp(92.0, 116.0);
          final double gap = (constraints.maxWidth * 0.07).clamp(18.0, 28.0);
          final double topGap = (constraints.maxHeight * 0.245).clamp(90.0, 145.0);

          return SizedBox.expand(
            child: Column(
              children: <Widget>[
                SizedBox(height: topGap),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _PictureTile(
                      key: const Key('bat_image'),
                      assetPath: 'assets/images/bat.png',
                      size: tileSize,
                    ),
                    SizedBox(width: gap),
                    _PictureTile(
                      key: const Key('ball_image'),
                      assetPath: 'assets/images/ball.png',
                      size: tileSize,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: tileSize * 2 + gap,
                  child: const Row(
                    children: <Widget>[
                      Expanded(child: _ScoreLabel('Runs')),
                      Expanded(child: _ScoreLabel('Balls')),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: tileSize * 2 + gap,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _ScoreValue(
                          key: const Key('runs_value'),
                          value: '$_runs',
                        ),
                      ),
                      Expanded(
                        child: _ScoreValue(
                          key: const Key('balls_value'),
                          value: '$_balls',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 20,
                  child: Text(
                    _lastRunText,
                    key: const Key('last_run_text'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  key: const Key('bat_restart_button'),
                  onPressed: _bat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _inningsFinished ? restartRed : batButtonBlue,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: Text(
                    _inningsFinished ? 'Restart' : 'Bat',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PictureTile extends StatelessWidget {
  const _PictureTile({
    super.key,
    required this.assetPath,
    required this.size,
  });

  final String assetPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

class _ScoreLabel extends StatelessWidget {
  const _ScoreLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ScoreValue extends StatelessWidget {
  const _ScoreValue({
    super.key,
    required this.value,
  });

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 27,
        height: 1.05,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
