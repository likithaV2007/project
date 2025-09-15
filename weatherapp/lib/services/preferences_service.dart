import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _isDarkModeKey = 'isDarkMode';
  static const String _unitKey = 'unit';
  static const String _favoriteCitiesKey = 'favoriteCities';

  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, value);
  }

  static Future<String> getUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_unitKey) ?? 'metric';
  }

  static Future<void> setUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unitKey, unit);
  }

  static Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteCitiesKey) ?? [];
  }

  static Future<void> addFavoriteCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteCities();
    if (!favorites.contains(city)) {
      favorites.add(city);
      await prefs.setStringList(_favoriteCitiesKey, favorites);
    }
  }

  static Future<void> removeFavoriteCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteCities();
    favorites.remove(city);
    await prefs.setStringList(_favoriteCitiesKey, favorites);
  }
}
