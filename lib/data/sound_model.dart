class Sound {
  final String name;
  final double duration;
  final String previewUrl;

  Sound({
    required this.name,
    required this.duration,
    required this.previewUrl,
  });

  factory Sound.fromJson(Map<String, dynamic> json) {
    final previews = json['previews'];
    if (previews == null || previews['preview-lq-mp3'] == null) {
      throw Exception('Missing preview');
    }

    return Sound(
      name: json['name'] ?? 'Unknown',
      duration: (json['duration'] ?? 0).toDouble(),
      previewUrl: previews['preview-lq-mp3'],
    );
  }
}
