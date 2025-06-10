import 'sound_model.dart';

class SoundAssignmentManager {
  static final List<Sound?> _assignedSounds = List.filled(4, null);

  static void assignSoundToButton(Sound sound, int index) {
    if (index >= 0 && index < 4) {
      _assignedSounds[index] = sound;
    }
  }

  static Sound? getSoundForButton(int index) {
    if (index >= 0 && index < 4) {
      return _assignedSounds[index];
    }
    return null;
  }

  static List<Sound?> loadAssignments() {
    return _assignedSounds;
  }
}
