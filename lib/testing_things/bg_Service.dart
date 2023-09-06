
import 'dart:ui';

import 'package:file_transfer/shared/operations.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:file_transfer/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      autoStartOnBoot: true,
      isForegroundMode: false,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(),
  );

  service.startService();
}



@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  Shared.preferences = preferences;
  Shared.fetchTasks();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      theMagic();
      print("invoked: forground");
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      theMagic();
      print("invoked: background");
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  
  // // bring to foreground
  // Timer.periodic(const Duration(seconds: 1), (timer) async {
  //   if (service is AndroidServiceInstance) {
  //     if (await service.isForegroundService()) {
        
  //       // flutterLocalNotificationsPlugin.show(
  //       //   888,
  //       //   'File Transfer',
  //       //   'Always running in the background ${DateTime.now()}',
  //       //   const NotificationDetails(
  //       //     android: AndroidNotificationDetails(
  //       //       'my_foreground',
  //       //       'MY FOREGROUND SERVICE',
  //       //       icon: 'ic_bg_service_small',
  //       //       ongoing: true,
  //       //     ),
  //       //   ),
  //       // );
  //     }
  //   }

  //   print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
  //   Operations.theMagic();

  //   // service.invoke(
  //   //   'update',
  //   //   {
  //   //     "current_date": DateTime.now().toIso8601String(),
  //   //     "device": "device",
  //   //   },
  //   // );
  // });
}
