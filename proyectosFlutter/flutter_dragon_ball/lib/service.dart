// character_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'characters.dart';

class CharacterService {
  final String listApiUrl = 'https://dragonball-api.com/api/characters';
  final String detailBaseUrl = 'https://dragonball-api.com/api/characters';

  final String planetListApiUrl = 'https://dragonball-api.com/api/planets';
  final String planetDetailBaseUrl = 'https://dragonball-api.com/api/planets';

  Future<List<Character>> getCharacters() async {
    final url = Uri.parse('$listApiUrl?limit=500');
    final response = await http.get(url);

    final jsonBody = jsonDecode(response.body);
    final List<dynamic> results = jsonBody['items'] ?? [];
    return results.map((e) => Character.fromJson(e)).toList();
  }

  Future<Character> getCharacterDetails(int id) async {
    final url = Uri.parse('$detailBaseUrl/$id');
    final response = await http.get(url);

    final jsonBody = jsonDecode(response.body);
    return Character.fromJson(jsonBody as Map<String, dynamic>);
  }

  Future<List<OriginPlanet>> getPlanets() async {
    final url = Uri.parse('$planetListApiUrl?limit=500');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> results = jsonBody['items'] ?? [];

      return results.map((e) => OriginPlanet.fromJson(e)).toList();
    } else {
      throw Exception(
        'Error al cargar la lista de planetas: ${response.statusCode}',
      );
    }
  }

  Future<OriginPlanet> getPlanetDetails(int id) async {
    final url = Uri.parse('$planetDetailBaseUrl/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return OriginPlanet.fromJson(jsonBody as Map<String, dynamic>);
    } else {
      throw Exception(
        'Error al cargar detalles del planeta $id: ${response.statusCode}',
      );
    }
  }
}
