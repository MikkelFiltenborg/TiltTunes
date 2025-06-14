import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/sound_model.dart';

class FreesoundApiClient {
  static const String _baseUrl =
      'https://freesound.org/apiv2'; // Freesound.org Api
  final String _apiKey = 'KD9OlFxBX3fvSOteFGrNcUKk0UebDUdGh4xz1ELZ'; // Api Key

  Future<List<Sound>> searchSounds(String query) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/search/text/?query=$query&fields=name,duration,previews',
      ),
      headers: {'Authorization': 'Token $_apiKey'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      return results
          .map((json) {
            try {
              return Sound.fromJson(json);
            } catch (_) {
              return null; // Skips Entries Without Previews
            }
          })
          .where((sound) => sound != null)
          .cast<Sound>()
          .toList();
    } else {
      throw Exception('Failed to load sounds');
    }
  }
}
