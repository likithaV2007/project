import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../services/preferences_service.dart';
import '../widgets/weather_card.dart';
import '../widgets/weather_details.dart';

class WeatherScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const WeatherScreen({super.key, required this.onThemeToggle});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _cityController = TextEditingController();
  Weather? _weather;
  List<Map<String, dynamic>> _hourlyForecast = [];
  List<Map<String, dynamic>> _dailyForecast = [];
  List<String> _favorites = [];
  bool _isLoading = false;
  String? _error;
  String _unit = 'metric';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadAllWeatherData();
  }

  Future<void> _loadPreferences() async {
    final unit = await PreferencesService.getUnit();
    final favorites = await PreferencesService.getFavoriteCities();
    setState(() {
      _unit = unit;
      _favorites = favorites;
    });
  }

  Future<void> _loadAllWeatherData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weather = await _weatherService.getWeatherByLocation();
      final hourly = await _weatherService.getHourlyForecast();
      final daily = await _weatherService.getDailyForecast();

      setState(() {
        _weather = weather;
        _hourlyForecast = hourly;
        _dailyForecast = daily;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _searchWeather() async {
    if (_cityController.text.isEmpty) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final weather = await _weatherService.getCurrentWeather(
        _cityController.text,
      );
      final hourly = await _weatherService.getHourlyForecast();
      final daily = await _weatherService.getDailyForecast();
      setState(() {
        _weather = weather;
        _hourlyForecast = hourly;
        _dailyForecast = daily;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _toggleUnit() async {
    final newUnit = _unit == 'metric' ? 'imperial' : 'metric';
    setState(() => _unit = newUnit);
    await PreferencesService.setUnit(newUnit);
  }

  void _addToFavorites() async {
    if (_weather != null) {
      await PreferencesService.addFavoriteCity(_weather!.cityName);
      final favorites = await PreferencesService.getFavoriteCities();
      setState(() => _favorites = favorites);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(_unit == 'metric' ? Icons.thermostat : Icons.ac_unit),
            onPressed: _toggleUnit,
            tooltip: 'Toggle Unit',
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onThemeToggle,
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _loadAllWeatherData,
            tooltip: 'Current Location',
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildWeatherTab() : _buildFavoritesTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'Weather'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherTab() {
    return RefreshIndicator(
      onRefresh: _loadAllWeatherData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),
            if (_isLoading) _buildLoadingWidget(),
            if (_error != null) _buildErrorWidget(),
            if (_weather != null && !_isLoading) ...[
              WeatherCard(weather: _weather!),
              const SizedBox(height: 16),
              _buildHourlyForecast(),
              const SizedBox(height: 16),
              WeatherDetails(weather: _weather!),
              const SizedBox(height: 16),
              _buildSunriseSunset(),
              const SizedBox(height: 16),
              _buildAirQuality(),
              const SizedBox(height: 16),
              _buildDailyForecast(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Favorite Cities',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          if (_favorites.isEmpty)
            const Center(child: Text('No favorite cities added yet'))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _favorites.length,
                itemBuilder: (context, index) {
                  final city = _favorites[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.location_city),
                      title: Text(city),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await PreferencesService.removeFavoriteCity(city);
                          final favorites =
                              await PreferencesService.getFavoriteCities();
                          setState(() => _favorites = favorites);
                        },
                      ),
                      onTap: () {
                        _cityController.text = city;
                        _searchWeather();
                        setState(() => _selectedIndex = 0);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  hintText: 'Enter city name',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (_) => _searchWeather(),
              ),
            ),
            const SizedBox(width: 8),
            if (_weather != null && !_favorites.contains(_weather!.cityName))
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: _addToFavorites,
                tooltip: 'Add to Favorites',
              ),
            ElevatedButton(
              onPressed: _searchWeather,
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyForecast() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hourly Forecast',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _hourlyForecast.length,
                itemBuilder: (context, index) {
                  final forecast = _hourlyForecast[index];
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('HH:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              forecast['time'],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Icon(Icons.wb_cloudy, size: 24),
                        const SizedBox(height: 8),
                        Text(
                          '${forecast['temp']}°',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyForecast() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '7-Day Forecast',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...(_dailyForecast
                .take(7)
                .map(
                  (forecast) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            DateFormat('EEE').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                forecast['date'],
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.wb_cloudy, size: 24),
                        const SizedBox(width: 16),
                        Expanded(child: Text(forecast['description'])),
                        Text(
                          '${forecast['maxTemp']}°/${forecast['minTemp']}°',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSunriseSunset() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sun & Moon',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wb_sunny,
                          color: Colors.orange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Sunrise'),
                      Text(
                        DateFormat(
                          'HH:mm',
                        ).format(_weather?.sunrise ?? DateTime.now()),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.brightness_3,
                          color: Colors.indigo,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Sunset'),
                      Text(
                        DateFormat(
                          'HH:mm',
                        ).format(_weather?.sunset ?? DateTime.now()),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAirQuality() {
    final quality = _weather?.airQuality ?? 2;
    final qualityText = [
      '',
      'Good',
      'Fair',
      'Moderate',
      'Poor',
      'Very Poor',
    ][quality];
    final qualityColor = [
      Colors.grey,
      Colors.green,
      Colors.lightGreen,
      Colors.yellow,
      Colors.orange,
      Colors.red,
    ][quality];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: qualityColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.air, color: qualityColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Air Quality',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    qualityText,
                    style: TextStyle(
                      color: qualityColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: qualityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                quality.toString(),
                style: TextStyle(
                  color: qualityColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading weather data...'),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
            const SizedBox(height: 8),
            Text(
              'Unable to load weather data',
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Please check your internet connection and try again',
              style: TextStyle(color: Colors.red.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
