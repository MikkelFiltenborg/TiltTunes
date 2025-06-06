import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tile_tunes/data/sound_assignment_manager.dart';
import 'settings_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> soundTitles = [
    'No Sound 1',
    'No Sound 2',
    'No Sound 3',
    'No Sound 4',
  ];

  late StreamSubscription _gyroscopeSubscription;
  bool _useTiltTrigger = true;
  double _xSensitivity = 0.5; // Threshold for x axis
  double _ySensitivity = 0.5; // Threshold for y axis
  bool _canTrigger = true;

  @override
  void initState() {
    super.initState();
    _loadSoundAssignments();
    _startListeningToGyroscope();
  }

  void _loadSoundAssignments() {
    setState(() {
      for (int i = 0; i < 4; i++) {
        final sound = SoundAssignmentManager.getSoundForButton(i);
        soundTitles[i] = sound?.name ?? 'Button ${i + 1}';
      }
    });
  }

  void _startListeningToGyroscope() {
    _gyroscopeSubscription = gyroscopeEventStream().listen((event) {
      if (!_useTiltTrigger || !_canTrigger) return;

      final x = event.x;
      final y = event.y;

      if (y < -_ySensitivity) {
        _triggerButton(0); // Top
      } else if (x < -_xSensitivity) {
        _triggerButton(1); // Right
      } else if (y > _ySensitivity) {
        _triggerButton(2); // Bottom
      } else if (x > _xSensitivity) {
        _triggerButton(3); // Left
      }
    });
  }

  void _triggerButton(int index) {
    _onButtonTap(context, index + 1);
    _canTrigger = false;
    Future.delayed(const Duration(seconds: 1), () {
      _canTrigger = true;
    });
  }

  @override
  void dispose() {
    _gyroscopeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tilt Tunes',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );

              if (result is Map<String, dynamic>) {
                setState(() {
                  _useTiltTrigger = result['useTilt'] ?? true;
                  _xSensitivity = result['sensitivityX'] ?? 1.5;
                  _ySensitivity = result['sensitivityY'] ?? 1.5;
                });
              }
              _loadSoundAssignments();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              // Top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: height / 2,
                child: _TriangleButton(
                  color: Colors.blue,
                  direction: TriangleDirection.down,
                  text: soundTitles[0],
                  textAlign: Alignment.topCenter,
                  textPadding: const EdgeInsets.only(top: 75, left: 50),
                  onTap: () => _onButtonTap(context, 1),
                ),
              ),
              // Right
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: width / 2,
                child: _TriangleButton(
                  color: Colors.yellow,
                  direction: TriangleDirection.left,
                  text: soundTitles[1],
                  textAlign: Alignment.centerRight,
                  textPadding: const EdgeInsets.only(right: 0),
                  onTap: () => _onButtonTap(context, 2),
                ),
              ),
              // Bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: height / 2,
                child: _TriangleButton(
                  color: Colors.red,
                  direction: TriangleDirection.up,
                  text: soundTitles[2],
                  textAlign: Alignment.bottomCenter,
                  textPadding: const EdgeInsets.only(bottom: 75, left: 50),
                  onTap: () => _onButtonTap(context, 3),
                ),
              ),
              // Left
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                width: width / 2,
                child: _TriangleButton(
                  color: Colors.green,
                  direction: TriangleDirection.right,
                  text: soundTitles[3],
                  textAlign: Alignment.centerLeft,
                  textPadding: const EdgeInsets.only(left: 50),
                  onTap: () => _onButtonTap(context, 4),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onButtonTap(BuildContext context, int buttonNumber) async {
    final sound = SoundAssignmentManager.getSoundForButton(buttonNumber - 1);
    if (sound != null) {
      final player = AudioPlayer();
      await player.play(UrlSource(sound.previewUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No sound assigned to Button $buttonNumber')),
      );
    }
  }
}

enum TriangleDirection { up, down, left, right }

class _TriangleButton extends StatelessWidget {
  final Color color;
  final TriangleDirection direction;
  final String text;
  final Alignment textAlign;
  final EdgeInsetsGeometry textPadding;
  final VoidCallback onTap;

  const _TriangleButton({
    required this.color,
    required this.direction,
    required this.text,
    required this.textAlign,
    required this.textPadding,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _TriangleClipper(direction),
      child: Material(
        color: color,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: textPadding,
            child: Align(
              alignment: textAlign,
              child: SizedBox(
                width: 120,
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black45,
                        offset: Offset(1, 1),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  final TriangleDirection direction;

  _TriangleClipper(this.direction);

  @override
  Path getClip(Size size) {
    final path = Path();

    switch (direction) {
      case TriangleDirection.up:
        path.moveTo(0, size.height);
        path.lineTo(size.width / 2, 0);
        path.lineTo(size.width, size.height);
        break;
      case TriangleDirection.down:
        path.moveTo(0, 0);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(size.width, 0);
        break;
      case TriangleDirection.left:
        path.moveTo(size.width, 0);
        path.lineTo(0, size.height / 2);
        path.lineTo(size.width, size.height);
        break;
      case TriangleDirection.right:
        path.moveTo(0, 0);
        path.lineTo(size.width, size.height / 2);
        path.lineTo(0, size.height);
        break;
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(_TriangleClipper oldClipper) =>
      oldClipper.direction != direction;
}