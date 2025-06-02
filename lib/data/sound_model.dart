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
    return Sound(
      name: json['name'] ?? 'Unknown',
      duration: (json['duration'] ?? 0).toDouble(),
      previewUrl: json['previews']['preview_hq_mp3'],
    );
  }
}
