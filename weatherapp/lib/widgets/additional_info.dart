import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather.dart';

class AdditionalInfoWidget extends StatelessWidget {
  final Weather weather;

  const AdditionalInfoWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSunriseSunsetCard(context),
        const SizedBox(height: 16),
        _buildAirQualityCard(context),
        if (weather.alerts.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildAlertsCard(context),
        ],
      ],
    );
  }

  Widget _buildSunriseSunsetCard(BuildContext context) {
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
                  child: _buildSunMoonItem(
                    context,
                    Icons.wb_sunny,
                    'Sunrise',
                    DateFormat('HH:mm').format(weather.sunrise),
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildSunMoonItem(
                    context,
                    Icons.brightness_3,
                    'Sunset',
                    DateFormat('HH:mm').format(weather.sunset),
                    Colors.indigo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSunMoonItem(
    BuildContext context,
    IconData icon,
    String label,
    String time,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Text(
          time,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAirQualityCard(BuildContext context) {
    final qualityText = _getAirQualityText(weather.airQuality);
    final qualityColor = _getAirQualityColor(weather.airQuality);

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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                weather.airQuality.toString(),
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

  Widget _buildAlertsCard(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text(
                  'Weather Alerts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...weather.alerts.map(
              (alert) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  alert,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.orange.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAirQualityText(int quality) {
    switch (quality) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }

  Color _getAirQualityColor(int quality) {
    switch (quality) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
