import 'package:flutter/material.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> soundTitles = [
    'Sound 1', // Button 1 Top
    'Sound 2', // Button 2 Right
    'Sound 3', // Button 3 Bottom
    'Sound 4', // Button 4 Left
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tilt Tunes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
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
              // Button 1 Top
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
                  textPadding: const EdgeInsets.only(top: 75),
                  onTap: () => _onButtonTap(context, 1),
                ),
              ),

              // Button 2 Right
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: width / 2,
                child: _TriangleButton(
                  color: Colors.yellow.shade700,
                  direction: TriangleDirection.left,
                  text: soundTitles[1],
                  textAlign: Alignment.centerRight,
                  textPadding: const EdgeInsets.only(right: 25),
                  onTap: () => _onButtonTap(context, 2),
                ),
              ),

              // Button 3 Bottom
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
                  textPadding: const EdgeInsets.only(bottom: 75),
                  onTap: () => _onButtonTap(context, 3),
                ),
              ),

              // Button 4 Left
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
                  textPadding: const EdgeInsets.only(left: 25),
                  onTap: () => _onButtonTap(context, 4),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onButtonTap(BuildContext context, int buttonNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Button $buttonNumber tapped')),
    );
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
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 2, color: Colors.black45, offset: Offset(1,1))],
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
  bool shouldReclip(_TriangleClipper oldClipper) => oldClipper.direction != direction;
}