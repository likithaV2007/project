import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather.dart';

class WeatherService {

  static String get _baseUrl => dotenv.env['BASE_URL'] ?? 'https://weather.free.beeceptor.com';

  Future<Weather> getCurrentWeather(String cityName) async {
    final url = '$_baseUrl/weather';
    print('🌐 Calling API: $url');
    
    try {
      final response = await http.get(Uri.parse(url));
      print('📡 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ API Success - Data received!');
        
        // Use API data with fallbacks
        return Weather(
          cityName: data['city'] ?? data['name'] ?? 'API City',
          temperature: (data['temperature'] ?? data['temp'] ?? 25.0).toDouble(),
          description: data['description'] ?? data['weather'] ?? 'Clear sky',
          icon: '02d',
          feelsLike: (data['feels_like'] ?? data['feelslike'] ?? 27.0).toDouble(),
          humidity: data['humidity'] ?? 60,
          windSpeed: (data['wind_speed'] ?? data['wind'] ?? 5.0).toDouble(),
          pressure: data['pressure'] ?? 1015,
          visibility: data['visibility'] ?? 10000,
          sunrise: DateTime.now().subtract(const Duration(hours: 2)),
          sunset: DateTime.now().add(const Duration(hours: 6)),
          airQuality: 2,
          alerts: [],
        );
      } else {
        print('❌ API Error: Status ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Exception: $e');
    }
    
    print('🔄 Using fallback data');
    return _getMockWeather(cityName.isEmpty ? 'Demo City' : cityName);
  }

  dynamic _extractValue(Map<String, dynamic> data, List<String> keys) {
    for (String key in keys) {
      if (data.containsKey(key)) {
        return data[key];
      }
      // Check nested objects
      for (var value in data.values) {
        if (value is Map<String, dynamic> && value.containsKey(key)) {
          return value[key];
        }
      }
    }
    return null;
  }

  Future<Weather> getWeatherByLocation() async {
    return getCurrentWeather('Current Location');
  }

  Future<List<Map<String, dynamic>>> getHourlyForecast() async {
    return List.generate(24, (i) => {
      'time': DateTime.now().add(Duration(hours: i)).millisecondsSinceEpoch,
      'temp': 20 + (i % 10),
      'icon': '02d',
      'humidity': 60 + (i % 20),
    });
  }

  Future<List<Map<String, dynamic>>> getDailyForecast() async {
    return List.generate(7, (i) => {
      'date': DateTime.now().add(Duration(days: i)).millisecondsSinceEpoch,
      'maxTemp': 25 + (i % 5),
      'minTemp': 15 + (i % 5),
      'icon': '02d',
      'description': 'partly cloudy',
    });
  }

  Weather _getMockWeather(String cityName) {
    return Weather(
      cityName: cityName,
      temperature: 22.5,
      description: 'partly cloudy',
      icon: '02d',
      feelsLike: 24.0,
      humidity: 65,
      windSpeed: 3.2,
      pressure: 1013,
      visibility: 10000,
      sunrise: DateTime.now().subtract(const Duration(hours: 2)),
      sunset: DateTime.now().add(const Duration(hours: 6)),
      airQuality: 2,
      alerts: [],
    );
  }
}