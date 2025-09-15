import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifications/notification_screen.dart';
import 'package:workmanager/workmanager.dart';

class NotificationRepository {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'Channel_id',
    'Channel_title',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  static Future<void> initialize() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload);
      },
    );

    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  }

  static void _handleNotificationTap(String? payload) {
    debugPrint('Notification tapped. Payload: $payload');
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'Channel_id',
        'Channel_title',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required int seconds,
    String? payload,
  }) async {
    await Workmanager().registerOneOffTask(
      "notification_task_${DateTime.now().millisecondsSinceEpoch}",
      "showNotification",
      initialDelay: Duration(seconds: seconds),
      inputData: {
        'title': title,
        'body': body,
        'payload': payload ?? '',
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await NotificationRepository.initialize();

  // Check if app was launched by tapping a notification when terminated
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await NotificationRepository.flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();

  String? payloadFromTerminated;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    final NotificationResponse? response =
        notificationAppLaunchDetails!.notificationResponse;
    payloadFromTerminated = response?.payload;
  }

  runApp(MyApp(initialPayload: payloadFromTerminated));
}

class MyApp extends StatelessWidget {
  final String? initialPayload;

  const MyApp({Key? key, this.initialPayload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You can use initialPayload to decide which screen to show first
    return MaterialApp(
      title: 'Notification Demo',
      home: HomeScreen(initialPayload: initialPayload),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String? initialPayload;
  const HomeScreen({Key? key, this.initialPayload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (initialPayload != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Launched from Notification'),
            content: Text('Payload: $initialPayload'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }

    return const NotificationScreen();
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "showNotification") {
      final plugin = FlutterLocalNotificationsPlugin();
      
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'Channel_id',
        'Channel_title',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        playSound: true,
      );
      
      await plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );
      
      await plugin.initialize(initializationSettings);
      
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'Channel_id',
          'Channel_title',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
        ),
      );
      
      await plugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        inputData?['title'] ?? 'Background Notification',
        inputData?['body'] ?? 'This works in terminated state',
        notificationDetails,
        payload: inputData?['payload'],
      );
    }
    return Future.value(true);
  });
}