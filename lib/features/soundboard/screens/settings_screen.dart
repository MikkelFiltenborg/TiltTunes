import 'package:flutter/material.dart';
import 'package:tilt_tunes/data/sound_assignment_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../assets/palette/app_colors.dart';
import 'sound_list_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _useTiltTrigger = true; // Toggle Trigger State
  double _sensitivityX = 0.5; // Initial Value X Slider
  double _sensitivityY = 0.5; // Initial Value Y Slider

  void _loadSettings() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      _useTiltTrigger = preferences.getBool('useTiltTrigger') ?? true;
      _sensitivityX = preferences.getDouble('sensitivityX') ?? 0.5;
      _sensitivityY = preferences.getDouble('sensitivityY') ?? 0.5;
    });
  }

  void _saveSettings() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool('useTiltTrigger', _useTiltTrigger);
    preferences.setDouble('sensitivityX', _sensitivityX);
    preferences.setDouble('sensitivityY', _sensitivityY);
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.mintGreen,),
        ),
        centerTitle: true,
        backgroundColor: AppColors.darkBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.mutedWhite,
          onPressed: () {
            _saveSettings();
            Navigator.pop(context, {
              'useTilt': _useTiltTrigger,
              'sensitivityX': _sensitivityX,
              'sensitivityY': _sensitivityY,
            });
          },
        ),
      ),
      body: Container(
        color: AppColors.darkBackground,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trigger Mode',
                    style: TextStyle( fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.mutedWhite,),
                  ),
                  Switch(
                    value: _useTiltTrigger,
                    activeColor: AppColors.lightEmerald,
                    inactiveThumbColor: AppColors.darkEmerald,
                    onChanged: (value) {
                      setState(() {
                        _useTiltTrigger = value;
                      });
                      _saveSettings();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // X Slider
              Text(
                'Tilt Sensitivity X',
                style: const TextStyle( fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.mutedWhite,),
              ),
              Slider(
                value: _sensitivityX,
                min: 0,
                max: 1,
                divisions: 20,
                thumbColor: AppColors.viridianGreen,
                activeColor: AppColors.viridianGreen,
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
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.mutedWhite,),
              ),
              Slider(
                value: _sensitivityY,
                min: 0,
                max: 1,
                divisions: 20,
                thumbColor: AppColors.viridianGreen,
                activeColor: AppColors.viridianGreen,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.fernGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: AppColors.mutedWhite,
                  ),
                  label: const Text(
                    'More Sounds',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.mutedWhite,),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SoundListScreen(
                          onAssign: (sound, buttonIndex) {
                            SoundAssignmentManager.assignSoundToButton(
                              sound,
                              buttonIndex,
                            );
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
      ),
    );
  }
}
