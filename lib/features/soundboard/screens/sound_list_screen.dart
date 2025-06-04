import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tile_tunes/data/sound_assignment_manager.dart';
import '../../../core/api_client.dart';
import '../../../data/sound_model.dart';

class SoundListScreen extends StatefulWidget {
  final void Function(Sound sound, int buttonIndex)? onAssign;
  const SoundListScreen({super.key, this.onAssign});

  @override
  _SoundListScreenState createState() => _SoundListScreenState();
}


class _SoundListScreenState extends State<SoundListScreen> {
  final FreesoundApiClient _apiClient = FreesoundApiClient();
  late Future<List<Sound>> _futureSounds;
  final TextEditingController _searchController = TextEditingController(text: '');
  String _currentlyPlayingUrl = '';

  @override
  void initState() {
    super.initState();
    _futureSounds = _apiClient.searchSounds(_searchController.text);
  }

  void _search() {
    setState(() {
      _futureSounds = _apiClient.searchSounds(_searchController.text);
    });
  }

  void _handlePlayPause(String url) async {
    if (_currentlyPlayingUrl == url) {
      await AudioPlayer().stop();
      setState(() => _currentlyPlayingUrl = '');
    } else {
      await AudioPlayer().play(UrlSource(url));
      setState(() => _currentlyPlayingUrl = url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sounds',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search sounds...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Sound>>(
              future: _futureSounds,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No results found.'));
                }

                final sounds = snapshot.data!;
                return ListView.builder(
                  itemCount: sounds.length,
                  itemBuilder: (context, index) {
                    final sound = sounds[index];
                    final isPlaying = sound.previewUrl == _currentlyPlayingUrl;

                    return ListTile(
                      title: Text(sound.name),
                      subtitle: Text('${sound.duration.toStringAsFixed(1)} sec'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(isPlaying ? Icons.stop : Icons.play_circle_outline_rounded),
                            onPressed: () => _handlePlayPause(sound.previewUrl),
                          ),
                          if (widget.onAssign != null)
                            IconButton(
                              icon: Icon(Icons.add),
                              tooltip: 'Assign to Button',
                              onPressed: () => _showAssignDialog(sound)
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAssignDialog(Sound sound) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Assign to Button'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(4, (index) {
              return ListTile(
                title: Text('Button ${index+1}'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  if (widget.onAssign != null) {
                    widget.onAssign!(sound, index);
                  }
                  Navigator.of(context).pop();
                },
              );
            }),
          ),
        );
      },
    );
  }
}