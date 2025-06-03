import 'package:flutter/material.dart';
import 'sound_list_screen.dart'; // Adjust import path to your sound list screen

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _useTiltTrigger = true; // Toggle switch state
  double _sensitivityX = 0.5;  // Slider initial value for X
  double _sensitivityY = 0.5;  // Slider initial value for Y

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle switch row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trigger Mode',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Switch(
                  value: _useTiltTrigger,
                  onChanged: (value) {
                    setState(() {
                      _useTiltTrigger = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sensitivity X slider
            Text(
              'Gyroscope Sensitivity X',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Slider(
              value: _sensitivityX,
              min: 0,
              max: 1,
              divisions: 20,
              label: _sensitivityX.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  _sensitivityX = value;
                });
              },
            ),

            // Sensitivity Y slider
            Text(
              'Gyroscope Sensitivity Y',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Slider(
              value: _sensitivityY,
              min: 0,
              max: 1,
              divisions: 20,
              label: _sensitivityY.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  _sensitivityY = value;
                });
              },
            ),

            const SizedBox(height: 40),

            // Button to open sound selection screen
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.volume_up_rounded),
                label: const Text('More Sounds',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SoundListScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}