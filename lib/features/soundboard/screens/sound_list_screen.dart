import 'package:flutter/material.dart';
import '../../../core/api_client.dart';
import '../../../data/sound_model.dart';

class SoundListScreen extends StatefulWidget {
  const SoundListScreen({super.key});

  @override
  State<SoundListScreen> createState() => _SoundListScreenState();
}

class _SoundListScreenState extends State<SoundListScreen> {
  final _apiClient = FreesoundApiClient();
  late Future<List<Sound>> _futureSounds;

  @override
  void initState() {
    super.initState();
    _futureSounds = _apiClient.searchSounds('query');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sound Results')),
      body: FutureBuilder<List<Sound>>(
        future: _futureSounds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Results Found.'));
          }

          final sounds = snapshot.data!;
          return ListView.builder(
            itemCount: sounds.length,
            itemBuilder: (context, index) {
              final sound = sounds[index];
              return ListTile(
                title: Text(sound.name),
                subtitle: Text('${sound.duration.toStringAsFixed(1)} sec'),
                trailing: Icon(Icons.play_arrow),
                onTap: () {
                  //TODO: Hook up playback here
                },
              );
            },
          );
        },
      ),
    );
  }
}