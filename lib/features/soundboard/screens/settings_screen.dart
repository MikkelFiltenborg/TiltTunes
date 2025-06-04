import 'package:flutter/material.dart';
import 'package:tile_tunes/data/sound_assignment_manager.dart';
import 'sound_list_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _useTiltTrigger = true; // Toggle Trigger State
  double _sensitivityX = 0.5;  // Initial Value X Slider
  double _sensitivityY = 0.5;  // Initial Value Y Slider

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slide Toggle Row
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

            // X Slider
            Text(
              'Tilt Sensitivity X',
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

            // Y Slider
            Text(
              'Tilt Sensitivity Y',
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

            // More Sounds
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.volume_up_rounded),
                label: const Text('More Sounds',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SoundListScreen(
                        onAssign: (sound, buttonIndex) {
                          SoundAssignmentManager.assignSoundToButton(sound, buttonIndex);
                        },
                      ),
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