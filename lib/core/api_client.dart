import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/sound_model.dart';

class FreesoundApiClient {
  final String _apiKey = 'KD9OlFxBX3fvSOteFGrNcUKk0UebDUdGh4xz1ELZ	'; // 🔐 Replace this
  final String _baseUrl = 'https://freesound.org/apiv2';

  Future<List<Sound>> searchSounds(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search/text/?query=$query'),
      headers: {
        'Authorization': 'Token $_apiKey',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => Sound.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sounds');
    }
  }
}
