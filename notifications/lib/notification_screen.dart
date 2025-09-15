import 'package:flutter/material.dart';
import 'package:notifications/notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await NotificationRepository.showNotification(
                  title: 'Instant Notification',
                  body: 'This is an instant message',
                );
              },
              child: const Text('Show Instant Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await NotificationRepository.scheduleNotification(
                  title: 'Background Notification',
                  body: 'This works in background and terminated state',
                  seconds: 5,
                );
                debugPrint("schedule notification");
              },
              child: const Text('Schedule Background Notification'),
            ),
          ],
        ),
      ),
    );
  }
}