# Weather App

A comprehensive Flutter weather application with advanced features and a beautiful, responsive UI.

## ✨ Features

### 🌤️ Weather Information
- **Current Weather**: Real-time weather conditions with detailed metrics
- **Hourly Forecast**: 24-hour weather predictions
- **Weekly Forecast**: 7-day weather outlook
- **Weather Details**: Temperature, humidity, wind speed, pressure, visibility
- **Sunrise & Sunset**: Daily sun times with beautiful icons
- **Air Quality Index**: Real-time air quality monitoring
- **Weather Alerts**: Important weather warnings and notifications

### 🎯 Smart Features
- **GPS Auto-Location**: Automatic current location detection
- **City Search**: Search weather for any city worldwide
- **Favorite Cities**: Save and quickly access favorite locations
- **Unit Switcher**: Toggle between Celsius/Fahrenheit and metric/imperial
- **Offline Caching**: Access weather data even when offline
- **Pull to Refresh**: Easy data refresh with swipe gesture

### 🎨 User Experience
- **Dark/Light Mode**: Automatic theme switching with user preference
- **Clean Responsive UI**: Beautiful design that works on all screen sizes
- **Material 3 Design**: Modern Google Material Design components
- **Smooth Animations**: Fluid transitions and interactions
- **Professional Icons**: Weather-appropriate icons and indicators

## Screenshots

The app features:
- Beautiful weather cards with gradient backgrounds
- Weather icons that match current conditions
- Detailed weather metrics in an organized grid layout
- Professional light theme with blue accent colors

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. For real weather data, get an API key from [OpenWeatherMap](https://openweathermap.org/api)
4. Replace `demo_key` in `lib/services/weather_service.dart` with your API key
5. Run `flutter run` to start the app

## Dependencies

- `http`: For API calls
- `geolocator`: For location services
- `permission_handler`: For handling location permissions

## Architecture

- **Models**: Data structures for weather information
- **Services**: API calls and location services
- **Screens**: Main UI screens
- **Widgets**: Reusable UI components
