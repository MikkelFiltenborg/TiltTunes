import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../assets/palette/app_colors.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  late Future<List<Sound>> _futureSounds;
  final TextEditingController _searchController = TextEditingController(
    text: '',
  );
  String _currentlyPlayingUrl = '';

  @override
  void initState() {
    super.initState();
    _futureSounds = _apiClient.searchSounds(_searchController.text);
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _currentlyPlayingUrl = '';
      });
    });
  }

  void _search() {
    setState(() {
      _futureSounds = _apiClient.searchSounds(_searchController.text);
    });
  }

  void _handlePlayPause(String url) async {
    if (_currentlyPlayingUrl == url) {
      await _audioPlayer.stop();
      setState(() => _currentlyPlayingUrl = '');
    } else {
      await _audioPlayer.stop(); // stop current if any
      await _audioPlayer.play(UrlSource(url));
      setState(() => _currentlyPlayingUrl = url);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showAssignDialog(Sound sound) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.darkBackground,
          titleTextStyle: const TextStyle(
            color: AppColors.mintGreen,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          title: const Text('Assign to Button'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(4, (index) {
              return ListTile(
                title: Text(
                  'Button ${index + 1}',
                  style: const TextStyle(color: AppColors.mutedWhite),
                ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sounds',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.mintGreen,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.darkBackground,
        iconTheme: const IconThemeData(color: AppColors.mutedWhite),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: AppColors.darkEmerald,
            selectionColor: AppColors.darkEmerald,
            selectionHandleColor: AppColors.lightEmerald,
          ),
        ),
        child: Container(
          color: AppColors.darkBackground,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: AppColors.mutedWhite),
                        decoration: InputDecoration(
                          hintText: 'Search sounds...',
                          hintStyle: const TextStyle(
                            color: AppColors.mutedWhite,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.darkEmerald,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.lightEmerald,
                            ),
                          ),
                        ),
                        onSubmitted: (_) => _search(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      color: AppColors.mutedWhite,
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
                        final isPlaying =
                            sound.previewUrl == _currentlyPlayingUrl;

                        return ListTile(
                          title: Text(sound.name),
                          textColor: AppColors.mutedWhite,
                          subtitle: Text(
                            '${sound.duration.toStringAsFixed(1)} sec',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  isPlaying
                                      ? Icons.stop
                                      : Icons.play_circle_outline_rounded,
                                  color: isPlaying
                                      ? AppColors.mintGreen
                                      : AppColors.fernGreen,
                                ),
                                onPressed: () =>
                                    _handlePlayPause(sound.previewUrl),
                              ),
                              if (widget.onAssign != null)
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: AppColors.fernGreen,
                                  ),
                                  tooltip: 'Assign to Button',
                                  onPressed: () => _showAssignDialog(sound),
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
        ),
      ),
    );
  }
}
