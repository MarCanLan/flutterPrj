import 'package:shared_preferences/shared_preferences.dart';

class RatingService {
  static const String _ratingKeyPrefix = 'character_rating';

  Future<int> getCharacterRating(int characterId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = '$_ratingKeyPrefix$characterId';
    return prefs.getInt(key) ?? 0;
  }

  Future<void> saveCharacterRating(int characterId, int rating) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = '$_ratingKeyPrefix$characterId';
    // Aseguramos que la valoración esté entre 0 y 10 antes de guardar.
    final validRating = rating.clamp(0, 10);
    await prefs.setInt(key, validRating);
  }
}
